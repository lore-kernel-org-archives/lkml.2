Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398Ab0FYLRB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 07:17:01 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:37413 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754525Ab0FYLQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 07:16:59 -0400
X-AuditID: b753bd60-ab044ba000006d9b-e1-4c249029ba48
Message-ID: <4C249027.1060304@hitachi.com>
Date: Fri, 25 Jun 2010 20:16:55 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Jamie Iles <jamie.iles@picochip.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] perf tools: allow cross compiling with DWARF support
References: <1277462318-6516-1-git-send-email-jamie.iles@picochip.com>
In-Reply-To: <1277462318-6516-1-git-send-email-jamie.iles@picochip.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jamie Iles wrote:
> The path to elfutils was previously hardcoded as /usr/include/elfutils
> which does not work with cross compilers. If CROSS_COMPILE is set, try
> to set an include path from GCC's sysroot if GCC was built with sysroot
> support, if sysroot support isn't enabled, don't specify a path for
> elfutils allowing the user to set it with EXTRA_CFLAGS.

Hmm, I'm not so sure about cross compiling. I just thought
if there is no sysroot support, we should warn user instead of
just failing to find elfutils.

Thank you,

> 
> Signed-off-by: Jamie Iles <jamie.iles@picochip.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  tools/perf/Makefile |   14 ++++++++++++--
>  1 files changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/perf/Makefile b/tools/perf/Makefile
> index 6aa2fe3..6217839 100644
> --- a/tools/perf/Makefile
> +++ b/tools/perf/Makefile
> @@ -503,8 +503,18 @@ PERFLIBS = $(LIB_FILE)
>  -include config.mak.autogen
>  -include config.mak
>  
> +ifndef CROSS_COMPILE
> +ELFUTILS_INCLUDE = -I/usr/include/elfutils
> +else
> +# See if the compiler has been built with sysroot support
> +SYSROOT_PATH = $(shell $(CC) -print-sysroot 2> /dev/null || echo "")
> +ifneq ($(SYSROOT_PATH),)
> +ELFUTILS_INCLUDE := -I$(SYSROOT_PATH)/usr/include/elfutils
> +endif
> +endif
> +
>  ifndef NO_DWARF
> -FLAGS_DWARF=$(ALL_CFLAGS) -I/usr/include/elfutils -ldw -lelf $(ALL_LDFLAGS) $(EXTLIBS)
> +FLAGS_DWARF=$(ALL_CFLAGS) $(ELFUTILS_INCLUDE) -ldw -lelf $(ALL_LDFLAGS) $(EXTLIBS)
>  ifneq ($(call try-cc,$(SOURCE_DWARF),$(FLAGS_DWARF)),y)
>  	msg := $(warning No libdw.h found or old libdw.h found or elfutils is older than 0.138, disables dwarf support. Please install new elfutils-devel/libdw-dev);
>  	NO_DWARF := 1
> @@ -551,7 +561,7 @@ ifndef NO_DWARF
>  ifeq ($(origin PERF_HAVE_DWARF_REGS), undefined)
>  	msg := $(warning DWARF register mappings have not been defined for architecture $(ARCH), DWARF support disabled);
>  else
> -	BASIC_CFLAGS += -I/usr/include/elfutils -DDWARF_SUPPORT
> +	BASIC_CFLAGS += $(ELFUTILS_INCLUDE) -DDWARF_SUPPORT
>  	EXTLIBS += -lelf -ldw
>  	LIB_OBJS += $(OUTPUT)util/probe-finder.o
>  endif # PERF_HAVE_DWARF_REGS

