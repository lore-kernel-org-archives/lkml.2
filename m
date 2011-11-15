Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757474Ab1KOWBU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 17:01:20 -0500
Received: from www.linutronix.de ([62.245.132.108]:55140 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757450Ab1KOWBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 17:01:17 -0500
Date: Tue, 15 Nov 2011 23:00:59 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Stepan Moskovchenko <stepanm@codeaurora.org>
cc: Dima Zavin <dima@android.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Frank Rowand <frank.rowand@am.sony.com>,
        amit kachhap <amit.kachhap@linaro.org>,
        Colin Cross <ccross@android.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        chaos.youn@samsung.com, LAK <linux-arm-kernel@lists.infradead.org>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Re: [patch] ARM: smpboot: Enable interrupts after marking CPU
 online/active
In-Reply-To: <4EC2DF93.2050904@codeaurora.org>
Message-ID: <alpine.LFD.2.02.1111152259430.4902@ionos>
References: <20110908215314.829452535@linutronix.de> <CADGdYn6V_eQJZ4=irMbSS7XJj4MJVeALxcrWdD7o2bGs1sEJZQ@mail.gmail.com> <20110913133258.GA6267@n2100.arm.linux.org.uk> <CAKfTPtCWuiOM5+sOwdh1FzXZb1EFT__tVEpRPY5suGOxpYTdQQ@mail.gmail.com>
 <20110913175312.GB6267@n2100.arm.linux.org.uk> <20110923084001.GP17169@n2100.arm.linux.org.uk> <01d501cc84d6$62720890$275619b0$%kim@samsung.com> <alpine.LFD.2.02.1110071354310.3240@ionos> <CAPz4a6CkOXp6LHX2hFYVBhXWT4rhCUzLyYTLbO7g8u_jYcHt7Q@mail.gmail.com>
 <CAPz4a6C7md+k8pCz6mJtB-v_1h-faGxQZkOqU9vHUtcG-jrYVQ@mail.gmail.com> <4EC2DF93.2050904@codeaurora.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Nov 2011, Stepan Moskovchenko wrote:
> I am seeing a deadlock when executing hotplug operations with this patch
> applied. When the secondary CPU gets brought up in _cpu_up, the cpu is turned
> on
> and then the online notifier gets called, which is what marks the secondary
> CPU
> as active. If _cpu_up on the primary CPU is preempted before the secondary CPU
> is marked active, it is possible that the primary CPU will want to call
> smp_call_function (or send an IPI) to the secondary CPU because it is marked
> online. However, with this patch, the secondary CPU is still spinning on
> !cpu_active(cpu)
> with interrupts disabled. So, the primary CPU is now stuck in csd_lock_wait(),
> waiting for the secondary CPU to respond, while the secondary CPU spins with
> interrupts disabled, waiting for the primary CPU to mark it as active. So,
> while
> your approach to not call smp_function_single may work for you in your
> specific
> case, I believe there is still a problem in the general case.
> 
> One suggestion for resolving this might be making smp_call_function look at
> the
> active CPUs rather than online CPUs, or to just let the secondary CPU mark
> itself as active rather than having the primary CPU do this, though this might
> defeat the original intended purpose of the active mask.

What a mess. I'll have a look tomorrow.
