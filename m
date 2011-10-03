Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932067Ab1JCMKg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 08:10:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49695 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754445Ab1JCMKb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 08:10:31 -0400
Date: Mon, 3 Oct 2011 14:10:26 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Josh Boyer <jwboyer@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
        hongjiu.lu@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] binfmt_elf: Fix PIE execution with randomization
 disabled
In-Reply-To: <20110929195359.GJ16720@zod.bos.redhat.com>
Message-ID: <alpine.LNX.2.00.1110031407280.31654@pobox.suse.cz>
References: <20110929195359.GJ16720@zod.bos.redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Sep 2011, Josh Boyer wrote:

> We've had a bug report[1] of some PIE programs getting a SIGKILL upon exec
> if you disable address randomization with:
> 
> 	echo 0 > /proc/sys/kernel/randomize_va_space
> 
> I tracked this down to get_unmapped_area_prot returning -ENOMEM because
> the address being passed in is larger than TASK_SIZE - len for the bss
> section of the test executable.  That filters back to set_brk returning
> an error to load_elf_binary and the SIGKILL being sent around line 872
> of binfmt_elf.c.
> 
> H.J. submitted an upstream bug report [2] as well, but got no feedback
> and we can't view it with kernel.org being down anyway.  He came up with
> the patch below as well, which is what I'm sending on for comments.  The
> changelog is my addition, so if that is wrong yell at me.
> 
> I wanted to get some more eyes on this, because the current code sets
> load_bias to 0 unconditionally on CONFIG_X86 or CONFIG_ARM.  I have no
> idea why that is.  The original execshield patches had an #ifdef on
> __i386__ but the patch that was commited to add PIE support has the
> CONFIG_X86 setting.
> 
> Thoughts welcome.
> 
> [1] https://bugzilla.redhat.com/show_bug.cgi?id=708563
> [2] http://bugzilla.kernel.org/show_bug.cgi?id=36372
> 
> josh
> 
> ---
> 
> From: H.J. Lu <hongjiu.lu@intel.com>
> 
> Set the load_bias for PIE executables to a non-zero address if no virtual
> address is specified.  This prevents us from running out of room for all
> the various loadable segments when ASLR is disabled.
> 
> Signed-off-by: H.J. Lu <hongjiu.lu@intel.com>
> Signed-off-by: Josh Boyer <jwboyer@redhat.com>
> 
> ---
> 
> diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
> index 303983f..069ee29 100644
> --- a/fs/binfmt_elf.c
> +++ b/fs/binfmt_elf.c
> @@ -794,9 +794,14 @@ static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs)
>  			/* Try and get dynamic programs out of the way of the
>  			 * default mmap base, as well as whatever program they
>  			 * might try to exec.  This is because the brk will
> -			 * follow the loader, and is not movable.  */
> +			 * follow the loader, and is not movable.  Don't use
> +			 * 0 load address since we may not have room for
> +			 * all loadable segements.  */
>  #if defined(CONFIG_X86) || defined(CONFIG_ARM)
> -			load_bias = 0;
> +			if (vaddr)
> +				load_bias = 0;
> +			else
> +				load_bias = ELF_PAGESTART(ELF_ET_DYN_BASE);

If you do this unconditionally, I can't see how ASLR could be working at 
all -- this patch causes that elf_addr() is always called with non-zero 
'addr' argument, right? (haven't verified by actually testing the patch 
yet, but I fail to see how come this simply doesn't break ASLR 
completely).

Checking for PF_RANDOMIZE flag should be the way to go here.

-- 
Jiri Kosina
SUSE Labs
