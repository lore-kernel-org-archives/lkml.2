Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758376Ab2EOIse (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 04:48:34 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:31582 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758227Ab2EOIsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 04:48:08 -0400
Date: Tue, 15 May 2012 11:47:47 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Alan Cox <alan@linux.intel.com>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] hvc_xen: NULL dereference on allocation failure
Message-ID: <20120515084746.GC30265@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If kzalloc() returns a NULL here, we pass a NULL to
xencons_disconnect_backend() which will cause an Oops.

Also I removed the __GFP_ZERO while I was at it since kzalloc() implies
__GFP_ZERO.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/tty/hvc/hvc_xen.c b/drivers/tty/hvc/hvc_xen.c
index 83d5c88..d3d91da 100644
--- a/drivers/tty/hvc/hvc_xen.c
+++ b/drivers/tty/hvc/hvc_xen.c
@@ -430,9 +430,9 @@ static int __devinit xencons_probe(struct xenbus_device *dev,
 	if (devid == 0)
 		return -ENODEV;
 
-	info = kzalloc(sizeof(struct xencons_info), GFP_KERNEL | __GFP_ZERO);
+	info = kzalloc(sizeof(struct xencons_info), GFP_KERNEL);
 	if (!info)
-		goto error_nomem;
+		return -ENOMEM;
 	dev_set_drvdata(&dev->dev, info);
 	info->xbdev = dev;
 	info->vtermno = xenbus_devid_to_vtermno(devid);
