Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758679Ab2KVWjd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 17:39:33 -0500
Received: from mail.kernel.org ([198.145.19.201]:49021 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753545Ab2KVSdl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:33:41 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alex Elder <elder@inktank.com>, Sage Weil <sage@inktank.com>
Subject: [ 100/171] libceph: provide osd number when creating osd
Date: Wed, 21 Nov 2012 16:40:46 -0800
Message-Id: <20121122004043.398590304@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122004033.298367941@linuxfoundation.org>
References: <20121122004033.298367941@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Elder <elder@inktank.com>

(cherry picked from commit e10006f807ffc4d5b1d861305d18d9e8145891ca)

Pass the osd number to the create_osd() routine, and move the
initialization of fields that depend on it therein.

Signed-off-by: Alex Elder <elder@inktank.com>
Reviewed-by: Sage Weil <sage@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/osd_client.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -624,7 +624,7 @@ static void osd_reset(struct ceph_connec
 /*
  * Track open sessions with osds.
  */
-static struct ceph_osd *create_osd(struct ceph_osd_client *osdc)
+static struct ceph_osd *create_osd(struct ceph_osd_client *osdc, int onum)
 {
 	struct ceph_osd *osd;
 
@@ -634,6 +634,7 @@ static struct ceph_osd *create_osd(struc
 
 	atomic_set(&osd->o_ref, 1);
 	osd->o_osdc = osdc;
+	osd->o_osd = onum;
 	INIT_LIST_HEAD(&osd->o_requests);
 	INIT_LIST_HEAD(&osd->o_linger_requests);
 	INIT_LIST_HEAD(&osd->o_osd_lru);
@@ -643,6 +644,7 @@ static struct ceph_osd *create_osd(struc
 	osd->o_con.private = osd;
 	osd->o_con.ops = &osd_con_ops;
 	osd->o_con.peer_name.type = CEPH_ENTITY_TYPE_OSD;
+	osd->o_con.peer_name.num = cpu_to_le64(onum);
 
 	INIT_LIST_HEAD(&osd->o_keepalive_item);
 	return osd;
@@ -998,15 +1000,13 @@ static int __map_request(struct ceph_osd
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


