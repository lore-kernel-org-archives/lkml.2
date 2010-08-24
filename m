Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826Ab0HXLWE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 07:22:04 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:61731 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351Ab0HXLWB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 07:22:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=LbqFCeGu3A00ZvEsDvuvai68unVAiD/zLQvaXdR58USw9qAKE6yfek6HQ4vxGaAnZr
         MBn76M5kxxuc2cLDgPyXaZx89yWf6mHSeEN0wRJQUuiLWEFADwHlg+xGxIJrPS65XNrg
         RkPRUCLW+9NwhCGTyauEZVHVcuhepESbjquFU=
MIME-Version: 1.0
In-Reply-To: <1282648229-19575-2-git-send-email-avi@redhat.com>
References: <1282648229-19575-1-git-send-email-avi@redhat.com>
	<1282648229-19575-2-git-send-email-avi@redhat.com>
Date: Tue, 24 Aug 2010 07:22:00 -0400
Message-ID: <AANLkTikb1SN6YDsU0dPfTjDkLAZGOX27ccaiEc5OoQHC@mail.gmail.com>
Subject: Re: [PATCH 1/3] x86: allow kernel exception fixup for divide errors (#DE)
From: Brian Gerst <brgerst@gmail.com>
To: Avi Kivity <avi@redhat.com>
Cc: x86@kernel.org, kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 24, 2010 at 7:10 AM, Avi Kivity <avi@redhat.com> wrote:
> KVM wants to emulate the DIV and IDIV instructions by executing them natively;
> this can cause a #DE to be raised.
>
> Allow the exception handling mechanism to process #DE exceptions so KVM can
> catch and process them.
>
> Signed-off-by: Avi Kivity <avi@redhat.com>
> ---
>  arch/x86/kernel/traps.c |   10 +++++++++-
>  1 files changed, 9 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
> index 725ef4d..dd313cf 100644
> --- a/arch/x86/kernel/traps.c
> +++ b/arch/x86/kernel/traps.c
> @@ -205,7 +205,8 @@ dotraplinkage void do_##name(struct pt_regs *regs, long error_code) \
>        do_trap(trapnr, signr, str, regs, error_code, &info);           \
>  }
>
> -DO_ERROR_INFO(0, SIGFPE, "divide error", divide_error, FPE_INTDIV, regs->ip)
> +static DO_ERROR_INFO(0, SIGFPE, "divide error", divide_error_user,
> +                    FPE_INTDIV, regs->ip)
>  DO_ERROR(4, SIGSEGV, "overflow", overflow)
>  DO_ERROR(5, SIGSEGV, "bounds", bounds)
>  DO_ERROR_INFO(6, SIGILL, "invalid opcode", invalid_op, ILL_ILLOPN, regs->ip)
> @@ -217,6 +218,13 @@ DO_ERROR(12, SIGBUS, "stack segment", stack_segment)
>  #endif
>  DO_ERROR_INFO(17, SIGBUS, "alignment check", alignment_check, BUS_ADRALN, 0)
>
> +dotraplinkage void do_divide_error(struct pt_regs *regs, long error_code)
> +{
> +       if (!user_mode_vm(regs) && fixup_exception(regs))
> +               return;
> +       do_divide_error_user(regs, error_code);
> +}
> +
>  #ifdef CONFIG_X86_64
>  /* Runs on IST stack */
>  dotraplinkage void do_stack_segment(struct pt_regs *regs, long error_code)

Kernel mode exceptions should already be handled by do_trap().  This
is unnecessary.

--
Brian Gerst
