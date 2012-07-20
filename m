Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752158Ab2GTG4m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 02:56:42 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:43887 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991Ab2GTG4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 02:56:40 -0400
Date: Fri, 20 Jul 2012 09:56:23 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lars-Peter Clausen <lars@metafoo.de>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, kernel-janitors@vger.kernel.org
Subject: [patch] driver-core: dev_to_node() should handle NULL pointers
Message-ID: <20120720065622.GA11710@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What prompted this patch is that in dma_pool_create() we call
dev_to_node() before checking whether "dev" is NULL.  It looks like
there are places which call dma_pool_create() with a NULL pointer.  An
example is in drivers/usb/gadget/amd5536udc.c.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Static checker fix.

diff --git a/include/linux/device.h b/include/linux/device.h
index aa7b3b4..c80e7a8d 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -714,7 +714,9 @@ int dev_set_name(struct device *dev, const char *name, ...);
 #ifdef CONFIG_NUMA
 static inline int dev_to_node(struct device *dev)
 {
-	return dev->numa_node;
+	if (dev)
+		return dev->numa_node;
+	return -1;
 }
 static inline void set_dev_node(struct device *dev, int node)
 {
