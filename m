Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020Ab0IHPyX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 11:54:23 -0400
Received: from casper.infradead.org ([85.118.1.10]:51171 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755613Ab0IHPyU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 11:54:20 -0400
Subject: Re: [process scheduler] Possible bug in context_swich()?
From: Peter Zijlstra <peterz@infradead.org>
To: fabio de francesco <fabio@metanix.org>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <201009081728.18227.fabio@metanix.org>
References: <201009081728.18227.fabio@metanix.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 08 Sep 2010 17:54:18 +0200
Message-ID: <1283961258.23762.33.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-09-08 at 17:28 +0200, fabio de francesco wrote:

> In context_switch() (in linux/kernel/sched.c), starting with release 2.6.33, 
> two "unlikely" macro  have been changed to "likely". I think the previous 
> logic was right while the latter is wrong.
> 
> In case I am missing something I, please, ask someone to explain the above 
> mentioned inversion of logic through releases.

It helps if you CC people, LKML alone is a bit of a gamble.

git blame kernel/sched.c, will tell you that the change you refer to
comes from:

commit 710390d90f143a9ebb87a475215140f426792efd
Author: Tim Blechmann <tim@klingt.org>
Date:   Tue Nov 24 11:55:27 2009 +0100

    sched: Optimize branch hint in context_switch()
    
    Branch hint profiling on my nehalem machine showed over 90%
    incorrect branch hints:
    
      10420275 170645395  94 context_switch                 sched.c
       3043
      10408421 171098521  94 context_switch                 sched.c
       3050
    
    Signed-off-by: Tim Blechmann <tim@klingt.org>
    Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
    Cc: Mike Galbraith <efault@gmx.de>
    Cc: Paul Mackerras <paulus@samba.org>
    Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
    Cc: Frederic Weisbecker <fweisbec@gmail.com>
    LKML-Reference: <4B0BBB9F.6080304@klingt.org>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/kernel/sched.c b/kernel/sched.c
index 93474a7..010d5e1 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2829,14 +2829,14 @@ context_switch(struct rq *rq, struct task_struct *prev,
 	 */
 	arch_start_context_switch(prev);
 
-	if (unlikely(!mm)) {
+	if (likely(!mm)) {
 		next->active_mm = oldmm;
 		atomic_inc(&oldmm->mm_count);
 		enter_lazy_tlb(oldmm, next);
 	} else
 		switch_mm(oldmm, mm, next);
 
-	if (unlikely(!prev->mm)) {
+	if (likely(!prev->mm)) {
 		prev->active_mm = NULL;
 		rq->prev_mm = oldmm;
 	}

