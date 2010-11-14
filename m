Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520Ab0KNGdy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 01:33:54 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:37930 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707Ab0KNGdw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 01:33:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=SjtZd4jJSlQeG0e3HTgogBc65T8+T/GYtYl37ZQNmAF70Y2NrGpJwqQ+doHztcpNlU
         IsxFN+4GsnyyuizMsnPqL43fu92W5NwFA95pGsEVRsvESRKPCOqbYsq5pZ5Opg3LDEpa
         WVHIEDhJ+Efd5FEMVIbFn4M96IgxAauUzo1s4=
MIME-Version: 1.0
In-Reply-To: <1289414154-7829-4-git-send-email-kees.cook@canonical.com>
References: <1289414154-7829-1-git-send-email-kees.cook@canonical.com>
	<1289414154-7829-4-git-send-email-kees.cook@canonical.com>
Date: Sat, 13 Nov 2010 22:33:51 -0800
X-Google-Sender-Auth: sabWBxOjHIf3ez2ocN501QPrBrU
Message-ID: <AANLkTi=9gtB8YJX-L41-QRfe7aOvG=S=JkVgfvdEeZ6q@mail.gmail.com>
Subject: Re: [PATCH 3/4] x86: call verify_cpu during 32bit CPU startup
From: Yinghai Lu <yinghai@kernel.org>
To: Kees Cook <kees.cook@canonical.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Pekka Enberg <penberg@kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 10:35 AM, Kees Cook <kees.cook@canonical.com> wrote:
> The XD_DISABLE-clearing side-effect needs to happen for both 32bit
> and 64bit, but the 32bit init routines were not calling verify_cpu()
> yet. This adds that call to gain the side-effect.
>
> The longmode/SSE tests being performed in verify_cpu() need to happen very
> early for 64bit but not for 32bit. Instead of including it in two places
> for 32bit, we can just include it once in arch/x86/kernel/head_32.S.
>
> Signed-off-by: Kees Cook <kees.cook@canonical.com>
> Acked-by: Pekka Enberg <penberg@kernel.org>
> Acked-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
> ---
>  arch/x86/kernel/head_32.S    |    6 ++++++
>  arch/x86/kernel/verify_cpu.S |    1 +
>  2 files changed, 7 insertions(+), 0 deletions(-)
>
> diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
> index bcece91..fdaea52 100644
> --- a/arch/x86/kernel/head_32.S
> +++ b/arch/x86/kernel/head_32.S
> @@ -314,6 +314,10 @@ ENTRY(startup_32_smp)
>        subl $0x80000001, %eax
>        cmpl $(0x8000ffff-0x80000001), %eax
>        ja 6f
> +
> +       /* Clear bogus XD_DISABLE bits */
> +       call verify_cpu
> +
>        mov $0x80000001, %eax
>        cpuid
>        /* Execute Disable bit supported? */
> @@ -609,6 +613,8 @@ ignore_int:
>  #endif
>        iret
>
> +#include "verify_cpu.S"
> +
>        __REFDATA
>  .align 4
>  ENTRY(initial_code)
> diff --git a/arch/x86/kernel/verify_cpu.S b/arch/x86/kernel/verify_cpu.S
> index ccb4136..5644b4b 100644
> --- a/arch/x86/kernel/verify_cpu.S
> +++ b/arch/x86/kernel/verify_cpu.S
> @@ -19,6 +19,7 @@
>  *
>  *     arch/x86_64/boot/compressed/head_64.S: Boot cpu verification
>  *     arch/x86_64/kernel/trampoline_64.S: secondary processor verfication
> + *     arch/x86_64/kernel/head_32.S: processor startup

should change those x86_64 to x86.

Yinghai
