Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756919Ab2LNW0l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 17:26:41 -0500
Received: from mail.kernel.org ([198.145.19.201]:38050 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756888Ab2LNW0j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 17:26:39 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Tejun Heo <tj@kernel.org>, Xiaotian Feng <xtfeng@gmail.com>,
        Shuah Khan <shuah.khan@hp.com>
Subject: [ 03/22] workqueue: convert BUG_ON()s in __queue_delayed_work() to WARN_ON_ONCE()s
Date: Fri, 14 Dec 2012 14:25:48 -0800
Message-Id: <20121214222250.541693497@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20121214222249.889051473@linuxfoundation.org>
References: <20121214222249.889051473@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Shuah Khan <shuah.khan@hp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/workqueue.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1145,8 +1145,8 @@ int queue_delayed_work_on(int cpu, struc
 	if (!test_and_set_bit(WORK_STRUCT_PENDING_BIT, work_data_bits(work))) {
 		unsigned int lcpu;
 
-		BUG_ON(timer_pending(timer));
-		BUG_ON(!list_empty(&work->entry));
+		WARN_ON_ONCE(timer_pending(timer));
+		WARN_ON_ONCE(!list_empty(&work->entry));
 
 		timer_stats_timer_set_start_info(&dwork->timer);
 


