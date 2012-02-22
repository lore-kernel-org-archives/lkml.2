Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572Ab2BVXKJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 18:10:09 -0500
Received: from ozlabs.org ([203.10.76.45]:56232 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751066Ab2BVXKH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 18:10:07 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andreas =?utf-8?Q?Bie=C3=9Fmann?= <andreas@biessmann.de>,
        linux-kernel@vger.kernel.org
Cc: Andreas =?utf-8?Q?Bie=C3=9Fmann?= <andreas@biessmann.de>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Jochen Friedrich <jochen@scram.de>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>
Subject: Re: [PATCH] mod/file2alias: make modpost compile on darwin again
In-Reply-To: <1329947735-4331-1-git-send-email-andreas@biessmann.de>
References: <1329947735-4331-1-git-send-email-andreas@biessmann.de>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Thu, 23 Feb 2012 09:38:49 +1030
Message-ID: <874nui5uv2.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Feb 2012 22:55:35 +0100, Andreas Bießmann <andreas@biessmann.de> wrote:
> commit e49ce14150c64b29a8dd211df785576fa19a9858 breaks cross compiling
> the linux kernel on darwin hosts.
> This fix introduce some minimal glue to adopt linker section handling
> for darwin hosts.

Really?

Yes, I assumed an ELF host.  There's a portable way of doing this, but
it's damn ugly (see http://ccodearchive.net/info/autodata.html).

Oh, and checkpatch.pl is wrong, the code was fine.

If noone has strong opinions about this, I'll apply it.  I'm a bit
weirded out though.

Thanks,
Rusty.

> Additionally this patch fixes minor chackpatch warnings introduced by
> mentioned commit.
> 
> Signed-off-by: Andreas Bießmann <andreas@biessmann.de>
> CC: Rusty Russell <rusty@rustcorp.com.au>
> CC: Greg Kroah-Hartman <gregkh@suse.de>
> CC: Jochen Friedrich <jochen@scram.de>
> CC: Samuel Ortiz <sameo@linux.intel.com>
> CC: "K. Y. Srinivasan" <kys@microsoft.com>
> ---
>  scripts/mod/file2alias.c |   37 ++++++++++++++++++++++++++++++++-----
>  1 files changed, 32 insertions(+), 5 deletions(-)
> 
> diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
> index d0de2a2..d2f42eb 100644
> --- a/scripts/mod/file2alias.c
> +++ b/scripts/mod/file2alias.c
> @@ -46,11 +46,37 @@ struct devtable {
>  	void *function;
>  };
>  
> +#define ___cat(a, b) a ## b
> +#define __cat(a, b) ___cat(a, b)
> +
> +/* we need some special handling for this host tool running eventually on
> + * Darwin. The Mach-O section handling is a bit different than ELF section
> + * handling. The differnces in detail are:
> + *  a) we have segments which have sections
> + *  b) we need a API call to get the respective section symbols */
> +#if defined(__MACH__)
> +#include <mach-o/getsect.h>
> +
> +#define INIT_SECTION(name)  do {					\
> +		unsigned long name ## _len;				\
> +		char *__cat(pstart_, name) = getsectdata("__TEXT",	\
> +			#name, &__cat(name, _len));			\
> +		char *__cat(pstop_, name) = __cat(pstart_, name) +	\
> +			__cat(name, _len);				\
> +		__cat(__start_, name) = (void *)__cat(pstart_, name);	\
> +		__cat(__stop_, name) = (void *)__cat(pstop_, name);	\
> +	} while (0)
> +#define SECTION(name)   __attribute__((section("__TEXT, " #name)))
> +
> +struct devtable **__start___devtable, **__stop___devtable;
> +#else
> +#define INIT_SECTION(name) /* no-op for ELF */
> +#define SECTION(name)   __attribute__((section(#name)))
> +
>  /* We construct a table of pointers in an ELF section (pointers generally
>   * go unpadded by gcc).  ld creates boundary syms for us. */
>  extern struct devtable *__start___devtable[], *__stop___devtable[];
> -#define ___cat(a,b) a ## b
> -#define __cat(a,b) ___cat(a,b)
> +#endif /* __MACH__ */
>  
>  #if __GNUC__ == 3 && __GNUC_MINOR__ < 3
>  # define __used			__attribute__((__unused__))
> @@ -60,13 +86,13 @@ extern struct devtable *__start___devtable[], *__stop___devtable[];
>  
>  /* Add a table entry.  We test function type matches while we're here. */
>  #define ADD_TO_DEVTABLE(device_id, type, function) \
> -	static struct devtable __cat(devtable,__LINE__) = {	\
> +	static struct devtable __cat(devtable, __LINE__) = {	\
>  		device_id + 0*sizeof((function)((const char *)NULL,	\
>  						(type *)NULL,		\
>  						(char *)NULL)),		\
>  		sizeof(type), (function) };				\
> -	static struct devtable *__attribute__((section("__devtable"))) \
> -		__used __cat(devtable_ptr,__LINE__) = &__cat(devtable,__LINE__)
> +	static struct devtable *SECTION(__devtable) __used \
> +		__cat(devtable_ptr, __LINE__) = &__cat(devtable, __LINE__)
>  
>  #define ADD(str, sep, cond, field)                              \
>  do {                                                            \
> @@ -1080,6 +1106,7 @@ void handle_moddevtable(struct module *mod, struct elf_info *info,
>  		do_pnp_card_entries(symval, sym->st_size, mod);
>  	else {
>  		struct devtable **p;
> +		INIT_SECTION(__devtable);
>  
>  		for (p = __start___devtable; p < __stop___devtable; p++) {
>  			if (sym_is(name, namelen, (*p)->device_id)) {
> -- 
> 1.7.9.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
