Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932221Ab2E3DIP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 23:08:15 -0400
Received: from dalsmrelay2.nai.com ([205.227.136.216]:26288 "EHLO
	dalsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932184Ab2E3DIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 23:08:13 -0400
Message-ID: <4FC58EDC.6060800@snapgear.com>
Date: Wed, 30 May 2012 13:07:08 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: <linux-m68k@vger.kernel.org>, Greg Ungerer <gerg@uclinux.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] m68k: Use generic strncpy_from_user(), strlen_user(),
 and strnlen_user()
References: <1338327216-15309-1-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1338327216-15309-1-git-send-email-geert@linux-m68k.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

On 30/05/12 07:33, Geert Uytterhoeven wrote:
> Signed-off-by: Geert Uytterhoeven<geert@linux-m68k.org>

Looks good:

Acked-by: Greg Ungerer <gerg@uclinux.org>


> ---
> Do we also want
>
>      select HAVE_EFFICIENT_UNALIGNED_ACCESS if (!COLDFIRE&&  !M68000)

Maybe yes.

Regards
Greg


>   arch/m68k/Kconfig                  |    2 +
>   arch/m68k/include/asm/Kbuild       |    2 +
>   arch/m68k/include/asm/uaccess_mm.h |   11 +++--
>   arch/m68k/lib/uaccess.c            |   74 ------------------------------------
>   4 files changed, 11 insertions(+), 78 deletions(-)
>
> diff --git a/arch/m68k/Kconfig b/arch/m68k/Kconfig
> index cac5b6b..1471201 100644
> --- a/arch/m68k/Kconfig
> +++ b/arch/m68k/Kconfig
> @@ -7,6 +7,8 @@ config M68K
>   	select GENERIC_IRQ_SHOW
>   	select ARCH_HAVE_NMI_SAFE_CMPXCHG if RMW_INSNS
>   	select GENERIC_CPU_DEVICES
> +	select GENERIC_STRNCPY_FROM_USER if MMU
> +	select GENERIC_STRNLEN_USER if MMU
>   	select FPU if MMU
>   	select ARCH_USES_GETTIMEOFFSET if MMU&&  !COLDFIRE
>
> diff --git a/arch/m68k/include/asm/Kbuild b/arch/m68k/include/asm/Kbuild
> index 1a922fa..eafa253 100644
> --- a/arch/m68k/include/asm/Kbuild
> +++ b/arch/m68k/include/asm/Kbuild
> @@ -1,2 +1,4 @@
>   include include/asm-generic/Kbuild.asm
>   header-y += cachectl.h
> +
> +generic-y += word-at-a-time.h
> diff --git a/arch/m68k/include/asm/uaccess_mm.h b/arch/m68k/include/asm/uaccess_mm.h
> index 9c80cd5..472c891 100644
> --- a/arch/m68k/include/asm/uaccess_mm.h
> +++ b/arch/m68k/include/asm/uaccess_mm.h
> @@ -379,12 +379,15 @@ __constant_copy_to_user(void __user *to, const void *from, unsigned long n)
>   #define copy_from_user(to, from, n)	__copy_from_user(to, from, n)
>   #define copy_to_user(to, from, n)	__copy_to_user(to, from, n)
>
> -long strncpy_from_user(char *dst, const char __user *src, long count);
> -long strnlen_user(const char __user *src, long n);
> +#define user_addr_max() \
> +	(segment_eq(get_fs(), USER_DS) ? TASK_SIZE : ~0UL)
> +
> +extern long strncpy_from_user(char *dst, const char __user *src, long count);
> +extern __must_check long strlen_user(const char __user *str);
> +extern __must_check long strnlen_user(const char __user *str, long n);
> +
>   unsigned long __clear_user(void __user *to, unsigned long n);
>
>   #define clear_user	__clear_user
>
> -#define strlen_user(str) strnlen_user(str, 32767)
> -
>   #endif /* _M68K_UACCESS_H */
> diff --git a/arch/m68k/lib/uaccess.c b/arch/m68k/lib/uaccess.c
> index 5664386..5e97f2e 100644
> --- a/arch/m68k/lib/uaccess.c
> +++ b/arch/m68k/lib/uaccess.c
> @@ -104,80 +104,6 @@ unsigned long __generic_copy_to_user(void __user *to, const void *from,
>   EXPORT_SYMBOL(__generic_copy_to_user);
>
>   /*
> - * Copy a null terminated string from userspace.
> - */
> -long strncpy_from_user(char *dst, const char __user *src, long count)
> -{
> -	long res;
> -	char c;
> -
> -	if (count<= 0)
> -		return count;
> -
> -	asm volatile ("\n"
> -		"1:	"MOVES".b	(%2)+,%4\n"
> -		"	move.b	%4,(%1)+\n"
> -		"	jeq	2f\n"
> -		"	subq.l	#1,%3\n"
> -		"	jne	1b\n"
> -		"2:	sub.l	%3,%0\n"
> -		"3:\n"
> -		"	.section .fixup,\"ax\"\n"
> -		"	.even\n"
> -		"10:	move.l	%5,%0\n"
> -		"	jra	3b\n"
> -		"	.previous\n"
> -		"\n"
> -		"	.section __ex_table,\"a\"\n"
> -		"	.align	4\n"
> -		"	.long	1b,10b\n"
> -		"	.previous"
> -		: "=d" (res), "+a" (dst), "+a" (src), "+r" (count), "=&d" (c)
> -		: "i" (-EFAULT), "0" (count));
> -
> -	return res;
> -}
> -EXPORT_SYMBOL(strncpy_from_user);
> -
> -/*
> - * Return the size of a string (including the ending 0)
> - *
> - * Return 0 on exception, a value greater than N if too long
> - */
> -long strnlen_user(const char __user *src, long n)
> -{
> -	char c;
> -	long res;
> -
> -	asm volatile ("\n"
> -		"1:	subq.l	#1,%1\n"
> -		"	jmi	3f\n"
> -		"2:	"MOVES".b	(%0)+,%2\n"
> -		"	tst.b	%2\n"
> -		"	jne	1b\n"
> -		"	jra	4f\n"
> -		"\n"
> -		"3:	addq.l	#1,%0\n"
> -		"4:	sub.l	%4,%0\n"
> -		"5:\n"
> -		"	.section .fixup,\"ax\"\n"
> -		"	.even\n"
> -		"20:	sub.l	%0,%0\n"
> -		"	jra	5b\n"
> -		"	.previous\n"
> -		"\n"
> -		"	.section __ex_table,\"a\"\n"
> -		"	.align	4\n"
> -		"	.long	2b,20b\n"
> -		"	.previous\n"
> -		: "=&a" (res), "+d" (n), "=&d" (c)
> -		: "0" (src), "r" (src));
> -
> -	return res;
> -}
> -EXPORT_SYMBOL(strnlen_user);
> -
> -/*
>    * Zero Userspace
>    */
>


-- 
------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
8 Gardner Close                             FAX:         +61 7 3217 5323
Milton, QLD, 4064, Australia                WEB: http://www.SnapGear.com
