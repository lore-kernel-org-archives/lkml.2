Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932612Ab0KSWek (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 17:34:40 -0500
Received: from kroah.org ([198.145.64.141]:44936 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932525Ab0KSV6Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 16:58:24 -0500
X-Mailbox-Line: From gregkh@clark.site Fri Nov 19 13:56:39 2010
Message-Id: <20101119215639.401285027@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 19 Nov 2010 13:55:29 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Lennart Poettering <lennart@poettering.net>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: [08/82] sched: Drop all load weight manipulation for RT tasks
In-Reply-To: <20101119215658.GA7804@kroah.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Linus Walleij <linus.walleij@stericsson.com>

commit 17bdcf949d03306b308c5fb694849cd35f119807 upstream.

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
Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1286807811-10568-1-git-send-email-linus.walleij@stericsson.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/sched.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1830,12 +1830,6 @@ static void dec_nr_running(struct rq *rq
 
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


