Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770Ab1KAOQb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 10:16:31 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62116 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753582Ab1KAOQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 10:16:30 -0400
Date: Tue, 1 Nov 2011 19:45:41 +0530
From: Rabin Vincent <rabin@rab.in>
To: rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org
Subject: WARNING at __ftrace_hash_rec_update()
Message-ID: <20111101141420.GA4918@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On v3.1-7810-g094803e (current linus git), I'm able to trigger the below
FTRACE_WARN_ON() by running the following sequence of commands.
DYNAMIC_FTRACE is enabled.

ftrace.c:1384:
	if (FTRACE_WARN_ON((rec->flags & ~FTRACE_FL_MASK) == 0))
		return;
	rec->flags--;

$ mount -t debugfs nodev /debug
$ cd /debug/tracing/
$ echo 0 > tracing_on 
$ echo function > current_tracer 
$ echo > set_ftrace_filter 
$ echo 1 > tracing_on 
$ cat trace
# tracer: function
#
#           TASK-PID    CPU#    TIMESTAMP  FUNCTION
#              | |       |          |         |
$ echo > set_ftrace_filter 
[   52.066435] ------------[ cut here ]------------
[   52.066824] WARNING: at /home/rabin/kernel/kernel/trace/ftrace.c:1384 __ftrace_hash_rec_update.part.27+0x157/0x1a7()
[   52.067794] Modules linked in:
[   52.068260] Pid: 445, comm: bash Not tainted 3.1.0-07810-g094803e #29
[   52.068702] Call Trace:
[   52.068884]  [<ffffffff8106fb26>] ? __ftrace_hash_rec_update.part.27+0x157/0x1a7
[   52.069599]  [<ffffffff81032347>] warn_slowpath_common+0x83/0x9b
[   52.070122]  [<ffffffff810758d9>] ? trace_parser_put+0xd/0xf
[   52.070812]  [<ffffffff81032379>] warn_slowpath_null+0x1a/0x1c
[   52.071515]  [<ffffffff8106fb26>] __ftrace_hash_rec_update.part.27+0x157/0x1a7
[   52.072385]  [<ffffffff8106fce2>] ftrace_hash_move+0x2e/0x151
[   52.073075]  [<ffffffff810bd028>] ? virt_to_head_page+0xe/0x31
[   52.073748]  [<ffffffff810befd7>] ? kfree+0x5e/0xd7
[   52.074349]  [<ffffffff8106feb8>] ftrace_regex_release+0xb3/0x107
[   52.075098]  [<ffffffff810c5085>] fput+0x8b/0x132
[   52.075649]  [<ffffffff810c24cf>] filp_close+0x63/0x6f
[   52.076301]  [<ffffffff810d043e>] sys_dup3+0x130/0x158
[   52.076898]  [<ffffffff810d04c4>] sys_dup2+0x5e/0x65
[   52.077440]  [<ffffffff81298db3>] ia32_do_call+0x13/0x13
[   52.078097] ---[ end trace c723c025d087b7e9 ]---
$ cat trace
# tracer: function
#
# WARNING: FUNCTION TRACING IS CORRUPTED
#          MAY BE MISSING FUNCTION EVENTS
#           TASK-PID    CPU#    TIMESTAMP  FUNCTION
#              | |       |          |         |

