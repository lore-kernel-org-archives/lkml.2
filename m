Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932457Ab2JAW7b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 18:59:31 -0400
Received: from 1wt.eu ([62.212.114.60]:34958 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753222Ab2JAW71 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 18:59:27 -0400
Message-Id: <20121001225159.098617063@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:52:32 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Willy Tarreau <w@1wt.eu>, Jiri Slaby <jslaby@suse.cz>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [ 035/180] PNP: fix "work around Dell 1536/1546 BIOS MMCONFIG bug that breaks USB"
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Willy Tarreau <w@1wt.eu>

Initial stable commit : 2215d91091c465fd58da7814d1c10e09ac2d8307

This patch backported into 2.6.32.55 is enabled when CONFIG_AMD_NB is set,
but this config option does not exist in 2.6.32, it was called CONFIG_K8_NB,
so the fix was never applied. Some other changes were needed to make it work.
first, the correct include file name was asm/k8.h and not asm/amd_nb.h, and
second, amd_get_mmconfig_range() is needed and was merged by previous patch.

Thanks to Jiri Slabi who reported the issue and diagnosed all the dependencies.

Signed-off-by: Willy Tarreau <w@1wt.eu>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
---
 arch/x86/pci/amd_bus.c |    1 +
 drivers/pnp/quirks.c   |    6 +++---
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/pci/amd_bus.c b/arch/x86/pci/amd_bus.c
index cb34763..aae9931 100644
--- a/arch/x86/pci/amd_bus.c
+++ b/arch/x86/pci/amd_bus.c
@@ -3,6 +3,7 @@
 #include <linux/topology.h>
 #include <linux/cpu.h>
 #include <asm/pci_x86.h>
+#include <asm/k8.h>
 
 #ifdef CONFIG_X86_64
 #include <asm/pci-direct.h>
diff --git a/drivers/pnp/quirks.c b/drivers/pnp/quirks.c
index eb39d26..253996c 100644
--- a/drivers/pnp/quirks.c
+++ b/drivers/pnp/quirks.c
@@ -300,9 +300,9 @@ static void quirk_system_pci_resources(struct pnp_dev *dev)
 	}
 }
 
-#ifdef CONFIG_AMD_NB
+#ifdef CONFIG_K8_NB
 
-#include <asm/amd_nb.h>
+#include <asm/k8.h>
 
 static void quirk_amd_mmconfig_area(struct pnp_dev *dev)
 {
@@ -366,7 +366,7 @@ static struct pnp_fixup pnp_fixups[] = {
 	/* PnP resources that might overlap PCI BARs */
 	{"PNP0c01", quirk_system_pci_resources},
 	{"PNP0c02", quirk_system_pci_resources},
-#ifdef CONFIG_AMD_NB
+#ifdef CONFIG_K8_NB
 	{"PNP0c01", quirk_amd_mmconfig_area},
 #endif
 	{""}
-- 
1.7.2.1.45.g54fbc



