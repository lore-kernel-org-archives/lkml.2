Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757203Ab3AHXps (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 18:45:48 -0500
Received: from mail1.windriver.com ([147.11.146.13]:53745 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757016Ab3AHXjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 18:39:46 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Thomas Graf <tgraf@infradead.org>, "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 63/77] sctp: ABORT if receive, reassmbly, or reodering queue is not empty while closing socket
Date: Tue, 8 Jan 2013 18:35:42 -0500
Message-ID: <1357688156-25387-64-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
References: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Graf <tgraf@infradead.org>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit cd4fcc704f30f2064ab30b5300d44d431e46db50 upstream.

Trigger user ABORT if application closes a socket which has data
queued on the socket receive queue or chunks waiting on the
reassembly or ordering queue as this would imply data being lost
which defeats the point of a graceful shutdown.

This behavior is already practiced in TCP.

We do not check the input queue because that would mean to parse
all chunks on it to look for unacknowledged data which seems too
much of an effort. Control chunks or duplicated chunks may also
be in the input queue and should not be stopping a graceful
shutdown.

Signed-off-by: Thomas Graf <tgraf@infradead.org>
Acked-by: Vlad Yasevich <vladislav.yasevich@hp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 include/net/sctp/ulpevent.h |  2 +-
 net/sctp/socket.c           | 13 ++++++++-----
 net/sctp/ulpevent.c         | 16 +++++++++++++---
 3 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/include/net/sctp/ulpevent.h b/include/net/sctp/ulpevent.h
index 7ea12e8..b93b719 100644
--- a/include/net/sctp/ulpevent.h
+++ b/include/net/sctp/ulpevent.h
@@ -80,7 +80,7 @@ static inline struct sctp_ulpevent *sctp_skb2event(struct sk_buff *skb)
 
 void sctp_ulpevent_free(struct sctp_ulpevent *);
 int sctp_ulpevent_is_notification(const struct sctp_ulpevent *);
-void sctp_queue_purge_ulpevents(struct sk_buff_head *list);
+unsigned int sctp_queue_purge_ulpevents(struct sk_buff_head *list);
 
 struct sctp_ulpevent *sctp_ulpevent_make_assoc_change(
 	const struct sctp_association *asoc,
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 22631c1..03daceb 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -1373,6 +1373,7 @@ SCTP_STATIC void sctp_close(struct sock *sk, long timeout)
 	struct sctp_endpoint *ep;
 	struct sctp_association *asoc;
 	struct list_head *pos, *temp;
+	unsigned int data_was_unread;
 
 	SCTP_DEBUG_PRINTK("sctp_close(sk: 0x%p, timeout:%ld)\n", sk, timeout);
 
@@ -1382,6 +1383,10 @@ SCTP_STATIC void sctp_close(struct sock *sk, long timeout)
 
 	ep = sctp_sk(sk)->ep;
 
+	/* Clean up any skbs sitting on the receive queue.  */
+	data_was_unread = sctp_queue_purge_ulpevents(&sk->sk_receive_queue);
+	data_was_unread += sctp_queue_purge_ulpevents(&sctp_sk(sk)->pd_lobby);
+
 	/* Walk all associations on an endpoint.  */
 	list_for_each_safe(pos, temp, &ep->asocs) {
 		asoc = list_entry(pos, struct sctp_association, asocs);
@@ -1399,7 +1404,9 @@ SCTP_STATIC void sctp_close(struct sock *sk, long timeout)
 			}
 		}
 
-		if (sock_flag(sk, SOCK_LINGER) && !sk->sk_lingertime) {
+		if (data_was_unread || !skb_queue_empty(&asoc->ulpq.lobby) ||
+		    !skb_queue_empty(&asoc->ulpq.reasm) ||
+		    (sock_flag(sk, SOCK_LINGER) && !sk->sk_lingertime)) {
 			struct sctp_chunk *chunk;
 
 			chunk = sctp_make_abort_user(asoc, NULL, 0);
@@ -1409,10 +1416,6 @@ SCTP_STATIC void sctp_close(struct sock *sk, long timeout)
 			sctp_primitive_SHUTDOWN(asoc, NULL);
 	}
 
-	/* Clean up any skbs sitting on the receive queue.  */
-	sctp_queue_purge_ulpevents(&sk->sk_receive_queue);
-	sctp_queue_purge_ulpevents(&sctp_sk(sk)->pd_lobby);
-
 	/* On a TCP-style socket, block for at most linger_time if set. */
 	if (sctp_style(sk, TCP) && timeout)
 		sctp_wait_for_close(sk, timeout);
diff --git a/net/sctp/ulpevent.c b/net/sctp/ulpevent.c
index aa72e89..3b81c62 100644
--- a/net/sctp/ulpevent.c
+++ b/net/sctp/ulpevent.c
@@ -1053,9 +1053,19 @@ void sctp_ulpevent_free(struct sctp_ulpevent *event)
 }
 
 /* Purge the skb lists holding ulpevents. */
-void sctp_queue_purge_ulpevents(struct sk_buff_head *list)
+unsigned int sctp_queue_purge_ulpevents(struct sk_buff_head *list)
 {
 	struct sk_buff *skb;
-	while ((skb = skb_dequeue(list)) != NULL)
-		sctp_ulpevent_free(sctp_skb2event(skb));
+	unsigned int data_unread = 0;
+
+	while ((skb = skb_dequeue(list)) != NULL) {
+		struct sctp_ulpevent *event = sctp_skb2event(skb);
+
+		if (!sctp_ulpevent_is_notification(event))
+			data_unread += skb->len;
+
+		sctp_ulpevent_free(event);
+	}
+
+	return data_unread;
 }
-- 
1.7.12.1

