Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144Ab0KYK1b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 05:27:31 -0500
Received: from ping.uio.no ([193.157.115.196]:39722 "EHLO ping.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751955Ab0KYK1a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 05:27:30 -0500
X-Greylist: delayed 1967 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Nov 2010 05:27:29 EST
Date: Thu, 25 Nov 2010 10:54:37 +0100
From: Morten Hustveit <mortehu@ping.uio.no>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] fcntl: Add the F_READAHEAD command
Message-ID: <20101125095437.GA3409@ping.uio.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Exiscan-Spam-Score: -5.0 (-----)
X-Exiscan-Spam-Report: SpamAssassin 3.2.5 (2008-06-10) on rossum.ping.uio.no
	Score  Rule
	* -5.0 PING_UIO_MAIL_IS_INTERNAL Message has never been outside
	*      129.240.0.0/16 or 193.157.115.0/24
	* -0.0 NO_RELAYS Informational: message was not relayed via SMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow userland applications to control the read-ahead per file descriptor.

For example, this interface can be used to adjust read sizes in applications
using sendfile() to serve many streams from disk.

The implementation is based on sys_readahead() and sys_fadvise64().

The same interface was added to FreeBSD in 2009.

Signed-off-by: Morten Hustveit <mortehu@ping.uio.no>
--- 
diff --git a/fs/fcntl.c b/fs/fcntl.c
index ecc8b39..19a8a46 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -340,6 +340,31 @@ static int f_getown_ex(struct file *filp, unsigned long arg)
 	return ret;
 }
 
+static int f_readahead(struct file *filp, unsigned long arg)
+{
+	struct address_space *mapping;
+
+	mapping = filp->f_mapping;
+	if (!mapping || !mapping->a_ops || !mapping->a_ops->readpage)
+		return -EINVAL;
+
+	if (mapping->a_ops->get_xip_mem)
+		return 0;
+
+	if (arg) {
+		filp->f_ra.ra_pages = (arg + PAGE_SIZE - 1) >> PAGE_SHIFT;
+		spin_lock(&filp->f_lock);
+		filp->f_mode &= ~FMODE_RANDOM;
+		spin_unlock(&filp->f_lock);
+	} else {
+		spin_lock(&filp->f_lock);
+		filp->f_mode |= FMODE_RANDOM;
+		spin_unlock(&filp->f_lock);
+	}
+
+	return 0;
+}
+
 static long do_fcntl(int fd, unsigned int cmd, unsigned long arg,
 		struct file *filp)
 {
@@ -420,6 +445,9 @@ static long do_fcntl(int fd, unsigned int cmd, unsigned long arg,
 	case F_GETPIPE_SZ:
 		err = pipe_fcntl(filp, cmd, arg);
 		break;
+	case F_READAHEAD:
+		err = f_readahead(filp, arg);
+		break;
 	default:
 		break;
 	}
diff --git a/include/linux/fcntl.h b/include/linux/fcntl.h
index afc00af..69d8e4d 100644
--- a/include/linux/fcntl.h
+++ b/include/linux/fcntl.h
@@ -28,6 +28,11 @@
 #define F_GETPIPE_SZ	(F_LINUX_SPECIFIC_BASE + 8)
 
 /*
+ * Set read-ahead buffer size
+ */
+#define F_READAHEAD	(F_LINUX_SPECIFIC_BASE + 9)
+
+/*
  * Types of directory notifications that may be requested.
  */
 #define DN_ACCESS	0x00000001	/* File accessed */
