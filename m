Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755577Ab1GCKeT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 06:34:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:42905 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755508Ab1GCKeR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 06:34:17 -0400
Date: Sun, 3 Jul 2011 10:33:58 GMT
From: tip-bot for Sergei Shtylyov <sshtylyov@ru.mvista.com>
Message-ID: <tip-50c31e4a2497ea17747b587e8f96b278f07f5483@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        sshtylyov@ru.mvista.com, suresh.b.siddha@intel.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        sshtylyov@ru.mvista.com, suresh.b.siddha@intel.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <201107012242.08347.sshtylyov@ru.mvista.com>
References: <201107012242.08347.sshtylyov@ru.mvista.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mtrr] x86, mtrr: Use pci_dev->revision
Git-Commit-ID: 50c31e4a2497ea17747b587e8f96b278f07f5483
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 03 Jul 2011 10:34:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  50c31e4a2497ea17747b587e8f96b278f07f5483
Gitweb:     http://git.kernel.org/tip/50c31e4a2497ea17747b587e8f96b278f07f5483
Author:     Sergei Shtylyov <sshtylyov@ru.mvista.com>
AuthorDate: Fri, 1 Jul 2011 22:42:08 +0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 2 Jul 2011 11:10:07 +0200

x86, mtrr: Use pci_dev->revision

This code uses PCI_CLASS_REVISION instead of PCI_REVISION_ID, so
it wasn't converted by commit 44c10138fd4 ("PCI: Change all
drivers to use pci_device->revision") before being moved to
arch/x86/...

Do it now at last -- and save one level of indentation...

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Link: http://lkml.kernel.org/r/201107012242.08347.sshtylyov@ru.mvista.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/mtrr/main.c |   13 +++++--------
 1 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/main.c b/arch/x86/kernel/cpu/mtrr/main.c
index 707b637..08119a3 100644
--- a/arch/x86/kernel/cpu/mtrr/main.c
+++ b/arch/x86/kernel/cpu/mtrr/main.c
@@ -79,7 +79,6 @@ void set_mtrr_ops(const struct mtrr_ops *ops)
 static int have_wrcomb(void)
 {
 	struct pci_dev *dev;
-	u8 rev;
 
 	dev = pci_get_class(PCI_CLASS_BRIDGE_HOST << 8, NULL);
 	if (dev != NULL) {
@@ -89,13 +88,11 @@ static int have_wrcomb(void)
 		 * chipsets to be tagged
 		 */
 		if (dev->vendor == PCI_VENDOR_ID_SERVERWORKS &&
-		    dev->device == PCI_DEVICE_ID_SERVERWORKS_LE) {
-			pci_read_config_byte(dev, PCI_CLASS_REVISION, &rev);
-			if (rev <= 5) {
-				pr_info("mtrr: Serverworks LE rev < 6 detected. Write-combining disabled.\n");
-				pci_dev_put(dev);
-				return 0;
-			}
+		    dev->device == PCI_DEVICE_ID_SERVERWORKS_LE &&
+		    dev->revision <= 5) {
+			pr_info("mtrr: Serverworks LE rev < 6 detected. Write-combining disabled.\n");
+			pci_dev_put(dev);
+			return 0;
 		}
 		/*
 		 * Intel 450NX errata # 23. Non ascending cacheline evictions to
