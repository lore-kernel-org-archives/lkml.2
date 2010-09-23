Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756314Ab0IWUFV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 16:05:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:35091 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755353Ab0IWUFU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 16:05:20 -0400
Date: Thu, 23 Sep 2010 20:04:57 GMT
From: tip-bot for Daniel Drake <dsd@laptop.org>
Cc: grant.likely@secretlab.ca, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@redhat.com, dsd@laptop.org, dilinger@queued.net,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        grant.likely@secretlab.ca, dsd@laptop.org, dilinger@queued.net,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <20100923162805.0F6549D401B@zog.reactivated.net>
References: <20100923162805.0F6549D401B@zog.reactivated.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/olpc] x86, olpc: Only enable PCI configuration type override on XO-1
Message-ID: <tip-76fb657017588a0912f0d1d140cb807446e4ef05@git.kernel.org>
Git-Commit-ID: 76fb657017588a0912f0d1d140cb807446e4ef05
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 23 Sep 2010 20:04:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  76fb657017588a0912f0d1d140cb807446e4ef05
Gitweb:     http://git.kernel.org/tip/76fb657017588a0912f0d1d140cb807446e4ef05
Author:     Daniel Drake <dsd@laptop.org>
AuthorDate: Thu, 23 Sep 2010 17:28:04 +0100
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 23 Sep 2010 11:14:18 -0700

x86, olpc: Only enable PCI configuration type override on XO-1

This configuration type override is for XO-1 only and must not happen
on XO-1.5.

Signed-off-by: Daniel Drake <dsd@laptop.org>
LKML-Reference: <20100923162805.0F6549D401B@zog.reactivated.net>
Cc: Andres Solomon <dilinger@queued.net>
Cc: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/Kconfig       |    2 +-
 arch/x86/kernel/olpc.c |    6 ++++--
 arch/x86/pci/olpc.c    |    2 +-
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index cea0cd9..0ed4c9b 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1900,7 +1900,7 @@ config PCI_GODIRECT
 	bool "Direct"
 
 config PCI_GOOLPC
-	bool "OLPC"
+	bool "OLPC XO-1"
 	depends on OLPC
 
 config PCI_GOANY
diff --git a/arch/x86/kernel/olpc.c b/arch/x86/kernel/olpc.c
index 0e0cdde..635888c 100644
--- a/arch/x86/kernel/olpc.c
+++ b/arch/x86/kernel/olpc.c
@@ -242,8 +242,10 @@ static int __init olpc_init(void)
 			(unsigned char *) &olpc_platform_info.ecver, 1);
 
 #ifdef CONFIG_PCI_OLPC
-	/* If the VSA exists let it emulate PCI, if not emulate in kernel */
-	if (!cs5535_has_vsa2())
+	/* If the VSA exists let it emulate PCI, if not emulate in kernel.
+	 * XO-1 only. */
+	if (olpc_platform_info.boardrev < olpc_board_pre(0xd0) &&
+			!cs5535_has_vsa2())
 		x86_init.pci.arch_init = pci_olpc_init;
 #endif
 
diff --git a/arch/x86/pci/olpc.c b/arch/x86/pci/olpc.c
index b348154..13700ec 100644
--- a/arch/x86/pci/olpc.c
+++ b/arch/x86/pci/olpc.c
@@ -304,7 +304,7 @@ static struct pci_raw_ops pci_olpc_conf = {
 
 int __init pci_olpc_init(void)
 {
-	printk(KERN_INFO "PCI: Using configuration type OLPC\n");
+	printk(KERN_INFO "PCI: Using configuration type OLPC XO-1\n");
 	raw_pci_ops = &pci_olpc_conf;
 	is_lx = is_geode_lx();
 	return 0;
