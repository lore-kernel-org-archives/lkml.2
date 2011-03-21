Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932626Ab1CUXm1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 19:42:27 -0400
Received: from kroah.org ([198.145.64.141]:49548 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754977Ab1CUXP7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:15:59 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Mar 21 16:07:15 2011
Message-Id: <20110321230715.512657828@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 21 Mar 2011 16:07:00 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ben Hutchings <bhutchings@solarflare.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [61/87] PCI: sysfs: Fix failure path for addition of "vpd" attribute
In-Reply-To: <20110321230732.GA26510@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ben Hutchings <bhutchings@solarflare.com>

commit 0f12a4e29368a9476076515881d9ef4e5876c6e2 upstream.

Commit 280c73d ("PCI: centralize the capabilities code in
pci-sysfs.c") changed the initialisation of the "rom" and "vpd"
attributes, and made the failure path for the "vpd" attribute
incorrect.  We must free the new attribute structure (attr), but
instead we currently free dev->vpd->attr.  That will normally be NULL,
resulting in a memory leak, but it might be a stale pointer, resulting
in a double-free.

Found by inspection; compile-tested only.

Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/pci-sysfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -1088,7 +1088,7 @@ static int pci_create_capabilities_sysfs
 		attr->write = write_vpd_attr;
 		retval = sysfs_create_bin_file(&dev->dev.kobj, attr);
 		if (retval) {
-			kfree(dev->vpd->attr);
+			kfree(attr);
 			return retval;
 		}
 		dev->vpd->attr = attr;


