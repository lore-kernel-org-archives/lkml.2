Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755855Ab1HRMTP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 08:19:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42519 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755816Ab1HRMTM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 08:19:12 -0400
From: Lukas Czerner <lczerner@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 1/5] fs: add netlink notification interface
Date: Thu, 18 Aug 2011 14:18:22 +0200
Message-Id: <1313669906-14931-2-git-send-email-lczerner@redhat.com>
In-Reply-To: <1313669906-14931-1-git-send-email-lczerner@redhat.com>
References: <1313669906-14931-1-git-send-email-lczerner@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There might be a lot of crazy things happening inside the file systems
but it might result in bogus error code returned to the user space. And
sometimes it is hard to figure out what just happened. This
commit adds the interface which can be used by file systems to send
better information to the user space via netlink interface, because it
is not bound with error codes.

Also applications might not report problems with the file systems
correctly, hence the administrator will never know about the problem
unless it is already too late. Also in the case of ENOSPC conditions
even if we are checking 'df' output from cronjob, we might miss some
ENOSPC states because it just takes snapshots of the state. Those are
just examples.

With this interface file system can send a message via netlink interface
at the moment when the problem arises.

In order to use this file system must register the netlink
interface with init_fs_nl_family() on module initialization and the in
can send messages with fs_nl_send_warning().

At this point there are only two types of warning FS_NL_ENOSPC_WARN,
which should be used in situations when file system does not have enough
space to reserve data blocks and FS_NL_META_ENOSPC_WARN, for situations
when file system does not have enough space to reserve metadata blocks.
But more can be added in the future.

The code has been based on fs/quota/netlink.c which is used to send
quota warnings to the user space. Eventually it can be merged into this
interface.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
---
 fs/Makefile        |    2 +-
 fs/netlink.c       |  107 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/fs.h |   11 +++++
 3 files changed, 119 insertions(+), 1 deletions(-)
 create mode 100644 fs/netlink.c

diff --git a/fs/Makefile b/fs/Makefile
index afc1096..7e9c61f 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -11,7 +11,7 @@ obj-y :=	open.o read_write.o file_table.o super.o \
 		attr.o bad_inode.o file.o filesystems.o namespace.o \
 		seq_file.o xattr.o libfs.o fs-writeback.o \
 		pnode.o drop_caches.o splice.o sync.o utimes.o \
-		stack.o fs_struct.o statfs.o
+		stack.o fs_struct.o statfs.o netlink.o
 
 ifeq ($(CONFIG_BLOCK),y)
 obj-y +=	buffer.o bio.o block_dev.o direct-io.o mpage.o ioprio.o
diff --git a/fs/netlink.c b/fs/netlink.c
new file mode 100644
index 0000000..15c44a1
--- /dev/null
+++ b/fs/netlink.c
@@ -0,0 +1,107 @@
+#include <linux/fs.h>
+#include <linux/cred.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <net/netlink.h>
+#include <net/genetlink.h>
+
+enum {
+	FS_NL_A_UNSPEC,
+	FS_NL_A_WARNING,
+	FS_NL_A_DEV_MAJOR,
+	FS_NL_A_DEV_MINOR,
+	FS_NL_A_CAUSED_ID,
+	__FS_NL_A_MAX,
+};
+#define FS_NL_A_MAX (__FS_NL_A_MAX - 1)
+
+enum {
+	FS_NL_C_UNSPEC,
+	FS_NL_C_WARNING,
+	__FS_NL_C_MAX,
+};
+#define FS_NL_C_MAX (__FS_NL_C_MAX - 1)
+
+
+static struct genl_family fs_genl_family = {
+	.id = GENL_ID_GENERATE,
+	.hdrsize = 0,
+	.name = "FS_MSG",
+	.version = 1,
+	.maxattr = FS_NL_A_MAX,
+};
+static int registered;
+
+/**
+ * fs_nl_send_warning - Send warning from file system to userspace
+ * @dev: The device on which the fs is mounted
+ * @warntype: The type of the warning
+ *
+ * This can be used by file systems to send a warning message to the
+ * userspace.
+ */
+
+void fs_nl_send_warning(dev_t dev, unsigned int warntype)
+{
+	static atomic_t seq;
+	struct sk_buff *skb;
+	void *msg_head;
+	int ret;
+	int msg_size = nla_total_size(sizeof(u64)) +
+			3 * nla_total_size(sizeof(u32));
+
+	/* We have to allocate using GFP_NOFS as we are called from a
+	 * filesystem performing write and thus further recursion into
+	 * the fs to free some data could cause deadlocks. */
+	skb = genlmsg_new(msg_size, GFP_NOFS);
+	if (!skb) {
+		printk(KERN_ERR
+		  "VFS: Not enough memory to send fs warning.\n");
+		return;
+	}
+	msg_head = genlmsg_put(skb, 0, atomic_add_return(1, &seq),
+			&fs_genl_family, 0, FS_NL_C_WARNING);
+	if (!msg_head) {
+		printk(KERN_ERR
+		  "VFS: Cannot store netlink header in fs warning.\n");
+		goto err_out;
+	}
+	ret = nla_put_u32(skb, FS_NL_A_WARNING, warntype);
+	if (ret)
+		goto attr_err_out;
+	ret = nla_put_u32(skb, FS_NL_A_DEV_MAJOR, MAJOR(dev));
+	if (ret)
+		goto attr_err_out;
+	ret = nla_put_u32(skb, FS_NL_A_DEV_MINOR, MINOR(dev));
+	if (ret)
+		goto attr_err_out;
+	ret = nla_put_u64(skb, FS_NL_A_CAUSED_ID, current_uid());
+	if (ret)
+		goto attr_err_out;
+	genlmsg_end(skb, msg_head);
+	genlmsg_multicast(skb, 0, fs_genl_family.id, GFP_NOFS);
+	return;
+attr_err_out:
+	printk(KERN_ERR "VFS: Not enough space to compose "
+			"fs netlink message!\n");
+err_out:
+	kfree_skb(skb);
+}
+EXPORT_SYMBOL(fs_nl_send_warning);
+
+void init_fs_nl_family(void)
+{
+	if (registered)
+		return;
+
+	if (genl_register_family(&fs_genl_family) != 0) {
+		printk(KERN_ERR
+		       "VFS: Failed to create fs netlink interface.\n");
+		return;
+	}
+	registered = 1;
+}
+EXPORT_SYMBOL(init_fs_nl_family);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 178cdb4..78ba846 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2663,5 +2663,16 @@ static inline void inode_has_no_xattr(struct inode *inode)
 		inode->i_flags |= S_NOSEC;
 }
 
+/*
+ * Definition for fs netlink interface
+ */
+#define FS_NL_NOWARN		0
+#define FS_NL_ENOSPC_WARN	1
+#define FS_NL_META_ENOSPC_WARN	2
+
+/* fs/netlink.c */
+void init_fs_nl_family(void);
+void fs_nl_send_warning(dev_t dev, unsigned int warntype);
+
 #endif /* __KERNEL__ */
 #endif /* _LINUX_FS_H */
-- 
1.7.4.4

