Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933882Ab2C2UMM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 16:12:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29499 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933851Ab2C2ULp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 16:11:45 -0400
From: Don Zickus <dzickus@redhat.com>
To: <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        thomas.mingarelli@hp.com, Don Zickus <dzickus@redhat.com>
Subject: [PATCH 2/3] x86, nmi: Add new NMI queues to deal with IO_CHK and SERR
Date: Thu, 29 Mar 2012 16:11:16 -0400
Message-Id: <1333051877-15755-3-git-send-email-dzickus@redhat.com>
In-Reply-To: <1333051877-15755-1-git-send-email-dzickus@redhat.com>
References: <1333051877-15755-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In discussions with Thomas Mingarelli about hpwdt, he explained to me some
issues they were some when using their virtual NMI button to test the
hpwdt driver.

It turns out the virtual NMI button used on HP's machines do no send
unknown NMIs but instead send IO_CHK NMIs.  The way the kernel code
is written, the hpwdt driver can not register itself against that type
of NMI and therefore can not successfully capture system information
before panic'ing.

To solve this I created two new NMI queues to allow driver to register
against the IO_CHK and SERR NMIs.  Or in the hpwdt all three (if you
include unknown NMIs too).

The change is straightforward and just mimics what the unknown NMI does.

Reported-and-tested-by: Thomas Mingarelli <thomas.mingarelli@hp.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 arch/x86/include/asm/nmi.h |    2 ++
 arch/x86/kernel/nmi.c      |   18 ++++++++++++++++++
 drivers/watchdog/hpwdt.c   |   27 ++++++++++++++++++++-------
 3 files changed, 40 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/nmi.h b/arch/x86/include/asm/nmi.h
index fd3f9f1..07162df 100644
--- a/arch/x86/include/asm/nmi.h
+++ b/arch/x86/include/asm/nmi.h
@@ -27,6 +27,8 @@ void arch_trigger_all_cpu_backtrace(void);
 enum {
 	NMI_LOCAL=0,
 	NMI_UNKNOWN,
+	NMI_SERR,
+	NMI_IO_CHECK,
 	NMI_MAX
 };
 
diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index 47acaf3..ac9c1b7 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -54,6 +54,14 @@ static struct nmi_desc nmi_desc[NMI_MAX] =
 		.lock = __SPIN_LOCK_UNLOCKED(&nmi_desc[1].lock),
 		.head = LIST_HEAD_INIT(nmi_desc[1].head),
 	},
+	{
+		.lock = __SPIN_LOCK_UNLOCKED(&nmi_desc[2].lock),
+		.head = LIST_HEAD_INIT(nmi_desc[2].head),
+	},
+	{
+		.lock = __SPIN_LOCK_UNLOCKED(&nmi_desc[3].lock),
+		.head = LIST_HEAD_INIT(nmi_desc[3].head),
+	},
 
 };
 
@@ -120,6 +128,8 @@ static int __setup_nmi(unsigned int type, struct nmiaction *action)
 	 * to manage expectations
 	 */
 	WARN_ON_ONCE(type == NMI_UNKNOWN && !list_empty(&desc->head));
+	WARN_ON_ONCE(type == NMI_SERR && !list_empty(&desc->head));
+	WARN_ON_ONCE(type == NMI_IO_CHECK && !list_empty(&desc->head));
 
 	/*
 	 * some handlers need to be executed first otherwise a fake
@@ -212,6 +222,10 @@ EXPORT_SYMBOL_GPL(unregister_nmi_handler);
 static notrace __kprobes void
 pci_serr_error(unsigned char reason, struct pt_regs *regs)
 {
+	/* check to see if anyone registered against these types of errors */
+	if (nmi_handle(NMI_SERR, regs, false))
+		return;
+
 	pr_emerg("NMI: PCI system error (SERR) for reason %02x on CPU %d.\n",
 		 reason, smp_processor_id());
 
@@ -241,6 +255,10 @@ io_check_error(unsigned char reason, struct pt_regs *regs)
 {
 	unsigned long i;
 
+	/* check to see if anyone registered against these types of errors */
+	if (nmi_handle(NMI_IO_CHECK, regs, false))
+		return;
+
 	pr_emerg(
 	"NMI: IOCK error (debug interrupt?) for reason %02x on CPU %d.\n",
 		 reason, smp_processor_id());
diff --git a/drivers/watchdog/hpwdt.c b/drivers/watchdog/hpwdt.c
index deee02c8..e974c07 100644
--- a/drivers/watchdog/hpwdt.c
+++ b/drivers/watchdog/hpwdt.c
@@ -732,19 +732,32 @@ static int __devinit hpwdt_init_nmi_decoding(struct pci_dev *dev)
 	 * Only one function can register for NMI_UNKNOWN
 	 */
 	retval = register_nmi_handler(NMI_UNKNOWN, hpwdt_pretimeout, 0, "hpwdt");
-	if (retval != 0) {
-		dev_warn(&dev->dev,
-			"Unable to register a die notifier (err=%d).\n",
-			retval);
-		if (cru_rom_addr)
-			iounmap(cru_rom_addr);
-	}
+	if (retval)
+		goto error;
+	retval = register_nmi_handler(NMI_SERR, hpwdt_pretimeout, 0, "hpwdt");
+	if (retval)
+		goto error1;
+	retval = register_nmi_handler(NMI_IO_CHECK, hpwdt_pretimeout, 0, "hpwdt");
+	if (retval)
+		goto error2;
 
 	dev_info(&dev->dev,
 			"HP Watchdog Timer Driver: NMI decoding initialized"
 			", allow kernel dump: %s (default = 0/OFF)\n",
 			(allow_kdump == 0) ? "OFF" : "ON");
 	return 0;
+
+error2:
+	unregister_nmi_handler(NMI_SERR, "hpwdt");
+error1:
+	unregister_nmi_handler(NMI_UNKNOWN, "hpwdt");
+error:
+	dev_warn(&dev->dev,
+		"Unable to register a die notifier (err=%d).\n",
+		retval);
+	if (cru_rom_addr)
+		iounmap(cru_rom_addr);
+	return retval;
 }
 
 static void hpwdt_exit_nmi_decoding(void)
-- 
1.7.7.6

