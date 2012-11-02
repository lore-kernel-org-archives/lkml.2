Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762993Ab2KBRHq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 13:07:46 -0400
Received: from mail.kernel.org ([198.145.19.201]:33342 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762307Ab2KBRHh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 13:07:37 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alex Elder <elder@inktank.com>, Sage Weil <sage@inktank.com>
Subject: [ 09/24] rbd: reset BACKOFF if unable to re-queue
Date: Fri,  2 Nov 2012 10:06:57 -0700
Message-Id: <20121102170248.094911668@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc3.16.g8ead1bf
In-Reply-To: <20121102170247.406319110@linuxfoundation.org>
References: <20121102170247.406319110@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/ceph/messenger.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -2300,10 +2300,11 @@ restart:
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


