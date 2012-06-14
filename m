Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756571Ab2FNRP5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 13:15:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4298 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752151Ab2FNRPz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 13:15:55 -0400
Date: Fri, 15 Jun 2012 02:15:53 +0900 (JST)
Message-Id: <20120615.021553.2062569361246467656.yamato@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-bluetooth@vger.kernel.org
Subject: [PATCH 1/8] /proc/net/ entries for bluetooth protocols
From: Masatake YAMATO <yamato@redhat.com>
Organization: Red Hat Japan, Inc.
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lsof command can tell the type of socket processes are using. Internally
lsof uses inode numbers on socket fs as key to resolve the type of
sockets. Files under /proc/net/, such as tcp, udp, unix, etc provides
such inode information.

Unfortunately bluetooth related protocols don't provide such inode
information. This patch series introduces /proc/net/* files for the protocols.


This patch against af_bluetooth.c provides facility to the implementation
of protocols. This patch extends bt_sock_list and introduces two exported
function bt_procfs_init, bt_procfs_cleanup.

The type bt_sock_list is already used in some implementations of
protocols. bt_procfs_init prepares seq_operations which converts
protocol own bt_sock_list data to /proc/net proc entry for the
protocol when the entry is accessed by cat or something process.

What I, lsof user, need is just inode number of bluetooth
socket. Therefore default show handler of seq_operations
prints bluetooth socket common informations including inode
number.

However, people may want more information. The bt_procfs_init
takes a function pointer for customizing the show handler of
seq_operations.

Signed-off-by: Masatake YAMATO <yamato@redhat.com>
---
 include/net/bluetooth/bluetooth.h |   12 ++++
 net/bluetooth/af_bluetooth.c      |  136 +++++++++++++++++++++++++++++++++++++
 2 files changed, 148 insertions(+)

diff --git a/include/net/bluetooth/bluetooth.h b/include/net/bluetooth/bluetooth.h
index 961669b..83a1d1a 100644
--- a/include/net/bluetooth/bluetooth.h
+++ b/include/net/bluetooth/bluetooth.h
@@ -30,6 +30,9 @@
 #include <linux/list.h>
 #include <linux/poll.h>
 #include <net/sock.h>
+#include <linux/seq_file.h>
+
+
 
 #ifndef AF_BLUETOOTH
 #define AF_BLUETOOTH	31
@@ -205,6 +208,10 @@ enum {
 struct bt_sock_list {
 	struct hlist_head head;
 	rwlock_t          lock;
+#ifdef CONFIG_PROC_FS
+        struct file_operations   fops;
+        int (* custom_seq_show)(struct seq_file *, void *);
+#endif
 };
 
 int  bt_sock_register(int proto, const struct net_proto_family *ops);
@@ -293,6 +300,11 @@ extern void hci_sock_cleanup(void);
 extern int bt_sysfs_init(void);
 extern void bt_sysfs_cleanup(void);
 
+extern int  bt_procfs_init(struct module* module, struct net *net, const char *name, 
+			   struct bt_sock_list* sk_list,
+			   int (* seq_show)(struct seq_file *, void *));
+extern void bt_procfs_cleanup(struct net *net, const char *name);
+
 extern struct dentry *bt_debugfs;
 
 int l2cap_init(void);
diff --git a/net/bluetooth/af_bluetooth.c b/net/bluetooth/af_bluetooth.c
index 46e7f86..81a2094 100644
--- a/net/bluetooth/af_bluetooth.c
+++ b/net/bluetooth/af_bluetooth.c
@@ -542,6 +543,141 @@ int bt_sock_wait_state(struct sock *sk, int state, unsigned long timeo)
 }
 EXPORT_SYMBOL(bt_sock_wait_state);
 
+#ifdef CONFIG_PROC_FS
+struct bt_seq_state {
+	struct bt_sock_list *l;
+};
+
+static void *bt_seq_start(struct seq_file *seq, loff_t *pos)
+{
+	struct bt_seq_state *s = seq->private;
+	
+	read_lock(&s->l->lock);
+	return seq_hlist_start_head(&s->l->head, *pos);
+}
+
+static void *bt_seq_next(struct seq_file *seq, void *v, loff_t *pos)
+{
+	struct bt_seq_state *s = seq->private;
+	
+	return seq_hlist_next(v, &s->l->head, pos);
+}
+
+static void bt_seq_stop(struct seq_file *seq, void *v)
+{
+	struct bt_seq_state *s = seq->private;
+
+	read_unlock(&s->l->lock);
+}
+
+static int bt_seq_show(struct seq_file *seq, void *v)
+{
+	struct sock *sk;
+	struct bt_sock *bt;
+	struct bt_seq_state *s = seq->private;
+
+
+	if (v == SEQ_START_TOKEN) {
+		seq_puts(seq ,"sk              RefCnt Rmem   Wmem   User   Inode Src Dst Parent");
+
+		if (s->l->custom_seq_show) {
+			seq_putc(seq, ' ');
+			s->l->custom_seq_show(seq, v);
+		}
+
+		seq_putc(seq, '\n');
+	}
+	else {
+		sk = sk_entry(v);
+		bt = bt_sk(sk);
+		seq_printf(seq, "%pK %-6d %-6u %-6u %-6u %-6lu",
+			   sk,
+			   atomic_read(&sk->sk_refcnt),
+			   sk_rmem_alloc_get(sk),
+			   sk_wmem_alloc_get(sk),
+			   sock_i_uid(sk),
+			   sock_i_ino(sk)
+			);
+		seq_puts(seq, batostr(&bt->src));
+		seq_putc(seq, ' ');
+		seq_puts(seq, batostr(&bt->dst));
+		seq_putc(seq, ' ');
+		seq_printf(seq, "%-6lu", bt->parent? sock_i_ino(bt->parent): 0LU);
+
+		if (s->l->custom_seq_show) {
+			seq_putc(seq, ' ');
+			s->l->custom_seq_show(seq, v);
+		}
+
+		seq_putc(seq, '\n');
+	}
+	return 0;
+}
+
+static struct seq_operations bt_seq_ops = {
+	.start = bt_seq_start,
+	.next  = bt_seq_next,
+	.stop  = bt_seq_stop,
+	.show  = bt_seq_show,
+};
+
+static int bt_seq_open(struct inode *inode, struct file *file)
+{
+	struct bt_sock_list *sk_list;
+	struct bt_seq_state *s;
+
+	sk_list = PDE(inode)->data;
+	s = __seq_open_private(file, &bt_seq_ops,
+			       sizeof(struct bt_seq_state));
+	if (s == NULL)
+		return -ENOMEM;
+	 
+	s->l = sk_list;
+	return 0;
+}
+
+int bt_procfs_init(struct module* module, struct net *net, const char *name, struct bt_sock_list* sk_list,
+		   int (* seq_show)(struct seq_file *, void *))
+{
+	struct proc_dir_entry * pde;
+
+	sk_list->custom_seq_show = seq_show;
+
+	sk_list->fops.owner     = module;
+	sk_list->fops.open      = bt_seq_open;
+	sk_list->fops.read      = seq_read;
+	sk_list->fops.llseek    = seq_lseek;
+	sk_list->fops.release   = seq_release_private;
+	
+	pde = proc_net_fops_create(net, name, 0, &sk_list->fops);
+	if (pde == NULL)
+		return -ENOMEM;
+
+	pde->data = sk_list;
+	
+	return 0;
+}
+
+void bt_procfs_cleanup(struct net *net, const char *name)
+{
+	proc_net_remove(net, name);
+}
+#else
+int bt_procfs_init(struct module* module, struct net *net, const char *name, struct bt_sock_list* sk_list,
+		   int (* seq_show)(struct seq_file *, void *))
+{
+	return 0;
+}
+
+void bt_procfs_cleanup(struct net *net, const char *name)
+{
+}
+#endif
+
+EXPORT_SYMBOL(bt_procfs_init);
+EXPORT_SYMBOL(bt_procfs_cleanup);
+
+
 static struct net_proto_family bt_sock_family_ops = {
 	.owner	= THIS_MODULE,
 	.family	= PF_BLUETOOTH,
-- 
1.7.10.2

