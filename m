Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756107Ab2GKGf1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 02:35:27 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:18851 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752806Ab2GKGfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 02:35:24 -0400
Date: Wed, 11 Jul 2012 09:35:08 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] tracing: check for allocation failure
Message-ID: <20120711063507.GF11812@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clean up and return -ENOMEM on if the kzalloc() fails.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

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
