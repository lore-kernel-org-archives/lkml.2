Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754497Ab1DNWx7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 18:53:59 -0400
Received: from mga09.intel.com ([134.134.136.24]:64444 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753956Ab1DNWx6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 18:53:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,214,1301900400"; 
   d="scan'208";a="733541754"
From: Darren Hart <dvhart@linux.intel.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Darren Hart <dvhart@linux.intel.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        John Kacur <jkacur@redhat.com>, stable@kernel.org
Subject: [PATCH V5] futex: set FLAGS_HAS_TIMEOUT during futex_wait restart setup
Date: Thu, 14 Apr 2011 15:41:57 -0700
Message-Id: <daac0eb3af607f72b9a4d3126b2ba8fb5ed3b883.1302820917.git.dvhart@linux.intel.com>
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
V4: Correct stupid order of assignment mistake pointed out by Eric
V5: Correct subject to match implementation, correct stable submission

Signed-off-by: Darren Hart <dvhart@linux.intel.com>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Reported-by: Tim Smith <tsmith201104@yahoo.com>
Reported-by: Torsten Hilbrich <torsten.hilbrich@secunet.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: John Kacur <jkacur@redhat.com>
Cc: stable@kernel.org
---
 kernel/futex.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index bda4157..abd5324 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1886,7 +1886,7 @@ retry:
 	restart->futex.val = val;
 	restart->futex.time = abs_time->tv64;
 	restart->futex.bitset = bitset;
-	restart->futex.flags = flags;
+	restart->futex.flags = flags | FLAGS_HAS_TIMEOUT;
 
 	ret = -ERESTART_RESTARTBLOCK;
 
-- 
1.7.1

