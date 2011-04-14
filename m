Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964870Ab1DNR6H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 13:58:07 -0400
Received: from mail.windriver.com ([147.11.1.11]:41751 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964857Ab1DNR6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:58:04 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 143/209] af_unix: limit recursion level
Date: Thu, 14 Apr 2011 13:55:01 -0400
Message-Id: <1302803767-9715-30-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
 <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

commit 25888e30319f8896fc656fc68643e6a078263060 upstream

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

[PG: slight modifications required due to absense of 7361c36c5 in 34]

Reported-by: Марк Коренберг <socketpair@gmail.com>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 include/net/af_unix.h |    2 ++
 net/unix/af_unix.c    |   37 ++++++++++++++++++++++++++++++++-----
 net/unix/garbage.c    |    2 +-
 3 files changed, 35 insertions(+), 6 deletions(-)

diff --git a/include/net/af_unix.h b/include/net/af_unix.h
index 1614d78..861045f 100644
--- a/include/net/af_unix.h
+++ b/include/net/af_unix.h
@@ -10,6 +10,7 @@ extern void unix_inflight(struct file *fp);
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
         wait_queue_head_t       peer_wait;
 };
 #define unix_sk(__sk) ((struct unix_sock *)__sk)
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 8c34e3b..207a119 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1324,9 +1324,25 @@ static void unix_destruct_fds(struct sk_buff *skb)
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
@@ -1337,10 +1353,12 @@ static int unix_attach_fds(struct scm_cookie *scm, struct sk_buff *skb)
 	if (!UNIXCB(skb).fp)
 		return -ENOMEM;
 
-	for (i = scm->fp->count-1; i >= 0; i--)
-		unix_inflight(scm->fp->fp[i]);
+	if (unix_sock_count) {
+		for (i = scm->fp->count-1; i >= 0; i--)
+			unix_inflight(scm->fp->fp[i]);
+	}
 	skb->destructor = unix_destruct_fds;
-	return 0;
+	return max_level;
 }
 
 /*
@@ -1362,6 +1380,7 @@ static int unix_dgram_sendmsg(struct kiocb *kiocb, struct socket *sock,
 	struct sk_buff *skb;
 	long timeo;
 	struct scm_cookie tmp_scm;
+	int max_level = 0;
 
 	if (NULL == siocb->scm)
 		siocb->scm = &tmp_scm;
@@ -1402,8 +1421,9 @@ static int unix_dgram_sendmsg(struct kiocb *kiocb, struct socket *sock,
 	memcpy(UNIXCREDS(skb), &siocb->scm->creds, sizeof(struct ucred));
 	if (siocb->scm->fp) {
 		err = unix_attach_fds(siocb->scm, skb);
-		if (err)
+		if (err < 0)
 			goto out_free;
+		max_level = err + 1;
 	}
 	unix_get_secdata(siocb->scm, skb);
 
@@ -1484,6 +1504,8 @@ restart:
 	}
 
 	skb_queue_tail(&other->sk_receive_queue, skb);
+	if (max_level > unix_sk(other)->recursion_level)
+		unix_sk(other)->recursion_level = max_level;
 	unix_state_unlock(other);
 	other->sk_data_ready(other, len);
 	sock_put(other);
@@ -1514,6 +1536,7 @@ static int unix_stream_sendmsg(struct kiocb *kiocb, struct socket *sock,
 	int sent = 0;
 	struct scm_cookie tmp_scm;
 	bool fds_sent = false;
+	int max_level = 0;
 
 	if (NULL == siocb->scm)
 		siocb->scm = &tmp_scm;
@@ -1578,10 +1601,11 @@ static int unix_stream_sendmsg(struct kiocb *kiocb, struct socket *sock,
 		/* Only send the fds in the first buffer */
 		if (siocb->scm->fp && !fds_sent) {
 			err = unix_attach_fds(siocb->scm, skb);
-			if (err) {
+			if (err < 0) {
 				kfree_skb(skb);
 				goto out_err;
 			}
+			max_level = err + 1;
 			fds_sent = true;
 		}
 
@@ -1598,6 +1622,8 @@ static int unix_stream_sendmsg(struct kiocb *kiocb, struct socket *sock,
 			goto pipe_err_free;
 
 		skb_queue_tail(&other->sk_receive_queue, skb);
+		if (max_level > unix_sk(other)->recursion_level)
+			unix_sk(other)->recursion_level = max_level;
 		unix_state_unlock(other);
 		other->sk_data_ready(other, size);
 		sent += size;
@@ -1814,6 +1840,7 @@ static int unix_stream_recvmsg(struct kiocb *iocb, struct socket *sock,
 		unix_state_lock(sk);
 		skb = skb_dequeue(&sk->sk_receive_queue);
 		if (skb == NULL) {
+			unix_sk(sk)->recursion_level = 0;
 			if (copied >= target)
 				goto unlock;
 
diff --git a/net/unix/garbage.c b/net/unix/garbage.c
index ef5aa55..493e0e6 100644
--- a/net/unix/garbage.c
+++ b/net/unix/garbage.c
@@ -96,7 +96,7 @@ static DECLARE_WAIT_QUEUE_HEAD(unix_gc_wait);
 unsigned int unix_tot_inflight;
 
 
-static struct sock *unix_get_socket(struct file *filp)
+struct sock *unix_get_socket(struct file *filp)
 {
 	struct sock *u_sock = NULL;
 	struct inode *inode = filp->f_path.dentry->d_inode;
-- 
1.7.4.4

