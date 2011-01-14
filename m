Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056Ab1ANLnL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 06:43:11 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:63832 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752829Ab1ANLnG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 06:43:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=jLaFE2sok3Z/iOYg+PyKLdf8+Rm1yP5O2ZAf+vbmSdLTzjWzsI/+8Q9Ian5ikZk4Yx
         g42yjl3k+o3HarZrCNKOk7tKIirmdvCWh2jQ50jgeuMZzKBfbPf1Wf9qg1UTXNRPlSJk
         Z9Tj1Fknqe1VFP0ptiAsVG6mKmYrB01wnBytg=
MIME-Version: 1.0
In-Reply-To: <1294990949-2729-1-git-send-email-ccross@android.com>
References: <1294990949-2729-1-git-send-email-ccross@android.com>
Date: Fri, 14 Jan 2011 11:43:04 +0000
X-Google-Sender-Auth: XQ8S7UN60v9l0o2zUSJzJm6acxs
Message-ID: <AANLkTimqiqABxCejdeOQWZZ62DVUZW2v-yMpdu1aNDQT@mail.gmail.com>
Subject: Re: [PATCH] ARM: vfp: Fix up exception location in Thumb mode
From: Catalin Marinas <catalin.marinas@arm.com>
To: Colin Cross <ccross@android.com>
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 January 2011 07:42, Colin Cross <ccross@android.com> wrote:
> The exception handler in entry-armv.S checks for thumb mode and
> correctly determines the exception location and instruction,
> but VFP_bounce uses the uncorrected location off the stack.
> If the VFP exception occured in Thumb mode, fix up the
> exception location to match the value that would be returned
> in ARM mode.
>
> Fixes segfaults in userspace applications running in Thumb mode
> caused by a handled VFP exception returning to the middle of the
> instruction that triggered the exception.
>
> Change-Id: I6c6ba1ab88e107bec166ea334d7e0974a4f6bfba
> Signed-off-by: Colin Cross <ccross@android.com>
> ---
>  arch/arm/vfp/vfpmodule.c |   10 ++++++++++
>  1 files changed, 10 insertions(+), 0 deletions(-)
>
> diff --git a/arch/arm/vfp/vfpmodule.c b/arch/arm/vfp/vfpmodule.c
> index 0797cb5..63ed73d 100644
> --- a/arch/arm/vfp/vfpmodule.c
> +++ b/arch/arm/vfp/vfpmodule.c
> @@ -275,6 +275,16 @@ void VFP_bounce(u32 trigger, u32 fpexc, struct pt_regs *regs)
>        pr_debug("VFP: bounce: trigger %08x fpexc %08x\n", trigger, fpexc);
>
>        /*
> +        * If the exception occured in thumb mode, pc is exception location + 2,
> +        * the middle of the 32-bit VFP instruction.  Add 2 to get exception
> +        * location + 4, the same we get in ARM mode.
> +        */
> +#ifdef CONFIG_ARM_THUMB
> +       if (regs->ARM_cpsr & PSR_T_BIT)
> +               regs->ARM_pc += 2;
> +#endif

You can use "if (thumb_mode(regs))" and avoid the #ifdef entirely.

-- 
Catalin
