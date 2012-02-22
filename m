Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751561Ab2BVF5h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 00:57:37 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:38399 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750888Ab2BVF5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 00:57:36 -0500
X-Sasl-enc: XTdqGK9YUcrt9XS1QIGNLuJiPqtBCvw919mlR3Qh+z+mI9am8XpMzYGeyQ 1329890254
Message-ID: <1329890251.2193.50.camel@perseus.themaw.net>
Subject: Re: compat: autofs v5 packet size ambiguity - update
From: Ian Kent <raven@themaw.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, autofs@vger.kernel.org,
        Thomas Meyer <thomas@m3y3r.de>, Al Viro <viro@zeniv.linux.org.uk>
Date: Wed, 22 Feb 2012 13:57:31 +0800
In-Reply-To: <1329890027.2193.48.camel@perseus.themaw.net>
References: <CA+55aFzhS69QSoN1j+Z2md116u+3OfniAoE0QMo6xyBjDyjbEw@mail.gmail.com>
	 <20120221.221609.218135609185671883.davem@davemloft.net>
	 <CA+55aFwvmZGDzO_8wwYfH8HsLE=qCmLkJfeMyCe4PVvOYbDMHQ@mail.gmail.com>
	 <CA+55aFzv3X3yW8WZGMZO+aKa=qWi2w8=zn2DP-Q3jRry8Ermyw@mail.gmail.com>
	 <CA+55aFyh1NmBt0LwR3+iD6B-Xa8wAs-nGJ0MBouPhTzWUi8W5g@mail.gmail.com>
	 <1329889428.2193.45.camel@perseus.themaw.net>
	 <1329890027.2193.48.camel@perseus.themaw.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-02-22 at 13:53 +0800, Ian Kent wrote:
> On Wed, 2012-02-22 at 13:43 +0800, Ian Kent wrote:
> > On Tue, 2012-02-21 at 20:56 -0800, Linus Torvalds wrote:
> 
> Ahh ... forgot to set the file_operations structure member .. oops
> 
> >  
> > +static int autofs4_root_dir_open(struct inode *inode, struct file *file)
> > +{
> > +	struct autofs_sb_info *sbi= autofs4_sbi(file->f_path.dentry->d_sb);
> > +	if (sbi->compat_daemon < 0)
> > +		sbi->compat_daemon = is_compat_task();
> > +	return dcache_dir_open(inode, file);
> > +}
> > +
> 

Lets try that again.

autofs: work around unhappy compat problem on x86-64

From: Ian Kent <raven@themaw.net>

When the autofs protocol version 5 packet type was added in commit
5c0a32fc2cd0 ("autofs4: add new packet type for v5 communications"), it
obvously tried quite hard to be word-size agnostic, and uses explicitly
sized fields that are all correctly aligned.

However, with the final "char name[NAME_MAX+1]" array at the end, the
actual size of the structure ends up being not very well defined:
because the struct isn't marked 'packed', doing a "sizeof()" on it will
align the size of the struct up to the biggest alignment of the members
it has.

And despite all the members being the same, the alignment of them is
different: a "__u64" has 4-byte alignment on x86-32, but native 8-byte
alignment on x86-64.  And while 'NAME_MAX+1' ends up being a nice round
number (256), the name[] array starts out a 4-byte aligned.

End result: the "packed" size of the structure is 300 bytes: 4-byte, but
not 8-byte aligned.

As a result, despite all the fields being in the same place on all
architectures, sizeof() will round up that size to 304 bytes on
architectures that have 8-byte alignment for u64.

Note that this is *not* a problem for 32-bit compat mode on POWER, since
there __u64 is 8-byte aligned even in 32-bit mode.  But on x86, 32-bit
and 64-bit alignment is different for 64-bit entities, and as a result
the structure that has exactly the same layout has different sizes.

So on x86-64, but no other architecture, we will just subtract 4 from
the size of the structure when running in a compat task.  That way we
will write the properly sized packet that user mode expects.

Not pretty.  Sadly, this very subtle, and unnecessary, size difference
has been encoded in user space that wants to read packets of *exactly*
the right size, and will refuse to touch anything else.

Reported-and-tested-by: Thomas Meyer <thomas@m3y3r.de>
Cc: Ian Kent <raven@themaw.net>
---

 fs/autofs4/autofs_i.h  |    1 +
 fs/autofs4/dev-ioctl.c |    3 +++
 fs/autofs4/inode.c     |    1 +
 fs/autofs4/root.c      |   11 ++++++++++-
 fs/autofs4/waitq.c     |   23 ++++++++++++++++++++---
 5 files changed, 35 insertions(+), 4 deletions(-)


diff --git a/fs/autofs4/autofs_i.h b/fs/autofs4/autofs_i.h
index d8d8e7b..eb1cc92 100644
--- a/fs/autofs4/autofs_i.h
+++ b/fs/autofs4/autofs_i.h
@@ -110,6 +110,7 @@ struct autofs_sb_info {
 	int sub_version;
 	int min_proto;
 	int max_proto;
+	int compat_daemon;
 	unsigned long exp_timeout;
 	unsigned int type;
 	int reghost_enabled;
diff --git a/fs/autofs4/dev-ioctl.c b/fs/autofs4/dev-ioctl.c
index 76741d8..868fd57 100644
--- a/fs/autofs4/dev-ioctl.c
+++ b/fs/autofs4/dev-ioctl.c
@@ -265,6 +265,9 @@ static int autofs_dev_ioctl_open_mountpoint(const char *name, dev_t devid)
 		}
 
 		autofs_dev_ioctl_fd_install(fd, filp);
+
+		if (sbi->compat_daemon < 0)
+			sbi->compat_daemon = is_compat_task();
 	}
 
 	return fd;
diff --git a/fs/autofs4/inode.c b/fs/autofs4/inode.c
index e16980b..2920bbd 100644
--- a/fs/autofs4/inode.c
+++ b/fs/autofs4/inode.c
@@ -224,6 +224,7 @@ int autofs4_fill_super(struct super_block *s, void *data, int silent)
 	set_autofs_type_indirect(&sbi->type);
 	sbi->min_proto = 0;
 	sbi->max_proto = 0;
+	sbi->compat_daemon = -1;	/* unknown */
 	mutex_init(&sbi->wq_mutex);
 	mutex_init(&sbi->pipe_mutex);
 	spin_lock_init(&sbi->fs_lock);
diff --git a/fs/autofs4/root.c b/fs/autofs4/root.c
index 75e5f1c..ea0dc27 100644
--- a/fs/autofs4/root.c
+++ b/fs/autofs4/root.c
@@ -31,6 +31,7 @@ static long autofs4_root_ioctl(struct file *,unsigned int,unsigned long);
 #ifdef CONFIG_COMPAT
 static long autofs4_root_compat_ioctl(struct file *,unsigned int,unsigned long);
 #endif
+static int autofs4_root_dir_open(struct inode *inode, struct file *file);
 static int autofs4_dir_open(struct inode *inode, struct file *file);
 static struct dentry *autofs4_lookup(struct inode *,struct dentry *, struct nameidata *);
 static struct vfsmount *autofs4_d_automount(struct path *);
@@ -38,7 +39,7 @@ static int autofs4_d_manage(struct dentry *, bool);
 static void autofs4_dentry_release(struct dentry *);
 
 const struct file_operations autofs4_root_operations = {
-	.open		= dcache_dir_open,
+	.open		= autofs4_root_dir_open,
 	.release	= dcache_dir_close,
 	.read		= generic_read_dir,
 	.readdir	= dcache_readdir,
@@ -71,6 +72,14 @@ const struct dentry_operations autofs4_dentry_operations = {
 	.d_release	= autofs4_dentry_release,
 };
 
+static int autofs4_root_dir_open(struct inode *inode, struct file *file)
+{
+	struct autofs_sb_info *sbi= autofs4_sbi(file->f_path.dentry->d_sb);
+	if (sbi->compat_daemon < 0)
+		sbi->compat_daemon = is_compat_task();
+	return dcache_dir_open(inode, file);
+}
+
 static void autofs4_add_active(struct dentry *dentry)
 {
 	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
diff --git a/fs/autofs4/waitq.c b/fs/autofs4/waitq.c
index da8876d..8ec8507 100644
--- a/fs/autofs4/waitq.c
+++ b/fs/autofs4/waitq.c
@@ -15,6 +15,7 @@
 #include <linux/time.h>
 #include <linux/signal.h>
 #include <linux/file.h>
+#include <linux/compat.h>
 #include "autofs_i.h"
 
 /* We make this a static variable rather than a part of the superblock; it
@@ -91,7 +92,24 @@ static int autofs4_write(struct autofs_sb_info *sbi,
 
 	return (bytes > 0);
 }
-	
+
+/*
+ * The autofs_v5 packet was misdesigned.
+ *
+ * The packets are identical on x86-32 and x86-64, but have different
+ * alignment. Which means that 'sizeof()' will give different results.
+ * Fix it up for the case of running 32-bit user mode on a 64-bit kernel.
+ */
+static noinline size_t autofs_v5_packet_size(struct autofs_sb_info *sbi)
+{
+	size_t pktsz = sizeof(struct autofs_v5_packet);
+#if defined(CONFIG_X86_64) && defined(CONFIG_COMPAT)
+	if (sbi->compat_daemon > 0)
+		pktsz -= 4;
+#endif
+	return pktsz;
+}
+
 static void autofs4_notify_daemon(struct autofs_sb_info *sbi,
 				 struct autofs_wait_queue *wq,
 				 int type)
@@ -155,8 +173,7 @@ static void autofs4_notify_daemon(struct autofs_sb_info *sbi,
 	{
 		struct autofs_v5_packet *packet = &pkt.v5_pkt.v5_packet;
 
-		pktsz = sizeof(*packet);
-
+		pktsz = autofs_v5_packet_size(sbi);
 		packet->wait_queue_token = wq->wait_queue_token;
 		packet->len = wq->name.len;
 		memcpy(packet->name, wq->name.name, wq->name.len);


