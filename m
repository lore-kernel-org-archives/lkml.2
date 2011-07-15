Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753032Ab1GOP10 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 11:27:26 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51111 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174Ab1GOP1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 11:27:25 -0400
Message-ID: <4E205C58.30607@gmail.com>
Date: Fri, 15 Jul 2011 09:27:20 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: mingo@elte.hu, fweisbec@gmail.com
CC: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        acme@ghostprotocols.net, peterz@infradead.org, paulus@samba.org
Subject: Re: [PATCH] perf tools, x86: fix 32-bit compile on 64-bit system
References: <1310420304-21452-1-git-send-email-dsahern@gmail.com>
In-Reply-To: <1310420304-21452-1-git-send-email-dsahern@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2011 03:38 PM, David Ahern wrote:
> Builds for 32-bit binaries on a 64-bit host currently fail with the error:
> 
> gcc -o /tmp/perf-ppc/bench/mem-memcpy-x86-64-asm.o -c -fno-omit-frame-pointer -ggdb3 -Wall -Wextra -std=gnu99 -Werror -O6 -D_FORTIFY_SOURCE=2 -Wformat -Wformat-security -Wformat-y2k -Wshadow -Winit-self -Wpacked -Wredundant-decls -Wstrict-aliasing=3 -Wswitch-default -Wswitch-enum -Wno-system-headers -Wundef -Wwrite-strings -Wbad-function-cast -Wmissing-declarations -Wmissing-prototypes -Wnested-externs -Wold-style-definition -Wstrict-prototypes -Wdeclaration-after-statement -m32 -fstack-protector-all -Wstack-protector -Wvolatile-register-var -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -Iutil/include -Iarch/x86/include -I/tmp/perf-ppc/ -DLIBELF_NO_MMAP -DDWARF_SUPPORT -DNO_NEWT_SUPPORT -DNO_LIBPERL -DNO_LIBPYTHON -DHAVE_CPLUS_DEMANGLE -DNO_STRLCPY -DARCH_X86_64 bench/mem-memcpy-x86-64-asm.S
> bench/../../../arch/x86/lib/memcpy_64.S: Assembler messages:
> bench/../../../arch/x86/lib/memcpy_64.S:29: Error: bad register name `%rdi'
> bench/../../../arch/x86/lib/memcpy_64.S:34: Error: invalid instruction suffix for `movs'
> bench/../../../arch/x86/lib/memcpy_64.S:50: Error: bad register name `%rdi'
> bench/../../../arch/x86/lib/memcpy_64.S:61: Error: bad register name `%rdi'
> ...
> 
> The problem is the detection of the host arch without considering passed in
> flags. This change fixes 32-bit builds via:
> 
> make EXTRA_CFLAGS=-m32 
> 
> and 64-bit builds still reference the memcpy_64.S.
> 

Fairly trivial change to the Makefile. Any objections? I believe Arnaldo
is out for a few more days and realistically another week to get through
a month's backlog.

David

> Signed-off-by: David Ahern <dsahern@gmail.com>
> ---
>  tools/perf/Makefile |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/tools/perf/Makefile b/tools/perf/Makefile
> index 940257b..c168366 100644
> --- a/tools/perf/Makefile
> +++ b/tools/perf/Makefile
> @@ -52,7 +52,10 @@ ifeq ($(ARCH),i386)
>  endif
>  ifeq ($(ARCH),x86_64)
>  	ARCH := x86
> -	IS_X86_64 := $(shell echo __x86_64__ | ${CC} -E -xc - | tail -n 1)
> +	IS_X86_64 := 0
> +	ifeq (, $(findstring m32,$(EXTRA_CFLAGS)))
> +		IS_X86_64 := $(shell echo __x86_64__ | ${CC} -E -xc - | tail -n 1)
> +	endif
>  	ifeq (${IS_X86_64}, 1)
>  		RAW_ARCH := x86_64
>  		ARCH_CFLAGS := -DARCH_X86_64
