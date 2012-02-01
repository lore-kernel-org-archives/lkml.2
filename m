Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755769Ab2BAJqf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 04:46:35 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:46740 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753191Ab2BAJqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 04:46:34 -0500
Date: Wed, 1 Feb 2012 09:46:21 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: takuo.koguchi.sw@hitachi.com
Cc: linux-kernel@vger.kernel.org, masami.hiramatsu.pt@hitachi.com,
        rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com,
        jbaron@redhat.com, yrl.pp-manager.tt@hitachi.com
Subject: Re: [PATCH] ARM: Wire up HAVE_SYSCALL_TRACEPOINTS
Message-ID: <20120201094621.GD889@n2100.arm.linux.org.uk>
References: <XNM1$5$0$1$$3$9$0$A$8005107U4ed75e6e@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <XNM1$5$0$1$$3$9$0$A$8005107U4ed75e6e@hitachi.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 01, 2011 at 08:01:32PM +0900, takuo.koguchi.sw@hitachi.com wrote:
> diff --git a/arch/arm/include/asm/unistd.h b/arch/arm/include/asm/unistd.h
> index 4a11237..f4eac2d 100644
> --- a/arch/arm/include/asm/unistd.h
> +++ b/arch/arm/include/asm/unistd.h
> @@ -405,6 +405,9 @@
>  #define __NR_process_vm_readv		(__NR_SYSCALL_BASE+376)
>  #define __NR_process_vm_writev		(__NR_SYSCALL_BASE+377)
>  
> +#ifndef __ASSEMBLY__
> +#define NR_syscalls		378
> +#endif

So, we have 380 syscalls in the assembly code.  You're telling ftrace
that we have 378.  That's just great, because it means userspace can
trigger this trivially:

int reg_event_syscall_enter(struct ftrace_event_call *call)
{
        int ret = 0;
        int num;

        num = ((struct syscall_metadata *)call->data)->syscall_nr;
        if (WARN_ON_ONCE(num < 0 || num >= NR_syscalls))
                return -ENOSYS;

And what about the ARM private syscalls?

This ftrace NR_syscalls definition would have to be some very large
number to avoid these issuing the above warning.  ftrace really needs
to lose this before ARM can start using it.
