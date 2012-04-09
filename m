Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757545Ab2DIRyf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 13:54:35 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:10773 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757497Ab2DIRyd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 13:54:33 -0400
Subject: [PATCH 3/4] ipc: handle MSG_PEEK_ALL flag if
 CONFIG_CHECKPOINT_RESTORE is dropped
To: akpm@linux-foundation.org
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: serge.hallyn@canonical.com, dhowells@redhat.com, arnd@arndb.de,
        lucas.demarchi@profusion.mobi, linux-kernel@vger.kernel.org,
        criu@openvz.org, mtk.manpages@gmail.com
Date: Mon, 09 Apr 2012 21:54:12 +0400
Message-ID: <20120409175412.8358.59542.stgit@localhost6.localdomain6>
In-Reply-To: <20120409175309.8358.21631.stgit@localhost6.localdomain6>
References: <20120409175309.8358.21631.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return -ENOSYS, if user called sys_msgrcv() with MSG_PEEK_ALL flag set and
checkpoint/restore code wasn't compiled.

---
 ipc/compat.c |    5 ++++-
 ipc/msg.c    |    4 ++++
 2 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/ipc/compat.c b/ipc/compat.c
index bb9350d..0163aa1 100644
--- a/ipc/compat.c
+++ b/ipc/compat.c
@@ -377,7 +377,10 @@ long compat_sys_msgrcv(int first, int second, int msgtyp, int third,
 		return -EINVAL;
 	if (second < 0)
 		return -EINVAL;
-
+#ifndef CONFIG_CHECKPOINT_RESTORE
+	if (third & MSG_PEEK_ALL)
+		return -ENOSYS;
+#endif
 	if (!version) {
 		struct compat_ipc_kludge ipck;
 		if (!uptr)
diff --git a/ipc/msg.c b/ipc/msg.c
index 8d63cc7..9d8f249 100644
--- a/ipc/msg.c
+++ b/ipc/msg.c
@@ -819,6 +819,10 @@ long do_msgrcv(int msqid, void __user *buf, size_t bufsz, long msgtyp,
 
 	if (msqid < 0 || (long) bufsz < 0)
 		return -EINVAL;
+#ifndef CONFIG_CHECKPOINT_RESTORE
+	if (msgflg & MSG_PEEK_ALL)
+		return -ENOSYS;
+#endif
 	mode = convert_mode(&msgtyp, msgflg);
 	ns = current->nsproxy->ipc_ns;
 

