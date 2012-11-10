Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752122Ab2KJII6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2012 03:08:58 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:33449 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407Ab2KJIIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2012 03:08:54 -0500
MIME-Version: 1.0
In-Reply-To: <20121110073338.GP2616@ZenIV.linux.org.uk>
References: <CANN689FmsFBjfiD8V-nQyDh+GtTF5B3SDUcuXc=3OeeN6JW0kw@mail.gmail.com>
	<20121110045104.GN2616@ZenIV.linux.org.uk>
	<CANN689GetguA+1bqKXC=Cq0SLcLqaqLsn5XGBZYVbWeBogX+zA@mail.gmail.com>
	<20121110053334.GO2616@ZenIV.linux.org.uk>
	<CANN689G+j0VS5JcFDx08XexZmqZ95YUPMVRd+3ji=8Fr3Q2R=Q@mail.gmail.com>
	<20121110073338.GP2616@ZenIV.linux.org.uk>
Date: Sat, 10 Nov 2012 00:08:53 -0800
Message-ID: <CANN689GVcZwkm984-vxG4raWvUcSphd-msxBGT+2qgfySJHm1w@mail.gmail.com>
Subject: Re: Issues with "x86, um: switch to generic fork/vfork/clone" commit
From: Michel Lespinasse <walken@google.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Hugh Dickins <hughd@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 9, 2012 at 11:33 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> Could you verify that this on top of for-next gets the things working again?
> It's a very lazy way to deal with that (we don't want to bother with
> restoring extras, at the very least), but the rest can go separately (and
> is shared with mainline, unlike that one).  It seems to be working here,
> but I'd like to see your ACK as well.  If everything works, it'll get
> folded into the offending commit...
>
> diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
> index 633649e..32e6f05 100644
> --- a/arch/x86/ia32/ia32entry.S
> +++ b/arch/x86/ia32/ia32entry.S
> @@ -467,11 +467,16 @@ GLOBAL(\label)
>         PTREGSCALL stub32_sigaltstack, sys32_sigaltstack, %rdx
>         PTREGSCALL stub32_execve, compat_sys_execve, %rcx
>         PTREGSCALL stub32_fork, sys_fork, %rdi
> -       PTREGSCALL stub32_clone, sys_clone, %rdx
>         PTREGSCALL stub32_vfork, sys_vfork, %rdi
>         PTREGSCALL stub32_iopl, sys_iopl, %rsi
>
>         ALIGN
> +GLOBAL(stub32_clone)
> +       leaq sys_clone(%rip),%rax
> +       mov     %r8, %rcx
> +       jmp  ia32_ptregs_common
> +
> +       ALIGN
>  ia32_ptregs_common:
>         popq %r11
>         CFI_ENDPROC

Yes, I tested the above by applying it on top of mmotm and it did
solve the issue.

Thanks,

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
