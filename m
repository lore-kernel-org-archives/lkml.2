Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364Ab2A0TpD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 14:45:03 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:47023 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688Ab2A0TpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 14:45:00 -0500
Message-ID: <1327693495.3159.10.camel@edumazet-laptop>
Subject: Re: [BUG] Regression on behavior of EPOLLET | EPOLLIN for AF_UNIX
 sockets in 3.2
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Glauber Costa <glommer@parallels.com>
Cc: Nick Mathewson <nickm@freehaven.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alexey Moiseytsev <himeraster@gmail.com>
Date: Fri, 27 Jan 2012 20:44:55 +0100
In-Reply-To: <1327690506.3159.7.camel@edumazet-laptop>
References: <CAKDKvuzH14AZjDG3WSdrf5VtmiUgG0Y+EaC83qqSd0VFKzyitg@mail.gmail.com>
	 <1327686822.3159.3.camel@edumazet-laptop> <4F22EA24.3030901@parallels.com>
	 <1327690506.3159.7.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 27 janvier 2012 à 19:55 +0100, Eric Dumazet a écrit :
> Le vendredi 27 janvier 2012 à 22:17 +0400, Glauber Costa a écrit :
> > On 01/27/2012 09:53 PM, Eric Dumazet wrote:
> > > Le vendredi 27 janvier 2012 à 12:05 -0500, Nick Mathewson a écrit :
> > >> [1.] One line summary of the problem:
> > >>
> > >
> > > Hi
> > >
> > > Probably coming from commit 0884d7aa24e15e72b3c07f7da910a13bb7df3592
> > > (AF_UNIX: Fix poll blocking problem when reading from a stream socket)
> > >
> > > When we requeue skb because not completely eaten, we call again
> > >
> > > sk->sk_data_ready(sk, skb->len);
> > >
> > For the record, I just confirmed this to be the case.
> 
> A fix would be to change unix_poll() and not call sk_data_ready() when
> skb is requeued.
> 
> if (!skb_queue_empty(&sk->sk_receive_queue))
> 	mask |= POLLIN | POLLRDNORM;
> 
> Might be tricky if we want to keep unix_poll() lockless, but quite
> possible.
> 
> Or... not dequeue skb from sk_received_queue unless fully consumed.
> 

I am testing following patch :

 net/unix/af_unix.c |   18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index aad8fb6..6eca195 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1918,7 +1918,7 @@ static int unix_stream_recvmsg(struct kiocb *iocb, struct socket *sock,
 		struct sk_buff *skb;
 
 		unix_state_lock(sk);
-		skb = skb_dequeue(&sk->sk_receive_queue);
+		skb = skb_peek(&sk->sk_receive_queue);
 		if (skb == NULL) {
 			unix_sk(sk)->recursion_level = 0;
 			if (copied >= target)
@@ -1959,8 +1959,6 @@ static int unix_stream_recvmsg(struct kiocb *iocb, struct socket *sock,
 			/* Never glue messages from different writers */
 			if ((UNIXCB(skb).pid  != siocb->scm->pid) ||
 			    (UNIXCB(skb).cred != siocb->scm->cred)) {
-				skb_queue_head(&sk->sk_receive_queue, skb);
-				sk->sk_data_ready(sk, skb->len);
 				break;
 			}
 		} else {
@@ -1977,8 +1975,6 @@ static int unix_stream_recvmsg(struct kiocb *iocb, struct socket *sock,
 
 		chunk = min_t(unsigned int, skb->len, size);
 		if (memcpy_toiovec(msg->msg_iov, skb->data, chunk)) {
-			skb_queue_head(&sk->sk_receive_queue, skb);
-			sk->sk_data_ready(sk, skb->len);
 			if (copied == 0)
 				copied = -EFAULT;
 			break;
@@ -1993,13 +1989,10 @@ static int unix_stream_recvmsg(struct kiocb *iocb, struct socket *sock,
 			if (UNIXCB(skb).fp)
 				unix_detach_fds(siocb->scm, skb);
 
-			/* put the skb back if we didn't use it up.. */
-			if (skb->len) {
-				skb_queue_head(&sk->sk_receive_queue, skb);
-				sk->sk_data_ready(sk, skb->len);
+			if (skb->len)
 				break;
-			}
-
+			
+			skb_unlink(skb, &sk->sk_receive_queue);
 			consume_skb(skb);
 
 			if (siocb->scm->fp)
@@ -2010,9 +2003,6 @@ static int unix_stream_recvmsg(struct kiocb *iocb, struct socket *sock,
 			if (UNIXCB(skb).fp)
 				siocb->scm->fp = scm_fp_dup(UNIXCB(skb).fp);
 
-			/* put message back and return */
-			skb_queue_head(&sk->sk_receive_queue, skb);
-			sk->sk_data_ready(sk, skb->len);
 			break;
 		}
 	} while (size);


