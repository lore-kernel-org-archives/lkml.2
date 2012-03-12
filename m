Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755092Ab2CLAuq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 20:50:46 -0400
Received: from 1wt.eu ([62.212.114.60]:63107 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754606Ab2CLAsx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 20:48:53 -0400
Message-Id: <20120312004411.564122356@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 Mar 2012 01:44:17 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Tyler Hicks <tyhicks@linux.vnet.ibm.com>,
        Colin Ian King <colin.king@canonical.com>,
        Tim Gardner <tim.gardner@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 06/13] eCryptfs: Remove mmap from directory operations
In-Reply-To: <fec4dd6c17083169f2e217caca7375ef@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-longterm review patch.  If anyone has any objections, please let me know.

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
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/ecryptfs/file.c b/fs/ecryptfs/file.c
index 4e25328..d8adc51 100644
--- a/fs/ecryptfs/file.c
+++ b/fs/ecryptfs/file.c
@@ -327,7 +327,6 @@ const struct file_operations ecryptfs_dir_fops = {
 #ifdef CONFIG_COMPAT
 	.compat_ioctl = ecryptfs_compat_ioctl,
 #endif
-	.mmap = generic_file_mmap,
 	.open = ecryptfs_open,
 	.flush = ecryptfs_flush,
 	.release = ecryptfs_release,
-- 
1.7.2.1.45.g54fbc



