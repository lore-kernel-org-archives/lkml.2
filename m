Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933420Ab0LUJEu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 04:04:50 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:46771 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755101Ab0LUJEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 04:04:47 -0500
X-AuditID: b753bd60-a87a8ba000003e7d-57-4d106dacf273
From: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
Subject: [PATCH -tip v2 0/6] perf: Introduce bts sub commands
To: Arnaldo Carvalho de Melo <acme@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Cc: "akihiro.nagai.hw@hitachi.com"@sdl.hitachi.co.jp,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        2nddept-manager@sdl.hitachi.co.jp
Date: Tue, 21 Dec 2010 18:05:27 +0900
Message-ID: <20101221090527.8552.41486.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch series provides the commands 'perf bts record' and 'perf bts trace'
version 2. These commands can record and analyze BTS (Branch Trace Store) log.
And, provide the interface to use BTS log for application developers.

BTS is a facility of Intel x86 processors, which can record the address of
'branch to/from' on every branch/jump instruction and interrupt.
This facility is very useful for developers to test their software.
For example, coverage test, execution path analysis, dynamic step count ...etc.
Also, those tools can have a very big advantage that they don't require any
changes of the target executable binaries.

But, there are few applications using BTS. Reasons I guess are ...
 - Few people know what BTS is.
 - Few people know how to use BTS on Linux box.
 - It's hard to analyze the BTS log because it includes just a series of addresses.

So, I want to provide a user-friendly interface to BTS for application developers.


 About new sub commands
========================
'perf bts record' provides the easy way to record bts log.
Usage is 'perf bts record <command>'.  This command is just an alias to
'perf record -e branches:u -c 1 <command>'. But, new one is more simple and
more intuitive.

'perf bts trace' can parse and analyze recorded bts log and print various
information of execution path. This command can show address, pid, command name,
function+offset, file path of elf.
You can choose the printed information with option.

Example: 'perf bts trace'
function+offset
irq_return+0x0  => _start+0x0
irq_return+0x0  => _start+0x0
_start+0x3      => _dl_start+0x0
irq_return+0x0  => _dl_start+0x0
irq_return+0x0  => _dl_start+0x26
irq_return+0x0  => _dl_start+0x2d
_dl_start+0x71  => _dl_start+0x93
_dl_start+0x97  => _dl_start+0x78
...

This is the default behavior of 'perf bts trace'. It prints function+offset.


Example2: 'perf bts -cas trace'
command address            function+offset                  
ls      0xffffffff8146fe0e irq_return+0x0  => ls   0x0000003806200b20 _start+0x0
ls      0xffffffff8146fe0e irq_return+0x0  => ls   0x0000003806200b20 _start+0x0
ls      0x0000003806200b23 _start+0x3      => ls   0x0000003806204910 _dl_start+0x0
ls      0xffffffff8146fe0e irq_return+0x0  => ls   0x0000003806204910 _dl_start+0x0
ls      0xffffffff8146fe0e irq_return+0x0  => ls   0x0000003806204936 _dl_start+0x26
ls      0xffffffff8146fe0e irq_return+0x0  => ls   0x000000380620493d _dl_start+0x2d
ls      0x0000003806204981 _dl_start+0x71  => ls   0x00000038062049a3 _dl_start+0x93
ls      0x00000038062049a7 _dl_start+0x97  => ls   0x0000003806204988 _dl_start+0x78
...

In the future, I'd like to make this more informative. For example
 - Show source file path
 - Show line number
 - Show inlined function name
 - Draw call graph
 - Browse source code and coloring
 - Make bts record fast
and more!

Changes in V2:
 - Update to the latest -tip tree
 - add bts explanation to the subcommand list
 - remove the patch already merged (add OPT_CALLBACK_DEFAULT_NOOPT)
 - add comments
 - add new function to the todo list

Thanks,

---

Akihiro Nagai (6):
      perf bts trace: add print all option
      perf bts trace: print function+offset
      perf bts trace: print file path of the executed elf
      perf bts trace: print pid and command
      perf bts: Introduce new sub command 'perf bts trace'
      perf: Introduce perf sub command 'bts record'


 tools/perf/Documentation/perf-bts.txt |   53 ++++++
 tools/perf/Makefile                   |    1 
 tools/perf/builtin-bts.c              |  301 +++++++++++++++++++++++++++++++++
 tools/perf/builtin.h                  |    1 
 tools/perf/command-list.txt           |    1 
 tools/perf/perf.c                     |    1 
 6 files changed, 358 insertions(+), 0 deletions(-)
 create mode 100644 tools/perf/Documentation/perf-bts.txt
 create mode 100644 tools/perf/builtin-bts.c

-- 
Akihiro Nagai (akihiro.nagai.hw@hitachi.com)
