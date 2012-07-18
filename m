Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753091Ab2GRJlb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 05:41:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55593 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010Ab2GRJl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 05:41:28 -0400
Date: Wed, 18 Jul 2012 02:41:07 -0700
From: tip-bot for Dan Carpenter <dan.carpenter@oracle.com>
Message-ID: <tip-93574fcc5b50cc7b8834698acb2ce947e5b6a5dc@git.kernel.org>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, fweisbec@gmail.com, rostedt@goodmis.org,
        tglx@linutronix.de, dan.carpenter@oracle.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        mingo@redhat.com, fweisbec@gmail.com, rostedt@goodmis.org,
        tglx@linutronix.de, dan.carpenter@oracle.com
In-Reply-To: <20120711063507.GF11812@elgon.mountain>
References: <20120711063507.GF11812@elgon.mountain>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing:
  Check for allocation failure in __tracing_open()
Git-Commit-ID: 93574fcc5b50cc7b8834698acb2ce947e5b6a5dc
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 18 Jul 2012 02:41:14 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  93574fcc5b50cc7b8834698acb2ce947e5b6a5dc
Gitweb:     http://git.kernel.org/tip/93574fcc5b50cc7b8834698acb2ce947e5b6a5dc
Author:     Dan Carpenter <dan.carpenter@oracle.com>
AuthorDate: Wed, 11 Jul 2012 09:35:08 +0300
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Wed, 11 Jul 2012 19:56:26 -0400

tracing: Check for allocation failure in __tracing_open()

Clean up and return -ENOMEM on if the kzalloc() fails.

This also prevents a potential crash, as the pointer that failed to
allocate would be later used.

Link: http://lkml.kernel.org/r/20120711063507.GF11812@elgon.mountain

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 814ff30..a120f98 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2390,6 +2390,9 @@ __tracing_open(struct inode *inode, struct file *file)
 
 	iter->buffer_iter = kzalloc(sizeof(*iter->buffer_iter) * num_possible_cpus(),
 				    GFP_KERNEL);
+	if (!iter->buffer_iter)
+		goto release;
+
 	/*
 	 * We make a copy of the current tracer to avoid concurrent
 	 * changes on it while we are reading.
@@ -2451,6 +2454,7 @@ __tracing_open(struct inode *inode, struct file *file)
 	mutex_unlock(&trace_types_lock);
 	kfree(iter->trace);
 	kfree(iter->buffer_iter);
+release:
 	seq_release_private(inode, file);
 	return ERR_PTR(-ENOMEM);
 }
