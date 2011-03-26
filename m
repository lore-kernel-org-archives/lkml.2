Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030Ab1CZTuC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 15:50:02 -0400
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:21300 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753745Ab1CZTuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 15:50:00 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: lGhtqgkVM1lyB2q7U1W4RS.a_JLWbn8ZCTEhNeMTDr4oMUO
 ow5BbFxzenCYtLNihVPo93fXrVhrqmxF_oWN2iQS5UKIwCBGg1HQbaEQedeP
 Kf.BeiNPi1crj.Z2_2lBlp2NKdkwDdWOuym3YtpxjiNaRO0RTLZdWVm1WZRK
 zpbAq2adhjm6dEIryIrnlp4tu6c0JpPz8zVRbs.woRjrDiTG5tx4NP1Bct1J
 c3sBKgMk1VEXLoRbiVj7ZZJ9Gn7GYJuyS7TMAfqJu_n2i_1_FfPD5F46A1h4
 oDgX238LoxFkqqGk3HALS.sFnU4P.LvvFslZcduu4zaQBS7FrR21M2grtezr
 hwEA2pL6tP0VOUAwuDrJpVrTh
X-Yahoo-Newman-Property: ymail-3
Date: Sat, 26 Mar 2011 14:49:56 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, tj@kernel.org, npiggin@kernel.dk,
        rientjes@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] slub: Disable the lockless allocator
In-Reply-To: <alpine.DEB.2.00.1103261428200.25375@router.home>
Message-ID: <alpine.DEB.2.00.1103261440160.25375@router.home>
References: <alpine.DEB.2.00.1103221635400.4521@tiger>  <20110324142146.GA11682@elte.hu>  <alpine.DEB.2.00.1103240940570.32226@router.home>  <AANLkTikb8rtSX5hQG6MQF4quymFUuh5Tw97TcpB0YfwS@mail.gmail.com>  <20110324172653.GA28507@elte.hu> <20110324185258.GA28370@elte.hu>
  <alpine.LFD.2.00.1103242005530.31464@localhost6.localdomain6>  <20110324192247.GA5477@elte.hu>  <AANLkTinBwM9egao496WnaNLAPUxhMyJmkusmxt+ARtnV@mail.gmail.com>  <20110326112725.GA28612@elte.hu>  <20110326114736.GA8251@elte.hu> <1301161507.2979.105.camel@edumazet-laptop>
 <alpine.DEB.2.00.1103261406420.24195@router.home> <alpine.DEB.2.00.1103261428200.25375@router.home>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Mar 2011, Christoph Lameter wrote:

> Tejun: Whats going on there? I should be getting offsets into the per cpu
> area and not kernel addresses.

Its a UP kernel running on dual Athlon. So its okay ... Argh.... The
following patch fixes it by using the fallback code for cmpxchg_double:



Subject: per_cpu: Fixup cmpxchg_double for !SMP

cmpxchg_double should only be provided for SMP. In the UP case
the GS register is not defined and the function will fail.

Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux-2.6/arch/x86/include/asm/percpu.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/percpu.h	2011-03-26 11:11:19.175244998 -0500
+++ linux-2.6/arch/x86/include/asm/percpu.h	2011-03-26 14:45:29.254088998 -0500
@@ -507,6 +507,7 @@
  * it in software.  The address used in the cmpxchg16 instruction must be
  * aligned to a 16 byte boundary.
  */
+#ifdef CONFIG_SMP
 #define percpu_cmpxchg16b_double(pcp1, o1, o2, n1, n2)			\
 ({									\
 	char __ret;							\
@@ -529,6 +530,7 @@
 #define irqsafe_cpu_cmpxchg_double_8(pcp1, pcp2, o1, o2, n1, n2)	percpu_cmpxchg16b_double(pcp1, o1, o2, n1, n2)

 #endif
+#endif

 /* This is not atomic against other CPUs -- CPU preemption needs to be off */
 #define x86_test_and_clear_bit_percpu(bit, var)				\

