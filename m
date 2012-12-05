Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753683Ab2LEKcS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 05:32:18 -0500
Received: from multi.imgtec.com ([194.200.65.239]:56848 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751971Ab2LEKcQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 05:32:16 -0500
Message-ID: <50BF2262.7080603@imgtec.com>
Date: Wed, 5 Dec 2012 10:30:58 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Michal Marek <mmarek@suse.cz>
CC: Takashi Iwai <tiwai@suse.de>, Rusty Russell <rusty@ozlabs.org>,
        "David Howells" <dhowells@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] MODSIGN: Avoid using .incbin in C source
References: <1354616321-13520-2-git-send-email-mmarek@suse.cz> <1354616321-13520-1-git-send-email-mmarek@suse.cz> <22396.1354645048@warthog.procyon.org.uk> <87hao1gyiv.fsf@rustcorp.com.au> <s5hobi9aqxs.wl%tiwai@suse.de> <20121205095057.GA26543@sepie.suse.cz>
In-Reply-To: <20121205095057.GA26543@sepie.suse.cz>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2012_12_05_10_32_08
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12/12 09:50, Michal Marek wrote:
>> How about the revised patch below?
> [...]
>> diff --git a/kernel/modsign_certificate.S b/kernel/modsign_certificate.S
>> new file mode 100644
>> index 0000000..695d4e3
>> --- /dev/null
>> +++ b/kernel/modsign_certificate.S
>> @@ -0,0 +1,18 @@
>> +#ifndef SYMBOL_PREFIX
>> +#define ASM_SYMBOL(sym) sym
>> +#else
>> +#define PASTE2(x,y) x##y
>> +#define PASTE(x,y) PASTE2(x,y)
>> +#define ASM_SYMBOL(sym) PASTE(SYMBOL_PREFIX, sym)
>> +#endif
> 
> 
> It looks good, but looking at your patch, I just noticed that we have two
> versions of the SYMBOL_PREFIX macro in the kernel now:
> 
> scripts/Makefile.lib has had since some time
> 
> ifdef CONFIG_SYMBOL_PREFIX
> _sym_flags = -DSYMBOL_PREFIX=$(patsubst "%",%,$(CONFIG_SYMBOL_PREFIX))
> _cpp_flags += $(_sym_flags)
> _a_flags += $(_sym_flags)
> endif
> 
> while include/linux/kernel.h now has
> 
> /* This helps us to avoid #ifdef CONFIG_SYMBOL_PREFIX */
> #ifdef CONFIG_SYMBOL_PREFIX
> #define SYMBOL_PREFIX CONFIG_SYMBOL_PREFIX
> #else
> #define SYMBOL_PREFIX ""
> #endif
> 
> So depending on whether you include <linux/kernel.h> or not,
> SYMBOL_PREFIX expands to either a string or a token. James, Rusty, how
> about the patch below? If Takashi's patch is applied first, then
> obviously the modsign_pubkey.c part should be dropped and the ASM_SYMBOL
> definition in modsign_certificate.S can be simplified instead.
> 
> Michal
> 
> From df545c46fb89c085387f4d98c7a4fb06a7f678a9 Mon Sep 17 00:00:00 2001
> From: Michal Marek <mmarek@suse.cz>
> Date: Wed, 5 Dec 2012 10:03:15 +0100
> Subject: [PATCH] linux/kernel.h: Avoid conflicting SYMBOL_PREFIX definition
> 
> scripts/Makefile.lib already defines SYMBOL_PREFIX to the token _ if
> CONFIG_SYMBOL_PREFIX is defined. Drop the string definition in
> linux/kernel.h and change scripts/Makefile.lib to define SYMBOL_PREFIX
> on all architectures.

Hi Michal,

Yeh, that looks good to me, and I like it just being automatically
defined rather than having to include linux/kernel.h (potentially from
low level architecture headers too).

However I think it's unfortunate having to stringify from C as it's
pretty much always required to be in string form when used from a C
file, usually in an asm block. Any objection to defining SYMBOL_PREFIX
with the quotes around it for _c_flags only? E.g. see below

Cheers
James

> diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
> index bdf42fd..1138e77 100644
> --- a/scripts/Makefile.lib
> +++ b/scripts/Makefile.lib
> @@ -119,11 +119,10 @@ _c_flags += $(if $(patsubst n%,, \
>  		$(CFLAGS_GCOV))
>  endif
>  
> -ifdef CONFIG_SYMBOL_PREFIX
>  _sym_flags = -DSYMBOL_PREFIX=$(patsubst "%",%,$(CONFIG_SYMBOL_PREFIX))
> -_cpp_flags += $(_sym_flags)
> +_c_flags += $(_sym_flags)
>  _a_flags += $(_sym_flags)
> -endif
> +_cpp_flags += $(_sym_flags)
>  
>  
>  # If building the kernel in a separate objtree expand all occurrences
> 

How about this instead (i.e. no changes to kernel/modsign_pubkey.c)?

diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index 0be6f11..a76967e 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -119,11 +119,11 @@ _c_flags += $(if $(patsubst n%,, \
 		$(CFLAGS_GCOV))
 endif
 
-ifdef CONFIG_SYMBOL_PREFIX
 _sym_flags = -DSYMBOL_PREFIX=$(patsubst "%",%,$(CONFIG_SYMBOL_PREFIX))
-_cpp_flags += $(_sym_flags)
+_c_sym_flags = -DSYMBOL_PREFIX=\"$(patsubst "%",%,$(CONFIG_SYMBOL_PREFIX))\"
+_c_flags += $(_c_sym_flags)
 _a_flags += $(_sym_flags)
-endif
+_cpp_flags += $(_sym_flags)
 
 
 # If building the kernel in a separate objtree expand all occurrences

