Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754280Ab1HNQYl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 12:24:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36583 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754183Ab1HNQH7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 12:07:59 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 12 14:05:55 2011
Message-Id: <20110812210555.799724197@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 12 Aug 2011 14:04:27 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [42/90] ipv6: make fragment identifications less predictable
In-Reply-To: <20110812210626.GA4725@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Eric Dumazet <eric.dumazet@gmail.com>

[ Backport of upstream commit 87c48fa3b4630905f98268dde838ee43626a060c ]

Fernando Gont reported current IPv6 fragment identification generation
was not secure, because using a very predictable system-wide generator,
allowing various attacks.

IPv4 uses inetpeer cache to address this problem and to get good
performance. We'll use this mechanism when IPv6 inetpeer is stable
enough in linux-3.1

For the time being, we use jhash on destination address to provide less
predictable identifications. Also remove a spinlock and use cmpxchg() to
get better SMP performance.

Reported-by: Fernando Gont <fernando@gont.com.ar>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/net/ipv6.h      |   12 +-----------
 include/net/transp_v6.h |    2 ++
 net/ipv6/af_inet6.c     |    2 ++
 net/ipv6/ip6_output.c   |   40 +++++++++++++++++++++++++++++++++++-----
 net/ipv6/udp.c          |    2 +-
 5 files changed, 41 insertions(+), 17 deletions(-)

--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -463,17 +463,7 @@ static inline int ipv6_addr_diff(const s
 	return __ipv6_addr_diff(a1, a2, sizeof(struct in6_addr));
 }
 
-static __inline__ void ipv6_select_ident(struct frag_hdr *fhdr)
-{
-	static u32 ipv6_fragmentation_id = 1;
-	static DEFINE_SPINLOCK(ip6_id_lock);
-
-	spin_lock_bh(&ip6_id_lock);
-	fhdr->identification = htonl(ipv6_fragmentation_id);
-	if (++ipv6_fragmentation_id == 0)
-		ipv6_fragmentation_id = 1;
-	spin_unlock_bh(&ip6_id_lock);
-}
+extern void ipv6_select_ident(struct frag_hdr *fhdr, struct rt6_info *rt);
 
 /*
  *	Prototypes exported by ipv6
--- a/include/net/transp_v6.h
+++ b/include/net/transp_v6.h
@@ -14,6 +14,8 @@ extern struct proto tcpv6_prot;
 
 struct flowi6;
 
+extern void initialize_hashidentrnd(void);
+
 /* extension headers */
 extern int				ipv6_exthdrs_init(void);
 extern void				ipv6_exthdrs_exit(void);
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -1078,6 +1078,8 @@ static int __init inet6_init(void)
 		goto out;
 	}
 
+	initialize_hashidentrnd();
+
 	err = proto_register(&tcpv6_prot, 1);
 	if (err)
 		goto out;
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -596,6 +596,35 @@ int ip6_find_1stfragopt(struct sk_buff *
 	return offset;
 }
 
+static u32 hashidentrnd __read_mostly;
+#define FID_HASH_SZ 16
+static u32 ipv6_fragmentation_id[FID_HASH_SZ];
+
+void __init initialize_hashidentrnd(void)
+{
+	get_random_bytes(&hashidentrnd, sizeof(hashidentrnd));
+}
+
+static u32 __ipv6_select_ident(const struct in6_addr *addr)
+{
+	u32 newid, oldid, hash = jhash2((u32 *)addr, 4, hashidentrnd);
+	u32 *pid = &ipv6_fragmentation_id[hash % FID_HASH_SZ];
+
+	do {
+		oldid = *pid;
+		newid = oldid + 1;
+		if (!(hash + newid))
+			newid++;
+	} while (cmpxchg(pid, oldid, newid) != oldid);
+
+	return hash + newid;
+}
+
+void ipv6_select_ident(struct frag_hdr *fhdr, struct rt6_info *rt)
+{
+	fhdr->identification = htonl(__ipv6_select_ident(&rt->rt6i_dst.addr));
+}
+
 int ip6_fragment(struct sk_buff *skb, int (*output)(struct sk_buff *))
 {
 	struct sk_buff *frag;
@@ -680,7 +709,7 @@ int ip6_fragment(struct sk_buff *skb, in
 		skb_reset_network_header(skb);
 		memcpy(skb_network_header(skb), tmp_hdr, hlen);
 
-		ipv6_select_ident(fh);
+		ipv6_select_ident(fh, rt);
 		fh->nexthdr = nexthdr;
 		fh->reserved = 0;
 		fh->frag_off = htons(IP6_MF);
@@ -826,7 +855,7 @@ slow_path:
 		fh->nexthdr = nexthdr;
 		fh->reserved = 0;
 		if (!frag_id) {
-			ipv6_select_ident(fh);
+			ipv6_select_ident(fh, rt);
 			frag_id = fh->identification;
 		} else
 			fh->identification = frag_id;
@@ -1072,7 +1101,8 @@ static inline int ip6_ufo_append_data(st
 			int getfrag(void *from, char *to, int offset, int len,
 			int odd, struct sk_buff *skb),
 			void *from, int length, int hh_len, int fragheaderlen,
-			int transhdrlen, int mtu,unsigned int flags)
+			int transhdrlen, int mtu,unsigned int flags,
+			struct rt6_info *rt)
 
 {
 	struct sk_buff *skb;
@@ -1116,7 +1146,7 @@ static inline int ip6_ufo_append_data(st
 		skb_shinfo(skb)->gso_size = (mtu - fragheaderlen -
 					     sizeof(struct frag_hdr)) & ~7;
 		skb_shinfo(skb)->gso_type = SKB_GSO_UDP;
-		ipv6_select_ident(&fhdr);
+		ipv6_select_ident(&fhdr, rt);
 		skb_shinfo(skb)->ip6_frag_id = fhdr.identification;
 		__skb_queue_tail(&sk->sk_write_queue, skb);
 
@@ -1282,7 +1312,7 @@ int ip6_append_data(struct sock *sk, int
 
 			err = ip6_ufo_append_data(sk, getfrag, from, length,
 						  hh_len, fragheaderlen,
-						  transhdrlen, mtu, flags);
+						  transhdrlen, mtu, flags, rt);
 			if (err)
 				goto error;
 			return 0;
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1359,7 +1359,7 @@ static struct sk_buff *udp6_ufo_fragment
 	fptr = (struct frag_hdr *)(skb_network_header(skb) + unfrag_ip6hlen);
 	fptr->nexthdr = nexthdr;
 	fptr->reserved = 0;
-	ipv6_select_ident(fptr);
+	ipv6_select_ident(fptr, (struct rt6_info *)skb_dst(skb));
 
 	/* Fragment the skb. ipv6 header and the remaining fields of the
 	 * fragment header are updated in ipv6_gso_segment()


