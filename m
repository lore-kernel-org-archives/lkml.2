Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752333Ab2L0DmP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2012 22:42:15 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:63183 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738Ab2L0DmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2012 22:42:13 -0500
Message-ID: <50DBC2E0.3040908@huawei.com>
Date: Thu, 27 Dec 2012 11:39:12 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: <ebiederm@xmission.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>
Subject: [PATCH] userns: Allow unprivileged reboot
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In a container with its own pid namespace and user namespace, rebooting
the system won't reboot the host, but terminate all the processes in
it and thus have the container shutdown, so it's safe.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/sys.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/sys.c b/kernel/sys.c
index 265b376..24d1ef5 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -433,11 +433,12 @@ static DEFINE_MUTEX(reboot_mutex);
 SYSCALL_DEFINE4(reboot, int, magic1, int, magic2, unsigned int, cmd,
 		void __user *, arg)
 {
+	struct pid_namespace *pid_ns = task_active_pid_ns(current);
 	char buffer[256];
 	int ret = 0;
 
 	/* We only trust the superuser with rebooting the system. */
-	if (!capable(CAP_SYS_BOOT))
+	if (!ns_capable(pid_ns->user_ns, CAP_SYS_BOOT))
 		return -EPERM;
 
 	/* For safety, we require "magic" arguments. */
@@ -453,7 +454,7 @@ SYSCALL_DEFINE4(reboot, int, magic1, int, magic2, unsigned int, cmd,
 	 * pid_namespace, the command is handled by reboot_pid_ns() which will
 	 * call do_exit().
 	 */
-	ret = reboot_pid_ns(task_active_pid_ns(current), cmd);
+	ret = reboot_pid_ns(pid_ns, cmd);
 	if (ret)
 		return ret;
 
-- 
1.8.0.2
