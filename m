Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631Ab2L1T6v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:58:51 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54887 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754236Ab2L1TQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:16:52 -0500
Message-Id: <20121228190332.337998711@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:03:41 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tejun Heo <tj@kernel.org>, Xiaotian Feng <xtfeng@gmail.com>,
        Shuah Khan <shuah.khan@hp.com>
Subject: [ 011/173] workqueue: convert BUG_ON()s in __queue_delayed_work() to
 WARN_ON_ONCE()s
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

commit fc4b514f2727f74a4587c31db87e0e93465518c3 upstream.

8852aac25e ("workqueue: mod_delayed_work_on() shouldn't queue timer on
0 delay") unexpectedly uncovered a very nasty abuse of delayed_work in
megaraid - it allocated work_struct, casted it to delayed_work and
then pass that into queue_delayed_work().

Previously, this was okay because 0 @delay short-circuited to
queue_work() before doing anything with delayed_work.  8852aac25e
moved 0 @delay test into __queue_delayed_work() after sanity check on
delayed_work making megaraid trigger BUG_ON().

Although megaraid is already fixed by c1d390d8e6 ("megaraid: fix
BUG_ON() from incorrect use of delayed work"), this patch converts
BUG_ON()s in __queue_delayed_work() to WARN_ON_ONCE()s so that such
abusers, if there are more, trigger warning but don't crash the
machine.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Xiaotian Feng <xtfeng@gmail.com>
[Shuah Khan: This change is back-ported from upstream change that
 converted BUG_ON()s in __queue_delayed_work() to WARN_ON_ONCE()s.]
Tested on Stable Trees: 3.0.x, 3.4.x, 3.6.x
Signed-off-by: Shuah Khan <shuah.khan@hp.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/workqueue.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1146,8 +1146,8 @@ int queue_delayed_work_on(int cpu, struc
 	if (!test_and_set_bit(WORK_STRUCT_PENDING_BIT, work_data_bits(work))) {
 		unsigned int lcpu;
 
-		BUG_ON(timer_pending(timer));
-		BUG_ON(!list_empty(&work->entry));
+		WARN_ON_ONCE(timer_pending(timer));
+		WARN_ON_ONCE(!list_empty(&work->entry));
 
 		timer_stats_timer_set_start_info(&dwork->timer);
 


