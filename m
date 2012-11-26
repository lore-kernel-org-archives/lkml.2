Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932585Ab2KZRFH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:05:07 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47412 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932562Ab2KZRFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:05:01 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sage Weil <sage@newdream.net>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 084/270] libceph: drop connection refcounting for mon_client
Date: Mon, 26 Nov 2012 14:56:14 -0200
Message-Id: <1353949160-26803-85-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sage Weil <sage@inktank.com>

commit ec87ef4309d33bd9c87a53bb5152a86ae7a65f25 upstream.

All references to the embedded ceph_connection come from the msgr
workqueue, which is drained prior to mon_client destruction.  That
means we can ignore con refcounting entirely.

Signed-off-by: Sage Weil <sage@newdream.net>
Reviewed-by: Alex Elder <elder@inktank.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/ceph/mon_client.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/net/ceph/mon_client.c b/net/ceph/mon_client.c
index ec75996..b59ca7a 100644
--- a/net/ceph/mon_client.c
+++ b/net/ceph/mon_client.c
@@ -1037,9 +1037,23 @@ out:
 	mutex_unlock(&monc->mutex);
 }
 
+/*
+ * We can ignore refcounting on the connection struct, as all references
+ * will come from the messenger workqueue, which is drained prior to
+ * mon_client destruction.
+ */
+static struct ceph_connection *con_get(struct ceph_connection *con)
+{
+	return con;
+}
+
+static void con_put(struct ceph_connection *con)
+{
+}
+
 static const struct ceph_connection_operations mon_con_ops = {
-	.get = ceph_con_get,
-	.put = ceph_con_put,
+	.get = con_get,
+	.put = con_put,
 	.dispatch = dispatch,
 	.fault = mon_fault,
 	.alloc_msg = mon_alloc_msg,
-- 
1.7.9.5

