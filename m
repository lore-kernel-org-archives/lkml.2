Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757828Ab2EIGDf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 02:03:35 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39110 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756553Ab2EIFxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:53:40 -0400
Message-Id: <20120509055046.382751488@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:52:30 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Michael Tokarev <mjt@tls.msk.ru>,
        David Miller <davem@davemloft.net>, Ian Kent <raven@themaw.net>,
        Thomas Meyer <thomas@m3y3r.de>
Subject: [ 121/167] [PATCH] autofs: make the autofsv5 packet file descriptor use a
 packetized pipe
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 64f371bc3107e69efce563a3d0f0e6880de0d537 upstream.

The autofs packet size has had a very unfortunate size problem on x86:
because the alignment of 'u64' differs in 32-bit and 64-bit modes, and
because the packet data was not 8-byte aligned, the size of the autofsv5
packet structure differed between 32-bit and 64-bit modes despite
looking otherwise identical (300 vs 304 bytes respectively).

We first fixed that up by making the 64-bit compat mode know about this
problem in commit a32744d4abae ("autofs: work around unhappy compat
problem on x86-64"), and that made a 32-bit 'systemd' work happily on a
64-bit kernel because everything then worked the same way as on a 32-bit
kernel.

But it turned out that 'automount' had actually known and worked around
this problem in user space, so fixing the kernel to do the proper 32-bit
compatibility handling actually *broke* 32-bit automount on a 64-bit
kernel, because it knew that the packet sizes were wrong and expected
those incorrect sizes.

As a result, we ended up reverting that compatibility mode fix, and
thus breaking systemd again, in commit fcbf94b9dedd.

With both automount and systemd doing a single read() system call, and
verifying that they get *exactly* the size they expect but using
different sizes, it seemed that fixing one of them inevitably seemed to
break the other.  At one point, a patch I seriously considered applying
from Michael Tokarev did a "strcmp()" to see if it was automount that
was doing the operation.  Ugly, ugly.

However, a prettier solution exists now thanks to the packetized pipe
mode.  By marking the communication pipe as being packetized (by simply
setting the O_DIRECT flag), we can always just write the bigger packet
size, and if user-space does a smaller read, it will just get that
partial end result and the extra alignment padding will simply be thrown
away.

This makes both automount and systemd happy, since they now get the size
they asked for, and the kernel side of autofs simply no longer needs to
care - it could pad out the packet arbitrarily.

Of course, if there is some *other* user of autofs (please, please,
please tell me it ain't so - and we haven't heard of any) that tries to
read the packets with multiple writes, that other user will now be
broken - the whole point of the packetized mode is that one system call
gets exactly one packet, and you cannot read a packet in pieces.

Tested-by: Michael Tokarev <mjt@tls.msk.ru>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: David Miller <davem@davemloft.net>
Cc: Ian Kent <raven@themaw.net>
Cc: Thomas Meyer <thomas@m3y3r.de>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/autofs4/autofs_i.h  |   11 +++++++++++
 fs/autofs4/dev-ioctl.c |    2 +-
 fs/autofs4/inode.c     |    2 +-
 3 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/fs/autofs4/autofs_i.h b/fs/autofs4/autofs_i.h
index d8d8e7b..908e184 100644
--- a/fs/autofs4/autofs_i.h
+++ b/fs/autofs4/autofs_i.h
@@ -269,6 +269,17 @@ int autofs4_fill_super(struct super_block *, void *, int);
 struct autofs_info *autofs4_new_ino(struct autofs_sb_info *);
 void autofs4_clean_ino(struct autofs_info *);
 
+static inline int autofs_prepare_pipe(struct file *pipe)
+{
+	if (!pipe->f_op || !pipe->f_op->write)
+		return -EINVAL;
+	if (!S_ISFIFO(pipe->f_dentry->d_inode->i_mode))
+		return -EINVAL;
+	/* We want a packet pipe */
+	pipe->f_flags |= O_DIRECT;
+	return 0;
+}
+
 /* Queue management functions */
 
 int autofs4_wait(struct autofs_sb_info *,struct dentry *, enum autofs_notify);
diff --git a/fs/autofs4/dev-ioctl.c b/fs/autofs4/dev-ioctl.c
index 3dfd615..aa9103f 100644
--- a/fs/autofs4/dev-ioctl.c
+++ b/fs/autofs4/dev-ioctl.c
@@ -376,7 +376,7 @@ static int autofs_dev_ioctl_setpipefd(struct file *fp,
 			err = -EBADF;
 			goto out;
 		}
-		if (!pipe->f_op || !pipe->f_op->write) {
+		if (autofs_prepare_pipe(pipe) < 0) {
 			err = -EPIPE;
 			fput(pipe);
 			goto out;
diff --git a/fs/autofs4/inode.c b/fs/autofs4/inode.c
index 14c7bc0..6e488eb 100644
--- a/fs/autofs4/inode.c
+++ b/fs/autofs4/inode.c
@@ -290,7 +290,7 @@ int autofs4_fill_super(struct super_block *s, void *data, int silent)
 		printk("autofs: could not open pipe file descriptor\n");
 		goto fail_dput;
 	}
-	if (!pipe->f_op || !pipe->f_op->write)
+	if (autofs_prepare_pipe(pipe) < 0)
 		goto fail_fput;
 	sbi->pipe = pipe;
 	sbi->pipefd = pipefd;
-- 
1.7.10



