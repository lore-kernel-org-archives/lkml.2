Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933114Ab2KZRzc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:55:32 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47574 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933070Ab2KZRHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:07:24 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sage Weil <sage@inktank.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 121/270] libceph: report socket read/write error message
Date: Mon, 26 Nov 2012 14:56:51 -0200
Message-Id: <1353949160-26803-122-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sage Weil <sage@inktank.com>

commit 3a140a0d5c4b9e35373b016e41dfc85f1e526bdb upstream.

We need to set error_msg to something useful before calling ceph_fault();
do so here for try_{read,write}().  This is more informative than

libceph: osd0 192.168.106.220:6801 (null)

Signed-off-by: Sage Weil <sage@inktank.com>
Reviewed-by: Alex Elder <elder@inktank.com>
Reviewed-by: Yehuda Sadeh <yehuda@inktank.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/ceph/messenger.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index 63e1252..6e2f678 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -2287,14 +2287,18 @@ restart:
 	ret = try_read(con);
 	if (ret == -EAGAIN)
 		goto restart;
-	if (ret < 0)
+	if (ret < 0) {
+		con->error_msg = "socket error on read";
 		goto fault;
+	}
 
 	ret = try_write(con);
 	if (ret == -EAGAIN)
 		goto restart;
-	if (ret < 0)
+	if (ret < 0) {
+		con->error_msg = "socket error on write";
 		goto fault;
+	}
 
 done:
 	mutex_unlock(&con->mutex);
-- 
1.7.9.5

