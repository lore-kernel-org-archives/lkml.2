Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756649Ab0HPUW2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 16:22:28 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:35880 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756521Ab0HPUW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 16:22:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Mo3DvqQHnYOIgARbM0xlEjux1xZoRvHqrP+pHlgc+mh3p74iOnorYVAauva8E6b1pS
         ruDSjDNzZ4D1oW1FFsArH85sTEeAxc+GEGGEwWQnOTgMhV3tng40t9P9KjBoSxRzBeZP
         NV+Q6DLvM860TsQtiE9J1FJLw5rTS5z2ggqg0=
Subject: Re: [GIT] Networking
From: Eric Dumazet <eric.dumazet@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kaber@trash.net,
        Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <20100816.123607.57459160.davem@davemloft.net>
References: <20100814.220945.232761341.davem@davemloft.net>
	 <1281869722.2942.20.camel@edumazet-laptop>
	 <1281883637.2942.42.camel@edumazet-laptop>
	 <20100816.123607.57459160.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 Aug 2010 22:22:10 +0200
Message-ID: <1281990130.2487.70.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 16 août 2010 à 12:36 -0700, David Miller a écrit :

> I'm hesistent to say that we should put this kind of patch in.
> 
> It will shut up lockdep for this specific case, but it also means
> that if we do any other kinds of locking in this sequence we will
> not validate it.
> 
> The valuable of this is open for debate I guess.
> 
> But locking is hard so I would say that disabling lockdep to kill a
> warning it generates should be an absolute last resort.
> 
> I also don't think making the locking mechanics conditional upon
> LOCKDEP is sane either, exactly because it means lockdep is testing
> something other than what actually gets used in practice. :-)

Hmm, maybe just disable BH, not for whole duration, but for each cpu.

Its a bit late here and I prefer to close this problem before whole
earth shout on me.

Thanks

[PATCH] netfilter: {ip,ip6,arp}_tables: avoid lockdep false positive

After commit 24b36f019 (netfilter: {ip,ip6,arp}_tables: dont block
bottom half more than necessary), lockdep can raise a warning
because we attempt to lock a spinlock with BH enabled, while
the same lock is usually locked by another cpu in a softirq context.

Disable again BH to avoid these lockdep warnings.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Diagnosed-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
CC: Patrick McHardy <kaber@trash.net>
CC: Peter Zijlstra <peterz@infradead.org>
---
 net/ipv4/netfilter/arp_tables.c |    2 ++
 net/ipv4/netfilter/ip_tables.c  |    2 ++
 net/ipv6/netfilter/ip6_tables.c |    2 ++
 3 files changed, 6 insertions(+)

diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 6bccba3..51d6c31 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -735,6 +735,7 @@ static void get_counters(const struct xt_table_info *t,
 		if (cpu == curcpu)
 			continue;
 		i = 0;
+		local_bh_disable();
 		xt_info_wrlock(cpu);
 		xt_entry_foreach(iter, t->entries[cpu], t->size) {
 			ADD_COUNTER(counters[i], iter->counters.bcnt,
@@ -742,6 +743,7 @@ static void get_counters(const struct xt_table_info *t,
 			++i;
 		}
 		xt_info_wrunlock(cpu);
+		local_bh_enable();
 	}
 	put_cpu();
 }
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index c439721..97b64b2 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -909,6 +909,7 @@ get_counters(const struct xt_table_info *t,
 		if (cpu == curcpu)
 			continue;
 		i = 0;
+		local_bh_disable();
 		xt_info_wrlock(cpu);
 		xt_entry_foreach(iter, t->entries[cpu], t->size) {
 			ADD_COUNTER(counters[i], iter->counters.bcnt,
@@ -916,6 +917,7 @@ get_counters(const struct xt_table_info *t,
 			++i; /* macro does multi eval of i */
 		}
 		xt_info_wrunlock(cpu);
+		local_bh_enable();
 	}
 	put_cpu();
 }
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 5359ef4..29a7bca 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -922,6 +922,7 @@ get_counters(const struct xt_table_info *t,
 		if (cpu == curcpu)
 			continue;
 		i = 0;
+		local_bh_disable();
 		xt_info_wrlock(cpu);
 		xt_entry_foreach(iter, t->entries[cpu], t->size) {
 			ADD_COUNTER(counters[i], iter->counters.bcnt,
@@ -929,6 +930,7 @@ get_counters(const struct xt_table_info *t,
 			++i;
 		}
 		xt_info_wrunlock(cpu);
+		local_bh_enable();
 	}
 	put_cpu();
 }


