Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759384Ab1DNSqD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 14:46:03 -0400
Received: from mga03.intel.com ([143.182.124.21]:39341 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754071Ab1DNSp7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 14:45:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,212,1301900400"; 
   d="scan'208";a="419348232"
From: Darren Hart <dvhart@linux.intel.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Darren Hart <dvhart@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Eric Dumazet <eric.dumazet@gmail.com>, John Kacur <jkacur@redhat.com>
Subject: [PATCH V2] futex: set FLAGS_HAS_TIMEOUT during demux for FUTEX_WAIT
Date: Thu, 14 Apr 2011 11:45:42 -0700
Message-Id: <6aed1a53d080a90672bd44b773079dd81ac90b50.1302806742.git.dvhart@linux.intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1302800949.3248.42.camel@edumazet-laptop>
References: <1302800949.3248.42.camel@edumazet-laptop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The FLAGS_HAS_TIMEOUT flag was not getting set, causing the restart_block to
restart futex_wait() without a timeout after a signal.

Commit b41277dc7a18ee332d in 2.6.38 introduced the regression by accidentally
removing the the FLAGS_HAS_TIMEOUT assignment from futex_wait() during the setup
of the restart block. It makes more sense to set the flag earlier during
do_futex() where the other flags are set, although futex_wait is the only user
of FLAGS_HAS_TIMEOUT as it is the only op using a relative timeout (an
unfortunately preexisting condition).

Fixes: https://bugzilla.kernel.org/show_bug.cgi?id=32922

V2: Added references to commit message.

Signed-off-by: Darren Hart <dvhart@linux.intel.com>
Reported-by: Tim Smith <tsmith201104@yahoo.com>
Reported-by: Torsten Hilbrich <torsten.hilbrich@secunet.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>
CC: Eric Dumazet <eric.dumazet@gmail.com>
CC: John Kacur <jkacur@redhat.com>
---
 kernel/futex.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index bda4157..6eac6b6 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -2589,6 +2589,9 @@ long do_futex(u32 __user *uaddr, int op, u32 val, ktime_t *timeout,
 			return -ENOSYS;
 	}
 
+	if (timeout)
+		flags |= FLAGS_HAS_TIMEOUT;
+
 	switch (cmd) {
 	case FUTEX_WAIT:
 		val3 = FUTEX_BITSET_MATCH_ANY;
-- 
1.7.1

