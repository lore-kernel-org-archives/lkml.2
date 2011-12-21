Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180Ab1LUJvT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 04:51:19 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:52244 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440Ab1LUJvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 04:51:16 -0500
Message-ID: <1324461072.2728.19.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Subject: Re: Kernel-DOS error in arp mechanism =?UTF-8?Q?=E2=80=93?= no
 delete off incomplete arp adresses
From: Eric Dumazet <eric.dumazet@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: richard.weinberger@gmail.com, gladewitz@gmx.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Date: Wed, 21 Dec 2011 10:51:12 +0100
In-Reply-To: <20111221.030727.1528369698756365464.davem@davemloft.net>
References: <4EEC5286.3070408@gmx.de>
	 <CAFLxGvxjLCyMCPXtpm7a7RaOL4A4=bhCLPKD=FVAc8xOdx_CsQ@mail.gmail.com>
	 <1324453467.2610.20.camel@edumazet-laptop>
	 <20111221.030727.1528369698756365464.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 21 décembre 2011 à 03:07 -0500, David Miller a écrit :
> From: Eric Dumazet <eric.dumazet@gmail.com>
> Date: Wed, 21 Dec 2011 08:44:27 +0100
> 
> > David, I suggest we add back the garbage collector for current kernels,
> > we'll remove it when route cache really disappear ?
> > 
> > I'll send a patch today.
> 
> Yes, it's the best idea.
> 
> We can actually remove it again as early as when when route neigh's
> are ref-less.

Here is the patch I successfully tested in the neighbour stress
situation. This is a stable candidate (2.6.39+)

Thanks !

[PATCH] ipv4: reintroduce route cache garbage collector

Commit 2c8cec5c10b (ipv4: Cache learned PMTU information in inetpeer)
removed IP route cache garbage collector a bit too soon, as this gc was
responsible for expired routes cleanup, releasing their neighbour
reference.

As pointed out by Robert Gladewitz, recent kernels can fill and exhaust
their neighbour cache.

Reintroduce the garbage collection, since we'll have to wait our
neighbour lookups become refcount-less to not depend on this stuff.

Reported-by: Robert Gladewitz <gladewitz@gmx.de>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
---
 net/ipv4/route.c |  107 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 107 insertions(+)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 46af623..252c512 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -120,6 +120,7 @@
 
 static int ip_rt_max_size;
 static int ip_rt_gc_timeout __read_mostly	= RT_GC_TIMEOUT;
+static int ip_rt_gc_interval __read_mostly  = 60 * HZ;
 static int ip_rt_gc_min_interval __read_mostly	= HZ / 2;
 static int ip_rt_redirect_number __read_mostly	= 9;
 static int ip_rt_redirect_load __read_mostly	= HZ / 50;
@@ -133,6 +134,9 @@ static int ip_rt_min_advmss __read_mostly	= 256;
 static int rt_chain_length_max __read_mostly	= 20;
 static int redirect_genid;
 
+static struct delayed_work expires_work;
+static unsigned long expires_ljiffies;
+
 /*
  *	Interface to generic destination cache.
  */
@@ -830,6 +834,97 @@ static int has_noalias(const struct rtable *head, const struct rtable *rth)
 	return ONE;
 }
 
+static void rt_check_expire(void)
+{
+	static unsigned int rover;
+	unsigned int i = rover, goal;
+	struct rtable *rth;
+	struct rtable __rcu **rthp;
+	unsigned long samples = 0;
+	unsigned long sum = 0, sum2 = 0;
+	unsigned long delta;
+	u64 mult;
+
+	delta = jiffies - expires_ljiffies;
+	expires_ljiffies = jiffies;
+	mult = ((u64)delta) << rt_hash_log;
+	if (ip_rt_gc_timeout > 1)
+		do_div(mult, ip_rt_gc_timeout);
+	goal = (unsigned int)mult;
+	if (goal > rt_hash_mask)
+		goal = rt_hash_mask + 1;
+	for (; goal > 0; goal--) {
+		unsigned long tmo = ip_rt_gc_timeout;
+		unsigned long length;
+
+		i = (i + 1) & rt_hash_mask;
+		rthp = &rt_hash_table[i].chain;
+
+		if (need_resched())
+			cond_resched();
+
+		samples++;
+
+		if (rcu_dereference_raw(*rthp) == NULL)
+			continue;
+		length = 0;
+		spin_lock_bh(rt_hash_lock_addr(i));
+		while ((rth = rcu_dereference_protected(*rthp,
+					lockdep_is_held(rt_hash_lock_addr(i)))) != NULL) {
+			prefetch(rth->dst.rt_next);
+			if (rt_is_expired(rth)) {
+				*rthp = rth->dst.rt_next;
+				rt_free(rth);
+				continue;
+			}
+			if (rth->dst.expires) {
+				/* Entry is expired even if it is in use */
+				if (time_before_eq(jiffies, rth->dst.expires)) {
+nofree:
+					tmo >>= 1;
+					rthp = &rth->dst.rt_next;
+					/*
+					 * We only count entries on
+					 * a chain with equal hash inputs once
+					 * so that entries for different QOS
+					 * levels, and other non-hash input
+					 * attributes don't unfairly skew
+					 * the length computation
+					 */
+					length += has_noalias(rt_hash_table[i].chain, rth);
+					continue;
+				}
+			} else if (!rt_may_expire(rth, tmo, ip_rt_gc_timeout))
+				goto nofree;
+
+			/* Cleanup aged off entries. */
+			*rthp = rth->dst.rt_next;
+			rt_free(rth);
+		}
+		spin_unlock_bh(rt_hash_lock_addr(i));
+		sum += length;
+		sum2 += length*length;
+	}
+	if (samples) {
+		unsigned long avg = sum / samples;
+		unsigned long sd = int_sqrt(sum2 / samples - avg*avg);
+		rt_chain_length_max = max_t(unsigned long,
+					ip_rt_gc_elasticity,
+					(avg + 4*sd) >> FRACT_BITS);
+	}
+	rover = i;
+}
+
+/*
+ * rt_worker_func() is run in process context.
+ * we call rt_check_expire() to scan part of the hash table
+ */
+static void rt_worker_func(struct work_struct *work)
+{
+	rt_check_expire();
+	schedule_delayed_work(&expires_work, ip_rt_gc_interval);
+}
+
 /*
  * Perturbation of rt_genid by a small quantity [1..256]
  * Using 8 bits of shuffling ensure we can call rt_cache_invalidate()
@@ -3179,6 +3274,13 @@ static ctl_table ipv4_route_table[] = {
 		.proc_handler	= proc_dointvec_jiffies,
 	},
 	{
+		.procname	= "gc_interval",
+		.data		= &ip_rt_gc_interval,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_jiffies,
+	},
+	{
 		.procname	= "redirect_load",
 		.data		= &ip_rt_redirect_load,
 		.maxlen		= sizeof(int),
@@ -3388,6 +3490,11 @@ int __init ip_rt_init(void)
 	devinet_init();
 	ip_fib_init();
 
+	INIT_DELAYED_WORK_DEFERRABLE(&expires_work, rt_worker_func);
+	expires_ljiffies = jiffies;
+	schedule_delayed_work(&expires_work,
+		net_random() % ip_rt_gc_interval + ip_rt_gc_interval);
+
 	if (ip_rt_proc_init())
 		printk(KERN_ERR "Unable to create route proc files\n");
 #ifdef CONFIG_XFRM


