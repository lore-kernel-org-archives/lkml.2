Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487Ab2CLLir (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 07:38:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752393Ab2CLLip (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 07:38:45 -0400
Date: Mon, 12 Mar 2012 12:38:31 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] genirq: Get rid of unnecessary IRQTF_DIED flag
Message-ID: <20120312113830.GA2390@dhcp-26-207.brq.redhat.com>
References: <20120309135958.GD2114@dhcp-26-207.brq.redhat.com>
 <20120309150612.GA7353@redhat.com>
 <alpine.LFD.2.02.1203091716260.2742@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1203091716260.2742@ionos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 09, 2012 at 05:17:16PM +0100, Thomas Gleixner wrote:
> On Fri, 9 Mar 2012, Oleg Nesterov wrote:
> 
> > Of course I can't ack this, but afaics the whole series looks fine.
> > 
> > Only one minor nit,
> > 
> > On 03/09, Alexander Gordeev wrote:
> > >
> > > --- a/kernel/irq/handle.c
> > > +++ b/kernel/irq/handle.c
> > > @@ -60,8 +60,8 @@ static void irq_wake_thread(struct irq_desc *desc, struct irqaction *action)
> > >  	 * device interrupt, so no irq storm is lurking. If the
> > >  	 * RUNTHREAD bit is already set, nothing to do.
> > >  	 */
> > > -	if (test_bit(IRQTF_DIED, &action->thread_flags) ||
> > > -	    test_and_set_bit(IRQTF_RUNTHREAD, &action->thread_flags))
> > > +	if (test_and_set_bit(IRQTF_RUNTHREAD, &action->thread_flags) ||
> > > +	    (action->thread->flags & PF_EXITING))
> > >  		return;
> > 
> > perhaps it makes sense to check PF_EXITING first, we do not want
> > to set IRQTF_RUNTHREAD in this case. I think this doesn't really
> > matter (and the check is obviously racy anyway), just looks a bit
> > confusing.
> 
> It does not matter, the thread cleans it up in the exit path. So it's
> mostly cosmetic, but you are right, it reads better :)

Oleg, Thomas,

I swapped the checks because I wanted to avoid this scenario:


CPU1                        CPU2

                            do_exit()
                              exit_signals(tsk);  /* sets PF_EXITING */
                              smp_mb(); <--------------------------------+
                              exit_irq_thread();                         |
                                irq_finalize_oneshot();                  |
                                  desc->threads_oneshot &= ~action->thread_mask;
                                  unmask_irq(desc);                      |
                                                                         |
/* Once the irq is unmasked new interrupt can come... */                 |
                                                                         |
irq_wake_thread()                                                        |
                                                                         |
  /* To notice PF_EXITING has changed a call to smp_rmb() should be here |
   * to pair with smp_mb() in do_exit() ---------------------------------+
   * But it is not, and the condition might not fulfill.
   * Hence the thread might not return, although it should.
   */
  if ((action->thread->flags & PF_EXITING) ||
      test_and_set_bit(IRQTF_RUNTHREAD, &action->thread_flags))
          return;
  ...

  /* And would be stalled bit will be mistakenly set */
  desc->threads_oneshot |= action->thread_mask;


Given that PF_EXITING check almost never fulfills but always gets executed and
test_and_set_bit() is a smp general barrier I thought swapping of PF_EXITING vs
IRQTF_RUNTHREAD checks is better than putting explicit smp_rmb().

If my considerations are flawed I will repost the patch with the original
order as it indeed reads better :)

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
