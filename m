Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817Ab1LFSMG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 13:12:06 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:35764 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752601Ab1LFSME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 13:12:04 -0500
Message-ID: <4EDE5AE1.2080607@linux.vnet.ibm.com>
Date: Tue, 06 Dec 2011 23:41:45 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: rjw@sisk.pl, pavel@ucw.cz, len.brown@intel.com, tj@kernel.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH 1/2] PM / Freezer: Remove the "userspace only"	constraint
 from freezer[_do_not]_count()
References: <20111206160251.16729.62719.stgit@srivatsabhat.in.ibm.com> <20111206172020.GA709@redhat.com>
In-Reply-To: <20111206172020.GA709@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 11120608-7014-0000-0000-000000381327
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2011 10:50 PM, Oleg Nesterov wrote:

> On 12/06, Srivatsa S. Bhat wrote:
>>
>> And moreover, even the vfork issue does not need
>> the above restriction in these functions, since they are anyway called by
>> userspace processes.
> 
> This looks a bit confusing, as if CLONE_VFORK is not used by kthreads.
> It is actually used, but only by the non-freezeable workqueue threads,
> so the patch is fine.
> 
> Reviewed-by: Oleg Nesterov <oleg@redhat.com>
> 


Thank you! I have updated the commit message by omitting the confusing part:

---
From: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
[PATCH 1/2] PM / Freezer: Remove the "userspace only" constraint from freezer[_do_not]_count()

At present, the functions freezer_count() and freezer_do_not_count()
impose the restriction that they are effective only for userspace processes.
However, now, these functions have found more utility than originally
intended by the commit which introduced it: ba96a0c8 (freezer:
fix vfork problem). And moreover, even the vfork issue actually does not
need the above restriction in these functions.

So, modify these functions to make them work even for kernel threads, so
that they can be used at other places in the kernel, where the userspace
restriction doesn't apply.

Suggested-by: Oleg Nesterov <oleg@redhat.com>
Suggested-by: Tejun Heo <tj@kernel.org>
Acked-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 include/linux/freezer.h |   28 +++++++++++-----------------
 1 files changed, 11 insertions(+), 17 deletions(-)

diff --git a/include/linux/freezer.h b/include/linux/freezer.h
index 30f06c2..7bcfe73 100644
--- a/include/linux/freezer.h
+++ b/include/linux/freezer.h
@@ -67,33 +67,27 @@ static inline bool cgroup_freezing(struct task_struct *task)
  * appropriately in case the child has exited before the freezing of tasks is
  * complete.  However, we don't want kernel threads to be frozen in unexpected
  * places, so we allow them to block freeze_processes() instead or to set
- * PF_NOFREEZE if needed and PF_FREEZER_SKIP is only set for userland vfork
- * parents.  Fortunately, in the ____call_usermodehelper() case the parent won't
- * really block freeze_processes(), since ____call_usermodehelper() (the child)
- * does a little before exec/exit and it can't be frozen before waking up the
- * parent.
+ * PF_NOFREEZE if needed. Fortunately, in the ____call_usermodehelper() case the
+ * parent won't really block freeze_processes(), since ____call_usermodehelper()
+ * (the child) does a little before exec/exit and it can't be frozen before
+ * waking up the parent.
  */
 
-/*
- * If the current task is a user space one, tell the freezer not to count it as
- * freezable.
- */
+
+/* Tell the freezer not to count the current task as freezable. */
 static inline void freezer_do_not_count(void)
 {
-	if (current->mm)
-		current->flags |= PF_FREEZER_SKIP;
+	current->flags |= PF_FREEZER_SKIP;
 }
 
 /*
- * If the current task is a user space one, tell the freezer to count it as
- * freezable again and try to freeze it.
+ * Tell the freezer to count the current task as freezable again and try to
+ * freeze it.
  */
 static inline void freezer_count(void)
 {
-	if (current->mm) {
-		current->flags &= ~PF_FREEZER_SKIP;
-		try_to_freeze();
-	}
+	current->flags &= ~PF_FREEZER_SKIP;
+	try_to_freeze();
 }
 
 /*


