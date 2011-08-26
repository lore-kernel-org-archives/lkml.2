Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753627Ab1HZMHo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 08:07:44 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52245 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540Ab1HZMHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 08:07:40 -0400
From: John Kacur <jkacur@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        rt-users <linux-rt-users@vger.kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        lkml <linux-kernel@vger.kernel.org>, John Kacur <jkacur@redhat.com>
Subject: [PATCH] PREEMPT_RT_FULL Build error fix
Date: Fri, 26 Aug 2011 14:06:33 +0200
Message-Id: <1314360393-13605-1-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.7.2.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Problem:
make O=/bld/3.0.3-rt11/ kernel/fork.o
/home/jkacur/jk-2.6/kernel/fork.c:91: error: section of ‘name’ conflicts with previous declaration

__cacheline_aligned is already part of the definition of DEFINE_RWLOCK
for -rt

However it is not always used for the tasklist_lock in non-rt, so it can't
simply be added to the definition of DEFINE_RWLOCK in non-rt, so I modified
the definition in fork.c

Signed-off-by: John Kacur
---
 kernel/fork.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index aa5fe26..0d264ec 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -87,7 +87,11 @@ int max_threads;		/* tunable limit on nr_threads */
 
 DEFINE_PER_CPU(unsigned long, process_counts) = 0;
 
+#ifndef CONFIG_PREEMPT_RT_FULL
 __cacheline_aligned DEFINE_RWLOCK(tasklist_lock);  /* outer */
+#else
+DEFINE_RWLOCK(tasklist_lock);  /* outer */
+#endif
 
 #ifdef CONFIG_PROVE_RCU
 int lockdep_tasklist_lock_is_held(void)
-- 
1.7.2.3

