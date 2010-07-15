Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752626Ab0GOGuA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 02:50:00 -0400
Received: from mga01.intel.com ([192.55.52.88]:31545 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751663Ab0GOGt6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 02:49:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,206,1278313200"; 
   d="scan'208";a="818325321"
Subject: [PATCH] Don't apply for write lock on tasklist_lock if parent
 doesn't ptrace other processes
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, andi.kleen@intel.com
Content-Type: text/plain; charset="ISO-8859-1"
Date: Thu, 15 Jul 2010 14:51:03 +0800
Message-Id: <1279176663.2096.1264.camel@ymzhang.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We run some sub-cases (fork, exec, pipe, tcp, udp) of aim7 on 8-socket machine.
Perf shows write_lock_irq(&tasklist_lock) consumes more than 50% cpu time.

One hot caller is exit_ptrace. If the exiting process doesn't ptrace other
processes, kernel needn't apply for the write lock on tasklist_lock.

With below patch against kernel 2.6.35-rc5, we get more than 10% result improvement.

Signed-off-by: Zhang Yanmin <yanmin_zhang@linux.intel.com>

---

diff -Nraup linux-2.6.35-rc5/kernel/ptrace.c linux-2.6.35-rc5_ptrace/kernel/ptrace.c
--- linux-2.6.35-rc5/kernel/ptrace.c	2010-07-16 14:01:15.000000000 +0800
+++ linux-2.6.35-rc5_ptrace/kernel/ptrace.c	2010-07-16 14:03:20.000000000 +0800
@@ -331,6 +331,9 @@ void exit_ptrace(struct task_struct *tra
 	struct task_struct *p, *n;
 	LIST_HEAD(ptrace_dead);
 
+	if (list_empty(&tracer->ptraced))
+		return;
+
 	write_lock_irq(&tasklist_lock);
 	list_for_each_entry_safe(p, n, &tracer->ptraced, ptrace_entry) {
 		if (__ptrace_detach(tracer, p))


