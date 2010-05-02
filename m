Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758050Ab0EBQqk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 May 2010 12:46:40 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:49081 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757293Ab0EBQqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 May 2010 12:46:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=eimjs2x5vm/0kUwhJ/mCwE9LkFpeZeWOP6JnrMzfE/uZSz32aV/Oyccy30weeZ/NwI
         GLshUukKXlYB7WWYAIZbRBPjAMOqcZUl/6Q6fNkfp8S1xBd9UDa1u1XYcIqINETH3Yoe
         DNXMp0ex2FOl/2H27n3zFeKHPFfNABRHZI5M8=
From: Changli Gao <xiaosuo@gmail.com>
Cc: Jiri Slaby <jslaby@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Alexey Dobriyan <adobriyan@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Changli Gao <xiaosuo@gmail.com>
Subject: [PATCH] fs: use kmalloc() to allocate fdmem if possible
Date: Mon,  3 May 2010 00:46:16 +0800
Message-Id: <1272818776-7729-1-git-send-email-xiaosuo@gmail.com>
X-Mailer: git-send-email 1.6.4.4
In-Reply-To: <Alexander Viro <viro@zeniv.linux.org.uk>
References: <Alexander Viro <viro@zeniv.linux.org.uk>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

use kmalloc() to allocate fdmem if possible.

vmalloc() is used as a fallback solution for fdmem allocation. Two members are
added into the hole of the structure fdtable to indicate if vmalloc() is used
or not.

Signed-off-by: Changli Gao <xiaosuo@gmail.com>
----
 fs/file.c               |   33 ++++++++++++++++++++-------------
 include/linux/fdtable.h |    2 ++
 2 files changed, 22 insertions(+), 13 deletions(-)
diff --git a/fs/file.c b/fs/file.c
index 34bb7f7..f71dd85 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -39,28 +39,34 @@ int sysctl_nr_open_max = 1024 * 1024; /* raised later */
  */
 static DEFINE_PER_CPU(struct fdtable_defer, fdtable_defer_list);
 
-static inline void * alloc_fdmem(unsigned int size)
+static inline void *alloc_fdmem(unsigned int size, unsigned short *use_vmalloc)
 {
-	if (size <= PAGE_SIZE)
-		return kmalloc(size, GFP_KERNEL);
-	else
-		return vmalloc(size);
+	void *data;
+
+	data = kmalloc(size, GFP_KERNEL);
+	if (data != NULL) {
+		*use_vmalloc = 0;
+		return data;
+	}
+	*use_vmalloc = 1;
+
+	return vmalloc(size);
 }
 
 static inline void free_fdarr(struct fdtable *fdt)
 {
-	if (fdt->max_fds <= (PAGE_SIZE / sizeof(struct file *)))
-		kfree(fdt->fd);
-	else
+	if (fdt->fdarr_vmalloc)
 		vfree(fdt->fd);
+	else
+		kfree(fdt->fd);
 }
 
 static inline void free_fdset(struct fdtable *fdt)
 {
-	if (fdt->max_fds <= (PAGE_SIZE * BITS_PER_BYTE / 2))
-		kfree(fdt->open_fds);
-	else
+	if (fdt->fdset_vmalloc)
 		vfree(fdt->open_fds);
+	else
+		kfree(fdt->open_fds);
 }
 
 static void free_fdtable_work(struct work_struct *work)
@@ -167,12 +173,13 @@ static struct fdtable * alloc_fdtable(unsigned int nr)
 	if (!fdt)
 		goto out;
 	fdt->max_fds = nr;
-	data = alloc_fdmem(nr * sizeof(struct file *));
+	data = alloc_fdmem(nr * sizeof(struct file *), &fdt->fdarr_vmalloc);
 	if (!data)
 		goto out_fdt;
 	fdt->fd = (struct file **)data;
 	data = alloc_fdmem(max_t(unsigned int,
-				 2 * nr / BITS_PER_BYTE, L1_CACHE_BYTES));
+				 2 * nr / BITS_PER_BYTE, L1_CACHE_BYTES),
+			   &fdt->fdset_vmalloc);
 	if (!data)
 		goto out_arr;
 	fdt->open_fds = (fd_set *)data;
diff --git a/include/linux/fdtable.h b/include/linux/fdtable.h
index 013dc52..1e730bc 100644
--- a/include/linux/fdtable.h
+++ b/include/linux/fdtable.h
@@ -30,6 +30,8 @@ struct embedded_fd_set {
 
 struct fdtable {
 	unsigned int max_fds;
+	unsigned short fdarr_vmalloc;
+	unsigned short fdset_vmalloc;
 	struct file ** fd;      /* current fd array */
 	fd_set *close_on_exec;
 	fd_set *open_fds;
