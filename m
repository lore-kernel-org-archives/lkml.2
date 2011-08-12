Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754683Ab1HNQJ6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 12:09:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36871 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754660Ab1HNQJx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 12:09:53 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 12 14:05:58 2011
Message-Id: <20110812210558.696017700@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 12 Aug 2011 14:05:00 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "David S. Miller" <davem@davemloft.net>
Subject: [75/90] sparc: Size mondo queues more sanely.
In-Reply-To: <20110812210626.GA4725@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------


From: "David S. Miller" <davem@davemloft.net>

[ Upstream commit 961f65fc41cdc1f9099a6075258816c0db98e390 ]

There is currently no upper limit on the mondo queue sizes we'll use,
which guarentees that we'll eventually his page allocation limits, and
thus allocation failures, due to MAX_ORDER.

Cap the sizes sanely, current limits are:

CPU  MONDO	2 * max_possible_cpus
DEV  MONDO	256 (basically NR_IRQS)
RES  MONDO	128
NRES MONDO	4

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/sparc/kernel/mdesc.c |   30 +++++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)

--- a/arch/sparc/kernel/mdesc.c
+++ b/arch/sparc/kernel/mdesc.c
@@ -508,6 +508,8 @@ const char *mdesc_node_name(struct mdesc
 }
 EXPORT_SYMBOL(mdesc_node_name);
 
+static u64 max_cpus = 64;
+
 static void __init report_platform_properties(void)
 {
 	struct mdesc_handle *hp = mdesc_grab();
@@ -543,8 +545,10 @@ static void __init report_platform_prope
 	if (v)
 		printk("PLATFORM: watchdog-max-timeout [%llu ms]\n", *v);
 	v = mdesc_get_property(hp, pn, "max-cpus", NULL);
-	if (v)
-		printk("PLATFORM: max-cpus [%llu]\n", *v);
+	if (v) {
+		max_cpus = *v;
+		printk("PLATFORM: max-cpus [%llu]\n", max_cpus);
+	}
 
 #ifdef CONFIG_SMP
 	{
@@ -715,7 +719,7 @@ static void __cpuinit set_proc_ids(struc
 }
 
 static void __cpuinit get_one_mondo_bits(const u64 *p, unsigned int *mask,
-					 unsigned char def)
+					 unsigned long def, unsigned long max)
 {
 	u64 val;
 
@@ -726,6 +730,9 @@ static void __cpuinit get_one_mondo_bits
 	if (!val || val >= 64)
 		goto use_default;
 
+	if (val > max)
+		val = max;
+
 	*mask = ((1U << val) * 64U) - 1U;
 	return;
 
@@ -736,19 +743,28 @@ use_default:
 static void __cpuinit get_mondo_data(struct mdesc_handle *hp, u64 mp,
 				     struct trap_per_cpu *tb)
 {
+	static int printed;
 	const u64 *val;
 
 	val = mdesc_get_property(hp, mp, "q-cpu-mondo-#bits", NULL);
-	get_one_mondo_bits(val, &tb->cpu_mondo_qmask, 7);
+	get_one_mondo_bits(val, &tb->cpu_mondo_qmask, 7, ilog2(max_cpus * 2));
 
 	val = mdesc_get_property(hp, mp, "q-dev-mondo-#bits", NULL);
-	get_one_mondo_bits(val, &tb->dev_mondo_qmask, 7);
+	get_one_mondo_bits(val, &tb->dev_mondo_qmask, 7, 8);
 
 	val = mdesc_get_property(hp, mp, "q-resumable-#bits", NULL);
-	get_one_mondo_bits(val, &tb->resum_qmask, 6);
+	get_one_mondo_bits(val, &tb->resum_qmask, 6, 7);
 
 	val = mdesc_get_property(hp, mp, "q-nonresumable-#bits", NULL);
-	get_one_mondo_bits(val, &tb->nonresum_qmask, 2);
+	get_one_mondo_bits(val, &tb->nonresum_qmask, 2, 2);
+	if (!printed++) {
+		pr_info("SUN4V: Mondo queue sizes "
+			"[cpu(%u) dev(%u) r(%u) nr(%u)]\n",
+			tb->cpu_mondo_qmask + 1,
+			tb->dev_mondo_qmask + 1,
+			tb->resum_qmask + 1,
+			tb->nonresum_qmask + 1);
+	}
 }
 
 static void * __cpuinit mdesc_iterate_over_cpus(void *(*func)(struct mdesc_handle *, u64, int, void *), void *arg, cpumask_t *mask)


