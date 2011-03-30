Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933779Ab1C3VZt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:25:49 -0400
Received: from mga11.intel.com ([192.55.52.93]:57933 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965076Ab1C3VJM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:09:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="673448430"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: bhutchings@solarflare.com, jbarnes@virtuousgeek.org, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [205/275] PCI: sysfs: Fix failure path for addition of "vpd" attribute
Message-Id: <20110330210729.8A13D3E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:07:29 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/pci/pci-sysfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.35.y/drivers/pci/pci-sysfs.c
===================================================================
--- linux-2.6.35.y.orig/drivers/pci/pci-sysfs.c	2011-03-29 22:50:37.342302922 -0700
+++ linux-2.6.35.y/drivers/pci/pci-sysfs.c	2011-03-29 23:03:02.539235198 -0700
@@ -1018,7 +1018,7 @@
 		attr->write = write_vpd_attr;
 		retval = sysfs_create_bin_file(&dev->dev.kobj, attr);
 		if (retval) {
-			kfree(dev->vpd->attr);
+			kfree(attr);
 			return retval;
 		}
 		dev->vpd->attr = attr;
