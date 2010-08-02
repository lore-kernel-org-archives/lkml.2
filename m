Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457Ab0HBOIN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 10:08:13 -0400
Received: from www.tglx.de ([62.245.132.106]:38618 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752420Ab0HBOIM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 10:08:12 -0400
Date: Mon, 2 Aug 2010 16:07:41 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Tejun Heo <teheo@suse.de>
cc: lkml <linux-kernel@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>,
        Greg KH <gregkh@suse.de>
Subject: Re: [GIT PULL tip/genirq] Please pull from lost-spurious-irq
In-Reply-To: <4C529F59.3020404@suse.de>
Message-ID: <alpine.LFD.2.00.1008020956080.9198@localhost.localdomain>
References: <4C5033D9.7030800@kernel.org> <4C50349F.7020002@suse.de> <alpine.LFD.2.00.1007291042441.2471@localhost.localdomain> <4C529F59.3020404@suse.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun,

On Fri, 30 Jul 2010, Tejun Heo wrote:

> Hello,
> 
> On 07/29/2010 10:44 AM, Thomas Gleixner wrote:
> >> I'll ask Stephen to pull the above branch into linux-next until it
> >> shows up via tip so that we don't lose any more linux-next testing
> >> time.
> > 
> > I'm working on it already and I'm currently twisting my brain around
> > the problem this patches will impose to the RT stuff, where we cannot
> > access timer_list timers from atomic regions :(
> 
> Oh, I see.  A dull last ditch solution would be just disabling it on
> CONFIG_PREEMPT_RT, but yeah that will be dull.  :-(

Yup, but I have some other issues with this series as well. That thing
is massively overengineered. You mangle all the various functions into
irq_poll which makes it really hard to understand what the code does
under which circumstances.

I understand most of the problems you want to solve, but I don't like
the outcome too much.

Let's look at the various parts:

1) irq polling

   - Get rid of the for_each_irq() loop in the poll timer.

     You can solve this by adding the interrupt to a linked list and
     let the poll timer run through the list. Also why is the simple
     counter based decision not good enough ? Why do we need an extra
     time period for this ?

   - Reenable the interrupt from time to time to check whether the irq
     storm subsided.

     Generally a good idea, but we really do not want to wait for
     another 10k unhandled interrupts flooding the machine. Ideally we
     should read out the irq pending register from the irq chip to see
     whether the interrupt is still asserted.

2) irq watch

   I have to admit, that I have no clue what this thing exactly
   does. After staring into the code for quite a while I came to the
   conclusion that it's a dynamic polling machinery, which adjusts
   it's polling frequency depending on the number of good and bad
   samples. The heuristics for this are completely non obvious.

   Aside of that the watch mechanism adds unneccesary code to the hard
   interrupt context. There is no reason why you need to update that
   watch magic in the hard interrupt context. Analysing the stats can
   be done in the watch timer as well. All it takes is in
   handle_irq_event()

   case IRQ_HANDLED:
      	action->handled++;

   and in the watch timer function

        if (ret == IRQ_HANDLED)
	        action->polled++;

   irq_watch should use a separate global timer and a linked list. The
   timer is started when an interrupt is added to the watch mechanism
   and stopped when the list becomes empty.
   
   That's a clear separation of watch and poll and simplifies the
   whole business a lot.

3) irq expect

   So you basically poll the interrupt until either the interrupt
   happened or the device driver timeout occured.

   That's really weird. What does it solve ? Not running into the
   device driver timeout routine if the hardware interrupt has been
   lost?

   That's overkill, isn't it ? When the hardware loses an interrupt
   occasionally then why isn't the device driver timeout routine
   sufficient? If it does not check whether the device has an
   interrupt pending despite the fact that it has not been delivered,
   then this code needs to be fixed and not worked around with weird
   polling in the generic irq code.

   Btw, this polling is pretty bad in terms of power savings.

   - The timers are not aligned, so if there are several expects armed
     you get unbatched wakeups.

   - If the poll interval is smaller than the average hardware
     interrupt delivery time, you add more wakeups than necessary.

   - If the hardware interrupt has happened, you let the poll timer
     pending, which gives us an extra wakeup for each interrupt in the
     worst case.

   I assume your concern is to detect and deal with flaky interrupts,
   but avoiding the permanent poll when the device is not used, right?

   So that can be done simpler as well. One timer and a linked list
   again.

   expect_irq() adds the irq to the linked list and arms the timer, if
   it is not armed already. unexpect_irq() removes the irq from the
   linked list and deletes the timer when the list becomes empty.

   That can reuse the list_head in irq_desc which you need for irq
   poll and the timer interval should be fixed without dynamic
   adjustment.

   Keep it simple!

Thanks

	 tglx
