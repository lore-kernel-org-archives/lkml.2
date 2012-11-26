Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933386Ab2KZRJR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:09:17 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47696 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933242Ab2KZRJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:09:12 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>, Sage Weil <sage@inktank.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 149/270] ceph: Fix oops when handling mdsmap that decreases max_mds
Date: Mon, 26 Nov 2012 14:57:19 -0200
Message-Id: <1353949160-26803-150-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Yan, Zheng" <zheng.z.yan@intel.com>

commit 3e8f43a089f06279c5f76a9ccd42578eebf7bfa5 upstream.

When i >= newmap->m_max_mds, ceph_mdsmap_get_addr(newmap, i) return
NULL. Passing NULL to memcmp() triggers oops.

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
Signed-off-by: Sage Weil <sage@inktank.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 fs/ceph/mds_client.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 5ac6434..7f1682d 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -2634,7 +2634,8 @@ static void check_new_map(struct ceph_mds_client *mdsc,
 		     ceph_mdsmap_is_laggy(newmap, i) ? " (laggy)" : "",
 		     session_state_name(s->s_state));
 
-		if (memcmp(ceph_mdsmap_get_addr(oldmap, i),
+		if (i >= newmap->m_max_mds ||
+		    memcmp(ceph_mdsmap_get_addr(oldmap, i),
 			   ceph_mdsmap_get_addr(newmap, i),
 			   sizeof(struct ceph_entity_addr))) {
 			if (s->s_state == CEPH_MDS_SESSION_OPENING) {
-- 
1.7.9.5

