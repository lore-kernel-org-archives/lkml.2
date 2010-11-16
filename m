Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933553Ab0KPL34 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 06:29:56 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57965 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932917Ab0KPL3z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 06:29:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=B9qHX9XSe0fzy/tHRmbifV+6T703DrGHePpAhhzNyd8AgQ8Op+PKsB+hCpeFx6Zni1
         38dTLnYQPoV1M82+N79Pz/++9Q3Fm8RrnIykFlmywAfyWazhPj69LepSwHXMPvVlvA73
         fdNS2zaY2IYMPnhroNqpdV0ohyIXyvgLnL9lo=
MIME-Version: 1.0
In-Reply-To: <1289707863-1768-2-git-send-email-shan.hai@windriver.com>
References: <1289707863-1768-1-git-send-email-shan.hai@windriver.com>
	<1289707863-1768-2-git-send-email-shan.hai@windriver.com>
Date: Tue, 16 Nov 2010 06:29:53 -0500
Message-ID: <AANLkTi=SDjsDgzP=oLduB_Mo6BJCwEPe0q_VZva2VB1a@mail.gmail.com>
Subject: Re: [PATCH] Fix float to unsigned conversion failure with SPE enabled
From: Josh Boyer <jwboyer@gmail.com>
To: Hai Shan <haishan.bai@gmail.com>
Cc: linux-kernel@vger.kernel.org, Hai Shan <shan.hai@windriver.com>,
        linuxppc-dev@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 13, 2010 at 11:11 PM, Hai Shan <haishan.bai@gmail.com> wrote:
> Fixed the failure on converting minus float to unsigned int with SPE enabled
>
> Signed-off-by: Hai Shan <shan.hai@windriver.com>

You should make sure to send PowerPC patches to linuxppc-dev.

josh

> ---
>  arch/powerpc/math-emu/math_efp.c |   17 +++++++++++++----
>  1 files changed, 13 insertions(+), 4 deletions(-)
>
> diff --git a/arch/powerpc/math-emu/math_efp.c b/arch/powerpc/math-emu/math_efp.c
> index 41f4ef3..338a128 100644
> --- a/arch/powerpc/math-emu/math_efp.c
> +++ b/arch/powerpc/math-emu/math_efp.c
> @@ -320,7 +320,9 @@ int do_spe_mathemu(struct pt_regs *regs)
>                        } else {
>                                _FP_ROUND_ZERO(1, SB);
>                        }
> -                       FP_TO_INT_S(vc.wp[1], SB, 32, ((func & 0x3) != 0));
> +                       /* SB_s: convert from minus float to unsigned int */
> +                       FP_TO_INT_S(vc.wp[1], SB, 32,
> +                                       ((func & 0x3) != 0) || SB_s);
>                        goto update_regs;
>
>                default:
> @@ -458,7 +460,11 @@ cmp_s:
>                        } else {
>                                _FP_ROUND_ZERO(2, DB);
>                        }
> -                       FP_TO_INT_D(vc.wp[1], DB, 32, ((func & 0x3) != 0));
> +                       /* DB_s: convert from minus long double to
> +                        * unsigned long long
> +                        */
> +                       FP_TO_INT_D(vc.wp[1], DB, 32,
> +                                       ((func & 0x3) != 0) || DB_s);
>                        goto update_regs;
>
>                default:
> @@ -589,8 +595,11 @@ cmp_d:
>                                _FP_ROUND_ZERO(1, SB0);
>                                _FP_ROUND_ZERO(1, SB1);
>                        }
> -                       FP_TO_INT_S(vc.wp[0], SB0, 32, ((func & 0x3) != 0));
> -                       FP_TO_INT_S(vc.wp[1], SB1, 32, ((func & 0x3) != 0));
> +                       /* SB*_s: convert from minus float to unsigned int */
> +                       FP_TO_INT_S(vc.wp[0], SB0, 32,
> +                                       ((func & 0x3) != 0) || SB0_s);
> +                       FP_TO_INT_S(vc.wp[1], SB1, 32,
> +                                       ((func & 0x3) != 0) || SB1_s);
>                        goto update_regs;
>
>                default:
> --
> 1.7.0.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
