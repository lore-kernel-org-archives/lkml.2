Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507Ab2HGMmZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 08:42:25 -0400
Received: from mail.ispras.ru ([83.149.199.43]:37949 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753817Ab2HGMmY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 08:42:24 -0400
X-Greylist: delayed 1063 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Aug 2012 08:42:24 EDT
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Carsten Emde <C.Emde@osadl.org>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, ldv-project@ispras.ru
Subject: [PATCH] drm/edid: Fix potential memory leak in edid_load()
Date: Tue,  7 Aug 2012 16:23:06 +0400
Message-Id: <1344342186-6561-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not leak memory by updating pointer with potentially
NULL realloc return value.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/gpu/drm/drm_edid_load.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/drm_edid_load.c b/drivers/gpu/drm/drm_edid_load.c
index 66d4a28..0303935 100644
--- a/drivers/gpu/drm/drm_edid_load.c
+++ b/drivers/gpu/drm/drm_edid_load.c
@@ -119,7 +119,7 @@ static int edid_load(struct drm_connector *connector, char *name,
 {
 	const struct firmware *fw;
 	struct platform_device *pdev;
-	u8 *fwdata = NULL, *edid;
+	u8 *fwdata = NULL, *edid, *new_edid;
 	int fwsize, expected;
 	int builtin = 0, err = 0;
 	int i, valid_extensions = 0;
@@ -195,12 +195,14 @@ static int edid_load(struct drm_connector *connector, char *name,
 		    "\"%s\" for connector \"%s\"\n", valid_extensions,
 		    edid[0x7e], name, connector_name);
 		edid[0x7e] = valid_extensions;
-		edid = krealloc(edid, (valid_extensions + 1) * EDID_LENGTH,
+		new_edid = krealloc(edid, (valid_extensions + 1) * EDID_LENGTH,
 		    GFP_KERNEL);
-		if (edid == NULL) {
+		if (new_edid == NULL) {
 			err = -ENOMEM;
+			kfree(edid);
 			goto relfw_out;
 		}
+		edid = new_edid;
 	}
 
 	connector->display_info.raw_edid = edid;
-- 
1.7.9.5

