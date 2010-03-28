Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154Ab0C1LYt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 07:24:49 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:42823 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647Ab0C1LYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 07:24:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=E2lS8tqHs2JYYgtJKE5y2B8FEkOy38VvGSO6me188INcsWTULhAqGziJ6AujfOxCTN
         XcBLETCCeEPl5JaIpocd4y+SU5/hd+pigna3cuNgSjkKCJa2d2yMOJHUANNUx/hjkNmJ
         Wdnqd063fhfddu9kpdCX9To/BYVpmowTJi2E4=
Date: Sun, 28 Mar 2010 14:24:38 +0300
From: Dan Carpenter <error27@gmail.com>
To: David Airlie <airlied@linux.ie>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Andi Kleen <ak@linux.intel.com>,
       Thomas Hellstrom <thellstrom@vmware.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [patch] drm: sysfs files error handling
Message-ID: <20100328112438.GK5069@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	David Airlie <airlied@linux.ie>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Andi Kleen <ak@linux.intel.com>,
	Thomas Hellstrom <thellstrom@vmware.com>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In the original code we used "j" as an iterator but we used "i" as an
index.

-               for (j = 0; j < i; j++)
-                       device_remove_file(&connector->kdev,
-                                          &connector_attrs[i]);

Smatch complained about that because "i" was potentially passed the end
of the array.  Which makes sense if we should be using "j" there.

I also thought that we should remove the files for &connector_attrs_opt1
but to do that I had to add separate iterators for &connector_attrs and
&connector_attrs_opt1.

Signed-off-by: Dan Carpenter <error27@gmail.com>
---
Found by static analysis and compile tested only.

diff --git a/drivers/gpu/drm/drm_sysfs.c b/drivers/gpu/drm/drm_sysfs.c
index 014ce24..f144487 100644
--- a/drivers/gpu/drm/drm_sysfs.c
+++ b/drivers/gpu/drm/drm_sysfs.c
@@ -353,7 +353,10 @@ static struct bin_attribute edid_attr = {
 int drm_sysfs_connector_add(struct drm_connector *connector)
 {
 	struct drm_device *dev = connector->dev;
-	int ret = 0, i, j;
+	int attr_cnt = 0;
+	int opt_cnt = 0;
+	int i;
+	int ret = 0;
 
 	/* We shouldn't get called more than once for the same connector */
 	BUG_ON(device_is_registered(&connector->kdev));
@@ -376,8 +379,8 @@ int drm_sysfs_connector_add(struct drm_connector *connector)
 
 	/* Standard attributes */
 
-	for (i = 0; i < ARRAY_SIZE(connector_attrs); i++) {
-		ret = device_create_file(&connector->kdev, &connector_attrs[i]);
+	for (attr_cnt = 0; attr_cnt < ARRAY_SIZE(connector_attrs); attr_cnt++) {
+		ret = device_create_file(&connector->kdev, &connector_attrs[attr_cnt]);
 		if (ret)
 			goto err_out_files;
 	}
@@ -393,8 +396,8 @@ int drm_sysfs_connector_add(struct drm_connector *connector)
 		case DRM_MODE_CONNECTOR_SVIDEO:
 		case DRM_MODE_CONNECTOR_Component:
 		case DRM_MODE_CONNECTOR_TV:
-			for (i = 0; i < ARRAY_SIZE(connector_attrs_opt1); i++) {
-				ret = device_create_file(&connector->kdev, &connector_attrs_opt1[i]);
+			for (opt_cnt = 0; opt_cnt < ARRAY_SIZE(connector_attrs_opt1); opt_cnt++) {
+				ret = device_create_file(&connector->kdev, &connector_attrs_opt1[opt_cnt]);
 				if (ret)
 					goto err_out_files;
 			}
@@ -413,10 +416,10 @@ int drm_sysfs_connector_add(struct drm_connector *connector)
 	return 0;
 
 err_out_files:
-	if (i > 0)
-		for (j = 0; j < i; j++)
-			device_remove_file(&connector->kdev,
-					   &connector_attrs[i]);
+	for (i = 0; i < opt_cnt; i++)
+		device_remove_file(&connector->kdev, &connector_attrs_opt1[i]);
+	for (i = 0; i < attr_cnt; i++)
+		device_remove_file(&connector->kdev, &connector_attrs[i]);
 	device_unregister(&connector->kdev);
 
 out:
