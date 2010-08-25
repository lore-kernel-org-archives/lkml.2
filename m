Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521Ab0HYL77 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 07:59:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9879 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753502Ab0HYL75 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 07:59:57 -0400
Subject: Re: [PATCH] audit: speedup for syscalls when auditing is disabled
From: Eric Paris <eparis@redhat.com>
To: Michael Neuling <mikey@neuling.org>
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>, anton@samba.org, sgrubb@redhat.com
In-Reply-To: <15180.1282705886@neuling.org>
References: <29151.1282270393@neuling.org>
	 <1282586177.2681.43.camel@localhost.localdomain>
	 <20887.1282615880@neuling.org>
	 <1282621410.26616.406.camel@localhost.localdomain>
	 <15180.1282705886@neuling.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 25 Aug 2010 07:59:43 -0400
Message-ID: <1282737584.13142.153.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-08-25 at 13:11 +1000, Michael Neuling wrote:

> BTW, do you think we can do this in audit_syscall_exit() too?

No, I don't think that is safe, consider the case where we remove the
last rule while this task was inside a syscall.  It may have information
stored which is supposed to get freed in the syscall exit.

We could probably drop the if (!context) statement altogether and then
before the audit_get_context() call we could add

if (audit_dummy_context())
    return;

Which should be safe since that would imply there were no rules when we
entered the syscall.  I'm impressed with how much difference these 2
simple patches can make!

Looks like audit_get_context() could use some cleanups too.  What's the
point of setting the return code and crap like that when we know it's
not going anywhere.  In any case, if you want to clean up this last idea
and send it I'll make sure it gets queued up for the next go round.

-Eric

> If I do, I get down to 387 cycles (739.03 vanilla, 668.09 with
> audit_syscall_entry() optimisation, 204 best case) so about
> another 50% perf improvement.
> 
> Patch was simply:
> 
> --- linux-next.orig/kernel/auditsc.c
> +++ linux-next/kernel/auditsc.c
> @@ -1681,7 +1683,7 @@ void audit_syscall_exit(int valid, long 
>  
>  	context = audit_get_context(tsk, valid, return_code);
>  
> -	if (likely(!context))
> +	if (likely((!context) || (audit_n_rules == 0)))
>  		return;
>  
>  	if (context->in_syscall && context->current_state == AUDIT_RECORD_CONTEXT)
> 


