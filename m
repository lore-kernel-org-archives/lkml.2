Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932958Ab1EZQYX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 12:24:23 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42007 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932480Ab1EZQYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 12:24:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type;
        b=RAZ9IU0+cIwx9Hawhn5eiK5qnTb50eZyUI+5lSeIfQlyuOEqVWaWsD74Wz9k27Uh0O
         QE3VqrRDK5+4HtoenAtIuRYKGJGQSvJCTDOfnDrunz6uSNEhKHVy1KU+b2tCp99WTV77
         6aflcs3Slfu7yBctmHGrqapPiMq3+SgrZoHLE=
Message-ID: <4DDE7EAD.7000603@gmail.com>
Date: Thu, 26 May 2011 10:24:13 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>,
        Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
CC: Arnaldo Carvalho de Melo <acme@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        pp-manager@sdl.hitachi.co.jp
Subject: Re: [PATCH -tip v4 0/7] perf: Introduce branch sub commands
References: <20110526050246.30011.86048.stgit@localhost6.localdomain6> <20110526132833.GC21815@nowhere>
In-Reply-To: <20110526132833.GC21815@nowhere>
Content-Type: multipart/mixed;
 boundary="------------000408050108070108000406"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000408050108070108000406
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit



On 05/26/2011 07:28 AM, Frederic Weisbecker wrote:
> (Adding David Ahern in Cc)
> 
> Ok that's all good except this needs to use the "perf script" centralized
> dump.
> 
> Currently running "perf script" without an actual script dumps
> the events by default, whatever kind of event they are: hardware,
> software, tracepoints, ...
> So we want the branch output to be supported there, so we can reuse
> some code and interface.
> 
> For example, "perf script -f branch:comm,tid,sym" would print the
> comm, tid and the sym for to and from addresses.
> 
> That's better than creating a new set of options in a new command
> that people need to relearn while everybody could simply get
> familiarized with common perf script options.
> 
> Of course we can still have a "perf branch" command, which could
> be a tiny shortcut that maps to perf record and perf script.
> 
> Like:
> 
> 	perf branch record
> 	perf branch [trace] -f tid,sym,comm
> 
> Would map to:
> 
> 	perf record branch:u
> 	perf script -f branch:tid,sym,comm
> 
> And may be if one day we can do something more tricky than a
> linear output for branches (like source code coloring/browsing),
> then it may be implemented inside perf branch and not rely on
> another subcommand. Until then we are only dealing with raw linear
> dump, and that's a core job for perf script where we want to
> centralize that kind of facility.

I mentioned that when v3 was posted.

The sample address can be converted to symbols and the output can be
added to perf-script rather easily. Attached is an example. I was going
to submit it back in April and got distracted. I'll rebase, move the
addr->sym conversion to a function and submit later today.

David

> 
> Thanks.
> 
> On Thu, May 26, 2011 at 02:02:46PM +0900, Akihiro Nagai wrote:
>> Hi,
>>
>> This patch series provides the commands 'perf branch record' and
>> 'perf branch trace' version 4. These commands record and analyze
>> a BTS (Branch Trace Store) log. And, they provide the interface
>> to use BTS log for application developers.
>>
>> BTS is a facility of Intel x86 processors, which records the address of
>> 'branch to/from' on every branch/jump instruction and interrupt.
>> This facility is very useful for developers to test their software,
>> for example, coverage test, execution path analysis, dynamic step count ...etc.
>> These test tools have a big advantage, which user doesn't have to modify target
>> executable binaries, because the BTS is a hardware feauture.
>>
>> But, there are few applications using BTS. Reasons I guess are ...
>>  - Few people know what BTS is.
>>  - Few people know how to use BTS on Linux box.
>>  - It's hard to analyze the BTS log because it includes just a series of
>>    addresses.
>>
>> So, I want to provide a user-friendly interface to BTS for application
>> developers.
>>
>>
>>  About new sub commands
>> ========================
>> 'perf branch record' provides an easy way to record BTS log.
>> Usage is 'perf branch record <command>'.  This command is just an alias to
>> 'perf record -e branches:u -c 1 -d <command>'. But, new one is more simple
>> and more intuitive.
>>
>> 'perf branch trace' can parse and analyze recorded BTS log and print various
>> information of execution path. This command can show address, pid, command name,
>> function+offset, file path of elf.
>> You can choose the printed information with option.
>>
>> Example: 'perf branch trace'
>>
>> function+offset
>> _start+0x3      => _dl_start+0x0
>> _dl_start+0x71  => _dl_start+0x93
>> _dl_start+0x97  => _dl_start+0x78
>> _dl_start+0x97  => _dl_start+0x78
>> _dl_start+0xa3  => _dl_start+0x3c0
>> _dl_start+0x3c8 => _dl_start+0x3e8
>> ...
>>
>> This is the default behavior of 'perf branch trace'. It prints function+offset.
>>
>> Example2: 'perf branch -cas trace'
>> command address            function+offset
>> ls      0x0000003e9b000b23 _start+0x3      => 0x0000003e9b004540 _dl_start+0x0
>> ls      0x0000003e9b0045b1 _dl_start+0x71  => 0x0000003e9b0045d3 _dl_start+0x93
>> ls      0x0000003e9b0045d7 _dl_start+0x97  => 0x0000003e9b0045b8 _dl_start+0x78
>> ls      0x0000003e9b0045d7 _dl_start+0x97  => 0x0000003e9b0045b8 _dl_start+0x78
>> ls      0x0000003e9b0045e3 _dl_start+0xa3  => 0x0000003e9b004900 _dl_start+0x3c0
>> ls      0x0000003e9b004908 _dl_start+0x3c8 => 0x0000003e9b004928 _dl_start+0x3e8
>> ...
>>
>> In the future, I'd like to make this more informative. For example
>>  - Show source file path
>>  - Show line number
>>  - Show inlined function name
>>  - Draw call graph
>>  - Browse source code and coloring
>>  - Make BTS record fast
>> and more!
>>
>> Changes in V4:
>>  - Add kenel filter
>>  - Print PID and command only once in a line
>>  - Add output TSV mode
>>
>> Changes in V3:
>>  - Update to the latest -tip tree
>>  - Rename to 'perf branch'
>>  - Process only BTS records
>>  - Fix bug of getting elf_filepath
>>  - Fix return value of __cmd_trace
>>
>> Changes in V2:
>>  - Update to the latest -tip tree
>>  - Add bts explanation to the subcommand list
>>  - Remove the patch already merged (add OPT_CALLBACK_DEFAULT_NOOPT)
>>  - Add comments
>>  - Add new function to the todo list
>>
>> Thanks,
>>
>> ---
>>
>> Akihiro Nagai (7):
>>       perf branch trace: add kernel filter
>>       perf branch trace: add print all option
>>       perf branch trace: print function+offset
>>       perf branch trace: print file path of the executed elf
>>       perf branch trace: print pid and command
>>       perf branch: Introduce new sub command 'perf branch trace'
>>       perf: new subcommand perf branch record
>>
>>
>>  tools/perf/Documentation/perf-branch.txt |   62 +++++
>>  tools/perf/Makefile                      |    1 
>>  tools/perf/builtin-branch.c              |  361 ++++++++++++++++++++++++++++++
>>  tools/perf/builtin.h                     |    1 
>>  tools/perf/command-list.txt              |    1 
>>  tools/perf/perf.c                        |    1 
>>  6 files changed, 427 insertions(+), 0 deletions(-)
>>  create mode 100644 tools/perf/Documentation/perf-branch.txt
>>  create mode 100644 tools/perf/builtin-branch.c
>>
>> -- 
>> Akihiro Nagai (akihiro.nagai.hw@hitachi.com)

--------------000408050108070108000406
Content-Type: text/plain;
 name="perf-sample-addr.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="perf-sample-addr.patch"

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 6debb9c..55f9967 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -32,6 +32,7 @@ enum perf_output_field {
 	PERF_OUTPUT_EVNAME          = 1U << 5,
 	PERF_OUTPUT_TRACE           = 1U << 6,
 	PERF_OUTPUT_SYM             = 1U << 7,
+	PERF_OUTPUT_ADDR            = 1U << 8,
 };
 
 struct output_option {
@@ -46,6 +47,7 @@ struct output_option {
 	{.str = "event", .field = PERF_OUTPUT_EVNAME},
 	{.str = "trace", .field = PERF_OUTPUT_TRACE},
 	{.str = "sym",   .field = PERF_OUTPUT_SYM},
+	{.str = "addr",  .field = PERF_OUTPUT_ADDR},
 };
 
 /* default set to maintain compatibility with current format */
@@ -71,7 +73,8 @@ static struct {
 
 		.fields = PERF_OUTPUT_COMM | PERF_OUTPUT_TID |
 			      PERF_OUTPUT_CPU | PERF_OUTPUT_TIME |
-			      PERF_OUTPUT_EVNAME | PERF_OUTPUT_SYM,
+			      PERF_OUTPUT_EVNAME | PERF_OUTPUT_SYM |
+			      PERF_OUTPUT_ADDR,
 
 		.invalid_fields = PERF_OUTPUT_TRACE,
 	},
@@ -173,6 +176,11 @@ static int perf_evsel__check_attr(struct perf_session *session,
 				       PERF_OUTPUT_CPU))
 		return -EINVAL;
 
+	if (PRINT_FIELD(ADDR) &&
+		perf_attr__check_stype(attr, PERF_SAMPLE_ADDR, "ADDR",
+				       PERF_OUTPUT_ADDR))
+		return -EINVAL;
+
 	return 0;
 }
 
@@ -260,7 +268,7 @@ static void print_sample_start(struct perf_sample *sample,
 	}
 }
 
-static void process_event(union perf_event *event __unused,
+static void process_event(union perf_event *event,
 			  struct perf_sample *sample,
 			  struct perf_evsel *evsel,
 			  struct perf_session *session,
@@ -273,6 +281,31 @@ static void process_event(union perf_event *event __unused,
 
 	print_sample_start(sample, thread, attr);
 
+	if (PRINT_FIELD(ADDR)) {
+		struct addr_location al;
+		u8 cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
+		const char *symname, *dsoname;
+
+		thread__find_addr_map(thread, session, cpumode, MAP__FUNCTION,
+				      event->ip.pid, sample->addr, &al);
+		if (al.map)
+			al.sym = map__find_symbol(al.map, al.addr, NULL);
+		else
+			al.sym = NULL;
+
+		if (al.sym && al.sym->name)
+			symname = al.sym->name;
+		else
+			symname = "";
+
+		if (al.map && al.map->dso && al.map->dso->name)
+			dsoname = al.map->dso->name;
+		else
+			dsoname = "";
+
+		printf("%16" PRIx64 " %s (%s)", al.addr, symname, dsoname);
+	}
+
 	if (PRINT_FIELD(TRACE))
 		print_trace_event(sample->cpu, sample->raw_data,
 				  sample->raw_size);
@@ -972,7 +1005,7 @@ static const struct option options[] = {
 	OPT_STRING(0, "symfs", &symbol_conf.symfs, "directory",
 		    "Look for files with symbols relative to this directory"),
 	OPT_CALLBACK('f', "fields", NULL, "str",
-		     "comma separated output fields prepend with 'type:'. Valid types: hw,sw,trace. Fields: comm,tid,pid,time,cpu,event,trace,sym",
+		     "comma separated output fields prepend with 'type:'. Valid types: hw,sw,trace. Fields: comm,tid,pid,time,cpu,event,trace,sym,addr",
 		     parse_output_fields),
 
 	OPT_END()

--------------000408050108070108000406--
