Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756398Ab2KNGAE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 01:00:04 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55169 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756337Ab2KNFur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 00:50:47 -0500
Message-Id: <20121114053941.859256353@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 14 Nov 2012 05:40:31 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ilija Hadzic <ilijahadzic@gmail.com>,
        Ilija Hadzic <ihadzic@research.bell-labs.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [ 58/82] drm: restore open_count if drm_setup fails
In-Reply-To: <20121114053933.726869752@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilija Hadzic <ilijahadzic@gmail.com>

commit 0f1cb1bd94a9c967cd4ad3de51cfdabe61eb5dcc upstream.

If drm_setup (called at first open) fails, the whole
open call has failed, so we should not keep the
open_count incremented.

Signed-off-by: Ilija Hadzic <ihadzic@research.bell-labs.com>
Reviewed-by: Thomas Hellstrom <thellstrom@vmware.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/drm_fops.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_fops.c b/drivers/gpu/drm/drm_fops.c
index 7ef1b67..af68eca 100644
--- a/drivers/gpu/drm/drm_fops.c
+++ b/drivers/gpu/drm/drm_fops.c
@@ -135,8 +135,11 @@ int drm_open(struct inode *inode, struct file *filp)
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


