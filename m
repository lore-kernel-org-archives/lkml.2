Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760532Ab0EECNP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 22:13:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:37125 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760518Ab0EECNI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 22:13:08 -0400
Date: Wed, 5 May 2010 02:10:46 GMT
From: "tip-bot for Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, ebiederm@xmission.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, ebiederm@xmission.com
In-Reply-To: <1269936436-7039-15-git-send-email-ebiederm@xmission.com>
References: <1269936436-7039-15-git-send-email-ebiederm@xmission.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/irq] x86, irq: Kill io_apic_renumber_irq
Message-ID: <tip-7b20bd5fb902088579af4e70f7f802b93181a628@git.kernel.org>
Git-Commit-ID: 7b20bd5fb902088579af4e70f7f802b93181a628
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 05 May 2010 02:10:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7b20bd5fb902088579af4e70f7f802b93181a628
Gitweb:     http://git.kernel.org/tip/7b20bd5fb902088579af4e70f7f802b93181a628
Author:     Eric W. Biederman <ebiederm@xmission.com>
AuthorDate: Tue, 30 Mar 2010 01:07:16 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 4 May 2010 13:35:20 -0700

x86, irq: Kill io_apic_renumber_irq

Now that the generic irq layer is performing the exact same remapping as
io_apic_renumber_irq we can kill this weird  es7000 specific function.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
LKML-Reference: <1269936436-7039-15-git-send-email-ebiederm@xmission.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/io_apic.h   |    1 -
 arch/x86/kernel/acpi/boot.c      |    5 -----
 arch/x86/kernel/apic/es7000_32.c |   19 -------------------
 arch/x86/kernel/apic/io_apic.c   |    6 ------
 4 files changed, 0 insertions(+), 31 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 37b0f2b..9da192a 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -159,7 +159,6 @@ struct io_apic_irq_attr;
 extern int io_apic_set_pci_routing(struct device *dev, int irq,
 		 struct io_apic_irq_attr *irq_attr);
 void setup_IO_APIC_irq_extra(u32 gsi);
-extern int (*ioapic_renumber_irq)(int ioapic, int irq);
 extern void ioapic_init_mappings(void);
 extern void ioapic_insert_resources(void);
 
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 325fbba..9a5ed58 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -1117,11 +1117,6 @@ int mp_register_gsi(struct device *dev, u32 gsi, int trigger, int polarity)
 
 	ioapic_pin = mp_find_ioapic_pin(ioapic, gsi);
 
-#ifdef CONFIG_X86_32
-	if (ioapic_renumber_irq)
-		gsi = ioapic_renumber_irq(ioapic, gsi);
-#endif
-
 	if (ioapic_pin > MP_MAX_IOAPIC_PIN) {
 		printk(KERN_ERR "Invalid reference to IOAPIC pin "
 		       "%d-%d\n", mp_ioapics[ioapic].apicid,
diff --git a/arch/x86/kernel/apic/es7000_32.c b/arch/x86/kernel/apic/es7000_32.c
index 03ba1b8..425e53a 100644
--- a/arch/x86/kernel/apic/es7000_32.c
+++ b/arch/x86/kernel/apic/es7000_32.c
@@ -131,24 +131,6 @@ int					es7000_plat;
 
 static unsigned int			base;
 
-static int
-es7000_rename_gsi(int ioapic, int gsi)
-{
-	if (es7000_plat == ES7000_ZORRO)
-		return gsi;
-
-	if (!base) {
-		int i;
-		for (i = 0; i < nr_ioapics; i++)
-			base += nr_ioapic_registers[i];
-	}
-
-	if (!ioapic && (gsi < 16))
-		gsi += base;
-
-	return gsi;
-}
-
 static int __cpuinit wakeup_secondary_cpu_via_mip(int cpu, unsigned long eip)
 {
 	unsigned long vect = 0, psaival = 0;
@@ -190,7 +172,6 @@ static void setup_unisys(void)
 		es7000_plat = ES7000_ZORRO;
 	else
 		es7000_plat = ES7000_CLASSIC;
-	ioapic_renumber_irq = es7000_rename_gsi;
 }
 
 /*
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 594827c..d174d88 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1016,7 +1016,6 @@ static inline int irq_trigger(int idx)
 	return MPBIOS_trigger(idx);
 }
 
-int (*ioapic_renumber_irq)(int ioapic, int irq);
 static int pin_2_irq(int idx, int apic, int pin)
 {
 	int irq;
@@ -1032,11 +1031,6 @@ static int pin_2_irq(int idx, int apic, int pin)
 		irq = mp_irqs[idx].srcbusirq;
 	} else {
 		u32 gsi = mp_gsi_routing[apic].gsi_base + pin;
-		/*
-                 * For MPS mode, so far only needed by ES7000 platform
-                 */
-		if (ioapic_renumber_irq)
-			gsi = ioapic_renumber_irq(apic, gsi);
 
 		if (gsi >= NR_IRQS_LEGACY)
 			irq = gsi;
