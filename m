Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751850Ab2HSI0L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 04:26:11 -0400
Received: from claw.goop.org ([74.207.240.146]:38728 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750791Ab2HSI0F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 04:26:05 -0400
Message-ID: <5030A31B.3060908@goop.org>
Date: Sun, 19 Aug 2012 01:26:03 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org, x86@kernel.org, mmarek@suse.cz,
        linux-kbuild@vger.kernel.org, JBeulich@suse.com,
        akpm@linux-foundation.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 52/74] x86, lto, paravirt: Don't rely on local assembler
 labels
References: <1345345030-22211-1-git-send-email-andi@firstfloor.org> <1345345030-22211-53-git-send-email-andi@firstfloor.org>
In-Reply-To: <1345345030-22211-53-git-send-email-andi@firstfloor.org>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/18/2012 07:56 PM, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
>
> The paravirt patching code assumes that it can reference a
> local assembler label between two different top level assembler
> statements. This does not work with some experimental gcc builds,
> where the assembler code may end up in different assembler files.

Egad, what are those zany gcc chaps up to now?

    J

>
> Replace it with extern / global /asm linkage labels.
>
> This also removes one redundant copy of the macro.
>
> Cc: jeremy@goop.org
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  arch/x86/include/asm/paravirt_types.h |    9 +++++----
>  arch/x86/kernel/paravirt.c            |    5 -----
>  2 files changed, 5 insertions(+), 9 deletions(-)
>
> diff --git a/arch/x86/include/asm/paravirt_types.h b/arch/x86/include/asm/paravirt_types.h
> index 4f262bc..6a464ba 100644
> --- a/arch/x86/include/asm/paravirt_types.h
> +++ b/arch/x86/include/asm/paravirt_types.h
> @@ -385,10 +385,11 @@ extern struct pv_lock_ops pv_lock_ops;
>  	_paravirt_alt(insn_string, "%c[paravirt_typenum]", "%c[paravirt_clobber]")
>  
>  /* Simple instruction patching code. */
> -#define DEF_NATIVE(ops, name, code) 					\
> -	extern const char start_##ops##_##name[] __visible, 		\
> -			  end_##ops##_##name[] __visible;		\
> -	asm("start_" #ops "_" #name ": " code "; end_" #ops "_" #name ":")
> +#define NATIVE_LABEL(a,x,b) "\n\t.globl " a #x "_" #b "\n" a #x "_" #b ":\n\t"
> +
> +#define DEF_NATIVE(ops, name, code)					\
> +	__visible extern const char start_##ops##_##name[], end_##ops##_##name[];	\
> +	asm(NATIVE_LABEL("start_", ops, name) code NATIVE_LABEL("end_", ops, name))
>  
>  unsigned paravirt_patch_nop(void);
>  unsigned paravirt_patch_ident_32(void *insnbuf, unsigned len);
> diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
> index 17fff18..947255e 100644
> --- a/arch/x86/kernel/paravirt.c
> +++ b/arch/x86/kernel/paravirt.c
> @@ -62,11 +62,6 @@ void __init default_banner(void)
>  	       pv_info.name);
>  }
>  
> -/* Simple instruction patching code. */
> -#define DEF_NATIVE(ops, name, code)					\
> -	extern const char start_##ops##_##name[], end_##ops##_##name[];	\
> -	asm("start_" #ops "_" #name ": " code "; end_" #ops "_" #name ":")
> -
>  /* Undefined instruction for dealing with missing ops pointers. */
>  static const unsigned char ud2a[] = { 0x0f, 0x0b };
>  

