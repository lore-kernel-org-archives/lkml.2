Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758883Ab2I1Uew (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:34:52 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:61998 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965036Ab2I1Uaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:30:55 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alan Cox <alan@linux.intel.com>, Ingo Molnar <mingo@kernel.org>
Subject: [ 166/218] x86: Fix boot on Twinhead H12Y
Date: Fri, 28 Sep 2012 13:16:23 -0700
Message-Id: <20120928201520.581385168@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928201501.208384923@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/pci/fixup.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

--- a/arch/x86/pci/fixup.c
+++ b/arch/x86/pci/fixup.c
@@ -519,3 +519,20 @@ static void sb600_disable_hpet_bar(struc
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


