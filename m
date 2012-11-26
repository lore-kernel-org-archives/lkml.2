Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932540Ab2KZREy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:04:54 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47400 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932182Ab2KZREs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:04:48 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Elder <elder@inktank.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 081/270] libceph: provide osd number when creating osd
Date: Mon, 26 Nov 2012 14:56:11 -0200
Message-Id: <1353949160-26803-82-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Elder <elder@inktank.com>

commit e10006f807ffc4d5b1d861305d18d9e8145891ca upstream.

Pass the osd number to the create_osd() routine, and move the
initialization of fields that depend on it therein.

Signed-off-by: Alex Elder <elder@inktank.com>
Reviewed-by: Sage Weil <sage@inktank.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/ceph/osd_client.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index dc532c5..cb5b847 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -624,7 +624,7 @@ static void osd_reset(struct ceph_connection *con)
 /*
  * Track open sessions with osds.
  */
-static struct ceph_osd *create_osd(struct ceph_osd_client *osdc)
+static struct ceph_osd *create_osd(struct ceph_osd_client *osdc, int onum)
 {
 	struct ceph_osd *osd;
 
@@ -634,6 +634,7 @@ static struct ceph_osd *create_osd(struct ceph_osd_client *osdc)
 
 	atomic_set(&osd->o_ref, 1);
 	osd->o_osdc = osdc;
+	osd->o_osd = onum;
 	INIT_LIST_HEAD(&osd->o_requests);
 	INIT_LIST_HEAD(&osd->o_linger_requests);
 	INIT_LIST_HEAD(&osd->o_osd_lru);
@@ -643,6 +644,7 @@ static struct ceph_osd *create_osd(struct ceph_osd_client *osdc)
 	osd->o_con.private = osd;
 	osd->o_con.ops = &osd_con_ops;
 	osd->o_con.peer_name.type = CEPH_ENTITY_TYPE_OSD;
+	osd->o_con.peer_name.num = cpu_to_le64(onum);
 
 	INIT_LIST_HEAD(&osd->o_keepalive_item);
 	return osd;
@@ -998,15 +1000,13 @@ static int __map_request(struct ceph_osd_client *osdc,
 	req->r_osd = __lookup_osd(osdc, o);
 	if (!req->r_osd && o >= 0) {
 		err = -ENOMEM;
-		req->r_osd = create_osd(osdc);
+		req->r_osd = create_osd(osdc, o);
 		if (!req->r_osd) {
 			list_move(&req->r_req_lru_item, &osdc->req_notarget);
 			goto out;
 		}
 
 		dout("map_request osd %p is osd%d\n", req->r_osd, o);
-		req->r_osd->o_osd = o;
-		req->r_osd->o_con.peer_name.num = cpu_to_le64(o);
 		__insert_osd(osdc, req->r_osd);
 
 		ceph_con_open(&req->r_osd->o_con, &osdc->osdmap->osd_addr[o]);
-- 
1.7.9.5

