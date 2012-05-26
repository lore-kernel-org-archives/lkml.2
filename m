Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752484Ab2EZKSw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 06:18:52 -0400
Received: from www.linutronix.de ([62.245.132.108]:41005 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097Ab2EZKSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 06:18:51 -0400
Date: Sat, 26 May 2012 12:18:21 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Suresh Siddha <suresh.b.siddha@intel.com>
cc: Dimitri Sivanich <sivanich@sgi.com>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Yinghai Lu <yinghai@kernel.org>,
        Naga Chumbalkar <nagananda.chumbalkar@hp.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: check for valid irq_cfg pointer in
 smp_irq_move_cleanup_interrupt
In-Reply-To: <1337991809.7938.36.camel@sbsiddha-desk.sc.intel.com>
Message-ID: <alpine.LFD.2.02.1205261216160.3231@ionos>
References: <20120521164959.GE16454@sgi.com>   <alpine.LFD.2.02.1205212304580.3231@ionos>  <20120521211917.GA25567@sgi.com>   <alpine.LFD.2.02.1205212324260.3231@ionos> <20120523181636.GA2032@sgi.com>   <20120523190414.GA5263@sgi.com>  
 <1337801086.1997.197.camel@sbsiddha-desk.sc.intel.com>   <20120523200226.GA6936@sgi.com>   <1337816970.1997.207.camel@sbsiddha-desk.sc.intel.com>   <20120524143711.GA24711@sgi.com>  <1337883560.7938.9.camel@sbsiddha-desk.sc.intel.com> 
 <alpine.LFD.2.02.1205242113400.3231@ionos> <1337991809.7938.36.camel@sbsiddha-desk.sc.intel.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 May 2012, Suresh Siddha wrote:
> On Thu, 2012-05-24 at 21:16 +0200, Thomas Gleixner wrote:
> There are other (not-so common) irq desc references, like in the
> show_interrupts() (cat /proc/interrupts path) etc, that does things like
> this in the process context:
> 
>         desc = irq_to_desc(i);
>         if (!desc)
>                 return 0;
> 
>         raw_spin_lock_irqsave(&desc->lock, flags);
> 
> May be we should introduce something like
> get_irq_desc_locked()/put_irq_desc_locked() that can safely access the
> irq desc with pre-emption/irq's disabled and lock it etc. And the
> synchronize_sched() will enable the destroy_irq()/free_desc() to free it
> safely etc.

I want to avoid that and instead use proper refcounting. The reason is
that we want to move the irq descriptor when the affinity changes
nodes, and for that we need refcounting anyway.

Thanks,

	tglx
