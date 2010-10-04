Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757017Ab0JDSvS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 14:51:18 -0400
Received: from bhuna.collabora.co.uk ([93.93.128.226]:59107 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756974Ab0JDSvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 14:51:17 -0400
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
Date: Mon,  4 Oct 2010 19:48:28 +0100
Message-Id: <1286218109-30771-1-git-send-email-alban.crequy@collabora.co.uk>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20101004194734.6a1caf3e@chocolatine.cbg.collabora.co.uk>
References: <20101004194734.6a1caf3e@chocolatine.cbg.collabora.co.uk>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Userspace applications can already request to receive timestamps with:
setsockopt(sockfd, SOL_SOCKET, SO_TIMESTAMP, ...)

Although setsockopt() returns zero (success), timestamps are not added to the
ancillary data. This patch fixes that on SOCK_DGRAM and SOCK_SEQPACKET Unix
sockets.

Signed-off-by: Alban Crequy <alban.crequy@collabora.co.uk>
---
 net/unix/af_unix.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 617bea4..b03baa8 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1484,6 +1484,8 @@ restart:
 		goto restart;
 	}
 
+	if (sock_flag(other, SOCK_RCVTSTAMP))
+		__net_timestamp(skb);
 	skb_queue_tail(&other->sk_receive_queue, skb);
 	unix_state_unlock(other);
 	other->sk_data_ready(other, len);
@@ -1697,6 +1699,9 @@ static int unix_dgram_recvmsg(struct kiocb *iocb, struct socket *sock,
 	if (err)
 		goto out_free;
 
+	if (sock_flag(sk, SOCK_RCVTSTAMP))
+		__sock_recv_timestamp(msg, sk, skb);
+
 	if (!siocb->scm) {
 		siocb->scm = &tmp_scm;
 		memset(&tmp_scm, 0, sizeof(tmp_scm));
-- 
1.7.1

