Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435Ab1CPPjN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 11:39:13 -0400
Received: from 94-30-104-162.xdsl.murphx.net ([94.30.104.162]:54518 "EHLO
	spin.home.annexia.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752987Ab1CPPjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 11:39:08 -0400
X-Greylist: delayed 1023 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Mar 2011 11:39:07 EDT
From: "Richard W.M. Jones" <rjones@redhat.com>
To: "Richard W.M. Jones" <rjones@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] Allow core dumps to block devices as well as regular files.
Date: Wed, 16 Mar 2011 15:21:56 +0000
Message-Id: <1300288916-607-1-git-send-email-rjones@redhat.com>
X-Mailer: git-send-email 1.7.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow core dumps to block devices by allowing the user to name a block
device in core_pattern.  This change also removes the historical
comment which would no longer be accurate.

This is extremely useful when running the kernel in a "captive"
appliance.  There is not necessarily a writable, mounted filesystem
that can be used to catch a core dump, so instead we set aside a
virtual disk for core dumps and allow the kernel to write a core to
that.

This patch was tested by running the modified kernel under qemu (using
libguestfs) and forcing various core dumps to attached virtual disks.

Signed-off-by: Richard W.M. Jones <rjones@redhat.com>
---
 fs/exec.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index ba99e1a..ee8051a 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -2052,11 +2052,7 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
 			goto close_fail;
 		if (d_unhashed(cprm.file->f_path.dentry))
 			goto close_fail;
-		/*
-		 * AK: actually i see no reason to not allow this for named
-		 * pipes etc, but keep the previous behaviour for now.
-		 */
-		if (!S_ISREG(inode->i_mode))
+		if (!S_ISREG(inode->i_mode) && !S_ISBLK(inode->i_mode))
 			goto close_fail;
 		/*
 		 * Dont allow local users get cute and trick others to coredump
-- 
1.7.4

