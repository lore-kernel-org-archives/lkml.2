Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965180Ab2CAVty (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 16:49:54 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:35281 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965064Ab2CAVtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 16:49:53 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.135.71 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
MIME-Version: 1.0
Message-Id: <20120301213924.051028223@linuxfoundation.org>
User-Agent: quilt/0.51-17.1
Date: Thu, 01 Mar 2012 13:39:33 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Tyler Hicks <tyhicks@linux.vnet.ibm.com>,
        Colin Ian King <colin.king@canonical.com>,
        Tim Gardner <tim.gardner@canonical.com>,
        "Adrian C." <anrxc@sysphere.org>
Subject: [ 11/34] eCryptfs: Remove mmap from directory operations
In-Reply-To: <20120301214654.GA13231@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------


From: Tyler Hicks <tyhicks@linux.vnet.ibm.com>

backported from 38e3eaeedcac75360af8a92e7b66956ec4f334e5

Adrian reported that mkfontscale didn't work inside of eCryptfs mounts.
Strace revealed the following:

open("./", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY|O_CLOEXEC) = 3
fcntl64(3, F_GETFD) = 0x1 (flags FD_CLOEXEC)
open("./fonts.scale", O_WRONLY|O_CREAT|O_TRUNC, 0666) = 4
getdents(3, /* 80 entries */, 32768) = 2304
open("./.", O_RDONLY) = 5
fcntl64(5, F_SETFD, FD_CLOEXEC) = 0
fstat64(5, {st_mode=S_IFDIR|0755, st_size=16384, ...}) = 0
mmap2(NULL, 16384, PROT_READ, MAP_PRIVATE, 5, 0) = 0xb7fcf000
close(5) = 0
 --- SIGBUS (Bus error) @ 0 (0) ---
 +++ killed by SIGBUS +++

The mmap2() on a directory was successful, resulting in a SIGBUS
signal later.  This patch removes mmap() from the list of possible
ecryptfs_dir_fops so that mmap() isn't possible on eCryptfs directory
files.

http://bugs.launchpad.net/bugs/400443

Reported-by: Adrian C. <anrxc@sysphere.org>
Signed-off-by: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ecryptfs/file.c |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/ecryptfs/file.c
+++ b/fs/ecryptfs/file.c
@@ -327,7 +327,6 @@ const struct file_operations ecryptfs_di
 #ifdef CONFIG_COMPAT
 	.compat_ioctl = ecryptfs_compat_ioctl,
 #endif
-	.mmap = generic_file_mmap,
 	.open = ecryptfs_open,
 	.flush = ecryptfs_flush,
 	.release = ecryptfs_release,


