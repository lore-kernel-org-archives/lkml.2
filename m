Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386Ab0KHP6j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 10:58:39 -0500
Received: from mail.windriver.com ([147.11.1.11]:60848 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753022Ab0KHP6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 10:58:38 -0500
Message-ID: <4CD81E21.8040100@windriver.com>
Date: Mon, 08 Nov 2010 09:58:25 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: gregkh@suse.de, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        kgdb-bugreport@lists.sourceforge.net
Subject: Re: [RFC PATCH 2/5] usb-serial-console: try to poll the hcd vs dropping
 data
References: <Pine.LNX.4.44L0.1011061432410.28403-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1011061432410.28403-100000@netrider.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Nov 2010 15:58:26.0817 (UTC) FILETIME=[C7A22710:01CB7F5D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2010 01:39 PM, Alan Stern wrote:
> On Fri, 5 Nov 2010, Jason Wessel wrote:
> 
>> This patch tries to solve the problem that printk data is dropped
>> because there are too many outstanding transmit urb's while trying to
>> execute printk's to a console.  You can observe this by booting a
>> kernel with a serial console and cross checking the dmesg output with
>> what you received on the console or doing something like
>> "echo t > /proc/sysrq-trigger".
>>
>> This patch takes the route of forcibly polling the hcd device to drain
>> the urb queue in order to initiate the bulk write call backs.
>>
>> A few millisecond penalty will get incurred to allow the hcd
>> controller to complete a write urb, else the console data is thrown
>> away.  Even with any kind of delay, the latency is still lower than
>> using a traditional serial port uart due to the fact that there are
>> bigger buffer for use with the USB serial console kfifo
>> implementation.
> 
>> --- a/drivers/usb/serial/console.c
>> +++ b/drivers/usb/serial/console.c
>> @@ -197,13 +197,37 @@ static int usb_console_setup(struct console *co, char *options)
>>  	return retval;
>>  }
>>  
>> +static void usb_do_console_write(struct usb_serial *serial,
>> +				 struct usb_serial_port *port,
>> +				 const char *buf, unsigned count)
>> +{
>> +	int retval;
>> +	int loops = 100;
>> +try_again:
>> +	/* pass on to the driver specific version of this function if
>> +	   it is available */
>> +	if (serial->type->write)
>> +		retval = serial->type->write(NULL, port, buf, count);
>> +	else
>> +		retval = usb_serial_generic_write(NULL, port, buf, count);
>> +	if (retval < count && retval >= 0 && loops--) {
>> +		/* poll the hcd device because the queue is full */
> 
> In fact you can call the poll routine on every iteration.  Only the 
> udelay needs to wait for the queue to be full.


I figured it would be best to sleep a bit but if you feel we should be
able to poll every time we could go with a udelay(1) and loops =
10000, or udelay(10) and loops(1000).


> 
>> +		count -= retval;
>> +		buf += retval;
>> +		udelay(100);
>> +		usb_poll_irq(serial->dev);
>> +		usb_poll_irq_schedule_flush();
> 
> I don't understand this at all.  What's the point of adding the whole
> delayed_usb_complete_queue mechanism if you flush the queue as soon as
> some URBs are added to it?  Why not just let them complete normally
> during the usb_poll_irq call?
> 

The schedule function schedules the work for outside this context and
just leaves one unit of work waiting for a later point.

> I thought the whole idea was that you didn't want extraneous URBs to 
> complete while the KDB debugger was running.  This means that you 
> shouldn't call usb_poll_irq_schedule_flush until the debugger is ready 
> to go back to running the main kernel.


This really has nothing to do with kdb/kgdb.  This is purely for the
usb serial console and printk().  In the case of the kdb keyboard
handler, yes it schedules the flush just before resuming the kernel.

I attempted to explain the need to schedule/defer the work of flushing
the urb completion queue in response to your comments about the usb
poll api calls.


There is another series of experimental patches in my backlog for
implementing kgdb/kdb over USB serial, but numerous issues still exist
and will keep that development off for some time to the future:

  * complete the USB hcd polling API (this series)
  * usb serial console can push buffers when KFIFO's are full (this series)
  * Extensions for CONSOLE_POLL for usb serial implemented
  * sysrq as a tasklet (don't run the sysrq while holding the hcd locks)
  * Some new code to attempt to run any hcd threads (to get out of locks)
    on entry to the debug core

Jason.
