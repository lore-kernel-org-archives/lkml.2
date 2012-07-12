Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030725Ab2GLQYJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 12:24:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22196 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933647Ab2GLQYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 12:24:07 -0400
X-Authority-Analysis: v=2.0 cv=ZuBv2qHG c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=staRmkZhtn8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=pGLkceISAAAA:8 a=20KFwNOVAAAA:8 a=nG6809EUImIk0zy38VsA:9 a=PUjeQqilurYA:10 a=7DSvI1NPTFQA:10 a=MSl-tDqOz04A:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1342110245.14868.7.camel@gandalf.stny.rr.com>
Subject: [GIT PULL][v3.6] tracing: Check for allocation failure in
 __tracing_open()
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Date: Thu, 12 Jul 2012 12:24:05 -0400
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Dan found a bug that is in the queue for 3.6. Please add this for the
3.6 queue.

Thanks,

Steve

Please pull the latest tip/perf/core tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
tip/perf/core

Head SHA1: 93574fcc5b50cc7b8834698acb2ce947e5b6a5dc


Dan Carpenter (1):
      tracing: Check for allocation failure in __tracing_open()

----
 kernel/trace/trace.c |    4 ++++
 1 file changed, 4 insertions(+)
---------------------------
commit 93574fcc5b50cc7b8834698acb2ce947e5b6a5dc
Author: Dan Carpenter <dan.carpenter@oracle.com>
Date:   Wed Jul 11 09:35:08 2012 +0300

    tracing: Check for allocation failure in __tracing_open()
    
    Clean up and return -ENOMEM on if the kzalloc() fails.
    
    This also prevents a potential crash, as the pointer that failed to
    allocate would be later used.
    
    Link: http://lkml.kernel.org/r/20120711063507.GF11812@elgon.mountain
    
    Cc: Frederic Weisbecker <fweisbec@gmail.com>
    Cc: Ingo Molnar <mingo@redhat.com>
    Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

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


