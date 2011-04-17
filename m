Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754402Ab1DQTIc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 15:08:32 -0400
Received: from [69.28.251.93] ([69.28.251.93]:40981 "EHLO b32.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754201Ab1DQTI1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 15:08:27 -0400
From: Kevin Cernekee <cernekee@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Wu Zhangjin <wuzhangjin@gmail.com>, <linux-mips@linux-mips.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] MIPS: Squash pci_fixup_irqs() compiler warning
Date: Sun, 17 Apr 2011 12:01:08 -0700
Message-Id: <cb01d61712b1374a8c62bc765094ea7e@localhost>
User-Agent: vim 7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MIPS Linux is unique in that it uses a "const struct pci_dev *" argument
to discourage bad coding practices in pcibios_map_irq().  Add a cast so
that this warning goes away:

arch/mips/pci/pci.c: In function 'pcibios_init':
arch/mips/pci/pci.c:165:45: warning: passing argument 2 of 'pci_fixup_irqs' from incompatible pointer type
include/linux/pci.h:856:6: note: expected 'int (*)(struct pci_dev *, u8,  u8)' but argument is of type 'struct pci_dev *'

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
---

Reference:

http://www.mail-archive.com/gnewsense-dev@nongnu.org/msg00706.html

It's been two years since the original discussion, and the warning is
still there.  It is now the only warning left in my kernel build.

I was hoping we could get this resolved for good (one way or another).

 arch/mips/pci/pci.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/mips/pci/pci.c b/arch/mips/pci/pci.c
index 33bba7b..9a35cd6 100644
--- a/arch/mips/pci/pci.c
+++ b/arch/mips/pci/pci.c
@@ -157,7 +157,8 @@ static int __init pcibios_init(void)
 	for (hose = hose_head; hose; hose = hose->next)
 		pcibios_scanbus(hose);
 
-	pci_fixup_irqs(pci_common_swizzle, pcibios_map_irq);
+	pci_fixup_irqs(pci_common_swizzle,
+		       (int (*)(struct pci_dev *, u8, u8))pcibios_map_irq);
 
 	pci_initialized = 1;
 
-- 
1.7.4.3

