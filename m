Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752887Ab1JHPz1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Oct 2011 11:55:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12829 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751296Ab1JHPz0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Oct 2011 11:55:26 -0400
Date: Sat, 8 Oct 2011 17:51:32 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
Cc: Tejun Heo <tj@kernel.org>, Mike Christie <michaelc@cs.wisc.edu>,
        Michael Chan <mchan@broadcom.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/11] Modified workqueue patches for your review
Message-ID: <20111008155132.GA28854@redhat.com>
References: <1314339850-32666-1-git-send-email-bprakash@broadcom.com> <20110826085457.GC2632@htj.dyndns.org> <4E58138A.5050702@broadcom.com> <4E8E378B.30907@broadcom.com> <20111007004824.GA5458@google.com> <4E8E5493.5010804@broadcom.com> <20111007145102.GA25449@redhat.com> <4E8F8C97.6010804@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E8F8C97.6010804@broadcom.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07, Bhanu Prakash Gollapudi wrote:
>
> On 10/7/2011 7:51 AM, Oleg Nesterov wrote:
>> On 10/06, Bhanu Prakash Gollapudi wrote:
>>>
>>> On 10/6/2011 5:48 PM, Tejun Heo wrote:
>>>>
>>>>> Reviewing the patch, I agree that we cannot rely on
>>>>> get_online_cpus() any longer.  But I'm also not convinced that
>>>>> cpu_add_remove_lock should be used instead, as it shows up some
>>>>> other deadlocks in destroy_workqueue context because of this global
>>>>> lock.
>>
>> Which deadlocks? work->func() must not use cpu_maps_update_begin/end
>> and thus it can't create/destroy !singlethread workqueue.
>
> Oleg, I attached the stack traces leading to deadlock in my previous
> email.

Yes, I didn't read it to the end... But you could save me some time and
explain ;)

OK. Afaics, it is easy to fix this particular problem... First of all,
scsi_host_dev_release() destroys the single-threaded wq. In this case
we do not actually need the locking/list_del, the code was written this
way just for consistency. See the patch below.

But, it seems, we could change scsi_host_dev_release() instead? It could
probably schedule_work() a work which actually does destroy_workqueue().
destroy/flush under the lock shared with work->func's is always dangerous.

> Based on Tejun's suggestion I sent a prototype patch that should fix the
> deadlock due to cpu_add_remove_lock, and avoid the race condition.  I'm
> yet to test it.

Doesn't look right...

But once again, I didn't see the whole discussion, I have no idea what
I have missed.

Oleg.


--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -930,14 +930,19 @@ void destroy_workqueue(struct workqueue_
 	const struct cpumask *cpu_map = wq_cpu_map(wq);
 	int cpu;
 
-	cpu_maps_update_begin();
-	spin_lock(&workqueue_lock);
-	list_del(&wq->list);
-	spin_unlock(&workqueue_lock);
-
-	for_each_cpu(cpu, cpu_map)
-		cleanup_workqueue_thread(per_cpu_ptr(wq->cpu_wq, cpu));
- 	cpu_maps_update_done();
+	if (is_wq_single_threaded(wq)) {
+		cleanup_workqueue_thread(per_cpu_ptr(wq->cpu_wq,
+						singlethread_cpu));
+	} else {
+		cpu_maps_update_begin();
+		spin_lock(&workqueue_lock);
+		list_del(&wq->list);
+		spin_unlock(&workqueue_lock);
+
+		for_each_cpu(cpu, cpu_map)
+			cleanup_workqueue_thread(per_cpu_ptr(wq->cpu_wq, cpu));
+		cpu_maps_update_done();
+ 	}
 
 	free_percpu(wq->cpu_wq);
 	kfree(wq);

