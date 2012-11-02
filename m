Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763081Ab2KBRMT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 13:12:19 -0400
Received: from mail.kernel.org ([198.145.19.201]:33391 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762989Ab2KBRHp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 13:07:45 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        "Yan, Zheng" <zheng.z.yan@intel.com>, Sage Weil <sage@inktank.com>
Subject: [ 12/24] ceph: Fix oops when handling mdsmap that decreases max_mds
Date: Fri,  2 Nov 2012 10:07:00 -0700
Message-Id: <20121102170248.303699016@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc3.16.g8ead1bf
In-Reply-To: <20121102170247.406319110@linuxfoundation.org>
References: <20121102170247.406319110@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Yan, Zheng" <zheng.z.yan@intel.com>

commit 3e8f43a089f06279c5f76a9ccd42578eebf7bfa5 upstream.

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
@@ -2625,7 +2625,8 @@ static void check_new_map(struct ceph_md
 		     ceph_mdsmap_is_laggy(newmap, i) ? " (laggy)" : "",
 		     session_state_name(s->s_state));
 
-		if (memcmp(ceph_mdsmap_get_addr(oldmap, i),
+		if (i >= newmap->m_max_mds ||
+		    memcmp(ceph_mdsmap_get_addr(oldmap, i),
 			   ceph_mdsmap_get_addr(newmap, i),
 			   sizeof(struct ceph_entity_addr))) {
 			if (s->s_state == CEPH_MDS_SESSION_OPENING) {


