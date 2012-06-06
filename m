Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752493Ab2FFEAY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 00:00:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:16197 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515Ab2FFEAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 00:00:20 -0400
X-Authority-Analysis: v=2.0 cv=NbpkJh/4 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=9EbIeKX3vQwA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=oGMlB6cnAAAA:8 a=VnNF1IyMAAAA:8 a=Z4Rwk6OoAAAA:8 a=pGLkceISAAAA:8 a=3nbZYyFuAAAA:8 a=PgWMebuInx1RzEPmWVUA:9 a=jEp0ucaQiEUA:10 a=Zh68SRI7RUMA:10 a=CY6gl2JlH4YA:10 a=jbrJJM5MRmoA:10 a=MSl-tDqOz04A:10 a=EvKJbDF4Ut8A:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120606040015.114545378@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 05 Jun 2012 23:51:06 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        "Frank Ch. Eigler" <fche@redhat.com>
Subject: [RFC][PATCH 08/12] kprobes: Inverse taking of module_mutex with kprobe_mutex
References: <20120606035058.108720095@goodmis.org>
Content-Disposition: inline; filename=0008-kprobes-Inverse-taking-of-module_mutex-with-kprobe_m.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Currently module_mutex is taken before kprobe_mutex, but this
can cause issues when we have kprobes register ftrace, as the ftrace
mutex is taken before enabling a tracepoint, which currently takes
the module mutex.

If module_mutex is taken before kprobe_mutex, then we can not
have kprobes use the ftrace infrastructure.

There seems to be no reason that the kprobe_mutex can't be taken
before the module_mutex. Running lockdep shows that it is safe
among the kernels I've run.

Link: http://lkml.kernel.org/r/20120605102814.27845.21047.stgit@localhost.localdomain

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/kprobes.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index c62b854..7a8a122 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -561,9 +561,9 @@ static __kprobes void kprobe_optimizer(struct work_struct *work)
 {
 	LIST_HEAD(free_list);
 
+	mutex_lock(&kprobe_mutex);
 	/* Lock modules while optimizing kprobes */
 	mutex_lock(&module_mutex);
-	mutex_lock(&kprobe_mutex);
 
 	/*
 	 * Step 1: Unoptimize kprobes and collect cleaned (unused and disarmed)
@@ -586,8 +586,8 @@ static __kprobes void kprobe_optimizer(struct work_struct *work)
 	/* Step 4: Free cleaned kprobes after quiesence period */
 	do_free_cleaned_kprobes(&free_list);
 
-	mutex_unlock(&kprobe_mutex);
 	mutex_unlock(&module_mutex);
+	mutex_unlock(&kprobe_mutex);
 
 	/* Step 5: Kick optimizer again if needed */
 	if (!list_empty(&optimizing_list) || !list_empty(&unoptimizing_list))
-- 
1.7.10


