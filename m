Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904Ab0FAJgG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 05:36:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:59883 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754640Ab0FAJgB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 05:36:01 -0400
Message-ID: <4C04D453.9040208@kernel.org>
Date: Tue, 01 Jun 2010 11:35:15 +0200
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
Subject: [PATCH 3/3] vhost: apply cpumask and cgroup to vhost workers
References: <20100527163954.GA21710@redhat.com> <4BFEA434.6080405@kernel.org> <20100527173207.GA21880@redhat.com> <4BFEE216.2070807@kernel.org> <20100528150830.GB21880@redhat.com> <4BFFE742.2060205@kernel.org> <20100530112925.GB27611@redhat.com> <4C02C961.9050606@kernel.org> <20100531152221.GB2987@redhat.com> <4C03D983.9010905@kernel.org> <20100531160020.GC3067@redhat.com>
In-Reply-To: <20100531160020.GC3067@redhat.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 01 Jun 2010 09:35:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Apply the cpumask and cgroup of the initializing task to the created
vhost worker.

Based on Sridhar Samudrala's patch.  Li Zefan spotted a bug in error
path (twice), fixed (twice).

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Sridhar Samudrala <samudrala.sridhar@gmail.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
---
 drivers/vhost/vhost.c |   34 ++++++++++++++++++++++++++++++----
 1 file changed, 30 insertions(+), 4 deletions(-)

Index: work/drivers/vhost/vhost.c
===================================================================
--- work.orig/drivers/vhost/vhost.c
+++ work/drivers/vhost/vhost.c
@@ -23,6 +23,7 @@
 #include <linux/highmem.h>
 #include <linux/slab.h>
 #include <linux/kthread.h>
+#include <linux/cgroup.h>

 #include <linux/net.h>
 #include <linux/if_packet.h>
@@ -187,11 +188,29 @@ long vhost_dev_init(struct vhost_dev *de
 		    struct vhost_virtqueue *vqs, int nvqs)
 {
 	struct task_struct *worker;
-	int i;
+	cpumask_var_t mask;
+	int i, ret = -ENOMEM;
+
+	if (!alloc_cpumask_var(&mask, GFP_KERNEL))
+		goto out_free_mask;

 	worker = kthread_create(vhost_worker, dev, "vhost-%d", current->pid);
-	if (IS_ERR(worker))
-		return PTR_ERR(worker);
+	if (IS_ERR(worker)) {
+		ret = PTR_ERR(worker);
+		goto out_free_mask;
+	}
+
+	ret = sched_getaffinity(current->pid, mask);
+	if (ret)
+		goto out_stop_worker;
+
+	ret = sched_setaffinity(worker->pid, mask);
+	if (ret)
+		goto out_stop_worker;
+
+	ret = cgroup_attach_task_current_cg(worker);
+	if (ret)
+		goto out_stop_worker;

 	dev->vqs = vqs;
 	dev->nvqs = nvqs;
@@ -214,7 +233,14 @@ long vhost_dev_init(struct vhost_dev *de
 	}

 	wake_up_process(worker);	/* avoid contributing to loadavg */
-	return 0;
+	ret = 0;
+	goto out_free_mask;
+
+out_stop_worker:
+	kthread_stop(worker);
+out_free_mask:
+	free_cpumask_var(mask);
+	return ret;
 }

 /* Caller should have device mutex */
