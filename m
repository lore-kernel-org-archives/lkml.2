Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964781Ab2FHUgQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 16:36:16 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:47973 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754102Ab2FHUgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 16:36:15 -0400
Date: Fri, 8 Jun 2012 22:27:01 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Dave Jones <davej@redhat.com>, Marc Dionne <marc.c.dionne@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: NOHZ: local_softirq_pending 08
Message-ID: <20120608202701.GA26175@electric-eye.fr.zoreil.com>
References: <alpine.LFD.2.02.1205310938080.3231@ionos> <20120601225754.GA25281@electric-eye.fr.zoreil.com> <CAB9dFdvWoc1onyWyy4BVmhpjeb5K2d10re0NcW-_NQCbfRC0hw@mail.gmail.com> <20120605231550.GA20981@electric-eye.fr.zoreil.com> <20120606014656.GA24870@redhat.com> <20120606054251.GA24467@electric-eye.fr.zoreil.com> <20120608023420.GD7191@redhat.com> <alpine.LFD.2.02.1206080954440.3086@ionos> <20120608142333.GB1711@redhat.com> <alpine.LFD.2.02.1206081641040.3086@ionos>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1206081641040.3086@ionos>
User-Agent: Mutt/1.4.2.2i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner <tglx@linutronix.de> :
[...]
> I can't find the point where the warning is issued, but I think I
> found the cause of the problem.
> 
> static void rtl_slow_event_work(struct rtl8169_private *tp)
> {
> 	.....
> 	napi_schedule(&tp->napi);
> 	  --> __napi_schedule();
> 	      -->	list_add_tail(&napi->poll_list, &sd->poll_list);
> 	              __raise_softirq_irqoff(NET_RX_SOFTIRQ);
> 
> 		      This merily sets the softirq bit.
> 
> 
> So this code is really wrong. It's called from full preemptible
> context of the workqueue. And if the next thing is a context switch to
> idle then the pending softirq check will trigger.

void __napi_schedule(struct napi_struct *n)
{
        unsigned long flags;

        local_irq_save(flags);
        ____napi_schedule(&__get_cpu_var(softnet_data), n);
        local_irq_restore(flags);
}

Are you saying that this stuff should be considered "preemptible" ?

-- 
Ueimor
