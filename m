Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878Ab2KVSeS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:34:18 -0500
Received: from mail.kernel.org ([198.145.19.201]:49017 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753639Ab2KVSd7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:33:59 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Sage Weil <sage@inktank.com>, Alex Elder <elder@inktank.com>
Subject: [ 160/171] libceph: recheck con state after allocating incoming message
Date: Wed, 21 Nov 2012 16:41:46 -0800
Message-Id: <20121122004049.411749694@linuxfoundation.org>
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

(cherry picked from commit 6139919133377652992a5fe134e22abce3e9c25e)

We drop the lock when calling the ->alloc_msg() con op, which means
we need to (a) not clobber con->in_msg without the mutex held, and (b)
we need to verify that we are still in the OPEN state when we retake
it to avoid causing any mayhem.  If the state does change, -EAGAIN
will get us back to con_work() and loop.

Signed-off-by: Sage Weil <sage@inktank.com>
Reviewed-by: Alex Elder <elder@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/messenger.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -2735,9 +2735,16 @@ static int ceph_con_in_msg_alloc(struct
 	BUG_ON(con->in_msg != NULL);
 
 	if (con->ops->alloc_msg) {
+		struct ceph_msg *msg;
+
 		mutex_unlock(&con->mutex);
-		con->in_msg = con->ops->alloc_msg(con, hdr, skip);
+		msg = con->ops->alloc_msg(con, hdr, skip);
 		mutex_lock(&con->mutex);
+		if (con->state != CON_STATE_OPEN) {
+			ceph_msg_put(msg);
+			return -EAGAIN;
+		}
+		con->in_msg = msg;
 		if (con->in_msg) {
 			con->in_msg->con = con->ops->get(con);
 			BUG_ON(con->in_msg->con == NULL);


