Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933151Ab0J0NVr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 09:21:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:42532 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757705Ab0J0NVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 09:21:44 -0400
X-Authority-Analysis: v=1.1 cv=NFUeGz0loTdi/T6hXKngYYtckjed7x3pKvNOqmBBK18= c=1 sm=0 a=Uoo-rjBb3gMA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=pGLkceISAAAA:8 a=jEnMGsa9k_QRxKMtkHMA:9 a=DKkHwUe2l3tZksxFhSMA:7 a=gWxUUVEqoajy3rcN417AED3S9ysA:4 a=PUjeQqilurYA:10 a=MSl-tDqOz04A:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] ftrace: Speed up recordmcount
From: Steven Rostedt <rostedt@goodmis.org>
To: Wu Zhangjin <wuzhangjin@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu,
        John Reiser <jreiser@bitwagon.com>, Michal Marek <mmarek@suse.cz>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Sam Ravnborg <sam@ravnborg.org>
In-Reply-To: <f603e1dc44524b81ebc423dd226eb44d837a37be.1288175801.git.wuzhangjin@gmail.com>
References: <f603e1dc44524b81ebc423dd226eb44d837a37be.1288175801.git.wuzhangjin@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 27 Oct 2010 09:21:40 -0400
Message-ID: <1288185700.18238.117.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Added kbuild maintainers ]

On Wed, 2010-10-27 at 18:39 +0800, Wu Zhangjin wrote:
> From: Wu Zhangjin <wuzhangjin@gmail.com>
> 
> cmd_record_mcount is only needed for the targets who are compiled with
> -pg, so, only define it when CONFIG_FTRACE_MCOUNT_RECORD is defined and
> only use it for the targets who are compiled with -pg.

Thanks! I was going to do this myself, but just have not gotten around
to it.

> 
> Signed-off-by: Wu Zhangjin <wuzhangjin@gmail.com>

I need a SoB from Michal to apply it.

> ---
>  Makefile               |   11 ++++++++---
>  scripts/Makefile.build |   26 ++++++++++++++++----------
>  2 files changed, 24 insertions(+), 13 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index 3e43805..60d7a87 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -576,9 +576,14 @@ endif
>  ifdef CONFIG_FUNCTION_TRACER
>  KBUILD_CFLAGS	+= -pg
>  ifdef CONFIG_DYNAMIC_FTRACE
> -	ifdef CONFIG_HAVE_C_RECORDMCOUNT
> -		BUILD_C_RECORDMCOUNT := y
> -		export BUILD_C_RECORDMCOUNT
> +	ifdef CONFIG_FTRACE_MCOUNT_RECORD

FTRACE_MCOUNT_RECORD depends on DYNAMIC_FTRACE, so if you require
FTRACE_MCOUNT_RECORD, you can remove the ifdef CONFIG_DYNAMIC_FTRACE.


> +		DEFINE_CMD_RECORD_MCOUNT := y
> +		export DEFINE_CMD_RECORD_MCOUNT
> +
> +		ifdef CONFIG_HAVE_C_RECORDMCOUNT
> +			BUILD_C_RECORDMCOUNT := y
> +			export BUILD_C_RECORDMCOUNT
> +		endif
>  	endif
>  endif
>  endif
> diff --git a/scripts/Makefile.build b/scripts/Makefile.build
> index 5ad25e1..ceb5175 100644
> --- a/scripts/Makefile.build
> +++ b/scripts/Makefile.build
> @@ -208,22 +208,28 @@ cmd_modversions =								\
>  	fi;
>  endif
>  
> -ifdef CONFIG_FTRACE_MCOUNT_RECORD
> +ifdef DEFINE_CMD_RECORD_MCOUNT
>  ifdef BUILD_C_RECORDMCOUNT
>  # Due to recursion, we must skip empty.o.
>  # The empty.o file is created in the make process in order to determine
>  #  the target endianness and word size. It is made before all other C
>  #  files, including recordmcount.
> -cmd_record_mcount = if [ $(@) != "scripts/mod/empty.o" ]; then			\
> -			$(objtree)/scripts/recordmcount "$(@)";			\
> -		    fi;
> +cmd_record_mcount =							\
> +	if [ "$(findstring -pg,$(KBUILD_CFLAGS))" == "-pg" ]; then	\
> +		if [ $(@) != "scripts/mod/empty.o" ]; then		\
> +			$(objtree)/scripts/recordmcount "$(@)";		\
> +		fi;							\
> +	fi;
>  else
> -cmd_record_mcount = set -e ; perl $(srctree)/scripts/recordmcount.pl "$(ARCH)" \
> -	"$(if $(CONFIG_CPU_BIG_ENDIAN),big,little)" \
> -	"$(if $(CONFIG_64BIT),64,32)" \
> -	"$(OBJDUMP)" "$(OBJCOPY)" "$(CC) $(KBUILD_CFLAGS)" \
> -	"$(LD)" "$(NM)" "$(RM)" "$(MV)" \
> -	"$(if $(part-of-module),1,0)" "$(@)";
> +cmd_record_mcount = 							\
> +	if [ "$(findstring -pg,$(KBUILD_CFLAGS))" == "-pg" ]; then	\
> +		set -e ; perl $(srctree)/scripts/recordmcount.pl "$(ARCH)" \
> +		"$(if $(CONFIG_CPU_BIG_ENDIAN),big,little)" 		\
> +		"$(if $(CONFIG_64BIT),64,32)" 				\
> +		"$(OBJDUMP)" "$(OBJCOPY)" "$(CC) $(KBUILD_CFLAGS)" 	\
> +		"$(LD)" "$(NM)" "$(RM)" "$(MV)" 			\
> +		"$(if $(part-of-module),1,0)" "$(@)";			\
> +	fi;
>  endif
>  endif
>  


Note, this does not catch objects that have the -pg stripped by
CFLAGS_REMOVE_object.o


How about something like this:

ifdef DEFINE_CMD_RECORD_MCOUNT
ifdef BUILD_C_RECORDMCOUNT
sub_cmd_record_mcount = if [ $(@) != "scripts/mod/empty.o" ]; then		\
			$(objtree)/scripts/recordmcount "$(@)";			\
		    fi;
else
sub_cmd_record_mcount = set -e ; perl $(srctree)/scripts/recordmcount.pl "$(ARCH)" \
	"$(if $(CONFIG_CPU_BIG_ENDIAN),big,little)"			\
	"$(if $(CONFIG_64BIT),64,32)"					\
	"$(OBJDUMP)" "$(OBJCOPY)" "$(CC) $(KBUILD_CFLAGS)"		\
	"$(LD)" "$(NM)" "$(RM)" "$(MV)"					\
	"$(if $(part-of-module),1,0)" "$(@)";
endif
cmd_record_mcount =							\
	if [ "$(findstring -pg, $(_c_flags))" == "-pg" ]; then		\
		$(sub_cmd_record_mcount)				\
	fi;
endif


I tested the above and it seemed to work (although, I did it on another
machine, and copied it here by hand, so this version may have a typo).

-- Steve


