Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265Ab2K3Dk1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 22:40:27 -0500
Received: from mail-wi0-f202.google.com ([209.85.212.202]:58130 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258Ab2K3DkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 22:40:24 -0500
From: Filipe Brandenburger <filbranden@google.com>
To: Chris Mason <chris.mason@fusionio.com>, linux-btrfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Filipe Brandenburger <filbranden@google.com>
Subject: [PATCH 0/2] Btrfs: fix mode umasking on empty files
Date: Thu, 29 Nov 2012 19:40:07 -0800
Message-Id: <1354246809-32339-1-git-send-email-filbranden@google.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This set of patches fix bug #50861:
"Btrfs sometimes ignore umask and create world writable files"
https://bugzilla.kernel.org/show_bug.cgi?id=50861

It turns out that btrfs_create() will create an inode with permissions 0666 and
these will be changed to match the umask inside btrfs_init_acl() (and only in
cases where the ACL doesn't mandate which permissions the file should have.) The
changes are made to the "struct inode" but it's not marked as dirty, so these
changes will only propagate to the "struct btrfs_inode" if other changes are
made to the inode (e.g. by writing content and changing the size or by using
"touch" and changing the mtime, both of which will mark the inode as dirty.)

I fixed this issue by adding a call to btrfs_update_inode() in btrfs_create().
I believe this might be an acceptable solution since the same is already done on
most other system calls such as "mkdir" or "symlink".

An alternative might be applying the umask earlier, before the call to
btrfs_new_inode(), that way the inode would be created with the right permission
bits from the beginning, but that might either involve checking the ACLs before
creating the inode (which might need a rework of btrfs_init_acl()) or umasking
the bits unconditionally, but I guess there's a reason to apply that logic...

The first patch fixes the issue, the second patch refactors the code to avoid
the repetition of setting the flag variable on every error handling block.

Cheers,
Filipe


Filipe Brandenburger (2):
  Btrfs: fix permissions of empty files not affected by umask
  Btrfs: refactor error handling to drop inode in btrfs_create()

 fs/btrfs/inode.c | 27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

-- 
1.7.11.7

