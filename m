Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755109Ab2LCOiw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 09:38:52 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43993 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932473Ab2LCOhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 09:37:06 -0500
Message-Id: <20121203143150.250471629@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 03 Dec 2012 14:32:07 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [ 21/89] netfilter: Mark SYN/ACK packets as invalid  from original direction
In-Reply-To: <20121203143146.549859007@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>

commit 64f509ce71b08d037998e93dd51180c19b2f464c upstream.

Clients should not send such packets. By accepting them, we open
up a hole by wich ephemeral ports can be discovered in an off-path
attack.

See: "Reflection scan: an Off-Path Attack on TCP" by Jan Wrobel,
http://arxiv.org/abs/1201.2074

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/netfilter/nf_conntrack_proto_tcp.c |   19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 37bf943..1eb458c 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -159,21 +159,18 @@ static const u8 tcp_conntracks[2][6][TCP_CONNTRACK_MAX] = {
  *	sCL -> sSS
  */
 /* 	     sNO, sSS, sSR, sES, sFW, sCW, sLA, sTW, sCL, sS2	*/
-/*synack*/ { sIV, sIV, sIG, sIG, sIG, sIG, sIG, sIG, sIG, sSR },
+/*synack*/ { sIV, sIV, sSR, sIV, sIV, sIV, sIV, sIV, sIV, sSR },
 /*
  *	sNO -> sIV	Too late and no reason to do anything
  *	sSS -> sIV	Client can't send SYN and then SYN/ACK
  *	sS2 -> sSR	SYN/ACK sent to SYN2 in simultaneous open
- *	sSR -> sIG
- *	sES -> sIG	Error: SYNs in window outside the SYN_SENT state
- *			are errors. Receiver will reply with RST
- *			and close the connection.
- *			Or we are not in sync and hold a dead connection.
- *	sFW -> sIG
- *	sCW -> sIG
- *	sLA -> sIG
- *	sTW -> sIG
- *	sCL -> sIG
+ *	sSR -> sSR	Late retransmitted SYN/ACK in simultaneous open
+ *	sES -> sIV	Invalid SYN/ACK packets sent by the client
+ *	sFW -> sIV
+ *	sCW -> sIV
+ *	sLA -> sIV
+ *	sTW -> sIV
+ *	sCL -> sIV
  */
 /* 	     sNO, sSS, sSR, sES, sFW, sCW, sLA, sTW, sCL, sS2	*/
 /*fin*/    { sIV, sIV, sFW, sFW, sLA, sLA, sLA, sTW, sCL, sIV },


