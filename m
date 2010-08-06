Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935770Ab0HFTNH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 15:13:07 -0400
Received: from kroah.org ([198.145.64.141]:58537 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935678Ab0HFTAH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 15:00:07 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Aug  6 11:58:34 2010
Message-Id: <20100806185834.811140637@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 06 Aug 2010 11:57:06 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dean Nelson <dnelson@redhat.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [11/34] e1000e: dont inadvertently re-set INTX_DISABLE
In-Reply-To: <20100806185853.GA28270@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dean Nelson <dnelson@redhat.com>

commit 36f2407fe52c55566221f8c68c8fb808abffd2f5 upstream.

Should e1000_test_msi() fail to see an msi interrupt, it attempts to
fallback to legacy INTx interrupts. But an error in the code may prevent
this from happening correctly.

Before calling e1000_test_msi_interrupt(), e1000_test_msi() disables SERR
by clearing the SERR bit from the just read PCI_COMMAND bits as it writes
them back out.

Upon return from calling e1000_test_msi_interrupt(), it re-enables SERR
by writing out the version of PCI_COMMAND it had previously read.

The problem with this is that e1000_test_msi_interrupt() calls
pci_disable_msi(), which eventually ends up in pci_intx(). And because
pci_intx() was called with enable set to 1, the INTX_DISABLE bit gets
cleared from PCI_COMMAND, which is what we want. But when we get back to
e1000_test_msi(), the INTX_DISABLE bit gets inadvertently re-set because
of the attempt by e1000_test_msi() to re-enable SERR.

The solution is to have e1000_test_msi() re-read the PCI_COMMAND bits as
part of its attempt to re-enable SERR.

During debugging/testing of this issue I found that not all the systems
I ran on had the SERR bit set to begin with. And on some of the systems
the same could be said for the INTX_DISABLE bit. Needless to say these
latter systems didn't have a problem falling back to legacy INTx
interrupts with the code as is.

Signed-off-by: Dean Nelson <dnelson@redhat.com>
Tested-by: Emil Tantilov <emil.s.tantilov@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/e1000e/netdev.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/drivers/net/e1000e/netdev.c
+++ b/drivers/net/e1000e/netdev.c
@@ -3073,13 +3073,18 @@ static int e1000_test_msi(struct e1000_a
 
 	/* disable SERR in case the MSI write causes a master abort */
 	pci_read_config_word(adapter->pdev, PCI_COMMAND, &pci_cmd);
-	pci_write_config_word(adapter->pdev, PCI_COMMAND,
-			      pci_cmd & ~PCI_COMMAND_SERR);
+	if (pci_cmd & PCI_COMMAND_SERR)
+		pci_write_config_word(adapter->pdev, PCI_COMMAND,
+				      pci_cmd & ~PCI_COMMAND_SERR);
 
 	err = e1000_test_msi_interrupt(adapter);
 
-	/* restore previous setting of command word */
-	pci_write_config_word(adapter->pdev, PCI_COMMAND, pci_cmd);
+	/* re-enable SERR */
+	if (pci_cmd & PCI_COMMAND_SERR) {
+		pci_read_config_word(adapter->pdev, PCI_COMMAND, &pci_cmd);
+		pci_cmd |= PCI_COMMAND_SERR;
+		pci_write_config_word(adapter->pdev, PCI_COMMAND, pci_cmd);
+	}
 
 	/* success ! */
 	if (!err)


