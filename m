Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593Ab1GHS1M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 14:27:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40289 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751811Ab1GHS1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 14:27:11 -0400
Date: Fri, 8 Jul 2011 11:27:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dan Rosenberg <drosenberg@vsecurity.com>
Cc: chris@zankel.net, security@kernel.org, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [Security] [PATCH] xtensa: prevent arbitrary read in ptrace
Message-Id: <20110708112706.9014d306.akpm@linux-foundation.org>
In-Reply-To: <1310083434.2139.4.camel@anubis>
References: <1310083434.2139.4.camel@anubis>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 07 Jul 2011 20:03:54 -0400
Dan Rosenberg <drosenberg@vsecurity.com> wrote:

> Prevent an arbitrary kernel read. Check the user pointer with
> access_ok() before copying data in.
> 
> Signed-off-by: Dan Rosenberg <drosenberg@vsecurity.com>
> Cc: stable@kernel.org
> ---
>  arch/xtensa/kernel/ptrace.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/xtensa/kernel/ptrace.c b/arch/xtensa/kernel/ptrace.c
> index c72c947..ddce75e 100644
> --- a/arch/xtensa/kernel/ptrace.c
> +++ b/arch/xtensa/kernel/ptrace.c
> @@ -147,6 +147,9 @@ int ptrace_setxregs(struct task_struct *child, void __user *uregs)
>  	elf_xtregs_t *xtregs = uregs;
>  	int ret = 0;
>  
> +	if (!access_ok(VERIFY_READ, uregs, sizeof(elf_xtregs_t)))
> +		return -EIO;

This should be -EFAULT, methinks?

> +
>  #if XTENSA_HAVE_COPROCESSORS
>  	/* Flush all coprocessors before we overwrite them. */
>  	coprocessor_flush_all(ti);


