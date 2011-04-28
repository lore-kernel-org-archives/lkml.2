Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932238Ab1D1IaA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 04:30:00 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:63886 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754618Ab1D1I36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 04:29:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=LBDawUSw4U142cCOOaIV0Tlllkxy0B871n7Y+IjlXvoEr+DtHxfngja1f/DJ15rUIm
         GeW9MauGAA151jfhtM+OdIJu0uT64m7xbTH+xy3Yv55yVSd9S0OSf0teSTLCY5RLpAuV
         TsVo/Ek6WkGwea6uhqYO8sU9U0lCcij6dubJ4=
From: Lifeng Sun <lifongsun@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "James R. Van Zandt" <jrv@vanzandt.mv.com>, blinux-list@redhat.com,
        Clemens Ladisch <clemens@ladisch.de>,
        Massimo Dal Zotto <dz@debian.org>, Corey Minyard <minyard@acm.org>,
        openipmi-developer@lists.sourceforge.net,
        Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org,
        Lifeng Sun <lifongsun@gmail.com>
Subject: [PATCH 3/5] char driver: inappropriate ioctl operation should return ENOTTY
Date: Thu, 28 Apr 2011 16:29:20 +0800
Message-Id: <1303979360-30286-1-git-send-email-lifongsun@gmail.com>
X-Mailer: git-send-email 1.7.5.rc1
In-Reply-To: <1303977891-29280-1-git-send-email-lifongsun@gmail.com>
References: <1303977891-29280-1-git-send-email-lifongsun@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ioctl() calls against a character special file with an inappropriate
ioctl operation are incorrectly returning EINVAL rather than ENOTTY:

  [ENOTTY]
      Inappropriate I/O control operation.

In dtlk I also fix the error code for failing to call copy_to_user.

Signed-off-by: Lifeng Sun <lifongsun@gmail.com>
---
 drivers/char/dtlk.c              |    4 ++--
 drivers/char/hpet.c              |    2 +-
 drivers/char/i8k.c               |    5 +----
 drivers/char/ipmi/ipmi_devintf.c |    3 +++
 drivers/char/random.c            |    2 +-
 5 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/char/dtlk.c b/drivers/char/dtlk.c
index 85156dd..a293431 100644
--- a/drivers/char/dtlk.c
+++ b/drivers/char/dtlk.c
@@ -281,7 +281,7 @@ static long dtlk_ioctl(struct file *file,
 		sp = dtlk_interrogate();
 		mutex_unlock(&dtlk_mutex);
 		if (copy_to_user(argp, sp, sizeof(struct dtlk_settings)))
-			return -EINVAL;
+			return -EFAULT;
 		return 0;
 
 	case DTLK_STATUS:
@@ -289,7 +289,7 @@ static long dtlk_ioctl(struct file *file,
 		return put_user(portval, argp);
 
 	default:
-		return -EINVAL;
+		return -ENOTTY;
 	}
 }
 
diff --git a/drivers/char/hpet.c b/drivers/char/hpet.c
index 7066e80..720de66 100644
--- a/drivers/char/hpet.c
+++ b/drivers/char/hpet.c
@@ -575,7 +575,7 @@ hpet_ioctl_common(struct hpet_dev *devp, int cmd, unsigned long arg,
 	case HPET_IE_ON:
 		return hpet_ioctl_ieon(devp);
 	default:
-		return -EINVAL;
+		return -ENOTTY;
 	}
 
 	err = 0;
diff --git a/drivers/char/i8k.c b/drivers/char/i8k.c
index d72433f..baaa8cc 100644
--- a/drivers/char/i8k.c
+++ b/drivers/char/i8k.c
@@ -317,9 +317,6 @@ i8k_ioctl_unlocked(struct file *fp, unsigned int cmd, unsigned long arg)
 	unsigned char buff[16];
 	int __user *argp = (int __user *)arg;
 
-	if (!argp)
-		return -EINVAL;
-
 	switch (cmd) {
 	case I8K_BIOS_VERSION:
 		val = i8k_get_bios_version();
@@ -370,7 +367,7 @@ i8k_ioctl_unlocked(struct file *fp, unsigned int cmd, unsigned long arg)
 		break;
 
 	default:
-		return -EINVAL;
+		return -ENOTTY;
 	}
 
 	if (val < 0)
diff --git a/drivers/char/ipmi/ipmi_devintf.c b/drivers/char/ipmi/ipmi_devintf.c
index 2aa3977..e4272f2 100644
--- a/drivers/char/ipmi/ipmi_devintf.c
+++ b/drivers/char/ipmi/ipmi_devintf.c
@@ -624,6 +624,9 @@ static int ipmi_ioctl(struct file   *file,
 		rv = ipmi_set_maintenance_mode(priv->user, mode);
 		break;
 	}
+	default:
+		rv = -ENOTTY;
+		break;
 	}
   
 	return rv;
diff --git a/drivers/char/random.c b/drivers/char/random.c
index d4ddeba..40aad1c 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1157,7 +1157,7 @@ static long random_ioctl(struct file *f, unsigned int cmd, unsigned long arg)
 		rand_initialize();
 		return 0;
 	default:
-		return -EINVAL;
+		return -ENOTTY;
 	}
 }
 
-- 
1.7.5.rc1

