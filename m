Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758813Ab0GUVuA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 17:50:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45032 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755019Ab0GUVt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 17:49:57 -0400
Date: Wed, 21 Jul 2010 14:49:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, andi.kleen@intel.com,
        Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
        stable@kernel.org
Subject: Re: [PATCH] Don't apply for write lock on tasklist_lock if parent
 doesn't ptrace other processes
Message-Id: <20100721144944.5351c741.akpm@linux-foundation.org>
In-Reply-To: <1279176663.2096.1264.camel@ymzhang.sh.intel.com>
References: <1279176663.2096.1264.camel@ymzhang.sh.intel.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Jul 2010 14:51:03 +0800
"Zhang, Yanmin" <yanmin_zhang@linux.intel.com> wrote:

> We run some sub-cases (fork, exec, pipe, tcp, udp) of aim7 on 8-socket machine.
> Perf shows write_lock_irq(&tasklist_lock) consumes more than 50% cpu time.
> 
> One hot caller is exit_ptrace. If the exiting process doesn't ptrace other
> processes, kernel needn't apply for the write lock on tasklist_lock.
> 
> With below patch against kernel 2.6.35-rc5, we get more than 10% result improvement.
> 
> Signed-off-by: Zhang Yanmin <yanmin_zhang@linux.intel.com>
> 
> ---
> 
> diff -Nraup linux-2.6.35-rc5/kernel/ptrace.c linux-2.6.35-rc5_ptrace/kernel/ptrace.c
> --- linux-2.6.35-rc5/kernel/ptrace.c	2010-07-16 14:01:15.000000000 +0800
> +++ linux-2.6.35-rc5_ptrace/kernel/ptrace.c	2010-07-16 14:03:20.000000000 +0800
> @@ -331,6 +331,9 @@ void exit_ptrace(struct task_struct *tra
>  	struct task_struct *p, *n;
>  	LIST_HEAD(ptrace_dead);
>  
> +	if (list_empty(&tracer->ptraced))
> +		return;
> +
>  	write_lock_irq(&tasklist_lock);
>  	list_for_each_entry_safe(p, n, &tracer->ptraced, ptrace_entry) {
>  		if (__ptrace_detach(tracer, p))

hah, nice patch - an easy 10%.  I snuck a cc:stable into the changelog
in the hope that those guys mistake it for a bugfix ;)

