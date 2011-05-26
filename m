Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751511Ab1EZFEE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 01:04:04 -0400
Received: from mailx.hitachi.co.jp ([133.145.228.49]:51294 "EHLO
	mailx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021Ab1EZFEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 01:04:02 -0400
X-AuditID: b753bd60-a32aeba0000019f4-d6-4ddddebb1cde
X-AuditID: b753bd60-a32aeba0000019f4-d6-4ddddebb1cde
From: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
Subject: [PATCH -tip v4 0/7] perf: Introduce branch sub commands
To: Arnaldo Carvalho de Melo <acme@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        pp-manager@sdl.hitachi.co.jp
Date: Thu, 26 May 2011 14:02:46 +0900
Message-ID: <20110526050246.30011.86048.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch series provides the commands 'perf branch record' and
'perf branch trace' version 4. These commands record and analyze
a BTS (Branch Trace Store) log. And, they provide the interface
to use BTS log for application developers.

BTS is a facility of Intel x86 processors, which records the address of
'branch to/from' on every branch/jump instruction and interrupt.
This facility is very useful for developers to test their software,
for example, coverage test, execution path analysis, dynamic step count ...etc.
These test tools have a big advantage, which user doesn't have to modify target
executable binaries, because the BTS is a hardware feauture.

But, there are few applications using BTS. Reasons I guess are ...
 - Few people know what BTS is.
 - Few people know how to use BTS on Linux box.
 - It's hard to analyze the BTS log because it includes just a series of
   addresses.

So, I want to provide a user-friendly interface to BTS for application
developers.


 About new sub commands
========================
'perf branch record' provides an easy way to record BTS log.
Usage is 'perf branch record <command>'.  This command is just an alias to
'perf record -e branches:u -c 1 -d <command>'. But, new one is more simple
and more intuitive.

'perf branch trace' can parse and analyze recorded BTS log and print various
information of execution path. This command can show address, pid, command name,
function+offset, file path of elf.
You can choose the printed information with option.

Example: 'perf branch trace'

function+offset
_start+0x3      => _dl_start+0x0
_dl_start+0x71  => _dl_start+0x93
_dl_start+0x97  => _dl_start+0x78
_dl_start+0x97  => _dl_start+0x78
_dl_start+0xa3  => _dl_start+0x3c0
_dl_start+0x3c8 => _dl_start+0x3e8
...

This is the default behavior of 'perf branch trace'. It prints function+offset.

Example2: 'perf branch -cas trace'
command address            function+offset
ls      0x0000003e9b000b23 _start+0x3      => 0x0000003e9b004540 _dl_start+0x0
ls      0x0000003e9b0045b1 _dl_start+0x71  => 0x0000003e9b0045d3 _dl_start+0x93
ls      0x0000003e9b0045d7 _dl_start+0x97  => 0x0000003e9b0045b8 _dl_start+0x78
ls      0x0000003e9b0045d7 _dl_start+0x97  => 0x0000003e9b0045b8 _dl_start+0x78
ls      0x0000003e9b0045e3 _dl_start+0xa3  => 0x0000003e9b004900 _dl_start+0x3c0
ls      0x0000003e9b004908 _dl_start+0x3c8 => 0x0000003e9b004928 _dl_start+0x3e8
...

In the future, I'd like to make this more informative. For example
 - Show source file path
 - Show line number
 - Show inlined function name
 - Draw call graph
 - Browse source code and coloring
 - Make BTS record fast
and more!

Changes in V4:
 - Add kenel filter
 - Print PID and command only once in a line
 - Add output TSV mode

Changes in V3:
 - Update to the latest -tip tree
 - Rename to 'perf branch'
 - Process only BTS records
 - Fix bug of getting elf_filepath
 - Fix return value of __cmd_trace

Changes in V2:
 - Update to the latest -tip tree
 - Add bts explanation to the subcommand list
 - Remove the patch already merged (add OPT_CALLBACK_DEFAULT_NOOPT)
 - Add comments
 - Add new function to the todo list

Thanks,

---

Akihiro Nagai (7):
      perf branch trace: add kernel filter
      perf branch trace: add print all option
      perf branch trace: print function+offset
      perf branch trace: print file path of the executed elf
      perf branch trace: print pid and command
      perf branch: Introduce new sub command 'perf branch trace'
      perf: new subcommand perf branch record


 tools/perf/Documentation/perf-branch.txt |   62 +++++
 tools/perf/Makefile                      |    1 
 tools/perf/builtin-branch.c              |  361 ++++++++++++++++++++++++++++++
 tools/perf/builtin.h                     |    1 
 tools/perf/command-list.txt              |    1 
 tools/perf/perf.c                        |    1 
 6 files changed, 427 insertions(+), 0 deletions(-)
 create mode 100644 tools/perf/Documentation/perf-branch.txt
 create mode 100644 tools/perf/builtin-branch.c

-- 
Akihiro Nagai (akihiro.nagai.hw@hitachi.com)
