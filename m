Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754404Ab1G0Jh2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 05:37:28 -0400
Received: from www.linutronix.de ([62.245.132.108]:35582 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754024Ab1G0Jh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 05:37:27 -0400
Date: Wed, 27 Jul 2011 11:37:24 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Darren Hart <dvhart@linux.intel.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Maarten Lankhorst <m.b.lankhorst@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: rt_mutex: restore wait_lock init in __rt_mutex_init
In-Reply-To: <1311754711-19577-1-git-send-email-dvhart@linux.intel.com>
Message-ID: <alpine.LFD.2.02.1107271130280.2660@ionos>
References: <1311754711-19577-1-git-send-email-dvhart@linux.intel.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jul 2011, Darren Hart wrote:

> Without the raw_spin_lock_init(), the wait_lock does not get properly
> initialized with CONFIG_DEBUG_SPINLOCK. This can manifest in a BUG() in the
> futex requeue_pi path when the pi_state->pi_mutex->wait_lock fails the magic
> test in rt_mutex_start_proxy_lock()->raw_spin_lock(&lock->wait_lock).

That's actively wrong. You reinitialize the lock for all other cases
which call this via rt_mutex_init(). There is a reason why I moved the
spin lock initializer out of __rt_mutex_init() into
rt_mutex_init(). The lock name stuff for lockdep ends up to be
"lock->wait_lock" for all rt_mutexes, which is pretty useless when you
have to analyze a lockdep splat. Thanks for finding it nevertheless.

So the correct fix is:

Index: linux-2.6/kernel/rtmutex.c
===================================================================
--- linux-2.6.orig/kernel/rtmutex.c
+++ linux-2.6/kernel/rtmutex.c
@@ -1296,7 +1296,7 @@ EXPORT_SYMBOL_GPL(__rt_mutex_init);
 void rt_mutex_init_proxy_locked(struct rt_mutex *lock,
 				struct task_struct *proxy_owner)
 {
-	__rt_mutex_init(lock, NULL);
+	rt_mutex_init(lock);
 	debug_rt_mutex_proxy_lock(lock, proxy_owner);
 	rt_mutex_set_owner(lock, proxy_owner);
 	rt_mutex_deadlock_account_lock(lock, proxy_owner);

 
