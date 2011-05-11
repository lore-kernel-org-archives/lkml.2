Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756906Ab1EKQHB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:07:01 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:62176 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756865Ab1EKQG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:06:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=KYiXZII400JRFBy5Zs6xn/nAMFDnZd+DrI73OBCvt4OemTa6hMRL891apks8jSexW2
         vrAuY8qQBCTEbw9AHPqkz+slScTnCbm1hn/x7HU6VmQHZoB9mT4JeYkAoXCi2jPRGGjW
         SUb8S8ES9UocsB3DWAynBpwcWGoSD4mGN54XQ=
MIME-Version: 1.0
In-Reply-To: <1305016329.2914.22.camel@laptop>
References: <BANLkTi=qPWxRAa6+dT3ohEP6Z=0v+e4EXA@mail.gmail.com>
	<1305016329.2914.22.camel@laptop>
Date: Wed, 11 May 2011 21:26:35 +0800
Message-ID: <BANLkTin5iNMt2autv3TJpCvTQUoKsSzhTA@mail.gmail.com>
Subject: Re: [PATCH] sched: fix constructing the span cpu mask of sched domain
From: Hillf Danton <dhillf@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Yong Zhang <yong.zhang0@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 10, 2011 at 4:32 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> If you're interested in this area of the scheduler, you might want to
> have a poke at:
>
> http://marc.info/?l=linux-kernel&m=130218515520540
>
> That tries to rewrite the CONFIG_NUMA support for the sched_domain stuff
> to create domains based on the node_distance() to better reflect the
> actual machine topology.
>
> As stated, that patch is currently very broken, mostly because the
> topologies encountered don't map to non-overlapping trees. I've not yet
> come up with how to deal with that, but we sure need to do something
> like that, the current group 16 nodes and a group of all simply doesn't
> work well for today's machines now that NUMA is both common and the
> inter-node latencies are more relevant.
>

Hi Peter

Your work for rewriting NUMA support, published at
         http://marc.info/?l=linux-kernel&m=130218515520540
is patched by changing how level is computed and by changing how it is
used to build the mask.

When computing, some valid levels are lost in your work.

When building mask, nodes are selected only if they have same distance,
thus nodes of less distance are also masked out since the computation of
level now is tough.

Without MUNA hardware, I did not test the patch:(

Hillf
---

--- numa_by_peter.c	2011-05-11 20:22:10.000000000 +0800
+++ numa_by_hillf.c	2011-05-11 21:06:26.000000000 +0800
@@ -1,6 +1,5 @@
 static void sched_init_numa(void)
 {
-	int next_distance, curr_distance = node_distance(0, 0);
 	struct sched_domain_topology_level *tl;
 	int level = 0;
 	int i, j, k;
@@ -11,21 +10,34 @@ static void sched_init_numa(void)
 	if (!sched_domains_numa_distance)
 		return;

-	next_distance = curr_distance;
-	for (i = 0; i < nr_node_ids; i++) {
-		for (j = 0; j < nr_node_ids; j++) {
-			int distance = node_distance(0, j);
-			printk("distance(0,%d): %d\n", j, distance);
-			if (distance > curr_distance &&
-					(distance < next_distance ||
-					 next_distance == curr_distance))
-				next_distance = distance;
+	for (j = 0; j < nr_node_ids; j++) {
+		int distance = node_distance(0, j);
+		printk("distance(0,%d): %d\n", j, distance);
+		if (j == 0) {
+			sched_domains_numa_distance[j] = distance;
+			sched_domains_numa_levels = ++level;
+			continue;
 		}
-		if (next_distance != curr_distance) {
-			sched_domains_numa_distance[level++] = next_distance;
+		for (i = 0; i < level; i++) {
+			/* check if already exist */
+			if (distance == sched_domains_numa_distance[i])
+				goto next_node;
+			/* sort and insert it */
+			if (distance < sched_domains_numa_distance[i])
+				break;
+		}
+		if (i == level) {
+			sched_domains_numa_distance[level++] = distance;
 			sched_domains_numa_levels = level;
-			curr_distance = next_distance;
-		} else break;
+			continue;
+		}
+		for (k = level -1; k >= i; k--)
+			sched_domains_numa_distance[k+1] =
+			sched_domains_numa_distance[k];
+		sched_domains_numa_distance[i] = distance;
+		sched_domains_numa_levels = ++level;
+next_node:
+		;
 	}

 	sched_domains_numa_masks = kzalloc(sizeof(void *) * level, GFP_KERNEL);
@@ -44,8 +56,9 @@ static void sched_init_numa(void)
 			struct cpumask *mask =
 				per_cpu_ptr(sched_domains_numa_masks[i], j);

+			cpumask_clear(mask);
 			for (k = 0; k < nr_node_ids; k++) {
-				if (node_distance(cpu_to_node(j), k) >
+				if (node_distance(cpu_to_node(j), k) !=
 						sched_domains_numa_distance[i])
 					continue;
