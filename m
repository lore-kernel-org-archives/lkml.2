Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932403Ab0JLM6t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 08:58:49 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54458 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932282Ab0JLM6s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 08:58:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=fv6R4cx7kkcbxtOwM65Sk9iKTrw1foFAT2ChVOKcrzS0GhdwZ5oXjDvgQYzOU7T5TY
         Iu34Cp/DkVRIfH8J36JwWlec50noM5ahsATF+XaVS7yrCJuJZ/piekixU+B5BThV53a3
         VFaRQiedF9GR6M1f+jYc1FX2gaXPgBeUxJ95o=
MIME-Version: 1.0
In-Reply-To: <1286916487-11967-1-git-send-email-ling.ma@intel.com>
References: <1286916487-11967-1-git-send-email-ling.ma@intel.com>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Tue, 12 Oct 2010 14:58:26 +0200
Message-ID: <AANLkTimxadijsDY_t8mvOE2yq9VcMST1dYsqYpLM4Bhv@mail.gmail.com>
Subject: Re: [RFC PATCH] [X86/mem] Handle unaligned case by avoiding store
 crossing cache line
To: ling.ma@intel.com
Cc: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 12, 2010 at 10:48 PM,  <ling.ma@intel.com> wrote:
> From: Ma Ling <ling.ma@intel.com>
>
> In this patch we mannage to reduce penalty from crossing cache line
> on some CPU archs. There are two crossing-cache-line cases:
> read and write, but write is more expensive because of
> no cache-way predication and read-for-ownership operations
> on some archs, here we avoid sotre unaligned cases,
> another reason is shift register will cause more penalty
> on decode stages, so tolerate read.
...
> Signed-off-by: Ma Ling <ling.ma@intel.com>
> ---
>  arch/x86/lib/memcpy_64.S |   59 ++++++++++++++++++++++++++++++++++++++++-----
>  1 files changed, 52 insertions(+), 7 deletions(-)
>
> diff --git a/arch/x86/lib/memcpy_64.S b/arch/x86/lib/memcpy_64.S
> index 75ef61e..7545b08 100644
> --- a/arch/x86/lib/memcpy_64.S
> +++ b/arch/x86/lib/memcpy_64.S
> @@ -45,7 +45,7 @@ ENTRY(memcpy)
>        /*
>         * Use 32bit CMP here to avoid long NOP padding.
>         */
> -       cmp  $0x20, %edx
> +       cmp  $0x28, %rdx

Well, look above your change. The comment says "Use 32bit CMP".
If you really want to go to 64-bit one, then change comment too.

> +       /*
> +        * We append data to avoid store crossing cache.
> +        */
> +       movq (%rsi), %rcx
> +       movq %rdi, %r8
> +       addq $8, %rdi
> +       andq $-8, %rdi
> +       movq %rcx, (%r8)
> +       subq %rdi, %r8
> +       addq %r8, %rdx
> +       subq %r8, %rsi

The comment doesn't really help to understand what you are doing here.
Maybe "Align store location to 32 bytes to avoid crossing cachelines"?

>        /*
> -        * At most 3 ALU operations in one cycle,
> -        * so append NOPS in the same 16bytes trunk.
> +        * We append data to avoid store crossing cache.
>         */

Same here.

-- 
vda
