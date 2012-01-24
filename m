Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756557Ab2AXDKb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 22:10:31 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50064 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756391Ab2AXCnd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 21:43:33 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 23 18:39:26 2012
Message-Id: <20120124023926.772521120@clark.kroah.org>
User-Agent: quilt/0.50-11.1
Date: Mon, 23 Jan 2012 18:34:12 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "Eric W. Biederman" <ebiederm@xmission.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [032/129] PCI: msi: Disable msi interrupts when we initialize a pci device
In-Reply-To: <20120124024041.GA18422@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------
Content-Length: 1596
Lines: 46

From: "Eric W. Biederman" <ebiederm@xmission.com>

commit a776c491ca5e38c26d9f66923ff574d041e747f4 upstream.

I traced a nasty kexec on panic boot failure to the fact that we had
screaming msi interrupts and we were not disabling the msi messages at
kernel startup.  The booting kernel had not enabled those interupts so
was not prepared to handle them.

I can see no reason why we would ever want to leave the msi interrupts
enabled at boot if something else has enabled those interrupts.  The pci
spec specifies that msi interrupts should be off by default.  Drivers
are expected to enable the msi interrupts if they want to use them.  Our
interrupt handling code reprograms the interrupt handlers at boot and
will not be be able to do anything useful with an unexpected interrupt.

This patch applies cleanly all of the way back to 2.6.32 where I noticed
the problem.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/msi.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -870,5 +870,15 @@ EXPORT_SYMBOL(pci_msi_enabled);
 
 void pci_msi_init_pci_dev(struct pci_dev *dev)
 {
+	int pos;
 	INIT_LIST_HEAD(&dev->msi_list);
+
+	/* Disable the msi hardware to avoid screaming interrupts
+	 * during boot.  This is the power on reset default so
+	 * usually this should be a noop.
+	 */
+	pos = pci_find_capability(dev, PCI_CAP_ID_MSI);
+	if (pos)
+		msi_set_enable(dev, pos, 0);
+	msix_set_enable(dev, 0);
 }


