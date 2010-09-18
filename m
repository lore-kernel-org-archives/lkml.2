Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756580Ab0IRTOh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:14:37 -0400
Received: from kroah.org ([198.145.64.141]:51683 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755309Ab0IRTCI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:02:08 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:00:00 2010
Message-Id: <20100918190000.261754821@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 11:58:51 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Greg KH <greg@kroah.com>, Mike Galbraith <efault@gmx.de>
Subject: [087/123] sched: Fix incorrect sanity check
References: <20100918185724.290702750@clark.site>
Content-Disposition: inline; filename=sched-fix-incorrect-sanity-check.patch
In-Reply-To: <20100918190024.GA14388@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

commit 11854247e2c851e7ff9ce138e501c6cffc5a4217 upstream

We moved to migrate on wakeup, which means that sleeping tasks could
still be present on offline cpus. Amend the check to only test running
tasks.

Reported-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 kernel/cpu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -151,7 +151,7 @@ static inline void check_for_tasks(int c
 
 	write_lock_irq(&tasklist_lock);
 	for_each_process(p) {
-		if (task_cpu(p) == cpu &&
+		if (task_cpu(p) == cpu && p->state == TASK_RUNNING &&
 		    (!cputime_eq(p->utime, cputime_zero) ||
 		     !cputime_eq(p->stime, cputime_zero)))
 			printk(KERN_WARNING "Task %s (pid = %d) is on cpu %d\


