Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755252Ab1IGRFR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 13:05:17 -0400
Received: from ozlabs.org ([203.10.76.45]:56420 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754851Ab1IGRFN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 13:05:13 -0400
Date: Wed, 7 Sep 2011 21:08:55 +1000
From: Anton Blanchard <anton@samba.org>
To: Theodore Tso <tytso@MIT.EDU>
Cc: Tejun Heo <tj@kernel.org>, Eric Dumazet <eric.dumazet@gmail.com>,
        adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] percpu_counter: Put a reasonable upper bound on
 percpu_counter_batch
Message-ID: <20110907210855.414d417e@kryten>
In-Reply-To: <EEB2FCE2-3C14-406E-BD0E-FD27D091C492@mit.edu>
References: <20110826072622.406d3395@kryten>
	<20110826072927.5b4781f9@kryten>
	<1314347983.2563.1.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	<20110829214609.495ee299@kryten>
	<20110906034851.GC18425@mtj.dyndns.org>
	<EEB2FCE2-3C14-406E-BD0E-FD27D091C492@mit.edu>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.4; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Ted,

> Um, this was an ext4 patch and I pointed out it could cause
> problems.  (Specifically, data loss…)

I'm a bit confused. While the comment mentions ext4, the patch is just
putting an upper bound on the size of percpu_counter_batch and it is
useful for percpu_counter_compare() too:

 static void compute_batch_value(void)
 {
        int nr = num_online_cpus();

-       percpu_counter_batch = max(32, nr*2);
+       /*
+        * The cutoff point for the percpu_counter_compare() fast path grows
+        * at num_online_cpus^2 and on a big enough machine it will be
+        * unlikely to hit.
+        * We clamp the batch value to 1024 so the cutoff point only grows
+        * linearly past 512 CPUs.
+        */
+       percpu_counter_batch = clamp(nr*2, 32, 1024);
 }

The batch value should be opaque to the rest of the kernel. If ext4
requires a specific batch value we can use the functions that take
an explicit one (eg __percpu_counter_add).

Anton
