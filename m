Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265Ab1AFA35 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:29:57 -0500
Received: from kroah.org ([198.145.64.141]:35725 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754246Ab1AFA3y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:29:54 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 16:23:02 2011
Message-Id: <20110106002302.487927846@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 16:22:41 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [062/152] af_unix: limit recursion level
In-Reply-To: <20110106002500.GA3172@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Eric Dumazet <eric.dumazet@gmail.com>

[ Upstream commit 25888e30319f8896fc656fc68643e6a078263060 ]

Its easy to eat all kernel memory and trigger NMI watchdog, using an
exploit program that queues unix sockets on top of others.

lkml ref : http://lkml.org/lkml/2010/11/25/8

This mechanism is used in applications, one choice we have is to have a
recursion limit.

Other limits might be needed as well (if we queue other types of files),
since the passfd mechanism is currently limited by socket receive queue
sizes only.

Add a recursion_level to unix socket, allowing up to 4 levels.

Each time we send an unix socket through sendfd mechanism, we copy its
recursion level (plus one) to receiver. This recursion level is cleared
when socket receive queue is emptied.

Reported-by: Марк Коренберг <socketpair@gmail.com>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/net/af_unix.h |    2 ++
 net/unix/af_unix.c    |   37 ++++++++++++++++++++++++++++++++-----
 net/unix/garbage.c    |    2 +-
 3 files changed, 35 insertions(+), 6 deletions(-)

--- a/include/net/af_unix.h
+++ b/include/net/af_unix.h
@@ -10,6 +10,7 @@ extern void unix_inflight(struct file *f
 extern void unix_notinflight(struct file *fp);
 extern void unix_gc(void);
 extern void wait_for_unix_gc(void);
+extern struct sock *unix_get_socket(struct file *filp);
 
 #define UNIX_HASH_SIZE	256
 
@@ -56,6 +57,7 @@ struct unix_sock {
 	spinlock_t		lock;
 	unsigned int		gc_candidate : 1;
 	unsigned int		gc_maybe_cycle : 1;
+	unsigned char		recursion_level;
 	struct socket_wq	peer_wq;
 };
 #define unix_sk(__sk) ((struct unix_sock *)__sk)
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1343,9 +1343,25 @@ static void unix_destruct_scm(struct sk_
 	sock_wfree(skb);
 }
 
+#define MAX_RECURSION_LEVEL 4
+
 static int unix_attach_fds(struct scm_cookie *scm, struct sk_buff *skb)
 {
 	int i;
+	unsigned char max_level = 0;
+	int unix_sock_count = 0;
+
+	for (i = scm->fp->count - 1; i >= 0; i--) {
+		struct sock *sk = unix_get_socket(scm->fp->fp[i]);
+
+		if (sk) {
+			unix_sock_count++;
+			max_level = max(max_level,
+					unix_sk(sk)->recursion_level);
+		}
+	}
+	if (unlikely(max_level > MAX_RECURSION_LEVEL))
+		return -ETOOMANYREFS;
 
 	/*
 	 * Need to duplicate file references for the sake of garbage
@@ -1356,9 +1372,11 @@ static int unix_attach_fds(struct scm_co
 	if (!UNIXCB(skb).fp)
 		return -ENOMEM;
 
-	for (i = scm->fp->count-1; i >= 0; i--)
-		unix_inflight(scm->fp->fp[i]);
-	return 0;
+	if (unix_sock_count) {
+		for (i = scm->fp->count - 1; i >= 0; i--)
+			unix_inflight(scm->fp->fp[i]);
+	}
+	return max_level;
 }
 
 static int unix_scm_to_skb(struct scm_cookie *scm, struct sk_buff *skb, bool send_fds)
@@ -1393,6 +1411,7 @@ static int unix_dgram_sendmsg(struct kio
 	struct sk_buff *skb;
 	long timeo;
 	struct scm_cookie tmp_scm;
+	int max_level;
 
 	if (NULL == siocb->scm)
 		siocb->scm = &tmp_scm;
@@ -1431,8 +1450,9 @@ static int unix_dgram_sendmsg(struct kio
 		goto out;
 
 	err = unix_scm_to_skb(siocb->scm, skb, true);
-	if (err)
+	if (err < 0)
 		goto out_free;
+	max_level = err + 1;
 	unix_get_secdata(siocb->scm, skb);
 
 	skb_reset_transport_header(skb);
@@ -1512,6 +1532,8 @@ restart:
 	}
 
 	skb_queue_tail(&other->sk_receive_queue, skb);
+	if (max_level > unix_sk(other)->recursion_level)
+		unix_sk(other)->recursion_level = max_level;
 	unix_state_unlock(other);
 	other->sk_data_ready(other, len);
 	sock_put(other);
@@ -1542,6 +1564,7 @@ static int unix_stream_sendmsg(struct ki
 	int sent = 0;
 	struct scm_cookie tmp_scm;
 	bool fds_sent = false;
+	int max_level;
 
 	if (NULL == siocb->scm)
 		siocb->scm = &tmp_scm;
@@ -1605,10 +1628,11 @@ static int unix_stream_sendmsg(struct ki
 
 		/* Only send the fds in the first buffer */
 		err = unix_scm_to_skb(siocb->scm, skb, !fds_sent);
-		if (err) {
+		if (err < 0) {
 			kfree_skb(skb);
 			goto out_err;
 		}
+		max_level = err + 1;
 		fds_sent = true;
 
 		err = memcpy_fromiovec(skb_put(skb, size), msg->msg_iov, size);
@@ -1624,6 +1648,8 @@ static int unix_stream_sendmsg(struct ki
 			goto pipe_err_free;
 
 		skb_queue_tail(&other->sk_receive_queue, skb);
+		if (max_level > unix_sk(other)->recursion_level)
+			unix_sk(other)->recursion_level = max_level;
 		unix_state_unlock(other);
 		other->sk_data_ready(other, size);
 		sent += size;
@@ -1840,6 +1866,7 @@ static int unix_stream_recvmsg(struct ki
 		unix_state_lock(sk);
 		skb = skb_dequeue(&sk->sk_receive_queue);
 		if (skb == NULL) {
+			unix_sk(sk)->recursion_level = 0;
 			if (copied >= target)
 				goto unlock;
 
--- a/net/unix/garbage.c
+++ b/net/unix/garbage.c
@@ -96,7 +96,7 @@ static DECLARE_WAIT_QUEUE_HEAD(unix_gc_w
 unsigned int unix_tot_inflight;
 
 
-static struct sock *unix_get_socket(struct file *filp)
+struct sock *unix_get_socket(struct file *filp)
 {
 	struct sock *u_sock = NULL;
 	struct inode *inode = filp->f_path.dentry->d_inode;


