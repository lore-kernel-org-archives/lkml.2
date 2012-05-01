Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757773Ab2EAQRg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 12:17:36 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47678 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928Ab2EAQRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 12:17:35 -0400
Date: Tue, 1 May 2012 09:17:29 -0700
From: Tejun Heo <tj@kernel.org>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sasha Levin <levinsasha928@gmail.com>
Subject: [PATCH v3.4-rc5] block: iocontext->nr_tasks should be initialized
 to one
Message-ID: <20120501161729.GV26595@google.com>
References: <1335873936.16988.148.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335873936.16988.148.camel@lappy>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

create_task_io_context() left ioc->nr_tasks at zero; however, a newly
created ioc should have its nr_tasks initialized to one as it begins
attached to the task creating it.

This affects only CLONE_IO which currently doesn't seem to have any
actual user.  Sasha triggered WARN_ON_ONCE() in ioc_task_link() using
syscall fuzzer.  Even when it happens, the failure mode isn't critical
(blk-cgroup may allow attaching a CLONE_IO'd task to a cgroup when it
shouldn't and blkcg limits may behave weirdly).

Fix it by initializing it to one in create_task_io_context().

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Sasha Levin <levinsasha928@gmail.com>
LKML-Reference: <1335873936.16988.148.camel@lappy>
Cc: stable@vger.kernel.org
---
 block/blk-ioc.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/block/blk-ioc.c b/block/blk-ioc.c
index 1e2d53b..c942409 100644
--- a/block/blk-ioc.c
+++ b/block/blk-ioc.c
@@ -244,6 +244,7 @@ int create_task_io_context(struct task_struct *task, gfp_t gfp_flags, int node)
 	/* initialize */
 	atomic_long_set(&ioc->refcount, 1);
 	atomic_set(&ioc->active_ref, 1);
+	atomic_set(&ioc->nr_tasks, 1);
 	spin_lock_init(&ioc->lock);
 	INIT_RADIX_TREE(&ioc->icq_tree, GFP_ATOMIC | __GFP_HIGH);
 	INIT_HLIST_HEAD(&ioc->icq_list);
