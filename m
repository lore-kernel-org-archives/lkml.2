Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932560Ab0JRTRY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 15:17:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:59312 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932134Ab0JRTRX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 15:17:23 -0400
Date: Mon, 18 Oct 2010 19:16:49 GMT
From: tip-bot for Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        linus.walleij@stericsson.com, a.p.zijlstra@chello.nl,
        lennart@poettering.net, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, a.p.zijlstra@chello.nl,
        lennart@poettering.net, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1286807811-10568-1-git-send-email-linus.walleij@stericsson.com>
References: <1286807811-10568-1-git-send-email-linus.walleij@stericsson.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Drop all load weight manipulation for RT tasks
Message-ID: <tip-17bdcf949d03306b308c5fb694849cd35f119807@git.kernel.org>
Git-Commit-ID: 17bdcf949d03306b308c5fb694849cd35f119807
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 18 Oct 2010 19:16:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  17bdcf949d03306b308c5fb694849cd35f119807
Gitweb:     http://git.kernel.org/tip/17bdcf949d03306b308c5fb694849cd35f119807
Author:     Linus Walleij <linus.walleij@stericsson.com>
AuthorDate: Mon, 11 Oct 2010 16:36:51 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 18 Oct 2010 18:41:59 +0200

sched: Drop all load weight manipulation for RT tasks

Load weights are for the CFS, they do not belong in the RT task. This makes all
RT scheduling classes leave the CFS weights alone.

This fixes a real bug as well: I noticed the following phonomena: a process
elevated to SCHED_RR forks with SCHED_RESET_ON_FORK set, and the child is
indeed SCHED_OTHER, and the niceval is indeed reset to 0. However the weight
inserted by set_load_weight() remains at 0, giving the task insignificat
priority.

With this fix, the weight is reset to what the task had before being elevated
to SCHED_RR/SCHED_FIFO.

Cc: Lennart Poettering <lennart@poettering.net>
Cc: stable@kernel.org
Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1286807811-10568-1-git-send-email-linus.walleij@stericsson.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 5f64fed..728081a 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1855,12 +1855,6 @@ static void dec_nr_running(struct rq *rq)
 
 static void set_load_weight(struct task_struct *p)
 {
-	if (task_has_rt_policy(p)) {
-		p->se.load.weight = 0;
-		p->se.load.inv_weight = WMULT_CONST;
-		return;
-	}
-
 	/*
 	 * SCHED_IDLE tasks get minimal weight:
 	 */
