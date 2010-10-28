Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932735Ab0J1CVY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 22:21:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:56358 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932457Ab0J1CVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 22:21:20 -0400
X-Authority-Analysis: v=1.1 cv=kXGwZUU/u1JTMRv8Axk4W0omja+vfTT+sGlOkodD8F8= c=1 sm=0 a=wSgS5G9fFx4A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=pGLkceISAAAA:8 a=meVymXHHAAAA:8 a=QfZ8UanS6Nfu2vkQX1EA:9 a=7vt5-eNVHPJtrb_7jNEA:7 a=NQEy_a9w6O533b2E92-TZbWZ1TsA:4 a=PUjeQqilurYA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [v2 PATCH] ftrace: Speed up recordmcount
From: Steven Rostedt <rostedt@goodmis.org>
To: Wu Zhangjin <wuzhangjin@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu,
        John Reiser <jreiser@bitwagon.com>, Sam Ravnborg <sam@ravnborg.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Michal Marek <mmarek@suse.cz>
In-Reply-To: <3dc8cddf022eb7024f9f2cf857529a15bee8999a.1288196498.git.wuzhangjin@gmail.com>
References: <3dc8cddf022eb7024f9f2cf857529a15bee8999a.1288196498.git.wuzhangjin@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 27 Oct 2010 22:21:18 -0400
Message-ID: <1288232478.18238.138.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal,

Can you give an Acked-by: on this patch?

Thanks!

-- Steve


On Thu, 2010-10-28 at 00:24 +0800, Wu Zhangjin wrote:
> From: Wu Zhangjin <wuzhangjin@gmail.com>
> 
> cmd_record_mcount is used to locate the _mcount symbols in the object
> files, only the files compiled with -pg has the _mcount symbol, so, it
> is only needed for such files, but the current cmd_record_mcount is used
> for all of the object files, so, we need to fix it and speed it up.
> 
> Since -pg may be removed by the method used in kernel/trace/Makefile:
> 
> ORIG_CFLAGS := $(KBUILD_CFLAGS)
> KBUILD_CFLAGS = $(subst -pg,,$(ORIG_CFLAGS))
> 
> Or may be removed by the method used in arch/x86/kernel/Makefile:
> 
> CONFIG_REMOVE_file.o = -pg
> 
> So, we must check the last variable stores the compiling flags, that is
> c_flags(Please refer to cmd_cc_o_c and rule_cc_o_c defined in
> scripts/Makefile.build) and since the CFLAGS_REMOVE_file.o is already
> filtered in _c_flags(Please refer to scripts/Makefile.lib) and _c_flags
> has less symbols, therefore, we only need to check _c_flags.
> 
> ---------------
> Changes from v1:
> 
>   o Don't touch Makefile for CONFIG_FTRACE_MCOUNT_RECORD is enough
>   o Use _c_flags intead of KBUILD_CFLAGS to cover CONFIG_REMOVE_file.o = -pg
>   (feedback from Steven Rostedt <rostedt@goodmis.org>)
> 
> Signed-off-by: Wu Zhangjin <wuzhangjin@gmail.com>
> ---
>  scripts/Makefile.build |   13 +++++++++----
>  1 files changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/scripts/Makefile.build b/scripts/Makefile.build
> index 5ad25e1..0ad6108 100644
> --- a/scripts/Makefile.build
> +++ b/scripts/Makefile.build
> @@ -214,17 +214,22 @@ ifdef BUILD_C_RECORDMCOUNT
>  # The empty.o file is created in the make process in order to determine
>  #  the target endianness and word size. It is made before all other C
>  #  files, including recordmcount.
> -cmd_record_mcount = if [ $(@) != "scripts/mod/empty.o" ]; then			\
> -			$(objtree)/scripts/recordmcount "$(@)";			\
> -		    fi;
> +sub_cmd_record_mcount =					\
> +	if [ $(@) != "scripts/mod/empty.o" ]; then	\
> +		$(objtree)/scripts/recordmcount "$(@)";	\
> +	fi;
>  else
> -cmd_record_mcount = set -e ; perl $(srctree)/scripts/recordmcount.pl "$(ARCH)" \
> +sub_cmd_record_mcount = set -e ; perl $(srctree)/scripts/recordmcount.pl "$(ARCH)" \
>  	"$(if $(CONFIG_CPU_BIG_ENDIAN),big,little)" \
>  	"$(if $(CONFIG_64BIT),64,32)" \
>  	"$(OBJDUMP)" "$(OBJCOPY)" "$(CC) $(KBUILD_CFLAGS)" \
>  	"$(LD)" "$(NM)" "$(RM)" "$(MV)" \
>  	"$(if $(part-of-module),1,0)" "$(@)";
>  endif
> +cmd_record_mcount = 						\
> +	if [ "$(findstring -pg,$(_c_flags))" == "-pg" ]; then	\
> +		$(sub_cmd_record_mcount)			\
> +	fi;
>  endif
>  
>  define rule_cc_o_c


