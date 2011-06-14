Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019Ab1FNVQ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 17:16:28 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35952 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753303Ab1FNVQZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 17:16:25 -0400
Date: Tue, 14 Jun 2011 23:16:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andy Lutomirski <luto@MIT.EDU>
Cc: Rakib Mullick <rakib.mullick@gmail.com>, hpa@zytor.com, tglx@linutronix.de,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86, vsyscall: Fix build warning in vsyscall_64.c
Message-ID: <20110614211613.GB12249@elte.hu>
References: <1307777464.25182.3.camel@localhost.localdomain>
 <BANLkTi=SQb6EL4+bdH2Q+iwaW9E3i+48Ew@mail.gmail.com>
 <BANLkTi=yEo9fcXW8SqUCtSOag7Mn_+Ni9Q@mail.gmail.com>
 <BANLkTimv6F8NsH0Lg7q6gi1-oiBv8nUrSA@mail.gmail.com>
 <BANLkTikbnsu05+Nae8isATuZ8Fucj14+LQ@mail.gmail.com>
 <BANLkTi=nsCK2bFf2v+PkKj=Opsxseqe9pQ@mail.gmail.com>
 <BANLkTi=ZETGToRcOHXg5gxAQO3EKN+YyLg@mail.gmail.com>
 <BANLkTi=-xJizWP5H9vNvaJhRN-Vm-ubraA@mail.gmail.com>
 <4DF7A264.3030901@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DF7A264.3030901@mit.edu>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andy Lutomirski <luto@MIT.EDU> wrote:

> Aha!  You have CONFIG_BUG=n.  I'm not sure that fixing warnings for
> that case is worth it (or is even a good idea).

Especially since the warning is correct, CONFIG_BUG=n is mortally 
broken!

A BUG() turned into NOP is 100% evil, full stop.

> Can you try this patch, though:
> 
> Signed-off-by: Andy Lutomirski <luto@mit.edu>
> 
> diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
> index dfb0ec6..f4083f4 100644
> --- a/include/asm-generic/bug.h
> +++ b/include/asm-generic/bug.h
> @@ -107,11 +107,11 @@ extern void warn_slowpath_null(const char
> *file, const int line);
> 
>  #else /* !CONFIG_BUG */
>  #ifndef HAVE_ARCH_BUG
> -#define BUG() do {} while(0)
> +#define BUG() do { unreachable(); } while(0)
>  #endif
> 
>  #ifndef HAVE_ARCH_BUG_ON
> -#define BUG_ON(condition) do { if (condition) ; } while(0)
> +#define BUG_ON(condition) do { if (condition) unreachable(); } while(0)
>  #endif
> 
>  #ifndef HAVE_ARCH_WARN_ON
> 
> It may silence a lot of warnings, although it'll come at a cost of
> increased code size with CONFIG_BUG=n on older gcc.  On newer GCC,
> you'll get possibly faster and smaller code.

I sent such a patch ages ago but was shouted down by 'this will 
increase code size'.

I think correctness trumps code size and turning BUG() and BUG_ON() 
into a NOP is just crazy ...

Thanks,

	Ingo
