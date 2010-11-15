Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932096Ab0KONm5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 08:42:57 -0500
Received: from mail.openrapids.net ([64.15.138.104]:46457 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756786Ab0KONmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 08:42:55 -0500
Date: Mon, 15 Nov 2010 08:42:44 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org
Subject: [ANNOUNCE] New tools: lttngtrace and lttngreport
Message-ID: <20101115134243.GA2772@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 08:20:40 up 53 days, 17:22,  4 users,  load average: 1.51, 1.31,
	1.22
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

Recently, Linus came up with a request: a "super-strace" based on kernel
tracing. So I just came up with two bash scripts that perform exactly this within
LTTng: lttngtrace starts tracing, runs a program, stops tracing. lttngreport
generates a wakeup dependency report. I'm appending the script below (depends on
LTTng kernel tree, LTTng modules package, ltt-control and lttv).

It will report which interrupt/softirq and wakeup dependency chain caused each
wakeup, along with the duration within each step of the wakeup chain. This
includes I/O activity, traps, and syscalls.

Usage, e.g. to trace a git clone (must be run as root):

# lttngtrace git clone git://git.lttng.org/lttv.git
[...]

% lttngreport
[...]
Woken up in context of 29856 [/usr/lib/git-core/git] in high-level state RUNNING
Blocked in RUNNING, SYSCALL 7 [sys_waitpid+0x0/0x30], (times: 139642.854813709-139642.855068608, dur: 0.000255)
Woken up in context of 29856 [/usr/lib/git-core/git] in high-level state RUNNING
Blocked in RUNNING, SYSCALL 118 [sys_fsync+0x0/0x10], (times: 139642.855714820-139642.855795631, dur: 0.000081)
Woken up by a SoftIRQ: SoftIRQ 4 [blk_done_softirq+0x0/0x70]
Blocked in RUNNING, SYSCALL 118 [sys_fsync+0x0/0x10], (times: 139642.855870453-139642.858538485, dur: 0.002668)
         Blocked in UNKNOWN, (times: 139642.855869565-139642.858434668, dur: 0.002565)
         Woken up by a SoftIRQ: SoftIRQ 4 [blk_done_softirq+0x0/0x70]
         Blocked in UNKNOWN, (times: 139642.858483534-139642.858528693, dur: 0.000045)
         Woken up by a SoftIRQ: SoftIRQ 4 [blk_done_softirq+0x0/0x70]
Woken up in context of 1140 [kjournald]UNKNOWN,  in high-level state UNKNOWN
Blocked in RUNNING, SYSCALL 168 [sys_poll+0x0/0xc0], (times: 139642.859478216-139642.860636322, dur: 0.001158)
Woken up by a SoftIRQ: SoftIRQ 3 [net_rx_action+0x0/0x1e0]
Blocked in RUNNING, SYSCALL 38 [sys_rename+0x0/0x30], (times: 139642.861159211-139642.861240877, dur: 0.000082)
Woken up by a SoftIRQ: SoftIRQ 4 [blk_done_softirq+0x0/0x70]

I'll be happy to tweak the report as I receive feedback.

(bash scripts below, depends on current lttv git tree)

Thanks,

Mathieu

-------
lttngtrace:

#!/bin/sh

rm -fr /tmp/autotrace1
ltt-armall

lttctl -C -w /tmp/autotrace1 autotrace1

${*} &
CHILDPID=$!
wait

lttctl -D autotrace1
ltt-disarmall

echo ${CHILDPID} > /tmp/autotrace1-pid

------
lttngreport:

#!/bin/sh

CHILDPID=$(cat /tmp/autotrace1-pid)

lttv -m depanalysis -t /tmp/autotrace1 --dep-pid ${CHILDPID}


-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
