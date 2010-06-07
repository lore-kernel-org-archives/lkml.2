Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756173Ab0FGDhP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 23:37:15 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56133 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756115Ab0FGDhN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 23:37:13 -0400
Message-ID: <4C0C69CB.2070104@cn.fujitsu.com>
Date: Mon, 07 Jun 2010 11:38:51 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; zh-CN; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Chris Mason <chris.mason@oracle.com>
CC: Linux Btrfs <linux-btrfs@vger.kernel.org>,
       Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] btrfs: fix cannot use the loop device
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

we cannot use the loop device which has been connected to a file in the btrf

The reproduce steps is following:
 # dd if=/dev/zero of=vdev0 bs=1M count=1024
 # losetup /dev/loop0 vdev0
 # mkfs.btrfs /dev/loop0
 ...
 failed to zero device start -5

The reason is that the btrfs don't implement either ->write_begin or ->write
the VFS API, so we fix it by setting ->write to do_sync_write().

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/file.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 79437c5..abcb918 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1197,6 +1197,7 @@ static int btrfs_file_mmap(struct file	*filp, struct vm_area_struct *vma)
 const struct file_operations btrfs_file_operations = {
 	.llseek		= generic_file_llseek,
 	.read		= do_sync_read,
+	.write		= do_sync_write,
 	.aio_read       = generic_file_aio_read,
 	.splice_read	= generic_file_splice_read,
 	.aio_write	= btrfs_file_aio_write,
-- 
1.6.5.2


