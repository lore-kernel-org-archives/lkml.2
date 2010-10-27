Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756709Ab0J0UJO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 16:09:14 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:65021 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680Ab0J0UIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 16:08:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:user-agent:date:from:to:cc:subject:references
         :content-disposition;
        b=FpU3ICCNNIRSNc5QyRD5HL9W/NIqJ+iiAblPCUy60qNmOi5aeD16VuV2K+54eiJDCt
         AY40UDgiETKSxXASKieZdyAgovGI023hvHPSDq/yHIn5hZ6+cu5mi2lNsBW7SBxpUMwF
         tfsYR7YNfKiw2/fZY4LQ8gJO50ndiNtnKdl7Y=
Message-Id: <20101027200806.496446571@openvz.org>
User-Agent: quilt/0.47-1
Date: Wed, 27 Oct 2010 23:53:54 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-kernel@vger.kernel.org, "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>,
        Don Zickus <dzickus@redhat.com>, Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [rfc -tip 1/2] x86, apic: Get rid of some IPI wrappers
References: <20101027195352.996250316@openvz.org>
Content-Disposition: inline; filename=x86-apic-no-ipi-wrappers
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

They just hide the sameness of methods.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
CC: Don Zickus <dzickus@redhat.com>
---
 arch/x86/kernel/apic/apic_flat_64.c |   17 +++--------------
 arch/x86/kernel/apic/bigsmp_32.c    |    9 ++-------
 arch/x86/kernel/apic/es7000_32.c    |   11 +++--------
 arch/x86/kernel/apic/numaq_32.c     |    9 ++-------
 arch/x86/kernel/apic/summit_32.c    |    9 ++-------
 5 files changed, 12 insertions(+), 43 deletions(-)

Index: linux-2.6.git/arch/x86/kernel/apic/apic_flat_64.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/apic/apic_flat_64.c
+++ linux-2.6.git/arch/x86/kernel/apic/apic_flat_64.c
@@ -261,17 +261,6 @@ static void physflat_vector_allocation_d
 	cpumask_set_cpu(cpu, retmask);
 }
 
-static void physflat_send_IPI_mask(const struct cpumask *cpumask, int vector)
-{
-	default_send_IPI_mask_sequence_phys(cpumask, vector);
-}
-
-static void physflat_send_IPI_mask_allbutself(const struct cpumask *cpumask,
-					      int vector)
-{
-	default_send_IPI_mask_allbutself_phys(cpumask, vector);
-}
-
 static void physflat_send_IPI_allbutself(int vector)
 {
 	default_send_IPI_mask_allbutself_phys(cpu_online_mask, vector);
@@ -279,7 +268,7 @@ static void physflat_send_IPI_allbutself
 
 static void physflat_send_IPI_all(int vector)
 {
-	physflat_send_IPI_mask(cpu_online_mask, vector);
+	default_send_IPI_mask_sequence_phys(cpu_online_mask, vector);
 }
 
 static unsigned int physflat_cpu_mask_to_apicid(const struct cpumask *cpumask)
@@ -354,8 +343,8 @@ struct apic apic_physflat =  {
 	.cpu_mask_to_apicid		= physflat_cpu_mask_to_apicid,
 	.cpu_mask_to_apicid_and		= physflat_cpu_mask_to_apicid_and,
 
-	.send_IPI_mask			= physflat_send_IPI_mask,
-	.send_IPI_mask_allbutself	= physflat_send_IPI_mask_allbutself,
+	.send_IPI_mask			= default_send_IPI_mask_sequence_phys,
+	.send_IPI_mask_allbutself	= default_send_IPI_mask_allbutself_phys,
 	.send_IPI_allbutself		= physflat_send_IPI_allbutself,
 	.send_IPI_all			= physflat_send_IPI_all,
 	.send_IPI_self			= apic_send_IPI_self,
Index: linux-2.6.git/arch/x86/kernel/apic/bigsmp_32.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/apic/bigsmp_32.c
+++ linux-2.6.git/arch/x86/kernel/apic/bigsmp_32.c
@@ -139,11 +139,6 @@ static int bigsmp_phys_pkg_id(int cpuid_
 	return cpuid_apic >> index_msb;
 }
 
-static inline void bigsmp_send_IPI_mask(const struct cpumask *mask, int vector)
-{
-	default_send_IPI_mask_sequence_phys(mask, vector);
-}
-
 static void bigsmp_send_IPI_allbutself(int vector)
 {
 	default_send_IPI_mask_allbutself_phys(cpu_online_mask, vector);
@@ -151,7 +146,7 @@ static void bigsmp_send_IPI_allbutself(i
 
 static void bigsmp_send_IPI_all(int vector)
 {
-	bigsmp_send_IPI_mask(cpu_online_mask, vector);
+	default_send_IPI_mask_sequence_phys(cpu_online_mask, vector);
 }
 
 static int dmi_bigsmp; /* can be set by dmi scanners */
@@ -236,7 +231,7 @@ struct apic apic_bigsmp = {
 	.cpu_mask_to_apicid		= bigsmp_cpu_mask_to_apicid,
 	.cpu_mask_to_apicid_and		= bigsmp_cpu_mask_to_apicid_and,
 
-	.send_IPI_mask			= bigsmp_send_IPI_mask,
+	.send_IPI_mask			= default_send_IPI_mask_sequence_phys,
 	.send_IPI_mask_allbutself	= NULL,
 	.send_IPI_allbutself		= bigsmp_send_IPI_allbutself,
 	.send_IPI_all			= bigsmp_send_IPI_all,
Index: linux-2.6.git/arch/x86/kernel/apic/es7000_32.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/apic/es7000_32.c
+++ linux-2.6.git/arch/x86/kernel/apic/es7000_32.c
@@ -420,11 +420,6 @@ static unsigned int es7000_get_apic_id(u
 	return (x >> 24) & 0xFF;
 }
 
-static void es7000_send_IPI_mask(const struct cpumask *mask, int vector)
-{
-	default_send_IPI_mask_sequence_phys(mask, vector);
-}
-
 static void es7000_send_IPI_allbutself(int vector)
 {
 	default_send_IPI_mask_allbutself_phys(cpu_online_mask, vector);
@@ -432,7 +427,7 @@ static void es7000_send_IPI_allbutself(i
 
 static void es7000_send_IPI_all(int vector)
 {
-	es7000_send_IPI_mask(cpu_online_mask, vector);
+	default_send_IPI_mask_sequence_phys(cpu_online_mask, vector);
 }
 
 static int es7000_apic_id_registered(void)
@@ -672,7 +667,7 @@ struct apic __refdata apic_es7000_cluste
 	.cpu_mask_to_apicid		= es7000_cpu_mask_to_apicid,
 	.cpu_mask_to_apicid_and		= es7000_cpu_mask_to_apicid_and,
 
-	.send_IPI_mask			= es7000_send_IPI_mask,
+	.send_IPI_mask			= default_send_IPI_mask_sequence_phys,
 	.send_IPI_mask_allbutself	= NULL,
 	.send_IPI_allbutself		= es7000_send_IPI_allbutself,
 	.send_IPI_all			= es7000_send_IPI_all,
@@ -737,7 +732,7 @@ struct apic __refdata apic_es7000 = {
 	.cpu_mask_to_apicid		= es7000_cpu_mask_to_apicid,
 	.cpu_mask_to_apicid_and		= es7000_cpu_mask_to_apicid_and,
 
-	.send_IPI_mask			= es7000_send_IPI_mask,
+	.send_IPI_mask			= default_send_IPI_mask_sequence_phys,
 	.send_IPI_mask_allbutself	= NULL,
 	.send_IPI_allbutself		= es7000_send_IPI_allbutself,
 	.send_IPI_all			= es7000_send_IPI_all,
Index: linux-2.6.git/arch/x86/kernel/apic/numaq_32.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/apic/numaq_32.c
+++ linux-2.6.git/arch/x86/kernel/apic/numaq_32.c
@@ -299,11 +299,6 @@ static inline unsigned int numaq_get_api
 	return (x >> 24) & 0x0F;
 }
 
-static inline void numaq_send_IPI_mask(const struct cpumask *mask, int vector)
-{
-	default_send_IPI_mask_sequence_logical(mask, vector);
-}
-
 static inline void numaq_send_IPI_allbutself(int vector)
 {
 	default_send_IPI_mask_allbutself_logical(cpu_online_mask, vector);
@@ -311,7 +306,7 @@ static inline void numaq_send_IPI_allbut
 
 static inline void numaq_send_IPI_all(int vector)
 {
-	numaq_send_IPI_mask(cpu_online_mask, vector);
+	default_send_IPI_mask_sequence_logical(cpu_online_mask, vector);
 }
 
 #define NUMAQ_TRAMPOLINE_PHYS_LOW	(0x8)
@@ -525,7 +520,7 @@ struct apic __refdata apic_numaq = {
 	.cpu_mask_to_apicid		= numaq_cpu_mask_to_apicid,
 	.cpu_mask_to_apicid_and		= numaq_cpu_mask_to_apicid_and,
 
-	.send_IPI_mask			= numaq_send_IPI_mask,
+	.send_IPI_mask			= default_send_IPI_mask_sequence_logical,
 	.send_IPI_mask_allbutself	= NULL,
 	.send_IPI_allbutself		= numaq_send_IPI_allbutself,
 	.send_IPI_all			= numaq_send_IPI_all,
Index: linux-2.6.git/arch/x86/kernel/apic/summit_32.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/apic/summit_32.c
+++ linux-2.6.git/arch/x86/kernel/apic/summit_32.c
@@ -52,11 +52,6 @@ static unsigned summit_get_apic_id(unsig
 	return (x >> 24) & 0xFF;
 }
 
-static inline void summit_send_IPI_mask(const struct cpumask *mask, int vector)
-{
-	default_send_IPI_mask_sequence_logical(mask, vector);
-}
-
 static void summit_send_IPI_allbutself(int vector)
 {
 	default_send_IPI_mask_allbutself_logical(cpu_online_mask, vector);
@@ -64,7 +59,7 @@ static void summit_send_IPI_allbutself(i
 
 static void summit_send_IPI_all(int vector)
 {
-	summit_send_IPI_mask(cpu_online_mask, vector);
+	default_send_IPI_mask_sequence_logical(cpu_online_mask, vector);
 }
 
 #include <asm/tsc.h>
@@ -545,7 +540,7 @@ struct apic apic_summit = {
 	.cpu_mask_to_apicid		= summit_cpu_mask_to_apicid,
 	.cpu_mask_to_apicid_and		= summit_cpu_mask_to_apicid_and,
 
-	.send_IPI_mask			= summit_send_IPI_mask,
+	.send_IPI_mask			= default_send_IPI_mask_sequence_logical,
 	.send_IPI_mask_allbutself	= NULL,
 	.send_IPI_allbutself		= summit_send_IPI_allbutself,
 	.send_IPI_all			= summit_send_IPI_all,

