Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758719Ab2KVWrQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 17:47:16 -0500
Received: from mail.kernel.org ([198.145.19.201]:49009 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753397Ab2KVSda (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:33:30 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Sage Weil <sage@newdream.net>, Alex Elder <elder@inktank.com>
Subject: [ 103/171] libceph: drop connection refcounting for mon_client
Date: Wed, 21 Nov 2012 16:40:49 -0800
Message-Id: <20121122004043.700214272@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122004033.298367941@linuxfoundation.org>
References: <20121122004033.298367941@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sage Weil <sage@inktank.com>

(cherry picked from commit ec87ef4309d33bd9c87a53bb5152a86ae7a65f25)

All references to the embedded ceph_connection come from the msgr
workqueue, which is drained prior to mon_client destruction.  That
means we can ignore con refcounting entirely.

Signed-off-by: Sage Weil <sage@newdream.net>
Reviewed-by: Alex Elder <elder@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/mon_client.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

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


