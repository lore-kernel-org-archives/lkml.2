Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933135Ab2KZRHq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:07:46 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47590 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933117Ab2KZRHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:07:39 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sage Weil <sage@inktank.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 125/270] libceph: protect ceph_con_open() with mutex
Date: Mon, 26 Nov 2012 14:56:55 -0200
Message-Id: <1353949160-26803-126-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sage Weil <sage@inktank.com>

commit 5469155f2bc83bb2c88b0a0370c3d54d87eed06e upstream.

Take the con mutex while we are initiating a ceph open.  This is necessary
because the may have previously been in use and then closed, which could
result in a racing workqueue running con_work().

Signed-off-by: Sage Weil <sage@inktank.com>
Reviewed-by: Yehuda Sadeh <yehuda@inktank.com>
Reviewed-by: Alex Elder <elder@inktank.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/ceph/messenger.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index f1bd3bb..a477998 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -537,6 +537,7 @@ void ceph_con_open(struct ceph_connection *con,
 		   __u8 entity_type, __u64 entity_num,
 		   struct ceph_entity_addr *addr)
 {
+	mutex_lock(&con->mutex);
 	dout("con_open %p %s\n", con, ceph_pr_addr(&addr->in_addr));
 	set_bit(OPENING, &con->state);
 	WARN_ON(!test_and_clear_bit(CLOSED, &con->state));
@@ -546,6 +547,7 @@ void ceph_con_open(struct ceph_connection *con,
 
 	memcpy(&con->peer_addr, addr, sizeof(*addr));
 	con->delay = 0;      /* reset backoff memory */
+	mutex_unlock(&con->mutex);
 	queue_con(con);
 }
 EXPORT_SYMBOL(ceph_con_open);
-- 
1.7.9.5

