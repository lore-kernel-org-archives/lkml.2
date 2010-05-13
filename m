Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759128Ab0EMS0H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 14:26:07 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:37724 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755130Ab0EMS0E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 14:26:04 -0400
Date: Thu, 13 May 2010 11:25:56 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, fweisbec@gmail.com, a.p.zijlstra@chello.nl,
       paulus@samba.org, acme@redhat.com
Subject: [PATCH RFC] perf: fix find_swevent_head() RCU lockdep splat
Message-ID: <20100513182556.GA14326@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit guesses at the perf_cpu_context locking design and deploys
an rcu_dereference_check() accordingly.  The design appears to require
that a given CPU be accessing its own per_cpu_context or that it be
traversing under RCU protection.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>

 perf_event.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index a4fa381..002791c 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -4074,7 +4074,9 @@ find_swevent_head(struct perf_cpu_context *ctx, u64 type, u32 event_id)
 
 	hash = swevent_hash(type, event_id);
 
-	hlist = rcu_dereference(ctx->swevent_hlist);
+	hlist = rcu_dereference_check(ctx->swevent_hlist,
+				      rcu_read_lock_held() ||
+				      ctx == &__get_cpu_var(perf_cpu_context));
 	if (!hlist)
 		return NULL;
 
