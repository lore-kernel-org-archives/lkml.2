Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751196Ab0JPEYr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 00:24:47 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:41844 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738Ab0JPEYq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 00:24:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=XWPSrbnRBUKqRJkbRcKMOxWAtpDwR2FaTNwwzLFpiYJWF63CBbUER0PLI1vC2mfF3o
         MJEUzYWY6K2CwP4Fi7Rl1JkJ9cVh1MFKJvwMQ9Yxy04XST5lOzwCc+Zc/VzZS/aWTejw
         a0XORJYxwi2WlALPPC6J4tVsX5LIohc11fmEA=
MIME-Version: 1.0
In-Reply-To: <E1P0eK5-0006j5-4q@ZenIV.linux.org.uk>
References: <E1P0eK5-0006j5-4q@ZenIV.linux.org.uk>
Date: Fri, 15 Oct 2010 22:24:44 -0600
Message-ID: <AANLkTi=ZVzfoBixM8YdXa82FLAWyKcKjz0_qbo5ThuDa@mail.gmail.com>
Subject: Re: [PATCH 3/5] mips: sanitize restart logics
From: Shane McDonald <mcdonald.shane@gmail.com>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: ralf@linux-mips.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 28, 2010 at 11:50 AM, Al Viro <viro@ftp.linux.org.uk> wrote:
>
> Put the original syscall number into ->regs[0] when we leave syscall
> with error.  Use it in restart logics.  Everything else will have
> it 0 since we pass through SAVE_SOME on all the ways in.  Note that
> in places like bad_stack and inllegal_syscall we leave it 0 - it's
> not restartable.
>
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Building 2.6.36-rc8 on a 32-bit mipsel system gives me
the following compile failure:

  LD      .tmp_vmlinux1
arch/mips/built-in.o:/home/shane/linux-mips.org/linux/arch/mips/kernel/scall32-o32.S:66:
undefined reference to `PR_R2'
arch/mips/built-in.o:/home/shane/linux-mips.org/linux/arch/mips/kernel/scall32-o32.S:66:
undefined reference to `PR_R2'
make: *** [.tmp_vmlinux1] Error 1

I tracked it down to this patch.  In particular, I believe the change
to scall32-o32.S is causing the problem.

> diff --git a/arch/mips/kernel/scall32-o32.S b/arch/mips/kernel/scall32-o32.S
> index 17202bb..d3edb9f 100644
> --- a/arch/mips/kernel/scall32-o32.S
> +++ b/arch/mips/kernel/scall32-o32.S
> @@ -63,9 +63,9 @@ stack_done:
>        sw      t0, PT_R7(sp)           # set error flag
>        beqz    t0, 1f
>
> +       lw      t1, PR_R2(sp)           # syscall number

Should this be PT_R2(sp), rather than PR_R2(sp)?

>        negu    v0                      # error
> -       sw      v0, PT_R0(sp)           # set flag for syscall
> -                                       # restarting
> +       sw      t1, PT_R0(sp)           # save it for syscall restarting
>  1:     sw      v0, PT_R2(sp)           # result
>
>  o32_syscall_exit:
> @@ -104,9 +104,9 @@ syscall_trace_entry:
>        sw      t0, PT_R7(sp)           # set error flag
>        beqz    t0, 1f
>
> +       lw      t1, PT_R2(sp)           # syscall number
>        negu    v0                      # error
> -       sw      v0, PT_R0(sp)           # set flag for syscall
> -                                       # restarting
> +       sw      t1, PT_R0(sp)           # save it for syscall restarting
>  1:     sw      v0, PT_R2(sp)           # result
>
>        j       syscall_exit
> @@ -170,7 +170,6 @@ stackargs:
>         */
>  bad_stack:
>        negu    v0                              # error
> -       sw      v0, PT_R0(sp)
>        sw      v0, PT_R2(sp)
>        li      t0, 1                           # set error flag
>        sw      t0, PT_R7(sp)

Changing PR_R2(sp) to PT_R2(sp) allows me to compile
and successfully boot 2.6.36-rc8.  I'll whip up a quick patch
to make this change and submit it.

Shane
