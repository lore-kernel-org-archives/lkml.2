Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758256Ab0ENVkH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 17:40:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:45631 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757489Ab0ENVkD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 17:40:03 -0400
Date: Fri, 14 May 2010 21:39:44 GMT
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       petr@vandrovec.name, jbarnes@virtuousgeek.org, jacob.jun.pan@intel.com,
       tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org, jacob.jun.pan@intel.com, petr@vandrovec.name,
       tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <AANLkTiltKUa3TrKR1M51eGw8FLNoQJSLT0k0_K5X3-OJ@mail.gmail.com>
References: <AANLkTiltKUa3TrKR1M51eGw8FLNoQJSLT0k0_K5X3-OJ@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, mrst: Don't blindly access extended config space
Message-ID: <tip-e9b1d5d0ff4d3ae86050dc4c91b3147361c7af9e@git.kernel.org>
Git-Commit-ID: e9b1d5d0ff4d3ae86050dc4c91b3147361c7af9e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 14 May 2010 21:39:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e9b1d5d0ff4d3ae86050dc4c91b3147361c7af9e
Gitweb:     http://git.kernel.org/tip/e9b1d5d0ff4d3ae86050dc4c91b3147361c7af9e
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Fri, 14 May 2010 13:55:57 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 14 May 2010 13:55:57 -0700

x86, mrst: Don't blindly access extended config space

Do not blindly access extended configuration space unless we actively
know we're on a Moorestown platform.  The fixed-size BAR capability
lives in the extended configuration space, and thus is not applicable
if the configuration space isn't appropriately sized.

This fixes booting certain VMware configurations with CONFIG_MRST=y.

Moorestown will add a fake PCI-X 266 capability to advertise the
presence of extended configuration space.

Reported-and-tested-by: Petr Vandrovec <petr@vandrovec.name>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Acked-by: Jacob Pan <jacob.jun.pan@intel.com>
Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>
LKML-Reference: <AANLkTiltKUa3TrKR1M51eGw8FLNoQJSLT0k0_K5X3-OJ@mail.gmail.com>
---
 arch/x86/pci/mrst.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/pci/mrst.c b/arch/x86/pci/mrst.c
index 8bf2fcb..1cdc02c 100644
--- a/arch/x86/pci/mrst.c
+++ b/arch/x86/pci/mrst.c
@@ -247,6 +247,10 @@ static void __devinit pci_fixed_bar_fixup(struct pci_dev *dev)
 	u32 size;
 	int i;
 
+	/* Must have extended configuration space */
+	if (dev->cfg_size < PCIE_CAP_OFFSET + 4)
+		return;
+
 	/* Fixup the BAR sizes for fixed BAR devices and make them unmoveable */
 	offset = fixed_bar_cap(dev->bus, dev->devfn);
 	if (!offset || PCI_DEVFN(2, 0) == dev->devfn ||
