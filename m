Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933327Ab2LMONz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:13:55 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45034 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933309Ab2LMONr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:13:47 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 210/241] netfilter: Validate the sequence number of dataless ACK packets as well
Date: Thu, 13 Dec 2012 11:59:35 -0200
Message-Id: <1355407206-17100-211-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>

commit 4a70bbfaef0361d27272629d1a250a937edcafe4 upstream.

We spare nothing by not validating the sequence number of dataless
ACK packets and enabling it makes harder off-path attacks.

See: "Reflection scan: an Off-Path Attack on TCP" by Jan Wrobel,
http://arxiv.org/abs/1201.2074

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/netfilter/nf_conntrack_proto_tcp.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 6638ad5..942a8f3 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -624,15 +624,9 @@ static bool tcp_in_window(const struct nf_conn *ct,
 		ack = sack = receiver->td_end;
 	}
 
-	if (seq == end
-	    && (!tcph->rst
-		|| (seq == 0 && state->state == TCP_CONNTRACK_SYN_SENT)))
+	if (tcph->rst && seq == 0 && state->state == TCP_CONNTRACK_SYN_SENT)
 		/*
-		 * Packets contains no data: we assume it is valid
-		 * and check the ack value only.
-		 * However RST segments are always validated by their
-		 * SEQ number, except when seq == 0 (reset sent answering
-		 * SYN.
+		 * RST sent answering SYN.
 		 */
 		seq = end = sender->td_end;
 
-- 
1.7.9.5

