Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934863Ab1KJD1k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:27:40 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42412 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934074Ab1KJD1g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:27:36 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:14 2011
Message-Id: <20111109212714.899181185@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:27:44 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Zheng Yan <zheng.z.yan@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [142/262] tcp: properly handle md5sig_pool references
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: "Yan, Zheng" <zheng.z.yan@intel.com>

[ Upstream commit 260fcbeb1ae9e768a44c9925338fbacb0d7e5ba9 ]

tcp_v4_clear_md5_list() assumes that multiple tcp md5sig peers
only hold one reference to md5sig_pool. but tcp_v4_md5_do_add()
increases use count of md5sig_pool for each peer. This patch
makes tcp_v4_md5_do_add() only increases use count for the first
tcp md5sig peer.

Signed-off-by: Zheng Yan <zheng.z.yan@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/ipv4/tcp_ipv4.c |   11 +++++++----
 net/ipv6/tcp_ipv6.c |    8 +++++---
 2 files changed, 12 insertions(+), 7 deletions(-)

--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -909,18 +909,21 @@ int tcp_v4_md5_do_add(struct sock *sk, _
 			}
 			sk_nocaps_add(sk, NETIF_F_GSO_MASK);
 		}
-		if (tcp_alloc_md5sig_pool(sk) == NULL) {
+
+		md5sig = tp->md5sig_info;
+		if (md5sig->entries4 == 0 &&
+		    tcp_alloc_md5sig_pool(sk) == NULL) {
 			kfree(newkey);
 			return -ENOMEM;
 		}
-		md5sig = tp->md5sig_info;
 
 		if (md5sig->alloced4 == md5sig->entries4) {
 			keys = kmalloc((sizeof(*keys) *
 					(md5sig->entries4 + 1)), GFP_ATOMIC);
 			if (!keys) {
 				kfree(newkey);
-				tcp_free_md5sig_pool();
+				if (md5sig->entries4 == 0)
+					tcp_free_md5sig_pool();
 				return -ENOMEM;
 			}
 
@@ -964,6 +967,7 @@ int tcp_v4_md5_do_del(struct sock *sk, _
 				kfree(tp->md5sig_info->keys4);
 				tp->md5sig_info->keys4 = NULL;
 				tp->md5sig_info->alloced4 = 0;
+				tcp_free_md5sig_pool();
 			} else if (tp->md5sig_info->entries4 != i) {
 				/* Need to do some manipulation */
 				memmove(&tp->md5sig_info->keys4[i],
@@ -971,7 +975,6 @@ int tcp_v4_md5_do_del(struct sock *sk, _
 					(tp->md5sig_info->entries4 - i) *
 					 sizeof(struct tcp4_md5sig_key));
 			}
-			tcp_free_md5sig_pool();
 			return 0;
 		}
 	}
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -605,7 +605,8 @@ static int tcp_v6_md5_do_add(struct sock
 			}
 			sk_nocaps_add(sk, NETIF_F_GSO_MASK);
 		}
-		if (tcp_alloc_md5sig_pool(sk) == NULL) {
+		if (tp->md5sig_info->entries6 == 0 &&
+			tcp_alloc_md5sig_pool(sk) == NULL) {
 			kfree(newkey);
 			return -ENOMEM;
 		}
@@ -614,8 +615,9 @@ static int tcp_v6_md5_do_add(struct sock
 				       (tp->md5sig_info->entries6 + 1)), GFP_ATOMIC);
 
 			if (!keys) {
-				tcp_free_md5sig_pool();
 				kfree(newkey);
+				if (tp->md5sig_info->entries6 == 0)
+					tcp_free_md5sig_pool();
 				return -ENOMEM;
 			}
 
@@ -661,6 +663,7 @@ static int tcp_v6_md5_do_del(struct sock
 				kfree(tp->md5sig_info->keys6);
 				tp->md5sig_info->keys6 = NULL;
 				tp->md5sig_info->alloced6 = 0;
+				tcp_free_md5sig_pool();
 			} else {
 				/* shrink the database */
 				if (tp->md5sig_info->entries6 != i)
@@ -669,7 +672,6 @@ static int tcp_v6_md5_do_del(struct sock
 						(tp->md5sig_info->entries6 - i)
 						* sizeof (tp->md5sig_info->keys6[0]));
 			}
-			tcp_free_md5sig_pool();
 			return 0;
 		}
 	}


