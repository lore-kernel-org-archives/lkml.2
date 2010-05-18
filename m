Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756849Ab0ERPZF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 11:25:05 -0400
Received: from www.tglx.de ([62.245.132.106]:49608 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756724Ab0ERPY7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 11:24:59 -0400
Date: Tue, 18 May 2010 17:24:12 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: [GIT Pull] hpet for 2.6.35
Message-ID: <alpine.LFD.2.00.1005181723120.3368@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest timers-for-linus-hpet git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timers-for-linus-hpet

Thanks,

	tglx

------------------>
Andreas Herrmann (1):
      x86, hpet: Add reference to chipset erratum documentation for disable-hpet-msi-quirk

Thomas Gleixner (1):
      x86, hpet: Restrict read back to affected ATI chipsets


 arch/x86/include/asm/hpet.h |    1 +
 arch/x86/kernel/hpet.c      |   29 +++++++++++++++++------------
 arch/x86/kernel/quirks.c    |    8 ++++++++
 3 files changed, 26 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/hpet.h b/arch/x86/include/asm/hpet.h
index 1d5c08a..004e6e2 100644
--- a/arch/x86/include/asm/hpet.h
+++ b/arch/x86/include/asm/hpet.h
@@ -68,6 +68,7 @@ extern unsigned long force_hpet_address;
 extern u8 hpet_blockid;
 extern int hpet_force_user;
 extern u8 hpet_msi_disable;
+extern u8 hpet_readback_cmp;
 extern int is_hpet_enabled(void);
 extern int hpet_enable(void);
 extern void hpet_disable(void);
diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 23b4ecd..a198b7c 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -36,6 +36,7 @@
 unsigned long				hpet_address;
 u8					hpet_blockid; /* OS timer block num */
 u8					hpet_msi_disable;
+u8					hpet_readback_cmp;
 
 #ifdef CONFIG_PCI_MSI
 static unsigned long			hpet_num_timers;
@@ -395,19 +396,23 @@ static int hpet_next_event(unsigned long delta,
 	 * at that point and we would wait for the next hpet interrupt
 	 * forever. We found out that reading the CMP register back
 	 * forces the transfer so we can rely on the comparison with
-	 * the counter register below. If the read back from the
-	 * compare register does not match the value we programmed
-	 * then we might have a real hardware problem. We can not do
-	 * much about it here, but at least alert the user/admin with
-	 * a prominent warning.
-	 * An erratum on some chipsets (ICH9,..), results in comparator read
-	 * immediately following a write returning old value. Workaround
-	 * for this is to read this value second time, when first
-	 * read returns old value.
+	 * the counter register below.
+	 *
+	 * That works fine on those ATI chipsets, but on newer Intel
+	 * chipsets (ICH9...) this triggers due to an erratum: Reading
+	 * the comparator immediately following a write is returning
+	 * the old value.
+	 *
+	 * We restrict the read back to the affected ATI chipsets (set
+	 * by quirks) and also run it with hpet=verbose for debugging
+	 * purposes.
 	 */
-	if (unlikely((u32)hpet_readl(HPET_Tn_CMP(timer)) != cnt)) {
-		WARN_ONCE(hpet_readl(HPET_Tn_CMP(timer)) != cnt,
-		  KERN_WARNING "hpet: compare register read back failed.\n");
+	if (hpet_readback_cmp || hpet_verbose) {
+		u32 cmp = hpet_readl(HPET_Tn_CMP(timer));
+
+		if (cmp != cnt)
+			printk_once(KERN_WARNING
+			    "hpet: compare register read back failed.\n");
 	}
 
 	return (s32)(hpet_readl(HPET_COUNTER) - cnt) >= 0 ? -ETIME : 0;
diff --git a/arch/x86/kernel/quirks.c b/arch/x86/kernel/quirks.c
index 12e9fea..e72d3fc 100644
--- a/arch/x86/kernel/quirks.c
+++ b/arch/x86/kernel/quirks.c
@@ -495,10 +495,18 @@ void force_hpet_resume(void)
 /*
  * HPET MSI on some boards (ATI SB700/SB800) has side effect on
  * floppy DMA. Disable HPET MSI on such platforms.
+ * See erratum #27 (Misinterpreted MSI Requests May Result in
+ * Corrupted LPC DMA Data) in AMD Publication #46837,
+ * "SB700 Family Product Errata", Rev. 1.0, March 2010.
+ *
+ * Also force the read back of the CMP register in hpet_next_event()
+ * to work around the problem that the CMP register write seems to be
+ * delayed. See hpet_next_event() for details.
  */
 static void force_disable_hpet_msi(struct pci_dev *unused)
 {
 	hpet_msi_disable = 1;
+	hpet_readback_cmp = 1;
 }
 
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_SBX00_SMBUS,
