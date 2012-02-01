Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932713Ab2BAVMn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:12:43 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:34933 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932669Ab2BAVKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:10:46 -0500
X-Sasl-enc: ErDK0wz1u8RuFhnC9TuQfvIe821mLk1wjwbGjoe3c6we 1328130644
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Feb  1 13:00:50 2012
Message-Id: <20120201210050.210614371@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Wed, 01 Feb 2012 13:00:36 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Nick Mathewson <nickm@freehaven.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Alexey Moiseytsev <himeraster@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [72/89] af_unix: fix EPOLLET regression for stream sockets
In-Reply-To: <20120201210505.GA26028@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Eric Dumazet <eric.dumazet@gmail.com>

[ Upstream commit 6f01fd6e6f6809061b56e78f1e8d143099716d70 ]

Commit 0884d7aa24 (AF_UNIX: Fix poll blocking problem when reading from
a stream socket) added a regression for epoll() in Edge Triggered mode
(EPOLLET)

Appropriate fix is to use skb_peek()/skb_unlink() instead of
skb_dequeue(), and only call skb_unlink() when skb is fully consumed.

This remove the need to requeue a partial skb into sk_receive_queue head
and the extra sk->sk_data_ready() calls that added the regression.

This is safe because once skb is given to sk_receive_queue, it is not
modified by a writer, and readers are serialized by u->readlock mutex.

This also reduce number of spinlock acquisition for small reads or
MSG_PEEK users so should improve overall performance.

Reported-by: Nick Mathewson <nickm@freehaven.net>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Alexey Moiseytsev <himeraster@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/unix/af_unix.c |   19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1915,7 +1915,7 @@ static int unix_stream_recvmsg(struct ki
 		struct sk_buff *skb;
 
 		unix_state_lock(sk);
-		skb = skb_dequeue(&sk->sk_receive_queue);
+		skb = skb_peek(&sk->sk_receive_queue);
 		if (skb == NULL) {
 			unix_sk(sk)->recursion_level = 0;
 			if (copied >= target)
@@ -1955,11 +1955,8 @@ static int unix_stream_recvmsg(struct ki
 		if (check_creds) {
 			/* Never glue messages from different writers */
 			if ((UNIXCB(skb).pid  != siocb->scm->pid) ||
-			    (UNIXCB(skb).cred != siocb->scm->cred)) {
-				skb_queue_head(&sk->sk_receive_queue, skb);
-				sk->sk_data_ready(sk, skb->len);
+			    (UNIXCB(skb).cred != siocb->scm->cred))
 				break;
-			}
 		} else {
 			/* Copy credentials */
 			scm_set_cred(siocb->scm, UNIXCB(skb).pid, UNIXCB(skb).cred);
@@ -1974,8 +1971,6 @@ static int unix_stream_recvmsg(struct ki
 
 		chunk = min_t(unsigned int, skb->len, size);
 		if (memcpy_toiovec(msg->msg_iov, skb->data, chunk)) {
-			skb_queue_head(&sk->sk_receive_queue, skb);
-			sk->sk_data_ready(sk, skb->len);
 			if (copied == 0)
 				copied = -EFAULT;
 			break;
@@ -1990,13 +1985,10 @@ static int unix_stream_recvmsg(struct ki
 			if (UNIXCB(skb).fp)
 				unix_detach_fds(siocb->scm, skb);
 
-			/* put the skb back if we didn't use it up.. */
-			if (skb->len) {
-				skb_queue_head(&sk->sk_receive_queue, skb);
-				sk->sk_data_ready(sk, skb->len);
+			if (skb->len)
 				break;
-			}
 
+			skb_unlink(skb, &sk->sk_receive_queue);
 			consume_skb(skb);
 
 			if (siocb->scm->fp)
@@ -2007,9 +1999,6 @@ static int unix_stream_recvmsg(struct ki
 			if (UNIXCB(skb).fp)
 				siocb->scm->fp = scm_fp_dup(UNIXCB(skb).fp);
 
-			/* put message back and return */
-			skb_queue_head(&sk->sk_receive_queue, skb);
-			sk->sk_data_ready(sk, skb->len);
 			break;
 		}
 	} while (size);


