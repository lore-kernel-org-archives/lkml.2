Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755773Ab2GaEvQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 00:51:16 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48882 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755729Ab2GaEvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 00:51:11 -0400
Message-Id: <20120731044314.829883804@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Tue, 31 Jul 2012 05:43:32 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alan Cox <alan@linux.intel.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: [ 22/73] x86: Fix boot on Twinhead H12Y
In-Reply-To: <20120731044310.013763753@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Cox <alan@linux.intel.com>

commit 80b3e557371205566a71e569fbfcce5b11f92dbe upstream.

Despite lots of investigation into why this is needed we don't
know or have an elegant cure. The only answer found on this
laptop is to mark a problem region as used so that Linux doesn't
put anything there.

Currently all the users add reserve= command lines and anyone
not knowing this needs to find the magic page that documents it.
Automate it instead.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Tested-and-bugfixed-by: Arne Fitzenreiter <arne@fitzenreiter.de>
Resolves-bug: https://bugzilla.kernel.org/show_bug.cgi?id=10231
Link: http://lkml.kernel.org/r/20120515174347.5109.94551.stgit@bluebook
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/pci/fixup.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/arch/x86/pci/fixup.c b/arch/x86/pci/fixup.c
index d0e6e40..5dd467b 100644
--- a/arch/x86/pci/fixup.c
+++ b/arch/x86/pci/fixup.c
@@ -519,3 +519,20 @@ static void sb600_disable_hpet_bar(struct pci_dev *dev)
 	}
 }
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_ATI, 0x4385, sb600_disable_hpet_bar);
+
+/*
+ * Twinhead H12Y needs us to block out a region otherwise we map devices
+ * there and any access kills the box.
+ *
+ *   See: https://bugzilla.kernel.org/show_bug.cgi?id=10231
+ *
+ * Match off the LPC and svid/sdid (older kernels lose the bridge subvendor)
+ */
+static void __devinit twinhead_reserve_killing_zone(struct pci_dev *dev)
+{
+        if (dev->subsystem_vendor == 0x14FF && dev->subsystem_device == 0xA003) {
+                pr_info("Reserving memory on Twinhead H12Y\n");
+                request_mem_region(0xFFB00000, 0x100000, "twinhead");
+        }
+}
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x27B9, twinhead_reserve_killing_zone);


