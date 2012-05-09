Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759916Ab2EIVG7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 17:06:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18294 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755396Ab2EIVG6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 17:06:58 -0400
Date: Wed, 9 May 2012 23:05:51 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: torvalds@linux-foundation.org, hpa@zytor.com, mingo@elte.hu,
        linux-kernel@vger.kernel.org, suresh@aristanetworks.com
Subject: Re: [PATCH 1/3] coredump: flush the fpu exit state for proper
	multi-threaded core dump
Message-ID: <20120509210551.GB334@redhat.com>
References: <1336421341.19423.4.camel@sbsiddha-desk.sc.intel.com> <1336519085-27450-1-git-send-email-suresh.b.siddha@intel.com> <1336519085-27450-2-git-send-email-suresh.b.siddha@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336519085-27450-2-git-send-email-suresh.b.siddha@intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08, Suresh Siddha wrote:
>
> --- a/kernel/exit.c
> +++ b/kernel/exit.c
> @@ -656,6 +656,11 @@ static void exit_mm(struct task_struct * tsk)
>  		struct core_thread self;
>  		up_read(&mm->mmap_sem);
>
> +		/*
> +		 * Flush the live extended register state to memory.
> +		 */
> +		prepare_to_copy(tsk);

This doesn't look very nice imho, but I guess you understand this...

Perhaps we need an arch-dependent helper which saves the FPU regs
if needed.

I can be easily wrong, but I did the quick grep and I am not sure
we can rely on prepare_to_copy(). For example, it is a nop in
arch/sh/include/asm/processor_64.h. But at the same time it has
save_fpu().

OTOH, I am not sure it is safe to use prepare_to_copy() in exit_mm(),
at least in theory. God knows what it can do...

But again, I do not think I can comment this change. Perhaps this
is the right step anyway.

Oleg.

