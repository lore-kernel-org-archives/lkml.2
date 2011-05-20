Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934399Ab1ETNkc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 09:40:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:36068 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933911Ab1ETNk0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 09:40:26 -0400
Date: Fri, 20 May 2011 13:40:05 GMT
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Message-ID: <tip-c040aaeb86f66e956e147ce5f238d28308e06109@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        suresh.b.siddha@intel.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        suresh.b.siddha@intel.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110518233157.994002011@sbsiddha-MOBL3.sc.intel.com>
References: <20110518233157.994002011@sbsiddha-MOBL3.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, ioapic: Consolidate gsi routing info into 'struct ioapic'
Git-Commit-ID: c040aaeb86f66e956e147ce5f238d28308e06109
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 20 May 2011 13:40:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c040aaeb86f66e956e147ce5f238d28308e06109
Gitweb:     http://git.kernel.org/tip/c040aaeb86f66e956e147ce5f238d28308e06109
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Wed, 18 May 2011 16:31:38 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 20 May 2011 13:41:01 +0200

x86, ioapic: Consolidate gsi routing info into 'struct ioapic'

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: daniel.blueman@gmail.com
Link: http://lkml.kernel.org/r/20110518233157.994002011@sbsiddha-MOBL3.sc.intel.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/io_apic.h |    1 +
 arch/x86/kernel/apic/io_apic.c |   38 +++++++++++++++++++++++++-------------
 arch/x86/kernel/devicetree.c   |    4 +++-
 3 files changed, 29 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 4f07bf6..690d1cc 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -108,6 +108,7 @@ extern int nr_ioapics;
 
 extern int mpc_ioapic_id(int ioapic);
 extern unsigned int mpc_ioapic_addr(int ioapic);
+extern struct mp_ioapic_gsi *mp_ioapic_gsi_routing(int ioapic);
 
 #define MP_MAX_IOAPIC_PIN 127
 
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index e911315..b7dd233 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -87,6 +87,8 @@ static struct ioapic {
 	struct IO_APIC_route_entry *saved_registers;
 	/* I/O APIC config */
 	struct mpc_ioapic mp_config;
+	/* IO APIC gsi routing info */
+	struct mp_ioapic_gsi  gsi_config;
 } ioapics[MAX_IO_APICS];
 
 #define mpc_ioapic_ver(id)		ioapics[id].mp_config.apicver
@@ -101,10 +103,12 @@ unsigned int mpc_ioapic_addr(int id)
 	return ioapics[id].mp_config.apicaddr;
 }
 
-int nr_ioapics;
+struct mp_ioapic_gsi *mp_ioapic_gsi_routing(int id)
+{
+	return &ioapics[id].gsi_config;
+}
 
-/* IO APIC gsi routing info */
-struct mp_ioapic_gsi  mp_gsi_routing[MAX_IO_APICS];
+int nr_ioapics;
 
 /* The one past the highest gsi number used */
 u32 gsi_top;
@@ -924,6 +928,7 @@ static int pin_2_irq(int idx, int apic, int pin)
 {
 	int irq;
 	int bus = mp_irqs[idx].srcbus;
+	struct mp_ioapic_gsi *gsi_cfg = mp_ioapic_gsi_routing(apic);
 
 	/*
 	 * Debugging check, we are in big trouble if this message pops up!
@@ -934,7 +939,7 @@ static int pin_2_irq(int idx, int apic, int pin)
 	if (test_bit(bus, mp_bus_not_pci)) {
 		irq = mp_irqs[idx].srcbusirq;
 	} else {
-		u32 gsi = mp_gsi_routing[apic].gsi_base + pin;
+		u32 gsi = gsi_cfg->gsi_base + pin;
 
 		if (gsi >= NR_IRQS_LEGACY)
 			irq = gsi;
@@ -3898,8 +3903,9 @@ int mp_find_ioapic(u32 gsi)
 
 	/* Find the IOAPIC that manages this GSI. */
 	for (i = 0; i < nr_ioapics; i++) {
-		if ((gsi >= mp_gsi_routing[i].gsi_base)
-		    && (gsi <= mp_gsi_routing[i].gsi_end))
+		struct mp_ioapic_gsi *gsi_cfg = mp_ioapic_gsi_routing(i);
+		if ((gsi >= gsi_cfg->gsi_base)
+		    && (gsi <= gsi_cfg->gsi_end))
 			return i;
 	}
 
@@ -3909,12 +3915,16 @@ int mp_find_ioapic(u32 gsi)
 
 int mp_find_ioapic_pin(int ioapic, u32 gsi)
 {
+	struct mp_ioapic_gsi *gsi_cfg;
+
 	if (WARN_ON(ioapic == -1))
 		return -1;
-	if (WARN_ON(gsi > mp_gsi_routing[ioapic].gsi_end))
+
+	gsi_cfg = mp_ioapic_gsi_routing(ioapic);
+	if (WARN_ON(gsi > gsi_cfg->gsi_end))
 		return -1;
 
-	return gsi - mp_gsi_routing[ioapic].gsi_base;
+	return gsi - gsi_cfg->gsi_base;
 }
 
 static __init int bad_ioapic(unsigned long address)
@@ -3936,6 +3946,7 @@ void __init mp_register_ioapic(int id, u32 address, u32 gsi_base)
 {
 	int idx = 0;
 	int entries;
+	struct mp_ioapic_gsi *gsi_cfg;
 
 	if (bad_ioapic(address))
 		return;
@@ -3955,21 +3966,22 @@ void __init mp_register_ioapic(int id, u32 address, u32 gsi_base)
 	 * and to prevent reprogramming of IOAPIC pins (PCI GSIs).
 	 */
 	entries = io_apic_get_redir_entries(idx);
-	mp_gsi_routing[idx].gsi_base = gsi_base;
-	mp_gsi_routing[idx].gsi_end = gsi_base + entries - 1;
+	gsi_cfg = mp_ioapic_gsi_routing(idx);
+	gsi_cfg->gsi_base = gsi_base;
+	gsi_cfg->gsi_end = gsi_base + entries - 1;
 
 	/*
 	 * The number of IO-APIC IRQ registers (== #pins):
 	 */
 	ioapics[idx].nr_registers = entries;
 
-	if (mp_gsi_routing[idx].gsi_end >= gsi_top)
-		gsi_top = mp_gsi_routing[idx].gsi_end + 1;
+	if (gsi_cfg->gsi_end >= gsi_top)
+		gsi_top = gsi_cfg->gsi_end + 1;
 
 	printk(KERN_INFO "IOAPIC[%d]: apic_id %d, version %d, address 0x%x, "
 	       "GSI %d-%d\n", idx, mpc_ioapic_id(idx),
 	       mpc_ioapic_ver(idx), mpc_ioapic_addr(idx),
-	       mp_gsi_routing[idx].gsi_base, mp_gsi_routing[idx].gsi_end);
+	       gsi_cfg->gsi_base, gsi_cfg->gsi_end);
 
 	nr_ioapics++;
 }
diff --git a/arch/x86/kernel/devicetree.c b/arch/x86/kernel/devicetree.c
index f06494e..690bc84 100644
--- a/arch/x86/kernel/devicetree.c
+++ b/arch/x86/kernel/devicetree.c
@@ -369,6 +369,7 @@ static struct of_ioapic_type of_ioapic_type[] =
 static int ioapic_xlate(struct irq_domain *id, const u32 *intspec, u32 intsize,
 			u32 *out_hwirq, u32 *out_type)
 {
+	struct mp_ioapic_gsi *gsi_cfg;
 	struct io_apic_irq_attr attr;
 	struct of_ioapic_type *it;
 	u32 line, idx, type;
@@ -378,7 +379,8 @@ static int ioapic_xlate(struct irq_domain *id, const u32 *intspec, u32 intsize,
 
 	line = *intspec;
 	idx = (u32) id->priv;
-	*out_hwirq = line + mp_gsi_routing[idx].gsi_base;
+	gsi_cfg = mp_ioapic_gsi_routing(idx);
+	*out_hwirq = line + gsi_cfg->gsi_base;
 
 	intspec++;
 	type = *intspec;
