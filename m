Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755087Ab2LGBHo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 20:07:44 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:44913 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423248Ab2LGA5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 19:57:36 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        "netdev@vger.kernel.org, Eric Dumazet" <eric.dumazet@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [ 07/11] [PATCH 3.0.y] route: release dst_entry.hh_cache when handling redirects
Date: Thu,  6 Dec 2012 16:57:03 -0800
Message-Id: <20121207005615.450608760@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121207005613.189054768@linuxfoundation.org>
References: <20121207005613.189054768@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Kubecek <mkubecek@suse.cz>

Stable-3.0 commit 42ab5316 (ipv4: fix redirect handling) was
backport of mainline commit 9cc20b26 from 3.2-rc3 where hh
member of struct dst_entry was already gone.

However, in 3.0 we still have it and we have to clean it as
well, otherwise it keeps pointing to the cleaned up (and
unusable) hh_cache entry and packets cannot be sent out.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/route.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1374,6 +1374,7 @@ static int check_peer_redir(struct dst_e
 	struct rtable *rt = (struct rtable *) dst;
 	__be32 orig_gw = rt->rt_gateway;
 	struct neighbour *n, *old_n;
+	struct hh_cache *old_hh;
 
 	dst_confirm(&rt->dst);
 
@@ -1381,6 +1382,9 @@ static int check_peer_redir(struct dst_e
 	n = __arp_bind_neighbour(&rt->dst, rt->rt_gateway);
 	if (IS_ERR(n))
 		return PTR_ERR(n);
+	old_hh = xchg(&rt->dst.hh, NULL);
+	if (old_hh)
+		hh_cache_put(old_hh);
 	old_n = xchg(&rt->dst._neighbour, n);
 	if (old_n)
 		neigh_release(old_n);


