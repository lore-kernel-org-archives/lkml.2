Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752382Ab2BTAMl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 19:12:41 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57181 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032Ab2BTAMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 19:12:40 -0500
From: "H. Peter Anvin" <hpa@zytor.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: mingo@kernel.org, tglx@linutronix.de, hpa@zytor.com,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        hjl.tools@gmail.com, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <greg@kroah.com>
Subject: [PATCH 08/30] compat: Use COMPAT_USE_64BIT_TIME in the lp driver
Date: Sun, 19 Feb 2012 16:07:46 -0800
Message-Id: <1329696488-16970-9-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1329696488-16970-1-git-send-email-hpa@zytor.com>
References: <1329696488-16970-1-git-send-email-hpa@zytor.com>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 19 Feb 2012 16:12:27 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. J. Lu" <hjl.tools@gmail.com>

Enable the lp driver to be used with a compat ABI with 64-bit time.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <greg@kroah.com>
---
 drivers/char/lp.c |   20 ++++++++++++++------
 1 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/char/lp.c b/drivers/char/lp.c
index f434856..a111ff2 100644
--- a/drivers/char/lp.c
+++ b/drivers/char/lp.c
@@ -706,18 +706,26 @@ static long lp_compat_ioctl(struct file *file, unsigned int cmd,
 {
 	unsigned int minor;
 	struct timeval par_timeout;
-	struct compat_timeval __user *tc;
 	int ret;
 
 	minor = iminor(file->f_path.dentry->d_inode);
 	mutex_lock(&lp_mutex);
 	switch (cmd) {
 	case LPSETTIMEOUT:
-		tc = compat_ptr(arg);
-		if (get_user(par_timeout.tv_sec, &tc->tv_sec) ||
-		    get_user(par_timeout.tv_usec, &tc->tv_usec)) {
-			ret = -EFAULT;
-			break;
+		if (COMPAT_USE_64BIT_TIME) {
+			if (copy_from_user(&par_timeout, (void __user *)arg,
+						sizeof (struct timeval))) {
+				ret = -EFAULT;
+				break;
+			}
+		} else {
+			struct compat_timeval __user *tc;
+			tc = compat_ptr(arg);
+			if (get_user(par_timeout.tv_sec, &tc->tv_sec) ||
+			    get_user(par_timeout.tv_usec, &tc->tv_usec)) {
+				ret = -EFAULT;
+				break;
+			}
 		}
 		ret = lp_set_timeout(minor, &par_timeout);
 		break;
-- 
1.7.6.5

