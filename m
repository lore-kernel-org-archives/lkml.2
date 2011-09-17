Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754183Ab1IRIEc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Sep 2011 04:04:32 -0400
Received: from www17.your-server.de ([213.133.104.17]:43332 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753341Ab1IRIE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Sep 2011 04:04:28 -0400
Subject: [PATCH 3/3] truncate()/ftruncate() fix length argument on ia32
 emulation.
From: Thomas Meyer <thomas@m3y3r.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arch@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 17 Sep 2011 20:01:17 +0200
Message-ID: <1316282477.5814.19.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

move signed-extended int to long, because of signed test.

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---
 arch/x86/ia32/ia32entry.S |    4 ++--
 fs/compat.c               |   10 ++++++++++
 include/linux/compat.h    |    2 ++
 3 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index 30f4116..074b9d3 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -595,8 +595,8 @@ ia32_sys_call_table:
 	.quad compat_sys_old_readdir
 	.quad sys32_mmap		/* 90 */
 	.quad sys_munmap
-	.quad sys_truncate
-	.quad sys_ftruncate
+	.quad compat_sys_truncate
+	.quad compat_sys_ftruncate
 	.quad sys_fchmod
 	.quad sys_fchown16		/* 95 */
 	.quad sys_getpriority
diff --git a/fs/compat.c b/fs/compat.c
index 232675e..315ea2d 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -1814,3 +1814,13 @@ compat_sys_open_by_handle_at(int mountdirfd,
 	return do_handle_open(mountdirfd, handle, flags);
 }
 #endif
+
+asmlinkage long compat_sys_truncate(const char __user *path, int length)
+{
+	return sys_truncate(path, length);
+}
+
+asmlinkage long compat_sys_ftruncate(unsigned int fd, int length)
+{
+	return sys_ftruncate(fd, length);
+}
diff --git a/include/linux/compat.h b/include/linux/compat.h
index 3bfb30a..7a3b0e7 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -544,6 +544,8 @@ asmlinkage ssize_t compat_sys_mq_timedreceive(mqd_t mqdes,
 			const struct compat_timespec __user *u_abs_timeout);
 asmlinkage long compat_sys_socketcall(int call, u32 __user *args);
 asmlinkage long compat_sys_sysctl(struct compat_sysctl_args __user *args);
+asmlinkage long compat_sys_truncate(const char __user *path, int length);
+asmlinkage long compat_sys_ftruncate(unsigned int fd, int length);
 
 extern ssize_t compat_rw_copy_check_uvector(int type,
 		const struct compat_iovec __user *uvector,
-- 
1.7.6


