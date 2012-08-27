Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218Ab2H0H0f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 03:26:35 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54657 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752460Ab2H0HZZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 03:25:25 -0400
X-IronPort-AV: E=Sophos;i="4.77,833,1336320000"; 
   d="scan'208";a="5730522"
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: Wanlong Gao <gaowanlong@cn.fujitsu.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 1/5] drivers:tty:fix up ENOIOCTLCMD error handling
Date: Mon, 27 Aug 2012 15:23:12 +0800
Message-Id: <1346052196-32682-2-git-send-email-gaowanlong@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1346052196-32682-1-git-send-email-gaowanlong@cn.fujitsu.com>
References: <1346052196-32682-1-git-send-email-gaowanlong@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/27 15:25:14,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/27 15:25:15,
	Serialize complete at 2012/08/27 15:25:15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At commit 07d106d0, Linus pointed out that ENOIOCTLCMD should be
translated as ENOTTY to user mode.
For example:
	fd = open("/dev/tty", O_RDWR);
	ioctl(fd, -1, &argp);

then the errno should be ENOTTY but not EINVAL.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
---
 drivers/tty/tty_io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index b425c79..720c408f 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -2756,7 +2756,7 @@ long tty_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	if (ld->ops->ioctl) {
 		retval = ld->ops->ioctl(tty, file, cmd, arg);
 		if (retval == -ENOIOCTLCMD)
-			retval = -EINVAL;
+			retval = -ENOTTY;
 	}
 	tty_ldisc_deref(ld);
 	return retval;
-- 
1.7.12

