Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752297Ab0KWKX1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 05:23:27 -0500
Received: from hera.kernel.org ([140.211.167.34]:48440 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751199Ab0KWKXZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 05:23:25 -0500
Date: Tue, 23 Nov 2010 10:22:54 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, oleg@redhat.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, oleg@redhat.com,
        mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] cpu: Remove incorrect BUG_ON
Message-ID: <tip-51a96c77815e7f139892a6e9c8275a50e9baebdf@git.kernel.org>
Git-Commit-ID: 51a96c77815e7f139892a6e9c8275a50e9baebdf
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 23 Nov 2010 10:22:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  51a96c77815e7f139892a6e9c8275a50e9baebdf
Gitweb:     http://git.kernel.org/tip/51a96c77815e7f139892a6e9c8275a50e9baebdf
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 19 Nov 2010 20:37:53 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 23 Nov 2010 10:29:08 +0100

cpu: Remove incorrect BUG_ON

Oleg mentioned that there is no actual guarantee the dying cpu's
migration thread is actually finished running when we get there, so
replace the BUG_ON() with a spinloop waiting for it.

Reported-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/cpu.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/kernel/cpu.c b/kernel/cpu.c
index 3945066..cb7a1ef 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -249,8 +249,11 @@ static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
 	 * The migration_call() CPU_DYING callback will have removed all
 	 * runnable tasks from the cpu, there's only the idle task left now
 	 * that the migration thread is done doing the stop_machine thing.
+	 *
+	 * Wait for the stop thread to go away.
 	 */
-	BUG_ON(!idle_cpu(cpu));
+	while (!idle_cpu(cpu))
+		cpu_relax();
 
 	/* This actually kills the CPU. */
 	__cpu_die(cpu);
