Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440Ab1AKD6D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 22:58:03 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:42215 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755353Ab1AKD5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 22:57:22 -0500
X-Authority-Analysis: v=1.1 cv=dquaJDitHqzHCdqWSoZ6IgapSuTzW/4TaRYx9N9k4W8= c=1 sm=0 a=Qc2wOvdqbUsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=QGhqEVVczRNaYH_qOG0A:9 a=7GslqZvsTGayXhC8BcL__BaK9oIA:4 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110111035719.939086039@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 10 Jan 2011 22:53:57 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 2/5][RT] rtmutex: Try to take lock early in rt_spin_lock_slowlock()
References: <20110111035355.643480133@goodmis.org>
Content-Disposition: inline; filename=0002-rtmutex-Try-to-take-lock-early-in-rt_spin_lock_slowl.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Try to take the lock again as soon as we go into the
rt_spin_lock_slowlock() code before doing the setup and wait loop.
This makes the code closer to what the rt_mutex_slowlock() does,
which will help in simplifying this code in later commits.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/rtmutex.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/kernel/rtmutex.c b/kernel/rtmutex.c
index f0ce334..318d7ed 100644
--- a/kernel/rtmutex.c
+++ b/kernel/rtmutex.c
@@ -829,6 +829,11 @@ rt_spin_lock_slowlock(struct rt_mutex *lock)
 	raw_spin_lock_irqsave(&lock->wait_lock, flags);
 	init_lists(lock);
 
+	if (do_try_to_take_rt_mutex(lock, STEAL_LATERAL)) {
+		raw_spin_unlock_irqrestore(&lock->wait_lock, flags);
+		return;
+	}
+
 	BUG_ON(rt_mutex_owner(lock) == current);
 
 	/*
-- 
1.7.2.3


