Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753660Ab1J0Ask (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 20:48:40 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:62681 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753529Ab1J0Asj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 20:48:39 -0400
MIME-Version: 1.0
In-Reply-To: <20111026170133.GD9467@ghostprotocols.net>
References: <1319600345-29311-1-git-send-email-furat.afram@gmail.com> <20111026170133.GD9467@ghostprotocols.net>
From: Furat Afram <furat.afram@gmail.com>
Date: Wed, 26 Oct 2011 17:48:19 -0700
Message-ID: <CAH7dF3XGmFe4XCejp9gNZWusWkZbDAgKbQ8AU==s+r_AyXrVTg@mail.gmail.com>
Subject: Re: [PATCH 1/1] perf probe:fix sigsegv in adding nonexistent event
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Program received signal SIGSEGV, Segmentation fault.
dso__split_kallsyms (dso=0xb87ca0, map=0xb87d20, filter=0) at util/symbol.c:640
640		struct machine *machine = kmaps->machine;
Missing separate debuginfos, use: debuginfo-install
elfutils-libelf-0.152-1.fc15.x86_64 glibc-2.14-5.x86_64
libgcc-4.6.1-9.fc15.x86_64 newt-0.52.12-3.fc15.x86_64
python-libs-2.7.1-7.fc15.x86_64 slang-2.2.3-2.fc15.x86_64
zlib-1.2.5-3.fc15.x86_64
(gdb) bt
#0  dso__split_kallsyms (dso=0xb87ca0, map=0xb87d20, filter=0) at
util/symbol.c:640
#1  0x00000000004423d3 in dso__load_kallsyms (filter=0, map=0xb87d20,
filename=0x5042fe "/proc/kallsyms", dso=0xb87ca0) at util/symbol.c:789
#2  dso__load_kernel_sym (filter=0, map=0xb87d20, dso=0xb87ca0) at
util/symbol.c:2107
#3  dso__load (dso=0xb87ca0, map=0xb87d20, filter=0) at util/symbol.c:1574
#4  0x000000000044aa40 in map__load (self=0xb87d20, filter=0) at util/map.c:109
#5  0x000000000044b1d0 in map__find_symbol_by_name (filter=0,
name=<optimized out>, self=0xb87d20) at util/map.c:162
#6  map_groups__find_symbol_by_name (self=<optimized out>,
type=<optimized out>, name=0x8cf8c0 "PageHug", mapp=0x0, filter=0) at
util/map.c:314
#7  0x0000000000462cc5 in map_groups__find_function_by_name
(self=0x819088, filter=0, mapp=0x0, name=<optimized out>) at
util/map.h:215
#8  machine__find_kernel_function_by_name (filter=0, self=0x819040,
mapp=0x0, name=<optimized out>) at util/map.h:224
#9  __find_kernel_function_by_name (mapp=0x0, name=<optimized out>) at
util/probe-event.c:111
#10 convert_to_probe_trace_events (module=<optimized out>,
tevs=<optimized out>, pev=<optimized out>, max_tevs=<optimized out>)
    at util/probe-event.c:1866
#11 add_perf_probe_events (pevs=<optimized out>, npevs=1,
max_tevs=<optimized out>, module=<optimized out>, force_add=false)
    at util/probe-event.c:1909
#12 0x000000000042332e in cmd_probe (argc=0, argv=<optimized out>,
prefix=<optimized out>) at builtin-probe.c:397
#13 0x000000000040fcf9 in run_builtin (p=0x747ba0, argc=3,
argv=0x7fffffffe5a0) at perf.c:286
#14 0x000000000040f4dc in handle_internal_command
(argv=0x7fffffffe5a0, argc=3) at perf.c:358
#15 run_argv (argv=0x7fffffffe440, argcp=0x7fffffffe44c) at perf.c:402
#16 main (argc=3, argv=0x7fffffffe5a0) at perf.c:488


On Wed, Oct 26, 2011 at 10:01 AM, Arnaldo Carvalho de Melo
<acme@ghostprotocols.net> wrote:
> Em Tue, Oct 25, 2011 at 08:39:05PM -0700, furat.afram@gmail.com escreveu:
>> From: Furat Afram <furat.afram@gmail.com>
>>
>> pref probe crashes when trying to add nonexistent event
>
> Can you provide a backtrace of such crash? I'm having difficulty to
> figure out how the patch provided will fix perf probe.
>
> - Arnaldo
>
>> Signed-off-by: Furat Afram <furat.afram@gmail.com>
>> ---
>>  tools/perf/util/symbol.c |    8 ++++++--
>>  1 files changed, 6 insertions(+), 2 deletions(-)
>>
>> diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
>> index 40eeaf0..ad0c79b 100644
>> --- a/tools/perf/util/symbol.c
>> +++ b/tools/perf/util/symbol.c
>> @@ -636,14 +636,18 @@ static int dso__load_all_kallsyms(struct dso *dso, const char *filename,
>>  static int dso__split_kallsyms(struct dso *dso, struct map *map,
>>                              symbol_filter_t filter)
>>  {
>> -     struct map_groups *kmaps = map__kmap(map)->kmaps;
>> -     struct machine *machine = kmaps->machine;
>> +     struct map_groups *kmaps;
>> +     struct machine *machine;
>>       struct map *curr_map = map;
>>       struct symbol *pos;
>>       int count = 0, moved = 0;
>>       struct rb_root *root = &dso->symbols[map->type];
>>       struct rb_node *next = rb_first(root);
>>       int kernel_range = 0;
>> +     kmaps = map__kmap(map)->kmaps;
>> +     if (kmaps == NULL)
>> +             return -1;
>> +     machine = kmaps->machine;
>>
>>       while (next) {
>>               char *module;
>> --
>> 1.7.6.4
>
