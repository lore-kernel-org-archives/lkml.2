Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932210Ab2KVVY2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:24:28 -0500
Received: from mail.kernel.org ([198.145.19.201]:49627 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755183Ab2KVSko (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:40:44 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Sage Weil <sage@inktank.com>, Alex Elder <elder@inktank.com>
Subject: [ 157/171] libceph: verify state after retaking con lock after dispatch
Date: Wed, 21 Nov 2012 16:41:43 -0800
Message-Id: <20121122004049.111129803@linuxfoundation.org>
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

(cherry picked from commit 7b862e07b1a4d5c963d19027f10ea78085f27f9b)

We drop the con mutex when delivering a message.  When we retake the
lock, we need to verify we are still in the OPEN state before
preparing to read the next tag, or else we risk stepping on a
connection that has been closed.

Signed-off-by: Sage Weil <sage@inktank.com>
Reviewed-by: Alex Elder <elder@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/messenger.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -2003,7 +2003,6 @@ static void process_message(struct ceph_
 	con->ops->dispatch(con, msg);
 
 	mutex_lock(&con->mutex);
-	prepare_read_tag(con);
 }
 
 
@@ -2213,6 +2212,8 @@ more:
 		if (con->in_tag == CEPH_MSGR_TAG_READY)
 			goto more;
 		process_message(con);
+		if (con->state == CON_STATE_OPEN)
+			prepare_read_tag(con);
 		goto more;
 	}
 	if (con->in_tag == CEPH_MSGR_TAG_ACK) {


