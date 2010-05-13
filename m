Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758823Ab0EML7Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 07:59:16 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61876 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753020Ab0EML7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 07:59:13 -0400
Message-ID: <4BEBE961.2040501@monstr.eu>
Date: Thu, 13 May 2010 13:58:25 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: "Steven J. Magnani" <steve@digidescorp.com>
CC: microblaze-uclinux@itee.uq.edu.au, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] microblaze: fix get_user/put_user side-effects
References: <1273181913-888-1-git-send-email-steve@digidescorp.com>
In-Reply-To: <1273181913-888-1-git-send-email-steve@digidescorp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven J. Magnani wrote:
> The Microblaze implementations of get_user() and (MMU) put_user() evaluate 
> the address argument more than once. This causes unexpected side-effects for
> invocations that include increment operators, i.e. get_user(foo, bar++).
> 
> This patch also removes the distinction between MMU and noMMU put_user().
> 
> Without the patch:
>   $ echo 1234567890 > /proc/sys/kernel/core_pattern
>   $ cat /proc/sys/kernel/core_pattern
>   12345

Applied,

I believe that in future we could use inline function which should solve 
this problem too.

Thanks,
Michal


> 
> Signed-off-by: Steven J. Magnani <steve@digidescorp.com>
> ---
> diff -uprN a/arch/microblaze/include/asm/uaccess.h b/arch/microblaze/include/asm/uaccess.h
> --- a/arch/microblaze/include/asm/uaccess.h	2010-04-27 10:14:33.000000000 -0500
> +++ b/arch/microblaze/include/asm/uaccess.h	2010-05-06 16:21:02.000000000 -0500
> @@ -182,6 +182,39 @@ extern long __user_bad(void);
>   * Returns zero on success, or -EFAULT on error.
>   * On error, the variable @x is set to zero.
>   */
> +#define get_user(x, ptr)						\
> +	__get_user_check((x), (ptr), sizeof(*(ptr)))
> +
> +#define __get_user_check(x, ptr, size)					\
> +({									\
> +	unsigned long __gu_val = 0;					\
> +	const typeof(*(ptr)) __user *__gu_addr = (ptr);			\
> +	int __gu_err = 0;						\
> +									\
> +	if (access_ok(VERIFY_READ, __gu_addr, size)) {			\
> +		switch (size) {						\
> +		case 1:							\
> +			__get_user_asm("lbu", __gu_addr, __gu_val,	\
> +				       __gu_err);			\
> +			break;						\
> +		case 2:							\
> +			__get_user_asm("lhu", __gu_addr, __gu_val,	\
> +				       __gu_err);			\
> +			break;						\
> +		case 4:							\
> +			__get_user_asm("lw", __gu_addr, __gu_val,	\
> +				       __gu_err);			\
> +			break;						\
> +		default:						\
> +			__gu_err = __user_bad();			\
> +			break;						\
> +		}							\
> +	} else {							\
> +		__gu_err = -EFAULT;					\
> +	}								\
> +	x = (typeof(*(ptr)))__gu_val;					\
> +	__gu_err;							\
> +})
>  
>  #define __get_user(x, ptr)						\
>  ({									\
> @@ -206,12 +239,6 @@ extern long __user_bad(void);
>  })
>  
>  
> -#define get_user(x, ptr)						\
> -({									\
> -	access_ok(VERIFY_READ, (ptr), sizeof(*(ptr)))			\
> -		? __get_user((x), (ptr)) : -EFAULT;			\
> -})
> -
>  #define __put_user_asm(insn, __gu_ptr, __gu_val, __gu_err)	\
>  ({								\
>  	__asm__ __volatile__ (					\
> @@ -266,6 +293,42 @@ extern long __user_bad(void);
>   *
>   * Returns zero on success, or -EFAULT on error.
>   */
> +#define put_user(x, ptr)						\
> +	__put_user_check((x), (ptr), sizeof(*(ptr)))
> +
> +#define __put_user_check(x, ptr, size)					\
> +({									\
> +	typeof(*(ptr)) __pu_val;					\
> +	typeof(*(ptr)) __user *__pu_addr = (ptr);			\
> +	int __pu_err = 0;						\
> +									\
> +	__pu_val = (x);							\
> +	if (access_ok(VERIFY_WRITE, __pu_addr, size)) {			\
> +		switch (size) {						\
> +		case 1:							\
> +			__put_user_asm("sb", __pu_addr, __pu_val,	\
> +				       __pu_err);			\
> +			break;						\
> +		case 2:							\
> +			__put_user_asm("sh", __pu_addr, __pu_val,	\
> +				       __pu_err);			\
> +			break;						\
> +		case 4:							\
> +			__put_user_asm("sw", __pu_addr, __pu_val,	\
> +				       __pu_err);			\
> +			break;						\
> +		case 8:							\
> +			__put_user_asm_8(__pu_addr, __pu_val, __pu_err);\
> +			break;						\
> +		default:						\
> +			__pu_err = __user_bad();			\
> +			break;						\
> +		}							\
> +	} else {							\
> +		__pu_err = -EFAULT;					\
> +	}								\
> +	__pu_err;							\
> +})
>  
>  #define __put_user(x, ptr)						\
>  ({									\
> @@ -290,18 +353,6 @@ extern long __user_bad(void);
>  	__gu_err;							\
>  })
>  
> -#ifndef CONFIG_MMU
> -
> -#define put_user(x, ptr)	__put_user((x), (ptr))
> -
> -#else /* CONFIG_MMU */
> -
> -#define put_user(x, ptr)						\
> -({									\
> -	access_ok(VERIFY_WRITE, (ptr), sizeof(*(ptr)))			\
> -		? __put_user((x), (ptr)) : -EFAULT;			\
> -})
> -#endif /* CONFIG_MMU */
>  
>  /* copy_to_from_user */
>  #define __copy_from_user(to, from, n)	\
> 


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
