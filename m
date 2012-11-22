Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932853Ab2KVV6W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:58:22 -0500
Received: from mail.kernel.org ([198.145.19.201]:49627 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754910Ab2KVSkN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:40:13 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alex Elder <elder@inktank.com>, Sage Weil <sage@inktank.com>
Subject: [ 126/171] libceph: just set SOCK_CLOSED when state changes
Date: Wed, 21 Nov 2012 16:41:12 -0800
Message-Id: <20121122004045.993092379@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122004033.298367941@linuxfoundation.org>
References: <20121122004033.298367941@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Elder <elder@inktank.com>

(cherry picked from commit d65c9e0b9eb43d14ece9dd843506ccba06162ee7)

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/messenger.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -261,8 +261,8 @@ static void ceph_sock_state_change(struc
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


