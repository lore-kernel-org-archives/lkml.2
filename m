Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752554Ab1GUM01 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 08:26:27 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41694 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888Ab1GUM00 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 08:26:26 -0400
Subject: Re: 2.6.32.21 - uptime related crashes?
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: john stultz <johnstul@us.ibm.com>, Willy Tarreau <w@1wt.eu>,
        MINOURA Makoto <minoura@valinux.co.jp>,
        Andrew Morton <akpm@linux-foundation.org>,
        Faidon Liambotis <paravoid@debian.org>, linux-kernel@vger.kernel.org,
        stable@kernel.org, Nikola Ciprich <nikola.ciprich@linuxbox.cz>,
        seto.hidetoshi@jp.fujitsu.com,
        =?ISO-8859-1?Q?Herv=E9?= Commowick <hcommowick@exosec.fr>,
        Rand@jasper.es
In-Reply-To: <20110721072256.GE9216@elte.hu>
References: <20110430093605.GA10529@1wt.eu> <20110430173905.GA25641@tty.gr>
	 <BANLkTi=22QFrJ4vO7-3VuHU=9Cg39bxJ4Q@mail.gmail.com>
	 <20110705231515.95bc758f.akpm@linux-foundation.org>
	 <kk5d3hgi9eh.fsf@brer.local.valinux.co.jp>
	 <1310434819.30337.21.camel@work-vm> <20110712041938.GO27254@1wt.eu>
	 <1310690138.3367.61.camel@work-vm> <1310724097.2586.296.camel@twins>
	 <1310752795.2945.4.camel@work-vm>  <20110721072256.GE9216@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 21 Jul 2011 14:24:58 +0200
Message-ID: <1311251098.29152.130.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-07-21 at 09:22 +0200, Ingo Molnar wrote:
> 
> Ping, what's going on with this bug? Systems are crashing so we need 
> a quick fix ASAP ... 

Something as simple as the below ought to cure things for now. Once we
get __cycles_2_ns() fixed up we can enable it again.

(patch against -tip, .32 code is different but equally simple to fix)

---
Subject: x86, intel: Don't mark sched_clock() as stable

Because the x86 sched_clock() implementation wraps at 54 bits and the
scheduler code assumes it wraps at the full 64bits we can get into
trouble after 208 days (~7 months) of uptime. 

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/x86/kernel/cpu/intel.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index ed6086e..c8dc48b 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -91,8 +91,15 @@ static void __cpuinit early_init_intel(struct cpuinfo_x86 *c)
 	if (c->x86_power & (1 << 8)) {
 		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
 		set_cpu_cap(c, X86_FEATURE_NONSTOP_TSC);
+		/*
+		 * Unfortunately our __cycles_2_ns() implementation makes
+		 * the raw sched_clock() interface wrap at 54-bits, which
+		 * makes it unsuitable for direct use, so disable this
+		 * for now.
+		 *
 		if (!check_tsc_unstable())
 			sched_clock_stable = 1;
+		 */
 	}
 
 	/*

