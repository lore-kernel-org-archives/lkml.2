Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030202Ab2KXJSt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2012 04:18:49 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:44868 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932781Ab2KXJSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2012 04:18:46 -0500
MIME-Version: 1.0
Date: Sat, 24 Nov 2012 10:18:44 +0100
Message-ID: <CAPVoSvQNVnz=NrkNaZ4G_k76WuVaAJ24uEXkAyJvDNLHHPs1Kw@mail.gmail.com>
Subject: Hang in md-raid1 with 3.7-rcX
From: Torsten Kaiser <just.for.lkml@googlemail.com>
To: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After my system got stuck with 3.7.0-rc2 as reported in
http://marc.info/?l=linux-kernel&m=135142236520624 LOCKDEP seem to
blame XFS, because it found 2 possible deadlocks. But after these
locking issues where fixed, my system got stuck again with 3.7.0-rc6
as reported in http://marc.info/?l=linux-kernel&m=135344072325490
Dave Chinner thinks its an issue within md, that it gets stuck and
that will then prevent any further xfs activity, and that I should
report it to the raid mailing list.

The issue seems to be that multiple processes (kswapd0, xfsaild/md4
and flush-9:4) get stuck in md_super_wait() like this:
[<ffffffff816b1224>] schedule+0x24/0x60
[<ffffffff814f9dad>] md_super_wait+0x4d/0x80
[<ffffffff8105ca30>] ? __init_waitqueue_head+0x60/0x60
[<ffffffff81500753>] bitmap_unplug+0x173/0x180
[<ffffffff810b6acf>] ? write_cache_pages+0x12f/0x420
[<ffffffff810b6700>] ? set_page_dirty_lock+0x60/0x60
[<ffffffff814e8eb8>] raid1_unplug+0x98/0x110
[<ffffffff81278a6d>] blk_flush_plug_list+0xad/0x240
[<ffffffff81278c13>] blk_finish_plug+0x13/0x50

The full hung-tasks stack traces and the output from SysRq+W can be
found at http://marc.info/?l=linux-kernel&m=135344072325490 or in the
LKML thread 'Hang in XFS reclaim on 3.7.0-rc3'.

I tried to understand how this could happen, but I don't see anything
wrong. Only that md_super_wait() looks like an open coded version of
__wait_event() and could be replaced by using it.

http://marc.info/?l=linux-raid&m=135283030027665 looks like the same
issue, but using ext4 instead of xfs.

My setup wrt. md is two normal sata disks on a normal ahci controller
(AMD SB850 southbridge).
Both disks are divided into 4 partitions and each one assembled into a
separate raid1.
One (md5) is used for swap, the others hold xfs filesystems for /boot/
(md4), / (md6) and /home/ (md7).

I will try to provide any information you ask, but I can't reproduce
the hang on demand so gathering more information about that state is
not so easy, but I will try.

Thanks for looking into this,

Torsten
