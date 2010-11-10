Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756490Ab0KJTVv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 14:21:51 -0500
Received: from casper.infradead.org ([85.118.1.10]:34253 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756143Ab0KJTVu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 14:21:50 -0500
Subject: Re: [RFC][PATCH 05/22] sched: SCHED_DEADLINE policy implementation
From: Peter Zijlstra <peterz@infradead.org>
To: Raistlin <raistlin@linux.it>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Chris Friesen <cfriesen@nortel.com>, oleg@redhat.com,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Darren Hart <darren@dvhart.com>, Johan Eker <johan.eker@ericsson.com>,
        "p.faure" <p.faure@akatech.ch>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Claudio Scordino <claudio@evidence.eu.com>,
        michael trimarchi <trimarchi@retis.sssup.it>,
        Fabio Checconi <fabio@gandalf.sssup.it>,
        Tommaso Cucinotta <cucinotta@sssup.it>,
        Juri Lelli <juri.lelli@gmail.com>,
        Nicola Manica <nicola.manica@disi.unitn.it>,
        Luca Abeni <luca.abeni@unitn.it>, Dhaval Giani <dhaval@retis.sssup.it>,
        Harald Gustafsson <hgu1972@gmail.com>,
        paulmck <paulmck@linux.vnet.ibm.com>
In-Reply-To: <1288333814.8661.146.camel@Palantir>
References: <1288333128.8661.137.camel@Palantir>
	 <1288333814.8661.146.camel@Palantir>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 10 Nov 2010 20:21:21 +0100
Message-ID: <1289416881.2084.41.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-29 at 08:30 +0200, Raistlin wrote:
> +       if (task_has_dl_policy(p) || task_has_rt_policy(p)) {
> +               p->se.load.weight = 0;
> +               p->se.load.inv_weight = WMULT_CONST;
> +               return;
> +       } 

---
commit 17bdcf949d03306b308c5fb694849cd35f119807
Author: Linus Walleij <linus.walleij@stericsson.com>
Date:   Mon Oct 11 16:36:51 2010 +0200

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

