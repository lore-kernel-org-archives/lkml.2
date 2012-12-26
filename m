Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752960Ab2LZOsd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2012 09:48:33 -0500
Received: from relay.parallels.com ([195.214.232.42]:40760 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151Ab2LZOsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2012 09:48:31 -0500
Date: Wed, 26 Dec 2012 18:47:51 +0400
From: Andrew Vagin <avagin@parallels.com>
To: Oleg Nesterov <oleg@redhat.com>
CC: Pavel Emelyanov <xemul@parallels.com>, David Howells <dhowells@redhat.com>,
        <linux-kernel@vger.kernel.org>, <criu@openvz.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>, Andrey Wagin <avagin@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        <linux-fsdevel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [CRIU] [PATCH 1/4] signalfd: add ability to return siginfo in a
 raw	format
Message-ID: <20121226144751.GA18767@paralelels.com>
References: <1356336807-5517-1-git-send-email-avagin@openvz.org>
 <1356336807-5517-2-git-send-email-avagin@openvz.org>
 <20121224165306.GA9553@redhat.com>
 <CANaxB-x=fQROdwD1OyU8=Ai9tXWm9QTSsGgfKvPbjn57ER6aZg@mail.gmail.com>
 <20121225143043.GA1813@redhat.com>
 <20121225152716.GA3198@redhat.com>
 <50D9C8E9.6020602@parallels.com>
 <20121225165803.GA9066@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="M9NhX3UHpAaciwkO"
Content-Disposition: inline
In-Reply-To: <20121225165803.GA9066@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [10.30.16.61]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--M9NhX3UHpAaciwkO
Content-Type: text/plain; charset="koi8-r"
Content-Disposition: inline

On Tue, Dec 25, 2012 at 05:58:03PM +0100, Oleg Nesterov wrote:
> On 12/25, Pavel Emelyanov wrote:
> >
> > On 12/25/2012 07:27 PM, Oleg Nesterov wrote:
> > >
> > > I guess that probably you actually need DUMP, not DEQUEUE. but the
> > > latter is not trivial. However, perhaps we can do this assuming that
> > > all other threads are sleeping and nobody can do dequeue_signal().
> > > Say, we can play with ppos/llseek. If *ppos is not zero,
> > > signalfd_dequeue() could dump the nth entry from list or return 0.
> >
> > This would be perfect, but isn't it better to preserve the pos
> > semantics -- we do know size of entry we're about to copy, we can
> > treat pos as offset in bytes, not in elements.
> 
> nr-of-records looks better (more flexible) than nr-of-bytes to me. And
> perhaps we can also encode private-or-shared into ppos. But I will not
> argue in any case.

Oleg and Pavel, could you look at these two patches. I implemented in them,
what you described here.

> 
> Oleg.
> 
> _______________________________________________
> CRIU mailing list
> CRIU@openvz.org
> http://lists.openvz.org/mailman/listinfo/criu

--M9NhX3UHpAaciwkO
Content-Type: text/plain; charset="koi8-r"
Content-Disposition: attachment;
	filename="0001-signal-add-helper-to-get-siginfo-without-removing-fr.patch"

>From 2b8b475b39f41ca65e623905b2f7d2d9348bfa84 Mon Sep 17 00:00:00 2001
From: Andrey Vagin <avagin@openvz.org>
Date: Thu, 29 Nov 2012 20:51:49 +0400
Subject: [PATCH 1/2] signal: add helper to get siginfo without removing from
 the queue

Signed-off-by: Andrey Vagin <avagin@openvz.org>
---
 include/linux/sched.h |  2 ++
 kernel/signal.c       | 28 ++++++++++++++++++++++++++++
 2 files changed, 30 insertions(+)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 206bb08..a907854 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2222,6 +2222,8 @@ extern void __flush_signals(struct task_struct *);
 extern void ignore_signals(struct task_struct *);
 extern void flush_signal_handlers(struct task_struct *, int force_default);
 extern int dequeue_signal(struct task_struct *tsk, sigset_t *mask, siginfo_t *info);
+extern int peek_signal(struct task_struct *tsk, sigset_t *mask,
+				siginfo_t *info, int offset, bool group);
 
 static inline int dequeue_signal_lock(struct task_struct *tsk, sigset_t *mask, siginfo_t *info)
 {
diff --git a/kernel/signal.c b/kernel/signal.c
index ac5f5e7..aa71213 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -536,6 +536,34 @@ unblock_all_signals(void)
 	spin_unlock_irqrestore(&current->sighand->siglock, flags);
 }
 
+int peek_signal(struct task_struct *tsk, sigset_t *mask,
+			siginfo_t *info, int offset, bool group)
+{
+	struct sigpending *pending;
+	struct sigqueue *q;
+	int i = 0, ret = 0;
+
+	if (group)
+		pending = &tsk->signal->shared_pending;
+	else
+		pending = &tsk->pending;
+
+	list_for_each_entry(q, &pending->list, list) {
+		if (sigismember(mask, q->info.si_signo))
+			continue;
+
+		if (i == offset) {
+			copy_siginfo(info, &q->info);
+			ret = info->si_signo;
+			break;
+		}
+
+		i++;
+	}
+
+	return ret;
+}
+
 static void collect_signal(int sig, struct sigpending *list, siginfo_t *info)
 {
 	struct sigqueue *q, *first = NULL;
-- 
1.7.11.7


--M9NhX3UHpAaciwkO
Content-Type: text/plain; charset="koi8-r"
Content-Disposition: attachment;
	filename="0002-signalfd-add-ability-to-get-signal-without-removing-.patch"

>From 6bf48dd6a77261af0daaa9be19cd13a9a11a008d Mon Sep 17 00:00:00 2001
From: Andrey Vagin <avagin@openvz.org>
Date: Wed, 26 Dec 2012 13:45:54 +0400
Subject: [PATCH 2/2] signalfd: add ability to get signal without removing
 from the queue

lseek sets a sequence number of signal in a queue, then read() returns
siginfo if a signal is exists, otherwise it returns 0. All signals
remain in a queue.

If lseek sets a positive position, signals are taken from a shared queue.
If lseek sets a negative position, signals are taken from a private queue.
If ppos is zero (default), signalfd dequeues signals.

Signed-off-by: Andrey Vagin <avagin@openvz.org>
---
 fs/signalfd.c | 48 ++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 46 insertions(+), 2 deletions(-)

diff --git a/fs/signalfd.c b/fs/signalfd.c
index ee60d5f..0ce6fb3 100644
--- a/fs/signalfd.c
+++ b/fs/signalfd.c
@@ -48,8 +48,21 @@ void signalfd_cleanup(struct sighand_struct *sighand)
 
 struct signalfd_ctx {
 	sigset_t sigmask;
+	loff_t peek_offset;
 };
 
+static ssize_t signalfd_peek(struct signalfd_ctx *ctx, siginfo_t *info)
+{
+       int ret;
+
+       spin_lock_irq(&current->sighand->siglock);
+       ret = peek_signal(current, &ctx->sigmask, info,
+			abs(ctx->peek_offset) - 1, ctx->peek_offset > 0);
+       spin_unlock_irq(&current->sighand->siglock);
+
+       return ret;
+}
+
 static int signalfd_release(struct inode *inode, struct file *file)
 {
 	kfree(file->private_data);
@@ -230,7 +243,11 @@ static ssize_t signalfd_read(struct file *file, char __user *buf, size_t count,
 
 	siginfo = (struct signalfd_siginfo __user *) buf;
 	do {
-		ret = signalfd_dequeue(ctx, &info, nonblock);
+		if (ctx->peek_offset == 0)
+			ret = signalfd_dequeue(ctx, &info, nonblock);
+		else
+			ret = signalfd_peek(ctx, &info);
+
 		if (unlikely(ret <= 0))
 			break;
 
@@ -242,6 +259,13 @@ static ssize_t signalfd_read(struct file *file, char __user *buf, size_t count,
 		if (ret < 0)
 			break;
 
+		if (ctx->peek_offset) {
+			if (ctx->peek_offset > 0)
+				ctx->peek_offset++;
+			else
+				ctx->peek_offset--;
+		}
+
 		siginfo++;
 		total += ret;
 		nonblock = 1;
@@ -264,6 +288,24 @@ static int signalfd_show_fdinfo(struct seq_file *m, struct file *f)
 }
 #endif
 
+loff_t signalfd_llseek(struct file *f, loff_t offset, int whence)
+{
+	struct signalfd_ctx *ctx = f->private_data;
+
+	switch (whence) {
+	case SEEK_SET:
+		ctx->peek_offset = offset;
+		break;
+	case SEEK_CUR:
+		ctx->peek_offset += offset;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return ctx->peek_offset;
+}
+
 static const struct file_operations signalfd_fops = {
 #ifdef CONFIG_PROC_FS
 	.show_fdinfo	= signalfd_show_fdinfo,
@@ -271,7 +313,7 @@ static const struct file_operations signalfd_fops = {
 	.release	= signalfd_release,
 	.poll		= signalfd_poll,
 	.read		= signalfd_read,
-	.llseek		= noop_llseek,
+	.llseek		= signalfd_llseek,
 };
 
 SYSCALL_DEFINE4(signalfd4, int, ufd, sigset_t __user *, user_mask,
@@ -300,6 +342,7 @@ SYSCALL_DEFINE4(signalfd4, int, ufd, sigset_t __user *, user_mask,
 			return -ENOMEM;
 
 		ctx->sigmask = sigmask;
+		ctx->peek_offset = 0;
 
 		ufd = get_unused_fd_flags(flags);
 		if (ufd < 0) {
@@ -321,6 +364,7 @@ SYSCALL_DEFINE4(signalfd4, int, ufd, sigset_t __user *, user_mask,
 		}
 
 		file->f_flags |= flags & SFD_RAW;
+		file->f_mode |= FMODE_LSEEK;
 
 		fd_install(ufd, file);
 	} else {
-- 
1.7.11.7


--M9NhX3UHpAaciwkO--
