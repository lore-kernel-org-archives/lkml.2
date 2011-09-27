Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818Ab1I0SKV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 14:10:21 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:65278 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883Ab1I0SKS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 14:10:18 -0400
MIME-Version: 1.0
X-Originating-IP: [89.139.46.211]
In-Reply-To: <87sjni9aql.fsf@ti.com>
References: <1316948337-7924-1-git-send-email-ohad@wizery.com>
 <1316948337-7924-3-git-send-email-ohad@wizery.com> <87sjni9aql.fsf@ti.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 27 Sep 2011 21:09:57 +0300
Message-ID: <CAK=WgbZhz8LcAYZEY3qqRkX4E_wtspWp09Eq9G=5VdpoMMF1FQ@mail.gmail.com>
Subject: Re: [RFC 2/5] ARM: OMAP: omap_device: add a method to set iommu
 private archdata
To: Kevin Hilman <khilman@ti.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Hiroshi DOYU <Hiroshi.DOYU@nokia.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Joerg Roedel <Joerg.Roedel@amd.com>, iommu@lists.linux-foundation.org,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Cousson Benoit <b-cousson@ti.com>, Tony Lindgren <tony@atomide.com>,
        Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kevin,

On Tue, Sep 27, 2011 at 1:53 AM, Kevin Hilman <khilman@ti.com> wrote:
> Benoit did just this in preparation for DT.
>
>       http://marc.info/?l=linux-omap&m=131672480111927&w=2
>
> Will that meet your needs?

It's almost there, but not entirely.

Benoit's alloc/delete functions focus on the omap_device part, leaving
the handling of the platform device (allocation and pdata setting) to
omap_device_build_ss(), which at the same time registers the pdev.

I'd need to split omap_device_build_ss() into two: an alloc() part
which does everything but registering the pdev, and a register() part.
Users will first call alloc(), manually set archdata members, and then
call the register() part.

Something like this (compile-tested only, based on Benoit's
for_3.2/4_omap4_dt_early_devices branch):

diff --git a/arch/arm/plat-omap/omap_device.c b/arch/arm/plat-omap/omap_device.c
index 0ae9e7f..9b8008c 100644
--- a/arch/arm/plat-omap/omap_device.c
+++ b/arch/arm/plat-omap/omap_device.c
@@ -671,7 +671,7 @@ struct platform_device *omap_device_build(const
char *pdev_name, int pdev_id,
 }

 /**
- * omap_device_build_ss - build and register an omap_device with
multiple hwmods
+ * omap_device_alloc_ss - build an omap_device with multiple hwmods
  * @pdev_name: name of the platform_device driver to use
  * @pdev_id: this platform_device's connection ID
  * @oh: ptr to the single omap_hwmod that backs this omap_device
@@ -679,19 +679,19 @@ struct platform_device *omap_device_build(const
char *pdev_name, int pdev_id,
  * @pdata_len: amount of memory pointed to by @pdata
  * @pm_lats: pointer to a omap_device_pm_latency array for this device
  * @pm_lats_cnt: ARRAY_SIZE() of @pm_lats
- * @is_early_device: should the device be registered as an early device or not
  *
- * Convenience function for building and registering an omap_device
+ * Convenience function for building (only) an omap_device
  * subsystem record.  Subsystem records consist of multiple
- * omap_hwmods.  This function in turn builds and registers a
- * platform_device record.  Returns an ERR_PTR() on error, or passes
- * along the return value of omap_device_register().
+ * omap_hwmods.  This function in turn builds (but doesn't register) a
+ * platform_device record, so callers can manipulate it (typically by
+ * setting one or more archdata members) before it's registered.
+ * Returns an ERR_PTR() on error, or the allocated pdev on success.
  */
-struct platform_device *omap_device_build_ss(const char *pdev_name,
int pdev_id,
+struct platform_device *omap_device_alloc_ss(const char *pdev_name,
int pdev_id,
 					 struct omap_hwmod **ohs, int oh_cnt,
 					 void *pdata, int pdata_len,
 					 struct omap_device_pm_latency *pm_lats,
-					 int pm_lats_cnt, int is_early_device)
+					 int pm_lats_cnt)
 {
 	int ret = -ENOMEM;
 	struct platform_device *pdev;
@@ -723,13 +723,6 @@ struct platform_device
*omap_device_build_ss(const char *pdev_name, int pdev_id,
 	if (ret)
 		goto odbs_exit2;

-	if (is_early_device)
-		ret = omap_early_device_register(pdev);
-	else
-		ret = omap_device_register(pdev);
-	if (ret)
-		goto odbs_exit2;
-
 	return pdev;

 odbs_exit2:
@@ -744,6 +737,93 @@ odbs_exit:
 }

 /**
+ * omap_device_delete_ss - free an omap_device-based platform device
+ * @pdev: platform_device that represents this omap_device
+ *
+ * Convenience function for freeing a platform_device record, which
+ * is based on an omap_device subsystem record.
+ *
+ * Use this function only if @pdev was created using omap_device_alloc_ss(),
+ * most commonly because a subsequent call to omap_device_register_ss() failed.
+ */
+void omap_device_delete_ss(struct platform_device *pdev)
+{
+	struct omap_device *od = to_omap_device(pdev);
+
+	omap_device_delete(od);
+	platform_device_put(pdev);
+}
+
+/**
+ * omap_device_register_ss - register an omap_device-based platform device
+ * @pdev: platform_device that represents this omap_device
+ * @is_early_device: should the device be registered as an early device or not
+ *
+ * Convenience function for registering a platform_device record, which
+ * is based on an omap_device subsystem record, which was created using
+ * omap_device_alloc_ss().
+ *
+ * Returns 0 on success, or an appropriate error value otherwise (essentially
+ * by returning the value of platform_device_register())
+ */
+int omap_device_register_ss(struct platform_device *pdev, int is_early_device)
+{
+	int ret;
+
+	if (is_early_device)
+		ret = omap_early_device_register(pdev);
+	else
+		ret = omap_device_register(pdev);
+
+	return ret;
+}
+
+/**
+ * omap_device_build_ss - build and register an omap_device with
multiple hwmods
+ * @pdev_name: name of the platform_device driver to use
+ * @pdev_id: this platform_device's connection ID
+ * @oh: ptr to the single omap_hwmod that backs this omap_device
+ * @pdata: platform_data ptr to associate with the platform_device
+ * @pdata_len: amount of memory pointed to by @pdata
+ * @pm_lats: pointer to a omap_device_pm_latency array for this device
+ * @pm_lats_cnt: ARRAY_SIZE() of @pm_lats
+ * @is_early_device: should the device be registered as an early device or not
+ *
+ * Convenience function for building and registering an omap_device
+ * subsystem record.  Subsystem records consist of multiple
+ * omap_hwmods.  This function in turn builds and registers a
+ * platform_device record.  Returns an ERR_PTR() on error, or passes
+ * along the built pdev on success.
+ */
+struct platform_device *omap_device_build_ss(const char *pdev_name,
int pdev_id,
+					 struct omap_hwmod **ohs, int oh_cnt,
+					 void *pdata, int pdata_len,
+					 struct omap_device_pm_latency *pm_lats,
+					 int pm_lats_cnt, int is_early_device)
+{
+	struct platform_device *pdev;
+	int ret;
+
+	pdev = omap_device_alloc_ss(pdev_name, pdev_id, ohs, oh_cnt, pdata,
+			pdata_len, pm_lats, pm_lats_cnt);
+
+	if (IS_ERR(pdev))
+		goto out;
+
+	ret = omap_device_register_ss(pdev, is_early_device);
+	if (ret) {
+		pdev = ERR_PTR(ret);
+		goto delete_od;
+	}
+
+	return pdev;
+delete_od:
+	omap_device_delete_ss(pdev);
+out:
+	return pdev;
+}
+
+/**
  * omap_early_device_register - register an omap_device as an early platform
  * device.
  * @od: struct omap_device * to register


That's the idea; please tell me how you'd like to see this go forward
(there are at least several personal-taste issues here, e.g., naming:
now we have two sets of alloc/delete functions which have different
semantics) and which branch would you like me to base this work off of
(not sure if Benoit's patches already went into your
for_3.2/omap_device branch) and I'll respin this patch properly.

Thanks a lot!
Ohad.
