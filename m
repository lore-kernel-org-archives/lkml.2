Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757193Ab1EaPkd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 11:40:33 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52950 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756890Ab1EaPkc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 11:40:32 -0400
Date: Tue, 31 May 2011 17:40:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andy Lutomirski <luto@MIT.EDU>
Cc: x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Jesper Juhl <jj@chaosbits.net>,
        Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Jan Beulich <JBeulich@novell.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Mikael Pettersson <mikpe@it.uu.se>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH v4 09/10] x86-64: Randomize int 0xcc magic al values at
 boot
Message-ID: <20110531154012.GB30353@elte.hu>
References: <cover.1306851090.git.luto@mit.edu>
 <75a00aee647302e22c86a5c5fac0478b9776481a.1306851090.git.luto@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <75a00aee647302e22c86a5c5fac0478b9776481a.1306851090.git.luto@mit.edu>
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

> This is not a security feature.  It's to prevent the int 0xcc
> sequence from becoming ABI.

Hm, what kind of ABI reliance could be built on it?

> +static void __init mangle_vsyscall_movb(void *mapping,
> +					unsigned long movb_addr, u8 initial)
> +{
> +	u8 *imm8;
> +	BUG_ON(movb_addr >= 4095);

Please put newlines after local variable definitions.

>  static int __init vsyscall_init(void)
>  {
> +	extern char __vsyscall_0;

Please don't put extern definitions in the middle of a .c file - if 
then it should be in a .h file. (even if only a single function uses 
it)

> +	/*
> +	 * Randomize the magic al values for int 0xcc invocation.  This
> +	 * isn't really a security feature; it's to make sure that
> +	 * dynamic binary instrumentation tools don't start to think
> +	 * that the int 0xcc magic incantation is ABI.
> +	 */
> +	vsyscall_nr_offset = get_random_int() % 3;
> +	vsyscall_page = pfn_to_page(__pa_symbol(&__vsyscall_0) >> PAGE_SHIFT);
> +	mapping = kmap_atomic(vsyscall_page);
> +	/* It's easier to hardcode the addresses -- they're ABI. */
> +	mangle_vsyscall_movb(mapping, 0, 0xcc);

what about filling it with zeroes?

> +#ifndef CONFIG_UNSAFE_VSYSCALLS
> +	mangle_vsyscall_movb(mapping, 1024, 0xce);
> +#endif
> +	mangle_vsyscall_movb(mapping, 2048, 0xf0);

Dunno, this all looks rather ugly.

Thanks,

	Ingo
