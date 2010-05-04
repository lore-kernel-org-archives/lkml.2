Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760067Ab0EDRIe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 13:08:34 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50581 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753330Ab0EDRIc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 13:08:32 -0400
Date: Tue, 4 May 2010 19:08:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       peterz@infradead.org, tglx@linutronix.de, tom.leiming@gmail.com
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/locking] lockdep, fork: Fix dependency of
 hardirqs_enabled and softirqs_enabled
Message-ID: <20100504170817.GA23854@elte.hu>
References: <1272988872-2347-1-git-send-email-tom.leiming@gmail.com>
 <tip-9ca79f1559dc54268bdf129c0b2a1e2bcebeb0d5@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-9ca79f1559dc54268bdf129c0b2a1e2bcebeb0d5@git.kernel.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* tip-bot for Ming Lei <tom.leiming@gmail.com> wrote:

> Commit-ID:  9ca79f1559dc54268bdf129c0b2a1e2bcebeb0d5
> Gitweb:     http://git.kernel.org/tip/9ca79f1559dc54268bdf129c0b2a1e2bcebeb0d5
> Author:     Ming Lei <tom.leiming@gmail.com>
> AuthorDate: Wed, 5 May 2010 00:01:12 +0800
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Tue, 4 May 2010 18:33:20 +0200
> 
> lockdep, fork: Fix dependency of hardirqs_enabled and softirqs_enabled
> 
> The defination of hardirqs_enabled and softirqs_enabled in
> task_struct depends on CONFIG_TRACE_IRQFLAGS instead of
> CONFIG_PROVE_LOCKING.
> 
> Signed-off-by: Ming Lei <tom.leiming@gmail.com>
> Acked-by: Peter Zijlstra <peterz@infradead.org>
> LKML-Reference: <1272988872-2347-1-git-send-email-tom.leiming@gmail.com>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  kernel/fork.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/fork.c b/kernel/fork.c
> index 44b0791..038a8fd 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -1004,7 +1004,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
>  
>  	rt_mutex_init_task(p);
>  
> -#ifdef CONFIG_PROVE_LOCKING
> +#ifdef CONFIG_TRACE_IRQFLAGS
>  	DEBUG_LOCKS_WARN_ON(!p->hardirqs_enabled);
>  	DEBUG_LOCKS_WARN_ON(!p->softirqs_enabled);
>  #endif

this looks wrong - and it also causes this warning during bootup, with certain 
configs:

ftrace: allocating 24861 entries in 98 pages
------------[ cut here ]------------
WARNING: at kernel/fork.c:1008 copy_process+0x217/0x112c()
Hardware name: System Product Name
Modules linked in:
Pid: 0, comm: swapper Not tainted 2.6.34-rc6-tip-01171-gd3c6011-dirty #3116
Call Trace:
 [<ffffffff81039739>] warn_slowpath_common+0x7c/0x94
 [<ffffffff81039765>] warn_slowpath_null+0x14/0x16
 [<ffffffff81037dc5>] copy_process+0x217/0x112c
 [<ffffffff8100386c>] ? call_softirq+0x1c/0x28
 [<ffffffff8109e10a>] ? __alloc_pages_nodemask+0x112/0x5fc
 [<ffffffff81038e2c>] do_fork+0x152/0x2d1
 [<ffffffff815d3074>] ? trace_hardirqs_on_thunk+0x3a/0x3c
 [<ffffffff815d3729>] ? restore_args+0x0/0x30
 [<ffffffff81008ec1>] kernel_thread+0x70/0x72
 [<ffffffff8199e546>] ? kernel_init+0x0/0x1f5
 [<ffffffff81003770>] ? kernel_thread_helper+0x0/0x10
 [<ffffffff8104e14c>] ? rcu_scheduler_starting+0x38/0x5c
 [<ffffffff815a503d>] rest_init+0x21/0x80
 [<ffffffff8199ed21>] start_kernel+0x3b8/0x3c3
 [<ffffffff8199e2a3>] x86_64_start_reservations+0xb3/0xb7
 [<ffffffff8199e38b>] x86_64_start_kernel+0xe4/0xeb
---[ end trace 4eaa2a86a8e2da22 ]---
Setting APIC routing to flat

	Ingo
