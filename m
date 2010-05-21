Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758564Ab0EURfy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 13:35:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42007 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753706Ab0EURfw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 13:35:52 -0400
Date: Fri, 21 May 2010 18:26:59 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-sh@vger.kernel.org,
       Paul Mundt <lethal@linux-sh.org>,
       uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org,
       David Howells <dhowells@redhat.com>, Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH v2] ptrace: unify FDPIC implementations
Message-ID: <20100521162659.GA16193@redhat.com>
References: <1266280229-18469-1-git-send-email-vapier@gentoo.org> <1274431345-22366-1-git-send-email-vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274431345-22366-1-git-send-email-vapier@gentoo.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/21, Mike Frysinger wrote:
>
> The Blackfin/FRV/SuperH guys all have the same exact FDPIC ptrace code in
> their arch handlers (since they were probably copied & pasted).  Since
> these ptrace interfaces are an arch independent aspect of the FDPIC code,
> unify them in the common ptrace code so new FDPIC ports don't need to copy
> and paste this fundamental stuff yet again.
>
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> Acked-by: Roland McGrath <roland@redhat.com>
> Acked-by: David Howells <dhowells@redhat.com>
> Acked-by: Paul Mundt <lethal@linux-sh.org>

I think the patch is nice too.

But,

> --- a/kernel/ptrace.c
> +++ b/kernel/ptrace.c
> @@ -596,6 +596,26 @@ int ptrace_request(struct task_struct *child, long request,
>  		ret = ptrace_detach(child, data);
>  		break;
>
> +#ifdef CONFIG_BINFMT_ELF_FDPIC
> +	case PTRACE_GETFDPIC: {
> +		unsigned long tmp = 0;
> +
> +		switch (addr) {
> +		case PTRACE_GETFDPIC_EXEC:
> +			tmp = child->mm->context.exec_fdpic_loadmap;
> +			break;
> +		case PTRACE_GETFDPIC_INTERP:
> +			tmp = child->mm->context.interp_fdpic_loadmap;

This looks unsafe. What protect child->mm if ptrace() races with SIGKILL ?

Of course, I do not blame this patch, the code was copied from arch/, but
I think we need another patch which checks ->mm != NULL under task_lock()
on top of this one?

Oleg.

