Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759307Ab2BJRXi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 12:23:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6240 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780Ab2BJRXh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 12:23:37 -0500
Date: Fri, 10 Feb 2012 18:17:03 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Pedro Alves <palves@redhat.com>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] ptrace: don't modify flags on PTRACE_SETOPTIONS
	failure
Message-ID: <20120210171703.GA8908@redhat.com>
References: <1328884991-23889-1-git-send-email-vda.linux@googlemail.com> <1328884991-23889-2-git-send-email-vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328884991-23889-2-git-send-email-vda.linux@googlemail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/10, Denys Vlasenko wrote:

> On ptrace(PTRACE_SETOPTIONS, pid, 0, <opts>), we used to set
> those option bits which are known, and then fail with -EINVAL
> if there are some unknown bits in <opts>.
> 
> This in inconsistent with typical error handling, which
> does not change any state if input is invalid.
> 
> This patch changes PTRACE_SETOPTIONS behavior so that
> in this case, we return -EINVAL and don't change any bits
> in task->ptrace.
> 
> It's very unlikely that there is userspace code in the wild which
> will be affected by this change: it should have the form
> 
>     ptrace(PTRACE_SETOPTIONS, pid, 0, PTRACE_O_BOGUSOPT)
> 
> where PTRACE_O_BOGUSOPT is a constant unknown to the kernel.
> But kernel headers, naturally, don't contain any
> PTRACE_O_BOGUSOPTs, thus the only way userspace can use one
> if it defines one itself. I can't see why anyone would do such
> a thing deliberately.
> 
> Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
> Acked-by: Tejun Heo <tj@kernel.org>

Reviewed-by: Oleg Nesterov <oleg@redhat.com>

> ---
>  kernel/ptrace.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/ptrace.c b/kernel/ptrace.c
> index 00ab2ca..273f56e 100644
> --- a/kernel/ptrace.c
> +++ b/kernel/ptrace.c
> @@ -528,6 +528,9 @@ int ptrace_writedata(struct task_struct *tsk, char __user *src, unsigned long ds
>  
>  static int ptrace_setoptions(struct task_struct *child, unsigned long data)
>  {
> +	if (data & ~(unsigned long)PTRACE_O_MASK)
> +		return -EINVAL;
> +
>  	child->ptrace &= ~PT_TRACE_MASK;
>  
>  	if (data & PTRACE_O_TRACESYSGOOD)
> @@ -551,7 +554,7 @@ static int ptrace_setoptions(struct task_struct *child, unsigned long data)
>  	if (data & PTRACE_O_TRACEEXIT)
>  		child->ptrace |= PT_TRACE_EXIT;
>  
> -	return (data & ~PTRACE_O_MASK) ? -EINVAL : 0;
> +	return 0;
>  }
>  
>  static int ptrace_getsiginfo(struct task_struct *child, siginfo_t *info)
> -- 
> 1.7.7.6
> 

