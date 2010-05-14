Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756890Ab0ENWdN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 18:33:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:38362 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754959Ab0ENWdJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 18:33:09 -0400
Date: Fri, 14 May 2010 22:32:55 GMT
Message-Id: <201005142232.o4EMWtV9017946@hera.kernel.org>
From: "H. Peter Anvin" <hpa@zytor.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] One additional x86 fix for 2.6.34
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Petr Vandrovec <petr@vandrovec.name>,
       Jacob Pan <jacob.jun.pan@intel.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 14 May 2010 22:32:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

One additional fix for the 2.6.34 tree.  It missed my push from
earlier today because I was waiting for confirmation from the original
reporter that it indeed solves the problem.

The following changes since commit 7f284d3cc96e02468a42e045f77af11e5ff8b095:
  Frank Arnold (1):
        x86, cacheinfo: Turn off L3 cache index disable feature in virtualized environments

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

H. Peter Anvin (1):
      x86, mrst: Don't blindly access extended config space

 arch/x86/pci/mrst.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

commit e9b1d5d0ff4d3ae86050dc4c91b3147361c7af9e
Author: H. Peter Anvin <hpa@linux.intel.com>
Date:   Fri May 14 13:55:57 2010 -0700

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
