Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753077Ab0KHTyv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 14:54:51 -0500
Received: from mail.windriver.com ([147.11.1.11]:48274 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034Ab0KHTyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 14:54:50 -0500
Message-ID: <4CD85575.2080305@windriver.com>
Date: Mon, 08 Nov 2010 13:54:29 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: gregkh@suse.de, USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        kgdb-bugreport@lists.sourceforge.net, Alan Cox <alan@linux.intel.com>,
        Oliver Neukum <oliver@neukum.org>
Subject: Re: [RFC PATCH 1/5] usb-hcd: implement polling a specific usb device
References: <Pine.LNX.4.44L0.1011081355050.1340-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1011081355050.1340-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Nov 2010 19:54:31.0417 (UTC) FILETIME=[C2649690:01CB7F7E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08/2010 01:19 PM, Alan Stern wrote:
> On Mon, 8 Nov 2010, Jason Wessel wrote:
> 
>>>> +static void usb_poll_irq_flush_helper(struct work_struct *dummy)
>>>> +{
>>>> +	struct urb *urb;
>>>> +	struct urb *scratch;
>>>> +	unsigned long flags;
>>>> +
>>>> +	mutex_lock(&usb_poll_irq_flush_mutex);
>>> What is this mutex used for?
>>
>> This mutex exists because I did not see a way to create a static
>> workqueue with the attribute WQ_NON_REENTRANT.  When the workqueue
>> does not have this attribute there is a corner case that between two
>> usb poll intervals (one being handled on cpu 0 and the next on cpu 1)
>> that you can get two units of work to run concurrently.
> 
> So this reduces to the more fundamental question of why you need to use 
> a workqueue in the first place.
>
[clip]
>
> The queue should be drained just before you exit the debugger.


I think this is the key issue here.  There is no debugger running.
The context of kdb has nothing to do with this patch.

In this case the input source was printk() constantly calling the usb
serial console write until there are no more kfifo buffers left and we
need to poll the usb hcd to push some of the data out.

The easiest example is to look at what happens when you set
console=ttyUSB0,115200 as a kernel boot argument.  

irq's off
  console_register(with usb device) {
    loop() {
       write_all_console_boot_log_so_far()
    }
  }
irq's on
... more printk's ...

It is not obvious where another good place exists to drain the queue.
You mentioned before interrupts are restored, but I don't see how we
can do that in this case without putting lots of other hook points or
potentially adding to the hot path of irq restore (which is obviously
a no-no).

What about another option?  Perhaps we drain the queue the next time
the HCD runs when it is not in the polling context?  If we do that,
then we can possibly eliminate the poll schedule all together, but I
believe there is a corner case where if you do not receive any irq
events for a while the queued urb completions hang in limbo.

> 
>> The "schedule later via a workqueue" seemed the path of least
>> resistance.
>>
>> You could argue that we might have a user of this API that would want
>> to flush the delayed urb queue in a safe place.  For now though, the
>> two users of the new poll API (kdb, and usb serial console) do not
>> need it and this leads me to believe we would be best served to not
>> export the flush helper.
> 
> Why should usb serial console need to use the queue?
> 
> Let's put it this way: Your polling mechanism has conflated two 
> separate issues.  The matter of polling the host controller driver is 
> distinct from the question of which URBs to stick on the queue.
> 
> While kdb is running, it makes sense to give back only the URBs that 
> are for the console device.  But if you are polling during the normal 
> operation of printk and the usb serial console, then there's no reason 
> not to give back all the URBs that complete during polling.
> 

That is an interesting way to look at things...  You metioned I
conflated to issues, but in my mind they were the same (kdb vs printk
requiremetns).  I just figured we should do the minimum possible when
trying to exec a printk() because we want it to be as reliable as
possible.  I had the following example in mind where a usb camera
driver executes a pile of printk()'s and the poll kicks in, we would
only like the completion handler to run for the usb serial device and
to defer the rest.

> In other words, usb_poll_irq() doesn't need to set or clear
> usb_poll_hcd_device.  (Incidentally, that's not a very good name -- I'd 
> change to it usb_poll_device.)

Seems resonable to me.  Its life has changed a bit since we originally
started talking about it.

> Instead, set that pointer when you enter the debugger and clear it
> when you leave the debugger, at which time you can drain the queue.

In the kdb keyboard patch we already have such a place we can do this,
and that is where the schedule logic occurs.  The other reason I opted
for the scheduling vs running it before kernel execution is completely
resumed is on the off chance something has other locks or mutexes
required by another cpu.

What about the printk() case though?  My argument for queuing and
scheduling was to minimize the ability that printk() will get deferred
by something else.


Thanks,
Jason.
