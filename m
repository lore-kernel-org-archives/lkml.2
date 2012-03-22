Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964941Ab2CVMOL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 08:14:11 -0400
Received: from merlin.infradead.org ([205.233.59.134]:43992 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715Ab2CVMOK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 08:14:10 -0400
Message-ID: <1332418412.2487.13.camel@twins>
Subject: Re: [PATCH 0/4] arch/CPU hotplug: Add missing CPU Hotplug bits to
 fix nasty issues
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: rkuo@codeaurora.org, tglx@linutronix.de, linas@codeaurora.org,
        mingo@elte.hu, dhowells@redhat.com, yasutake.koichi@jp.panasonic.com,
        akpm@linux-foundation.org, benh@kernel.crashing.org,
        jesper.nilsson@axis.com, cmetcalf@tilera.com, linux@arm.linux.org.uk,
        jejb@parisc-linux.org, deller@gmx.de, vapier@gentoo.org,
        linux-hexagon@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-am33-list@redhat.com, linux-parisc@vger.kernel.org
Date: Thu, 22 Mar 2012 13:13:32 +0100
In-Reply-To: <20120322112735.17063.21791.stgit@srivatsabhat.in.ibm.com>
References: <20120322112735.17063.21791.stgit@srivatsabhat.in.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-03-22 at 16:58 +0530, Srivatsa S. Bhat wrote:
> Commit 5fbd036b552f633abb394a319f7c62a5c86a9cd7 (sched: Cleanup cpu_active
> madness) introduced some changes that made the scheduler rely on the
> CPU_STARTING notifier. And hence those architectures which forgot to
> send out the CPU_STARTING notification will almost surely get into trouble.
> (Xen is one example[1]). 

The requirement is that CPU_STARTING is ran before set_cpu_online() or
the open-coded equivalent -- eg. blackfin gets this wrong.

However, it is also required that all this happens while local IRQs are
still disabled, since the moment we enable IRQs interrupts can happen
and interrupts can cause wakeups, and wakeups need to have this state
set up -- blackfin, cris, m32r, mips, sh, sparc64, sparc32, um?, x86 get
this wrong.

Furthermore, all archs that use CONFIG_USE_GENERIC_SMP_HELPERS should
hold ipi_call_lock() over setting the cpu online -- alpha, arm, m32r,
mips, sh, sparc32 seem wrong.

Furthermore, I was pondering the scenario where a 3rd cpu IPIs the newly
booting cpu, I suspect we need a smp_wmb() after setting cpu_active and
a rmb in select_fallback_rq() before reading active.

All in all its a complete friggin trainwreck.
