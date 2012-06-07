Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753003Ab2FHAAB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 20:00:01 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:61040 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753822Ab2FGX77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 19:59:59 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Sasha Levin <levinsasha928@gmail.com>
Subject: Re: lp: hung task in lp_open
Date: Thu, 7 Jun 2012 23:59:43 +0000
User-Agent: KMail/1.12.2 (Linux/3.4.0-rc3; KDE/4.3.2; x86_64; ; )
Cc: Greg KH <greg@kroah.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>
References: <1339075302.3279.14.camel@lappy>
In-Reply-To: <1339075302.3279.14.camel@lappy>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201206072359.43707.arnd@arndb.de>
X-Provags-ID: V02:K0:W5SiMtAM1T0d3dGmtLW8Ianj5oY5Tth/AdTEeKB5tjp
 aeOjYY/TOAuX6QaI6SRBWg2uJbV82TQZ2cK3c4RjjUdcvfeU46
 hEw9VW/QobJt4h0qvAsFYgSu9BmEX+6xNa9pwKNwpN+8eOC3YZ
 dNqENsMa/zZJSoPBlVUVuowCJrNR6q0qEOaUeoyF+jR4IFQqf3
 h7I98HFOcDQXeR3mtM9IFRKij38hddmIjRGWU7J0nUFxb+q6pN
 3dhtNWxRQPssCTCm5PlTTD1PDeDM/Z04M3UAoljcjMsqPvY1Gb
 A2n5jRn5/QDezrQbuUHAgoYcx0Ij6uZKxxvPovVbkA6oQ0o5WR
 aqL8CZVtASM41LrFHBdo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 07 June 2012, Sasha Levin wrote:
> This appears to be happening since we can block on port open, which
> is done within the mutex lock, so that any further lp_open calls with
> appear to be "hung" on that mutex.
> 
> That mutex was added there as part of BKL cleanup.
> 
> I'm not sure whether the solution here is to get the lock just on the
> parts which need locking, or add it as an exception to the hung task monitor.

Hmm, does the hung task detector only trigger because this is an
uninterruptible sleep? Does this fix it?

8<------
lp: use only one per-port mutex

Different stages of the BKL removal in the lp driver have taken different
approaches: the earlier read/write conversion used a new per-port mutex,
while the later open and ioctl conversion used a global mutex and
did an uninterruptible sleep, which causes tasks to hang when multiple
ones try to open any device. Using mutex_lock_interruptible lets the
user stop waiting for a device that is already open and decouples the
devices from one another.

Reported-by: Sasha Levin <levinsasha928@gmail.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/drivers/char/lp.c b/drivers/char/lp.c
index a741e41..0fcb197 100644
--- a/drivers/char/lp.c
+++ b/drivers/char/lp.c
@@ -493,11 +493,12 @@ static int lp_open(struct inode * inode, struct file * file)
 	unsigned int minor = iminor(inode);
 	int ret = 0;
 
-	mutex_lock(&lp_mutex);
-	if (minor >= LP_NO) {
-		ret = -ENXIO;
-		goto out;
-	}
+	if (minor >= LP_NO)
+		return -ENXIO;
+
+	if (mutex_lock_interruptible(&lp_table[minor].port_mutex))
+		return -ERESTARTSYS;
+
 	if ((LP_F(minor) & LP_EXIST) == 0) {
 		ret = -ENXIO;
 		goto out;
@@ -554,7 +555,7 @@ static int lp_open(struct inode * inode, struct file * file)
 	lp_release_parport (&lp_table[minor]);
 	lp_table[minor].current_mode = IEEE1284_MODE_COMPAT;
 out:
-	mutex_unlock(&lp_mutex);
+	mutex_unlock(&lp_table[minor].port_mutex);
 	return ret;
 }
 
@@ -680,7 +681,8 @@ static long lp_ioctl(struct file *file, unsigned int cmd,
 	int ret;
 
 	minor = iminor(file->f_path.dentry->d_inode);
-	mutex_lock(&lp_mutex);
+	if (mutex_lock_interruptible(&lp_table[minor].port_mutex))
+		return -ERESTARTSYS;
 	switch (cmd) {
 	case LPSETTIMEOUT:
 		if (copy_from_user(&par_timeout, (void __user *)arg,
@@ -694,7 +696,7 @@ static long lp_ioctl(struct file *file, unsigned int cmd,
 		ret = lp_do_ioctl(minor, cmd, arg, (void __user *)arg);
 		break;
 	}
-	mutex_unlock(&lp_mutex);
+	mutex_unlock(&lp_table[minor].port_mutex);
 
 	return ret;
 }
@@ -708,7 +710,8 @@ static long lp_compat_ioctl(struct file *file, unsigned int cmd,
 	int ret;
 
 	minor = iminor(file->f_path.dentry->d_inode);
-	mutex_lock(&lp_mutex);
+	if (mutex_lock_interruptible(&lp_table[minor].port_mutex))
+		return -ERESTARTSYS;
 	switch (cmd) {
 	case LPSETTIMEOUT:
 		if (compat_get_timeval(&par_timeout, compat_ptr(arg))) {
@@ -727,7 +730,7 @@ static long lp_compat_ioctl(struct file *file, unsigned int cmd,
 		ret = lp_do_ioctl(minor, cmd, arg, compat_ptr(arg));
 		break;
 	}
-	mutex_unlock(&lp_mutex);
+	mutex_unlock(&lp_table[minor].port_mutex);
 
 	return ret;
 }
