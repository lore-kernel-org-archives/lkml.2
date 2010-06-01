Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755701Ab0FAJff (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 05:35:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:40207 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755593Ab0FAJfc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 05:35:32 -0400
Message-ID: <4C04D439.5070508@kernel.org>
Date: Tue, 01 Jun 2010 11:34:49 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Oleg Nesterov <oleg@redhat.com>, Sridhar Samudrala <sri@us.ibm.com>,
       netdev <netdev@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dmitri Vorobiev <dmitri.vorobiev@movial.com>,
       Jiri Kosina <jkosina@suse.cz>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 2/3] cgroups: Add an API to attach a task to current task's
 cgroup
References: <20100527163954.GA21710@redhat.com> <4BFEA434.6080405@kernel.org> <20100527173207.GA21880@redhat.com> <4BFEE216.2070807@kernel.org> <20100528150830.GB21880@redhat.com> <4BFFE742.2060205@kernel.org> <20100530112925.GB27611@redhat.com> <4C02C961.9050606@kernel.org> <20100531152221.GB2987@redhat.com> <4C03D983.9010905@kernel.org> <20100531160020.GC3067@redhat.com>
In-Reply-To: <20100531160020.GC3067@redhat.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 01 Jun 2010 09:34:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sridhar Samudrala <samudrala.sridhar@gmail.com>

Add a new kernel API to attach a task to current task's cgroup
in all the active hierarchies.

Signed-off-by: Sridhar Samudrala <sri@us.ibm.com>
Reviewed-by: Paul Menage <menage@google.com>
Acked-by: Li Zefan <lizf@cn.fujitsu.com>
---
 include/linux/cgroup.h |    1 +
 kernel/cgroup.c        |   23 +++++++++++++++++++++++
 2 files changed, 24 insertions(+)

Index: work/include/linux/cgroup.h
===================================================================
--- work.orig/include/linux/cgroup.h
+++ work/include/linux/cgroup.h
@@ -570,6 +570,7 @@ struct task_struct *cgroup_iter_next(str
 void cgroup_iter_end(struct cgroup *cgrp, struct cgroup_iter *it);
 int cgroup_scan_tasks(struct cgroup_scanner *scan);
 int cgroup_attach_task(struct cgroup *, struct task_struct *);
+int cgroup_attach_task_current_cg(struct task_struct *);

 /*
  * CSS ID is ID for cgroup_subsys_state structs under subsys. This only works
Index: work/kernel/cgroup.c
===================================================================
--- work.orig/kernel/cgroup.c
+++ work/kernel/cgroup.c
@@ -1788,6 +1788,29 @@ out:
 	return retval;
 }

+/**
+ * cgroup_attach_task_current_cg - attach task 'tsk' to current task's cgroup
+ * @tsk: the task to be attached
+ */
+int cgroup_attach_task_current_cg(struct task_struct *tsk)
+{
+	struct cgroupfs_root *root;
+	struct cgroup *cur_cg;
+	int retval = 0;
+
+	cgroup_lock();
+	for_each_active_root(root) {
+		cur_cg = task_cgroup_from_root(current, root);
+		retval = cgroup_attach_task(cur_cg, tsk);
+		if (retval)
+			break;
+	}
+	cgroup_unlock();
+
+	return retval;
+}
+EXPORT_SYMBOL_GPL(cgroup_attach_task_current_cg);
+
 /*
  * Attach task with pid 'pid' to cgroup 'cgrp'. Call with cgroup_mutex
  * held. May take task_lock of task
