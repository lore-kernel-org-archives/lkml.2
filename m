Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929Ab0JYIpN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 04:45:13 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:63496 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753814Ab0JYIpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 04:45:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=Q5DHEx+he4iitRi3uRjT4dOClIiZRg6QI2OTr7abN0Ak8mSta8wmcSwE7X+KrcMGBl
         GDl8Jss5ydqJeT93UZ285ok/+ppdZqbr8yKD15PY7N8DfHXdbm2PgBgAg78YcXfb3ZM6
         5+i/jxB9RBfhk7wcWlrO//JVQWQzKAM5m4wkk=
Date: Sun, 24 Oct 2010 17:31:29 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [rfc -tip] x86, apic: Get rid of some IPI wrappers
Message-ID: <20101024133129.GA7386@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

They just hide the sameness of methods.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---

I may be missing something but frankly I don't see the reason for
hiding sameness here, the reverse -- if you're going to change something
then instead of looking into direct method implementation you are to
tear through wrapping calls. Of course if implementation is differ from
'default_' one (as in x2apic, uv) it deserves own method.

No?

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
