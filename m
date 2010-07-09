Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480Ab0GIWda (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 18:33:30 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:53879 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755297Ab0GIWd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 18:33:28 -0400
From: Darren Hart <dvhltc@us.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <eric.dumazet@gmail.com>, John Kacur <jkacur@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Mike Galbraith <efault@gmx.de>,
       linux-rt-users@vger.kernel.org, Darren Hart <dvhltc@us.ibm.com>
Subject: [PATCH 1/4] rtmutex: avoid null derefence in WARN_ON
Date: Fri,  9 Jul 2010 15:32:57 -0700
Message-Id: <1278714780-788-2-git-send-email-dvhltc@us.ibm.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1278714780-788-1-git-send-email-dvhltc@us.ibm.com>
References: <1278714780-788-1-git-send-email-dvhltc@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the pi_blocked_on variable is NULL, the subsequent WARN_ON's
will cause an OOPS. Only perform the susequent checks if
pi_blocked_on is valid.

Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: John Kacur <jkacur@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Mike Galbraith <efault@gmx.de>
---
 kernel/rtmutex.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/rtmutex.c b/kernel/rtmutex.c
index 23dd443..baac7d9 100644
--- a/kernel/rtmutex.c
+++ b/kernel/rtmutex.c
@@ -579,9 +579,10 @@ static void wakeup_next_waiter(struct rt_mutex *lock, int savestate)
 
 	raw_spin_lock(&pendowner->pi_lock);
 
-	WARN_ON(!pendowner->pi_blocked_on);
-	WARN_ON(pendowner->pi_blocked_on != waiter);
-	WARN_ON(pendowner->pi_blocked_on->lock != lock);
+	if (!WARN_ON(!pendowner->pi_blocked_on)) {
+		WARN_ON(pendowner->pi_blocked_on != waiter);
+		WARN_ON(pendowner->pi_blocked_on->lock != lock);
+	}
 
 	pendowner->pi_blocked_on = NULL;
 
-- 
1.7.0.4

