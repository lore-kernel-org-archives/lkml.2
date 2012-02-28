Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932273Ab2B1Bkx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 20:40:53 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:49705 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932238Ab2B1BGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 20:06:22 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.204.39 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
MIME-Version: 1.0
Message-Id: <20120228010207.679941665@linuxfoundation.org>
User-Agent: quilt/0.51-17.1
Date: Mon, 27 Feb 2012 17:02:25 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Ben Greear <greearb@candelatech.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 22/73] ipv6-multicast: Fix memory leak in input path.
In-Reply-To: <20120228010246.GA24299@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Ben Greear <greearb@candelatech.com>

[ Upstream commit 2015de5fe2a47086a3260802275932bfd810884e ]

Have to free the skb before returning if we fail
the fib lookup.

Signed-off-by: Ben Greear <greearb@candelatech.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ip6mr.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -2051,8 +2051,10 @@ int ip6_mr_input(struct sk_buff *skb)
 	int err;
 
 	err = ip6mr_fib_lookup(net, &fl6, &mrt);
-	if (err < 0)
+	if (err < 0) {
+		kfree_skb(skb);
 		return err;
+	}
 
 	read_lock(&mrt_lock);
 	cache = ip6mr_cache_find(mrt,


