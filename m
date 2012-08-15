Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755045Ab2HOOuH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 10:50:07 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:49702 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754690Ab2HOOuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 10:50:01 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v2 20/31] arm64: User access library function
Date: Wed, 15 Aug 2012 14:49:54 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com> <1344966752-16102-21-git-send-email-catalin.marinas@arm.com>
In-Reply-To: <1344966752-16102-21-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1252"
Content-Transfer-Encoding: 7bit
Message-Id: <201208151449.54834.arnd@arndb.de>
X-Provags-ID: V02:K0:r0CrVWVIim3iiF5eBAVHTBRgk18eh/vaEbAwQSWHnDQ
 xsNBjCs7Wnc19/Ks6t6rDqZvfUtiGHbivXmVsVAV1dcrGoGx7P
 27orDe+7y4jleJyC3jxGzZWJMSlNwv0LmtS74cK20/S8T8G3DS
 Q5q2th9zuV2EYeSRIbZUsazNedl4nw2entvbSBg7cBb0WVx9OM
 PKXdjPQAKNlIaPBXqOWlliivV9+a+LjLkYUBxfRVLN6eIdleWZ
 poSSUExK8hyp1F4ol1L9CId+cp2IC6nQCj/6R4MqbN0EuwkzAo
 eTRdLPmtrLOB2gqkD5tVxshDMl02mehYV/JY7496UVBdSqpKhA
 uHPX1fpwbsH8NJ9EZ5yA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 14 August 2012, Catalin Marinas wrote:

> +/*
> + * Single-value transfer routines.  They automatically use the right
> + * size if we just have the right pointer type.  Note that the functions
> + * which read from user space (*get_*) need to take care not to leak
> + * kernel data even if the calling code is buggy and fails to check
> + * the return value.  This means zeroing out the destination variable
> + * or buffer on error.  Normally this is done out of line by the
> + * fixup code, but there are a few places where it intrudes on the
> + * main code path.  When we only write to user space, there is no
> + * problem.
> + */
> +extern long __get_user_1(void *);
> +extern long __get_user_2(void *);
> +extern long __get_user_4(void *);
> +extern long __get_user_8(void *);
> +
> +#define __get_user_x(__r2,__p,__e,__s,__i...)				\
> +	   asm volatile(						\
> +		__asmeq("%0", "x0") __asmeq("%1", "x2")			\
> +		"bl	__get_user_" #__s				\
> +		: "=&r" (__e), "=r" (__r2)				\
> +		: "0" (__p)						\
> +		: __i, "cc")
> +
> +#define get_user(x,p)							\
> +	({								\
> +		register const typeof(*(p)) __user *__p asm("x0") = (p);\
> +		register unsigned long __r2 asm("x2");			\
> +		register long __e asm("x0");				\
> +		switch (sizeof(*(__p))) {				\
> +		case 1:							\
> +			__get_user_x(__r2, __p, __e, 1, "x30");		\
> +			break;						\
> +		case 2:							\
> +			__get_user_x(__r2, __p, __e, 2, "x3", "x30");	\
> +			break;						\
> +		case 4:							\
> +			__get_user_x(__r2, __p, __e, 4, "x30");		\
> +			break;						\
> +		case 8:							\
> +			__get_user_x(__r2, __p, __e, 8, "x30");		\
> +			break;						\
> +		default: __e = __get_user_bad(); break;			\
> +		}							\
> +		x = (typeof(*(p))) __r2;				\
> +		__e;							\
> +	})

It's fairly unusual to have out of line get_user/put_user functions.
What is the reason for this, other than copying from ARM?

> +
> +__get_user_bad:
> +	mov	x2, #0
> +	mov	x0, #-EFAULT
> +	ret
> +ENDPROC(__get_user_bad)

> +__put_user_bad:
> +	mov	x0, #-EFAULT
> +	ret
> +ENDPROC(__put_user_bad)
> +

The purpose of these symbols is to provoke a link error when you
pass the wrong data into get_user/put_user. Actually defining them
completely breaks this logic, so you should remove these!

	Arnd
