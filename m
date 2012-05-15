Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933274Ab2EOQpZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 12:45:25 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:45508 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933073Ab2EOQpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 12:45:20 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] x86: Fix boot on Twinhead H12Y
To: mingo@elte.hu, linux-kernel@vger.kernel.org
Date: Tue, 15 May 2012 18:44:15 +0100
Message-ID: <20120515174347.5109.94551.stgit@bluebook>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Despite lots of investigation into why this is needed we don't know or have
an elegant cure. The only answer found on this laptop is to mark a problem
region as used so that Linux doesn't put anything there.

Currently all the users add reserve= command lines and anyone not knowing this
needs to find the magic page that documents it. Automate it instead.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Tested-and-bugfixed-by: Arne Fitzenreiter <arne@fitzenreiter.de>
Resolves-bug: https://bugzilla.kernel.org/show_bug.cgi?id=10231
---

 arch/x86/pci/fixup.c |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/arch/x86/pci/fixup.c b/arch/x86/pci/fixup.c
index d0e6e40..40b3eb8 100644
--- a/arch/x86/pci/fixup.c
+++ b/arch/x86/pci/fixup.c
@@ -519,3 +519,22 @@ static void sb600_disable_hpet_bar(struct pci_dev *dev)
 	}
 }
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_ATI, 0x4385, sb600_disable_hpet_bar);
+
+/*
+ * Twinhead H12Y needs us to block out a region otherwise we map devices
+ * there and any access kills the box.
+ * See: https://bugzilla.kernel.org/show_bug.cgi?id=10231
+ *
+ * Match off the LPC and svid/sdid (older kernels lose the bridge subvendor)
+ */
+
+static void __devinit twinhead_reserve_killing_zone(struct pci_dev *dev)
+{
+        if (dev->subsystem_vendor == 0x14FF && dev->subsystem_device ==
+                                        0xA003) {
+                pr_info("Reserving memory on Twinhead H12Y\n");
+                request_mem_region(0xFFB00000, 0x100000, "twinhead");
+        }
+}
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x27B9,
+                                twinhead_reserve_killing_zone);

