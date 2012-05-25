Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932978Ab2EYP3p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 11:29:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37920 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932090Ab2EYP3m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 11:29:42 -0400
From: Lukas Czerner <lczerner@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, mbroz@redhat.com,
        Lukas Czerner <lczerner@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 1/2] vfs: Do not allow mnt_longterm to go negative
Date: Fri, 25 May 2012 17:29:35 +0200
Message-Id: <1337959776-16564-1-git-send-email-lczerner@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently when someone calls __mnt_make_shortterm() and the mnt_longterm
is already zero, it will come negative which is exactly opposite of what
the function should to. So fix this by decrementing mnt_longterm only in
case that it's not zero. Note that mnt_longterm should not be touched
directly, but rather via __mnt_make_shortterm() and mnt_make_shortterm()
functions - the former does not have this problem.

Moreover this will fix very nasty bug which might cause file systems not
being properly cleaned up while unmounting. Specifically it might cause
deactivate_super() not being called at all, hence the file system would
be still up and running even after successful unmount without user even
noticing it.

The following scenario leads to a bug. While mounting propagate_mnt()
would walk through propagation tree cloning the mount for every every
mount the root propagates to. Even for mounts which parents are not
parents of the directory you're trying to mount to. So it will bump up
the s_active counter.

However before the propagate_mnt() is left it will clean the unneeded
cloned mounts (those which parent root is not parent of your new mount
point), but it will _NOT_ decrement the s_active because umount_tree()
would decrement mnt_longterm causing it to underflow, hence
mntput_no_expire() would bail out before actually calling mntfree() and
releasing the super block (decreasing s_active). At this point super
block will never get released.

User can not directly observe this (aside from seeing running file system
processes even after unmount), but it can be easily reproduced with loop
device.

mount --bind /tmp/one /tmp/two
losetup /dev/loop0 /mnt/test/file0
mount /dev/loop0 /mnt/test1
umount /mnt/test1
losetup -d /dev/loop0
^^^^^^^^^^^^^^^^^^^^^
This will fail because the device is still busy (super block is still
active and s_active is non zero).

This commit fixes this issue.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
Reported-by: Milan Broz <mbroz@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/namespace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index e608199..e72fec7 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -632,7 +632,7 @@ static inline void __mnt_make_longterm(struct mount *mnt)
 static inline void __mnt_make_shortterm(struct mount *mnt)
 {
 #ifdef CONFIG_SMP
-	atomic_dec(&mnt->mnt_longterm);
+	atomic_add_unless(&mnt->mnt_longterm, -1, 0);
 #endif
 }
 
-- 
1.7.7.6

