Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757649Ab2FGCWJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 22:22:09 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:51535 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754749Ab2FGCWI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 22:22:08 -0400
X-AuditID: 9c930179-b7bb9ae000000ea5-fa-4fd0104b841a
From: Namhyung Kim <namhyung@gmail.com>
To: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org,
        Akihiro Nagai <akihiro.nagai.hw@hitachi.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, Avik Sil <avik.sil@linaro.org>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung.kim@lge.com>,
        Oleg Nesterov <oleg@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [GIT PULL 00/15] perf/urgent fixes
In-Reply-To: <4FCFDEB7.8000101@gmail.com> (David Ahern's message of "Wed, 06
	Jun 2012 16:50:31 -0600")
References: <1338588999-32509-1-git-send-email-acme@infradead.org>
	<20120606065014.GB17808@gmail.com> <4FCFDEB7.8000101@gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.95 (gnu/linux)
Date: Thu, 07 Jun 2012 11:19:10 +0900
Message-ID: <878vfzamox.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, David

On Wed, 06 Jun 2012 16:50:31 -0600, David Ahern wrote:
> On 6/6/12 12:50 AM, Ingo Molnar wrote:
>> Hm, I got this build failure:
>>
>> bench/mem-memcpy.c: In function ‘bench_mem_memcpy’:
>> bench/mem-memcpy.c:193:2: error: implicit declaration of function ‘perf_atoll’ [-Werror=implicit-function-declaration]
>> bench/mem-memcpy.c:193:2: error: nested extern declaration of ‘perf_atoll’ [-Werror=nested-externs]
>
> I just created a new F17-x86_64 VM and Arnaldo's perf/urgent branch
> builds fine (which includes this patch).
>

I can reproduce it on my F17-x86_64 - current tip + your patch gives:

$ make
PERF_VERSION = 3.5.rc1.99.g7ac4a
    CC perf.o
    CC builtin-annotate.o
    CC builtin-bench.o
    CC bench/sched-messaging.o
    CC bench/sched-pipe.o
    CC bench/mem-memcpy-x86-64-asm.o
    CC bench/mem-memset-x86-64-asm.o
    CC bench/mem-memcpy.o
bench/mem-memcpy.c: In function ‘bench_mem_memcpy’:
bench/mem-memcpy.c:193:2: error: implicit declaration of function ‘perf_atoll’ [-Werror=implicit-function-declaration]
bench/mem-memcpy.c:193:2: error: nested extern declaration of ‘perf_atoll’ [-Werror=nested-externs]
cc1: all warnings being treated as errors
make: *** [bench/mem-memcpy.o] Error 1



>>
>> Which appears to be a result of:
>>
>> 6b7df4a0237a perf tool: Build fix, remove duplicate declarations
>>
>> Those declarations were not so unused on this fresh install of
>> Fedora 17.
>
> 32-bit? 64-bit?
>
> This would fix your compile problem, but I have no way of verifying
> since it builds fine for me.
>
> diff --git a/tools/perf/bench/mem-memcpy.c b/tools/perf/bench/mem-memcpy.c
> index 7155722..535b4b8 100644
> --- a/tools/perf/bench/mem-memcpy.c
> +++ b/tools/perf/bench/mem-memcpy.c
> @@ -10,6 +10,7 @@
>  #include "../util/util.h"
>  #include "../util/parse-options.h"
>  #include "../util/header.h"
> +#include "../util/string.h"
>  #include "bench.h"
>  #include "mem-memcpy-arch.h"

After applying this (on top of your patch):

$ make
PERF_VERSION = 3.5.rc1.99.g7ac4a.dirty
    CC perf.o
    CC bench/mem-memcpy.o
bench/mem-memcpy.c:13:28: fatal error: ../util/string.h: No such file or directory
compilation terminated.
make: *** [bench/mem-memcpy.o] Error 1

Thanks,
Namhyung
