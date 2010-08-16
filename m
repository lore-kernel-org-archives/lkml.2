Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755761Ab0HPSsN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 14:48:13 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:51880 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752372Ab0HPSsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 14:48:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ZH5c4aUC5QferxO7ewZc1Aty2AJM1oEsTOgYDEodOxk3uzHY1U046YTVTy5NHVLlWM
         oaUlDnZULyrrBhlHwB9JlUXuBL3F8zG7EVkGgOPgFALyKnuKJHt2W7GDo19BDyzOB4Gf
         dbTKtYJfhJGqk0lmvus5UuPp5WLu7wxPsYEck=
Subject: Re: [LOCKDEP BUG][2.6.36-rc1] xt_info_wrlock?
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Patrick McHardy <kaber@trash.net>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <1281982566.3268.137.camel@gandalf.stny.rr.com>
References: <1281978469.3268.55.camel@gandalf.stny.rr.com>
	 <1281979893.2524.54.camel@edumazet-laptop>
	 <1281981301.3268.110.camel@gandalf.stny.rr.com>
	 <1281982566.3268.137.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 Aug 2010 20:48:05 +0200
Message-ID: <1281984485.2487.24.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 16 août 2010 à 14:16 -0400, Steven Rostedt a écrit :

> We need a better comment than that. Could that be changed to something like:
> 
> 	/*
> 	 * lockdep tests if we grab a lock and can be preempted by 
> 	 * a softirq and that softirq grabs the same lock causing a
> 	 * deadlock.
> 	 * This is a special case because this is a per-cpu lock,
> 	 * and we are only grabbing the lock for other CPUs. A softirq
> 	 * will only takes its local CPU lock thus, if we are preempted
> 	 * by a softirq, then it will grab the current CPU lock which
> 	 * we do not take here.
> 	 *
> 	 * Simply disable lockdep here until it can handle this situation.
> 	 */
> 

You mean duplicating this long comment in three files, or only once in
Changelog ?

My choice was to document the lockdep_off() use (very seldom used in
kernel) in the Changelog. Hopefully, people messing with this code know
about git ;)

I agree I didnt document how netfilter locks work in this Changelog.

And in original commit (24b36f019) I forgot to state that get_counters()
is guarded by a mutex, so that no more than one cpu runs in
get_counters().

What about following ?

[PATCH] netfilter: {ip,ip6,arp}_tables: avoid lockdep false positive

After commit 24b36f019 (netfilter: {ip,ip6,arp}_tables: dont block
bottom half more than necessary), lockdep can raise a warning
because we attempt to lock a spinlock with BH enabled, while
the same lock is usually locked by another cpu in a softirq context.

In this use case, the lockdep splat is a false positive, because
the BH disabling only matters for one cpu and its associated.

1) We use one spinlock per cpu.

2) A softirq will only lock the lock associated to current cpu.

3) get_counters() disables sofirqs while fetching data of current cpu.
   (to avoid a deadlock if a softirq comes and try to lock same lock)

4) other locks are locked without blocking softirq
   (as a softirq will lock another lock)

5) get_counter() calls are serialized by a mutex.

   This to avoid a deadlock if two cpus were doing :

   CPU1          CPU2
lock lock#1      lock lock#2
copy data#1      copy data#2
unlock lock#1    unlock lock#2

lock#2           lock#1
softirq lock#1   softirq, attempt to lock lock#2
<deadlock>       <deadlock>

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
 


