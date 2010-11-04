Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752710Ab0KDTA6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 15:00:58 -0400
Received: from mga02.intel.com ([134.134.136.20]:59394 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752316Ab0KDTA5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 15:00:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,297,1286175600"; 
   d="scan'208";a="674390297"
From: Darren Hart <dvhart@linux.intel.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Darren Hart <dvhart@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Eric Dumazet <eric.dumazet@gmail.com>, John Kacur <jkacur@redhat.com>
Subject: [PATCH V2] futex: fix compiler warnings in exit_robust_list
Date: Thu,  4 Nov 2010 15:00:00 -0400
Message-Id: <1288897200-13008-1-git-send-email-dvhart@linux.intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20101104104912.GA27033@pengutronix.de>
References: <20101104104912.GA27033@pengutronix.de>
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

arm
arm-1136jfs-linux-gnueabi-gcc (OSELAS.Toolchain-1.99.3) 4.3.2

The code path really can't result in next_pi being unitialized (or should
not), but let's keep the build clean. Annotate next_pi as an uninitialized_var.

V2: Implement Uwe's suggestion to use uninitialized_var()

Signed-off-by: Darren Hart <dvhart@linux.intel.com>
Tested-by: Matt Fleming <matt@console-pimps.org>
Tested-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>
CC: Eric Dumazet <eric.dumazet@gmail.com>
CC: John Kacur <jkacur@redhat.com>
---
 kernel/futex.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 6c683b3..40a8777 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -2489,7 +2489,8 @@ void exit_robust_list(struct task_struct *curr)
 {
 	struct robust_list_head __user *head = curr->robust_list;
 	struct robust_list __user *entry, *next_entry, *pending;
-	unsigned int limit = ROBUST_LIST_LIMIT, pi, next_pi, pip;
+	unsigned int limit = ROBUST_LIST_LIMIT, pi, pip;
+	unsigned int uninitialized_var(next_pi);
 	unsigned long futex_offset;
 	int rc;
 
-- 
1.7.1

