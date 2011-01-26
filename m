Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147Ab1AZK7N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 05:59:13 -0500
Received: from hera.kernel.org ([140.211.167.34]:37540 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752858Ab1AZK7M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 05:59:12 -0500
Date: Wed, 26 Jan 2011 10:58:43 GMT
From: tip-bot for Hans Rosenfeld <hans.rosenfeld@amd.com>
Cc: linux-kernel@vger.kernel.org, hans.rosenfeld@amd.com, hpa@zytor.com,
        mingo@redhat.com, andreas.herrmann3@amd.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, hans.rosenfeld@amd.com,
        linux-kernel@vger.kernel.org, andreas.herrmann3@amd.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1295881543-572552-4-git-send-email-hans.rosenfeld@amd.com>
References: <1295881543-572552-4-git-send-email-hans.rosenfeld@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/amd-nb] x86, amd: Extend AMD northbridge caching code to support "Link Control" devices
Message-ID: <tip-41b2610c3443e6c4760e61fc10eef73f96f9f6a5@git.kernel.org>
Git-Commit-ID: 41b2610c3443e6c4760e61fc10eef73f96f9f6a5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 26 Jan 2011 10:58:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  41b2610c3443e6c4760e61fc10eef73f96f9f6a5
Gitweb:     http://git.kernel.org/tip/41b2610c3443e6c4760e61fc10eef73f96f9f6a5
Author:     Hans Rosenfeld <hans.rosenfeld@amd.com>
AuthorDate: Mon, 24 Jan 2011 16:05:42 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 26 Jan 2011 08:28:23 +0100

x86, amd: Extend AMD northbridge caching code to support "Link Control" devices

"Link Control" devices (NB function 4) will be used by L3 cache
partitioning on family 0x15.

Signed-off-by: Hans Rosenfeld <hans.rosenfeld@amd.com>
Cc: <andreas.herrmann3@amd.com>
LKML-Reference: <1295881543-572552-4-git-send-email-hans.rosenfeld@amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/amd_nb.h |    1 +
 arch/x86/kernel/amd_nb.c      |   11 +++++++++--
 include/linux/pci_ids.h       |    1 +
 3 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/amd_nb.h b/arch/x86/include/asm/amd_nb.h
index 64dc82e..3e70700 100644
--- a/arch/x86/include/asm/amd_nb.h
+++ b/arch/x86/include/asm/amd_nb.h
@@ -26,6 +26,7 @@ extern void amd_get_nodes(struct bootnode *nodes);
 
 struct amd_northbridge {
 	struct pci_dev *misc;
+	struct pci_dev *link;
 };
 
 struct amd_northbridge_info {
diff --git a/arch/x86/kernel/amd_nb.c b/arch/x86/kernel/amd_nb.c
index a4f394c..4ae9a96 100644
--- a/arch/x86/kernel/amd_nb.c
+++ b/arch/x86/kernel/amd_nb.c
@@ -20,6 +20,11 @@ struct pci_device_id amd_nb_misc_ids[] = {
 };
 EXPORT_SYMBOL(amd_nb_misc_ids);
 
+static struct pci_device_id amd_nb_link_ids[] = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_NB_LINK) },
+	{}
+};
+
 const struct amd_nb_bus_dev_range amd_nb_bus_dev_ranges[] __initconst = {
 	{ 0x00, 0x18, 0x20 },
 	{ 0xff, 0x00, 0x20 },
@@ -45,7 +50,7 @@ int amd_cache_northbridges(void)
 {
 	int i = 0;
 	struct amd_northbridge *nb;
-	struct pci_dev *misc;
+	struct pci_dev *misc, *link;
 
 	if (amd_nb_num())
 		return 0;
@@ -64,10 +69,12 @@ int amd_cache_northbridges(void)
 	amd_northbridges.nb = nb;
 	amd_northbridges.num = i;
 
-	misc = NULL;
+	link = misc = NULL;
 	for (i = 0; i != amd_nb_num(); i++) {
 		node_to_amd_nb(i)->misc = misc =
 			next_northbridge(misc, amd_nb_misc_ids);
+		node_to_amd_nb(i)->link = link =
+			next_northbridge(link, amd_nb_link_ids);
         }
 
 	/* some CPU families (e.g. family 0x11) do not support GART */
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 3adb06e..580de67 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -518,6 +518,7 @@
 #define PCI_DEVICE_ID_AMD_11H_NB_MISC	0x1303
 #define PCI_DEVICE_ID_AMD_11H_NB_LINK	0x1304
 #define PCI_DEVICE_ID_AMD_15H_NB_MISC	0x1603
+#define PCI_DEVICE_ID_AMD_15H_NB_LINK	0x1604
 #define PCI_DEVICE_ID_AMD_CNB17H_F3	0x1703
 #define PCI_DEVICE_ID_AMD_LANCE		0x2000
 #define PCI_DEVICE_ID_AMD_LANCE_HOME	0x2001
