Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756545Ab1JCPnD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 11:43:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54506 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753229Ab1JCPm5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 11:42:57 -0400
Date: Mon, 3 Oct 2011 11:42:09 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>, Andrew Morton <akpm00@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, hongjiu.lu@intel.com,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Russell King <rmk@arm.linux.org.uk>
Subject: Re: [PATCH v2] binfmt_elf: Fix PIE execution with randomization
 disabled (was Re: [RFC PATCH] binfmt_elf: Fix PIE execution with
 randomization disabled)
Message-ID: <20111003154208.GQ16720@zod.bos.redhat.com>
References: <20110929195359.GJ16720@zod.bos.redhat.com>
 <20110929141929.43df799d.akpm00@gmail.com>
 <alpine.LFD.2.02.1109291958210.9106@xanadu.home>
 <20110930021629.GL16720@zod.bos.redhat.com>
 <alpine.LNX.2.00.1110031651400.31654@pobox.suse.cz>
 <20111003150345.GP16720@zod.bos.redhat.com>
 <alpine.LNX.2.00.1110031709230.31654@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1110031709230.31654@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 03, 2011 at 05:11:47PM +0200, Jiri Kosina wrote:
> > I was mostly just trying to adapt H.J.'s patch to account for the
> > PF_RANDOMIZE case.  Looking at it a bit more, I'm not sure why they
> > would need to be different.  H.J., do you recall why you made that
> > change originally?
> 
> How about the patch below instead? It survives my testing, and I believe 
> it handles both cases properly.
> 
> Confirmation from the original bug reporter would obviously be a nice 
> bonus too :)

I built an F15 kernel with this patch included.  The testcase included
in the original bug report seems to run with and without randomization
enabled.  Looking at the ldd output on the binary shows that both cases
are working appropriately as well.

I'm happy to add my Acked-by below, but it would be nice if H.J.
confirmed as well.

> From: Jiri Kosina <jkosina@suse.cz>
> Subject: [PATCH] binfmt_elf: fix PIE execution with randomization disabled
> 
> The case of address space randomization being disabled in runtime through
> randomize_va_space sysctl is not treated properly in load_elf_binary(),
> resulting in SIGKILL coming at exec() time for certain PIE-linked binaries
> in case the randomization has been disabled at runtime prior to calling
> exec().
> 
> Handle the randomize_va_space == 0 case the same way as if we were not
> supporting .text randomization at all.
> 
> Based on original patch by H.J. Lu <hongjiu.lu@intel.com> and
> Josh Boyer <jwboyer@redhat.com>
> 
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Jiri Kosina <jkosina@suse.cz>
> Cc: Nicolas Pitre <nicolas.pitre@linaro.org>
> Cc: Russell King <rmk@arm.linux.org.uk>
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>

Acked-by: Josh Boyer <jwboyer@redhat.com>

> ---
>  fs/binfmt_elf.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
> index dd0fdfc..bb11fe4 100644
> --- a/fs/binfmt_elf.c
> +++ b/fs/binfmt_elf.c
> @@ -795,7 +795,10 @@ static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs)
>  			 * might try to exec.  This is because the brk will
>  			 * follow the loader, and is not movable.  */
>  #if defined(CONFIG_X86) || defined(CONFIG_ARM)
> -			load_bias = 0;
> +			if (current->flags & PF_RANDOMIZE)
> +				load_bias = 0;
> +			else
> +				load_bias = ELF_PAGESTART(ELF_ET_DYN_BASE - vaddr);
>  #else
>  			load_bias = ELF_PAGESTART(ELF_ET_DYN_BASE - vaddr);
>  #endif
> 
