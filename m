Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758046Ab1DAPpk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 11:45:40 -0400
Received: from ist.d-labs.de ([213.239.218.44]:60319 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754445Ab1DAPpj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 11:45:39 -0400
From: Florian Mickler <florian@mickler.org>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        Florian Mickler <florian@mickler.org>, Len Brown <lenb@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>, kurup_avinash@yahoo.com,
        maciej.rutecki@gmail.com, rjw@sisk.pl, sedat.dilek@gmail.com
Subject: [PATCH] x86, ioapic: move acpi_get_override_irq to acpi.c
Date: Fri,  1 Apr 2011 17:44:46 +0200
Message-Id: <1301672686-10096-1-git-send-email-florian@mickler.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <20110401075011.GD7594@elte.hu>
References: <20110401075011.GD7594@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to get rid of the ugly CONFIG_ACPI ifdef, we move
the function acpi_get_override_irq into acpi.c and add a new
helper function ioapic_get_irq to io_apic.c.

Signed-off-by: Florian Mickler <florian@mickler.org>
Cc: Len Brown <lenb@kernel.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: kurup_avinash@yahoo.com
Cc: maciej.rutecki@gmail.com
Cc: rjw@sisk.pl
Cc: sedat.dilek@gmail.com
LKML-Reference: <1301558489-4198-1-git-send-email-florian@mickler.org>
---

Hi Ingo,

Instead of exporting find_irq_entry, irq_trigger and irq_polarity, I added a 
new helper function 'ioapic_get_irq(..)' and exported that. 

Also I did it as a seperate commit, since it is more of a cleanup and the other 
commit is already tested... hope this is ok. 

Regards,
Flo

arch/x86/include/asm/io_apic.h |    8 +++++++-
 arch/x86/kernel/apic/io_apic.c |   40 ++++++++++++----------------------------
 arch/x86/pci/acpi.c            |   24 ++++++++++++++++++++++++
 include/linux/acpi.h           |    6 ++++++
 4 files changed, 49 insertions(+), 29 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index c4bd267..89d3fc6 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -177,6 +177,7 @@ extern void __init pre_init_apic_IRQ0(void);
 extern void mp_save_irq(struct mpc_intsrc *m);
 
 extern void disable_ioapic_support(void);
+extern int ioapic_get_irq(int ioapic, int pin, int *trigger, int *polarity);
 
 #else  /* !CONFIG_X86_IO_APIC */
 
@@ -209,8 +210,13 @@ static inline int restore_IO_APIC_setup(struct IO_APIC_route_entry **ent)
 	return -ENOMEM;
 }
 
-static inline void mp_save_irq(struct mpc_intsrc *m) { };
+static inline void mp_save_irq(struct mpc_intsrc *m) { }
 static inline void disable_ioapic_support(void) { }
+static inline int ioapic_get_irq(int ioapic, int pin, int *trigger,
+		int *polarity)
+{
+	return -1;
+}
 #endif
 
 #endif /* _ASM_X86_IO_APIC_H */
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index edf86ca..35eb531 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -938,6 +938,18 @@ static int irq_trigger(int idx)
 	return trigger;
 }
 
+int ioapic_get_irq(int ioapic, int pin, int *trigger, int *polarity)
+{
+	int idx = find_irq_entry(ioapic, pin, mp_INT);
+
+	if (idx >= 0) {
+		*trigger = irq_trigger(idx);
+		*polarity = irq_polarity(idx);
+	}
+
+	return idx;
+}
+
 static int pin_2_irq(int idx, int apic, int pin)
 {
 	int irq;
@@ -3785,34 +3797,6 @@ static int __init io_apic_get_version(int ioapic)
 	return reg_01.bits.version;
 }
 
-int acpi_get_override_irq(u32 gsi, int *trigger, int *polarity)
-{
-	int ioapic, pin, idx;
-
-#ifdef CONFIG_ACPI
-	if (acpi_irq_model != ACPI_IRQ_MODEL_IOAPIC)
-		return -1;
-#endif
-	if (skip_ioapic_setup)
-		return -1;
-
-	ioapic = mp_find_ioapic(gsi);
-	if (ioapic < 0)
-		return -1;
-
-	pin = mp_find_ioapic_pin(ioapic, gsi);
-	if (pin < 0)
-		return -1;
-
-	idx = find_irq_entry(ioapic, pin, mp_INT);
-	if (idx < 0)
-		return -1;
-
-	*trigger = irq_trigger(idx);
-	*polarity = irq_polarity(idx);
-	return 0;
-}
-
 /*
  * This function currently is only a helper for the i386 smp boot process where
  * we need to reprogram the ioredtbls to cater for the cpus which have come online
diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
index 0972315..941328d 100644
--- a/arch/x86/pci/acpi.c
+++ b/arch/x86/pci/acpi.c
@@ -70,6 +70,30 @@ void __init pci_acpi_crs_quirks(void)
 	       pci_use_crs ? "nocrs" : "use_crs");
 }
 
+int acpi_get_override_irq(u32 gsi, int *trigger, int *polarity)
+{
+	int ioapic, pin;
+
+	if (acpi_irq_model != ACPI_IRQ_MODEL_IOAPIC)
+		return -1;
+
+	if (skip_ioapic_setup)
+		return -1;
+
+	ioapic = mp_find_ioapic(gsi);
+	if (ioapic < 0)
+		return -1;
+
+	pin = mp_find_ioapic_pin(ioapic, gsi);
+	if (pin < 0)
+		return -1;
+
+	if (ioapic_get_irq(ioapic, pin, trigger, polarity) < 0)
+		return -1;
+
+	return 0;
+}
+
 static acpi_status
 resource_to_addr(struct acpi_resource *resource,
 			struct acpi_resource_address64 *addr)
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index a2e910e..82c03db 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -348,6 +348,12 @@ static inline int acpi_table_parse(char *id,
 {
 	return -1;
 }
+
+static inline int acpi_get_override_irq(u32 gsi, int *trigger, int *polarity)
+{
+	return -1;
+}
+
 #endif	/* !CONFIG_ACPI */
 
 #ifdef CONFIG_ACPI_SLEEP
-- 
1.7.4.1

