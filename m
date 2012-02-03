Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756063Ab2BCUBq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 15:01:46 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58563 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755084Ab2BCUBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 15:01:45 -0500
Message-ID: <4F2C3D25.8040909@mvista.com>
Date: Fri, 03 Feb 2012 14:01:41 -0600
From: Corey Minyard <cminyard@mvista.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111109 Thunderbird/3.1.16
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>
Subject: Re: [PATCH 3/6] ipmi: use a tasklet for handling received messages
References: <1328284079-5489-1-git-send-email-cminyard@mvista.com>	<1328284079-5489-3-git-send-email-cminyard@mvista.com> <20120203114414.0f9ae99a.akpm@linux-foundation.org>
In-Reply-To: <20120203114414.0f9ae99a.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/2012 01:44 PM, Andrew Morton wrote:
> On Fri, 03 Feb 2012 09:47:56 -0600
> Corey Minyard<cminyard@mvista.com>  wrote:
>
>> The IPMI driver would release a lock, deliver a message, then relock.
>> This is obviously ugly, and this patch converts the message handler
>> interface to use a tasklet to schedule work.  This lets the receive
>> handler be called from an interrupt handler with interrupts enabled.
>>
>> ...
>>
>> +/*
>> + * If there are messages in the queue or pretimeouts, handle them.
>> + */
>> +static void handle_new_recv_msgs(ipmi_smi_t intf)
>> +{
>> +	struct ipmi_smi_msg  *smi_msg;
>> +	unsigned long        flags = 0;
>> +	int                  rv;
>> +	int                  run_to_completion = intf->run_to_completion;
>> +
>> +	/* See if any waiting messages need to be processed. */
>> +	if (!run_to_completion)
>> +		spin_lock_irqsave(&intf->waiting_msgs_lock, flags);
>> +	while (!list_empty(&intf->waiting_msgs)) {
>> +		smi_msg = list_entry(intf->waiting_msgs.next,
>> +				     struct ipmi_smi_msg, link);
>> +		list_del(&smi_msg->link);
>> +		if (!run_to_completion)
>> +			spin_unlock_irqrestore(&intf->waiting_msgs_lock, flags);
> Yikes, what's going on here?  How is the list protected if the spinlock
> isn't taken?
>
> I went to the comment over ipmi_smi.run_to_completion but it doesn't
> explain how it governs the locking strategy at all.  If there's some
> other way in which the reader is supposed to grok IPMI locking, please
> clue me in ;)
>
The "run_to_completion" mode is designed to run at panic time so that 
the watchdog timer can be extended and panic information can be stored 
in the IPMI event log.  In that case locks are irrelevant and can cause 
hangs, so they are skipped.

This is documented a little better in ipmi_si_intf.c, but you are right, 
it's not terribly complete.

-corey
