Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752342Ab1IVH0r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 03:26:47 -0400
Received: from peace.netnation.com ([204.174.223.2]:35793 "EHLO
	peace.netnation.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977Ab1IVH0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 03:26:44 -0400
Date: Thu, 22 Sep 2011 00:26:44 -0700
From: Simon Kirby <sim@hostway.ca>
To: linux-kernel@vger.kernel.org
Subject: [3.1-rc6] kmalloc(64) leak from IDE
Message-ID: <20110922072643.GA27232@hostway.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All sorts of fun with 3.1-rc!

On an older x86 box still using the IDE code, I'm seeing a kmalloc(64)
leak (according to slabtop) that basically OOM'd the box in a few days
(640 MB of RAM). This has popped up since 2.6.36, which ran for a long
time on this box with no problems. Issues seen on -rc5, so I rebuilt with
CONFIG_DEBUG_KMEMLEAK on 9d037a777695993ec7437e5f451647dea7919d4c and
/sys/kernel/debug/kmemleak filled up with size 64 traces involving IDE
requests. Every trace seems to contain idedisk_prep_fn():

unreferenced object 0xe30c00c0 (size 64):
  comm "md6_raid1", pid 255, jiffies 4294903935 (age 23889.704s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 ea 00 00 00 00 00 00 00 00  ................
    7e 00 00 00 20 00 00 00 01 00 00 00 00 00 00 00  ~... ...........
  backtrace:
    [<c1495c37>] kmemleak_alloc+0x27/0x50
    [<c10b2f4a>] kmem_cache_alloc_trace+0x8a/0x120
    [<c131fe47>] idedisk_prep_fn+0x37/0xf0
    [<c12758b3>] blk_peek_request+0xa3/0x1e0
    [<c1311f15>] __ide_requeue_and_plug+0x25/0x30
    [<c131257d>] do_ide_request+0x3d/0x4e0
    [<c1270ff4>] __blk_run_queue+0x14/0x20
    [<c127699c>] __make_request+0x21c/0x290
    [<c1274f26>] generic_make_request+0x1a6/0x490
    [<c127526c>] submit_bio+0x5c/0xd0
    [<c13a651b>] md_super_write+0x6b/0x80
    [<c13a67ec>] md_update_sb+0x2bc/0x540
    [<c13a7d51>] md_check_recovery+0x2c1/0x5f0
    [<c138abce>] raid1d+0x2e/0xd90
    [<c13a58d5>] md_thread+0xe5/0x110
    [<c1047df4>] kthread+0x74/0x80

unreferenced object 0xc1c3d900 (size 64):
  comm "hardirq", pid 0, jiffies 5819438 (age 829.636s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 ea 00 00 00 00 00 00 00 00  ................
    7e 00 00 00 20 00 00 00 01 00 00 00 00 00 00 00  ~... ...........
  backtrace:
    [<c1495c37>] kmemleak_alloc+0x27/0x50
    [<c10b2f4a>] kmem_cache_alloc_trace+0x8a/0x120
    [<c131fe47>] idedisk_prep_fn+0x37/0xf0
    [<c12758b3>] blk_peek_request+0xa3/0x1e0
    [<c1311f15>] __ide_requeue_and_plug+0x25/0x30
    [<c1311f2f>] ide_requeue_and_plug+0xf/0x20
    [<c1311fb8>] ide_intr+0x78/0x1e0
    [<c1065c14>] handle_irq_event_percpu+0x54/0x1d0
    [<c1065dac>] handle_irq_event+0x1c/0x30
    [<c1067b8c>] handle_level_irq+0x4c/0xa0
    [<ffffffff>] 0xffffffff

idedisk_prep_fn() seems to allocate a command and return it as
rq->special, but I'm not following what happens after that.

Simon-
