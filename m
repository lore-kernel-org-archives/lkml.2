Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756092Ab0HKTCo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 15:02:44 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:52242 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755653Ab0HKTCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 15:02:33 -0400
X-Authority-Analysis: v=1.1 cv=FLDyhxrUEZZDQYGWQdnXfbzWjjll+fIPMqQTcKt1R7E= c=1 sm=0 a=X13hoWuv3ckA:10 a=GzHTLUccyWwA:10 a=IXo+6rlC6z1XzBFn1RNpIA==:17 a=QyXUC8HyAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=Pkt9h47x8Hto2BhnsRwA:9 a=M0cxqGFJzxM4434gO_EA:7 a=knxtmVo6q5zkEjwrFj7QalSe-DsA:4 a=dGJ0OcVc7YAA:10 a=LI9Vle30uBYA:10 a=jeBq3FmKZ4MA:10 a=yDC58AueyHYw7qgK:21 a=eDWgUeKtD7MFHY3U:21 a=IXo+6rlC6z1XzBFn1RNpIA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.87.39
Message-Id: <20100811190231.349832035@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 11 Aug 2010 15:01:45 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, <stable@kernel.org>,
        Huang Ying <ying.huang@intel.com>
Subject: [PATCH 2/2] tracing: Fix ring_buffer_read_page reading out of page boundary
References: <20100811190143.688551293@goodmis.org>
Content-Disposition: inline; filename=0002-tracing-Fix-ring_buffer_read_page-reading-out-of-pag.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Huang Ying <ying.huang@intel.com>

With the configuration: CONFIG_DEBUG_PAGEALLOC=y and Shaohua's patch:

[PATCH]x86: make spurious_fault check correct pte bit

Function call graph trace with the following will trigger a page fault.

# cd /sys/kernel/debug/tracing/
# echo function_graph > current_tracer
# cat per_cpu/cpu1/trace_pipe_raw > /dev/null

BUG: unable to handle kernel paging request at ffff880006e99000
IP: [<ffffffff81085572>] rb_event_length+0x1/0x3f
PGD 1b19063 PUD 1b1d063 PMD 3f067 PTE 6e99160
Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
last sysfs file: /sys/devices/virtual/net/lo/operstate
CPU 1
Modules linked in:

Pid: 1982, comm: cat Not tainted 2.6.35-rc6-aes+ #300 /Bochs
RIP: 0010:[<ffffffff81085572>]  [<ffffffff81085572>] rb_event_length+0x1/0x3f
RSP: 0018:ffff880006475e38  EFLAGS: 00010006
RAX: 0000000000000ff0 RBX: ffff88000786c630 RCX: 000000000000001d
RDX: ffff880006e98000 RSI: 0000000000000ff0 RDI: ffff880006e99000
RBP: ffff880006475eb8 R08: 000000145d7008bd R09: 0000000000000000
R10: 0000000000008000 R11: ffffffff815d9336 R12: ffff880006d08000
R13: ffff880006e605d8 R14: 0000000000000000 R15: 0000000000000018
FS:  00007f2b83e456f0(0000) GS:ffff880002100000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: ffff880006e99000 CR3: 00000000064a8000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process cat (pid: 1982, threadinfo ffff880006474000, task ffff880006e40770)
Stack:
 ffff880006475eb8 ffffffff8108730f 0000000000000ff0 000000145d7008bd
<0> ffff880006e98010 ffff880006d08010 0000000000000296 ffff88000786c640
<0> ffffffff81002956 0000000000000000 ffff8800071f4680 ffff8800071f4680
Call Trace:
 [<ffffffff8108730f>] ? ring_buffer_read_page+0x15a/0x24a
 [<ffffffff81002956>] ? return_to_handler+0x15/0x2f
 [<ffffffff8108a575>] tracing_buffers_read+0xb9/0x164
 [<ffffffff810debfe>] vfs_read+0xaf/0x150
 [<ffffffff81002941>] return_to_handler+0x0/0x2f
 [<ffffffff810248b0>] __bad_area_nosemaphore+0x17e/0x1a1
 [<ffffffff81002941>] return_to_handler+0x0/0x2f
 [<ffffffff810248e6>] bad_area_nosemaphore+0x13/0x15
Code: 80 25 b2 16 b3 00 fe c9 c3 55 48 89 e5 f0 80 0d a4 16 b3 00 02 c9 c3 55 31 c0 48 89 e5 48 83 3d 94 16 b3 00 01 c9 0f 94 c0 c3 55 <8a> 0f 48 89 e5 83 e1 1f b8 08 00 00 00 0f b6 d1 83 fa 1e 74 27
RIP  [<ffffffff81085572>] rb_event_length+0x1/0x3f
 RSP <ffff880006475e38>
CR2: ffff880006e99000
---[ end trace a6877bb92ccb36bb ]---

The root cause is that ring_buffer_read_page() may read out of page
boundary, because the boundary checking is done after reading. This is
fixed via doing boundary checking before reading.

Reported-by: Shaohua Li <shaohua.li@intel.com>
Cc: <stable@kernel.org>
Signed-off-by: Huang Ying <ying.huang@intel.com>
LKML-Reference: <1280297641.2771.307.camel@yhuang-dev>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 1da7b6e..5ec8f1d 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -3868,6 +3868,9 @@ int ring_buffer_read_page(struct ring_buffer *buffer,
 			rpos = reader->read;
 			pos += size;
 
+			if (rpos >= commit)
+				break;
+
 			event = rb_reader_event(cpu_buffer);
 			size = rb_event_length(event);
 		} while (len > size);
-- 
1.7.1


