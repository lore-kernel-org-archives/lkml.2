Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361Ab1H2LqU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 07:46:20 -0400
Received: from ozlabs.org ([203.10.76.45]:34008 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753276Ab1H2LqN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 07:46:13 -0400
Date: Mon, 29 Aug 2011 21:46:09 +1000
From: Anton Blanchard <anton@samba.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, tj@kernel.org,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] percpu_counter: Put a reasonable upper bound on
 percpu_counter_batch
Message-ID: <20110829214609.495ee299@kryten>
In-Reply-To: <1314347983.2563.1.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
References: <20110826072622.406d3395@kryten>
	<20110826072927.5b4781f9@kryten>
	<1314347983.2563.1.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.4; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When testing on a 1024 thread ppc64 box I noticed a large amount of
CPU time in ext4 code.

ext4_has_free_blocks has a fast path to avoid summing every free and
dirty block per cpu counter, but only if the global count shows more
free blocks than the maximum amount that could be stored in all the
per cpu counters.

Since percpu_counter_batch scales with num_online_cpus() and the maximum
amount in all per cpu counters is percpu_counter_batch * num_online_cpus(),
this breakpoint grows at O(n^2).

This issue will also hit with users of percpu_counter_compare which
does a similar thing for one percpu counter.

I chose to cap percpu_counter_batch at 1024 as a conservative first
step, but we may want to reduce it further based on further benchmarking.

Signed-off-by: Anton Blanchard <anton@samba.org>
---

Index: linux-2.6-work/lib/percpu_counter.c
===================================================================
--- linux-2.6-work.orig/lib/percpu_counter.c	2011-08-29 19:50:44.482008591 +1000
+++ linux-2.6-work/lib/percpu_counter.c	2011-08-29 21:21:10.026779139 +1000
@@ -153,7 +153,14 @@ static void compute_batch_value(void)
 {
 	int nr = num_online_cpus();
 
-	percpu_counter_batch = max(32, nr*2);
+	/*
+	 * The cutoff point for the percpu_counter_compare() fast path grows
+	 * at num_online_cpus^2 and on a big enough machine it will be
+	 * unlikely to hit.
+	 * We clamp the batch value to 1024 so the cutoff point only grows
+	 * linearly past 512 CPUs.
+	 */
+	percpu_counter_batch = clamp(nr*2, 32, 1024);
 }
 
 static int __cpuinit percpu_counter_hotcpu_callback(struct notifier_block *nb,
