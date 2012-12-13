Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933353Ab2LMOX4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:23:56 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44990 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933250Ab2LMONT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:13:19 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Pavel Emelyanov <xemul@parallels.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 202/241] tcp-repair: Handle zero-length data put in rcv queue
Date: Thu, 13 Dec 2012 11:59:27 -0200
Message-Id: <1355407206-17100-203-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Emelyanov <xemul@parallels.com>

commit c454e6111d1ef4268fe98e87087216e51c2718c3 upstream.

When sending data into a tcp socket in repair state we should check
for the amount of data being 0 explicitly. Otherwise we'll have an skb
with seq == end_seq in rcv queue, but tcp doesn't expect this to happen
(in particular a warn_on in tcp_recvmsg shoots).

Signed-off-by: Pavel Emelyanov <xemul@parallels.com>
Reported-by: Giorgos Mavrikas <gmavrikas@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[ herton: unfuzz patch for 3.5, place size check before
  tcp_try_rmem_schedule ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/ipv4/tcp_input.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index ab30c96..4a3cac8 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -4713,6 +4713,9 @@ int tcp_send_rcvq(struct sock *sk, struct msghdr *msg, size_t size)
 	struct tcphdr *th;
 	bool fragstolen;
 
+	if (size == 0)
+		return 0;
+
 	if (tcp_try_rmem_schedule(sk, size + sizeof(*th)))
 		goto err;
 
-- 
1.7.9.5

