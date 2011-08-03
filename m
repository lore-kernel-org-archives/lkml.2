Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103Ab1HCXow (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 19:44:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33397 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755967Ab1HCX0G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 19:26:06 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Aug  3 15:12:44 2011
Message-Id: <20110803221244.792017780@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 03 Aug 2011 15:00:27 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [007/102] staging: r8192e_pci: Handle duplicate PCI ID 0x10ec:0x8192 conflict with rtl8192se
In-Reply-To: <20110803221345.GA10346@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit 1c50bf7e415cf6ce9545dbecc2ac0d89d3916c53 upstream.

There are two devices with PCI ID 0x10ec:0x8192, namely RTL8192E and
RTL8192SE. The method of distinguishing them is by the revision ID
at offset 0x8 of the PCI configuration space. If the value is 0x10,
then the device uses rtl8192se for a driver.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/rtl8192e/r8192E_core.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/staging/rtl8192e/r8192E_core.c
+++ b/drivers/staging/rtl8192e/r8192E_core.c
@@ -4532,6 +4532,7 @@ static int __devinit rtl8192_pci_probe(s
 	u8 unit = 0;
 	int ret = -ENODEV;
 	unsigned long pmem_start, pmem_len, pmem_flags;
+	u8 revisionid;
 
 	RT_TRACE(COMP_INIT,"Configuring chip resources\n");
 
@@ -4592,6 +4593,11 @@ static int __devinit rtl8192_pci_probe(s
          pci_write_config_byte(pdev, 0x41, 0x00);
 
 
+	pci_read_config_byte(pdev, 0x08, &revisionid);
+	/* If the revisionid is 0x10, the device uses rtl8192se. */
+	if (pdev->device == 0x8192 && revisionid == 0x10)
+		goto fail1;
+
 	pci_read_config_byte(pdev, 0x05, &unit);
 	pci_write_config_byte(pdev, 0x05, unit & (~0x04));
 


