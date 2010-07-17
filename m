Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966313Ab0GQAtx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 20:49:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:55535 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759520Ab0GQAtS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 20:49:18 -0400
Date: Sat, 17 Jul 2010 00:49:04 GMT
From: tip-bot for Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        jbarnes@virtuousgeek.org, tglx@linutronix.de, hpa@linux.intel.com,
        jacob.jun.pan@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jbarnes@virtuousgeek.org, tglx@linutronix.de,
        jacob.jun.pan@linux.intel.com, hpa@linux.intel.com
In-Reply-To: <1279306706-27087-1-git-send-email-jacob.jun.pan@linux.intel.com>
References: <1279306706-27087-1-git-send-email-jacob.jun.pan@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, pci, mrst: Add extra sanity check in walking the PCI extended cap chain
Message-ID: <tip-f82c3d71d6fd2e6a3e3416f09099e29087e39abf@git.kernel.org>
Git-Commit-ID: f82c3d71d6fd2e6a3e3416f09099e29087e39abf
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 17 Jul 2010 00:49:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f82c3d71d6fd2e6a3e3416f09099e29087e39abf
Gitweb:     http://git.kernel.org/tip/f82c3d71d6fd2e6a3e3416f09099e29087e39abf
Author:     Jacob Pan <jacob.jun.pan@linux.intel.com>
AuthorDate: Fri, 16 Jul 2010 11:58:26 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 16 Jul 2010 16:52:15 -0700

x86, pci, mrst: Add extra sanity check in walking the PCI extended cap chain

The fixed bar capability structure is searched in PCI extended
configuration space.  We need to make sure there is a valid capability
ID to begin with otherwise, the search code may stuck in a infinite
loop which results in boot hang.  This patch adds additional check for
cap ID 0, which is also invalid, and indicates end of chain.

End of chain is supposed to have all fields zero, but that doesn't
seem to always be the case in the field.

Suggested-by: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
Reviewed-by: Jesse Barnes <jbarnes@virtuousgeek.org>
LKML-Reference: <1279306706-27087-1-git-send-email-jacob.jun.pan@linux.intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/pci/mrst.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/pci/mrst.c b/arch/x86/pci/mrst.c
index 7ef3a27..cb29191 100644
--- a/arch/x86/pci/mrst.c
+++ b/arch/x86/pci/mrst.c
@@ -66,8 +66,9 @@ static int fixed_bar_cap(struct pci_bus *bus, unsigned int devfn)
 					  devfn, pos, 4, &pcie_cap))
 			return 0;
 
-		if (pcie_cap == 0xffffffff)
-			return 0;
+		if (PCI_EXT_CAP_ID(pcie_cap) == 0x0000 ||
+			PCI_EXT_CAP_ID(pcie_cap) == 0xffff)
+			break;
 
 		if (PCI_EXT_CAP_ID(pcie_cap) == PCI_EXT_CAP_ID_VNDR) {
 			raw_pci_ext_ops->read(pci_domain_nr(bus), bus->number,
@@ -76,7 +77,7 @@ static int fixed_bar_cap(struct pci_bus *bus, unsigned int devfn)
 				return pos;
 		}
 
-		pos = pcie_cap >> 20;
+		pos = PCI_EXT_CAP_NEXT(pcie_cap);
 	}
 
 	return 0;
