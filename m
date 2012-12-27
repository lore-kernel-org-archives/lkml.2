Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752909Ab2L0OhG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 09:37:06 -0500
Received: from mail-la0-f44.google.com ([209.85.215.44]:46250 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855Ab2L0OhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 09:37:03 -0500
Date: Thu, 27 Dec 2012 18:36:26 +0400
From: Andrey Wagin <avagin@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Vagin <avagin@parallels.com>, Pavel Emelyanov <xemul@parallels.com>,
        David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org,
        criu@openvz.org, Cyrill Gorcunov <gorcunov@openvz.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [CRIU] [PATCH 1/4] signalfd: add ability to return siginfo in a
 raw format
Message-ID: <20121227143626.GA15154@gmail.com>
References: <1356336807-5517-1-git-send-email-avagin@openvz.org>
 <1356336807-5517-2-git-send-email-avagin@openvz.org>
 <20121224165306.GA9553@redhat.com>
 <CANaxB-x=fQROdwD1OyU8=Ai9tXWm9QTSsGgfKvPbjn57ER6aZg@mail.gmail.com>
 <20121225143043.GA1813@redhat.com>
 <20121225152716.GA3198@redhat.com>
 <50D9C8E9.6020602@parallels.com>
 <20121225165803.GA9066@redhat.com>
 <20121226144751.GA18767@paralelels.com>
 <20121226163112.GA6593@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="VbJkn9YxBvnuCH5J"
Content-Disposition: inline
In-Reply-To: <20121226163112.GA6593@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline

On Wed, Dec 26, 2012 at 05:31:12PM +0100, Oleg Nesterov wrote:
> On 12/26, Andrew Vagin wrote:
> >
> > On Tue, Dec 25, 2012 at 05:58:03PM +0100, Oleg Nesterov wrote:
> > > On 12/25, Pavel Emelyanov wrote:
> > > >
> > > > On 12/25/2012 07:27 PM, Oleg Nesterov wrote:
> > > > >
> > > > > I guess that probably you actually need DUMP, not DEQUEUE. but the
> > > > > latter is not trivial. However, perhaps we can do this assuming that
> > > > > all other threads are sleeping and nobody can do dequeue_signal().
> > > > > Say, we can play with ppos/llseek. If *ppos is not zero,
> > > > > signalfd_dequeue() could dump the nth entry from list or return 0.
> > > >
> > > > This would be perfect, but isn't it better to preserve the pos
> > > > semantics -- we do know size of entry we're about to copy, we can
> > > > treat pos as offset in bytes, not in elements.
> > >
> > > nr-of-records looks better (more flexible) than nr-of-bytes to me. And
> > > perhaps we can also encode private-or-shared into ppos. But I will not
> > > argue in any case.
> >
> > Oleg and Pavel, could you look at these two patches. I implemented in them,
> > what you described here.
> 
> cosmetics nits below, feel free to ignore...
> 
> Damn. But after I wrote this email I realized that llseek() probably can't
> work. Because peek_offset/f_pos/whatever has to be shared with all processes
> which have this file opened.
> 
> Suppose that the task forks after sys_signalfd(). Now if parent or child
> do llseek this affects them both. This is insane because signalfd is
> "strange" to say at least, fork/dup/etc inherits signalfd_ctx but not the
> "source" of the data.

You are right.

> 
> So I think we should not use llseek. But, probably we can rely on pread() ?
> This way we can avoid the problem above, and this looks even simpler.

Yes. It is a good idea. A new patch is attached to this email. I
implemented pread for signalfd and fixed all your previous comments.

Could you look at this patch. If it's good for you, I will send a whole
serie.

Thanks.

--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=koi8-r
Content-Disposition: attachment; filename="0001-signalfd-add-ability-to-get-signal-without-removing-.patch"

>From 64f8fc4b209c73114622b03a43ea196b01d777f8 Mon Sep 17 00:00:00 2001
From: Andrey Vagin <avagin@openvz.org>
Date: Wed, 26 Dec 2012 13:45:54 +0400
Subject: [PATCH] signalfd: add ability to get signal without removing from
 the queue (v2)

pread(fd, buf, size, pos) with non-zero pos reads siginfo
and leaves signal in a queue.

pos = seq + SIGNALFD_*_OFFSET

seq is a sequence number of a signal in a queue.

SIGNALFD_PRIVATE_OFFSET - read from a private queue.
SIGNALFD_SHARED_OFFSET - read from a shared queue.

v2: llseek() can't be used here, because peek_offset/f_pos/whatever
has to be shared with all processes which have this file opened.

Suppose that the task forks after sys_signalfd(). Now if parent or child
do llseek this affects them both. This is insane because signalfd is
"strange" to say at least, fork/dup/etc inherits signalfd_ctx but not
the" source" of the data. // Oleg Nesterov

Signed-off-by: Andrey Vagin <avagin@openvz.org>
---
 fs/signalfd.c                 | 54 ++++++++++++++++++++++++++++++++++++++++++-
 include/uapi/linux/signalfd.h |  3 +++
 2 files changed, 56 insertions(+), 1 deletion(-)

diff --git a/fs/signalfd.c b/fs/signalfd.c
index ee60d5f..9e4e2fc 100644
--- a/fs/signalfd.c
+++ b/fs/signalfd.c
@@ -50,6 +50,50 @@ struct signalfd_ctx {
 	sigset_t sigmask;
 };
 
+static ssize_t signalfd_peek(struct signalfd_ctx *ctx,
+				siginfo_t *info, unsigned long ppos)
+{
+	struct sigpending *pending;
+	struct sigqueue *q;
+	bool group = 0;
+	loff_t seq, i;
+	int ret = 0;
+
+	if (ppos < SIGNALFD_PRIVATE_OFFSET)
+		return -EINVAL;
+
+	if (ppos >= SIGNALFD_SHARED_OFFSET) {
+		seq = ppos - SIGNALFD_SHARED_OFFSET;
+		group = 1;
+	} else
+		seq = ppos - SIGNALFD_PRIVATE_OFFSET;
+
+	spin_lock_irq(&current->sighand->siglock);
+
+	if (group)
+		pending = &current->signal->shared_pending;
+	else
+		pending = &current->pending;
+
+	i = 0;
+	list_for_each_entry(q, &pending->list, list) {
+		if (sigismember(&ctx->sigmask, q->info.si_signo))
+			continue;
+
+		if (i == seq) {
+			copy_siginfo(info, &q->info);
+			ret = info->si_signo;
+			break;
+		}
+
+		i++;
+	}
+
+	spin_unlock_irq(&current->sighand->siglock);
+
+	return ret;
+}
+
 static int signalfd_release(struct inode *inode, struct file *file)
 {
 	kfree(file->private_data);
@@ -230,7 +274,11 @@ static ssize_t signalfd_read(struct file *file, char __user *buf, size_t count,
 
 	siginfo = (struct signalfd_siginfo __user *) buf;
 	do {
-		ret = signalfd_dequeue(ctx, &info, nonblock);
+		if (*ppos == 0)
+			ret = signalfd_dequeue(ctx, &info, nonblock);
+		else
+			ret = signalfd_peek(ctx, &info, *ppos);
+
 		if (unlikely(ret <= 0))
 			break;
 
@@ -242,6 +290,9 @@ static ssize_t signalfd_read(struct file *file, char __user *buf, size_t count,
 		if (ret < 0)
 			break;
 
+		if (*ppos)
+			(*ppos)++;
+
 		siginfo++;
 		total += ret;
 		nonblock = 1;
@@ -321,6 +372,7 @@ SYSCALL_DEFINE4(signalfd4, int, ufd, sigset_t __user *, user_mask,
 		}
 
 		file->f_flags |= flags & SFD_RAW;
+		file->f_mode |= FMODE_PREAD;
 
 		fd_install(ufd, file);
 	} else {
diff --git a/include/uapi/linux/signalfd.h b/include/uapi/linux/signalfd.h
index bc31849..c6eb535 100644
--- a/include/uapi/linux/signalfd.h
+++ b/include/uapi/linux/signalfd.h
@@ -17,6 +17,9 @@
 #define SFD_NONBLOCK O_NONBLOCK
 #define SFD_RAW O_DIRECT
 
+#define SIGNALFD_SHARED_OFFSET (1LL << 62)
+#define SIGNALFD_PRIVATE_OFFSET 1
+
 struct signalfd_siginfo {
 	__u32 ssi_signo;
 	__s32 ssi_errno;
-- 
1.7.11.7


--VbJkn9YxBvnuCH5J--
