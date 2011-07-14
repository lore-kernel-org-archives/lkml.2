Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751043Ab1GNEfY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 00:35:24 -0400
Received: from ozlabs.org ([203.10.76.45]:42670 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750707Ab1GNEfX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 00:35:23 -0400
Date: Thu, 14 Jul 2011 14:35:21 +1000
From: Anton Blanchard <anton@samba.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: mahesh@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, mingo@elte.hu, benh@kernel.crashing.org,
        torvalds@linux-foundation.org
Subject: Re: [regression] 3.0-rc boot failure -- bisected to cd4ea6ae3982
Message-ID: <20110714143521.5fe4fab6@kryten>
In-Reply-To: <20110714103418.7ef25b68@kryten>
References: <20110707102107.GA16666@in.ibm.com>
	<1310036375.3282.509.camel@twins>
	<20110714103418.7ef25b68@kryten>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.4; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I took a quick look and we are stuck in update_group_power:
> 
>         do {
>                 power += group->cpu_power;
>                 group = group->next;
>         } while (group != child->groups);
> 
> I looked at the linked list:
> 
> child->groups = c000007b2f74ff00
> 
> and dumping group as we go:
> 
> c000007b2f74ff00 c000007b2f760000 c000007b2fb60000 c000007b2ff60000
> 
> at this point we end up in a cycle and never make it back to
> child->groups:
> 
> c000008b2e68ff00 c000008b2e6a0000 c000008b2eaa0000 c000008b2eea0000
> c000009aee77ff00 c000009aee790000 c000009aeeb90000 c000009aeef90000
> c00000bafde91800 c00000dafdf81800 c00000fafce81800 c000011afdf71800
> c00001226e70ff00 c00001226e720000 c00001226eb20000 c00001226ef20000
> c000008b2e68ff00

It looks like the group ends up in two lists. I added a BUG_ON to
ensure we never link a group twice, and it hits.

I also printed out the cpu spans as we walk through build_sched_groups:

0 1 2 3
0 4 8 12 16 20 24 28
0 32 64 96 128 160 192 224 256 288 320 352 384 416 448 480
0 128 256 384
4 5 6 7
8 9 10 11
12 13 14 15
16 17 18 19
20 21 22 23
24 25 26 27
28 29 30 31
32 33 34 35
32 36 40 44 48 52 56 60
36 37 38 39
40 41 42 43
44 45 46 47
48 49 50 51
52 53 54 55
56 57 58 59
60 61 62 63
64 65 66 67
64 68 72 76 80 84 88 92
68 69 70 71
72 73 74 75
76 77 78 79
80 81 82 83
84 85 86 87
88 89 90 91
92 93 94 95
96 97 98 99
96 100 104 108 112 116 120 124
100 101 102 103
104 105 106 107
108 109 110 111
112 113 114 115
116 117 118 119
120 121 122 123
124 125 126 127
128 129 130 131
128 132 136 140 144 148 152 156

Duplicates start appearing in this span:
128 160 192 224 256 288 320 352 384 416 448 480 512 544 576 608

So it looks like the overlap of the 16 entry spans
(SD_NODES_PER_DOMAIN) is causing our problem.

Anton

Index: linux-2.6-work/kernel/sched.c
===================================================================
--- linux-2.6-work.orig/kernel/sched.c	2011-07-11
12:48:48.251087767 +1000 +++ linux-2.6-work/kernel/sched.c
2011-07-14 14:19:45.867094044 +1000 @@ -7021,6 +7021,7 @@
build_sched_groups(struct sched_domain * 
 		cpumask_clear(sched_group_cpus(sg));
 		sg->cpu_power = 0;
+		BUG_ON(sg->next);
 
 		for_each_cpu(j, span) {
 			if (get_group(j, sdd, NULL) != group)


Anton
