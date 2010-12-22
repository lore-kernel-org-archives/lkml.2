Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218Ab0LVAjd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 19:39:33 -0500
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:57305 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752471Ab0LVAjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 19:39:32 -0500
Subject: Re: [V2 PATCH] kthread_work: Make lockdep happy
From: Andy Walls <awalls@md.metrocast.net>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        nicolas.mailhot@laposte.net, Jarod Wilson <jarod@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20101221044050.GA25718@windriver.com>
References: <1292762975.2403.29.camel@localhost>
	 <AANLkTimYx2Og1BG37wb0WZ0_U8WJjLKHMKgU45qycUaM@mail.gmail.com>
	 <AANLkTikuKMLUoVnQsU6QNCnHBgOponJUngHGtyVHk1xK@mail.gmail.com>
	 <4D0F8276.9070903@kernel.org>  <20101221044050.GA25718@windriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 21 Dec 2010 19:39:53 -0500
Message-ID: <1292978393.2401.14.camel@morgan.silverblock.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.2.15,1.0.148,0.0.0000
 definitions=2010-12-21_09:2010-12-21,2010-12-21,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 suspectscore=0
 phishscore=0 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 engine=5.0.0-1010190000 definitions=main-1012210159
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-12-21 at 12:40 +0800, Yong Zhang wrote:
> From: Yong Zhang <yong.zhang0@gmail.com>
> Subject: [V2 PATCH] kthread_work: Make lockdep happy
> 
> spinlock in kthread_worker and wait_queue_head in kthread_work
> both should be lockdep sensible.
> So change the interface to make it suiltable for CONFIG_LOCKDEP.
> 
> Reported-by: Nicolas <nicolas.mailhot@laposte.net>
> Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Andy Walls <awalls@md.metrocast.net>
> ---
> Changes from V1:
>  *According to Tejun, kthread_worker could be defined on stack,
>   So introduce DEFINE_KTHREAD_WORKER_ONSTACK.
>  *Change wrong setting to kthread_work->task. Thanks Adny for
>   pointing it.
>  *including some minor issue.
> 
> BTW, only passed build.
> 
>  include/linux/kthread.h |   45 +++++++++++++++++++++++++++++++++++----------
>  kernel/kthread.c        |    9 +++++++++
>  2 files changed, 44 insertions(+), 10 deletions(-)

Yong,

I have tested your patch with the following patch on top of yours.  I
find the two patches together acceptable in testing in a machine with
both a PVR-350 card and a PVR-500 card installed.

Tested-by: Andy Walls <awalls@md.metrocast.net>
Signed-off-by: Andy Walls <awalls@md.metrocast.net>

Could you please author a [V3 PATCH] adding my changes?  Since the
majority of the change is your work, it should be attributed to you as
the author.


About my additional changes:

I needed the explicit EXPORT_SYMBOL_GPL(__init_kthread_worker),
otherwise the build would fail, because the ivtv module had an
unresolved symbol.

I added the lockdep class name to make it easier to identify the ivtv
module's kthread worker's lock class.  Now one can actually recognize
the lock class in lockdep output strings:

	# cat lockdep | grep itv
	ffffffffa0483a60 FD:    1 BD:    1 ......: (&itv->irq_worker)->lock

Thanks again.

Regards,
Andy


diff --git a/include/linux/kthread.h b/include/linux/kthread.h
index f8b3320..994564a 100644
--- a/include/linux/kthread.h
+++ b/include/linux/kthread.h
@@ -100,13 +100,15 @@ struct kthread_work {
 # define DEFINE_KTHREAD_WORK_ONSTACK(work, fn) DEFINE_KTHREAD_WORK(work, fn)
 #endif
 
-extern void __init_kthread_worker(struct kthread_worker *worker,
-					struct lock_class_key *key);
+void __init_kthread_worker(struct kthread_worker *worker,
+			   struct lock_class_key *key,
+			   const char *lock_class_name);
 
 #define init_kthread_worker(worker)					\
 	do {								\
 		static struct lock_class_key __key;			\
-		__init_kthread_worker((worker), &__key);		\
+		__init_kthread_worker((worker), &__key,			\
+				      "(" #worker ")->lock");		\
 	} while (0)
 
 #define init_kthread_work(work, fn)					\
diff --git a/kernel/kthread.c b/kernel/kthread.c
index f760587..4657ebd 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -266,13 +266,15 @@ int kthreadd(void *unused)
 }
 
 void __init_kthread_worker(struct kthread_worker *worker,
-				struct lock_class_key *key)
+			   struct lock_class_key *key,
+			   const char *lock_class_name)
 {
 	spin_lock_init(&worker->lock);
-	lockdep_set_class(&worker->lock, key);
+	lockdep_set_class_and_name(&worker->lock, key, lock_class_name);
 	INIT_LIST_HEAD(&worker->work_list);
 	worker->task = NULL;
 }
+EXPORT_SYMBOL_GPL(__init_kthread_worker);
 
 /**
  * kthread_worker_fn - kthread function to process kthread_worker


