Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932611Ab0HJStf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 14:49:35 -0400
Received: from kroah.org ([198.145.64.141]:55446 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932561Ab0HJStN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 14:49:13 -0400
Date: Tue, 10 Aug 2010 11:46:11 -0700
From: Greg KH <greg@kroah.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org, lwn@lwn.net
Subject: Re: Linux 2.6.27.50
Message-ID: <20100810184611.GB10346@kroah.com>
References: <20100810184600.GA10346@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100810184600.GA10346@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Documentation/accounting/.gitignore b/Documentation/accounting/.gitignore
new file mode 100644
index 0000000..8648520
--- /dev/null
+++ b/Documentation/accounting/.gitignore
@@ -0,0 +1 @@
+getdelays
diff --git a/Documentation/auxdisplay/.gitignore b/Documentation/auxdisplay/.gitignore
new file mode 100644
index 0000000..7af2228
--- /dev/null
+++ b/Documentation/auxdisplay/.gitignore
@@ -0,0 +1 @@
+cfag12864b-example
diff --git a/Documentation/connector/.gitignore b/Documentation/connector/.gitignore
new file mode 100644
index 0000000..d2b9c32
--- /dev/null
+++ b/Documentation/connector/.gitignore
@@ -0,0 +1 @@
+ucon
diff --git a/Documentation/ia64/.gitignore b/Documentation/ia64/.gitignore
new file mode 100644
index 0000000..ab806ed
--- /dev/null
+++ b/Documentation/ia64/.gitignore
@@ -0,0 +1 @@
+aliasing-test
diff --git a/Documentation/networking/.gitignore b/Documentation/networking/.gitignore
new file mode 100644
index 0000000..286a568
--- /dev/null
+++ b/Documentation/networking/.gitignore
@@ -0,0 +1 @@
+ifenslave
diff --git a/Documentation/pcmcia/.gitignore b/Documentation/pcmcia/.gitignore
new file mode 100644
index 0000000..53d0813
--- /dev/null
+++ b/Documentation/pcmcia/.gitignore
@@ -0,0 +1 @@
+crc32hash
diff --git a/Documentation/spi/.gitignore b/Documentation/spi/.gitignore
new file mode 100644
index 0000000..4280576
--- /dev/null
+++ b/Documentation/spi/.gitignore
@@ -0,0 +1,2 @@
+spidev_fdx
+spidev_test
diff --git a/Documentation/video4linux/.gitignore b/Documentation/video4linux/.gitignore
new file mode 100644
index 0000000..9527039
--- /dev/null
+++ b/Documentation/video4linux/.gitignore
@@ -0,0 +1 @@
+v4lgrab
diff --git a/Documentation/vm/.gitignore b/Documentation/vm/.gitignore
new file mode 100644
index 0000000..33e8a02
--- /dev/null
+++ b/Documentation/vm/.gitignore
@@ -0,0 +1 @@
+slabinfo
diff --git a/Documentation/watchdog/src/.gitignore b/Documentation/watchdog/src/.gitignore
new file mode 100644
index 0000000..ac90997
--- /dev/null
+++ b/Documentation/watchdog/src/.gitignore
@@ -0,0 +1,2 @@
+watchdog-simple
+watchdog-test
diff --git a/Makefile b/Makefile
index 382a8dd..040c479 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 27
-EXTRAVERSION = .49
+EXTRAVERSION = .50
 NAME = Trembling Tortoise
 
 # *DOCUMENTATION*
diff --git a/arch/x86/boot/compressed/.gitignore b/arch/x86/boot/compressed/.gitignore
index be0ed06..63eff3b 100644
--- a/arch/x86/boot/compressed/.gitignore
+++ b/arch/x86/boot/compressed/.gitignore
@@ -1 +1,3 @@
 relocs
+vmlinux.bin.all
+vmlinux.relocs
diff --git a/drivers/misc/enclosure.c b/drivers/misc/enclosure.c
index 0736cff..f57abe8 100644
--- a/drivers/misc/enclosure.c
+++ b/drivers/misc/enclosure.c
@@ -264,8 +264,11 @@ enclosure_component_register(struct enclosure_device *edev,
 	cdev->groups = enclosure_groups;
 
 	err = device_register(cdev);
-	if (err)
-		ERR_PTR(err);
+	if (err) {
+		ecomp->number = -1;
+		put_device(cdev);
+		return ERR_PTR(err);
+	}
 
 	return ecomp;
 }
diff --git a/drivers/parisc/led.c b/drivers/parisc/led.c
index f9b1266..299b4e6e 100644
--- a/drivers/parisc/led.c
+++ b/drivers/parisc/led.c
@@ -182,16 +182,18 @@ static int led_proc_read(char *page, char **start, off_t off, int count,
 static int led_proc_write(struct file *file, const char *buf, 
 	unsigned long count, void *data)
 {
-	char *cur, lbuf[count + 1];
+	char *cur, lbuf[32];
 	int d;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
 
-	memset(lbuf, 0, count + 1);
+	if (count >= sizeof(lbuf))
+		count = sizeof(lbuf)-1;
 
 	if (copy_from_user(lbuf, buf, count))
 		return -EFAULT;
+	lbuf[count] = 0;
 
 	cur = lbuf;
 
diff --git a/fs/gfs2/dir.c b/fs/gfs2/dir.c
index eed040d..4c83653 100644
--- a/fs/gfs2/dir.c
+++ b/fs/gfs2/dir.c
@@ -393,7 +393,7 @@ static int gfs2_dirent_find_space(const struct gfs2_dirent *dent,
 	unsigned totlen = be16_to_cpu(dent->de_rec_len);
 
 	if (gfs2_dirent_sentinel(dent))
-		actual = GFS2_DIRENT_SIZE(0);
+		actual = 0;
 	if (totlen - actual >= required)
 		return 1;
 	return 0;
diff --git a/fs/xfs/xfs_dfrag.c b/fs/xfs/xfs_dfrag.c
index 75b0cd4..ce2a6a2 100644
--- a/fs/xfs/xfs_dfrag.c
+++ b/fs/xfs/xfs_dfrag.c
@@ -74,7 +74,9 @@ xfs_swapext(
 		goto out_free_sxp;
 	}
 
-	if (!(file->f_mode & FMODE_WRITE) || (file->f_flags & O_APPEND)) {
+	if (!(file->f_mode & FMODE_WRITE) ||
+	    !(file->f_mode & FMODE_READ) ||
+	    (file->f_flags & O_APPEND)) {
 		error = XFS_ERROR(EBADF);
 		goto out_put_file;
 	}
@@ -86,6 +88,7 @@ xfs_swapext(
 	}
 
 	if (!(target_file->f_mode & FMODE_WRITE) ||
+	    !(target_file->f_mode & FMODE_READ) ||
 	    (target_file->f_flags & O_APPEND)) {
 		error = XFS_ERROR(EBADF);
 		goto out_put_target_file;
