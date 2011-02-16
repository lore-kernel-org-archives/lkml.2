Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758303Ab1BPEuK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 23:50:10 -0500
Received: from adelie.canonical.com ([91.189.90.139]:44890 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756159Ab1BPEuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 23:50:06 -0500
From: Andy Whitcroft <apw@canonical.com>
To: Tyler Hicks <tyhicks@linux.vnet.ibm.com>,
        Dustin Kirkland <kirkland@canonical.com>
Cc: ecryptfs-devel@lists.launchpad.net, linux-kernel@vger.kernel.org,
        Andy Whitcroft <apw@canonical.com>
Subject: [PATCH 1/1] ecryptfs: read on a directory should return EISDIR if not supported
Date: Wed, 16 Feb 2011 04:49:59 +0000
Message-Id: <1297831799-5169-1-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

read() calls against a file descriptor connected to a directory are
incorrectly returning EINVAL rather than EISDIR:

  [EISDIR]
    [XSI] [Option Start] The fildes argument refers to a directory and the
    implementation does not allow the directory to be read using read()
    or pread(). The readdir() function should be used instead. [Option End]

This occurs because we do not have a .read operation defined for
ecryptfs directories.  Connect this up to generic_read_dir().

BugLink: http://bugs.launchpad.net/bugs/719691
Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 fs/ecryptfs/file.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/ecryptfs/file.c b/fs/ecryptfs/file.c
index 81e10e6..7d1050e 100644
--- a/fs/ecryptfs/file.c
+++ b/fs/ecryptfs/file.c
@@ -317,6 +317,7 @@ ecryptfs_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 
 const struct file_operations ecryptfs_dir_fops = {
 	.readdir = ecryptfs_readdir,
+	.read = generic_read_dir,
 	.unlocked_ioctl = ecryptfs_unlocked_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl = ecryptfs_compat_ioctl,
-- 
1.7.1

