Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756491Ab2HSDC6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 23:02:58 -0400
Received: from mga11.intel.com ([192.55.52.93]:44069 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753983Ab2HSC5p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 22:57:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,792,1336374000"; 
   d="scan'208";a="204911370"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, mmarek@suse.cz, linux-kbuild@vger.kernel.org,
        JBeulich@suse.com, akpm@linux-foundation.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 74/74] lto, workaround: Mark do_futex noinline to prevent clobbering ebp
Date: Sat, 18 Aug 2012 19:57:10 -0700
Message-Id: <1345345030-22211-75-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
References: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

On a 32bit build gcc 4.7 with LTO decides to clobber the 6th argument on the
stack.  Unfortunately this corrupts the user EBP and leads to later crashes.
For now mark do_futex noinline to prevent this.

I wish there was a generic way to handle this. Seems like a ticking time
bomb problem.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 kernel/futex.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 3717e7b..48b5a07 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -2620,7 +2620,7 @@ void exit_robust_list(struct task_struct *curr)
 				   curr, pip);
 }
 
-long do_futex(u32 __user *uaddr, int op, u32 val, ktime_t *timeout,
+noinline long do_futex(u32 __user *uaddr, int op, u32 val, ktime_t *timeout,
 		u32 __user *uaddr2, u32 val2, u32 val3)
 {
 	int cmd = op & FUTEX_CMD_MASK;
-- 
1.7.7.6

