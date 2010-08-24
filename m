Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933176Ab0HXX2w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 19:28:52 -0400
Received: from kroah.org ([198.145.64.141]:40580 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933029Ab0HXW7i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 18:59:38 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:42:18 2010
Message-Id: <20100824224218.262413581@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:42:34 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [72/91] netlink: fix compat recvmsg
In-Reply-To: <20100824224617.GA5440@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit 68d6ac6d2740b6a55f3ae92a4e0be6d881904b32 upstream.

Since
commit 1dacc76d0014a034b8aca14237c127d7c19d7726
Author: Johannes Berg <johannes@sipsolutions.net>
Date:   Wed Jul 1 11:26:02 2009 +0000

    net/compat/wext: send different messages to compat tasks

we had a race condition when setting and then
restoring frag_list. Eric attempted to fix it,
but the fix created even worse problems.

However, the original motivation I had when I
added the code that turned out to be racy is
no longer clear to me, since we only copy up
to skb->len to userspace, which doesn't include
the frag_list length. As a result, not doing
any frag_list clearing and restoring avoids
the race condition, while not introducing any
other problems.

Additionally, while preparing this patch I found
that since none of the remaining netlink code is
really aware of the frag_list, we need to use the
original skb's information for packet information
and credentials. This fixes, for example, the
group information received by compat tasks.

Cc: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Acked-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/netlink/af_netlink.c |   46 ++++++++++++++++------------------------------
 1 file changed, 16 insertions(+), 30 deletions(-)

--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -1383,7 +1383,7 @@ static int netlink_recvmsg(struct kiocb
 	struct netlink_sock *nlk = nlk_sk(sk);
 	int noblock = flags&MSG_DONTWAIT;
 	size_t copied;
-	struct sk_buff *skb, *frag __maybe_unused = NULL;
+	struct sk_buff *skb, *data_skb;
 	int err;
 
 	if (flags&MSG_OOB)
@@ -1395,45 +1395,35 @@ static int netlink_recvmsg(struct kiocb
 	if (skb == NULL)
 		goto out;
 
+	data_skb = skb;
+
 #ifdef CONFIG_COMPAT_NETLINK_MESSAGES
 	if (unlikely(skb_shinfo(skb)->frag_list)) {
-		bool need_compat = !!(flags & MSG_CMSG_COMPAT);
-
 		/*
-		 * If this skb has a frag_list, then here that means that
-		 * we will have to use the frag_list skb for compat tasks
-		 * and the regular skb for non-compat tasks.
+		 * If this skb has a frag_list, then here that means that we
+		 * will have to use the frag_list skb's data for compat tasks
+		 * and the regular skb's data for normal (non-compat) tasks.
 		 *
-		 * The skb might (and likely will) be cloned, so we can't
-		 * just reset frag_list and go on with things -- we need to
-		 * keep that. For the compat case that's easy -- simply get
-		 * a reference to the compat skb and free the regular one
-		 * including the frag. For the non-compat case, we need to
-		 * avoid sending the frag to the user -- so assign NULL but
-		 * restore it below before freeing the skb.
+		 * If we need to send the compat skb, assign it to the
+		 * 'data_skb' variable so that it will be used below for data
+		 * copying. We keep 'skb' for everything else, including
+		 * freeing both later.
 		 */
-		if (need_compat) {
-			struct sk_buff *compskb = skb_shinfo(skb)->frag_list;
-			skb_get(compskb);
-			kfree_skb(skb);
-			skb = compskb;
-		} else {
-			frag = skb_shinfo(skb)->frag_list;
-			skb_shinfo(skb)->frag_list = NULL;
-		}
+		if (flags & MSG_CMSG_COMPAT)
+			data_skb = skb_shinfo(skb)->frag_list;
 	}
 #endif
 
 	msg->msg_namelen = 0;
 
-	copied = skb->len;
+	copied = data_skb->len;
 	if (len < copied) {
 		msg->msg_flags |= MSG_TRUNC;
 		copied = len;
 	}
 
-	skb_reset_transport_header(skb);
-	err = skb_copy_datagram_iovec(skb, 0, msg->msg_iov, copied);
+	skb_reset_transport_header(data_skb);
+	err = skb_copy_datagram_iovec(data_skb, 0, msg->msg_iov, copied);
 
 	if (msg->msg_name) {
 		struct sockaddr_nl *addr = (struct sockaddr_nl *)msg->msg_name;
@@ -1453,11 +1443,7 @@ static int netlink_recvmsg(struct kiocb
 	}
 	siocb->scm->creds = *NETLINK_CREDS(skb);
 	if (flags & MSG_TRUNC)
-		copied = skb->len;
-
-#ifdef CONFIG_COMPAT_NETLINK_MESSAGES
-	skb_shinfo(skb)->frag_list = frag;
-#endif
+		copied = data_skb->len;
 
 	skb_free_datagram(sk, skb);
 


