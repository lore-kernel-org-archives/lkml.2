Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753777Ab1HAR1J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 13:27:09 -0400
Received: from mail.windriver.com ([147.11.1.11]:63321 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753653Ab1HAR05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 13:26:57 -0400
Message-ID: <4E36E19B.20207@windriver.com>
Date: Mon, 1 Aug 2011 12:25:47 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Remy Bohmer <linux@bohmer.net>
CC: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: threaded interrupt handlers: what if hardirq part not disables
 device interrupt?
References: <CANqCtQ+9ab1qt0WzuC6n6gX9Y8XNcDxaTosUBc94eecj0umuiQ@mail.gmail.com> <1312202678.2617.460.camel@laptop>
In-Reply-To: <1312202678.2617.460.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2011 07:44 AM, Peter Zijlstra wrote:
> On Sun, 2011-07-31 at 16:15 +0200, Remy Bohmer wrote:
>> As alternative solution I can do the following as well:
>> The driver now has a tasklet used for processing the queue. If I add
>> IRQF_NO_THREAD as irq-flag, the thread is not created and the handler
>> runs completely in hard-irq context. This seems to work okay, but it
>> does not feel as the right solution.
>>
>> How is this supposed to work? Do you have better ideas how to solve
>> situations like this? 
> This sounds like the total trainwreck known as tty/console, I believe
> jwessel and tglx had some ideas on that. Maybe Jason can share what he
> knows, I'm not up to speed on that issue.
>
>

I talked with Thomas a bit about this last week.  While we did not talk specifically about implementation details we agree on the top level problem.  Talking to the serial hardware for any reason in an atomic context (as you often might do with printk) is simply forbidden, and yet we really want any kind critical messages, when taking an oops or using the kernel debugger to be able to be emitted from the serial port.  Design wise these goals couldn't be further apart.

The infrastructure we have in the kernel today for the serial console and tty plumbing simply does not meet both needs.  The discussion went on to conclude that for the normal mode of operation a serial HW driver should be structured to put everything into a queue for deferred work using a worker thread.  The hard IRQ context would make use of a kfifo if needed.   In terms of the oops / kernel debug path we already have some plumbing for the CONSOLE_POLL interface where we can directly read/write to the serial hardware and effectively don't care how much latency or time is lost in between.   The general idea would be to make this interface a required part of the change so we could have low latency operation as well as "don't care about latency" operation.

All that being said, I am not sure it actually answers the original problem of the atmel driver.  It seems to me that the driver needs to change just a bit with the same sort of principle in mind.  We have a kfifo implementation in the kernel that is generic and employed by many of the USB serial devices today.  It would seem that the logical approach to your immediate problem would be to use the kfifo and schedule the work without a tasklet and instead use the workqueue interface to either stick work on the default queue or make use of a separate queue specific to the atmel HW.  This approach should allow for the maximum preemption and in theory the lowest latency at the expense of some scheduling overhead as is to be expected for the price of using the RT kernel.

Jason.
