Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754910Ab2BXOYO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 09:24:14 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:59616 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753876Ab2BXOYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 09:24:11 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: James Hogan <james.hogan@imgtec.com>
Subject: Re: [RFC] [PATCH] asm-generic/unistd.h: handle symbol prefixes in cond_syscall
Date: Fri, 24 Feb 2012 14:24:07 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, "linux-kernel" <linux-kernel@vger.kernel.org>
References: <4F47981F.4020305@imgtec.com>
In-Reply-To: <4F47981F.4020305@imgtec.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201202241424.07319.arnd@arndb.de>
X-Provags-ID: V02:K0:00Yap2Tdzqy2TXIBaKQan5QeilUhFR2TWpzT0fCWyqp
 +6eB10Yt59CDbVtCrv4z6Va4GAM7fYjy+OK5sZbiSjrsK1wQBw
 Iyvf847HXOqHI0082TnoKlO3B347Lv54qIYRdkXIkF8sHJEuza
 eouGTfTtpRlDYHKYgFmAS/obaBNaBbYOtIQfOYDORIH6UNegfu
 inKYTKubBxidft+b7RxIUmBmgzI6YJ3j4gU1IsiA7rGE4RRnO6
 kttzbWhHYGnTNilKS+f+7y+V7vYOfPeBmq8FvX33OlbK0+tj0F
 wZzZNcHcEqH5r+TR56gmGvftyBgHzzok3rT88teQ3EzjNJ1K40
 uft8r1PX7wcseEHxiB/w=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 24 February 2012, James Hogan wrote:
> Some architectures have symbol prefixes and set CONFIG_SYMBOL_PREFIX,
> but this wasn't taken into account by the generic cond_syscall. It's
> easy enough to fix in a generic fashion, so add the symbol prefix to
> symbol names in cond_syscall when CONFIG_SYMBOL_PREFIX is set.
> 
> Signed-off-by: James Hogan <james.hogan@imgtec.com>
> ---
>  include/asm-generic/unistd.h |    9 ++++++++-
>  1 files changed, 8 insertions(+), 1 deletions(-)
> 
> diff --git a/include/asm-generic/unistd.h b/include/asm-generic/unistd.h
> index 2292d1a..c9a5ba4 100644
> --- a/include/asm-generic/unistd.h
> +++ b/include/asm-generic/unistd.h
> @@ -924,7 +924,14 @@ __SYSCALL(__NR_fork, sys_ni_syscall)
>   * but it doesn't work on all toolchains, so we just do it by hand
>   */
>  #ifndef cond_syscall
> -#define cond_syscall(x) asm(".weak\t" #x "\n\t.set\t" #x ",sys_ni_syscall")
> +#ifdef CONFIG_SYMBOL_PREFIX
> +#define __SYMBOL_PREFIX CONFIG_SYMBOL_PREFIX
> +#else
> +#define __SYMBOL_PREFIX
> +#endif
> +#define cond_syscall(x) asm(".weak\t" __SYMBOL_PREFIX #x "\n\t" \
> +                           ".set\t" __SYMBOL_PREFIX #x "," \
> +                           __SYMBOL_PREFIX "sys_ni_syscall")
>  #endif

Our trend is to move away from arch specific Kconfig symbols and __ARCH_HAS_*
macros towards just defining whatever you need in the architecture as an
override for the generic definition.

Just provide your own unistd.h that does

#define cond_syscall(x) asm(".weak\t." #x "\n\t.set\t." #x ",.sys_ni_syscall")
#include <asm-generic/unistd.h>

BTW, are you planning to submit arch/metag for inclusion? I've looked at
the code recently and it appears that you are on the right track overall,
and it shouldn't be too hard to get to the same quality level as
arch/openrisc.

	Arnd
