Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758025Ab2KVVn7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:43:59 -0500
Received: from mail.kernel.org ([198.145.19.201]:49636 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755047Ab2KVSkZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:40:25 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Sage Weil <sage@inktank.com>, Yehuda Sadeh <yehuda@inktank.com>,
        Alex Elder <elder@inktank.com>
Subject: [ 145/171] libceph: reset connection retry on successfully negotiation
Date: Wed, 21 Nov 2012 16:41:31 -0800
Message-Id: <20121122004047.895410121@linuxfoundation.org>
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

(cherry picked from commit 85effe183dd45854d1ad1a370b88cddb403c4c91)

We exponentially back off when we encounter connection errors.  If several
errors accumulate, we will eventually wait ages before even trying to
reconnect.

Fix this by resetting the backoff counter after a successful negotiation/
connection with the remote node.  Fixes ceph issue #2802.

Signed-off-by: Sage Weil <sage@inktank.com>
Reviewed-by: Yehuda Sadeh <yehuda@inktank.com>
Reviewed-by: Alex Elder <elder@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/messenger.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -1629,6 +1629,8 @@ static int process_connect(struct ceph_c
 		if (con->in_reply.flags & CEPH_MSG_CONNECT_LOSSY)
 			set_bit(LOSSYTX, &con->flags);
 
+		con->delay = 0;      /* reset backoff memory */
+
 		prepare_read_tag(con);
 		break;
 


