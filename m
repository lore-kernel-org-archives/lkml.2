Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993027Ab2KOELr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 23:11:47 -0500
Received: from mail.kernel.org ([198.145.19.201]:49283 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993010Ab2KOELn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 23:11:43 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Ilija Hadzic <ihadzic@research.bell-labs.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [ 34/66] drm: restore open_count if drm_setup fails
Date: Wed, 14 Nov 2012 20:10:39 -0800
Message-Id: <20121115040941.464224906@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc3.16.g8ead1bf
In-Reply-To: <20121115040939.016421011@linuxfoundation.org>
References: <20121115040939.016421011@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilija Hadzic <ilijahadzic@gmail.com>

commit 0f1cb1bd94a9c967cd4ad3de51cfdabe61eb5dcc upstream.

If drm_setup (called at first open) fails, the whole
open call has failed, so we should not keep the
open_count incremented.

Signed-off-by: Ilija Hadzic <ihadzic@research.bell-labs.com>
Reviewed-by: Thomas Hellstrom <thellstrom@vmware.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/drm_fops.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/drm_fops.c
+++ b/drivers/gpu/drm/drm_fops.c
@@ -135,8 +135,11 @@ int drm_open(struct inode *inode, struct
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


