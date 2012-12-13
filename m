Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080Ab2LMOEU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:04:20 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44222 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756193Ab2LMOEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:04:10 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ilija Hadzic <ihadzic@research.bell-labs.com>,
        Dave Airlie <airlied@redhat.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 055/241] drm: restore open_count if drm_setup fails
Date: Thu, 13 Dec 2012 11:57:00 -0200
Message-Id: <1355407206-17100-56-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilija Hadzic <ilijahadzic@gmail.com>

commit 0f1cb1bd94a9c967cd4ad3de51cfdabe61eb5dcc upstream.

If drm_setup (called at first open) fails, the whole
open call has failed, so we should not keep the
open_count incremented.

Signed-off-by: Ilija Hadzic <ihadzic@research.bell-labs.com>
Reviewed-by: Thomas Hellstrom <thellstrom@vmware.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/gpu/drm/drm_fops.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_fops.c b/drivers/gpu/drm/drm_fops.c
index 123de28..b90abff 100644
--- a/drivers/gpu/drm/drm_fops.c
+++ b/drivers/gpu/drm/drm_fops.c
@@ -139,8 +139,11 @@ int drm_open(struct inode *inode, struct file *filp)
 	retcode = drm_open_helper(inode, filp, dev);
 	if (!retcode) {
 		atomic_inc(&dev->counts[_DRM_STAT_OPENS]);
-		if (!dev->open_count++)
+		if (!dev->open_count++) {
 			retcode = drm_setup(dev);
+			if (retcode)
+				dev->open_count--;
+		}
 	}
 	if (!retcode) {
 		mutex_lock(&dev->struct_mutex);
-- 
1.7.9.5

