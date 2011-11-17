Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756512Ab1KQJ4m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 04:56:42 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:37008 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756237Ab1KQJ4l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 04:56:41 -0500
Message-ID: <4EC4DA55.2070706@parallels.com>
Date: Thu, 17 Nov 2011 13:56:37 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Cyrill Gorcunov <gorcunov@openvz.org>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/4] proc: Show namespaces IDs in /proc/pid/ns/* files
References: <4EC4DA15.7090106@parallels.com>
In-Reply-To: <4EC4DA15.7090106@parallels.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Pavel Emelyanov <xemul@parallels.com>

---
 fs/proc/namespaces.c |   12 ++++++++++++
 include/linux/mm.h   |    1 +
 2 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/fs/proc/namespaces.c b/fs/proc/namespaces.c
index be177f7..48c64ab 100644
--- a/fs/proc/namespaces.c
+++ b/fs/proc/namespaces.c
@@ -27,8 +27,20 @@ static const struct proc_ns_operations *ns_entries[] = {
 #endif
 };
 
+static ssize_t proc_ns_read(struct file *file, char __user *buf,
+				      size_t len, loff_t *ppos)
+{
+	char tmp[32];
+	struct proc_inode *ei = PROC_I(file->f_dentry->d_inode);
+
+	snprintf(tmp, sizeof(tmp), "id:\t%lu\n",
+			gen_object_id(ei->ns, GEN_OBJ_ID_NS));
+	return simple_read_from_buffer(buf, len, ppos, tmp, strlen(tmp));
+}
+
 static const struct file_operations ns_file_operations = {
 	.llseek		= no_llseek,
+	.read		= proc_ns_read,
 };
 
 static struct dentry *proc_ns_instantiate(struct inode *dir,
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 80ea327..cd4d727 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1628,6 +1628,7 @@ extern void copy_user_huge_page(struct page *dst, struct page *src,
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE || CONFIG_HUGETLBFS */
 
 enum {
+	GEN_OBJ_ID_NS,
 	GEN_OBJ_ID_TYPES,
 };
 
-- 
1.5.5.6
