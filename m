Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380Ab0LHRde (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 12:33:34 -0500
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:36302 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754304Ab0LHRdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 12:33:33 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: BXq23_MVM1lLZq2IqnqEMV3Oa_8w9zKqkyq52uF7JTiUqMH
 VTIvcfNtcsBu1GfGLUGkK0kwUF05LfEHflw.am9D1aUeNhvk7XwWgarmZooY
 ThXjvlVJOxSEWi915SdlCHqENCqHSXja5Td1b5LIwEWgBM.4NWUlqWhXnvOq
 1AJ8mnNrV.37B3tdjdiJHsMTUrGaamohgPtX3zXLgayHjDh22bbizGhDkcSs
 qw99pV0UIDfQ-
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 8 Dec 2010 11:33:29 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Tejun Heo <tj@kernel.org>
cc: Eric Dumazet <eric.dumazet@gmail.com>, akpm@linux-foundation.org,
        Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH] x86: Replace uses of current_cpu_data with this_cpu
 ops
In-Reply-To: <4CFFBE67.8070809@kernel.org>
Message-ID: <alpine.DEB.2.00.1012081132280.23407@router.home>
References: <20101206171618.302060721@linux.com>  <20101206171638.595205962@linux.com> <4CFE41F8.7040400@kernel.org>  <4CFE4294.30001@kernel.org>  <alpine.DEB.2.00.1012070846050.25976@router.home>  <4CFE4BE0.9040203@kernel.org>  <alpine.DEB.2.00.1012070906290.26552@router.home>
  <4CFE4E05.7070902@kernel.org>  <alpine.DEB.2.00.1012071020040.26552@router.home>  <4CFF8520.4020704@kernel.org> <1291815501.2883.34.camel@edumazet-laptop>  <alpine.DEB.2.00.1012080929590.23407@router.home> <1291828646.2883.65.camel@edumazet-laptop>
 <4CFFBE67.8070809@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Beginnings of a patch to avoid bitops. If you think this is the right way
then I will complete it for all uses of cpu_has.


---
 arch/x86/include/asm/cpufeature.h |   15 +++++++++++++++
 arch/x86/kernel/apic/apic.c       |    2 +-
 2 files changed, 16 insertions(+), 1 deletion(-)

Index: linux-2.6/arch/x86/include/asm/cpufeature.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/cpufeature.h	2010-12-08 09:39:31.000000000 -0600
+++ linux-2.6/arch/x86/include/asm/cpufeature.h	2010-12-08 09:40:02.000000000 -0600
@@ -221,6 +221,21 @@ extern const char * const x86_power_flag
 	  ? 1 :								\
 	 test_cpu_cap(c, bit))

+#define this_cpu_has(bit)							\
+	(__builtin_constant_p(bit) &&					\
+	 ( (((bit)>>5)==0 && (1UL<<((bit)&31) & REQUIRED_MASK0)) ||	\
+	   (((bit)>>5)==1 && (1UL<<((bit)&31) & REQUIRED_MASK1)) ||	\
+	   (((bit)>>5)==2 && (1UL<<((bit)&31) & REQUIRED_MASK2)) ||	\
+	   (((bit)>>5)==3 && (1UL<<((bit)&31) & REQUIRED_MASK3)) ||	\
+	   (((bit)>>5)==4 && (1UL<<((bit)&31) & REQUIRED_MASK4)) ||	\
+	   (((bit)>>5)==5 && (1UL<<((bit)&31) & REQUIRED_MASK5)) ||	\
+	   (((bit)>>5)==6 && (1UL<<((bit)&31) & REQUIRED_MASK6)) ||	\
+	   (((bit)>>5)==7 && (1UL<<((bit)&31) & REQUIRED_MASK7)) ||	\
+	   (((bit)>>5)==8 && (1UL<<((bit)&31) & REQUIRED_MASK8)) ||	\
+	   (((bit)>>5)==9 && (1UL<<((bit)&31) & REQUIRED_MASK9)) )	\
+	  ? 1 :								\
+	 (this_cpu_read(cpu_info.x86_capabilty) & (1 << bit)))
+
 #define boot_cpu_has(bit)	cpu_has(&boot_cpu_data, bit)

 #define set_cpu_cap(c, bit)	set_bit(bit, (unsigned long *)((c)->x86_capability))
Index: linux-2.6/arch/x86/kernel/apic/apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/apic.c	2010-12-08 09:40:37.000000000 -0600
+++ linux-2.6/arch/x86/kernel/apic/apic.c	2010-12-08 09:40:49.000000000 -0600
@@ -516,7 +516,7 @@ static void __cpuinit setup_APIC_timer(v
 {
 	struct clock_event_device *levt = &__get_cpu_var(lapic_events);

-	if (cpu_has(__this_cpu_ptr(&cpu_info), X86_FEATURE_ARAT)) {
+	if (this_cpu_has(X86_FEATURE_ARAT)) {
 		lapic_clockevent.features &= ~CLOCK_EVT_FEAT_C3STOP;
 		/* Make LAPIC timer preferrable over percpu HPET */
 		lapic_clockevent.rating = 150;
