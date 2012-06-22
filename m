Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762397Ab2FVTg6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 15:36:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22743 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756387Ab2FVTg4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 15:36:56 -0400
Date: Fri, 22 Jun 2012 15:36:50 -0400
From: Dave Jones <davej@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: big allocation failure during tracing init.
Message-ID: <20120622193650.GA20098@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just hit this during a low-memory test..

trinity-child6: page allocation failure: order:4, mode:0xc0d0
Pid: 25842, comm: trinity-child6 Not tainted 3.5.0-rc3+ #95
Call Trace:
 [<ffffffff81147fab>] warn_alloc_failed+0xeb/0x150
 [<ffffffff8114c2d6>] __alloc_pages_nodemask+0x836/0xab0
 [<ffffffff8118a630>] alloc_pages_current+0xb0/0x120
 [<ffffffff8108e377>] ? local_clock+0x47/0x60
 [<ffffffff811471d4>] __get_free_pages+0x14/0x50
 [<ffffffff811963c9>] kmalloc_order_trace+0x39/0x190
 [<ffffffff810b3108>] ? trace_hardirqs_off_caller+0x28/0xc0
 [<ffffffff81196cbe>] __kmalloc+0x23e/0x290
 [<ffffffff811d270c>] __seq_open_private+0x2c/0x80
 [<ffffffff81114d8c>] tracing_open+0x8c/0x340
 [<ffffffff811aadbf>] do_dentry_open+0x25f/0x310
 [<ffffffff81114d00>] ? tracing_iter_reset+0x90/0x90
 [<ffffffff811ac2fe>] nameidata_to_filp+0x7e/0xe0
 [<ffffffff811bc427>] do_last+0x4a7/0x9f0
 [<ffffffff811be2ac>] path_openat+0xdc/0x410
 [<ffffffff8108e377>] ? local_clock+0x47/0x60
 [<ffffffff811cd231>] ? alloc_fd+0x171/0x220
 [<ffffffff811cd231>] ? alloc_fd+0x171/0x220
 [<ffffffff811be701>] do_filp_open+0x41/0xa0
 [<ffffffff816501e5>] ? _raw_spin_unlock+0x35/0x60
 [<ffffffff811cd231>] ? alloc_fd+0x171/0x220
 [<ffffffff811ac44d>] do_sys_open+0xed/0x1c0
 [<ffffffff811ac564>] sys_openat+0x14/0x20
 [<ffffffff81657b96>] system_call_fastpath+0x1a/0x1f

I guess the problem is on kernels built with CONFIG_MAXCPUS, struct trace_iterator
can be pretty large due to this embedded in it..

	struct ring_buffer_iter *buffer_iter[NR_CPUS];

Any thoughts on how to change that to a smaller dynamic data structure,
without adding too much overhead to tracing ? (I'm assuming a linked-list walk
for eg would be excessive?)

	Dave

