Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757438Ab2DFP0h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 11:26:37 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51117 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754851Ab2DFP0g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 11:26:36 -0400
MIME-Version: 1.0
In-Reply-To: <20120406114502.GD30425@liondog.tnic>
References: <1333666086-6517-1-git-send-email-fweisbec@gmail.com>
	<1333666086-6517-4-git-send-email-fweisbec@gmail.com>
	<20120406114502.GD30425@liondog.tnic>
Date: Fri, 6 Apr 2012 17:26:35 +0200
Message-ID: <CAFTL4hzvy1wgm8e7_h2S6Fa_A+QybUsssetLaWyUu3tB5a2m1w@mail.gmail.com>
Subject: Re: [PATCH 03/15] perf: Build libtraceevent.a
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Borislav Petkov <bp@alien8.de>, Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <srostedt@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Arun Sharma <asharma@fb.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/4/6 Borislav Petkov <bp@alien8.de>:
> On Fri, Apr 06, 2012 at 12:47:54AM +0200, Frederic Weisbecker wrote:
>> From: Steven Rostedt <srostedt@redhat.com>
>>
>> Have building perf also build libtraceevent.a. Currently, perf does
>> not use the code within libtraceevent.a, but it soon will.
>>
>> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
>> Cc: Ingo Molnar <mingo@kernel.org>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Peter Zijlstra <peterz@infradead.org>
>> Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
>> Cc: Steven Rostedt <rostedt@goodmis.org>
>> Cc: Borislav Petkov <bp@alien8.de>
>> Cc: Jiri Olsa <jolsa@redhat.com>
>> Cc: Arun Sharma <asharma@fb.com>
>> Cc: Namhyung Kim <namhyung.kim@lge.com>
>> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
>> ---
>>  tools/perf/Makefile |   11 ++++++++++-
>>  1 files changed, 10 insertions(+), 1 deletions(-)
>>
>> diff --git a/tools/perf/Makefile b/tools/perf/Makefile
>> index 6f93a99..8e60e51 100644
>> --- a/tools/perf/Makefile
>> +++ b/tools/perf/Makefile
>> @@ -1,5 +1,6 @@
>>  ifeq ("$(origin O)", "command line")
>>       OUTPUT := $(O)/
>> +     COMMAND_O := O=$(O)
>>  endif
>>
>>  # The default target of this Makefile is...
>> @@ -211,6 +212,9 @@ $(OUTPUT)python/perf.so: $(PYRF_OBJS) $(PYTHON_EXT_SRCS) $(PYTHON_EXT_DEPS)
>>
>>  SCRIPTS = $(patsubst %.sh,%,$(SCRIPT_SH))
>>
>> +EVENT_PARSE_DIR = ../lib/traceevent/
>> +LIBTRACEEVENT = $(OUTPUT)$(EVENT_PARSE_DIR)libtraceevent.a
>> +
>>  #
>>  # Single 'perf' binary right now:
>>  #
>> @@ -335,6 +339,7 @@ LIB_H += util/cpumap.h
>>  LIB_H += util/top.h
>>  LIB_H += $(ARCH_INCLUDE)
>>  LIB_H += util/cgroup.h
>> +LIB_H += $(EVENT_PARSE_DIR)event-parse.h
>>
>>  LIB_OBJS += $(OUTPUT)util/abspath.o
>>  LIB_OBJS += $(OUTPUT)util/alias.o
>> @@ -741,7 +746,7 @@ $(OUTPUT)perf.o: perf.c $(OUTPUT)common-cmds.h $(OUTPUT)PERF-CFLAGS
>>               '-DPERF_HTML_PATH="$(htmldir_SQ)"' \
>>               $(ALL_CFLAGS) -c $(filter %.c,$^) -o $@
>>
>> -$(OUTPUT)perf: $(OUTPUT)perf.o $(BUILTIN_OBJS) $(PERFLIBS)
>> +$(OUTPUT)perf: $(OUTPUT)perf.o $(BUILTIN_OBJS) $(PERFLIBS) $(LIBTRACEEVENT)
>>       $(QUIET_LINK)$(CC) $(ALL_CFLAGS) $(ALL_LDFLAGS) $(OUTPUT)perf.o \
>>                 $(BUILTIN_OBJS) $(LIBS) -o $@
>>
>> @@ -847,6 +852,10 @@ $(sort $(dir $(DIRECTORY_DEPS))):
>>  $(LIB_FILE): $(LIB_OBJS)
>>       $(QUIET_AR)$(RM) $@ && $(AR) rcs $@ $(LIB_OBJS)
>>
>> +# libparsevent.a
>> +$(LIBTRACEEVENT):
>> +     make -C $(EVENT_PARSE_DIR) $(COMMAND_O) libtraceevent.a
>> +
>
> With a toplevel Makefile in tools/, this should be made into its own
> target residing in tools/lib/traceevent/Makefile and a perf build should
> be dependent on it instead of adding a perf-specific libtraceevent
> target here.

Not sure what you mean. The libtraceevent makefile is standalone and
perf is dependant on it.
What am I missing?
