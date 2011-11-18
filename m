Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756560Ab1KRUEr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 15:04:47 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:43348 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753616Ab1KRUEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 15:04:46 -0500
From: Sasha Levin <levinsasha928@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Sasha Levin <levinsasha928@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Pekka Enberg <penberg@kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PATCH] pipe: Fail cleanly when root tries F_SETPIPE_SZ with big size
Date: Fri, 18 Nov 2011 22:04:34 +0200
Message-Id: <1321646674-26890-1-git-send-email-levinsasha928@gmail.com>
X-Mailer: git-send-email 1.7.8.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a user with the CAP_SYS_RESOURCE cap tries to F_SETPIPE_SZ a pipe with
size bigger than what kmalloc() can alloc it spits out an ugly warning:

[    3.651552] ------------[ cut here ]------------
[    3.652644] WARNING: at mm/page_alloc.c:2095 __alloc_pages_nodemask+0x5d3/0x7a0()
[    3.654313] Pid: 733, comm: a.out Not tainted 3.2.0-rc1+ #4
[    3.655568] Call Trace:
[    3.656207]  [<ffffffff810de163>] ? __alloc_pages_nodemask+0x5d3/0x7a0
[    3.657698]  [<ffffffff8107a575>] warn_slowpath_common+0x75/0xb0
[    3.659018]  [<ffffffff8107a675>] warn_slowpath_null+0x15/0x20
[    3.660468]  [<ffffffff810de163>] __alloc_pages_nodemask+0x5d3/0x7a0
[    3.665725]  [<ffffffff810f5432>] ? handle_pte_fault+0xf2/0x200
[    3.667032]  [<ffffffff8167b849>] ? _raw_spin_unlock+0x9/0x40
[    3.668283]  [<ffffffff810f2d76>] ? __pte_alloc+0x96/0x150
[    3.669354]  [<ffffffff81121121>] ? get_empty_filp+0x91/0x160
[    3.670238]  [<ffffffff810f6764>] ? handle_mm_fault+0x1a4/0x360
[    3.671139]  [<ffffffff810de342>] __get_free_pages+0x12/0x50
[    3.671972]  [<ffffffff811169fb>] __kmalloc+0x12b/0x150
[    3.672782]  [<ffffffff811283f5>] pipe_set_size+0x75/0x120
[    3.673681]  [<ffffffff81129998>] pipe_fcntl+0xf8/0x140
[    3.674833]  [<ffffffff81130264>] do_fcntl+0x2d4/0x410
[    3.675960]  [<ffffffff81129722>] ? do_pipe_flags+0xb2/0x100
[    3.677218]  [<ffffffff81130406>] sys_fcntl+0x66/0xa0
[    3.678037]  [<ffffffff8167c612>] system_call_fastpath+0x16/0x1b
[    3.679008] ---[ end trace 432f702e6db7b5ee ]---

Instead, make sure we are trying to allocate less than the max possible
before even trying to allocate it. This way we can avoid the warning if
possible.

Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
---
 fs/pipe.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/pipe.c b/fs/pipe.c
index 4065f07..c5a4ef1 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -1137,6 +1137,9 @@ static long pipe_set_size(struct pipe_inode_info *pipe, unsigned long nr_pages)
 	if (nr_pages < pipe->nrbufs)
 		return -EBUSY;
 
+	if (nr_pages * sizeof(struct pipe_buffer) > KMALLOC_MAX_SIZE)
+		return -ENOMEM;
+
 	bufs = kcalloc(nr_pages, sizeof(struct pipe_buffer), GFP_KERNEL);
 	if (unlikely(!bufs))
 		return -ENOMEM;
-- 
1.7.8.rc1

