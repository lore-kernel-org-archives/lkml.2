Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757667Ab0EEIRm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 04:17:42 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55497 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753854Ab0EEIRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 04:17:39 -0400
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: dedekind1@gmail.com
Cc: Marc Kleine-Budde <mkl@pengutronix.de>,
       David Woodhouse <dwmw2@infradead.org>, Andi Kleen <ak@linux.intel.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Dmitry Pervushin <dpervushin@embeddedalley.com>,
       Kevin Cernekee <kpc.mtd@gmail.com>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org
Date: Wed,  5 May 2010 10:17:25 +0200
Message-Id: <1273047445-23411-1-git-send-email-mkl@pengutronix.de>
X-Mailer: git-send-email 1.7.1
X-SA-Exim-Connect-IP: 92.198.50.58
X-SA-Exim-Mail-From: mkl@pengutronix.de
Subject: [PATCH V2] ubi: init even if mtd device cannot be attached, if built into kernel
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on metis.ext.pengutronix.de)
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ubi can be built into the kernel or be compiled as a kernel module.
Further on the command line one can specify mtd devices to be attach to
ubi while loading. In the current implementation the ubi driver refuses
to load if one of the mtd devices cannot be attached.

Consider:
1) ubi compiled into the kernel and
2) a mtd device specified on the command line and
3) this mtd device contains bogus data (for whatever reason).

During init ubi tries to attach the mtd device is this fails the whole
ubi subsystem isn't initialized. Later the userspace cannot attach any
mtd to ubi because ubi isn't loaded.

This patch keeps the current behaviour: if ubi is compiled as a module
and a mtd device cannot be attached the ubi module cannot be loaded,
but changes it for the ubi-is-built-into-the-kernel usecase.

If ubi is builtin, a not attachable mtd device doen't stop ubi from
initializing. This slightly modifies the behaviour if multiple mtd
devices are specified on the command line. Now every mtd device is
probed and, if possible, attached, i.e. a faulty mtd device doesn't
stop the others from being attached.

V2: integrated comments from Artem Bityutskiy:
    use defines instead of static inline functions

Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/mtd/ubi/build.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/ubi/build.c b/drivers/mtd/ubi/build.c
index fad40aa..d0447a5 100644
--- a/drivers/mtd/ubi/build.c
+++ b/drivers/mtd/ubi/build.c
@@ -49,6 +49,12 @@
 /* Maximum length of the 'mtd=' parameter */
 #define MTD_PARAM_LEN_MAX 64
 
+#ifdef CONFIG_MTD_UBI_MODULE
+#define ubi_is_module() 1
+#else
+#define ubi_is_module() 0
+#endif
+
 /**
  * struct mtd_dev_param - MTD device parameter description data structure.
  * @name: MTD character device node path, MTD device name, or MTD device number
@@ -1240,9 +1246,11 @@ static int __init ubi_init(void)
 					 p->vid_hdr_offs);
 		mutex_unlock(&ubi_devices_mutex);
 		if (err < 0) {
-			put_mtd_device(mtd);
 			ubi_err("cannot attach mtd%d", mtd->index);
-			goto out_detach;
+			if (ubi_is_module()) {
+				put_mtd_device(mtd);
+				goto out_detach;
+			}
 		}
 	}
 
-- 
1.7.1

