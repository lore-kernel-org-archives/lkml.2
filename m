Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759209Ab2DYNzb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 09:55:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44560 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766Ab2DYNz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 09:55:29 -0400
Date: Wed, 25 Apr 2012 06:55:01 -0700
From: tip-bot for Don Zickus <dzickus@redhat.com>
Message-ID: <tip-553222f3e81f18da31b2552e18dc519715198590@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        thomas.mingarelli@hp.com, akpm@linux-foundation.org,
        tglx@linutronix.de, dzickus@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        peterz@infradead.org, thomas.mingarelli@hp.com, tglx@linutronix.de,
        dzickus@redhat.com
In-Reply-To: <1333051877-15755-3-git-send-email-dzickus@redhat.com>
References: <1333051877-15755-3-git-send-email-dzickus@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] x86/nmi:
  Add new NMI queues to deal with IO_CHK and SERR
Git-Commit-ID: 553222f3e81f18da31b2552e18dc519715198590
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 25 Apr 2012 06:55:06 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  553222f3e81f18da31b2552e18dc519715198590
Gitweb:     http://git.kernel.org/tip/553222f3e81f18da31b2552e18dc519715198590
Author:     Don Zickus <dzickus@redhat.com>
AuthorDate: Thu, 29 Mar 2012 16:11:16 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 25 Apr 2012 12:43:34 +0200

x86/nmi: Add new NMI queues to deal with IO_CHK and SERR

In discussions with Thomas Mingarelli about hpwdt, he explained
to me some issues they were some when using their virtual NMI
button to test the hpwdt driver.

It turns out the virtual NMI button used on HP's machines do no
send unknown NMIs but instead send IO_CHK NMIs.  The way the
kernel code is written, the hpwdt driver can not register itself
against that type of NMI and therefore can not successfully
capture system information before panic'ing.

To solve this I created two new NMI queues to allow driver to
register against the IO_CHK and SERR NMIs.  Or in the hpwdt all
three (if you include unknown NMIs too).

The change is straightforward and just mimics what the unknown
NMI does.

Reported-and-tested-by: Thomas Mingarelli <thomas.mingarelli@hp.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/1333051877-15755-3-git-send-email-dzickus@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
index 4000b80..6e414b5 100644
--- a/drivers/watchdog/hpwdt.c
+++ b/drivers/watchdog/hpwdt.c
@@ -725,19 +725,32 @@ static int __devinit hpwdt_init_nmi_decoding(struct pci_dev *dev)
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
