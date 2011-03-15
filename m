Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758319Ab1COSsp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 14:48:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22755 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750734Ab1COSso (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 14:48:44 -0400
Message-Id: <201103151848.p2FImgaN015020@int-mx09.intmail.prod.int.phx2.redhat.com>
From: "Richard W.M. Jones" <rjones@redhat.com>
Date: Tue, 15 Mar 2011 18:38:23 +0000
Subject: [PATCH] Allow core_pattern to name block devices.
Apparently-To: <rjones@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
To: unlisted-recipients:; (no To-header on input)

Allow core dumps to block devices by allowing the user to name a block
device in core_pattern.

This is extremely useful when running the kernel in a "captive"
appliance.  There is not necessarily a writable, mounted filesystem
that can be used to catch a core dump, so instead we set aside a
virtual disk for core dumps and allow the kernel to write a core to
that.

This patch was tested by running the modified kernel under qemu (using
libguestfs) and forcing various core dumps to attached virtual disks.

Signed-off-by: Richard W.M. Jones <rjones@redhat.com>
---
 fs/exec.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 52a447d..7aa4b19 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -2047,10 +2047,11 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
 		if (d_unhashed(cprm.file->f_path.dentry))
 			goto close_fail;
 		/*
-		 * AK: actually i see no reason to not allow this for named
-		 * pipes etc, but keep the previous behaviour for now.
+		 * Previously coredumps were only allowed to regular files.
+		 * Block devices are useful too for capturing errors in
+		 * captive appliances.
 		 */
-		if (!S_ISREG(inode->i_mode))
+		if (!S_ISREG(inode->i_mode) && !S_ISBLK(inode->i_mode))
 			goto close_fail;
 		/*
 		 * Dont allow local users get cute and trick others to coredump
-- 
1.7.4
