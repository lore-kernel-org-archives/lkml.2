Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932593Ab0J0Vyz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 17:54:55 -0400
Received: from mga14.intel.com ([143.182.124.37]:46930 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757406Ab0J0Vyv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 17:54:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,248,1286175600"; 
   d="scan'208";a="341327220"
From: Darren Hart <dvhart@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Matt Fleming <matt@console-pimps.org>, tglx@linutronix.de,
        peterz@infradead.org, mingo@elte.hu, eric.dumazet@gmail.com,
        jkacur@redhat.com, Darren Hart <dvhart@linux.intel.com>
Subject: [PATCH 1/3] futex: fix compiler warnings in exit_robust_list
Date: Wed, 27 Oct 2010 14:54:24 -0700
Message-Id: <1288216466-14309-2-git-send-email-dvhart@linux.intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1288216466-14309-1-git-send-email-dvhart@linux.intel.com>
References: <1288216466-14309-1-git-send-email-dvhart@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following commit introduced a compiler warning:

Commit 1dcc41bb037533839753df983d31778b30b67d93
futex: Change 3rd arg of fetch_robust_entry() to unsigned int*

The following archs/compiler versions all report:
kernel/futex.c: In function ‘exit_robust_list’:
kernel/futex.c:2492: warning: ‘next_pi’ may be used uninitialized in this function

x86_64
gcc (Ubuntu 4.4.3-4ubuntu5) 4.4.3
gcc (GCC) 4.4.4 20100630 (Red Hat 4.4.4-10)
gcc (Ubuntu/Linaro 4.4.4-14ubuntu5) 4.4.5

sh
sh-linux-gnu-gcc (Sourcery G++ Lite 4.3-143) 4.3.3

The code path really can't result in next_pi pi being unitialized (or should
not), but let's keep the build clean. Assign next_pi = 0 to avoid the warnings.

Signed-off-by: Darren Hart <dvhart@linux.intel.com>
Tested-by: Matt Fleming <matt@console-pimps.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>
CC: Eric Dumazet <eric.dumazet@gmail.com>
CC: John Kacur <jkacur@redhat.com>
---
 kernel/futex.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index a118bf1..78715cb 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -2489,7 +2489,7 @@ void exit_robust_list(struct task_struct *curr)
 {
 	struct robust_list_head __user *head = curr->robust_list;
 	struct robust_list __user *entry, *next_entry, *pending;
-	unsigned int limit = ROBUST_LIST_LIMIT, pi, next_pi, pip;
+	unsigned int limit = ROBUST_LIST_LIMIT, pi, next_pi = 0, pip;
 	unsigned long futex_offset;
 	int rc;
 
-- 
1.7.1

