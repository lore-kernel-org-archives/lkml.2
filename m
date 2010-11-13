Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757694Ab0KMArN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 19:47:13 -0500
Received: from smtp-out.google.com ([74.125.121.35]:51205 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753239Ab0KMArL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 19:47:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-operating-system
         :user-agent;
        b=w8oYaKIq8vFnUnCKOQ6/vJNtTj/5+s4D9u58xMK/VOoDxjZx3LBDaccYHqU0jEzy3j
         JxkT4/LDT6aTSWvnrjQw==
Date: Fri, 12 Nov 2010 16:46:57 -0800
From: Mandeep Singh Baines <msb@google.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Ying Han <yinghan@google.com>,
        linux-kernel@vger.kernel.org, gspencer@chromium.org,
        piman@chromium.org, wad@chromium.org, olofj@chromium.org,
        Bodo Eggert <7eggert@web.de>
Subject: [PATCH] oom: allow a non-CAP_SYS_RESOURCE proces to oom_score_adj
 down
Message-ID: <20101113004657.GN7363@google.com>
References: <20101111043541.GA4588@google.com>
 <alpine.DEB.2.00.1011102328080.7571@chino.kir.corp.google.com>
 <20101111183050.GI7363@google.com>
 <alpine.DEB.2.00.1011111241450.25829@chino.kir.corp.google.com>
 <20101111222509.GJ7363@google.com>
 <alpine.DEB.2.00.1011111511570.3775@chino.kir.corp.google.com>
 <20101111235620.GK7363@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101111235620.GK7363@google.com>
X-Operating-System: Linux/2.6.32-gg252-generic (x86_64)
User-Agent: Mutt/1.5.20 (2009-06-14)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We'd like to be able to oom_score_adj a process up/down as its
enters/leaves the foreground. Currently, it is not possible to oom_adj
down without CAP_SYS_RESOURCE. This patch allows a task to decrease
its oom_score_adj back to the value that a CAP_SYS_RESOURCE thread set
it or its inherited value at fork. Assuming the thread that has forked
it has oom_score_adj of 0, each tab could decrease it back from 0 upon
activation unless a CAP_SYS_RESOURCE thread elevated it to something
higher.

Alternative considered:

* a setuid binary
* a daemon with CAP_SYS_RESOURCE

Since you don't wan't all processes to be able to reduce their
oom_adj, a setuid or daemon implementation would be complex. The
alternatives also have much higher overhead.

This patch updated based on feedback from
David Rientjes <rientjes@google.com>.

Change-Id: If8f52363fd6c156e1730f43148aee987260e9c72
Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
---
 fs/proc/base.c        |    4 +++-
 include/linux/sched.h |    2 ++
 2 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index f3d02ca..e617413 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1164,7 +1164,7 @@ static ssize_t oom_score_adj_write(struct file *file, const char __user *buf,
 		goto err_task_lock;
 	}
 
-	if (oom_score_adj < task->signal->oom_score_adj &&
+	if (oom_score_adj < task->signal->oom_score_adj_min &&
 			!capable(CAP_SYS_RESOURCE)) {
 		err = -EACCES;
 		goto err_sighand;
@@ -1177,6 +1177,8 @@ static ssize_t oom_score_adj_write(struct file *file, const char __user *buf,
 			atomic_dec(&task->mm->oom_disable_count);
 	}
 	task->signal->oom_score_adj = oom_score_adj;
+	if (capable(CAP_SYS_RESOURCE))
+		task->signal->oom_score_adj_min = oom_score_adj;
 	/*
 	 * Scale /proc/pid/oom_adj appropriately ensuring that OOM_DISABLE is
 	 * always attainable.
diff --git a/include/linux/sched.h b/include/linux/sched.h
index f53cdf2..2a71ee0 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -626,6 +626,8 @@ struct signal_struct {
 
 	int oom_adj;		/* OOM kill score adjustment (bit shift) */
 	int oom_score_adj;	/* OOM kill score adjustment */
+	int oom_score_adj_min;	/* OOM kill score adjustment minimum value.
+				 * Only settable by CAP_SYS_RESOURCE. */
 
 	struct mutex cred_guard_mutex;	/* guard against foreign influences on
 					 * credential calculations
-- 
1.7.3.1

