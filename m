Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755191Ab1ILVwB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 17:52:01 -0400
Received: from mail-vw0-f52.google.com ([209.85.212.52]:38381 "EHLO
	mail-vw0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754856Ab1ILVv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 17:51:58 -0400
MIME-Version: 1.0
Date: Mon, 12 Sep 2011 14:51:58 -0700
Message-ID: <CAB2gnbXatCnom+SUwSxyQ0Wt9TBESzbPoiDw2As90OyUVngQOA@mail.gmail.com>
Subject: [PATCH 2/2] ceph: fix ceph_monc_init memory leak
From: Noah Watkins <noahwatkins@gmail.com>
To: Sage Weil <sage@newdream.net>
Cc: ceph-devel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

failure clean up does not consider ceph_auth_init.

Signed-off-by: Noah Watkins <noahwatkins@gmail.com>
---
 net/ceph/mon_client.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/net/ceph/mon_client.c b/net/ceph/mon_client.c
index af2ef30..0b62dea 100644
--- a/net/ceph/mon_client.c
+++ b/net/ceph/mon_client.c
@@ -759,8 +759,10 @@ int ceph_monc_init(struct ceph_mon_client *monc,
struct ceph_client *cl)
 	/* authentication */
 	monc->auth = ceph_auth_init(cl->options->name,
 				    cl->options->key);
-	if (IS_ERR(monc->auth))
-		return PTR_ERR(monc->auth);
+	if (IS_ERR(monc->auth)) {
+		err = PTR_ERR(monc->auth);
+		goto out_con;
+	}
 	monc->auth->want_keys =
 		CEPH_ENTITY_TYPE_AUTH | CEPH_ENTITY_TYPE_MON |
 		CEPH_ENTITY_TYPE_OSD | CEPH_ENTITY_TYPE_MDS;
@@ -771,7 +773,7 @@ int ceph_monc_init(struct ceph_mon_client *monc,
struct ceph_client *cl)
 				     sizeof(struct ceph_mon_subscribe_ack),
 				     GFP_NOFS, true);
 	if (!monc->m_subscribe_ack)
-		goto out_con;
+		goto out_auth;

 	monc->m_subscribe = ceph_msg_new(CEPH_MSG_MON_SUBSCRIBE, 96, GFP_NOFS,
 					 true);
@@ -809,6 +811,8 @@ out_subscribe:
 	ceph_msg_put(monc->m_subscribe);
 out_subscribe_ack:
 	ceph_msg_put(monc->m_subscribe_ack);
+out_auth:
+	ceph_auth_destroy(monc->auth);
 out_con:
 	monc->con->ops->put(monc->con);
 out_monmap:
-- 
1.7.6.1
