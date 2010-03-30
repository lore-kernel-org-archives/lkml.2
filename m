Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756942Ab0C3XVt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:21:49 -0400
Received: from kroah.org ([198.145.64.141]:46332 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932550Ab0C3XUq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:20:46 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:48:19 2010
Message-Id: <20100330224818.405944786@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:42:02 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Dean Nelson <dnelson@redhat.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [088/156] PCI: fix return value from pcix_get_max_mmrbc()
In-Reply-To: <20100330230630.GA28824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dean Nelson <dnelson@redhat.com>

commit 25daeb550b69e89aff59bc6a84218a12b5203531 upstream.

For the PCI_X_STATUS register, pcix_get_max_mmrbc() is returning an incorrect
value, which is based on:

	(stat & PCI_X_STATUS_MAX_READ) >> 12

Valid return values are 512, 1024, 2048, 4096, which correspond to a 'stat'
(masked and right shifted by 21) of 0, 1, 2, 3, respectively.

A right shift by 11 would generate the correct return value when 'stat' (masked
and right shifted by 21) has a value of 1 or 2. But for a value of 0 or 3 it's
not possible to generate the correct return value by only right shifting.

Fix is based on pcix_get_mmrbc()'s similar dealings with the PCI_X_CMD register.

Signed-off-by: Dean Nelson <dnelson@redhat.com>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/pci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -2432,7 +2432,7 @@ int pcix_get_max_mmrbc(struct pci_dev *d
 	if (err)
 		return -EINVAL;
 
-	return (stat & PCI_X_STATUS_MAX_READ) >> 12;
+	return 512 << ((stat & PCI_X_STATUS_MAX_READ) >> 21);
 }
 EXPORT_SYMBOL(pcix_get_max_mmrbc);
 


