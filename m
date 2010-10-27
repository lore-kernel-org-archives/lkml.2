Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756651Ab0J0UIz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 16:08:55 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:57528 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752328Ab0J0UIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 16:08:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:user-agent:date:from:to:cc:subject:references
         :content-disposition;
        b=hAlVWtq63E2A8NjoXuXcGNbDMrdsJH4aVflJlAV13TdgcA3EX8fj6zsw1iTQHUV5qG
         lziQUdWH/baE4nUxP8EroZRHN565kysgUEFviq/ZvZqdeKxx42UiJiGHok/t7BmdBIyQ
         vXv/SZcE1nUKbxlYzsRKxIiEc+O9vuAuReQ60=
Message-Id: <20101027200806.680836780@openvz.org>
User-Agent: quilt/0.47-1
Date: Wed, 27 Oct 2010 23:53:55 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-kernel@vger.kernel.org, "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>,
        Don Zickus <dzickus@redhat.com>, Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [rfc -tip 2/2] x86, apic: Allow to send self NMI ipi
References: <20101027195352.996250316@openvz.org>
Content-Disposition: inline; filename=x86-apic-ipi-self-nmi
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
CC: Don Zickus <dzickus@redhat.com>
---
 arch/x86/include/asm/ipi.h            |    6 ++++++
 arch/x86/kernel/apic/ipi.c            |    5 ++++-
 arch/x86/kernel/apic/probe_64.c       |    5 ++++-
 arch/x86/kernel/apic/x2apic_cluster.c |    5 ++++-
 arch/x86/kernel/apic/x2apic_phys.c    |    5 ++++-
 arch/x86/kernel/apic/x2apic_uv_x.c    |    5 ++++-
 6 files changed, 26 insertions(+), 5 deletions(-)

Index: linux-2.6.git/arch/x86/include/asm/ipi.h
=====================================================================
--- linux-2.6.git.orig/arch/x86/include/asm/ipi.h
+++ linux-2.6.git/arch/x86/include/asm/ipi.h
@@ -149,6 +149,12 @@ static inline void __default_local_send_
 		__default_send_IPI_shortcut(APIC_DEST_ALLINC, vector, apic->dest_logical);
 }
 
+static inline void __default_send_IPI_self_nmi(void)
+{
+	const struct cpumask *cpumask = cpumask_of(smp_processor_id());
+	apic->send_IPI_mask(cpumask, NMI_VECTOR);
+}
+
 #ifdef CONFIG_X86_32
 extern void default_send_IPI_mask_logical(const struct cpumask *mask,
 						 int vector);
Index: linux-2.6.git/arch/x86/kernel/apic/ipi.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/apic/ipi.c
+++ linux-2.6.git/arch/x86/kernel/apic/ipi.c
@@ -134,7 +134,10 @@ void default_send_IPI_all(int vector)
 
 void default_send_IPI_self(int vector)
 {
-	__default_send_IPI_shortcut(APIC_DEST_SELF, vector, apic->dest_logical);
+	if (unlikely(vector == NMI_VECTOR))
+		__default_send_IPI_self_nmi();
+	else
+		__default_send_IPI_shortcut(APIC_DEST_SELF, vector, apic->dest_logical);
 }
 
 /* must come after the send_IPI functions above for inlining */
Index: linux-2.6.git/arch/x86/kernel/apic/probe_64.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/apic/probe_64.c
+++ linux-2.6.git/arch/x86/kernel/apic/probe_64.c
@@ -92,7 +92,10 @@ void __init default_setup_apic_routing(v
 
 void apic_send_IPI_self(int vector)
 {
-	__default_send_IPI_shortcut(APIC_DEST_SELF, vector, APIC_DEST_PHYSICAL);
+	if (unlikely(vector == NMI_VECTOR))
+		__default_send_IPI_self_nmi();
+	else
+		__default_send_IPI_shortcut(APIC_DEST_SELF, vector, APIC_DEST_PHYSICAL);
 }
 
 int __init default_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
Index: linux-2.6.git/arch/x86/kernel/apic/x2apic_cluster.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/apic/x2apic_cluster.c
+++ linux-2.6.git/arch/x86/kernel/apic/x2apic_cluster.c
@@ -174,7 +174,10 @@ static int x2apic_cluster_phys_pkg_id(in
 
 static void x2apic_send_IPI_self(int vector)
 {
-	apic_write(APIC_SELF_IPI, vector);
+	if (unlikely(vector == NMI_VECTOR))
+		__default_send_IPI_self_nmi();
+	else
+		apic_write(APIC_SELF_IPI, vector);
 }
 
 static void init_x2apic_ldr(void)
Index: linux-2.6.git/arch/x86/kernel/apic/x2apic_phys.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/apic/x2apic_phys.c
+++ linux-2.6.git/arch/x86/kernel/apic/x2apic_phys.c
@@ -166,7 +166,10 @@ static int x2apic_phys_pkg_id(int initia
 
 static void x2apic_send_IPI_self(int vector)
 {
-	apic_write(APIC_SELF_IPI, vector);
+	if (unlikely(vector == NMI_VECTOR))
+		__default_send_IPI_self_nmi();
+	else
+		apic_write(APIC_SELF_IPI, vector);
 }
 
 static void init_x2apic_ldr(void)
Index: linux-2.6.git/arch/x86/kernel/apic/x2apic_uv_x.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/apic/x2apic_uv_x.c
+++ linux-2.6.git/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -274,7 +274,10 @@ static int uv_phys_pkg_id(int initial_ap
 
 static void uv_send_IPI_self(int vector)
 {
-	apic_write(APIC_SELF_IPI, vector);
+	if (unlikely(vector == NMI_VECTOR))
+		__default_send_IPI_self_nmi();
+	else
+		apic_write(APIC_SELF_IPI, vector);
 }
 
 struct apic __refdata apic_x2apic_uv_x = {

