Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757937Ab2KVVbd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:31:33 -0500
Received: from mail.kernel.org ([198.145.19.201]:49620 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755180Ab2KVSki (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:40:38 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [ 041/171] netfilter: Validate the sequence number of dataless ACK packets as well
Date: Wed, 21 Nov 2012 16:39:47 -0800
Message-Id: <20121122004037.483723325@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122004033.298367941@linuxfoundation.org>
References: <20121122004033.298367941@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>

commit 4a70bbfaef0361d27272629d1a250a937edcafe4 upstream.

We spare nothing by not validating the sequence number of dataless
ACK packets and enabling it makes harder off-path attacks.

See: "Reflection scan: an Off-Path Attack on TCP" by Jan Wrobel,
http://arxiv.org/abs/1201.2074

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/netfilter/nf_conntrack_proto_tcp.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -627,15 +627,9 @@ static bool tcp_in_window(const struct n
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
 


