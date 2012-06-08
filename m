Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934484Ab2FHUl6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 16:41:58 -0400
Received: from www.linutronix.de ([62.245.132.108]:59830 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759176Ab2FHUl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 16:41:57 -0400
Date: Fri, 8 Jun 2012 22:41:54 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Francois Romieu <romieu@fr.zoreil.com>
cc: Dave Jones <davej@redhat.com>, Marc Dionne <marc.c.dionne@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: NOHZ: local_softirq_pending 08
In-Reply-To: <20120608202701.GA26175@electric-eye.fr.zoreil.com>
Message-ID: <alpine.LFD.2.02.1206082238120.3086@ionos>
References: <alpine.LFD.2.02.1205310938080.3231@ionos> <20120601225754.GA25281@electric-eye.fr.zoreil.com> <CAB9dFdvWoc1onyWyy4BVmhpjeb5K2d10re0NcW-_NQCbfRC0hw@mail.gmail.com> <20120605231550.GA20981@electric-eye.fr.zoreil.com> <20120606014656.GA24870@redhat.com>
 <20120606054251.GA24467@electric-eye.fr.zoreil.com> <20120608023420.GD7191@redhat.com> <alpine.LFD.2.02.1206080954440.3086@ionos> <20120608142333.GB1711@redhat.com> <alpine.LFD.2.02.1206081641040.3086@ionos>
 <20120608202701.GA26175@electric-eye.fr.zoreil.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Jun 2012, Francois Romieu wrote:

> Thomas Gleixner <tglx@linutronix.de> :
> [...]
> > I can't find the point where the warning is issued, but I think I
> > found the cause of the problem.
> > 
> > static void rtl_slow_event_work(struct rtl8169_private *tp)
> > {
> > 	.....
> > 	napi_schedule(&tp->napi);
> > 	  --> __napi_schedule();
> > 	      -->	list_add_tail(&napi->poll_list, &sd->poll_list);
> > 	              __raise_softirq_irqoff(NET_RX_SOFTIRQ);
> > 
> > 		      This merily sets the softirq bit.
> > 
> > 
> > So this code is really wrong. It's called from full preemptible
> > context of the workqueue. And if the next thing is a context switch to
> > idle then the pending softirq check will trigger.
> 
> void __napi_schedule(struct napi_struct *n)
> {
>         unsigned long flags;
> 
>         local_irq_save(flags);
>         ____napi_schedule(&__get_cpu_var(softnet_data), n);
>         local_irq_restore(flags);
> }
> 
> Are you saying that this stuff should be considered "preemptible" ?

Gah, crap. Looked at the wrong ___________underscore level. I _____so
__love _that.

Though the problem is, that it is neither called in interrupt context
nor with bh disabled, so nothing invokes the softirq before it reaches
idle.

In hard interrupt context the pending flag is evaluated in irq_exit()
and the softirqs are invoked from there. If you call that from thread
context, then a bh_disable/enable pair will make sure that the pending
softirq is invoked. Did I miss some more ___underscore magic which
does that ?

Thanks,

	tglx


