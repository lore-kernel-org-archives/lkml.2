Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271Ab0HQHhf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 03:37:35 -0400
Received: from bld-mail16.adl2.internode.on.net ([150.101.137.101]:44278 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751025Ab0HQHhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 03:37:34 -0400
Date: Tue, 17 Aug 2010 17:37:25 +1000
From: Dave Chinner <david@fromorbit.com>
To: linux-kernel@vger.kernel.org
Cc: Steven Rostedt <rostedt@goodmis.org>
Subject: [tracing, hang] dumping events gets stuck in synchronise_sched
Message-ID: <20100817073725.GO10429@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tracing folks,

I've got a machine stuck with a cpu spinning in a tight loop (the
new writeback/sync livelock avoidance code is, well, livelocking),
and I was trying to find out what triggered by using the writeback
trace events. Unfortunately, I can't dump the trace events because
it gets stuck here:

[  263.744094] cat           D 0000000000000000     0  3031   3001 0x00000000
[  263.744094]  ffff880117917af8 0000000000000082 0000000000000292 0000000000000010
[  263.744094]  ffff880100000000 0000000000013580 ffff88011f0d87f0 0000000000013580
[  263.744094]  ffff88011f0d8b58 ffff880117917fd8 ffff88011f0d8b60 ffff880117917fd8
[  263.744094] Call Trace:
[  263.744094]  [<ffffffff818019c5>] schedule_timeout+0x1d5/0x2a0
[  263.744094]  [<ffffffff813fc2d4>] ? do_raw_spin_lock+0x54/0x160
[  263.744094]  [<ffffffff813fc2d4>] ? do_raw_spin_lock+0x54/0x160
[  263.744094]  [<ffffffff818015ff>] wait_for_common+0xcf/0x170
[  263.744094]  [<ffffffff81078b40>] ? default_wake_function+0x0/0x20
[  263.744094]  [<ffffffff8180177d>] wait_for_completion+0x1d/0x20
[  263.744094]  [<ffffffff810d8045>] synchronize_sched+0x55/0x60
[  263.744094]  [<ffffffff8109afb0>] ? wakeme_after_rcu+0x0/0x20
[  263.744094]  [<ffffffff810e0a09>] ring_buffer_read_prepare_sync+0x9/0x10
[  263.744094]  [<ffffffff810e7efc>] tracing_open+0x2bc/0x470
[  263.744094]  [<ffffffff810e7c40>] ? tracing_open+0x0/0x470
[  263.744094]  [<ffffffff81143fed>] __dentry_open+0xed/0x340
[  263.744094]  [<ffffffff813c32af>] ? security_inode_permission+0x1f/0x30
[  263.744094]  [<ffffffff81144354>] nameidata_to_filp+0x54/0x70
[  263.744094]  [<ffffffff81151688>] do_last+0x368/0x5d0
[  263.744094]  [<ffffffff81153ae5>] do_filp_open+0x205/0x5e0
[  263.744094]  [<ffffffff813fc22e>] ? do_raw_spin_unlock+0x5e/0xb0
[  263.744094]  [<ffffffff8115eaaa>] ? alloc_fd+0xfa/0x140
[  263.744094]  [<ffffffff81143dc5>] do_sys_open+0x65/0x130
[  263.744094]  [<ffffffff81143ed0>] sys_open+0x20/0x30
[  263.744094]  [<ffffffff81036032>] system_call_fastpath+0x16/0x1b

If a CPU does not yield, then synchronize_sched() will never complete
and hence I can't get to whatever events that might lead me to the
cause of the hung CPU. A bit of a Catch-22, really.

Given that the trace events are there mainly for debugging, this
seems like a bit of an oversight - hanging a CPU in a tight loop is
not an uncommon event during code development....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
