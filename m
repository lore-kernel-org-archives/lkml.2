Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755737Ab1EQQKc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 12:10:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:61651 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755327Ab1EQQKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 12:10:30 -0400
X-Authority-Analysis: v=1.1 cv=ou1QuR4lBR9YeJgEH9ccYmbAdaWqVVq3lOvCKJtMpGM= c=1 sm=0 a=uB6k01T4ArMA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=3BqYBvgPIVVOpVBZBCcA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] ftrace: recordmcount: avoid STT_FUNC symbols as base
 on ARM
From: Steven Rostedt <rostedt@goodmis.org>
To: Russell King <rmk@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Rabin Vincent <rabin@rab.in>
In-Reply-To: <1305134631-31617-1-git-send-email-rabin@rab.in>
References: <1305134631-31617-1-git-send-email-rabin@rab.in>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 17 May 2011 12:10:29 -0400
Message-ID: <1305648629.5456.744.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-11 at 22:53 +0530, Rabin Vincent wrote:
> While find_secsym_ndx often finds the unamed local STT_SECTION, if a
> section has only one function in it, the ARM toolchain generates the
> STT_FUNC symbol before the STT_SECTION, and recordmcount finds this
> instead.
> 
> This is problematic on ARM because in ARM ELFs, "if a [STT_FUNC] symbol
> addresses a Thumb instruction, its value is the address of the
> instruction with bit zero set (in a relocatable object, the section
> offset with bit zero set)".  This leads to incorrect mcount addresses
> being recorded.
> 
> Fix this by not using STT_FUNC symbols as the base on ARM.

Hi Russell,

Can you give me an Acked-by on this patch?

Thanks,

-- Steve

> 
> Signed-off-by: Rabin Vincent <rabin@rab.in>
> ---
>  scripts/recordmcount.h |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/scripts/recordmcount.h b/scripts/recordmcount.h
> index baf187b..0e2944a 100644
> --- a/scripts/recordmcount.h
> +++ b/scripts/recordmcount.h
> @@ -39,6 +39,7 @@
>  #undef ELF_R_INFO
>  #undef Elf_r_info
>  #undef ELF_ST_BIND
> +#undef ELF_ST_TYPE
>  #undef fn_ELF_R_SYM
>  #undef fn_ELF_R_INFO
>  #undef uint_t
> @@ -68,6 +69,7 @@
>  # define ELF_R_INFO		ELF64_R_INFO
>  # define Elf_r_info		Elf64_r_info
>  # define ELF_ST_BIND		ELF64_ST_BIND
> +# define ELF_ST_TYPE		ELF64_ST_TYPE
>  # define fn_ELF_R_SYM		fn_ELF64_R_SYM
>  # define fn_ELF_R_INFO		fn_ELF64_R_INFO
>  # define uint_t			uint64_t
> @@ -96,6 +98,7 @@
>  # define ELF_R_INFO		ELF32_R_INFO
>  # define Elf_r_info		Elf32_r_info
>  # define ELF_ST_BIND		ELF32_ST_BIND
> +# define ELF_ST_TYPE		ELF32_ST_TYPE
>  # define fn_ELF_R_SYM		fn_ELF32_R_SYM
>  # define fn_ELF_R_INFO		fn_ELF32_R_INFO
>  # define uint_t			uint32_t
> @@ -333,6 +336,11 @@ static unsigned find_secsym_ndx(unsigned const txtndx,
>  		if (txtndx == w2(symp->st_shndx)
>  			/* avoid STB_WEAK */
>  		    && (STB_LOCAL == st_bind || STB_GLOBAL == st_bind)) {
> +			/* function symbols on ARM have quirks, avoid them */
> +			if (w2(ehdr->e_machine) == EM_ARM
> +			    && ELF_ST_TYPE(symp->st_info) == STT_FUNC)
> +				continue;
> +
>  			*recvalp = _w(symp->st_value);
>  			return symp - sym0;
>  		}


