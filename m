Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757743Ab2HXJJc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 05:09:32 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:61394 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757828Ab2HXJJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 05:09:03 -0400
X-AuditID: 9c930179-b7cc4ae00000134d-4c-503744ac8b9e
From: Namhyung Kim <namhyung@kernel.org>
To: Bernhard Rosenkraenzer <bernhard.rosenkranzer@linaro.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 1/1] perf: Port to Android
References: <1408973.PFKjjaXiS1@localhost.localdomain>
Date: Fri, 24 Aug 2012 18:02:24 +0900
In-Reply-To: <1408973.PFKjjaXiS1@localhost.localdomain> (Bernhard
	Rosenkraenzer's message of "Thu, 23 Aug 2012 17:01:52 +0200")
Message-ID: <87boi0hdcv.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Bernhard

On Thu, 23 Aug 2012 17:01:52 +0200, Bernhard Rosenkraenzer wrote:
> commit 4dc79eed16e3bb03b3cf92fcc6127e107e7537aa
> Author: Bernhard Rosenkraenzer <Bernhard.Rosenkranzer@linaro.org>
> Date:   Sat Jun 23 06:18:05 2012 +0200
>
>     perf: Port to Android
>     
>     Adapt perf to deal with some missing functions in Bionic etc.
>     
>     Change-Id: I0cda2aad3edba26e1be3aebc9475a229ea9e8356

Please remove this Change-Id line.


>     Signed-off-by: Bernhard Rosenkraenzer <Bernhard.Rosenkranzer@linaro.org>
>
> diff --git a/tools/perf/Makefile b/tools/perf/Makefile
> index 92271d3..d15cdae 100644
> --- a/tools/perf/Makefile
> +++ b/tools/perf/Makefile
> @@ -117,7 +117,7 @@ ifndef PERF_DEBUG
>  endif
>  
>  CFLAGS = -fno-omit-frame-pointer -ggdb3 -Wall -Wextra -std=gnu99 
> $(CFLAGS_WERROR) $(CFLAGS_OPTIMIZE) -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS) 
> $(EXTRA_CFLAGS)
> -EXTLIBS = -lpthread -lrt -lelf -lm
> +EXTLIBS = -lpthread -lelf -lm
>  ALL_CFLAGS = $(CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -
> D_GNU_SOURCE

It seems your mail client wraps long line (again).


>  ALL_LDFLAGS = $(LDFLAGS)
>  STRIP ?= strip
> @@ -474,12 +474,23 @@ FLAGS_LIBELF=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS)
>  ifneq ($(call try-cc,$(SOURCE_LIBELF),$(FLAGS_LIBELF)),y)
>  	FLAGS_GLIBC=$(ALL_CFLAGS) $(ALL_LDFLAGS)
>  	ifneq ($(call try-cc,$(SOURCE_GLIBC),$(FLAGS_GLIBC)),y)
> -		msg := $(error No gnu/libc-version.h found, please install glibc-
> dev[el]/glibc-static);
> +		ifeq ($(call try-cc,$(SOURCE_BIONIC),$(FLAGS_GLIBC)),y)
> +			# Found Bionic instead of glibc...
> +			# That works too, but needs a bit of special treatment
> +			BASIC_CFLAGS += -DANDROID -include compat-android.h

Do we really need to include compat-android.h to every source file?


> +			ANDROID := 1
> +		else
> +			msg := $(error No gnu/libc-version.h found, please install glibc-
> dev[el]/glibc-static);
> +		endif
>  	else
>  		msg := $(error No libelf.h/libelf found, please install libelf-
> dev/elfutils-libelf-devel);
>  	endif
>  endif
>  
> +ifneq ($(ANDROID),1)
> +EXTLIBS += -lrt
> +endif
> +
>  ifneq ($(call try-cc,$(SOURCE_ELF_MMAP),$(FLAGS_COMMON)),y)
>  	BASIC_CFLAGS += -DLIBELF_NO_MMAP
>  endif
> diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
> index be4e1ee..3a1d0cc 100644
> --- a/tools/perf/builtin-record.c
> +++ b/tools/perf/builtin-record.c
> @@ -27,10 +27,43 @@
>  #include "util/cpumap.h"
>  #include "util/thread_map.h"
>  
> +#include <stdlib.h>
>  #include <unistd.h>
>  #include <sched.h>
>  #include <sys/mman.h>
>  
> +#ifdef ANDROID
> +/* While stdlib.h has a prototype for it,
> +   Bionic doesn't actually implement on_exit() */
> +#ifndef ATEXIT_MAX
> +#define ATEXIT_MAX 32
> +#endif
> +static int __on_exit_count = 0;
> +typedef void (*on_exit_func_t)(int, void*);
> +static on_exit_func_t __on_exit_funcs[ATEXIT_MAX];
> +static void *__on_exit_args[ATEXIT_MAX];
> +static int __exitcode = 0;
> +static void __handle_on_exit_funcs();
> +static int on_exit(on_exit_func_t function, void *arg);
> +#define exit(x) (exit)(__exitcode = (x))
> +
> +static int on_exit(on_exit_func_t function, void *arg) {
> +	if(__on_exit_count == ATEXIT_MAX)
> +		return ENOMEM;
> +	else if(__on_exit_count == 0)
> +		atexit(__handle_on_exit_funcs);
> +	__on_exit_funcs[__on_exit_count] = function;
> +	__on_exit_args[__on_exit_count++] = arg;
> +	return 0;
> +}
> +
> +static void __handle_on_exit_funcs() {
> +	for(int i=0; i<__on_exit_count; i++) {
> +		__on_exit_funcs[i](__exitcode, __on_exit_args[i]);
> +	}
> +}
> +#endif
> +

Putting above in builtin-record.c seems not a good choice. How about
something like util/android.c?


>  enum write_mode_t {
>  	WRITE_FORCE,
>  	WRITE_APPEND
> diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
> index 223ffdc..6dbd2ee 100644
> --- a/tools/perf/builtin-test.c
> +++ b/tools/perf/builtin-test.c
> @@ -469,10 +469,17 @@ static int test__basic_mmap(void)
>  		.watermark	= 0,
>  	};
>  	cpu_set_t cpu_set;
> +#ifndef ANDROID
>  	const char *syscall_names[] = { "getsid", "getppid", "getpgrp",
>  					"getpgid", };
>  	pid_t (*syscalls[])(void) = { (void *)getsid, getppid, getpgrp,
>  				      (void*)getpgid };
> +#else
> +	/* No getsid() on Android */
> +	const char *syscall_names[] = { "getppid", "getpgrp",
> +					"getpgid", };
> +	pid_t (*syscalls[])(void) = { getppid, getpgrp, (void*)getpgid };
> +#endif
>  #define nsyscalls ARRAY_SIZE(syscall_names)
>  	int ids[nsyscalls];
>  	unsigned int nr_events[nsyscalls],
> diff --git a/tools/perf/builtin.h b/tools/perf/builtin.h
> index b382bd5..1521a275 100644
> --- a/tools/perf/builtin.h
> +++ b/tools/perf/builtin.h
> @@ -1,6 +1,7 @@
>  #ifndef BUILTIN_H
>  #define BUILTIN_H
>  
> +#include "compat-android.h"
>  #include "util/util.h"
>  #include "util/strbuf.h"
>  
> diff --git a/tools/perf/compat-android.h b/tools/perf/compat-android.h
> new file mode 100644
> index 0000000..9a33f49
> --- /dev/null
> +++ b/tools/perf/compat-android.h

This also can be moved under util/ along with the .c file. 


> @@ -0,0 +1,96 @@
> +/* Android compatibility header
> + * Provides missing bits in Bionic on Android, ignored
> + * on regular Linux.
> + *
> + * Written by Bernhard.Rosenkranzer@linaro.org
> + *
> + * Released into the public domain. Do with this file
> + * whatever you want.
> + */
> +#ifdef ANDROID
> +/* Bionic has its own idea about ALIGN, and kills other definitions.
> + * Done outside the multiple-inclusion wrapper to make sure we
> + * can override Bionic's ALIGN by simply including compat-android.h
> + * again after including Bionic headers.
> + */
> +#undef ALIGN
> +#undef __ALIGN_MASK
> +#define ALIGN(x,a)              __ALIGN_MASK(x,(typeof(x))(a)-1)
> +#define __ALIGN_MASK(x,mask)    (((x)+(mask))&~(mask))
> +
> +#ifndef _COMPAT_ANDROID_H_
> +#define _COMPAT_ANDROID_H_ 1
> +#include <stdio.h>
> +#include <signal.h>
> +#include <asm/page.h> /* for PAGE_SIZE */
> +#include <asm/termios.h> /* for winsize */
> +
> +#ifndef __WORDSIZE
> +#include <stdint.h>
> +#define __WORDSIZE _BITSIZE
> +#endif
> +
> +#ifndef roundup
> +#define roundup(x, y)   ((((x)+((y)-1))/(y))*(y))
> +#endif
> +
> +#ifndef __force
> +#define __force
> +#endif
> +
> +#ifndef __le32
> +#define __le32 uint32_t
> +#endif
> +
> +/* Assorted functions that are missing from Bionic */
> +static void psignal(int sig, const char *s)
> +{
> +	if(sig >= 0 && sig < NSIG) {
> +		if(s)
> +			fprintf(stderr, "%s: %s\n", s, sys_siglist[sig]);
> +		else
> +			fprintf(stderr, "%s\n", sys_siglist[sig]);
> +	} else {
> +		if(s)
> +			fprintf(stderr, "%s: invalid signal\n", s);
> +		else
> +			fputs("invalid signal\n", stderr);
> +	}
> +}
> +
> +static ssize_t getline(char **lineptr, size_t *n, FILE *stream)
> +{
> +	size_t ret = 0;
> +
> +	if (!lineptr || !n || !stream)
> +		return -1;
> +
> +	if(!*lineptr) {
> +		*n = 128;
> +		*lineptr = (char*)malloc(*n);
> +		if(!*lineptr)
> +			return -1;
> +	}
> +
> +	while(!feof(stream) && !ferror(stream)) {
> +		int c;
> +		if(ret == *n) {
> +			*n += 128;
> +			*lineptr = (char*)realloc(*lineptr, *n);
> +			if(!*lineptr) {
> +				*n = 0;
> +				return -1;
> +			}
> +		}
> +		c = fgetc(stream);
> +		if(c == EOF)
> +			break;
> +		*lineptr[ret++] = c;
> +		if(c == '\n')
> +			break;
> +	}
> +	*lineptr[ret] = 0;
> +	return ret;
> +}

And above two functions can be moved too somehow.


> +#endif
> +#endif
> diff --git a/tools/perf/config/feature-tests.mak b/tools/perf/config/feature-
> tests.mak
> index d9084e0..498cd4d 100644
> --- a/tools/perf/config/feature-tests.mak
> +++ b/tools/perf/config/feature-tests.mak
> @@ -43,6 +43,19 @@ int main(void)
>  }
>  endef
>  
> +define SOURCE_BIONIC
> +#include <android/api-level.h>
> +
> +int main(void)
> +{
> +#ifndef __ANDROID_API__
> +	error out
> +#else
> +	return 0;
> +#endif
> +}
> +endef
> +
>  define SOURCE_ELF_MMAP
>  #include <libelf.h>
>  int main(void)
> diff --git a/tools/perf/util/annotate.h b/tools/perf/util/annotate.h
> index efa5dc8..ead88ea 100644
> --- a/tools/perf/util/annotate.h
> +++ b/tools/perf/util/annotate.h
> @@ -6,6 +6,7 @@
>  #include "symbol.h"
>  #include <linux/list.h>
>  #include <linux/rbtree.h>
> +#include <pthread.h>
>  
>  struct objdump_line {
>  	struct list_head node;
> diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
> index 2a6f33c..867415a 100644
> --- a/tools/perf/util/event.c
> +++ b/tools/perf/util/event.c
> @@ -6,6 +6,7 @@
>  #include "strlist.h"
>  #include "thread.h"
>  #include "thread_map.h"
> +#include "../compat-android.h"

Didn't we already include the header on command line?  Also I'm curious
whether it can be built with O=$(DIR) option.

Btw, can you (or anyone) tell me the current status of TLS support in
bionic?

Thanks,
Namhyung


>  
>  static const char *perf_event__names[] = {
>  	[0]					= "TOTAL",
> diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
> index 1b19728..2b0554b 100644
> --- a/tools/perf/util/event.h
> +++ b/tools/perf/util/event.h
> @@ -6,6 +6,7 @@
>  
>  #include "../perf.h"
>  #include "map.h"
> +#include "../compat-android.h"
>  
>  /*
>   * PERF_SAMPLE_IP | PERF_SAMPLE_TID | *
> diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
> index 0f99f39..77c5ced 100644
> --- a/tools/perf/util/util.h
> +++ b/tools/perf/util/util.h
> @@ -70,15 +70,19 @@
>  #include <sys/socket.h>
>  #include <sys/ioctl.h>
>  #include <sys/select.h>
> +#ifndef ANDROID
>  #include <netinet/in.h>
>  #include <netinet/tcp.h>
>  #include <arpa/inet.h>
> +#endif
>  #include <netdb.h>
>  #include <pwd.h>
>  #include <inttypes.h>
>  #include "../../../include/linux/magic.h"
>  #include "types.h"
> +#ifndef ANDROID
>  #include <sys/ttydefaults.h>
> +#endif
>  
>  extern const char *graph_line;
>  extern const char *graph_dotted_line;
