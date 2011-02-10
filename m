Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756542Ab1BJOon (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 09:44:43 -0500
Received: from hera.kernel.org ([140.211.167.34]:46351 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756337Ab1BJOok (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 09:44:40 -0500
Date: Thu, 10 Feb 2011 14:44:22 GMT
From: tip-bot for Jan Beulich <JBeulich@novell.com>
Cc: linux-kernel@vger.kernel.org, hans.rosenfeld@amd.com, hpa@zytor.com,
        mingo@redhat.com, Andreas.Herrmann3@amd.com, jbeulich@novell.com,
        JBeulich@novell.com, tglx@linutronix.de, mingo@elte.hu,
        borislav.petkov@amd.com
Reply-To: mingo@redhat.com, hpa@zytor.com, hans.rosenfeld@amd.com,
        linux-kernel@vger.kernel.org, Andreas.Herrmann3@amd.com,
        jbeulich@novell.com, JBeulich@novell.com, tglx@linutronix.de,
        mingo@elte.hu, borislav.petkov@amd.com
In-Reply-To: <4D525DDD0200007800030F07@vpn.id2.novell.com>
References: <4D525DDD0200007800030F07@vpn.id2.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/amd-nb] x86: Adjust section placement in AMD northbridge related code
Message-ID: <tip-691269f0d918cd72454c254f97722f194c07b9a8@git.kernel.org>
Git-Commit-ID: 691269f0d918cd72454c254f97722f194c07b9a8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 10 Feb 2011 14:44:22 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  691269f0d918cd72454c254f97722f194c07b9a8
Gitweb:     http://git.kernel.org/tip/691269f0d918cd72454c254f97722f194c07b9a8
Author:     Jan Beulich <JBeulich@novell.com>
AuthorDate: Wed, 9 Feb 2011 08:26:53 +0000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 10 Feb 2011 13:32:52 +0100

x86: Adjust section placement in AMD northbridge related code

amd_nb_misc_ids[] can live in .rodata, and enable_pci_io_ecs()
can be moved into .cpuinit.text.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Hans Rosenfeld <hans.rosenfeld@amd.com>
Cc: Andreas Herrmann <Andreas.Herrmann3@amd.com>
Cc: Borislav Petkov <borislav.petkov@amd.com>
LKML-Reference: <4D525DDD0200007800030F07@vpn.id2.novell.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/amd_nb.h |    2 +-
 arch/x86/kernel/amd_nb.c      |    7 ++++---
 arch/x86/pci/amd_bus.c        |    2 +-
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/amd_nb.h b/arch/x86/include/asm/amd_nb.h
index 423f11c..2b33c4d 100644
--- a/arch/x86/include/asm/amd_nb.h
+++ b/arch/x86/include/asm/amd_nb.h
@@ -9,7 +9,7 @@ struct amd_nb_bus_dev_range {
 	u8 dev_limit;
 };
 
-extern struct pci_device_id amd_nb_misc_ids[];
+extern const struct pci_device_id amd_nb_misc_ids[];
 extern const struct amd_nb_bus_dev_range amd_nb_bus_dev_ranges[];
 struct bootnode;
 
diff --git a/arch/x86/kernel/amd_nb.c b/arch/x86/kernel/amd_nb.c
index bf79a4a..ed3c2e5 100644
--- a/arch/x86/kernel/amd_nb.c
+++ b/arch/x86/kernel/amd_nb.c
@@ -12,7 +12,7 @@
 
 static u32 *flush_words;
 
-struct pci_device_id amd_nb_misc_ids[] = {
+const struct pci_device_id amd_nb_misc_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_K8_NB_MISC) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_10H_NB_MISC) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_NB_MISC) },
@@ -36,7 +36,7 @@ struct amd_northbridge_info amd_northbridges;
 EXPORT_SYMBOL(amd_northbridges);
 
 static struct pci_dev *next_northbridge(struct pci_dev *dev,
-					struct pci_device_id *ids)
+					const struct pci_device_id *ids)
 {
 	do {
 		dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev);
@@ -107,8 +107,9 @@ EXPORT_SYMBOL_GPL(amd_cache_northbridges);
    they're useless anyways */
 int __init early_is_amd_nb(u32 device)
 {
-	struct pci_device_id *id;
+	const struct pci_device_id *id;
 	u32 vendor = device & 0xffff;
+
 	device >>= 16;
 	for (id = amd_nb_misc_ids; id->vendor; id++)
 		if (vendor == id->vendor && device == id->device)
diff --git a/arch/x86/pci/amd_bus.c b/arch/x86/pci/amd_bus.c
index e27dffb..026e493 100644
--- a/arch/x86/pci/amd_bus.c
+++ b/arch/x86/pci/amd_bus.c
@@ -350,7 +350,7 @@ static int __init early_fill_mp_bus_info(void)
 
 #define ENABLE_CF8_EXT_CFG      (1ULL << 46)
 
-static void enable_pci_io_ecs(void *unused)
+static void __cpuinit enable_pci_io_ecs(void *unused)
 {
 	u64 reg;
 	rdmsrl(MSR_AMD64_NB_CFG, reg);
