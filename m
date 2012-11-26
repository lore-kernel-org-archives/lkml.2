Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933358Ab2KZRJB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:09:01 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47681 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933331Ab2KZRI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:08:59 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Elder <elder@inktank.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 146/270] rbd: reset BACKOFF if unable to re-queue
Date: Mon, 26 Nov 2012 14:57:16 -0200
Message-Id: <1353949160-26803-147-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Elder <elder@inktank.com>

commit 588377d6199034c36d335e7df5818b731fea072c upstream.

If ceph_fault() is unable to queue work after a delay, it sets the
BACKOFF connection flag so con_work() will attempt to do so.

In con_work(), when BACKOFF is set, if queue_delayed_work() doesn't
result in newly-queued work, it simply ignores this condition and
proceeds as if no backoff delay were desired.  There are two
problems with this--one of which is a bug.

The first problem is simply that the intended behavior is to back
off, and if we aren't able queue the work item to run after a delay
we're not doing that.

The only reason queue_delayed_work() won't queue work is if the
provided work item is already queued.  In the messenger, this
means that con_work() is already scheduled to be run again.  So
if we simply set the BACKOFF flag again when this occurs, we know
the next con_work() call will again attempt to hold off activity
on the connection until after the delay.

The second problem--the bug--is a leak of a reference count.  If
queue_delayed_work() returns 0 in con_work(), con->ops->put() drops
the connection reference held on entry to con_work().  However,
processing is (was) allowed to continue, and at the end of the
function a second con->ops->put() is called.

This patch fixes both problems.

Signed-off-by: Alex Elder <elder@inktank.com>
Reviewed-by: Sage Weil <sage@inktank.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/ceph/messenger.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index 8ba0eee..0de041f 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -2296,10 +2296,11 @@ restart:
 			mutex_unlock(&con->mutex);
 			return;
 		} else {
-			con->ops->put(con);
 			dout("con_work %p FAILED to back off %lu\n", con,
 			     con->delay);
+			set_bit(CON_FLAG_BACKOFF, &con->flags);
 		}
+		goto done;
 	}
 
 	if (con->state == CON_STATE_STANDBY) {
-- 
1.7.9.5

