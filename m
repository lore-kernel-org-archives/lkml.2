Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932140Ab0D2Bh0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 21:37:26 -0400
Received: from hera.kernel.org ([140.211.167.34]:50946 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932075Ab0D2BhX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 21:37:23 -0400
Date: Thu, 29 Apr 2010 01:36:56 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, venki@google.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, venki@google.com
In-Reply-To: <20100225185348.GA9674@linux-os.sc.intel.com>
References: <20100225185348.GA9674@linux-os.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/timers] x86, hpet: Restrict read back to affected ATI chipsets
Message-ID: <tip-30a564be9d9554c168a654eddc2165869cc0d7bf@git.kernel.org>
Git-Commit-ID: 30a564be9d9554c168a654eddc2165869cc0d7bf
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 29 Apr 2010 01:36:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  30a564be9d9554c168a654eddc2165869cc0d7bf
Gitweb:     http://git.kernel.org/tip/30a564be9d9554c168a654eddc2165869cc0d7bf
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Tue, 13 Apr 2010 15:31:36 +0200
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Wed, 28 Apr 2010 18:14:29 -0700

x86, hpet: Restrict read back to affected ATI chipsets

After programming the HPET, we do a readback as a workaround for
ATI/SBx00 chipsets as a synchronization.  Unfortunately this triggers
an erratum in newer ICH chipsets (ICH9+) where reading the comparator
immediately after the write returns the old value.  Furthermore, as
always, I/O reads are bad for performance.

Therefore, restrict the readback to the chipsets that need it, or, for
debugging purposes, when we are running with hpet=verbose.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Venkatesh Pallipadi <venki@google.com>
LKML-Reference: <20100225185348.GA9674@linux-os.sc.intel.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/hpet.h |    1 +
 arch/x86/kernel/hpet.c      |   29 +++++++++++++++++------------
 arch/x86/kernel/quirks.c    |    5 +++++
 3 files changed, 23 insertions(+), 12 deletions(-)

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
index 12e9fea..cd2c336 100644
--- a/arch/x86/kernel/quirks.c
+++ b/arch/x86/kernel/quirks.c
@@ -495,10 +495,15 @@ void force_hpet_resume(void)
 /*
  * HPET MSI on some boards (ATI SB700/SB800) has side effect on
  * floppy DMA. Disable HPET MSI on such platforms.
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
