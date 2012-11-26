Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933149Ab2KZRxk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:53:40 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47594 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933121Ab2KZRHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:07:42 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sage Weil <sage@inktank.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 126/270] libceph: reset connection retry on successfully negotiation
Date: Mon, 26 Nov 2012 14:56:56 -0200
Message-Id: <1353949160-26803-127-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sage Weil <sage@inktank.com>

commit 85effe183dd45854d1ad1a370b88cddb403c4c91 upstream.

We exponentially back off when we encounter connection errors.  If several
errors accumulate, we will eventually wait ages before even trying to
reconnect.

Fix this by resetting the backoff counter after a successful negotiation/
connection with the remote node.  Fixes ceph issue #2802.

Signed-off-by: Sage Weil <sage@inktank.com>
Reviewed-by: Yehuda Sadeh <yehuda@inktank.com>
Reviewed-by: Alex Elder <elder@inktank.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/ceph/messenger.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index a477998..07204f1 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -1629,6 +1629,8 @@ static int process_connect(struct ceph_connection *con)
 		if (con->in_reply.flags & CEPH_MSG_CONNECT_LOSSY)
 			set_bit(LOSSYTX, &con->flags);
 
+		con->delay = 0;      /* reset backoff memory */
+
 		prepare_read_tag(con);
 		break;
 
-- 
1.7.9.5

