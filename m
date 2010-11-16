Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757176Ab0KPS5w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 13:57:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29557 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756185Ab0KPS5v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 13:57:51 -0500
Subject: Re: [PATCH] vfio: fix config virtualization, esp command byte
From: Alex Williamson <alex.williamson@redhat.com>
To: Tom Lyon <pugs@cisco.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
In-Reply-To: <1289930061.3069.5.camel@x201>
References: <4cd9f0d6.jnHBr6PBphKwDwhM%pugs@cisco.com>
	 <1289930061.3069.5.camel@x201>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Nov 2010 11:57:27 -0700
Message-ID: <1289933847.3069.8.camel@x201>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-16 at 10:54 -0700, Alex Williamson wrote:
> On Tue, 2010-11-09 at 17:09 -0800, Tom Lyon wrote:
> > Cleans up config space virtualization, especialy handling of bytes
> > which have some virtual and some real bits, like PCI_COMMAND.
> > 
> > Alex, I hope you can test this with your setups.
> 
> Sorry for the delay.  FWIW, I'm not having much luck with this, I'll try
> to debug the problem.  Thanks,

This seems to be the bug.  Thanks,

Alex

vfio: Don't write random bits on read

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

diff --git a/drivers/vfio/vfio_pci_config.c b/drivers/vfio/vfio_pci_config.c
index 7132ac4..422d7b1 100644
--- a/drivers/vfio/vfio_pci_config.c
+++ b/drivers/vfio/vfio_pci_config.c
@@ -964,11 +964,6 @@ static int vfio_config_rwbyte(int write,
 		return 0;
 	}
 
-	if (write) {
-		if (copy_from_user(&newval, buf, 1))
-			return -EFAULT;
-	}
-
 	if (~virt) {	/* mix of real and virt bits */
 		/* update vconfig with latest hw bits */
 		ret = vfio_read_config_byte(vdev, pos, &realbits);
@@ -978,9 +973,14 @@ static int vfio_config_rwbyte(int write,
 			(vdev->vconfig[pos] & virt) | (realbits & ~virt);
 	}
 
-	/* update vconfig with writeable bits */
-	vdev->vconfig[pos] =
-		(vdev->vconfig[pos] & ~wr) | (newval & wr);
+	if (write) {
+		if (copy_from_user(&newval, buf, 1))
+			return -EFAULT;
+
+		/* update vconfig with writeable bits */
+		vdev->vconfig[pos] =
+			(vdev->vconfig[pos] & ~wr) | (newval & wr);
+        }
 
 	/*
 	 * Now massage virtual fields


