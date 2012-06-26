Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758057Ab2FZBfp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 21:35:45 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:43204 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757879Ab2FZBfo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 21:35:44 -0400
X-AuditID: 9c93016f-b7cbdae0000024ac-af-4fe911ee0f71
From: Namhyung Kim <namhyung@kernel.org>
To: Bernhard =?utf-8?Q?Rosenkr=C3=A4nzer?= 
	<bernhard.rosenkranzer@linaro.org>
Cc: linux-kernel@vger.kernel.org, Patch Tracking <patches@linaro.org>
Subject: Re: [PATCH] perf: Make perf buildable for Android
References: <CAJcDVWNGS7fNEN+MfScyBa7y30PYJvFtCyJkW5QxBFLGGFTOGA@mail.gmail.com>
Date: Tue, 26 Jun 2012 10:31:56 +0900
In-Reply-To: <CAJcDVWNGS7fNEN+MfScyBa7y30PYJvFtCyJkW5QxBFLGGFTOGA@mail.gmail.com>
	("Bernhard \=\?utf-8\?Q\?Rosenkr\=C3\=A4nzer\=22's\?\= message of "Mon, 25 Jun 2012
 17:25:45
	+0200")
Message-ID: <87y5navoxf.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.97 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Bernhard

On Mon, 25 Jun 2012 17:25:45 +0200, Bernhard Rosenkränzer wrote:
> Hi,
> this patch allows compiling perf for Android (with Bionic instead of glibc).
> Nothing overly complicated in there, just a couple of workarounds
> for missing functionality and header oddities in Bionic.
>

Interesting!

Now I'm working on making perf easy to cross-build but didn't check
android land. So I guess android already contains libelf in it, right?
And I'm also curious about the TLS (thread local storage) support in
bionic as perf use it for callchain processing (please see
util/callchain.c for definition of the callchain_cursor).

Btw, this patch seems broken by line wrapping. Please read the kernel
document for this (Documentation/email-clients.txt)

And below is a couple of nitpicks.

> Signed-off-by: Bernhard Rosenkraenzer <Bernhard.Rosenkranzer@linaro.org>
>
> diff --git a/tools/perf/Makefile b/tools/perf/Makefile
> index 92271d3..d15cdae 100644
> --- a/tools/perf/Makefile
> +++ b/tools/perf/Makefile
> @@ -117,7 +117,7 @@ ifndef PERF_DEBUG
>  endif
>
>  CFLAGS = -fno-omit-frame-pointer -ggdb3 -Wall -Wextra -std=gnu99
> $(CFLAGS_WERROR) $(CFLAGS_OPTIMIZE) -D_FORTIFY_SOURCE=2
> $(EXTRA_WARNINGS) $(EXTRA_CFLAGS)
> -EXTLIBS = -lpthread -lrt -lelf -lm
> +EXTLIBS = -lpthread -lelf -lm
>  ALL_CFLAGS = $(CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64
> -D_GNU_SOURCE
>  ALL_LDFLAGS = $(LDFLAGS)
>  STRIP ?= strip
> @@ -474,12 +474,23 @@ FLAGS_LIBELF=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS)
>  ifneq ($(call try-cc,$(SOURCE_LIBELF),$(FLAGS_LIBELF)),y)
>  	FLAGS_GLIBC=$(ALL_CFLAGS) $(ALL_LDFLAGS)
>  	ifneq ($(call try-cc,$(SOURCE_GLIBC),$(FLAGS_GLIBC)),y)
> -		msg := $(error No gnu/libc-version.h found, please install
> glibc-dev[el]/glibc-static);
> +		ifeq ($(call try-cc,$(SOURCE_BIONIC),$(FLAGS_GLIBC)),y)
> +			# Found Bionic instead of glibc...
> +			# That works too, but needs a bit of special treatment
> +			BASIC_CFLAGS += -DANDROID -include compat-android.h
> +			ANDROID := 1
> +		else
> +			msg := $(error No gnu/libc-version.h found, please install
> glibc-dev[el]/glibc-static);
> +		endif
>  	else
>  		msg := $(error No libelf.h/libelf found, please install
> libelf-dev/elfutils-libelf-devel);
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
> diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
> index 223ffdc..1f20f4d 100644
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
> +	// No getsid() on Android
> +	const char *syscall_names[] = { "getppid", "getpgrp",
> +					"getpgid", };
> +	pid_t (*syscalls[])(void) = { getppid, getpgrp, (void*)getpgid };
> +#endif
>  #define nsyscalls ARRAY_SIZE(syscall_names)
>  	int ids[nsyscalls];
>  	unsigned int nr_events[nsyscalls],
> diff --git a/tools/perf/compat-android.h b/tools/perf/compat-android.h
> new file mode 100644
> index 0000000..7681f35
> --- /dev/null
> +++ b/tools/perf/compat-android.h
> @@ -0,0 +1,90 @@
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
> +#include <asm/page.h> // for PAGE_SIZE
> +#include <asm/termios.h> // for winsize

We don't use C++ style comments.


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
> +// Assorted functions that are missing from Bionic

Ditto.


> +static void psignal(int sig, const char *s) {

Please put an opening brace at the next line. See also
Documentation/CodingStyle (chapter 3 "Placing Braces and Spaces")


> +	if(sig>=0 && sig<NSIG) {

This line (and all below) needs more spaces. Ususally it'd be like:

	if (sig >= 0 && sig < NSIG) {


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
> +static ssize_t getline(char **lineptr, size_t *n, FILE *stream) {
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
> +#endif
> +#endif
> diff --git a/tools/perf/config/feature-tests.mak
> b/tools/perf/config/feature-tests.mak
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
> diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
> index 42e8aca..9eb8a4b 100644
> --- a/tools/perf/builtin-record.c
> +++ b/tools/perf/builtin-record.c
> @@ -32,6 +32,12 @@
>  #include <sched.h>
>  #include <sys/mman.h>
>
> +#ifdef ANDROID
> +// While stdlib.h has a prototype for it,
> +// Bionic doesn't actually implement on_exit()
> +static struct perf_record *__global_rec;
> +#endif
> +
>  enum write_mode_t {
>  	WRITE_FORCE,
>  	WRITE_APPEND
> @@ -156,6 +162,11 @@ static void perf_record__sig_exit(int exit_status
> __used, void *arg)
>  	signal(signr, SIG_DFL);
>  	kill(getpid(), signr);
>  }
> +#ifdef ANDROID
> +static void perf_record__sig_exit_android(void) {
> +	perf_record__sig_exit(0, __global_rec);
> +}
> +#endif
>
>  static bool perf_evlist__equal(struct perf_evlist *evlist,
>  			       struct perf_evlist *other)
> @@ -339,6 +350,11 @@ static void perf_record__exit(int status __used, void *arg)
>  		symbol__exit();
>  	}
>  }
> +#ifdef ANDROID
> +static void perf_record__exit_android(void) {
> +	perf_record__exit(0, __global_rec);
> +}
> +#endif
>
>  static void perf_event__synthesize_guest_os(struct machine *machine,
> void *data)
>  {
> @@ -412,7 +428,12 @@ static int __cmd_record(struct perf_record *rec,
> int argc, const char **argv)
>
>  	rec->page_size = sysconf(_SC_PAGE_SIZE);
>
> +#ifndef ANDROID
>  	on_exit(perf_record__sig_exit, rec);
> +#else
> +	__global_rec = rec;
> +	atexit(perf_record__sig_exit_android);
> +#endif

This looks so ugly. Wouldn't it be better implementing simple wrapper to
on_exit using stack based approach in compat-android.c or else?

Thanks,
Namhyung


>  	signal(SIGCHLD, sig_handler);
>  	signal(SIGINT, sig_handler);
>  	signal(SIGUSR1, sig_handler);
> @@ -496,7 +517,11 @@ static int __cmd_record(struct perf_record *rec,
> int argc, const char **argv)
>  	/*
>  	 * perf_session__delete(session) will be called at perf_record__exit()
>  	 */
> +#ifndef ANDROID
>  	on_exit(perf_record__exit, rec);
> +#else
> +	atexit(perf_record__exit_android);
> +#endif
>
>  	if (opts->pipe_output) {
>  		err = perf_header__write_pipe(output);
