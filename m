Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758334Ab0LCEAa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 23:00:30 -0500
Received: from mailx.hitachi.co.jp ([133.145.228.49]:53581 "EHLO
	mailx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754800Ab0LCEA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 23:00:28 -0500
X-AuditID: b753bd60-a44fbba000000f8d-fb-4cf86ad68cbc
From: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
Subject: [PATCH -tip  0/7] perf: Introduce bts sub commands
Cc: "akihiro.nagai.hw@hitachi.com"@sdl.hitachi.co.jp
To: linux-kernel@vger.kernel.org
Date: Fri, 03 Dec 2010 12:58:33 +0900
Message-ID: <20101203035832.7827.16528.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch series provides the commands 'perf bts record' and 'perf bts trace'.
These commands can record and analyze BTS (Branch Trace Store) log.
And, provide the interface to use BTS log for application developers.

BTS is a facility of Intel x86 processors, which can record the address of
'branch to/from' on every branch/jump instruction and interrupt.
This facility is very useful for developers to test their software.
For example, coverage test, execution path analysis, dynamic step count ...etc.
Also, the tools have a very big advantage that they will require no changes to
the target executable binaries.

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
 - source file path
 - line number
 - inlined function name
and more!

Thanks,

---

Akihiro Nagai (7):
      perf bts trace: add print all option
      perf bts trace: print function+offset
      perf bts trace: print file path of the executed elf
      perf bts trace: print pid and command
      perf bts: Introduce new sub command 'perf bts trace'
      perf: Introduce perf sub command 'bts record'
      perf: add OPT_CALLBACK_DEFAULT_NOOPT


 tools/perf/Documentation/perf-bts.txt |   53 ++++++
 tools/perf/Makefile                   |    1 
 tools/perf/builtin-bts.c              |  304 +++++++++++++++++++++++++++++++++
 tools/perf/builtin.h                  |    1 
 tools/perf/perf.c                     |    1 
 tools/perf/util/parse-options.h       |    4 
 6 files changed, 364 insertions(+), 0 deletions(-)
 create mode 100644 tools/perf/Documentation/perf-bts.txt
 create mode 100644 tools/perf/builtin-bts.c

-- 
Akihiro Nagai (akihiro.nagai.hw@hitachi.com)
