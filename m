Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755590Ab2CVOxS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 10:53:18 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:58785 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753210Ab2CVOxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 10:53:15 -0400
Message-ID: <1332427989.2946.20.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [PATCH 0/4] arch/CPU hotplug: Add missing CPU Hotplug bits to
 fix nasty issues
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>, rkuo@codeaurora.org,
        tglx@linutronix.de, linas@codeaurora.org, mingo@elte.hu,
        dhowells@redhat.com, yasutake.koichi@jp.panasonic.com,
        akpm@linux-foundation.org, benh@kernel.crashing.org,
        jesper.nilsson@axis.com, cmetcalf@tilera.com, linux@arm.linux.org.uk,
        jejb@parisc-linux.org, deller@gmx.de, vapier@gentoo.org,
        linux-hexagon@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-am33-list@redhat.com, linux-parisc@vger.kernel.org
Date: Thu, 22 Mar 2012 14:53:09 +0000
In-Reply-To: <1332418412.2487.13.camel@twins>
References: <20120322112735.17063.21791.stgit@srivatsabhat.in.ibm.com>
	 <1332418412.2487.13.camel@twins>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-03-22 at 13:13 +0100, Peter Zijlstra wrote:
> On Thu, 2012-03-22 at 16:58 +0530, Srivatsa S. Bhat wrote:
> > Commit 5fbd036b552f633abb394a319f7c62a5c86a9cd7 (sched: Cleanup cpu_active
> > madness) introduced some changes that made the scheduler rely on the
> > CPU_STARTING notifier. And hence those architectures which forgot to
> > send out the CPU_STARTING notification will almost surely get into trouble.
> > (Xen is one example[1]). 
> 
> The requirement is that CPU_STARTING is ran before set_cpu_online() or
> the open-coded equivalent -- eg. blackfin gets this wrong.
> 
> However, it is also required that all this happens while local IRQs are
> still disabled, since the moment we enable IRQs interrupts can happen
> and interrupts can cause wakeups, and wakeups need to have this state
> set up -- blackfin, cris, m32r, mips, sh, sparc64, sparc32, um?, x86 get
> this wrong.
> 
> Furthermore, all archs that use CONFIG_USE_GENERIC_SMP_HELPERS should
> hold ipi_call_lock() over setting the cpu online -- alpha, arm, m32r,
> mips, sh, sparc32 seem wrong.

So for parisc, anywhere in smp_callin() should be fine.  Our last act on
CPU bringup before going into cpu_idle() is to enable interrupts.

> Furthermore, I was pondering the scenario where a 3rd cpu IPIs the newly
> booting cpu, I suspect we need a smp_wmb() after setting cpu_active and
> a rmb in select_fallback_rq() before reading active.
> 
> All in all its a complete friggin trainwreck.

I haven't yet actually tried git head on parisc (and I won't be able to
until I actually get my machines back [currently being shipped across
the atlantic]) but if there's a problem it will show up quickly:  parisc
actually uses cpu hotplug to boot its secondary cpus.

James


