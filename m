Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752028Ab1BBA2M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 19:28:12 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50111 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751949Ab1BBA2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:28:11 -0500
Date: Tue, 1 Feb 2011 16:27:29 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: Roland McGrath <roland@redhat.com>, oleg@redhat.com,
        jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org
Subject: Re: [PATCH] ptrace: use safer wake up on ptrace_detach()
Message-Id: <20110201162729.f75be47d.akpm@linux-foundation.org>
In-Reply-To: <20110201102618.GE14211@htj.dyndns.org>
References: <1296227324-25295-1-git-send-email-tj@kernel.org>
	<1296227324-25295-3-git-send-email-tj@kernel.org>
	<20110128184601.CBF7C180996@magilla.sf.frob.com>
	<20110131103855.GD7459@htj.dyndns.org>
	<20110201102618.GE14211@htj.dyndns.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Feb 2011 11:26:18 +0100
Tejun Heo <tj@kernel.org> wrote:

> The wake_up_process() call in ptrace_detach() is spurious and not
> interlocked with the tracee state.  IOW, the tracee could be running
> or sleeping in any place in the kernel by the time wake_up_process()
> is called.  This can lead to the tracee waking up unexpectedly which
> can be dangerous.
> 
> The wake_up is spurious and should be removed but for now reduce its
> toxicity by only waking up if the tracee is in TRACED or STOPPED
> state.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Roland McGrath <roland@redhat.com>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: stable@kernel.org

Am unable to work out why you tagged it for backporting.  It fixes some
observed bug?  Perhaps a regression?

> Index: work/kernel/ptrace.c
> ===================================================================
> --- work.orig/kernel/ptrace.c
> +++ work/kernel/ptrace.c
> @@ -313,7 +313,7 @@ int ptrace_detach(struct task_struct *ch
>  		child->exit_code = data;
>  		dead = __ptrace_detach(current, child);
>  		if (!child->exit_state)
> -			wake_up_process(child);
> +			wake_up_state(child, TASK_TRACED | TASK_STOPPED);
>  	}
>  	write_unlock_irq(&tasklist_lock);
>  
