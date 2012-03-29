Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933058Ab2C2AwR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 20:52:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50099 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758210Ab2C2AwK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 20:52:10 -0400
Date: Wed, 28 Mar 2012 20:52:06 -0400
From: Dave Jones <davej@redhat.com>
To: dhowells@redhat.com
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: large allocations in sys_add_key trigger page allocation failure.
Message-ID: <20120329005206.GA16008@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, dhowells@redhat.com,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just triggered this ..

Mar 28 20:01:13 dhcp-189-232 kernel: [15750.957215] trinity: page allocation failure: order:8, mode:0x40d0
Mar 28 20:01:13 dhcp-189-232 kernel: [15750.957659] Pid: 18257, comm: trinity Not tainted 3.3.0+ #31
Mar 28 20:01:13 dhcp-189-232 kernel: [15750.966766] Call Trace:
Mar 28 20:01:13 dhcp-189-232 kernel: [15750.967218]  [<ffffffff8115dd66>] warn_alloc_failed+0xf6/0x160
Mar 28 20:01:13 dhcp-189-232 kernel: [15750.967910]  [<ffffffff816b66b6>] ? preempt_schedule+0x46/0x60
Mar 28 20:01:13 dhcp-189-232 kernel: [15750.969266]  [<ffffffff811607d0>] ? page_alloc_cpu_notify+0x60/0x60
Mar 28 20:01:13 dhcp-189-232 kernel: [15750.970056]  [<ffffffff81162492>] __alloc_pages_nodemask+0x8b2/0xb10
Mar 28 20:01:13 dhcp-189-232 kernel: [15750.971127]  [<ffffffff8119dae6>] alloc_pages_current+0xb6/0x120
Mar 28 20:01:13 dhcp-189-232 kernel: [15750.972203]  [<ffffffff8115d3b4>] __get_free_pages+0x14/0x50
Mar 28 20:01:13 dhcp-189-232 kernel: [15750.973285]  [<ffffffff811ac64f>] kmalloc_order_trace+0x3f/0x1a0
Mar 28 20:01:13 dhcp-189-232 kernel: [15750.974349]  [<ffffffff811aca0a>] __kmalloc+0x25a/0x280
Mar 28 20:01:13 dhcp-189-232 kernel: [15750.975585]  [<ffffffff812c034a>] sys_add_key+0x9a/0x210
Mar 28 20:01:13 dhcp-189-232 kernel: [15750.976501]  [<ffffffff813386be>] ? trace_hardirqs_on_thunk+0x3a/0x3f
Mar 28 20:01:13 dhcp-189-232 kernel: [15750.977567]  [<ffffffff816c04e9>] system_call_fastpath+0x16/0x1b


An order 8 allocation seems kind of excessive.
There's already a fallback to vmalloc() in place, but can we just silence this spew
with the patch below ?

	Dave

--- 

Suppress large allocation warnings from sys_add_key

We already fallback to vmalloc, so this is just noise.

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/security/keys/keyctl.c b/security/keys/keyctl.c
index fb767c6..f65c72a 100644
--- a/security/keys/keyctl.c
+++ b/security/keys/keyctl.c
@@ -84,7 +84,7 @@ SYSCALL_DEFINE5(add_key, const char __user *, _type,
 	vm = false;
 	if (_payload) {
 		ret = -ENOMEM;
-		payload = kmalloc(plen, GFP_KERNEL);
+		payload = kmalloc(plen, __GFP_NOWARN | GFP_KERNEL);
 		if (!payload) {
 			if (plen <= PAGE_SIZE)
 				goto error2;
