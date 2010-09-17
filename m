Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755680Ab0IQCsi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 22:48:38 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41806 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755567Ab0IQCsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 22:48:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=woeUrk13292z7aWZSXnFek54ODcHCJ1Auggomz1bNBG6knae64ETjzb66qqRW5VM8u
         J2Iq88jSQumkz7WFFPxpTcNe34wq7/hsYxYyajoMPEcpo7W2Nr6Oq/CIekDVDi1wCS7p
         g/ab2BvJBULq43dil3MwUS8dwAo3THUKd+zmk=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Matt Helsley <matthltc@us.ibm.com>,
        Robin Green <greenrd@greenrd.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Prasad <prasad@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Will Deacon <will.deacon@arm.com>,
        Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>,
        "2.6.33-2.6.35" <stable@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 2/2] hw breakpoints: Fix pid namespace bug
Date: Fri, 17 Sep 2010 04:48:22 +0200
Message-Id: <1284691702-32269-3-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1284691702-32269-1-git-send-regression-fweisbec@gmail.com>
References: <1284691702-32269-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Helsley <matthltc@us.ibm.com>

Hardware breakpoints can't be registered within pid namespaces
because tsk->pid is passed rather than the pid in the current
namespace.

(See https://bugzilla.kernel.org/show_bug.cgi?id=17281 )

This is a quick fix demonstrating the problem but is not the
best method of solving the problem since passing pids internally
is not the best way to avoid pid namespace bugs. Subsequent patches
will show a better solution.

Much thanks to Frederic Weisbecker <fweisbec@gmail.com> for doing
the bulk of the work finding this bug.

Reported-by: Robin Green <greenrd@greenrd.org>
Signed-off-by: Matt Helsley <matthltc@us.ibm.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Prasad <prasad@linux.vnet.ibm.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
Cc: 2.6.33-2.6.35 <stable@kernel.org>
LKML-Reference: <f63454af09fb1915717251570423eb9ddd338340.1284407762.git.matthltc@us.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/hw_breakpoint.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/hw_breakpoint.c b/kernel/hw_breakpoint.c
index d71a987..c7c2aed 100644
--- a/kernel/hw_breakpoint.c
+++ b/kernel/hw_breakpoint.c
@@ -433,7 +433,8 @@ register_user_hw_breakpoint(struct perf_event_attr *attr,
 			    perf_overflow_handler_t triggered,
 			    struct task_struct *tsk)
 {
-	return perf_event_create_kernel_counter(attr, -1, tsk->pid, triggered);
+	return perf_event_create_kernel_counter(attr, -1, task_pid_vnr(tsk),
+						triggered);
 }
 EXPORT_SYMBOL_GPL(register_user_hw_breakpoint);
 
-- 
1.6.2.3

