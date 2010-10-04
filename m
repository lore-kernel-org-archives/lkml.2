Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756341Ab0JDPmj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 11:42:39 -0400
Received: from bhuna.collabora.co.uk ([93.93.128.226]:45462 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756292Ab0JDPmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 11:42:38 -0400
From: Alban Crequy <alban.crequy@collabora.co.uk>
Cc: Lennart Poettering <lennart@poettering.net>,
        Alban Crequy <alban.crequy@collabora.co.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH] AF_UNIX: Implement SO_TIMESTAMP and SO_TIMETAMPNS on Unix sockets
Date: Mon,  4 Oct 2010 16:38:26 +0100
Message-Id: <1286206706-25733-1-git-send-email-alban.crequy@collabora.co.uk>
X-Mailer: git-send-email 1.7.1
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Userspace applications can already request to receive timestamps with:
setsockopt(sockfd, SOL_SOCKET, SO_TIMESTAMP, ...)

Although setsockopt() returns zero (success), timestamps are not added to the
ancillary data. This patch fixes that.

Signed-off-by: Alban Crequy <alban.crequy@collabora.co.uk>
---
 net/unix/af_unix.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 617bea4..142ccea 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1697,6 +1697,8 @@ static int unix_dgram_recvmsg(struct kiocb *iocb, struct socket *sock,
 	if (err)
 		goto out_free;
 
+	sock_recv_timestamp(msg, sk, skb);
+
 	if (!siocb->scm) {
 		siocb->scm = &tmp_scm;
 		memset(&tmp_scm, 0, sizeof(tmp_scm));
@@ -1877,6 +1879,8 @@ static int unix_stream_recvmsg(struct kiocb *iocb, struct socket *sock,
 		copied += chunk;
 		size -= chunk;
 
+		sock_recv_timestamp(msg, sk, skb);
+
 		/* Mark read part of skb as used */
 		if (!(flags & MSG_PEEK)) {
 			skb_pull(skb, chunk);
-- 
1.7.1

