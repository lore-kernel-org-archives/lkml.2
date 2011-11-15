Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432Ab1KOLhN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 06:37:13 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:27389 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755103Ab1KOLhM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 06:37:12 -0500
Message-ID: <4EC24ED6.1050709@parallels.com>
Date: Tue, 15 Nov 2011 15:36:54 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Cyrill Gorcunov <gorcunov@openvz.org>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matt Helsley <matthltc@us.ibm.com>
Subject: [PATCH 2/4] proc: Show namespaces IDs in /proc/pid/ns/* files
References: <4EC24E9E.8040502@parallels.com>
In-Reply-To: <4EC24E9E.8040502@parallels.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Pavel Emelyanov <xemul@parallels.com>

---
 fs/proc/namespaces.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/fs/proc/namespaces.c b/fs/proc/namespaces.c
index be177f7..06baabb 100644
--- a/fs/proc/namespaces.c
+++ b/fs/proc/namespaces.c
@@ -12,6 +12,7 @@
 #include <linux/mnt_namespace.h>
 #include <linux/ipc_namespace.h>
 #include <linux/pid_namespace.h>
+#include <linux/gen_object_ids.h>
 #include "internal.h"
 
 
@@ -27,8 +28,19 @@ static const struct proc_ns_operations *ns_entries[] = {
 #endif
 };
 
+static ssize_t proc_ns_read(struct file *file, char __user *buf,
+				      size_t len, loff_t *ppos)
+{
+	char tmp[32];
+	struct proc_inode *ei = PROC_I(file->f_dentry->d_inode);
+
+	snprintf(tmp, sizeof(tmp), "id:\t%lu\n", gen_object_id(ei->ns));
+	return simple_read_from_buffer(buf, len, ppos, tmp, strlen(tmp));
+}
+
 static const struct file_operations ns_file_operations = {
 	.llseek		= no_llseek,
+	.read		= proc_ns_read,
 };
 
 static struct dentry *proc_ns_instantiate(struct inode *dir,
-- 
1.5.5.6
