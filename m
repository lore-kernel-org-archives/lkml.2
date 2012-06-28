Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932459Ab2F1GpJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 02:45:09 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:28354 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932294Ab2F1GpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 02:45:05 -0400
Date: Thu, 28 Jun 2012 09:44:58 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch 2/3] vfio: make count unsigned to prevent integer underflow
Message-ID: <20120628064458.GB11107@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340686552.1207.128.camel@bling.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In vfio_pci_ioctl() there is a potential integer underflow where we
might allocate less data than intended.  We check that hdr.count is not
too large, but we don't check whether it is negative:

drivers/vfio/pci/vfio_pci.c
   312          if (hdr.argsz - minsz < hdr.count * size ||
   313              hdr.count > vfio_pci_get_irq_count(vdev, hdr.index))
   314                  return -EINVAL;
   315
   316          data = kmalloc(hdr.count * size, GFP_KERNEL);

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 300d49b..86ef2da 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -347,7 +347,7 @@ struct vfio_irq_set {
 #define VFIO_IRQ_SET_ACTION_TRIGGER	(1 << 5) /* Trigger interrupt */
 	__u32	index;
 	__s32	start;
-	__s32	count;
+	__u32	count;
 	__u8	data[];
 };
 #define VFIO_DEVICE_SET_IRQS		_IO(VFIO_TYPE, VFIO_BASE + 10)
