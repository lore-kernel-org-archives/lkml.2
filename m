Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757822Ab0HOPk4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Aug 2010 11:40:56 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57750 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757560Ab0HOPky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Aug 2010 11:40:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=NOcLXtxMvsBg4qmUH0SpJxslfyfMlazAb664f8POmGT2J38jpUKnT6Pd8mFpYvNsw9
         RKXkni8eQaYbL9Uu0uwyyJ06de69zdnWDia+jy9gb1OlyZZVPqAIT43L2hILVjwDTeUS
         6dfxEvxtyOLrzegQI7epViyVu/tt2zKLxsC/E=
Subject: Re: [GIT] Networking
From: Eric Dumazet <eric.dumazet@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Patrick McHardy <kaber@trash.net>
In-Reply-To: <1281869722.2942.20.camel@edumazet-laptop>
References: <20100812.161050.246523792.davem@davemloft.net>
	 <AANLkTinGy+-ELbVx_2WJ1wOJCsz4Rez26Q2Baisws9+C@mail.gmail.com>
	 <20100814.220945.232761341.davem@davemloft.net>
	 <1281869722.2942.20.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 15 Aug 2010 16:47:17 +0200
Message-ID: <1281883637.2942.42.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le dimanche 15 août 2010 à 12:55 +0200, Eric Dumazet a écrit :

> We have one lock per cpu, and only one cpu can possibly lock its
> associated lock under softirq. So the usual lockdep check, warning a
> lock is taken with BH enabled, while same lock was taken inside softirq
> handler is triggering a false positive here.
> 
> I believe no existing lockdep annotation can instruct lockdep this use
> is OK, I guess we have following choice :
> 
> 1) Mask BH again, using xt_info_wrlock_lockdep(cpu) instead of
> xt_info_wrlock(cpu).
> 
> xt_info_wrlock_lockdep() being a variant, that disables BH in case
> CONFIG_PROVE_LOCKING=y
> 
> 2) temporally switch off lockdep in get_counters(), using a
> lockdep_off()/lockdep_on() pair, and a comment why this is necessary.
> 

In any case, here is patch implementing the later

CC Patrick, our netfilter maintainer...

Maybe lockdep rules could be improved to take care of this later ?

Thanks

[PATCH] netfilter: {ip,ip6,arp}_tables: avoid lockdep false positive

After commit 24b36f019 (netfilter: {ip,ip6,arp}_tables: dont block
bottom half more than necessary), lockdep can raise a warning
because we attempt to lock a spinlock with BH enabled, while
the same lock is usually locked by another cpu in a softirq context.

In this use case, the lockdep splat is a false positive, because
the BH disabling only matters for one cpu for a given lock
(we use one lock per cpu).

Use lockdep_off()/lockdep_on() around the problematic section to
avoid the splat.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Diagnosed-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
CC: Patrick McHardy <kaber@trash.net>
---
 net/ipv4/netfilter/arp_tables.c |    3 +++
 net/ipv4/netfilter/ip_tables.c  |    3 +++
 net/ipv6/netfilter/ip6_tables.c |    3 +++
 3 files changed, 9 insertions(+)

diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 6bccba3..b4f7ebf 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -729,8 +729,10 @@ static void get_counters(const struct xt_table_info *t,
 	local_bh_enable();
 	/* Processing counters from other cpus, we can let bottom half enabled,
 	 * (preemption is disabled)
+	 * We must turn off lockdep to avoid a false positive.
 	 */
 
+	lockdep_off();
 	for_each_possible_cpu(cpu) {
 		if (cpu == curcpu)
 			continue;
@@ -743,6 +745,7 @@ static void get_counters(const struct xt_table_info *t,
 		}
 		xt_info_wrunlock(cpu);
 	}
+	lockdep_on();
 	put_cpu();
 }
 
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index c439721..dc5b2fd 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -903,8 +903,10 @@ get_counters(const struct xt_table_info *t,
 	local_bh_enable();
 	/* Processing counters from other cpus, we can let bottom half enabled,
 	 * (preemption is disabled)
+	 * We must turn off lockdep to avoid a false positive.
 	 */
 
+	lockdep_off();
 	for_each_possible_cpu(cpu) {
 		if (cpu == curcpu)
 			continue;
@@ -917,6 +919,7 @@ get_counters(const struct xt_table_info *t,
 		}
 		xt_info_wrunlock(cpu);
 	}
+	lockdep_on();
 	put_cpu();
 }
 
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 5359ef4..fb55443 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -916,8 +916,10 @@ get_counters(const struct xt_table_info *t,
 	local_bh_enable();
 	/* Processing counters from other cpus, we can let bottom half enabled,
 	 * (preemption is disabled)
+	 * We must turn off lockdep to avoid a false positive.
 	 */
 
+	lockdep_off();
 	for_each_possible_cpu(cpu) {
 		if (cpu == curcpu)
 			continue;
@@ -930,6 +932,7 @@ get_counters(const struct xt_table_info *t,
 		}
 		xt_info_wrunlock(cpu);
 	}
+	lockdep_on();
 	put_cpu();
 }
 


