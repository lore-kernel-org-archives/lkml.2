Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756804Ab2ERPms (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 11:42:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52168 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755906Ab2ERPmq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 11:42:46 -0400
Date: Fri, 18 May 2012 17:42:37 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 2/3] x86: x2apic/cluster: Make use of lowest priority
 delivery mode
Message-ID: <20120518154236.GA23406@dhcp-26-207.brq.redhat.com>
References: <20120518102640.GB31517@dhcp-26-207.brq.redhat.com>
 <20120518144153.GD8455@moon>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="xgyAXRrhYN0wYx8y"
Content-Disposition: inline
In-Reply-To: <20120518144153.GD8455@moon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xgyAXRrhYN0wYx8y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 18, 2012 at 06:41:53PM +0400, Cyrill Gorcunov wrote:
> On Fri, May 18, 2012 at 12:26:41PM +0200, Alexander Gordeev wrote:
> > Currently x2APIC in logical destination mode delivers interrupts to a
> > single CPU, no matter how many CPUs were specified in the destination
> > cpumask.
> > 
> > This fix enables delivery of interrupts to multiple CPUs by bit-ORing
> > Logical IDs of destination CPUs that have matching Cluster ID.
> > 
> > Because only one cluster could be specified in a message destination
> > address, the destination cpumask is tried for a cluster that contains
> > maximum number of CPUs matching this cpumask. The CPUs in this cluster
> > are selected to receive the interrupts while all other CPUs (in the
> > cpumask) are ignored.
> 
> Hi Alexander,
> 
> I'm a bit confused, we do compose destination id from target cpumask
> and send one ipi per _cluster_ with all cpus belonging to this cluster
> OR'ed. So if my memory doesn't betray me all specified cpus in cluster
> should obtain this message. Thus I'm wondering where do you find that
> only one apic obtains ipi? (note i don't have the real physical
> machine with x2apic enabled handy to test, so please share
> the experience).

Cyrill,

This patchset is not about IPIs at all. It is about interrupts coming from
IO-APICs.

I.e. if you check /proc/interrups for some IR-IO-APIC you will notice that just
a single (first found) CPU receives the interrupts, even though the
corresponding /proc/irq/<irq#>/smp_affinity would specify multiple CPUs.

Given the current design it is unavoidable in physical destination mode (well,
as long as we do not broadcast, which I did not try yet). But it is well
avoidable in clustered logical addressing mode + lowest priority delivery mode.

I am attaching my debugging patchses so you could check actual values of ITREs.

> 
> 	Cyrill

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com

--xgyAXRrhYN0wYx8y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0001-x86-io-apic-Dump-IO-APICs-to-sys-kernel-ioapic.patch"

>From a9feb660a6a5e860052f9f2a86bfeced3faaa283 Mon Sep 17 00:00:00 2001
From: Alexander Gordeev <agordeev@redhat.com>
Date: Mon, 7 May 2012 12:55:12 -0400
Subject: [PATCH 1/3] x86: io-apic: Dump IO-APICs to /sys/kernel/ioapic

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 arch/x86/kernel/apic/io_apic.c |  160 ++++++++++++++++++++++++++++++++++++++++
 kernel/ksysfs.c                |   31 ++++++++
 2 files changed, 191 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index e88300d..3b78a50 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1618,6 +1618,166 @@ static void __init setup_timer_IRQ0_pin(unsigned int ioapic_idx,
 	ioapic_write_entry(ioapic_idx, pin, entry);
 }
 
+int sprintf_IO_APIC(char *p, int ioapic_idx)
+{
+	int i;
+	union IO_APIC_reg_00 reg_00;
+	union IO_APIC_reg_01 reg_01;
+	union IO_APIC_reg_02 reg_02;
+	union IO_APIC_reg_03 reg_03;
+	unsigned long flags;
+	char *buf = p;
+
+	raw_spin_lock_irqsave(&ioapic_lock, flags);
+	reg_00.raw = io_apic_read(ioapic_idx, 0);
+	reg_01.raw = io_apic_read(ioapic_idx, 1);
+	if (reg_01.bits.version >= 0x10)
+		reg_02.raw = io_apic_read(ioapic_idx, 2);
+	if (reg_01.bits.version >= 0x20)
+		reg_03.raw = io_apic_read(ioapic_idx, 3);
+	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
+
+	p += sprintf(p, "IO APIC #%d......\n", mpc_ioapic_id(ioapic_idx));
+	p += sprintf(p, ".... register #00: %08X\n", reg_00.raw);
+	p += sprintf(p, ".......    : physical APIC id: %02X\n", reg_00.bits.ID);
+	p += sprintf(p, ".......    : Delivery Type: %X\n", reg_00.bits.delivery_type);
+	p += sprintf(p, ".......    : LTS          : %X\n", reg_00.bits.LTS);
+
+	p += sprintf(p, ".... register #01: %08X\n", *(int *)&reg_01);
+	p += sprintf(p, ".......     : max redirection entries: %02X\n",
+		reg_01.bits.entries);
+
+	p += sprintf(p, ".......     : PRQ implemented: %X\n", reg_01.bits.PRQ);
+	p += sprintf(p, ".......     : IO APIC version: %02X\n",
+		reg_01.bits.version);
+
+	/*
+	 * Some Intel chipsets with IO APIC VERSION of 0x1? don't have reg_02,
+	 * but the value of reg_02 is read as the previous read register
+	 * value, so ignore it if reg_02 == reg_01.
+	 */
+	if (reg_01.bits.version >= 0x10 && reg_02.raw != reg_01.raw) {
+		p += sprintf(p, ".... register #02: %08X\n", reg_02.raw);
+		p += sprintf(p, ".......     : arbitration: %02X\n", reg_02.bits.arbitration);
+	}
+
+	/*
+	 * Some Intel chipsets with IO APIC VERSION of 0x2? don't have reg_02
+	 * or reg_03, but the value of reg_0[23] is read as the previous read
+	 * register value, so ignore it if reg_03 == reg_0[12].
+	 */
+	if (reg_01.bits.version >= 0x20 && reg_03.raw != reg_02.raw &&
+	    reg_03.raw != reg_01.raw) {
+		p += sprintf(p, ".... register #03: %08X\n", reg_03.raw);
+		p += sprintf(p, ".......     : Boot DT    : %X\n", reg_03.bits.boot_DT);
+	}
+
+	p += sprintf(p, ".... IRQ redirection table:\n");
+
+	if (intr_remapping_enabled) {
+		p += sprintf(p, " NR Indx Fmt Mask Trig IRR"
+			" Pol Stat Indx2 Zero Vect:\n");
+	} else {
+		p += sprintf(p, " NR Dst Mask Trig IRR Pol"
+			" Stat Dmod Deli Vect:\n");
+	}
+
+	for (i = 0; i <= reg_01.bits.entries; i++) {
+		if (intr_remapping_enabled) {
+			struct IO_APIC_route_entry entry;
+			struct IR_IO_APIC_route_entry *ir_entry;
+
+			entry = ioapic_read_entry(ioapic_idx, i);
+			ir_entry = (struct IR_IO_APIC_route_entry *) &entry;
+			p += sprintf(p, " %02x %04X ",
+				i,
+				ir_entry->index
+			);
+			p += sprintf(p, "%1d   %1d    %1d    %1d   %1d   "
+				"%1d    %1d     %X    %02X\n",
+				ir_entry->format,
+				ir_entry->mask,
+				ir_entry->trigger,
+				ir_entry->irr,
+				ir_entry->polarity,
+				ir_entry->delivery_status,
+				ir_entry->index2,
+				ir_entry->zero,
+				ir_entry->vector
+			);
+		} else {
+			struct IO_APIC_route_entry entry;
+
+			entry = ioapic_read_entry(ioapic_idx, i);
+			p += sprintf(p, " %02x %02X  ",
+				i,
+				entry.dest
+			);
+			p += sprintf(p, "%1d    %1d    %1d   %1d   %1d    "
+				"%1d    %1d    %02X\n",
+				entry.mask,
+				entry.trigger,
+				entry.irr,
+				entry.polarity,
+				entry.delivery_status,
+				entry.dest_mode,
+				entry.delivery_mode,
+				entry.vector
+			);
+		}
+	}
+
+	return p - buf;
+}
+
+int sprintf_IO_APICs(char *p)
+{
+	int ioapic_idx;
+	struct irq_cfg *cfg;
+	unsigned int irq;
+	struct irq_chip *chip;
+	char *buf = p;
+
+	p += sprintf(p, "number of MP IRQ sources: %d.\n", mp_irq_entries);
+	for (ioapic_idx = 0; ioapic_idx < nr_ioapics; ioapic_idx++)
+		p += sprintf(p, "number of IO-APIC #%d registers: %d.\n",
+		       mpc_ioapic_id(ioapic_idx),
+		       ioapics[ioapic_idx].nr_registers);
+
+	/*
+	 * We are a bit conservative about what we expect.  We have to
+	 * know about every hardware change ASAP.
+	 */
+	p += sprintf(p, "testing the IO APIC.......................\n");
+
+	for (ioapic_idx = 0; ioapic_idx < nr_ioapics; ioapic_idx++)
+		p += sprintf_IO_APIC(p, ioapic_idx);
+
+	p += sprintf(p, "IRQ to pin mappings:\n");
+	for_each_active_irq(irq) {
+		struct irq_pin_list *entry;
+
+		chip = irq_get_chip(irq);
+		if (chip != &ioapic_chip)
+			continue;
+
+		cfg = irq_get_chip_data(irq);
+		if (!cfg)
+			continue;
+		entry = cfg->irq_2_pin;
+		if (!entry)
+			continue;
+		p += sprintf(p, "IRQ%d ", irq);
+		for_each_irq_pin(entry, cfg->irq_2_pin)
+			p += sprintf(p, "-> %d:%d", entry->apic, entry->pin);
+		p += sprintf(p, "\n");
+	}
+
+	p += sprintf(p, ".................................... done.\n");
+
+	return p - buf;
+}
+
 __apicdebuginit(void) print_IO_APIC(int ioapic_idx)
 {
 	int i;
diff --git a/kernel/ksysfs.c b/kernel/ksysfs.c
index 4e316e1..85df7bb 100644
--- a/kernel/ksysfs.c
+++ b/kernel/ksysfs.c
@@ -141,6 +141,34 @@ static ssize_t fscaps_show(struct kobject *kobj,
 }
 KERNEL_ATTR_RO(fscaps);
 
+#ifdef CONFIG_X86_IO_APIC
+
+extern int sprintf_IO_APICs(char *p);
+
+static ssize_t ioapic_show(struct kobject *kobj,
+				       struct kobj_attribute *attr, char *buf)
+{
+	return sprintf_IO_APICs(buf);
+}
+static ssize_t ioapic_store(struct kobject *kobj,
+				   struct kobj_attribute *attr,
+				   const char *buf, size_t count)
+{
+	return -EINVAL;
+/*
+	unsigned long cnt;
+	int ret;
+
+	if (strict_strtoul(buf, 0, &cnt))
+		return -EINVAL;
+
+	ret = crash_shrink_memory(cnt);
+	return ret < 0 ? ret : count;
+*/
+}
+KERNEL_ATTR_RW(ioapic);
+#endif
+
 /*
  * Make /sys/kernel/notes give the raw contents of our kernel .notes section.
  */
@@ -182,6 +210,9 @@ static struct attribute * kernel_attrs[] = {
 	&kexec_crash_size_attr.attr,
 	&vmcoreinfo_attr.attr,
 #endif
+#ifdef CONFIG_X86_IO_APIC
+	&ioapic_attr.attr,
+#endif
 	NULL
 };
 
-- 
1.7.6.5


--xgyAXRrhYN0wYx8y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0002-x86-intremap-Fix-get_irte-NULL-pointer-assignment.patch"

>From ac8d07e4bb93ac25582cf117735b0896347b7df7 Mon Sep 17 00:00:00 2001
From: Alexander Gordeev <agordeev@redhat.com>
Date: Wed, 9 May 2012 10:45:52 -0400
Subject: [PATCH 2/3] x86: intremap: Fix get_irte() NULL-pointer assignment

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 drivers/iommu/intr_remapping.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/iommu/intr_remapping.c b/drivers/iommu/intr_remapping.c
index 6777ca0..adb0818 100644
--- a/drivers/iommu/intr_remapping.c
+++ b/drivers/iommu/intr_remapping.c
@@ -68,7 +68,7 @@ int get_irte(int irq, struct irte *entry)
 	unsigned long flags;
 	int index;
 
-	if (!entry || !irq_iommu)
+	if (!entry || !irq_iommu || !irq_iommu->iommu)
 		return -1;
 
 	raw_spin_lock_irqsave(&irq_2_ir_lock, flags);
-- 
1.7.6.5


--xgyAXRrhYN0wYx8y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0003-x86-intremap-Dump-IRTEs-to-sys-kernel-intremap.patch"

>From 62d026842357ffdee3397fd5d9f38b68bebc3f0b Mon Sep 17 00:00:00 2001
From: Alexander Gordeev <agordeev@redhat.com>
Date: Wed, 9 May 2012 07:48:53 -0400
Subject: [PATCH 3/3] x86: intremap: Dump IRTEs to /sys/kernel/intremap

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 drivers/iommu/intr_remapping.c |   26 ++++++++++++++++++++++++++
 kernel/ksysfs.c                |   29 +++++++++++++++++++----------
 2 files changed, 45 insertions(+), 10 deletions(-)

diff --git a/drivers/iommu/intr_remapping.c b/drivers/iommu/intr_remapping.c
index adb0818..541dc33 100644
--- a/drivers/iommu/intr_remapping.c
+++ b/drivers/iommu/intr_remapping.c
@@ -832,3 +832,29 @@ error:
 	return -1;
 }
 
+int sprintf_IRTE(char *p, int irq, const struct irte *irte)
+{
+	char *buf = p;
+
+	p += sprintf(p, "%4d: %1d   %1d  %1d  %1d  %1d %03X %03X %04X.%04X %04X  %1d   %1d\n", irq, irte->present, irte->fpd, irte->dst_mode, irte->redir_hint, irte->trigger_mode, irte->dlvry_mode, irte->vector, (irte->dest_id >> 16) & 0xFFFF, irte->dest_id & 0xFFFF, irte->sid, irte->sq, irte->svt);
+
+	return p - buf;
+}
+
+int sprintf_IRTEs(char *p)
+{
+	int irq;
+	struct irte irte;
+	char *buf = p;
+
+	p += sprintf(p, "IRQ#: P FPD DM RH TM DLM VEC --Dest-ID -SID SQ SVT\n");
+
+	for_each_active_irq(irq) {
+		if (get_irte(irq, &irte))
+			continue;
+		p += sprintf_IRTE(p, irq, &irte);
+	}
+
+	return p - buf;
+}
+
diff --git a/kernel/ksysfs.c b/kernel/ksysfs.c
index 85df7bb..be4e035 100644
--- a/kernel/ksysfs.c
+++ b/kernel/ksysfs.c
@@ -142,7 +142,6 @@ static ssize_t fscaps_show(struct kobject *kobj,
 KERNEL_ATTR_RO(fscaps);
 
 #ifdef CONFIG_X86_IO_APIC
-
 extern int sprintf_IO_APICs(char *p);
 
 static ssize_t ioapic_show(struct kobject *kobj,
@@ -155,18 +154,25 @@ static ssize_t ioapic_store(struct kobject *kobj,
 				   const char *buf, size_t count)
 {
 	return -EINVAL;
-/*
-	unsigned long cnt;
-	int ret;
+}
+KERNEL_ATTR_RW(ioapic);
+#endif
 
-	if (strict_strtoul(buf, 0, &cnt))
-		return -EINVAL;
+#ifdef CONFIG_IRQ_REMAP
+extern int sprintf_IRTEs(char *p);
 
-	ret = crash_shrink_memory(cnt);
-	return ret < 0 ? ret : count;
-*/
+static ssize_t intremap_show(struct kobject *kobj,
+				       struct kobj_attribute *attr, char *buf)
+{
+	return sprintf_IRTEs(buf);
 }
-KERNEL_ATTR_RW(ioapic);
+static ssize_t intremap_store(struct kobject *kobj,
+				   struct kobj_attribute *attr,
+				   const char *buf, size_t count)
+{
+	return -EINVAL;
+}
+KERNEL_ATTR_RW(intremap);
 #endif
 
 /*
@@ -213,6 +219,9 @@ static struct attribute * kernel_attrs[] = {
 #ifdef CONFIG_X86_IO_APIC
 	&ioapic_attr.attr,
 #endif
+#ifdef CONFIG_IRQ_REMAP
+	&intremap_attr.attr,
+#endif
 	NULL
 };
 
-- 
1.7.6.5


--xgyAXRrhYN0wYx8y--
