Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756273Ab0ECTqz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 15:46:55 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:41308 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755771Ab0ECTqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 15:46:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=snOIpZBKKKoqQBIyFtedUkqYEqwKke0Yo8ntdQqYZVYBCsmkBJNViRjpa3tRUpF3bc
         YfiAo6JzMCkoaPSTAb5OcUXKh+Zh3FDscbvr5KVHe081tLMA9YYI7ADdX7i5keTC6trH
         W5oWzfQ/iWH6gqCmLhwycxNTDSZz/P8nlCswY=
Subject: [PATCH net-next-2.6] net: if6_get_next() fix
From: Eric Dumazet <eric.dumazet@gmail.com>
To: paulmck@linux.vnet.ibm.com, Stephen Hemminger <shemminger@vyatta.com>
Cc: Valdis.Kletnieks@vt.edu, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Patrick McHardy <kaber@trash.net>,
       "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <20100503181629.GJ2597@linux.vnet.ibm.com>
References: <201004290021.o3T0L04Y028017@imap1.linux-foundation.org>
	 <5702.1272822394@localhost> <1272865137.2173.179.camel@edumazet-laptop>
	 <5933.1272897014@localhost> <1272898726.2226.47.camel@edumazet-laptop>
	 <5112.1272900590@localhost> <20100503154357.GF2597@linux.vnet.ibm.com>
	 <1272903293.2226.50.camel@edumazet-laptop>
	 <20100503181629.GJ2597@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 03 May 2010 21:46:47 +0200
Message-ID: <1272916007.2407.75.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 03 mai 2010 à 11:16 -0700, Paul E. McKenney a écrit :
> I would be happy to if I could find the commit creating
> hlist_for_each_entry_continue_rcu()...
> 
> I do see a ca. 2008 patch from Stephen Hemminger:
> 
> 	http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg264661.html
> 
> According to http://patchwork.ozlabs.org/patch/47997/, this is
> going up the networking tree as of March 18, 2010.
> 
> So I would be happy to push the patch below, but to do so, I will need
> to adopt the portion of Stephen's patch that created this primitive.
> 

Hmm,  I realize there is a true bug introduced by Stephen patch

Then, net-next-2.6 doesnt yet have your commit Paul to relax
hlist_for_each_entry_rcu(), so its a bit difficult to continue the work.

Thanks

[PATCH net-next-2.6] net: if6_get_next() fix

Must use rcu variant, we are in a rcu_read_lock_bh() section

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
---
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 34d2d64..16bb85c 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -2979,7 +2979,7 @@ static struct inet6_ifaddr *if6_get_next(struct seq_file *seq,
 			return ifa;
 
 	while (++state->bucket < IN6_ADDR_HSIZE) {
-		hlist_for_each_entry(ifa, n,
+		hlist_for_each_entry_rcu(ifa, n,
 				     &inet6_addr_lst[state->bucket], addr_lst) {
 			if (net_eq(dev_net(ifa->idev->dev), net))
 				return ifa;


