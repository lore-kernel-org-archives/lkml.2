Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754259Ab2LJKNF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 05:13:05 -0500
Received: from multi.imgtec.com ([194.200.65.239]:56885 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753825Ab2LJKND (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 05:13:03 -0500
Message-ID: <50C5B5A1.3040801@imgtec.com>
Date: Mon, 10 Dec 2012 10:12:49 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Rusty Russell <rusty@ozlabs.org>
CC: Michal Marek <mmarek@suse.cz>, Takashi Iwai <tiwai@suse.de>,
        David Howells <dhowells@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] MODSIGN: Avoid using .incbin in C source
References: <1354616321-13520-2-git-send-email-mmarek@suse.cz> <1354616321-13520-1-git-send-email-mmarek@suse.cz> <22396.1354645048@warthog.procyon.org.uk> <87hao1gyiv.fsf@rustcorp.com.au> <s5hobi9aqxs.wl%tiwai@suse.de> <20121205095057.GA26543@sepie.suse.cz> <87zk1qeap3.fsf@rustcorp.com.au>
In-Reply-To: <87zk1qeap3.fsf@rustcorp.com.au>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2012_12_10_10_12_50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/12 04:40, Rusty Russell wrote:
> Michal Marek <mmarek@suse.cz> writes:
>> It looks good, but looking at your patch, I just noticed that we have two
>> versions of the SYMBOL_PREFIX macro in the kernel now:
>>
>> scripts/Makefile.lib has had since some time
>>
>> ifdef CONFIG_SYMBOL_PREFIX
>> _sym_flags = -DSYMBOL_PREFIX=$(patsubst "%",%,$(CONFIG_SYMBOL_PREFIX))
>> _cpp_flags += $(_sym_flags)
>> _a_flags += $(_sym_flags)
>> endif
>>
>> while include/linux/kernel.h now has
>>
>> /* This helps us to avoid #ifdef CONFIG_SYMBOL_PREFIX */
>> #ifdef CONFIG_SYMBOL_PREFIX
>> #define SYMBOL_PREFIX CONFIG_SYMBOL_PREFIX
>> #else
>> #define SYMBOL_PREFIX ""
>> #endif
> 
> What a mess!  AFAICT there's one place which a non-string SYMBOL_PREFIX:
>         include/asm-generic/vmlinux.lds.h
> 
> So we do need it, and the only sane way seems to be via the cmdline and
> the shell usefully stripping quotes as we do.
> 
> So I just took Takashi's do-it-all-in-asm fix, and removed this
> re-definition (we have the same thing, BTW, called
> MODULE_SYMBOL_PREFIX).
> 
> I added a comment about the cmdline SYMBOL_PREFIX, too.
> 
> Thanks,
> Rusty.
> 
> From: Takashi Iwai <tiwai@suse.de>
> Subject: MODSIGN: Avoid using .incbin in C source
> 
> Using the asm .incbin statement in C sources breaks any gcc wrapper which
> assumes that preprocessed C source is self-contained. Use a separate .S
> file to include the siging key and certificate.
> 
> [ This means we no longer need SYMBOL_PREFIX which is defined in kernel.h
>   from cbdbf2abb7844548a7d7a6a2ae7af6b6fbcea401, so I removed it -- RR ]
> 
> Tested-by: Michal Marek <mmarek@suse.cz>
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

Looks good to me.
Acked-by: James Hogan <james.hogan@imgtec.com>

Thanks
James

> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> index 7d8dfc7..a123b13 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -701,13 +701,6 @@ static inline void ftrace_dump(enum ftrace_dump_mode oops_dump_mode) { }
>  #define COMPACTION_BUILD 0
>  #endif
>  
> -/* This helps us to avoid #ifdef CONFIG_SYMBOL_PREFIX */
> -#ifdef CONFIG_SYMBOL_PREFIX
> -#define SYMBOL_PREFIX CONFIG_SYMBOL_PREFIX
> -#else
> -#define SYMBOL_PREFIX ""
> -#endif
> -
>  /* Rebuild everything on CONFIG_FTRACE_MCOUNT_RECORD */
>  #ifdef CONFIG_FTRACE_MCOUNT_RECORD
>  # define REBUILD_DUE_TO_FTRACE_MCOUNT_RECORD
> diff --git a/kernel/Makefile b/kernel/Makefile
> index 86e3285..0bd9d43 100644
> --- a/kernel/Makefile
> +++ b/kernel/Makefile
> @@ -54,7 +54,7 @@ obj-$(CONFIG_DEBUG_SPINLOCK) += spinlock.o
>  obj-$(CONFIG_PROVE_LOCKING) += spinlock.o
>  obj-$(CONFIG_UID16) += uid16.o
>  obj-$(CONFIG_MODULES) += module.o
> -obj-$(CONFIG_MODULE_SIG) += module_signing.o modsign_pubkey.o
> +obj-$(CONFIG_MODULE_SIG) += module_signing.o modsign_pubkey.o modsign_certificate.o
>  obj-$(CONFIG_KALLSYMS) += kallsyms.o
>  obj-$(CONFIG_BSD_PROCESS_ACCT) += acct.o
>  obj-$(CONFIG_KEXEC) += kexec.o
> @@ -139,7 +139,7 @@ ifeq ($(CONFIG_MODULE_SIG),y)
>  extra_certificates:
>  	touch $@
>  
> -kernel/modsign_pubkey.o: signing_key.x509 extra_certificates
> +kernel/modsign_certificate.o: signing_key.x509 extra_certificates
>  
>  ###############################################################################
>  #
> diff --git a/kernel/modsign_certificate.S b/kernel/modsign_certificate.S
> new file mode 100644
> index 0000000..246b4c6
> --- /dev/null
> +++ b/kernel/modsign_certificate.S
> @@ -0,0 +1,19 @@
> +/* SYMBOL_PREFIX defined on commandline from CONFIG_SYMBOL_PREFIX */
> +#ifndef SYMBOL_PREFIX
> +#define ASM_SYMBOL(sym) sym
> +#else
> +#define PASTE2(x,y) x##y
> +#define PASTE(x,y) PASTE2(x,y)
> +#define ASM_SYMBOL(sym) PASTE(SYMBOL_PREFIX, sym)
> +#endif
> +
> +#define GLOBAL(name)	\
> +	.globl ASM_SYMBOL(name);	\
> +	ASM_SYMBOL(name):
> +
> +	.section ".init.data","aw"
> +
> +GLOBAL(modsign_certificate_list)
> +	.incbin "signing_key.x509"
> +	.incbin "extra_certificates"
> +GLOBAL(modsign_certificate_list_end)
> diff --git a/kernel/modsign_pubkey.c b/kernel/modsign_pubkey.c
> index 767e559..045504f 100644
> --- a/kernel/modsign_pubkey.c
> +++ b/kernel/modsign_pubkey.c
> @@ -20,12 +20,6 @@ struct key *modsign_keyring;
>  
>  extern __initdata const u8 modsign_certificate_list[];
>  extern __initdata const u8 modsign_certificate_list_end[];
> -asm(".section .init.data,\"aw\"\n"
> -    SYMBOL_PREFIX "modsign_certificate_list:\n"
> -    ".incbin \"signing_key.x509\"\n"
> -    ".incbin \"extra_certificates\"\n"
> -    SYMBOL_PREFIX "modsign_certificate_list_end:"
> -    );
>  
>  /*
>   * We need to make sure ccache doesn't cache the .o file as it doesn't notice
> 

