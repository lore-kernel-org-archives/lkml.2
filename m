Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762346Ab2EQSW5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 14:22:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35708 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762242Ab2EQSWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 14:22:55 -0400
Date: Thu, 17 May 2012 11:22:40 -0700
From: tip-bot for Alan Cox <alan@linux.intel.com>
Message-ID: <tip-80b3e557371205566a71e569fbfcce5b11f92dbe@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, alan@linux.intel.com, hpa@zytor.com,
        mingo@kernel.org, arne@fitzenreiter.de, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, alan@linux.intel.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, arne@fitzenreiter.de
In-Reply-To: <20120515174347.5109.94551.stgit@bluebook>
References: <20120515174347.5109.94551.stgit@bluebook>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Fix boot on Twinhead H12Y
Git-Commit-ID: 80b3e557371205566a71e569fbfcce5b11f92dbe
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 17 May 2012 11:22:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  80b3e557371205566a71e569fbfcce5b11f92dbe
Gitweb:     http://git.kernel.org/tip/80b3e557371205566a71e569fbfcce5b11f92dbe
Author:     Alan Cox <alan@linux.intel.com>
AuthorDate: Tue, 15 May 2012 18:44:15 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 17 May 2012 20:04:00 +0200

x86: Fix boot on Twinhead H12Y

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
---
 arch/x86/pci/fixup.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

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
