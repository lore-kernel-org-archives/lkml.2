Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753721Ab0C2RA0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 13:00:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39390 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752546Ab0C2RAV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 13:00:21 -0400
Message-ID: <4BB0DC2A.3040608@redhat.com>
Date: Mon, 29 Mar 2010 12:58:18 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc11 Thunderbird/3.0.3
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -v2] perf, probe-finder: Build fix on Debian
References: <20100329154132.GA16223@aftab> <4BB0CC60.8010604@redhat.com> <20100329164755.GA16034@aftab>
In-Reply-To: <20100329164755.GA16034@aftab>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov wrote:
> Building chokes with
> 
> In file included from /usr/include/gelf.h:53,
>                  from /usr/include/elfutils/libdw.h:53,
>                  from util/probe-finder.h:61,
>                  from util/probe-finder.c:39:
> /usr/include/libelf.h:98: error: expected specifier-qualifier-list before 'off64_t'
> /usr/include/libelf.h:160: error: expected specifier-qualifier-list before 'off64_t'
> /usr/include/libelf.h:201: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'elf_update'
> /usr/include/libelf.h:207: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'elf_getbase'
> /usr/include/libelf.h:305: error: expected declaration specifiers or '...' before 'off64_t'
> /usr/include/libelf.h:317: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'elf_getaroff'
> make: *** [util/probe-finder.o] Error 1
> make: *** Waiting for unfinished jobs....
> rm .perf.dev.null
> 
> which is due to the fact that </usr/include/libelf.h> isn't seeing
> off64_t from <sys/types.h>
> 
> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>

Thank you a lot!

Acked-by: Masami Hiramatsu <mhiramat@redhat.com>

> ---
>  tools/perf/Makefile |   10 +++++-----
>  1 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/tools/perf/Makefile b/tools/perf/Makefile
> index 8a8f52d..bc0f670 100644
> --- a/tools/perf/Makefile
> +++ b/tools/perf/Makefile
> @@ -200,7 +200,7 @@ endif
>  
>  CFLAGS = -ggdb3 -Wall -Wextra -std=gnu99 -Werror $(CFLAGS_OPTIMIZE) -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS) $(EXTRA_CFLAGS)
>  EXTLIBS = -lpthread -lrt -lelf -lm
> -ALL_CFLAGS = $(CFLAGS)
> +ALL_CFLAGS = $(CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64
>  ALL_LDFLAGS = $(LDFLAGS)
>  STRIP ?= strip
>  
> @@ -492,19 +492,19 @@ ifeq ($(uname_S),Darwin)
>  	PTHREAD_LIBS =
>  endif
>  
> -ifeq ($(shell sh -c "(echo '\#include <libelf.h>'; echo 'int main(void) { Elf * elf = elf_begin(0, ELF_C_READ, 0); return (long)elf; }') | $(CC) -x c - $(ALL_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -o $(BITBUCKET) $(ALL_LDFLAGS) $(EXTLIBS) "$(QUIET_STDERR)" && echo y"), y)
> -ifneq ($(shell sh -c "(echo '\#include <gnu/libc-version.h>'; echo 'int main(void) { const char * version = gnu_get_libc_version(); return (long)version; }') | $(CC) -x c - $(ALL_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -o $(BITBUCKET) $(ALL_LDFLAGS) $(EXTLIBS) "$(QUIET_STDERR)" && echo y"), y)
> +ifeq ($(shell sh -c "(echo '\#include <libelf.h>'; echo 'int main(void) { Elf * elf = elf_begin(0, ELF_C_READ, 0); return (long)elf; }') | $(CC) -x c - $(ALL_CFLAGS) -o $(BITBUCKET) $(ALL_LDFLAGS) $(EXTLIBS) "$(QUIET_STDERR)" && echo y"), y)
> +ifneq ($(shell sh -c "(echo '\#include <gnu/libc-version.h>'; echo 'int main(void) { const char * version = gnu_get_libc_version(); return (long)version; }') | $(CC) -x c - $(ALL_CFLAGS) -o $(BITBUCKET) $(ALL_LDFLAGS) $(EXTLIBS) "$(QUIET_STDERR)" && echo y"), y)
>  	msg := $(error No gnu/libc-version.h found, please install glibc-dev[el]/glibc-static);
>  endif
>  
> -	ifneq ($(shell sh -c "(echo '\#include <libelf.h>'; echo 'int main(void) { Elf * elf = elf_begin(0, ELF_C_READ_MMAP, 0); return (long)elf; }') | $(CC) -x c - $(ALL_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -o $(BITBUCKET) $(ALL_LDFLAGS) $(EXTLIBS) "$(QUIET_STDERR)" && echo y"), y)
> +	ifneq ($(shell sh -c "(echo '\#include <libelf.h>'; echo 'int main(void) { Elf * elf = elf_begin(0, ELF_C_READ_MMAP, 0); return (long)elf; }') | $(CC) -x c - $(ALL_CFLAGS) -o $(BITBUCKET) $(ALL_LDFLAGS) $(EXTLIBS) "$(QUIET_STDERR)" && echo y"), y)
>  		BASIC_CFLAGS += -DLIBELF_NO_MMAP
>  	endif
>  else
>  	msg := $(error No libelf.h/libelf found, please install libelf-dev/elfutils-libelf-devel and glibc-dev[el]);
>  endif
>  
> -ifneq ($(shell sh -c "(echo '\#include <dwarf.h>'; echo '\#include <libdw.h>'; echo 'int main(void) { Dwarf *dbg; dbg = dwarf_begin(0, DWARF_C_READ); return (long)dbg; }') | $(CC) -x c - $(ALL_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -I/usr/include/elfutils -ldw -lelf -o $(BITBUCKET) $(ALL_LDFLAGS) $(EXTLIBS) "$(QUIET_STDERR)" && echo y"), y)
> +ifneq ($(shell sh -c "(echo '\#include <dwarf.h>'; echo '\#include <libdw.h>'; echo 'int main(void) { Dwarf *dbg; dbg = dwarf_begin(0, DWARF_C_READ); return (long)dbg; }') | $(CC) -x c - $(ALL_CFLAGS) -I/usr/include/elfutils -ldw -lelf -o $(BITBUCKET) $(ALL_LDFLAGS) $(EXTLIBS) "$(QUIET_STDERR)" && echo y"), y)
>  	msg := $(warning No libdw.h found or old libdw.h found, disables dwarf support. Please install elfutils-devel/elfutils-dev);
>  	BASIC_CFLAGS += -DNO_DWARF_SUPPORT
>  else

-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com
