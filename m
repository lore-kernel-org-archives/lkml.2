Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932693Ab0EJWyc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 18:54:32 -0400
Received: from kroah.org ([198.145.64.141]:33325 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932390Ab0EJWwo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:52:44 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:33:25 2010
Message-Id: <20100510223325.155946522@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:32:57 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Wei Yongjun <yjwei@cn.fujitsu.com>,
       Vlad Yasevich <vladislav.yasevich@hp.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [086/117] sctp: avoid irq lock inversion while call sk->sk_data_ready()
In-Reply-To: <20100510223700.GA18404@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Wei Yongjun <yjwei@cn.fujitsu.com>

[ Upstream commit 561b1733a465cf9677356b40c27653dd45f1ac56 ]

sk->sk_data_ready() of sctp socket can be called from both BH and non-BH
contexts, but the default sk->sk_data_ready(), sock_def_readable(), can
not be used in this case. Therefore, we have to make a new function
sctp_data_ready() to grab sk->sk_data_ready() with BH disabling.

=========================================================
[ INFO: possible irq lock inversion dependency detected ]
2.6.33-rc6 #129
---------------------------------------------------------
sctp_darn/1517 just changed the state of lock:
 (clock-AF_INET){++.?..}, at: [<c06aab60>] sock_def_readable+0x20/0x80
but this lock took another, SOFTIRQ-unsafe lock in the past:
 (slock-AF_INET){+.-...}

and interrupts could create inverse lock ordering between them.

other info that might help us debug this:
1 lock held by sctp_darn/1517:
 #0:  (sk_lock-AF_INET){+.+.+.}, at: [<cdfe363d>] sctp_sendmsg+0x23d/0xc00 [sctp]

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/net/sctp/sctp.h |    1 +
 net/sctp/endpointola.c  |    1 +
 net/sctp/socket.c       |   10 ++++++++++
 3 files changed, 12 insertions(+)

--- a/include/net/sctp/sctp.h
+++ b/include/net/sctp/sctp.h
@@ -128,6 +128,7 @@ extern int sctp_register_pf(struct sctp_
 int sctp_backlog_rcv(struct sock *sk, struct sk_buff *skb);
 int sctp_inet_listen(struct socket *sock, int backlog);
 void sctp_write_space(struct sock *sk);
+void sctp_data_ready(struct sock *sk, int len);
 unsigned int sctp_poll(struct file *file, struct socket *sock,
 		poll_table *wait);
 void sctp_sock_rfree(struct sk_buff *skb);
--- a/net/sctp/endpointola.c
+++ b/net/sctp/endpointola.c
@@ -144,6 +144,7 @@ static struct sctp_endpoint *sctp_endpoi
 	/* Use SCTP specific send buffer space queues.  */
 	ep->sndbuf_policy = sctp_sndbuf_policy;
 
+	sk->sk_data_ready = sctp_data_ready;
 	sk->sk_write_space = sctp_write_space;
 	sock_set_flag(sk, SOCK_USE_WRITE_QUEUE);
 
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -6188,6 +6188,16 @@ do_nonblock:
 	goto out;
 }
 
+void sctp_data_ready(struct sock *sk, int len)
+{
+	read_lock_bh(&sk->sk_callback_lock);
+	if (sk_has_sleeper(sk))
+		wake_up_interruptible_sync_poll(sk->sk_sleep, POLLIN |
+						POLLRDNORM | POLLRDBAND);
+	sk_wake_async(sk, SOCK_WAKE_WAITD, POLL_IN);
+	read_unlock_bh(&sk->sk_callback_lock);
+}
+
 /* If socket sndbuf has changed, wake up all per association waiters.  */
 void sctp_write_space(struct sock *sk)
 {


