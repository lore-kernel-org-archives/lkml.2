Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759430Ab0E0SEp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 14:04:45 -0400
Received: from mail-qy0-f183.google.com ([209.85.221.183]:61119 "EHLO
	mail-qy0-f183.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759377Ab0E0SEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 14:04:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:content-transfer-encoding:user-agent;
        b=xYgB/85Q8TisquXYsh0don7uVduPLxEQrTm1kR3QYUG21WVyyHiSSgsqIkk400mZes
         ndPHE6aFlk0IgUMXaB6x20vA3tthvBXdVHMBFK53+qT33Ufqsc/UuU2yazS2zeVgQBC7
         Osijse1hSckd1pCAKnGjtx0FdQgTn58Dk8Z9g=
Date: Thu, 27 May 2010 15:04:31 -0300
From: "Luis Claudio R. Goncalves" <lclaudio@uudg.org>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       David Rientjes <rientjes@google.com>, Oleg Nesterov <oleg@redhat.com>,
       Mel Gorman <mel@csn.ul.ie>, williams@redhat.com
Subject: [RFC] oom-kill: give the dying task a higher priority
Message-ID: <20100527180431.GP13035@uudg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Could you please review this patch?

The idea behind it is quite simple: give the dying task a higher priority
so that it can be scheduled sooner and die to free memory.


oom-kill: give the dying task a higher priority

In a system under heavy load it was observed that even after the
oom-killer selects a task to die, the task may take a long time to die.

Right before sending a SIGKILL to the selected task the oom-killer
increases the task priority so that it can exit quickly, freeing memory.
That is accomplished by:

        /*
         * We give our sacrificial lamb high priority and access to
         * all the memory it needs. That way it should be able to
         * exit() and clear out its resources quickly...
         */
 	p->rt.time_slice = HZ;
 	set_tsk_thread_flag(p, TIF_MEMDIE);

It sounds plausible giving the dying task an even higher priority to be
sure it will be scheduled sooner and free the desired memory.

Signed-off-by: Luis Claudio R. Gonçalves <lclaudio@uudg.org>

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index b68e802..8047309 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -382,6 +382,8 @@ static void dump_header(struct task_struct *p, gfp_t gfp_mask, int order,
  */
 static void __oom_kill_task(struct task_struct *p, int verbose)
 {
+	struct sched_param param;
+
 	if (is_global_init(p)) {
 		WARN_ON(1);
 		printk(KERN_WARNING "tried to kill init!\n");
@@ -413,6 +415,8 @@ static void __oom_kill_task(struct task_struct *p, int verbose)
 	 */
 	p->rt.time_slice = HZ;
 	set_tsk_thread_flag(p, TIF_MEMDIE);
+	param.sched_priority = MAX_RT_PRIO-1;
+	sched_setscheduler(p, SCHED_FIFO, &param);
 
 	force_sig(SIGKILL, p);
 }


Thanks,
Luis
-- 
[ Luis Claudio R. Goncalves                    Bass - Gospel - RT ]
[ Fingerprint: 4FDD B8C4 3C59 34BD 8BE9  2696 7203 D980 A448 C8F8 ]

