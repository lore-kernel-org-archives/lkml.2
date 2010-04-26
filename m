Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701Ab0DZTOB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 15:14:01 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:56220 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754644Ab0DZTN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 15:13:59 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL v2] Preparation for BKL'ed ioctl removal
Date: Mon, 26 Apr 2010 21:12:39 +0200
User-Agent: KMail/1.13.2 (Linux/2.6.31-19-generic; KDE/4.4.2; x86_64; ; )
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Al Viro <viro@zeniv.linux.org.uk>,
       Jan Blunck <jblunck@suse.de>, Ingo Molnar <mingo@elte.hu>,
       John Kacur <jkacur@redhat.com>
References: <1271390201-20431-1-git-send-regression-fweisbec@gmail.com> <201004261030.21751.arnd@arndb.de> <alpine.LFD.2.00.1004261104310.3739@i5.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1004261104310.3739@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004262112.39906.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18iKfZhpuxa2fGJsptse9/hNkiQQqt8ihZ/zhg
 EurFB6HFunW8HgQfKO3XfNOEaUI20nFimNsGl0DvrBz4BYJwEN
 lqbZeul46ZlALt1fGzT+A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 26 April 2010 20:08:39 Linus Torvalds wrote:
> I wouldn't mind that. But we've not found people to do it so far, so...

I'll have another go at this tonight, see how far I get doing it
the simplest way for each file.

> NOTE! This has gone through a "allmodconfig" (with staging drivers), but 
> only on x86-64. There are quite probably missing architecture conversions
> and/or drivers. But this should be the bulk of them.

Yes, looks good. I've compared it to a previous series of mine that
changed all the files in a different way. A number of those changes
have found their way into your tree by now, and there were only
two left that you didn't catch (see below), and one false positive
where I patched a struct v4l2_file_operations.

> It doesn't look that bad. Just about 100 files affected. 

The v4l2_file_operations is actually another can of worms, I count
77 more files with a locked ioctl function in there. I'll put that on
the list of things to do before the BKL is gone.

	Arnd

---
Subject: Missing bits from ->ioctl to ->bkl_ioctl conversion

Feel free to fold this into your patch.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/Documentation/filesystems/vfs.txt b/Documentation/filesystems/vfs.txt
index 3de2f32..4890683 100644
--- a/Documentation/filesystems/vfs.txt
+++ b/Documentation/filesystems/vfs.txt
@@ -722,7 +722,7 @@ struct file_operations {
 	ssize_t (*aio_write) (struct kiocb *, const struct iovec *, unsigned long, loff_t);
 	int (*readdir) (struct file *, void *, filldir_t);
 	unsigned int (*poll) (struct file *, struct poll_table_struct *);
-	int (*ioctl) (struct inode *, struct file *, unsigned int, unsigned long);
+	int (*bkl_ioctl) (struct inode *, struct file *, unsigned int, unsigned long);
 	long (*unlocked_ioctl) (struct file *, unsigned int, unsigned long);
 	long (*compat_ioctl) (struct file *, unsigned int, unsigned long);
 	int (*mmap) (struct file *, struct vm_area_struct *);
diff --git a/sound/oss/au1550_ac97.c b/sound/oss/au1550_ac97.c
index c1070e3..7295781 100644
--- a/sound/oss/au1550_ac97.c
+++ b/sound/oss/au1550_ac97.c
@@ -835,11 +835,11 @@ au1550_ioctl_mixdev(struct inode *inode, struct file *file,
 }
 
 static /*const */ struct file_operations au1550_mixer_fops = {
-	owner:THIS_MODULE,
-	llseek:au1550_llseek,
-	ioctl:au1550_ioctl_mixdev,
-	open:au1550_open_mixdev,
-	release:au1550_release_mixdev,
+	.owner = THIS_MODULE,
+	.llseek = au1550_llseek,
+	.bkl_ioctl = au1550_ioctl_mixdev,
+	.open = au1550_open_mixdev,
+	.release = au1550_release_mixdev,
 };
 
 static int
