Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751882Ab1GOUUF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 16:20:05 -0400
Received: from mga01.intel.com ([192.55.52.88]:63718 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751041Ab1GOUUD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 16:20:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,210,1309762800"; 
   d="scan'208";a="30855193"
Subject: Re: rq_affinity doesn't seem to work?
From: Dan Williams <dan.j.williams@intel.com>
To: Roland Dreier <roland@purestorage.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Jens Axboe <axboe@kernel.dk>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Foong, Annie" <annie.foong@intel.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Nadolski, Edmund" <edmund.nadolski@intel.com>,
        "Skirvin, Jeffrey D" <jeffrey.d.skirvin@intel.com>
Date: Fri, 15 Jul 2011 13:20:02 -0700
In-Reply-To: <CAL1RGDUDbEG4ypr0GJLLi_0PTjZK0HshMVwTs=aY+=hhFdjK5g@mail.gmail.com>
References: <D010E79907AF0D4E90B603DE907837D504CA6365D6@azsmsx504.amr.corp.intel.com>
	 <4E1CAEEB.8050506@kernel.dk> <20110713171011.GA11864@parisc-linux.org>
	 <CAL1RGDUDbEG4ypr0GJLLi_0PTjZK0HshMVwTs=aY+=hhFdjK5g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1310761202.18112.6.camel@dwillia2-linux>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-07-14 at 10:02 -0700, Roland Dreier wrote:
> On Wed, Jul 13, 2011 at 10:10 AM, Matthew Wilcox <matthew@wil.cx> wrote:
> Limiting softirqs to 10% of a core seems a bit low, since we seem to
> be able to use more than 100% of a core handling block softirqs, and
> anyway magic numbers like that seem to always be wrong sometimes.
> Perhaps we could use the queue length on the destination CPU as a
> proxy for how busy ksoftirq is?

This is likely too aggressive (untested / need to confirm it resolves
the isci issue), but it's at least straightforward to determine, and I
wonder if it prevents the regression Matthew is seeing.  It assumes that
the once we have naturally spilled from the irq return path to ksoftirqd
that this cpu is having trouble keeping up with the load.

??

diff --git a/block/blk-core.c b/block/blk-core.c
index d2f8f40..9c7ba87 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1279,10 +1279,8 @@ get_rq:
 	init_request_from_bio(req, bio);
 
 	if (test_bit(QUEUE_FLAG_SAME_COMP, &q->queue_flags) ||
-	    bio_flagged(bio, BIO_CPU_AFFINE)) {
-		req->cpu = blk_cpu_to_group(get_cpu());
-		put_cpu();
-	}
+	    bio_flagged(bio, BIO_CPU_AFFINE))
+		req->cpu = smp_processor_id();
 
 	plug = current->plug;
 	if (plug) {
diff --git a/block/blk-softirq.c b/block/blk-softirq.c
index ee9c216..720918f 100644
--- a/block/blk-softirq.c
+++ b/block/blk-softirq.c
@@ -101,17 +101,21 @@ static struct notifier_block __cpuinitdata blk_cpu_notifier = {
 	.notifier_call	= blk_cpu_notify,
 };
 
+DECLARE_PER_CPU(struct task_struct *, ksoftirqd);
+
 void __blk_complete_request(struct request *req)
 {
+	int ccpu, cpu, group_ccpu, group_cpu;
 	struct request_queue *q = req->q;
+	struct task_struct *tsk;
 	unsigned long flags;
-	int ccpu, cpu, group_cpu;
 
 	BUG_ON(!q->softirq_done_fn);
 
 	local_irq_save(flags);
 	cpu = smp_processor_id();
 	group_cpu = blk_cpu_to_group(cpu);
+	tsk = per_cpu(ksoftirqd, cpu);
 
 	/*
 	 * Select completion CPU
@@ -120,8 +124,15 @@ void __blk_complete_request(struct request *req)
 		ccpu = req->cpu;
 	else
 		ccpu = cpu;
+	group_ccpu = blk_cpu_to_group(ccpu);
 
-	if (ccpu == cpu || ccpu == group_cpu) {
+	/*
+	 * try to skip a remote softirq-trigger if the completion is
+	 * within the same group, but not if local softirqs have already
+	 * spilled to ksoftirqd
+	 */
+	if (ccpu == cpu ||
+	    (group_ccpu == group_cpu && tsk->state != TASK_RUNNING)) {
 		struct list_head *list;
 do_local:
 		list = &__get_cpu_var(blk_cpu_done);





