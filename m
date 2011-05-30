Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032Ab1E3HvT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 03:51:19 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:52403 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165Ab1E3HvR convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:11:1>);
	Mon, 30 May 2011 03:51:17 -0400
Message-Id: <4DE3688D020000780004427E@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Mon, 30 May 2011 08:51:09 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Andy Lutomirski" <luto@MIT.EDU>
Cc: "Borislav Petkov" <bp@alien8.de>, "Jesper Juhl" <jj@chaosbits.net>,
        "richard -rw- weinberger" <richard.weinberger@gmail.com>,
        "Arjan van de Ven" <arjan@infradead.org>,
        "Mikael Pettersson" <mikpe@it.uu.se>, <x86@kernel.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 08/10] x86-64: Emulate vsyscalls
References: <cover.1306724657.git.luto@mit.edu><cover.1306724657.git.luto@mit.edu>
 <07445623494a3d9f02581eb06326420f5f443043.1306724657.git.luto@mit.edu>
In-Reply-To: <07445623494a3d9f02581eb06326420f5f443043.1306724657.git.luto@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 30.05.11 at 05:48, Andy Lutomirski <luto@MIT.EDU> wrote:
> This causes vsyscalls to be a little more expensive than real
> syscalls.  Fortunately sensible programs don't use them.

Hmm - weren't vsyscalls there for performance reasons?

Besides that, just a mostly cosmetic remark:

> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -1650,6 +1650,23 @@ config COMPAT_VDSO
>  
>  	  If unsure, say Y.
>  
> +config UNSAFE_VSYSCALLS
> +	def_bool y
> +	prompt "Unsafe fast legacy vsyscalls"
> +	depends on X86_64
> +	---help---
> +	  Legacy user code expects to be able to issue three syscalls
> +	  by calling fixed addresses in kernel space.  If you say N,
> +	  then the kernel traps and emulates these calls.  If you say
> +	  Y, then there is actual executable code at a fixed address
> +	  to implement these calls efficiently.
> +
> +	  On a system with recent enough glibc (probably 2.14 or
> +	  newer) and no static binaries, you can say N without a
> +	  performance penalty to improve security
> +
> +	  If unsure, say Y.
> +
>  config CMDLINE_BOOL
>  	bool "Built-in kernel command line"
>  	---help---
> --- a/arch/x86/kernel/Makefile
> +++ b/arch/x86/kernel/Makefile
> @@ -42,6 +42,9 @@ obj-$(CONFIG_X86_32)	+= probe_roms_32.o
>  obj-$(CONFIG_X86_32)	+= sys_i386_32.o i386_ksyms_32.o
>  obj-$(CONFIG_X86_64)	+= sys_x86_64.o x8664_ksyms_64.o
>  obj-$(CONFIG_X86_64)	+= syscall_64.o vsyscall_64.o vread_tsc_64.o
> +ifndef CONFIG_UNSAFE_VSYSCALLS
> +	obj-$(CONFIG_X86_64)	+= vsyscall_emu_64.o
> +endif

With the Kconfig dependency on X86_64 above and the new
variable being a boolean one, these three lines can be written
as just

obj-$(CONFIG_UNSAFE_VSYSCALLS) += vsyscall_emu_64.o

Jan

>  obj-y			+= bootflag.o e820.o
>  obj-y			+= pci-dma.o quirks.o topology.o kdebugfs.o
>  obj-y			+= alternative.o i8253.o pci-nommu.o hw_breakpoint.o


