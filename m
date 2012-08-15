Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511Ab2HONDw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 09:03:52 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:63916 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754378Ab2HONDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 09:03:51 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v2 03/31] arm64: Exception handling
Date: Wed, 15 Aug 2012 13:03:47 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com> <1344966752-16102-4-git-send-email-catalin.marinas@arm.com>
In-Reply-To: <1344966752-16102-4-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1252"
Content-Transfer-Encoding: 7bit
Message-Id: <201208151303.47743.arnd@arndb.de>
X-Provags-ID: V02:K0:PnpsQ9C+kdtSV66jYbszAKunzobxL9X4YB/HWxD7IF7
 5RLDBsT5LM+eQewNNZj4OVHXhckSUvE4ufg49KyXNYtlgajteG
 HCP7kYhupoXz8vLXERbJbN98PNt1tMDh5V5Fu5uCGDhDIoL0hL
 zxg8bO3f86Uo7mHRVn+jqmdO36PtrocNxlYaPd5FvH8YJsZ7JP
 u70WhX9tX9TsASKPYRhvz/mPMA9380JsHm5CO0wBe/pzDGakDx
 4K6Q7H2aTZoiN85zSXyTQwfq1fwLZnioncgYn06gVdQzlrybs3
 QALFOcM5P7ijdoCBe/XgoP+CiUtuu4IWjzKSRPyTDH4piL5aE1
 QtwZTYd23Fv5EK5WqHJU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 14 August 2012, Catalin Marinas wrote:

> +#ifdef CONFIG_AARCH32_EMULATION
> +#define compat_thumb_mode(regs) \
> +	(((regs)->pstate & COMPAT_PSR_T_BIT))
> +#else
> +#define compat_thumb_mode(regs) (0)
> +#endif

The symbol we use on other platforms is CONFIG_COMPAT. I don't think you
need to have a separate CONFIG_AARCH32_EMULATION

> +void __bad_xchg(volatile void *ptr, int size)
> +{
> +	printk("xchg: bad data size: pc 0x%p, ptr 0x%p, size %d\n",
> +		__builtin_return_address(0), ptr, size);
> +	BUG();
> +}
> +EXPORT_SYMBOL(__bad_xchg);
> +

I think we're better off not defining this function. My guess is that
initially the idea on ARM was that it was meant as a BUILD_BUG_ON
replacement, but the someone added this function. And you copied it.

Microblaze has the same declaration, but (correctly) misses the
definition, which produces a much more helpful link failure than
a run-time BUG(). Using BUILD_BUG_ON would be even better.

	Arnd
