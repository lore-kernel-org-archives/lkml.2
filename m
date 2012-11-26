Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757190Ab2KZR6j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:58:39 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47510 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932704Ab2KZRGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:06:30 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Elder <elder@inktank.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 107/270] libceph: just set SOCK_CLOSED when state changes
Date: Mon, 26 Nov 2012 14:56:37 -0200
Message-Id: <1353949160-26803-108-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Elder <elder@inktank.com>

commit d65c9e0b9eb43d14ece9dd843506ccba06162ee7 upstream.

When a TCP_CLOSE or TCP_CLOSE_WAIT event occurs, the SOCK_CLOSED
connection flag bit is set, and if it had not been previously set
queue_con() is called to ensure con_work() will get a chance to
handle the changed state.

con_work() atomically checks--and if set, clears--the SOCK_CLOSED
bit if it was set.  This means that even if the bit were set
repeatedly, the related processing in con_work() only gets called
once per transition of the bit from 0 to 1.

What's important then is that we ensure con_work() gets called *at
least* once when a socket close event occurs, not that it gets
called *exactly* once.

The work queue mechanism already takes care of queueing work
only if it is not already queued, so there's no need for us
to call queue_con() conditionally.

So this patch just makes it so the SOCK_CLOSED flag gets set
unconditionally in ceph_sock_state_change().

Signed-off-by: Alex Elder <elder@inktank.com>
Reviewed-by: Sage Weil <sage@inktank.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/ceph/messenger.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index 5bd243e..cd1aaa8 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -261,8 +261,8 @@ static void ceph_sock_state_change(struct sock *sk)
 	case TCP_CLOSE_WAIT:
 		dout("%s TCP_CLOSE_WAIT\n", __func__);
 		con_sock_state_closing(con);
-		if (!test_and_set_bit(SOCK_CLOSED, &con->flags))
-			queue_con(con);
+		set_bit(SOCK_CLOSED, &con->flags);
+		queue_con(con);
 		break;
 	case TCP_ESTABLISHED:
 		dout("%s TCP_ESTABLISHED\n", __func__);
-- 
1.7.9.5

