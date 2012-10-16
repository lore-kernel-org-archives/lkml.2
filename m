Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755722Ab2JPEVX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 00:21:23 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:50086 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753355Ab2JPEVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 00:21:22 -0400
Date: Tue, 16 Oct 2012 05:21:19 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: linux-next: build failure after merge of the final tree
Message-ID: <20121016042119.GP2616@ZenIV.linux.org.uk>
References: <20121016145029.d726d08c7f18668e3cd64a0a@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121016145029.d726d08c7f18668e3cd64a0a@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2012 at 02:50:29PM +1100, Stephen Rothwell wrote:
> Hi Al,
> 
> After merging the final tree, today's linux-next build (sparc64 defconfig)
> failed like this:
> 
> arch/sparc/kernel/head_64.o: In function `sys64_execve':
> (.text+0x1f58): relocation truncated to fit: R_SPARC_WDISP19 against symbol `sys_execve' defined in .text section in fs/built-in.o
> arch/sparc/kernel/head_64.o: In function `sys32_execve':
> (.text+0x1f64): relocation truncated to fit: R_SPARC_WDISP19 against symbol `compat_sys_execve' defined in .text section in fs/built-in.o
> 
> Probably caused by commit 3223f8aab885 ("sparc64: convert to generic
> execve") and following from the signal tree.
> 
> I have added this patch you suggested on IRC:
> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Tue, 16 Oct 2012 14:43:51 +1100
> Subject: [PATCH] sparc: fixup for conversion to generic execve
> 
> Fixes these errors:
> 
> arch/sparc/kernel/head_64.o: In function `sys64_execve':
> (.text+0x1f58): relocation truncated to fit: R_SPARC_WDISP19 against symbol `sys_execve' defined in .text section in fs/built-in.o
> arch/sparc/kernel/head_64.o: In function `sys32_execve':
> (.text+0x1f64): relocation truncated to fit: R_SPARC_WDISP19 against symbol `compat_sys_execve' defined in .text section in fs/built-in.o
> 
> Dictated-by: Al Viro <viro@zeniv.linux.org.uk>
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  arch/sparc/kernel/syscalls.S |   12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/sparc/kernel/syscalls.S b/arch/sparc/kernel/syscalls.S
> index 4bae096..f667cdf 100644
> --- a/arch/sparc/kernel/syscalls.S
> +++ b/arch/sparc/kernel/syscalls.S
> @@ -2,15 +2,19 @@
>  	 * environment settings are the same as the calling processes.
>  	 */
>  sys64_execve:
> -	ba,pt	%xcc,sys_execve
> -	 flushw
> +	flushw
> +	mov	%o7, %l5
> +	call	sys_execve
> +	 mov	%l5, %o7
>  
>  #ifdef CONFIG_COMPAT
>  sunos_execv:
>  	mov	%g0, %o2
>  sys32_execve:
> -	ba,pt	%xcc,compat_sys_execve
> -	 flushw
> +	flushw
> +	mov	%o7, %l5
> +	call	compat_sys_execve
> +	 mov	%l5, %o7
>  #endif

BTW, that's really quick and dirty; I'm not at all sure we need that
flushw there, which could make things much simpler.  Namely, kill
sys64_execve completely, making it equivalent to sys_execve(), do the
same to sys32_execve() (== compat_sys_execve()) and as for sunos_execv(),
I'd simply put it into sys_sparc32.c as
SYSCALL_DEFINE2(sunos_execv,
		char __user *, filename,
		const char __user *const __user *, argv)
{
	return compat_sys_execve(filename, argv, NULL);
}
We definitely want flushw in fork and friends, but I'm not sure what we
need it for in execve(2)...

Anyway, the brute-force variant works.  I had been lucky to stay within the
ba,pt target limit on the config I used (very heavily modular, so not much
code in vmlinux in the first place, let alone before fs/exec.o), so I'd missed
the problem until now.  I've booted that with fatter config that would blow the
previous variant at link time and it works.
