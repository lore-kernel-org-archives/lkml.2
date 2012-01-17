Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755686Ab2AQUEN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 15:04:13 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:37665 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753028Ab2AQUEM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 15:04:12 -0500
MIME-Version: 1.0
In-Reply-To: <1326733664-4095-1-git-send-email-sboyd@codeaurora.org>
References: <1326733664-4095-1-git-send-email-sboyd@codeaurora.org>
Date: Tue, 17 Jan 2012 12:04:11 -0800
X-Google-Sender-Auth: b5P2s9UcnJSQv4Wr5ym78zfLRyo
Message-ID: <CAPnjgZ2LGjMM7QwoJrf2==3th4cT+s75ebV9q+eXudF4o5E_pA@mail.gmail.com>
Subject: Re: [PATCH] ARM: Print BUG instead of undefined instruction on BUG_ON()
From: Simon Glass <sjg@chromium.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 16, 2012 at 9:07 AM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> The ARM kernel uses undefined instructions to implement
> BUG/BUG_ON(). This leads to problems where people don't read one
> line above the Oops message and see the "kernel BUG at ..."
> message and so they wrongly assume the kernel has hit an
> undefined instruction.
>
> Instead of printing:
>
>  Internal error: Oops - undefined instruction: 0 [#1] PREEMPT SMP
>
> print
>
>  Internal error: Oops - BUG: 0 [#1] PREEMPT SMP
>
> This should prevent people from thinking the BUG_ON was an
> undefined instruction when it was actually intentional.
>
> Cc: Simon Glass <sjg@chromium.org>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>

Tested on a Tegra20 system. I would like to adjust the backtrace
output slightly so will send a patch for that at the same time, since
we are in there.

Acked-by: Simon Glass <sjg@chromium.org>
Tested-by: Simon Glass <sjg@chromium.org>

> ---
>  arch/arm/kernel/traps.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
>
> diff --git a/arch/arm/kernel/traps.c b/arch/arm/kernel/traps.c
> index 99a5727..f84dfe6 100644
> --- a/arch/arm/kernel/traps.c
> +++ b/arch/arm/kernel/traps.c
> @@ -266,6 +266,7 @@ void die(const char *str, struct pt_regs *regs, int err)
>  {
>        struct thread_info *thread = current_thread_info();
>        int ret;
> +       enum bug_trap_type bug_type = BUG_TRAP_TYPE_NONE;
>
>        oops_enter();
>
> @@ -273,7 +274,9 @@ void die(const char *str, struct pt_regs *regs, int err)
>        console_verbose();
>        bust_spinlocks(1);
>        if (!user_mode(regs))
> -               report_bug(regs->ARM_pc, regs);
> +               bug_type = report_bug(regs->ARM_pc, regs);
> +       if (bug_type != BUG_TRAP_TYPE_NONE)
> +               str = "Oops - BUG";
>        ret = __die(str, err, thread, regs);
>
>        if (regs && kexec_should_crash(thread->task))
> --
> Sent by an employee of the Qualcomm Innovation Center, Inc.
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
>
