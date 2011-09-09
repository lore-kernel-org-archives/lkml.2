Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933529Ab1IIUPY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 16:15:24 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52436 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933265Ab1IIUPW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 16:15:22 -0400
MIME-Version: 1.0
In-Reply-To: <20110909010916.525482401@codeaurora.org>
References: <20110909010847.294039464@codeaurora.org>
	<20110909010916.525482401@codeaurora.org>
Date: Fri, 9 Sep 2011 22:15:20 +0200
Message-ID: <CACM3HyGvJQABO3Hi6e+yH+Xoi+S+fctGrH3w4Jm7=zqtnPTXTQ@mail.gmail.com>
Subject: Re: [patch v3 19/36] Hexagon: Add ptrace support
From: Jonas Bonn <jonas.bonn@gmail.com>
To: Richard Kuo <rkuo@codeaurora.org>
Cc: linux-arch@vger.kernel.org, linux-hexagon@vger.kernel.org,
        linux-kernel@vger.kernel.org, Linas Vepstas <linas@codeaurora.org>,
        arnd@arndb.de
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 September 2011 03:09, Richard Kuo <rkuo@codeaurora.org> wrote:
> +long arch_ptrace(struct task_struct *child, long request,
> +                unsigned long addr, unsigned long data)
> +{
> +       void __user *udata = (void __user *) data;
> +
> +       switch (request) {
> +       case PTRACE_POKETEXT:   /* write the word at location addr. */
> +       case PTRACE_POKEDATA:
> +               return generic_ptrace_pokedata(child, addr, data);
> +       case PTRACE_POKEUSR:    /* write register specified by addr. */
> +               return ptrace_pokeusr(child, addr, data);
> +       case PTRACE_GETREGS:
> +               return copy_regset_to_user(child, &hexagon_user_view,
> +                                          REGSET_GPR, 0,
> +                                          sizeof(struct user_regs_struct),
> +                                          udata);
> +       case PTRACE_SETREGS:
> +               return copy_regset_from_user(child, &hexagon_user_view,
> +                                            REGSET_GPR, 0,
> +                                            sizeof(struct user_regs_struct),
> +                                            udata);
> +       default:
> +               return ptrace_request(child, request, addr, data);
> +       }
> +
> +       return 0;
> +}
>

I think that... other than for compatibility with legacy userspace
code, you shouldn't need any of these cases other than the 'default'.

PTRACE_GETREGS is replaced by PTRACE_GETREGSET and this is handled in
generic code.  POKETEXT, POKEDATA are handled in the generic code.
POKEUSR can also be done via the SETREGSET mechanism.

That said, I don't think gdbserver has been updated to use
GETREGSET/SETREGSET.  This is a bit like the uClibc/glibc issue,
though... somebody just needs to do the work to make userspace work
with the new, "clean" kernel interface.

Given all that, you shouldn't need to export pt_regs to userspace
either.  You already have a user_regs_struct which is userspace's view
of the process registers.  For OpenRISC we made pt_regs a kernel
private structure, giving us the freedom to change the stack layout of
the registers in the future while providing a stable view for
userspace.  I would suggest doing the same here.

If you do decide to make pt_regs private, you'll need to change your
struct sigcontext to use user_regs_struct, as well.

/Jonas
