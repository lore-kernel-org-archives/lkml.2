Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757632Ab0IZOax (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 10:30:53 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53007 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755160Ab0IZOaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 10:30:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=o+JEGx4eoHf3yQmRd1FhKYOkYnWpxMMny6rYbYgkfGCwJXYdJ8VJnZCN8Jawz/I4z5
         DGN8Vo1nfzo/xcSh3gsvKvz7UlmZ/+xTffXnKEIE5EgdyovDbWe6OUCF4AORPtgtvqrQ
         CHfINrpUZepXeY/bxEed+Li92O2QYBKk2IKDo=
Date: Sun, 26 Sep 2010 16:32:41 +0200
From: Lutz Ballaschke <vegan.grindcore@googlemail.com>
To: Giel van Schijndel <me@mortis.eu>
Cc: wim@iguana.be, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCHv3 2/3] watchdog: add f71862fg support
Message-ID: <20100926143241.GC2150@kreios.titan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

from: Lutz Ballaschke <vegan.grindcore@googlemail.com>

ioctl WDIOC_GETTIMELEFT and helper function added to watchdog driver 
for common usage.

Signed-off-by: Lutz Ballaschke <vegan.grindcore@googlemail.com>
---

 drivers/watchdog/f71808e_wdt.c |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)


diff --git a/drivers/watchdog/f71808e_wdt.c b/drivers/watchdog/f71808e_wdt.c
index 546cef6..d070086 100644
--- a/drivers/watchdog/f71808e_wdt.c
+++ b/drivers/watchdog/f71808e_wdt.c
@@ -265,6 +265,24 @@ exit_unlock:
 	return err;
 }
 
+static int watchdog_time_left(void)
+{
+	int ret = 0;
+
+	mutex_lock(&watchdog.lock);
+	ret = superio_enter(watchdog.sioaddr);
+	if (ret)
+		goto exit_unlock;
+
+	superio_select(watchdog.sioaddr, SIO_F71808FG_LD_WDT);
+	ret = superio_inb(watchdog.sioaddr, F71808FG_REG_WD_TIME);
+	superio_exit(watchdog.sioaddr);
+
+exit_unlock:
+	mutex_unlock(&watchdog.lock);
+	return ret;
+}
+
 static int watchdog_keepalive(void)
 {
 	int err = 0;
@@ -590,6 +608,12 @@ static long watchdog_ioctl(struct file *file, unsigned int cmd,
 	case WDIOC_GETTIMEOUT:
 		return put_user(watchdog.timeout, uarg.i);
 
+	case WDIOC_GETTIMELEFT:
+		status = watchdog_time_left();
+		if (status < 0)
+			return status;
+		return put_user(status, uarg.i);
+
 	default:
 		return -ENOTTY;
 
