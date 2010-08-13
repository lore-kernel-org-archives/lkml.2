Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755090Ab0HMT7R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 15:59:17 -0400
Received: from trinity.develer.com ([83.149.158.210]:60555 "EHLO
	trinity.develer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753603Ab0HMT7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 15:59:13 -0400
From: Andrea Righi <arighi@develer.com>
To: Stefani Seibold <stefani@seibold.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] kfifo: fix kernel BUG in dma example
Date: Fri, 13 Aug 2010 21:59:03 +0200
Message-Id: <1281729545-1663-1-git-send-email-arighi@develer.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The scatterlist is used uninitialized in kfifo_dma_in_prepare(). This
triggers the following bug if CONFIG_DEBUG_SG=y:

  ------------[ cut here ]------------
  kernel BUG at include/linux/scatterlist.h:65!
  invalid opcode: 0000 [#1] PREEMPT SMP
  ...
  Call Trace:
   [<ffffffff810a1eab>] setup_sgl+0x6b/0xe0
   [<ffffffffa03d7000>] ? example_init+0x0/0x265 [dma_example]
   [<ffffffff810a2021>] __kfifo_dma_in_prepare+0x21/0x30
   [<ffffffffa03d7124>] example_init+0x124/0x265 [dma_example]
   [<ffffffff810f9c55>] ? trace_module_notify+0x25/0x370
   [<ffffffff81110c6e>] ? free_pages_prepare+0x11e/0x1e0
   [<ffffffff8106f2b1>] ? get_parent_ip+0x11/0x50
   [<ffffffff810f9c55>] ? trace_module_notify+0x25/0x370
   [<ffffffff810b65fd>] ? trace_hardirqs_on+0xd/0x10
   [<ffffffff814beade>] ? mutex_unlock+0xe/0x10
   [<ffffffff810f9c71>] ? trace_module_notify+0x41/0x370
   [<ffffffff810a77d5>] ? __blocking_notifier_call_chain+0x45/0x80
   [<ffffffff81137b7a>] ? vfree+0x2a/0x30
   [<ffffffff810a6ac3>] ? up_read+0x23/0x40
   [<ffffffff810a77f5>] ? __blocking_notifier_call_chain+0x65/0x80
   [<ffffffff810001e3>] do_one_initcall+0x43/0x180
   [<ffffffff810c577a>] sys_init_module+0xba/0x200
   [<ffffffff8103819b>] system_call_fastpath+0x16/0x1b
  RIP  [<ffffffff810a1e31>] setup_sgl_buf+0x1a1/0x1b0
   RSP <ffff88006720dc98>
  ---[ end trace a72b979fd3c1d3a5 ]---

Add the proper initialization to avoid the bug.

Signed-off-by: Andrea Righi <arighi@develer.com>
---
 samples/kfifo/dma-example.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/samples/kfifo/dma-example.c b/samples/kfifo/dma-example.c
index b9482c2..03433ca 100644
--- a/samples/kfifo/dma-example.c
+++ b/samples/kfifo/dma-example.c
@@ -45,6 +45,7 @@ static int __init example_init(void)
 
 	printk(KERN_INFO "queue len: %u\n", kfifo_len(&fifo));
 
+	sg_init_table(sg, ARRAY_SIZE(sg));
 	ret = kfifo_dma_in_prepare(&fifo, sg, ARRAY_SIZE(sg), FIFO_SIZE);
 	printk(KERN_INFO "DMA sgl entries: %d\n", ret);
 
-- 
1.7.0.4

