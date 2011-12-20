Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751390Ab1LTLa0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 06:30:26 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42988 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920Ab1LTLaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 06:30:19 -0500
From: zengzm.kernel@gmail.com
To: linux-kernel@vger.kernel.org
Cc: gregkh@suse.de, Zeng Zhaoming <zengzm.kernel@gmail.com>
Subject: [PATCH] tty: Fix memory leak in virtual console when enable unicode translation
Date: Tue, 20 Dec 2011 19:30:05 +0800
Message-Id: <1324380605-16611-1-git-send-email-zengzm.kernel@gmail.com>
X-Mailer: git-send-email 1.7.6.1.385.gb7fcd0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zeng Zhaoming <zengzm.kernel@gmail.com>

Virtual console unicode translation map leaks with following
message when enable kmemleak:

unreferenced object 0xeb5ec450 (size 192):
  comm "setfont", pid 665, jiffies 4294899028 (age 3696.220s)
  hex dump (first 32 bytes):
    e0 5b 9d eb 00 00 00 00 00 00 00 00 80 b9 ea eb  .[..............
    b0 5a 9d eb 00 00 00 00 00 00 00 00 00 00 00 00  .Z..............
  backtrace:
    [<c1533f8c>] kmemleak_alloc+0x3c/0xa0
    [<c114acc2>] kmem_cache_alloc_trace+0xe2/0x250
    [<c13498e8>] con_clear_unimap+0x78/0xd0
    [<c1345552>] vt_ioctl+0x1562/0x1d00
    [<c133aa00>] tty_ioctl+0x230/0x7c0
    [<c1171519>] do_vfs_ioctl+0x79/0x2d0
    [<c11717df>] sys_ioctl+0x6f/0x80
    [<c156601f>] sysenter_do_call+0x12/0x38
    [<ffffffff>] 0xffffffff
unreferenced object 0xeb9d5be0 (size 128):
  comm "setfont", pid 660, jiffies 4294899030 (age 3696.212s)
  hex dump (first 32 bytes):
    60 c2 a6 eb 50 c8 a6 eb c0 54 9d eb 80 59 9d eb  `...P....T...Y..
    90 53 9d eb 60 52 9d eb 60 92 9b eb 00 00 00 00  .S..`R..`.......
  backtrace:
    [<c1533f8c>] kmemleak_alloc+0x3c/0xa0
    [<c114acc2>] kmem_cache_alloc_trace+0xe2/0x250
    [<c134938c>] con_insert_unipair+0x7c/0x150
    [<c1349f8c>] con_set_unimap+0x15c/0x1f0
    [<c13456fb>] vt_ioctl+0x170b/0x1d00
    [<c133aa00>] tty_ioctl+0x230/0x7c0
    [<c1171519>] do_vfs_ioctl+0x79/0x2d0
    [<c11717df>] sys_ioctl+0x6f/0x80
    [<c156601f>] sysenter_do_call+0x12/0x38
    [<ffffffff>] 0xffffffff

The leak caused by con_set_default_unimap() not correct free the old map.

Signed-off-by: Zeng Zhaoming <zengzm.kernel@gmail.com>
---
 drivers/tty/vt/consolemap.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/tty/vt/consolemap.c b/drivers/tty/vt/consolemap.c
index 45d3e80..a0f3d6c 100644
--- a/drivers/tty/vt/consolemap.c
+++ b/drivers/tty/vt/consolemap.c
@@ -584,7 +584,7 @@ int con_set_default_unimap(struct vc_data *vc)
 			return 0;
 		dflt->refcount++;
 		*vc->vc_uni_pagedir_loc = (unsigned long)dflt;
-		if (p && --p->refcount) {
+		if (p && !--p->refcount) {
 			con_release_unimap(p);
 			kfree(p);
 		}
-- 
1.7.6.1.385.gb7fcd0

