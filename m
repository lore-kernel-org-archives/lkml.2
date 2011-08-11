Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446Ab1HKMCr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 08:02:47 -0400
Received: from merlin.infradead.org ([205.233.59.134]:60708 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864Ab1HKMCq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 08:02:46 -0400
Subject: Re: [ANNOUNCE] 3.0.1-rt8 - Regression to 3.0-rt7
From: Peter Zijlstra <peterz@infradead.org>
To: Tim Sander <tim.sander@hbm.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@us.ibm.com>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Date: Thu, 11 Aug 2011 14:02:22 +0200
In-Reply-To: <201108111330.28168.tim.sander@hbm.com>
References: <1312580681.28695.44.camel@twins>
	 <201108091713.19292.tim.sander@hbm.com> <1313055790.23660.70.camel@twins>
	 <201108111330.28168.tim.sander@hbm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1313064142.7144.1.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-08-11 at 13:30 +0200, Tim Sander wrote:
> The error does not occur  when configured with 
> CONFIG_PREEMPT_RT_FULL=y
> but with 
> CONFIG_PREEMPT_RTB=y.
> The same error also happens with
> CONFIG_PREEMPT_LL=y. (A log is appended after the other log just
> search for CONFIG_PREEMPT_LL 
> for starting point). 

Does the below (on top of -rt8) cure things for you? Shouldn't make a
difference for PREEMPT_LL though, so maybe there's something else busted
as well. But from what I can tell PREEMPT_BASE should be fine with such
things disabling preemption..



---
Index: linux-2.6/include/linux/uaccess.h
===================================================================
--- linux-2.6.orig/include/linux/uaccess.h
+++ linux-2.6/include/linux/uaccess.h
@@ -22,7 +22,7 @@ static inline void raw_pagefault_enable(
 	preempt_check_resched();
 }
 
-#ifndef CONFIG_PREEMPT_RT_FULL
+#ifndef CONFIG_PREEMPT_RT_BASE
 static inline void pagefault_disable(void)
 {
 	raw_pagefault_disable();
Index: linux-2.6/mm/memory.c
===================================================================
--- linux-2.6.orig/mm/memory.c
+++ linux-2.6/mm/memory.c
@@ -3438,7 +3438,7 @@ int handle_pte_fault(struct mm_struct *m
 	return 0;
 }
 
-#ifdef CONFIG_PREEMPT_RT_FULL
+#ifdef CONFIG_PREEMPT_RT_BASE
 void pagefault_disable(void)
 {
 	migrate_disable();

