Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754320Ab0ELKus (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 06:50:48 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:54480 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284Ab0ELKur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 06:50:47 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Wed, 12 May 2010 12:51:13 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCH] USB: gadget: f_mass_storage: fix in error recovery
In-reply-to: <70376CA23424B34D86F1C7DE6B9973430254343ABF@VSHINMSMBX01.vshodc.lntinfotech.com>
To: linux-usb@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       Viral Mehta <Viral.Mehta@lntinfotech.com>, linux-kernel@vger.kernel.org,
       Michal Nazarewicz <mina86@mina86.com>
Message-id: <1148fb1fcb3a9864a2a12fbbf2e3444827c9ed4a.1273661077.git.mina86@mina86.com>
X-Mailer: git-send-email 1.7.1
References: <994e1bf34d3b6f1fbc58c0f7ce61c7f258208ddd.1273651956.git.mina86@mina86.com>
 <70376CA23424B34D86F1C7DE6B9973430254343ABA@VSHINMSMBX01.vshodc.lntinfotech.com>
 <op.vck4q0c87p4s8u@pikus>
 <70376CA23424B34D86F1C7DE6B9973430254343ABB@VSHINMSMBX01.vshodc.lntinfotech.com>
 <70376CA23424B34D86F1C7DE6B9973430254343ABC@VSHINMSMBX01.vshodc.lntinfotech.com>
 <op.vck7aofj7p4s8u@pikus>
 <70376CA23424B34D86F1C7DE6B9973430254343ABF@VSHINMSMBX01.vshodc.lntinfotech.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In to places in fsg_common_init() an unconditional call to kfree()
on common was performed in error recovery which is not a valid
behaviour since fsg_common structure is not always allocated by
fsg_common_init().

To fix, the calls has been replaced with a goto to a proper error
recovery which does the correct thing.

Also, refactored fsg_common_release() function.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
---
On Wed, 12 May 2010 12:33:43 +0200, Viral Mehta <Viral.Mehta@lntinfotech.com> wrote:
> In that case, in addition to your previous patch, below hunk is needed
>
> diff --git a/drivers/usb/gadget/f_mass_storage.c b/drivers/usb/gadget/f_mass_storage.c
> index f4911c0..b1648fc 100644
> --- a/drivers/usb/gadget/f_mass_storage.c
> +++ b/drivers/usb/gadget/f_mass_storage.c
> @@ -2883,15 +2883,16 @@ static void fsg_common_release(struct kref *ref)
>
>         /* Beware tempting for -> do-while optimization: when in error
>          * recovery nluns may be zero. */
> +       if(common->luns) {
> +               for (; i; --i, ++lun) {
> +                       device_remove_file(&lun->dev, &dev_attr_ro);
> +                       device_remove_file(&lun->dev, &dev_attr_file);
> +                       fsg_lun_close(lun);
> +                       device_unregister(&lun->dev);
> +               }
>
> -       for (; i; --i, ++lun) {
> -               device_remove_file(&lun->dev, &dev_attr_ro);
> -               device_remove_file(&lun->dev, &dev_attr_file);
> -               fsg_lun_close(lun);
> -               device_unregister(&lun->dev);
> +               kfree(common->luns);
>         }
> -
> -       kfree(common->luns);
>         if (common->free_storage_on_release)
>                 kfree(common);
>  }

This is not entairly true but if you insist, attached is a bit
different version of your proposed chang.

 drivers/usb/gadget/f_mass_storage.c |   51 +++++++++++++++++------------------
 1 files changed, 25 insertions(+), 26 deletions(-)

diff --git a/drivers/usb/gadget/f_mass_storage.c b/drivers/usb/gadget/f_mass_storage.c
index 6cfd2f4..7d05a0b 100644
--- a/drivers/usb/gadget/f_mass_storage.c
+++ b/drivers/usb/gadget/f_mass_storage.c
@@ -2742,10 +2742,8 @@ static struct fsg_common *fsg_common_init(struct fsg_common *common,
 	/* Maybe allocate device-global string IDs, and patch descriptors */
 	if (fsg_strings[FSG_STRING_INTERFACE].id == 0) {
 		rc = usb_string_id(cdev);
-		if (rc < 0) {
-			kfree(common);
-			return ERR_PTR(rc);
-		}
+		if (unlikely(rc < 0))
+			goto error_release;
 		fsg_strings[FSG_STRING_INTERFACE].id = rc;
 		fsg_intf_desc.iInterface = rc;
 	}
@@ -2753,9 +2751,9 @@ static struct fsg_common *fsg_common_init(struct fsg_common *common,
 	/* Create the LUNs, open their backing files, and register the
 	 * LUN devices in sysfs. */
 	curlun = kzalloc(nluns * sizeof *curlun, GFP_KERNEL);
-	if (!curlun) {
-		kfree(common);
-		return ERR_PTR(-ENOMEM);
+	if (unlikely(!curlun)) {
+		rc = -ENOMEM;
+		goto error_release;
 	}
 	common->luns = curlun;
 
@@ -2914,11 +2912,7 @@ error_release:
 
 static void fsg_common_release(struct kref *ref)
 {
-	struct fsg_common *common =
-		container_of(ref, struct fsg_common, ref);
-	unsigned i = common->nluns;
-	struct fsg_lun *lun = common->luns;
-	struct fsg_buffhd *bh;
+	struct fsg_common *common = container_of(ref, struct fsg_common, ref);
 
 	/* If the thread isn't already dead, tell it to exit now */
 	if (common->state != FSG_STATE_TERMINATED) {
@@ -2929,23 +2923,28 @@ static void fsg_common_release(struct kref *ref)
 		complete(&common->thread_notifier);
 	}
 
-	/* Beware tempting for -> do-while optimization: when in error
-	 * recovery nluns may be zero. */
+	if (likely(common->luns)) {
+		struct fsg_lun *lun = common->luns;
+		unsigned i = common->nluns;
 
-	for (; i; --i, ++lun) {
-		device_remove_file(&lun->dev, &dev_attr_ro);
-		device_remove_file(&lun->dev, &dev_attr_file);
-		fsg_lun_close(lun);
-		device_unregister(&lun->dev);
-	}
+		/* In error recovery common->nluns may be zero. */
+		for (; i; --i, ++lun) {
+			device_remove_file(&lun->dev, &dev_attr_ro);
+			device_remove_file(&lun->dev, &dev_attr_file);
+			fsg_lun_close(lun);
+			device_unregister(&lun->dev);
+		}
 
-	kfree(common->luns);
+		kfree(common->luns);
+	}
 
-	i = FSG_NUM_BUFFERS;
-	bh = common->buffhds;
-	do {
-		kfree(bh->buf);
-	} while (++bh, --i);
+	{
+		struct fsg_buffhd *bh = common->buffhds;
+		unsigned i = FSG_NUM_BUFFERS;
+		do {
+			kfree(bh->buf);
+		} while (++bh, --i);
+	}
 
 	if (common->free_storage_on_release)
 		kfree(common);
-- 
1.7.1

