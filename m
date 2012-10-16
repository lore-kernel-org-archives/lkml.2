Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230Ab2JPMoi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 08:44:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11340 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752679Ab2JPMog (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 08:44:36 -0400
Date: Tue, 16 Oct 2012 14:43:48 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org, Ben Skeggs <bskeggs@redhat.com>
Subject: [BUG 3.7-rc1] nouveau cli->mutex possible recursive locking detected
Message-ID: <20121016124348.GB2274@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have this lockdep warning on wireless-testing tree based
on 3.7-rc1 (no other patches except wireless bits).

=============================================
Restarting tasks ... done.
[ INFO: possible recursive locking detected ]
3.7.0-rc1-wl+ #2 Not tainted
---------------------------------------------
Xorg/2269 is trying to acquire lock:
 (&cli->mutex){+.+.+.}, at: [<ffffffffa012a27f>] nouveau_bo_move_m2mf+0x5f/0x170 [nouveau]

but task is already holding lock:
 (&cli->mutex){+.+.+.}, at: [<ffffffffa012f3c4>] nouveau_abi16_get+0x34/0x100 [nouveau]

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&cli->mutex);
  lock(&cli->mutex);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

1 lock held by Xorg/2269:
 #0:  (&cli->mutex){+.+.+.}, at: [<ffffffffa012f3c4>] nouveau_abi16_get+0x34/0x100 [nouveau]

stack backtrace:
Pid: 2269, comm: Xorg Not tainted 3.7.0-rc1-wl+ #2
Call Trace:
 [<ffffffff810bbc24>] print_deadlock_bug+0xf4/0x100
 [<ffffffff810bdba9>] validate_chain+0x549/0x7e0
 [<ffffffff810be1a7>] __lock_acquire+0x367/0x580
 [<ffffffffa012a27f>] ? nouveau_bo_move_m2mf+0x5f/0x170 [nouveau]
 [<ffffffff810be464>] lock_acquire+0xa4/0x120
 [<ffffffffa012a27f>] ? nouveau_bo_move_m2mf+0x5f/0x170 [nouveau]
 [<ffffffff8156c860>] ? _raw_spin_unlock_irqrestore+0x40/0x80
 [<ffffffff81569217>] __mutex_lock_common+0x47/0x3f0
 [<ffffffffa012a27f>] ? nouveau_bo_move_m2mf+0x5f/0x170 [nouveau]
 [<ffffffffa011dd61>] ? nv84_graph_tlb_flush+0x291/0x2b0 [nouveau]
 [<ffffffffa00b4be6>] ? _nouveau_gpuobj_wr32+0x26/0x30 [nouveau]
 [<ffffffffa012a27f>] ? nouveau_bo_move_m2mf+0x5f/0x170 [nouveau]
 [<ffffffff815696e7>] mutex_lock_nested+0x37/0x50
 [<ffffffffa012a27f>] nouveau_bo_move_m2mf+0x5f/0x170 [nouveau]
 [<ffffffffa012a783>] nouveau_bo_move+0xe3/0x330 [nouveau]
 [<ffffffffa009619d>] ttm_bo_handle_move_mem+0x2bd/0x670 [ttm]
 [<ffffffffa0098a1e>] ttm_bo_move_buffer+0x12e/0x150 [ttm]
 [<ffffffffa0098ad9>] ttm_bo_validate+0x99/0x130 [ttm]
 [<ffffffffa012add3>] nouveau_bo_validate+0x23/0x30 [nouveau]
 [<ffffffffa012cd8e>] validate_list+0xae/0x2c0 [nouveau]
 [<ffffffffa012dec2>] nouveau_gem_pushbuf_validate+0xa2/0x1e0 [nouveau]
 [<ffffffffa012e22c>] nouveau_gem_ioctl_pushbuf+0x22c/0x8a0 [nouveau]
 [<ffffffffa002c465>] drm_ioctl+0x355/0x570 [drm]
 [<ffffffff8119349a>] ? do_sync_read+0xaa/0xf0
 [<ffffffffa012e000>] ? nouveau_gem_pushbuf_validate+0x1e0/0x1e0 [nouveau]
 [<ffffffff811a579c>] do_vfs_ioctl+0x8c/0x350
 [<ffffffff81575745>] ? sysret_check+0x22/0x5d
 [<ffffffff811a5b01>] sys_ioctl+0xa1/0xb0
 [<ffffffff81291eee>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff81575719>] system_call_fastpath+0x16/0x1b
