Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752784Ab2HAMWc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 08:22:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51761 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751100Ab2HAMWb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 08:22:31 -0400
Date: Wed, 1 Aug 2012 14:21:45 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: perf: commit 44f24cb3156a1e (Factor DSO symtab types) causes
 segfaults
Message-ID: <20120801122145.GD2528@krava.brq.redhat.com>
References: <20120731141455.GA5570@gmail.com>
 <20120801115740.GA16297@x4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120801115740.GA16297@x4>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 01, 2012 at 01:57:40PM +0200, Markus Trippelsdorf wrote:
> On 2012.07.31 at 16:14 +0200, Ingo Molnar wrote:
> > Jiri Olsa (4):
> >       perf symbols: Factor DSO symtab types to generic binary types
> 
> The commit above causes perf segfaults on my machine (running glibc trunk):
> 
> (gdb) run top --stdio
> Starting program: /usr/src/linux/tools/perf/perf top --stdio
> warning: no loadable sections found in added symbol-file system-supplied DSO at 0x7ffff7ffa000
> [Thread debugging using libthread_db enabled]
> Using host libthread_db library "/lib/libthread_db.so.1".
> 
> Program received signal SIGSEGV, Segmentation fault.
> dso__load (dso=0x6661d0, map=map@entry=0x666170, filter=filter@entry=0x426840 <symbol_filter>) at util/symbol.c:1833
> 1833                    dso->symtab_type = binary_type_symtab[i];
> (gdb) bt
> #0  dso__load (dso=0x6661d0, map=map@entry=0x666170, filter=filter@entry=0x426840 <symbol_filter>) at util/symbol.c:1833
> #1  0x000000000045fe87 in map__load (self=self@entry=0x666170, filter=filter@entry=0x426840 <symbol_filter>) at util/map.c:124
> #2  0x000000000045ffbd in map__find_symbol (self=0x666170, addr=11008, filter=filter@entry=0x426840 <symbol_filter>) at util/map.c:168
> #3  0x000000000043b5df in perf_event__preprocess_sample (event=event@entry=0x7ffff44c8720, machine=machine@entry=0x647730, 
>     al=al@entry=0x7fffffffb030, sample=sample@entry=0x7fffffffb060, filter=filter@entry=0x426840 <symbol_filter>) at util/event.c:886
> #4  0x0000000000426d8e in perf_event__process_sample (machine=0x647730, sample=0x7fffffffb060, evsel=<optimized out>, event=0x7ffff44c8720, 
>     tool=0x7fffffffb2c0) at builtin-top.c:723
> #5  perf_top__mmap_read_idx (top=top@entry=0x7fffffffb2c0, idx=idx@entry=3) at builtin-top.c:858
> #6  0x00000000004291c3 in perf_top__mmap_read (top=<optimized out>) at builtin-top.c:873
> #7  __cmd_top (top=0x7fffffffb2c0) at builtin-top.c:1040
> #8  cmd_top (argc=<optimized out>, argv=<optimized out>, prefix=<optimized out>) at builtin-top.c:1348
> #9  0x0000000000414d03 in run_builtin (p=p@entry=0x4dc888, argc=argc@entry=2, argv=argv@entry=0x7fffffffe0b0) at perf.c:273
> #10 0x0000000000415487 in handle_internal_command (argv=0x7fffffffe0b0, argc=2) at perf.c:345
> #11 run_argv (argv=0x7fffffffdeb0, argcp=0x7fffffffdebc) at perf.c:389
> #12 main (argc=2, argv=0x7fffffffe0b0) at perf.c:487
> (gdb)
hi,
I cannot reproduce, but found one obvious bug,
could you please test?

thanks,
jirka

---
 tools/perf/util/symbol.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index fdad4eee..fe86612 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -64,7 +64,7 @@ static enum dso_binary_type binary_type_symtab[] = {
 	DSO_BINARY_TYPE__NOT_FOUND,
 };
 
-#define DSO_BINARY_TYPE__SYMTAB_CNT sizeof(binary_type_symtab)
+#define DSO_BINARY_TYPE__SYMTAB_CNT ARRAY_SIZE(binary_type_symtab)
 
 static enum dso_binary_type binary_type_data[] = {
 	DSO_BINARY_TYPE__BUILD_ID_CACHE,
@@ -72,7 +72,7 @@ static enum dso_binary_type binary_type_data[] = {
 	DSO_BINARY_TYPE__NOT_FOUND,
 };
 
-#define DSO_BINARY_TYPE__DATA_CNT sizeof(binary_type_data)
+#define DSO_BINARY_TYPE__DATA_CNT ARRAY_SIZE(binary_type_data)
 
 int dso__name_len(const struct dso *dso)
 {
-- 
1.7.7.6

