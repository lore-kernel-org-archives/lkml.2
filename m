Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776Ab2JHUnm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 16:43:42 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:55685 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753163Ab2JHUnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 16:43:39 -0400
Date: Mon, 8 Oct 2012 13:43:33 -0700
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Irina Tirdea <irina.tirdea@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        David Ahern <dsahern@gmail.com>, Namhyung Kim <namhyung@kernel.org>,
        Pekka Enberg <penberg@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Irina Tirdea <irina.tirdea@intel.com>,
        Bernhard Rosenkraenzer <Bernhard.Rosenkranzer@linaro.org>
Subject: Re: [PATCH 2/8] perf tools: update Makefile for Android
Message-ID: <20121008204333.GG2631@ghostprotocols.net>
References: <1349678613-7045-1-git-send-email-irina.tirdea@gmail.com>
 <1349678613-7045-3-git-send-email-irina.tirdea@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349678613-7045-3-git-send-email-irina.tirdea@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Oct 08, 2012 at 09:43:27AM +0300, Irina Tirdea escreveu:
> From: Irina Tirdea <irina.tirdea@intel.com>
> 
> For cross-compiling on Android, some specific changes are needed in
> the Makefile.
> 
> Update the Makefile to support cross-compiling for Android.
> The original ideea for this was send by Bernhard Rosenkraenzer in
> https://lkml.org/lkml/2012/8/23/316, but this is a rewrite.

If this is a rewrite, I'm dropping Bernhard's SOB, leaving just him in
the CC list.

- Arnaldo

> 
> Changes:
> () support bionic in addition to glibc
> () remove rt and pthread libraries that do not exist in Android
> () use $(CFLAGS) when detecting initial compiler flags. This is needed
> when setting CFLAGS as an argument of make (e.g. for setting --sysroot).
> () include perf's local directory when building for Android to be able to find
> relative paths if using --sysroot (e.g.: ../../include/linux/perf_event.h)
> 
> Signed-off-by: Bernhard Rosenkraenzer <Bernhard.Rosenkranzer@linaro.org>
> Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
> ---
>  tools/perf/Makefile                 |   25 +++++++++++++++++++------
>  tools/perf/config/feature-tests.mak |    9 +++++++++
>  2 files changed, 28 insertions(+), 6 deletions(-)
> 
> diff --git a/tools/perf/Makefile b/tools/perf/Makefile
> index 0e468b5..1a23118 100644
> --- a/tools/perf/Makefile
> +++ b/tools/perf/Makefile
> @@ -155,15 +155,15 @@ SPARSE_FLAGS = -D__BIG_ENDIAN__ -D__powerpc__
>  
>  -include config/feature-tests.mak
>  
> -ifeq ($(call try-cc,$(SOURCE_HELLO),-Werror -fstack-protector-all),y)
> +ifeq ($(call try-cc,$(SOURCE_HELLO),$(CFLAGS) -Werror -fstack-protector-all),y)
>  	CFLAGS := $(CFLAGS) -fstack-protector-all
>  endif
>  
> -ifeq ($(call try-cc,$(SOURCE_HELLO),-Werror -Wstack-protector),y)
> +ifeq ($(call try-cc,$(SOURCE_HELLO),$(CFLAGS) -Werror -Wstack-protector),y)
>         CFLAGS := $(CFLAGS) -Wstack-protector
>  endif
>  
> -ifeq ($(call try-cc,$(SOURCE_HELLO),-Werror -Wvolatile-register-var),y)
> +ifeq ($(call try-cc,$(SOURCE_HELLO),$(CFLAGS) -Werror -Wvolatile-register-var),y)
>         CFLAGS := $(CFLAGS) -Wvolatile-register-var
>  endif
>  
> @@ -172,6 +172,13 @@ endif
>  BASIC_CFLAGS = -Iutil/include -Iarch/$(ARCH)/include -I$(OUTPUT)util -I$(TRACE_EVENT_DIR) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE
>  BASIC_LDFLAGS =
>  
> +ifeq ($(call try-cc,$(SOURCE_BIONIC),$(CFLAGS)),y)
> +	BIONIC := 1
> +	EXTLIBS := $(filter-out -lrt,$(EXTLIBS))
> +	EXTLIBS := $(filter-out -lpthread,$(EXTLIBS))
> +	BASIC_CFLAGS += -I.
> +endif
> +
>  # Guard against environment variables
>  BUILTIN_OBJS =
>  LIB_H =
> @@ -467,12 +474,18 @@ else
>  FLAGS_LIBELF=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS)
>  ifneq ($(call try-cc,$(SOURCE_LIBELF),$(FLAGS_LIBELF)),y)
>  	FLAGS_GLIBC=$(ALL_CFLAGS) $(ALL_LDFLAGS)
> -	ifneq ($(call try-cc,$(SOURCE_GLIBC),$(FLAGS_GLIBC)),y)
> -		msg := $(error No gnu/libc-version.h found, please install glibc-dev[el]/glibc-static);
> -	else
> +	ifeq ($(call try-cc,$(SOURCE_GLIBC),$(FLAGS_GLIBC)),y)
> +		LIBC_SUPPORT := 1
> +	endif
> +	ifeq ($(BIONIC),1)
> +		LIBC_SUPPORT := 1
> +	endif
> +	ifeq ($(LIBC_SUPPORT),1)
>  		NO_LIBELF := 1
>  		NO_DWARF := 1
>  		NO_DEMANGLE := 1
> +	else
> +		msg := $(error No gnu/libc-version.h found, please install glibc-dev[el]/glibc-static);
>  	endif
>  else
>  	FLAGS_DWARF=$(ALL_CFLAGS) -ldw -lelf $(ALL_LDFLAGS) $(EXTLIBS)
> diff --git a/tools/perf/config/feature-tests.mak b/tools/perf/config/feature-tests.mak
> index eaeb0fd..3ef5ec9 100644
> --- a/tools/perf/config/feature-tests.mak
> +++ b/tools/perf/config/feature-tests.mak
> @@ -43,6 +43,15 @@ int main(void)
>  }
>  endef
>  
> +define SOURCE_BIONIC
> +#include <android/api-level.h>
> +
> +int main(void)
> +{
> +	return __ANDROID_API__;
> +}
> +endef
> +
>  define SOURCE_ELF_MMAP
>  #include <libelf.h>
>  int main(void)
> -- 
> 1.7.9.5
