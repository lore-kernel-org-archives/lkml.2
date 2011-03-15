Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752784Ab1CODNt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 23:13:49 -0400
Received: from smtp-out.google.com ([216.239.44.51]:7016 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181Ab1CODNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 23:13:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=CcTyKCRoBZL7WsfOMk/jLQvu5he/mXT8gbBUfCquBxHpPO5rAzYLWMpBSGoBm2cWxX
         0MZkJ9EIiUUBNaHIuKLQ==
Date: Mon, 14 Mar 2011 20:13:38 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Linux 2.6.38
In-Reply-To: <AANLkTi=_cZRNPU29+MJkt9u6zDSLo153CKqLqg1+t7O6@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1103142011550.16032@chino.kir.corp.google.com>
References: <AANLkTi=_cZRNPU29+MJkt9u6zDSLo153CKqLqg1+t7O6@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This kernel includes a broken commit that was merged a couple of hours 
before release:

commit dc1b83ab08f1954335692cdcd499f78c94f4c42a
Author: Oleg Nesterov <oleg@redhat.com>
Date:   Mon Mar 14 20:05:30 2011 +0100

    oom: oom_kill_process: fix the child_points logic
    
    oom_kill_process() starts with victim_points == 0.  This means that
    (most likely) any child has more points and can be killed erroneously.
    
    Also, "children has a different mm" doesn't match the reality, we should
    check child->mm != t->mm.  This check is not exactly correct if t->mm ==
    NULL but this doesn't really matter, oom_kill_task() will kill them
    anyway.
    
    Note: "Kill all processes sharing p->mm" in oom_kill_task() is wrong
    too.
    
    Signed-off-by: Oleg Nesterov <oleg@redhat.com>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

As a result of this change, the oom killer will no longer attempt to 
sacrifice a child of the selected process in favor of the parent unless 
its memory usage exceeds the parent (and this will be an unreachable state 
once oom-prevent-unnecessary-oom-kills-or-kernel-panics.patch is merged 
from -mm).

This means systems running a webserver, for example, will kill the 
webserver itself in oom conditions and not one of its threads serving a 
connection; simply forking too many client connections in this scenario 
would lead to an oom condition that would kill the server instead of one 
of its threads.

Admins who find this behavior to cause disruptions in service should apply 
the following revert.

Signed-off-by: David Rientjes <rientjes@google.com>
---
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -458,10 +458,10 @@ static int oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
 			    struct mem_cgroup *mem, nodemask_t *nodemask,
 			    const char *message)
 {
-	struct task_struct *victim;
+	struct task_struct *victim = p;
 	struct task_struct *child;
-	struct task_struct *t;
-	unsigned int victim_points;
+	struct task_struct *t = p;
+	unsigned int victim_points = 0;
 
 	if (printk_ratelimit())
 		dump_header(p, gfp_mask, order, mem, nodemask);
@@ -487,15 +487,10 @@ static int oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
 	 * parent.  This attempts to lose the minimal amount of work done while
 	 * still freeing memory.
 	 */
-	victim_points = oom_badness(p, mem, nodemask, totalpages);
-	victim = p;
-	t = p;
 	do {
 		list_for_each_entry(child, &t->children, sibling) {
 			unsigned int child_points;
 
-			if (child->mm == t->mm)
-				continue;
 			/*
 			 * oom_badness() returns 0 if the thread is unkillable
 			 */
