Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757349Ab0LIU51 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 15:57:27 -0500
Received: from hera.kernel.org ([140.211.167.34]:35023 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753708Ab0LIU5Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 15:57:24 -0500
Date: Thu, 9 Dec 2010 20:57:09 GMT
From: tip-bot for Feng Tang <feng.tang@intel.com>
Cc: linux-kernel@vger.kernel.org, alan@linux.intel.com, hpa@zytor.com,
        mingo@redhat.com, yinghai@kernel.org, feng.tang@linux.intel.com,
        tglx@linutronix.de, feng.tang@intel.com, len.brown@intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, alan@linux.intel.com,
        linux-kernel@vger.kernel.org, feng.tang@linux.intel.com,
        yinghai@kernel.org, tglx@linutronix.de, feng.tang@intel.com,
        len.brown@intel.com
In-Reply-To: <20101208151857.212f0018@feng-i7>
References: <20101208151857.212f0018@feng-i7>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic-cleanups] x86: Further simplify mp_irq info handling
Message-ID: <tip-0e3fa13f4ee110de007bca3bf395b77997319fc8@git.kernel.org>
Git-Commit-ID: 0e3fa13f4ee110de007bca3bf395b77997319fc8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 09 Dec 2010 20:57:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0e3fa13f4ee110de007bca3bf395b77997319fc8
Gitweb:     http://git.kernel.org/tip/0e3fa13f4ee110de007bca3bf395b77997319fc8
Author:     Feng Tang <feng.tang@intel.com>
AuthorDate: Wed, 8 Dec 2010 15:18:57 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 9 Dec 2010 21:52:06 +0100

x86: Further simplify mp_irq info handling

assign_to_mp_irq() is copying the struct mpc_intsrc members one by
one. That's silly. Use memcpy() and let the compiler figure it out.
Same for the identical function assign_to_mpc_intsrc()

mp_irq_mpc_intsrc_cmp() is comparing the struct members one by one,
but no caller ever checks the different return codes. Use memcmp()
instead.

Remove the extra printk in MP_ioapic_info()

Signed-off-by: Feng Tang <feng.tang@linux.intel.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: "Alan Cox <alan@linux.intel.com>
Cc: Len Brown <len.brown@intel.com>
LKML-Reference: <20101208151857.212f0018@feng-i7>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 arch/x86/kernel/apic/io_apic.c |   37 ++-----------------------------------
 arch/x86/kernel/mpparse.c      |   38 ++++++--------------------------------
 2 files changed, 8 insertions(+), 67 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index c6b44f7..bb61a55 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -126,39 +126,6 @@ static int __init parse_noapic(char *str)
 }
 early_param("noapic", parse_noapic);
 
-static void assign_to_mp_irq(struct mpc_intsrc *m,
-				    struct mpc_intsrc *mp_irq)
-{
-	mp_irq->dstapic = m->dstapic;
-	mp_irq->type = m->type;
-	mp_irq->irqtype = m->irqtype;
-	mp_irq->irqflag = m->irqflag;
-	mp_irq->srcbus = m->srcbus;
-	mp_irq->srcbusirq = m->srcbusirq;
-	mp_irq->dstirq = m->dstirq;
-}
-
-static int mp_irq_mpc_intsrc_cmp(struct mpc_intsrc *mp_irq,
-					struct mpc_intsrc *m)
-{
-	if (mp_irq->dstapic != m->dstapic)
-		return 1;
-	if (mp_irq->type != m->type)
-		return 2;
-	if (mp_irq->irqtype != m->irqtype)
-		return 3;
-	if (mp_irq->irqflag != m->irqflag)
-		return 4;
-	if (mp_irq->srcbus != m->srcbus)
-		return 5;
-	if (mp_irq->srcbusirq != m->srcbusirq)
-		return 6;
-	if (mp_irq->dstirq != m->dstirq)
-		return 7;
-
-	return 0;
-}
-
 /* Will be called in mpparse/acpi/sfi codes for saving IRQ info */
 void mp_save_irq(struct mpc_intsrc *m)
 {
@@ -170,11 +137,11 @@ void mp_save_irq(struct mpc_intsrc *m)
 		m->srcbusirq, m->dstapic, m->dstirq);
 
 	for (i = 0; i < mp_irq_entries; i++) {
-		if (!mp_irq_mpc_intsrc_cmp(&mp_irqs[i], m))
+		if (!memcmp(&mp_irqs[i], m, sizeof(*m)))
 			return;
 	}
 
-	assign_to_mp_irq(m, &mp_irqs[mp_irq_entries]);
+	memcpy(&mp_irqs[mp_irq_entries], m, sizeof(*m));
 	if (++mp_irq_entries == MAX_IRQ_SOURCES)
 		panic("Max # of irq sources exceeded!!\n");
 }
diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index 4318687..01b0f6d 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -118,21 +118,8 @@ static void __init MP_bus_info(struct mpc_bus *m)
 
 static void __init MP_ioapic_info(struct mpc_ioapic *m)
 {
-	if (!(m->flags & MPC_APIC_USABLE))
-		return;
-
-	printk(KERN_INFO "I/O APIC #%d Version %d at 0x%X.\n",
-	       m->apicid, m->apicver, m->apicaddr);
-
-	mp_register_ioapic(m->apicid, m->apicaddr, gsi_top);
-}
-
-static void print_MP_intsrc_info(struct mpc_intsrc *m)
-{
-	apic_printk(APIC_VERBOSE, "Int: type %d, pol %d, trig %d, bus %02x,"
-		" IRQ %02x, APIC ID %x, APIC INT %02x\n",
-		m->irqtype, m->irqflag & 3, (m->irqflag >> 2) & 3, m->srcbus,
-		m->srcbusirq, m->dstapic, m->dstirq);
+	if (m->flags & MPC_APIC_USABLE)
+		mp_register_ioapic(m->apicid, m->apicaddr, gsi_top);
 }
 
 static void __init print_mp_irq_info(struct mpc_intsrc *mp_irq)
@@ -144,23 +131,11 @@ static void __init print_mp_irq_info(struct mpc_intsrc *mp_irq)
 		mp_irq->srcbusirq, mp_irq->dstapic, mp_irq->dstirq);
 }
 
-static void __init assign_to_mpc_intsrc(struct mpc_intsrc *mp_irq,
-					struct mpc_intsrc *m)
-{
-	m->dstapic = mp_irq->dstapic;
-	m->type = mp_irq->type;
-	m->irqtype = mp_irq->irqtype;
-	m->irqflag = mp_irq->irqflag;
-	m->srcbus = mp_irq->srcbus;
-	m->srcbusirq = mp_irq->srcbusirq;
-	m->dstirq = mp_irq->dstirq;
-}
 #else /* CONFIG_X86_IO_APIC */
 static inline void __init MP_bus_info(struct mpc_bus *m) {}
 static inline void __init MP_ioapic_info(struct mpc_ioapic *m) {}
 #endif /* CONFIG_X86_IO_APIC */
 
-
 static void __init MP_lintsrc_info(struct mpc_lintsrc *m)
 {
 	apic_printk(APIC_VERBOSE, "Lint: type %d, pol %d, trig %d, bus %02x,"
@@ -172,7 +147,6 @@ static void __init MP_lintsrc_info(struct mpc_lintsrc *m)
 /*
  * Read/parse the MPC
  */
-
 static int __init smp_check_mpc(struct mpc_table *mpc, char *oem, char *str)
 {
 
@@ -718,11 +692,11 @@ static void __init check_irq_src(struct mpc_intsrc *m, int *nr_m_spare)
 	int i;
 
 	apic_printk(APIC_VERBOSE, "OLD ");
-	print_MP_intsrc_info(m);
+	print_mp_irq_info(m);
 
 	i = get_MP_intsrc_index(m);
 	if (i > 0) {
-		assign_to_mpc_intsrc(&mp_irqs[i], m);
+		memcpy(m, &mp_irqs[i], sizeof(*m));
 		apic_printk(APIC_VERBOSE, "NEW ");
 		print_mp_irq_info(&mp_irqs[i]);
 		return;
@@ -809,14 +783,14 @@ static int  __init replace_intsrc_all(struct mpc_table *mpc,
 		if (nr_m_spare > 0) {
 			apic_printk(APIC_VERBOSE, "*NEW* found\n");
 			nr_m_spare--;
-			assign_to_mpc_intsrc(&mp_irqs[i], m_spare[nr_m_spare]);
+			memcpy(m_spare[nr_m_spare], &mp_irqs[i], sizeof(mp_irqs[i]));
 			m_spare[nr_m_spare] = NULL;
 		} else {
 			struct mpc_intsrc *m = (struct mpc_intsrc *)mpt;
 			count += sizeof(struct mpc_intsrc);
 			if (check_slot(mpc_new_phys, mpc_new_length, count) < 0)
 				goto out;
-			assign_to_mpc_intsrc(&mp_irqs[i], m);
+			memcpy(m, &mp_irqs[i], sizeof(*m));
 			mpc->length = count;
 			mpt += sizeof(struct mpc_intsrc);
 		}
