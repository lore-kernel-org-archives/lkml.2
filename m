Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664Ab1EaJzx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 05:55:53 -0400
Received: from casper.infradead.org ([85.118.1.10]:57566 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596Ab1EaJzw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 05:55:52 -0400
Subject: Re: Very high CPU values in top on idle system (3.0-rc1)
From: Peter Zijlstra <peterz@infradead.org>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
        Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1306793579.2530.2.camel@twins>
References: <20110530173916.GA1746@x4.trippels.de>
	 <1306778743.23844.5.camel@twins> <20110530182356.GA1762@x4.trippels.de>
	 <20110530204548.GA1762@x4.trippels.de>  <1306793579.2530.2.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 31 May 2011 11:55:45 +0200
Message-ID: <1306835745.2353.3.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-31 at 00:12 +0200, Peter Zijlstra wrote:
> 
> I poked around with some skip_rq_update bits but couldn't make it go
> away, will try more tomorrow.

Gah, that was annoying, and explains why I wasn't seeing it on my main
dev box but could see it on my desktop (wsm tsc is much better synced
than the core2 tsc).

Could you confirm that this indeed cures the problem? I'll probably
commit a version without the toggle, but that was easy for verifying it
indeed made a difference..

---
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -2604,6 +2601,8 @@ static void ttwu_queue(struct task_struc
 
 #if defined(CONFIG_SMP)
 	if (sched_feat(TTWU_QUEUE) && cpu != smp_processor_id()) {
+		if (sched_feat(TTWU_SYNC_CLOCK))
+			sched_clock_cpu(cpu); /* sync clocks x-cpu */
 		ttwu_queue_remote(p, cpu);
 		return;
 	}
Index: linux-2.6/kernel/sched_features.h
===================================================================
--- linux-2.6.orig/kernel/sched_features.h
+++ linux-2.6/kernel/sched_features.h
@@ -70,3 +70,4 @@ SCHED_FEAT(NONIRQ_POWER, 1)
  * using the scheduler IPI. Reduces rq->lock contention/bounces.
  */
 SCHED_FEAT(TTWU_QUEUE, 1)
+SCHED_FEAT(TTWU_SYNC_CLOCK, 1)

