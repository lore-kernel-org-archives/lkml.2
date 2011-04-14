Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752255Ab1DNUjv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 16:39:51 -0400
Received: from mga02.intel.com ([134.134.136.20]:56002 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751152Ab1DNUjv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 16:39:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,213,1301900400"; 
   d="scan'208";a="733494176"
From: Darren Hart <dvhart@linux.intel.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Linux Stable <stable@kernel.org>, Darren Hart <dvhart@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Eric Dumazet <eric.dumazet@gmail.com>, John Kacur <jkacur@redhat.com>
Subject: [PATCH V3] futex: set FLAGS_HAS_TIMEOUT during demux for FUTEX_WAIT
Date: Thu, 14 Apr 2011 13:39:40 -0700
Message-Id: <58437d290f34f93366114d6ffb7703330477d1e2.1302813580.git.dvhart@linux.intel.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The FLAGS_HAS_TIMEOUT flag was not getting set, causing the restart_block to
restart futex_wait() without a timeout after a signal.

Commit b41277dc7a18ee332d in 2.6.38 introduced the regression by accidentally
removing the the FLAGS_HAS_TIMEOUT assignment from futex_wait() during the setup
of the restart block. Restore the originaly behavior.

Fixes: https://bugzilla.kernel.org/show_bug.cgi?id=32922

V2: Added references to commit message.
V3: Set flag during restart block instead of do_futex()

Signed-off-by: Darren Hart <dvhart@linux.intel.com>
Reported-by: Tim Smith <tsmith201104@yahoo.com>
Reported-by: Torsten Hilbrich <torsten.hilbrich@secunet.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>
CC: Eric Dumazet <eric.dumazet@gmail.com>
CC: John Kacur <jkacur@redhat.com>
---
 kernel/futex.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index bda4157..9d9c476 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1887,6 +1887,7 @@ retry:
 	restart->futex.time = abs_time->tv64;
 	restart->futex.bitset = bitset;
 	restart->futex.flags = flags;
+	flags |= FLAGS_HAS_TIMEOUT;
 
 	ret = -ERESTART_RESTARTBLOCK;
 
-- 
1.7.1

