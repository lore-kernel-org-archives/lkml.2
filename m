Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933151Ab0ECQPC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 12:15:02 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:52946 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758731Ab0ECQO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 12:14:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=OkRjfbryPQyIX3CmzTCZFPbQ/8JRE9hdudq9kD2nRl4o4vuaUuSNXpWnpuD/4GgwqY
         BYfFmkVVuAiBFgOFU6zW1xatzVbGOVJ/N5i3QfwXFfUP/M3R2fP5NK8JBWWVdkzLLaBN
         Q0nn6J/ZDa+qRGlbaFtHbdu/p9yFmrAIh2mkM=
Subject: Re: mmotm 2010-04-28 - RCU whinges
From: Eric Dumazet <eric.dumazet@gmail.com>
To: paulmck@linux.vnet.ibm.com
Cc: Valdis.Kletnieks@vt.edu, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Patrick McHardy <kaber@trash.net>,
       "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <20100503154357.GF2597@linux.vnet.ibm.com>
References: <201004290021.o3T0L04Y028017@imap1.linux-foundation.org>
	 <5702.1272822394@localhost> <1272865137.2173.179.camel@edumazet-laptop>
	 <5933.1272897014@localhost> <1272898726.2226.47.camel@edumazet-laptop>
	 <5112.1272900590@localhost>  <20100503154357.GF2597@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 03 May 2010 18:14:53 +0200
Message-ID: <1272903293.2226.50.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 03 mai 2010 à 08:43 -0700, Paul E. McKenney a écrit :

> Highly recommended.  ;-)
> 
> And thanks to you for your testing efforts and to Eric for the fixes!!!
> 

For this last one, I think you should push following patch Paul

Followup of commit 3120438ad6
(rcu: Disable lockdep checking in RCU list-traversal primitives)

Or we might introduce a hlist_for_each_entry_continue_rcu_bh() macro...



diff --git a/include/linux/rculist.h b/include/linux/rculist.h
index 004908b..b0c7e24 100644
--- a/include/linux/rculist.h
+++ b/include/linux/rculist.h
@@ -435,10 +435,10 @@ static inline void hlist_add_after_rcu(struct hlist_node *prev,
  * @member:	the name of the hlist_node within the struct.
  */
 #define hlist_for_each_entry_continue_rcu(tpos, pos, member)		\
-	for (pos = rcu_dereference((pos)->next);			\
+	for (pos = rcu_dereference_raw((pos)->next);			\
 	     pos && ({ prefetch(pos->next); 1; }) &&			\
 	     ({ tpos = hlist_entry(pos, typeof(*tpos), member); 1; });  \
-	     pos = rcu_dereference(pos->next))
+	     pos = rcu_dereference_raw(pos->next))
 
 
 #endif	/* __KERNEL__ */


