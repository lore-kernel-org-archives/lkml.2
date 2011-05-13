Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759281Ab1EMNGF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 09:06:05 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47728 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759149Ab1EMNGD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 09:06:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=SBvYQmIX9lhCm9AxiNJSsgjeNjhYaadwS8rt8QUVth5R3zzBdh4c8koSssYrK7916G
         aYzET2VKJiZFVO1UoMuhHJnbxH5jNgSdZtbRhX+JXt4f3vRtf1QDcx+LPetOes+x1ry0
         EI3ndgXSh0x1DaDbUbP07ANSSzFbHomlhDtpo=
MIME-Version: 1.0
In-Reply-To: <1305122055.2914.220.camel@laptop>
References: <BANLkTi=qPWxRAa6+dT3ohEP6Z=0v+e4EXA@mail.gmail.com>
	<1305016329.2914.22.camel@laptop>
	<BANLkTin5iNMt2autv3TJpCvTQUoKsSzhTA@mail.gmail.com>
	<1305122055.2914.220.camel@laptop>
Date: Fri, 13 May 2011 21:06:01 +0800
Message-ID: <BANLkTinbZmE8=DE9q_QVQMKwG3h69cewng@mail.gmail.com>
Subject: Re: [PATCH] sched: fix constructing the span cpu mask of sched domain
From: Hillf Danton <dhillf@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Yong Zhang <yong.zhang0@gmail.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 11, 2011 at 9:54 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2011-05-11 at 21:26 +0800, Hillf Danton wrote:
>> Your work for rewriting NUMA support, published at
>>          http://marc.info/?l=linux-kernel&m=130218515520540
>> is patched by changing how level is computed and by changing how it is
>> used to build the mask.
>>
>> When computing, some valid levels are lost in your work.
>>
>> When building mask, nodes are selected only if they have same distance,
>> thus nodes of less distance are also masked out since the computation of
>> level now is tough.
>>
>> Without MUNA hardware, I did not test the patch:(
>
> I do have a (tiny) NUMA box (2 nodes) but that actually booted with the
> old code too, Andreas Hermann from AMD (CC'ed) is usually willing to
> test such patches on somewhat larger systems. Please send a full patch
> against tip/master for him to apply.
>
>

Hi Peter

In your original work, there is also a mismatch between how level is computed
and how it is used to build the cpu mask.

When computing level, distance is computed with node_distance(0, j),
instead of node_distance(i, j), and I do not think it is typo since the printk
also uses distance(0,%d).

When building cpu mask, however, distance is computed according to
for_each_possible_cpu(j) and node_distance(cpu_to_node(j), k).

Thus I concern there may be distances not covered by the level, see below.

If test result from Andreas is positive,
      I over concern,
else
      please take the mismatch into your consideration.


thanks
Hillf
---

--- numa_by_peter.c	2011-05-11 20:22:10.000000000 +0800
+++ numa_by_hillf.c	2011-05-13 20:36:46.000000000 +0800
@@ -1,6 +1,5 @@
 static void sched_init_numa(void)
 {
-	int next_distance, curr_distance = node_distance(0, 0);
 	struct sched_domain_topology_level *tl;
 	int level = 0;
 	int i, j, k;
@@ -11,21 +10,29 @@ static void sched_init_numa(void)
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
+		for (i = 0; i < level; i++) {
+			/* check if already exist */
+			if (distance == sched_domains_numa_distance[i])
+				goto next_node;
+			/* sort and insert it */
+			if (distance < sched_domains_numa_distance[i])
+				break;
 		}
-		if (next_distance != curr_distance) {
-			sched_domains_numa_distance[level++] = next_distance;
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
@@ -44,8 +51,9 @@ static void sched_init_numa(void)
 			struct cpumask *mask =
 				per_cpu_ptr(sched_domains_numa_masks[i], j);

+			cpumask_clear(mask);
 			for (k = 0; k < nr_node_ids; k++) {
-				if (node_distance(cpu_to_node(j), k) >
+				if (node_distance(cpu_to_node(j), k) !=
 						sched_domains_numa_distance[i])
 					continue;

@@ -57,6 +65,17 @@ static void sched_init_numa(void)
 		}
 	}

+	for (j = 0; j < nr_node_ids; j++)
+		for (k = 0; k < nr_node_ids; k++) {
+			int distance = node_distance(j, k);
+			for (i = 0; i < level; i++)
+				if (distance == sched_domains_numa_distance[i])
+					goto covered;
+			printk("distance(%d,%d): %d not covered by level\n",
+				j, k, distance);
+		covered:
+			;
+		}
 	tl = kzalloc((ARRAY_SIZE(default_topology) + level) *
 			sizeof(struct sched_domain_topology_level), GFP_KERNEL);
 	if (!tl)
