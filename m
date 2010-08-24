Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807Ab0HXMkn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 08:40:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:47615 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753184Ab0HXMkm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 08:40:42 -0400
Message-ID: <4C73BC96.6000003@kernel.org>
Date: Tue, 24 Aug 2010 14:35:34 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: workqueue destruction BUG_ON
References: <1282640156.3695.5.camel@jlt3.sipsolutions.net>	 <4C739DC6.1040309@kernel.org> <1282646268.3695.9.camel@jlt3.sipsolutions.net>
In-Reply-To: <1282646268.3695.9.camel@jlt3.sipsolutions.net>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 24 Aug 2010 12:40:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 08/24/2010 12:37 PM, Johannes Berg wrote:
> I think in my iwlwifi case it's actually destroying the iwlwifi
> workqueue (not sure why it even exists though).

Yeah, I'm planning on auditing each workqueue and remove unnecessary
ones.

>> I'll prep a debug patch to print out some details.
> 
> That'd be helpful, thanks!

Can you please apply the following patch and report the result?

Thanks.

>From 492a242b75b0abae3b1c17b4a654ab9ef67e612d Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Tue, 24 Aug 2010 14:22:47 +0200
Subject: [PATCH] workqueue: improve destroy_workqueue() debuggability

Now that the worklist is global, having works pending after wq
destruction can easily lead to oops and destroy_workqueue() have
several BUG_ON()s to catch these cases.  Unfortunately, BUG_ON()
doesn't tell much about how the work became pending after the final
flush_workqueue().

This patch adds WQ_DYING which is set before the final flush begins
and WARN_ON_ONCE() is triggered if a work is requested to be queued on
a dying workqueue and the request is ignored.  This clearly indicates
which caller is trying to queue a work on a dying workqueue and keeps
the system working in most cases.

Locking rule comment is updated such that the 'I' rule includes
modifying the field from destruction path.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/workqueue.h |    2 ++
 kernel/workqueue.c        |    7 ++++++-
 2 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 4f9d277..c959666 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -241,6 +241,8 @@ enum {
 	WQ_HIGHPRI		= 1 << 4, /* high priority */
 	WQ_CPU_INTENSIVE	= 1 << 5, /* cpu instensive workqueue */

+	WQ_DYING		= 1 << 6, /* internal: workqueue is dying */
+
 	WQ_MAX_ACTIVE		= 512,	  /* I like 512, better ideas? */
 	WQ_MAX_UNBOUND_PER_CPU	= 4,	  /* 4 * #cpus for unbound wq */
 	WQ_DFL_ACTIVE		= WQ_MAX_ACTIVE / 2,
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index cc3456f..362b50d 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -87,7 +87,8 @@ enum {
 /*
  * Structure fields follow one of the following exclusion rules.
  *
- * I: Set during initialization and read-only afterwards.
+ * I: Modifiable by initialization/destruction paths and read-only for
+ *    everyone else.
  *
  * P: Preemption protected.  Disabling preemption is enough and should
  *    only be modified and accessed from the local cpu.
@@ -944,6 +945,9 @@ static void __queue_work(unsigned int cpu, struct workqueue_struct *wq,

 	debug_work_activate(work);

+	if (WARN_ON_ONCE(wq->flags & WQ_DYING))
+		return;
+
 	/* determine gcwq to use */
 	if (!(wq->flags & WQ_UNBOUND)) {
 		struct global_cwq *last_gcwq;
@@ -2828,6 +2832,7 @@ void destroy_workqueue(struct workqueue_struct *wq)
 {
 	unsigned int cpu;

+	wq->flags |= WQ_DYING;
 	flush_workqueue(wq);

 	/*
-- 
1.7.1
