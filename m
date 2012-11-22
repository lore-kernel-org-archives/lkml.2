Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758662Ab2KVWow (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 17:44:52 -0500
Received: from mail.kernel.org ([198.145.19.201]:49015 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753451Ab2KVSdf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:33:35 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        "Yan, Zheng" <zheng.z.yan@intel.com>, Sage Weil <sage@inktank.com>
Subject: [ 167/171] ceph: Fix oops when handling mdsmap that decreases max_mds
Date: Wed, 21 Nov 2012 16:41:53 -0800
Message-Id: <20121122004050.103315082@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122004033.298367941@linuxfoundation.org>
References: <20121122004033.298367941@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Yan, Zheng" <zheng.z.yan@intel.com>

(cherry picked from commit 3e8f43a089f06279c5f76a9ccd42578eebf7bfa5)

When i >= newmap->m_max_mds, ceph_mdsmap_get_addr(newmap, i) return
NULL. Passing NULL to memcmp() triggers oops.

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
Signed-off-by: Sage Weil <sage@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/mds_client.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -2634,7 +2634,8 @@ static void check_new_map(struct ceph_md
 		     ceph_mdsmap_is_laggy(newmap, i) ? " (laggy)" : "",
 		     session_state_name(s->s_state));
 
-		if (memcmp(ceph_mdsmap_get_addr(oldmap, i),
+		if (i >= newmap->m_max_mds ||
+		    memcmp(ceph_mdsmap_get_addr(oldmap, i),
 			   ceph_mdsmap_get_addr(newmap, i),
 			   sizeof(struct ceph_entity_addr))) {
 			if (s->s_state == CEPH_MDS_SESSION_OPENING) {


