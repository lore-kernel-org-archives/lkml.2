Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753024Ab2B0KpF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 05:45:05 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:48684 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752474Ab2B0KpD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 05:45:03 -0500
Date: Mon, 27 Feb 2012 11:44:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Namhyung Kim <namhyung.kim@lge.com>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] hw breakpoint: Fix possible memory leak
Message-ID: <20120227104452.GA6082@elte.hu>
References: <1330311739-24302-1-git-send-email-namhyung.kim@lge.com>
 <1330338785.11248.49.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330338785.11248.49.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Mon, 2012-02-27 at 12:02 +0900, Namhyung Kim wrote:
> > If kzalloc() for TYPE_DATA failed on a given cpu, previous chunk
> > will be leaked. Fix it.
> 
> so why not fix the error loop? wouldn't putting that err_cpu == cpu
> break after the kfree sort it?

I edited that code earlier today - is the form below OK, or can 
you see a simpler method? It's not yet pushed out so can still 
edit it.

Thanks,

	Ingo

>From f019669c93da6c2094326d07735320d3bf223ffe Mon Sep 17 00:00:00 2001
From: Namhyung Kim <namhyung.kim@lge.com>
Date: Mon, 27 Feb 2012 12:02:19 +0900
Subject: [PATCH] hw breakpoints: Fix possible memory leak

If kzalloc() for TYPE_DATA failed on a given cpu, previous chunk
will be leaked. Fix it.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Link: http://lkml.kernel.org/r/1330311739-24302-1-git-send-email-namhyung.kim@lge.com
[ rearranged the code to have a clearer flow ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/events/hw_breakpoint.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/events/hw_breakpoint.c b/kernel/events/hw_breakpoint.c
index b7971d6..867032d 100644
--- a/kernel/events/hw_breakpoint.c
+++ b/kernel/events/hw_breakpoint.c
@@ -636,10 +636,9 @@ int __init init_hw_breakpoint(void)
 	for_each_possible_cpu(cpu) {
 		for (i = 0; i < TYPE_MAX; i++) {
 			task_bp_pinned = &per_cpu(nr_task_bp_pinned[i], cpu);
-			*task_bp_pinned = kzalloc(sizeof(int) * nr_slots[i],
-						  GFP_KERNEL);
+			*task_bp_pinned = kzalloc(sizeof(int) * nr_slots[i], GFP_KERNEL);
 			if (!*task_bp_pinned)
-				goto err_alloc;
+				goto err_alloc_pinned;
 		}
 	}
 
@@ -649,6 +648,9 @@ int __init init_hw_breakpoint(void)
 
 	return register_die_notifier(&hw_breakpoint_exceptions_nb);
 
+ err_alloc_pinned:
+	while (--i >= 0)
+		kfree(per_cpu(nr_task_bp_pinned[i], cpu));
  err_alloc:
 	for_each_possible_cpu(err_cpu) {
 		if (err_cpu == cpu)
