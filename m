Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755887Ab2ACXB1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 18:01:27 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39692 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755629Ab2ACWh0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 17:37:26 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan  3 14:30:36 2012
Message-Id: <20120103223036.220857049@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 03 Jan 2012 14:30:16 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Thomas Graf <tgraf@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [58/67] sctp: Do not account for sizeof(struct sk_buff) in estimated rwnd
In-Reply-To: <20120103223043.GA26738@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Thomas Graf <tgraf@redhat.com>

[ Upstream commit a76c0adf60f6ca5ff3481992e4ea0383776b24d2 ]

When checking whether a DATA chunk fits into the estimated rwnd a
full sizeof(struct sk_buff) is added to the needed chunk size. This
quickly exhausts the available rwnd space and leads to packets being
sent which are much below the PMTU limit. This can lead to much worse
performance.

The reason for this behaviour was to avoid putting too much memory
pressure on the receiver. The concept is not completely irational
because a Linux receiver does in fact clone an skb for each DATA chunk
delivered. However, Linux also reserves half the available socket
buffer space for data structures therefore usage of it is already
accounted for.

When proposing to change this the last time it was noted that this
behaviour was introduced to solve a performance issue caused by rwnd
overusage in combination with small DATA chunks.

Trying to reproduce this I found that with the sk_buff overhead removed,
the performance would improve significantly unless socket buffer limits
are increased.

The following numbers have been gathered using a patched iperf
supporting SCTP over a live 1 Gbit ethernet network. The -l option
was used to limit DATA chunk sizes. The numbers listed are based on
the average of 3 test runs each. Default values have been used for
sk_(r|w)mem.

Chunk
Size    Unpatched     No Overhead
-------------------------------------
   4    15.2 Kbit [!]   12.2 Mbit [!]
   8    35.8 Kbit [!]   26.0 Mbit [!]
  16    95.5 Kbit [!]   54.4 Mbit [!]
  32   106.7 Mbit      102.3 Mbit
  64   189.2 Mbit      188.3 Mbit
 128   331.2 Mbit      334.8 Mbit
 256   537.7 Mbit      536.0 Mbit
 512   766.9 Mbit      766.6 Mbit
1024   810.1 Mbit      808.6 Mbit

Signed-off-by: Thomas Graf <tgraf@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/sctp/output.c   |    8 +-------
 net/sctp/outqueue.c |    6 ++----
 2 files changed, 3 insertions(+), 11 deletions(-)

--- a/net/sctp/output.c
+++ b/net/sctp/output.c
@@ -697,13 +697,7 @@ static void sctp_packet_append_data(stru
 	/* Keep track of how many bytes are in flight to the receiver. */
 	asoc->outqueue.outstanding_bytes += datasize;
 
-	/* Update our view of the receiver's rwnd. Include sk_buff overhead
-	 * while updating peer.rwnd so that it reduces the chances of a
-	 * receiver running out of receive buffer space even when receive
-	 * window is still open. This can happen when a sender is sending
-	 * sending small messages.
-	 */
-	datasize += sizeof(struct sk_buff);
+	/* Update our view of the receiver's rwnd. */
 	if (datasize < rwnd)
 		rwnd -= datasize;
 	else
--- a/net/sctp/outqueue.c
+++ b/net/sctp/outqueue.c
@@ -411,8 +411,7 @@ void sctp_retransmit_mark(struct sctp_ou
 					chunk->transport->flight_size -=
 							sctp_data_size(chunk);
 				q->outstanding_bytes -= sctp_data_size(chunk);
-				q->asoc->peer.rwnd += (sctp_data_size(chunk) +
-							sizeof(struct sk_buff));
+				q->asoc->peer.rwnd += sctp_data_size(chunk);
 			}
 			continue;
 		}
@@ -432,8 +431,7 @@ void sctp_retransmit_mark(struct sctp_ou
 			 * (Section 7.2.4)), add the data size of those
 			 * chunks to the rwnd.
 			 */
-			q->asoc->peer.rwnd += (sctp_data_size(chunk) +
-						sizeof(struct sk_buff));
+			q->asoc->peer.rwnd += sctp_data_size(chunk);
 			q->outstanding_bytes -= sctp_data_size(chunk);
 			if (chunk->transport)
 				transport->flight_size -= sctp_data_size(chunk);


