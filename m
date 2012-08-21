Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754343Ab2HUPK0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 11:10:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59411 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726Ab2HUPKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 11:10:20 -0400
Date: Tue, 21 Aug 2012 08:09:58 -0700
From: tip-bot for Steven Rostedt <srostedt@redhat.com>
Message-ID: <tip-72ef3794c5cd5f5f0e6355c24a529224c449cd14@git.kernel.org>
Cc: fche@redhat.com, mingo@redhat.com, linux-kernel@vger.kernel.org,
        hpa@zytor.com, mingo@kernel.org, ananth@in.ibm.com,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com,
        rostedt@goodmis.org, akpm@linux-foundation.org, srostedt@redhat.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        mingo@redhat.com, fche@redhat.com, ananth@in.ibm.com,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com,
        akpm@linux-foundation.org, rostedt@goodmis.org, srostedt@redhat.com,
        tglx@linutronix.de
In-Reply-To: <20120605102814.27845.21047.stgit@localhost.localdomain>
References: <20120605102814.27845.21047.stgit@localhost.localdomain>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] kprobes:
  Inverse taking of module_mutex with kprobe_mutex
Git-Commit-ID: 72ef3794c5cd5f5f0e6355c24a529224c449cd14
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 21 Aug 2012 08:10:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  72ef3794c5cd5f5f0e6355c24a529224c449cd14
Gitweb:     http://git.kernel.org/tip/72ef3794c5cd5f5f0e6355c24a529224c449cd14
Author:     Steven Rostedt <srostedt@redhat.com>
AuthorDate: Tue, 5 Jun 2012 19:28:14 +0900
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Tue, 31 Jul 2012 10:29:55 -0400

kprobes: Inverse taking of module_mutex with kprobe_mutex

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
 1 files changed, 2 insertions(+), 2 deletions(-)

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
