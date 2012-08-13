Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975Ab2HMUqN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 16:46:13 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:52067 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753305Ab2HMUUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 16:20:18 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <netdev@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, <containers@lists.linux-foundation.org>,
        David Miller <davem@davemloft.net>, Serge Hallyn <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>,
        Remi Denis-Courmont <courmisch@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Sridhar Samudrala <sri@us.ibm.com>
Date: Mon, 13 Aug 2012 13:18:20 -0700
Message-Id: <1344889115-21610-6-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1344889115-21610-1-git-send-email-ebiederm@xmission.com>
References: <87ehnav9n5.fsf@xmission.com>
 <1344889115-21610-1-git-send-email-ebiederm@xmission.com>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18h3aTWWQ8l7H9L7jYoNnWOTLy6ldzRghE=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4982]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 XMBrknScrpt_02 Possible Broken Spam Script
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;<netdev@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH 06/21] userns: Print out socket uids in a user namespace aware fashion.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

Cc: David Miller <davem@davemloft.net>
Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Cc: James Morris <jmorris@namei.org>
Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc: Patrick McHardy <kaber@trash.net>
Cc: Remi Denis-Courmont <courmisch@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Vlad Yasevich <vyasevich@gmail.com>
Cc: Sridhar Samudrala <sri@us.ibm.com>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 include/net/tcp.h          |    3 ++-
 init/Kconfig               |    6 ------
 net/appletalk/atalk_proc.c |    3 ++-
 net/ipv4/ping.c            |    4 +++-
 net/ipv4/raw.c             |    4 +++-
 net/ipv4/tcp_ipv4.c        |    6 +++---
 net/ipv4/udp.c             |    4 +++-
 net/ipv6/raw.c             |    3 ++-
 net/ipv6/tcp_ipv6.c        |    6 +++---
 net/ipv6/udp.c             |    3 ++-
 net/ipx/ipx_proc.c         |    3 ++-
 net/key/af_key.c           |    2 +-
 net/llc/llc_proc.c         |    2 +-
 net/packet/af_packet.c     |    2 +-
 net/phonet/socket.c        |    6 ++++--
 net/sctp/proc.c            |    6 ++++--
 16 files changed, 36 insertions(+), 27 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index e19124b..91e7467 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1509,7 +1509,8 @@ struct tcp_iter_state {
 	sa_family_t		family;
 	enum tcp_seq_states	state;
 	struct sock		*syn_wait_sk;
-	int			bucket, offset, sbucket, num, uid;
+	int			bucket, offset, sbucket, num;
+	kuid_t			uid;
 	loff_t			last_pos;
 };
 
diff --git a/init/Kconfig b/init/Kconfig
index 80fae19..25a6ebb 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -942,10 +942,7 @@ config UIDGID_CONVERTED
 	depends on PROC_EVENTS = n
 
 	# Networking
-	depends on PACKET = n
 	depends on NET_9P = n
-	depends on IPX = n
-	depends on PHONET = n
 	depends on NET_CLS_FLOW = n
 	depends on NETFILTER_XT_MATCH_OWNER = n
 	depends on NETFILTER_XT_MATCH_RECENT = n
@@ -953,14 +950,11 @@ config UIDGID_CONVERTED
 	depends on NETFILTER_NETLINK_LOG = n
 	depends on INET = n
 	depends on IPV6 = n
-	depends on IP_SCTP = n
 	depends on AF_RXRPC = n
-	depends on LLC2 = n
 	depends on NET_KEY = n
 	depends on INET_DIAG = n
 	depends on DNS_RESOLVER = n
 	depends on AX25 = n
-	depends on ATALK = n
 
 	# Filesystems
 	depends on USB_GADGETFS = n
diff --git a/net/appletalk/atalk_proc.c b/net/appletalk/atalk_proc.c
index b5b1a22..c30f3a0 100644
--- a/net/appletalk/atalk_proc.c
+++ b/net/appletalk/atalk_proc.c
@@ -183,7 +183,8 @@ static int atalk_seq_socket_show(struct seq_file *seq, void *v)
 		   ntohs(at->dest_net), at->dest_node, at->dest_port,
 		   sk_wmem_alloc_get(s),
 		   sk_rmem_alloc_get(s),
-		   s->sk_state, SOCK_INODE(s->sk_socket)->i_uid);
+		   s->sk_state,
+		   from_kuid_munged(seq_user_ns(seq), sock_i_uid(s)));
 out:
 	return 0;
 }
diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
index 6232d47..bee5eeb 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -845,7 +845,9 @@ static void ping_format_sock(struct sock *sp, struct seq_file *f,
 		bucket, src, srcp, dest, destp, sp->sk_state,
 		sk_wmem_alloc_get(sp),
 		sk_rmem_alloc_get(sp),
-		0, 0L, 0, sock_i_uid(sp), 0, sock_i_ino(sp),
+		0, 0L, 0,
+		from_kuid_munged(seq_user_ns(f), sock_i_uid(sp)),
+		0, sock_i_ino(sp),
 		atomic_read(&sp->sk_refcnt), sp,
 		atomic_read(&sp->sk_drops), len);
 }
diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
index ff0f071..f242578 100644
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -992,7 +992,9 @@ static void raw_sock_seq_show(struct seq_file *seq, struct sock *sp, int i)
 		i, src, srcp, dest, destp, sp->sk_state,
 		sk_wmem_alloc_get(sp),
 		sk_rmem_alloc_get(sp),
-		0, 0L, 0, sock_i_uid(sp), 0, sock_i_ino(sp),
+		0, 0L, 0,
+		from_kuid_munged(seq_user_ns(seq), sock_i_uid(sp)),
+		0, sock_i_ino(sp),
 		atomic_read(&sp->sk_refcnt), sp, atomic_read(&sp->sk_drops));
 }
 
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 42b2a6a..642be8a 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2382,7 +2382,7 @@ void tcp_proc_unregister(struct net *net, struct tcp_seq_afinfo *afinfo)
 EXPORT_SYMBOL(tcp_proc_unregister);
 
 static void get_openreq4(const struct sock *sk, const struct request_sock *req,
-			 struct seq_file *f, int i, int uid, int *len)
+			 struct seq_file *f, int i, kuid_t uid, int *len)
 {
 	const struct inet_request_sock *ireq = inet_rsk(req);
 	int ttd = req->expires - jiffies;
@@ -2399,7 +2399,7 @@ static void get_openreq4(const struct sock *sk, const struct request_sock *req,
 		1,    /* timers active (only the expire timer) */
 		jiffies_to_clock_t(ttd),
 		req->retrans,
-		uid,
+		from_kuid_munged(seq_user_ns(f), uid),
 		0,  /* non standard timer */
 		0, /* open_requests have no inode */
 		atomic_read(&sk->sk_refcnt),
@@ -2450,7 +2450,7 @@ static void get_tcp4_sock(struct sock *sk, struct seq_file *f, int i, int *len)
 		timer_active,
 		jiffies_to_clock_t(timer_expires - jiffies),
 		icsk->icsk_retransmits,
-		sock_i_uid(sk),
+		from_kuid_munged(seq_user_ns(f), sock_i_uid(sk)),
 		icsk->icsk_probes_out,
 		sock_i_ino(sk),
 		atomic_read(&sk->sk_refcnt), sk,
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index b4c3582..53b8981 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -2110,7 +2110,9 @@ static void udp4_format_sock(struct sock *sp, struct seq_file *f,
 		bucket, src, srcp, dest, destp, sp->sk_state,
 		sk_wmem_alloc_get(sp),
 		sk_rmem_alloc_get(sp),
-		0, 0L, 0, sock_i_uid(sp), 0, sock_i_ino(sp),
+		0, 0L, 0,
+		from_kuid_munged(seq_user_ns(f), sock_i_uid(sp)),
+		0, sock_i_ino(sp),
 		atomic_read(&sp->sk_refcnt), sp,
 		atomic_read(&sp->sk_drops), len);
 }
diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
index ef0579d..7af88ef 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -1251,7 +1251,8 @@ static void raw6_sock_seq_show(struct seq_file *seq, struct sock *sp, int i)
 		   sk_wmem_alloc_get(sp),
 		   sk_rmem_alloc_get(sp),
 		   0, 0L, 0,
-		   sock_i_uid(sp), 0,
+		   from_kuid_munged(seq_user_ns(seq), sock_i_uid(sp)),
+		   0,
 		   sock_i_ino(sp),
 		   atomic_read(&sp->sk_refcnt), sp, atomic_read(&sp->sk_drops));
 }
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index c66b90f..4b5b335 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1803,7 +1803,7 @@ static void tcp_v6_destroy_sock(struct sock *sk)
 #ifdef CONFIG_PROC_FS
 /* Proc filesystem TCPv6 sock list dumping. */
 static void get_openreq6(struct seq_file *seq,
-			 const struct sock *sk, struct request_sock *req, int i, int uid)
+			 const struct sock *sk, struct request_sock *req, int i, kuid_t uid)
 {
 	int ttd = req->expires - jiffies;
 	const struct in6_addr *src = &inet6_rsk(req)->loc_addr;
@@ -1827,7 +1827,7 @@ static void get_openreq6(struct seq_file *seq,
 		   1,   /* timers active (only the expire timer) */
 		   jiffies_to_clock_t(ttd),
 		   req->retrans,
-		   uid,
+		   from_kuid_munged(seq_user_ns(seq), uid),
 		   0,  /* non standard timer */
 		   0, /* open_requests have no inode */
 		   0, req);
@@ -1877,7 +1877,7 @@ static void get_tcp6_sock(struct seq_file *seq, struct sock *sp, int i)
 		   timer_active,
 		   jiffies_to_clock_t(timer_expires - jiffies),
 		   icsk->icsk_retransmits,
-		   sock_i_uid(sp),
+		   from_kuid_munged(seq_user_ns(seq), sock_i_uid(sp)),
 		   icsk->icsk_probes_out,
 		   sock_i_ino(sp),
 		   atomic_read(&sp->sk_refcnt), sp,
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 99d0077..bbdff07 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1458,7 +1458,8 @@ static void udp6_sock_seq_show(struct seq_file *seq, struct sock *sp, int bucket
 		   sk_wmem_alloc_get(sp),
 		   sk_rmem_alloc_get(sp),
 		   0, 0L, 0,
-		   sock_i_uid(sp), 0,
+		   from_kuid_munged(seq_user_ns(seq), sock_i_uid(sp)),
+		   0,
 		   sock_i_ino(sp),
 		   atomic_read(&sp->sk_refcnt), sp,
 		   atomic_read(&sp->sk_drops));
diff --git a/net/ipx/ipx_proc.c b/net/ipx/ipx_proc.c
index f8ba30d..02ff7f2 100644
--- a/net/ipx/ipx_proc.c
+++ b/net/ipx/ipx_proc.c
@@ -217,7 +217,8 @@ static int ipx_seq_socket_show(struct seq_file *seq, void *v)
 	seq_printf(seq, "%08X  %08X  %02X     %03d\n",
 		   sk_wmem_alloc_get(s),
 		   sk_rmem_alloc_get(s),
-		   s->sk_state, SOCK_INODE(s->sk_socket)->i_uid);
+		   s->sk_state,
+		   from_kuid_munged(seq_user_ns(seq), sock_i_uid(s)));
 out:
 	return 0;
 }
diff --git a/net/key/af_key.c b/net/key/af_key.c
index 34e4185..0481d4b 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -3661,7 +3661,7 @@ static int pfkey_seq_show(struct seq_file *f, void *v)
 			       atomic_read(&s->sk_refcnt),
 			       sk_rmem_alloc_get(s),
 			       sk_wmem_alloc_get(s),
-			       sock_i_uid(s),
+			       from_kuid_munged(seq_user_ns(f), sock_i_uid(s)),
 			       sock_i_ino(s)
 			       );
 	return 0;
diff --git a/net/llc/llc_proc.c b/net/llc/llc_proc.c
index a1839c0..7b4799c 100644
--- a/net/llc/llc_proc.c
+++ b/net/llc/llc_proc.c
@@ -151,7 +151,7 @@ static int llc_seq_socket_show(struct seq_file *seq, void *v)
 		   sk_wmem_alloc_get(sk),
 		   sk_rmem_alloc_get(sk) - llc->copied_seq,
 		   sk->sk_state,
-		   sk->sk_socket ? SOCK_INODE(sk->sk_socket)->i_uid : -1,
+		   from_kuid_munged(seq_user_ns(seq), sock_i_uid(sk)),
 		   llc->link);
 out:
 	return 0;
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index ceaca7c..d147317 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -3846,7 +3846,7 @@ static int packet_seq_show(struct seq_file *seq, void *v)
 			   po->ifindex,
 			   po->running,
 			   atomic_read(&s->sk_rmem_alloc),
-			   sock_i_uid(s),
+			   from_kuid_munged(seq_user_ns(seq), sock_i_uid(s)),
 			   sock_i_ino(s));
 	}
 
diff --git a/net/phonet/socket.c b/net/phonet/socket.c
index 0acc943..b7e9827 100644
--- a/net/phonet/socket.c
+++ b/net/phonet/socket.c
@@ -612,7 +612,8 @@ static int pn_sock_seq_show(struct seq_file *seq, void *v)
 			sk->sk_protocol, pn->sobject, pn->dobject,
 			pn->resource, sk->sk_state,
 			sk_wmem_alloc_get(sk), sk_rmem_alloc_get(sk),
-			sock_i_uid(sk), sock_i_ino(sk),
+			from_kuid_munged(seq_user_ns(seq), sock_i_uid(sk)),
+			sock_i_ino(sk),
 			atomic_read(&sk->sk_refcnt), sk,
 			atomic_read(&sk->sk_drops), &len);
 	}
@@ -796,7 +797,8 @@ static int pn_res_seq_show(struct seq_file *seq, void *v)
 		struct sock *sk = *psk;
 
 		seq_printf(seq, "%02X %5d %lu%n",
-			   (int) (psk - pnres.sk), sock_i_uid(sk),
+			   (int) (psk - pnres.sk),
+			   from_kuid_munged(seq_user_ns(seq), sock_i_uid(sk)),
 			   sock_i_ino(sk), &len);
 	}
 	seq_printf(seq, "%*s\n", 63 - len, "");
diff --git a/net/sctp/proc.c b/net/sctp/proc.c
index 1e2eee8..dc12feb 100644
--- a/net/sctp/proc.c
+++ b/net/sctp/proc.c
@@ -216,7 +216,8 @@ static int sctp_eps_seq_show(struct seq_file *seq, void *v)
 		seq_printf(seq, "%8pK %8pK %-3d %-3d %-4d %-5d %5d %5lu ", ep, sk,
 			   sctp_sk(sk)->type, sk->sk_state, hash,
 			   epb->bind_addr.port,
-			   sock_i_uid(sk), sock_i_ino(sk));
+			   from_kuid_munged(seq_user_ns(seq), sock_i_uid(sk)),
+			   sock_i_ino(sk));
 
 		sctp_seq_dump_local_addrs(seq, epb);
 		seq_printf(seq, "\n");
@@ -324,7 +325,8 @@ static int sctp_assocs_seq_show(struct seq_file *seq, void *v)
 			   assoc->assoc_id,
 			   assoc->sndbuf_used,
 			   atomic_read(&assoc->rmem_alloc),
-			   sock_i_uid(sk), sock_i_ino(sk),
+			   from_kuid_munged(seq_user_ns(seq), sock_i_uid(sk)),
+			   sock_i_ino(sk),
 			   epb->bind_addr.port,
 			   assoc->peer.port);
 		seq_printf(seq, " ");
-- 
1.7.5.4

