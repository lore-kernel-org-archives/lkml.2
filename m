Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756879Ab2IJRqJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 13:46:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:47286 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752805Ab2IJRqH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 13:46:07 -0400
Message-ID: <1347299151.2124.57.camel@twins>
Subject: Re: [PATCH 4/7] ptrace: Partly fix
 set_task_blockstep()->update_debugctlmsr() logic
From: Peter Zijlstra <peterz@infradead.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Roland McGrath <roland@hack.frob.com>, linux-kernel@vger.kernel.org
Date: Mon, 10 Sep 2012 19:45:51 +0200
In-Reply-To: <20120910165717.GA17118@linutronix.de>
References: <20120903152525.GA9028@redhat.com>
	 <20120903152609.GA9071@redhat.com> <20120910165717.GA17118@linutronix.de>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-09-10 at 18:57 +0200, Sebastian Andrzej Siewior wrote:
> The only user that is touching this bits in irq context is perf. perf
> uses raw_local_irqsave() (raw_* most likely due to -RT).

# git grep raw_local_irq arch/x86/kernel/cpu/perf_* kernel/events/ | wc -l
0

I think you're confusing raw_spin_lock_irq{,save}() with
raw_local_irq{,save}(), those two are not the same.

raw_spin_lock* is a lock that is always a spinlock -- unlike spin_lock,
which can be a PI-mutex (PREEMPT_RT=y).

raw_local_irq* is like arch_spin_lock* and avoids things like tracing
and lockdep and should not be used unless you really know wth you're
doing, and then still not ;-)

>  I have no idea
> what you can against NMI unless not touching the register in NMI
> context. 

I think perf will actually touch this from NMI context under 'rare'
conditions, in particular:

  x86_pmu_handle_irq() (NMI handler)
    x86_pmu_stop()
      x86_pmu.disable -> intel_pmu_disable_event()
        intel_pmu_lbr_disable()
          __intel_pmu_lbr_disable()
            wrmsrl(MSR_IA32_DEBUGCTLMSR,... );

I suppose I should look into it not doing that...
