Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759335Ab0EDM5H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 08:57:07 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58071 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752958Ab0EDM5E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 08:57:04 -0400
Subject: Re: [PATCH V2] lockdep: reduce stack_trace usage
From: Peter Zijlstra <peterz@infradead.org>
To: Yong Zhang <yong.zhang@windriver.com>
Cc: John Kacur <jkacur@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>,
       Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
       Clark Williams <williams@redhat.com>,
       "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Gregory Haskins <ghaskins@novell.com>,
       "David S. Miller" <davem@davemloft.net>,
       Yong Zhang <yong.zhang0@gmail.com>
In-Reply-To: <20100504065711.GC10784@windriver.com>
References: <alpine.LFD.2.00.1004222208310.3155@localhost>
	 <20100423025850.GA21328@windriver.com>
	 <alpine.LFD.2.00.1004230907050.4151@localhost>
	 <1272009915.1646.25.camel@laptop>
	 <w2v520f0cf11004230131i743c596emfd0e5b8870330a8b@mail.gmail.com>
	 <20100423134044.GA2777@zhy-desktop>  <20100504065711.GC10784@windriver.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 04 May 2010 14:56:51 +0200
Message-ID: <1272977811.5605.183.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-04 at 14:57 +0800, Yong Zhang wrote:
> From 04395389820e89c0bd4bb57b939ec1882e0bb5da Mon Sep 17 00:00:00 2001
> From: Yong Zhang <yong.zhang@windriver.com>
> Date: Tue, 4 May 2010 14:16:48 +0800
> Subject: [PATCH] lockdep: Reduce stack_trace usage
> 
> When calling check_prevs_add(), if all validations passed
> add_lock_to_list() will add new lock to dependency tree and
> alloc stack_trace for each list_entry. But at this time,
> we are always on the same stack, so stack_trace for each
> list_entry has the same value. This is redundant and eats up
> lots of memory which could lead to warning on low
> MAX_STACK_TRACE_ENTRIES.
> Using one copy of stack_trace instead.

Right, this looks like it ought to do as intended.

I added the below snipped because I know I'll fail to remember and that
'static' qualifier is fairly easy to miss.

Thanks!

---

Index: linux-2.6/kernel/lockdep.c
===================================================================
--- linux-2.6.orig/kernel/lockdep.c
+++ linux-2.6/kernel/lockdep.c
@@ -1627,6 +1627,13 @@ check_prev_add(struct task_struct *curr,
 	int ret;
 	struct lock_list this;
 	struct lock_list *uninitialized_var(target_entry);
+	/*
+	 * Static variable, serialized by the graph_lock().
+	 *
+	 * We use this static variable to save the stack trace in case
+	 * we call into this function multiple times due to encountering
+	 * trylocks in the held lock stack.
+	 */
 	static struct stack_trace trace;
 
 	/*

