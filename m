Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932481Ab1EFAZ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:25:58 -0400
Received: from kroah.org ([198.145.64.141]:37269 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932454Ab1EFAZx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:25:53 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:22:17 2011
Message-Id: <20110506002216.951633305@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:21:44 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [119/143] af_unix: limit recursion level
In-Reply-To: <20110506002311.GA15354@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Eric Dumazet <eric.dumazet@gmail.com>

commit 25888e30319f8896fc656fc68643e6a078263060 upstream.

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
[bwh: Adjust for 2.6.32]
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
         wait_queue_head_t       peer_wait;
 };
 #define unix_sk(__sk) ((struct unix_sock *)__sk)
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1325,9 +1325,25 @@ static void unix_destruct_fds(struct sk_
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
@@ -1338,10 +1354,12 @@ static int unix_attach_fds(struct scm_co
 	if (!UNIXCB(skb).fp)
 		return -ENOMEM;
 
-	for (i = scm->fp->count-1; i >= 0; i--)
-		unix_inflight(scm->fp->fp[i]);
+	if (unix_sock_count) {
+		for (i = scm->fp->count - 1; i >= 0; i--)
+			unix_inflight(scm->fp->fp[i]);
+	}
 	skb->destructor = unix_destruct_fds;
-	return 0;
+	return max_level;
 }
 
 /*
@@ -1363,6 +1381,7 @@ static int unix_dgram_sendmsg(struct kio
 	struct sk_buff *skb;
 	long timeo;
 	struct scm_cookie tmp_scm;
+	int max_level = 0;
 
 	if (NULL == siocb->scm)
 		siocb->scm = &tmp_scm;
@@ -1403,8 +1422,9 @@ static int unix_dgram_sendmsg(struct kio
 	memcpy(UNIXCREDS(skb), &siocb->scm->creds, sizeof(struct ucred));
 	if (siocb->scm->fp) {
 		err = unix_attach_fds(siocb->scm, skb);
-		if (err)
+		if (err < 0)
 			goto out_free;
+		max_level = err + 1;
 	}
 	unix_get_secdata(siocb->scm, skb);
 
@@ -1485,6 +1505,8 @@ restart:
 	}
 
 	skb_queue_tail(&other->sk_receive_queue, skb);
+	if (max_level > unix_sk(other)->recursion_level)
+		unix_sk(other)->recursion_level = max_level;
 	unix_state_unlock(other);
 	other->sk_data_ready(other, len);
 	sock_put(other);
@@ -1515,6 +1537,7 @@ static int unix_stream_sendmsg(struct ki
 	int sent = 0;
 	struct scm_cookie tmp_scm;
 	bool fds_sent = false;
+	int max_level = 0;
 
 	if (NULL == siocb->scm)
 		siocb->scm = &tmp_scm;
@@ -1579,10 +1602,11 @@ static int unix_stream_sendmsg(struct ki
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
 
@@ -1599,6 +1623,8 @@ static int unix_stream_sendmsg(struct ki
 			goto pipe_err_free;
 
 		skb_queue_tail(&other->sk_receive_queue, skb);
+		if (max_level > unix_sk(other)->recursion_level)
+			unix_sk(other)->recursion_level = max_level;
 		unix_state_unlock(other);
 		other->sk_data_ready(other, size);
 		sent += size;
@@ -1827,6 +1853,7 @@ static int unix_stream_recvmsg(struct ki
 		unix_state_lock(sk);
 		skb = skb_dequeue(&sk->sk_receive_queue);
 		if (skb == NULL) {
+			unix_sk(sk)->recursion_level = 0;
 			if (copied >= target)
 				goto unlock;
 
--- a/net/unix/garbage.c
+++ b/net/unix/garbage.c
@@ -97,7 +97,7 @@ static DECLARE_WAIT_QUEUE_HEAD(unix_gc_w
 unsigned int unix_tot_inflight;
 
 
-static struct sock *unix_get_socket(struct file *filp)
+struct sock *unix_get_socket(struct file *filp)
 {
 	struct sock *u_sock = NULL;
 	struct inode *inode = filp->f_path.dentry->d_inode;


