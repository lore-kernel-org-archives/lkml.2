Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757533Ab0JSXZk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 19:25:40 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37279 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754664Ab0JSXZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 19:25:39 -0400
Subject: Re: [PATCH] support polling of /proc/swaps
From: Kay Sievers <kay.sievers@vrfy.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
In-Reply-To: <20101019153136.b2543f7b.akpm@linux-foundation.org>
References: <1287479956.1729.1.camel@yio.site>
	 <20101019153136.b2543f7b.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Oct 2010 01:25:47 +0200
Message-ID: <1287530747.1171.9.camel@yio.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-19 at 15:31 -0700, Andrew Morton wrote:
> On Tue, 19 Oct 2010 11:19:16 +0200
> Kay Sievers <kay.sievers@vrfy.org> wrote:

> It's a bit sad that we have to add quite a pile of infrastructure to
> make a procfs file pollable.  I wonder if it's possible to provide some
> core support for this, and reduce the amount of code at each particular
> handler site.

You mean something like adding the event counter to the seq_file? There
is /proc/self/mounts,mountinfo and /proc/swaps so far, I think.

> Also, I wonder how we are to communicate the existence of this feature
> to our users.  Nobody will look in Documentation/filesystems/.  Is
> there a manpage?  Seems not...

Hmm, 'man 5 proc'?

> > +static DECLARE_WAIT_QUEUE_HEAD(proc_poll_wait);
> > +static int proc_poll_event;
> 
> Please pick a lock to protect proc_poll_event.

An atomic_t should do it too, right?

> Then document that
> locking here, when you also document proc_poll_event ;)

The actual value has no meaning at all, it just tells that something
happened if it has changed.



From: Kay Sievers <kay.sievers@vrfy.org>
Subject: support polling of /proc/swaps

System management wants to subscribe to changes in swap
configuration. Make /proc/swaps pollable like /proc/mounts.

Signed-Off-By: Kay Sievers <kay.sievers@vrfy.org>
---
 mm/swapfile.c |   48 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 47 insertions(+), 1 deletion(-)

--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -30,6 +30,7 @@
 #include <linux/capability.h>
 #include <linux/syscalls.h>
 #include <linux/memcontrol.h>
+#include <linux/poll.h>
 
 #include <asm/pgtable.h>
 #include <asm/tlbflush.h>
@@ -58,6 +59,9 @@ static struct swap_info_struct *swap_inf
 
 static DEFINE_MUTEX(swapon_mutex);
 
+static DECLARE_WAIT_QUEUE_HEAD(proc_poll_wait);
+static atomic_t proc_poll_event = ATOMIC_INIT(0);
+
 static inline unsigned char swap_count(unsigned char ent)
 {
 	return ent & ~SWAP_HAS_CACHE;	/* may include SWAP_HAS_CONT flag */
@@ -1680,6 +1684,8 @@ SYSCALL_DEFINE1(swapoff, const char __us
 	}
 	filp_close(swap_file, NULL);
 	err = 0;
+	atomic_inc(&proc_poll_event);
+	wake_up_interruptible(&proc_poll_wait);
 
 out_dput:
 	filp_close(victim, NULL);
@@ -1688,6 +1694,25 @@ out:
 }
 
 #ifdef CONFIG_PROC_FS
+struct proc_swaps {
+	struct seq_file seq;
+	int event;
+};
+
+static unsigned swaps_poll(struct file *file, poll_table *wait)
+{
+	struct proc_swaps *s = file->private_data;
+
+	poll_wait(file, &proc_poll_wait, wait);
+
+	if (s->event != atomic_read(&proc_poll_event)) {
+		s->event = atomic_read(&proc_poll_event);
+		return POLLIN | POLLRDNORM | POLLERR | POLLPRI;
+	}
+
+	return POLLIN | POLLRDNORM;
+}
+
 /* iterator */
 static void *swap_start(struct seq_file *swap, loff_t *pos)
 {
@@ -1771,7 +1796,24 @@ static const struct seq_operations swaps
 
 static int swaps_open(struct inode *inode, struct file *file)
 {
-	return seq_open(file, &swaps_op);
+	struct proc_swaps *s;
+	int ret;
+
+	s = kmalloc(sizeof(struct proc_swaps), GFP_KERNEL);
+	if (!s)
+		return -ENOMEM;
+
+	file->private_data = s;
+
+	ret = seq_open(file, &swaps_op);
+	if (ret) {
+		kfree(s);
+		return ret;
+	}
+
+	s->seq.private = s;
+	s->event = atomic_read(&proc_poll_event);
+	return ret;
 }
 
 static const struct file_operations proc_swaps_operations = {
@@ -1779,6 +1821,7 @@ static const struct file_operations proc
 	.read		= seq_read,
 	.llseek		= seq_lseek,
 	.release	= seq_release,
+	.poll		= swaps_poll,
 };
 
 static int __init procswaps_init(void)
@@ -2084,6 +2127,9 @@ SYSCALL_DEFINE2(swapon, const char __use
 		swap_info[prev]->next = type;
 	spin_unlock(&swap_lock);
 	mutex_unlock(&swapon_mutex);
+	atomic_inc(&proc_poll_event);
+	wake_up_interruptible(&proc_poll_wait);
+
 	error = 0;
 	goto out;
 bad_swap:


