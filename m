Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759236Ab2EUVTH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 17:19:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18078 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932076Ab2EUVSr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 17:18:47 -0400
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 7/8] gfs2: fix recovery during unmount
Date: Mon, 21 May 2012 16:18:39 -0500
Message-Id: <1337635120-19969-8-git-send-email-teigland@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Journal recovery from lock_dlm should not be ignored
if there is an unmount in progress.  Ignoring it will
causes the recovery to get stuck.  The recovery
process will correctly handle an in-progess unmount.

Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/gfs2/sys.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/gfs2/sys.c b/fs/gfs2/sys.c
index d33172c..9c2592b 100644
--- a/fs/gfs2/sys.c
+++ b/fs/gfs2/sys.c
@@ -368,10 +368,7 @@ int gfs2_recover_set(struct gfs2_sbd *sdp, unsigned jid)
 	struct gfs2_jdesc *jd;
 	int rv;
 
-	rv = -ESHUTDOWN;
 	spin_lock(&sdp->sd_jindex_spin);
-	if (test_bit(SDF_NORECOVERY, &sdp->sd_flags))
-		goto out;
 	rv = -EBUSY;
 	if (sdp->sd_jdesc->jd_jid == jid)
 		goto out;
@@ -396,8 +393,13 @@ static ssize_t recover_store(struct gfs2_sbd *sdp, const char *buf, size_t len)
 	if (rv != 1)
 		return -EINVAL;
 
-	rv = gfs2_recover_set(sdp, jid);
+	if (test_bit(SDF_NORECOVERY, &sdp->sd_flags)) {
+		rv = -ESHUTDOWN;
+		goto out;
+	}
 
+	rv = gfs2_recover_set(sdp, jid);
+out:
 	return rv ? rv : len;
 }
 
-- 
1.7.10.1.362.g242cab3

