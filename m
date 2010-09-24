Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521Ab0IXQxG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:53:06 -0400
Received: from kroah.org ([198.145.64.141]:38372 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932691Ab0IXQ2a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:28:30 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Sep 24 09:26:18 2010
Message-Id: <20100924162618.536817208@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 24 Sep 2010 09:24:30 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Vladimir Zapolskiy <vzapolskiy@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>, Ben Dooks <ben@fluff.org.uk>,
        Atul Dahiya <atul.dahiya@samsung.com>,
        Taekgyun Ko <taeggyun.ko@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: [42/80] rtc: s3c: balance state changes of wakeup flag
In-Reply-To: <20100924162706.GA7381@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Vladimir Zapolskiy <vzapolskiy@gmail.com>

commit f501ed524b26ba1b739b7f7feb0a0e1496878769 upstream.

This change resolves a problem about unbalanced calls of
enable_irq_wakeup() and disable_irq_wakeup() for alarm interrupt.

Bug reproduction:

root@eb600:~# echo 0 > /sys/class/rtc/rtc0/wakealarm

WARNING: at kernel/irq/manage.c:361 set_irq_wake+0x7c/0xe4()
 Unbalanced IRQ 46 wake disable
Modules linked in:
[<c0025708>] (unwind_backtrace+0x0/0xd8) from [<c003358c>] (warn_slowpath_common+0x44/0x5c)
[<c003358c>] (warn_slowpath_common+0x44/0x5c) from [<c00335dc>] (warn_slowpath_fmt+0x24/0x30)
[<c00335dc>] (warn_slowpath_fmt+0x24/0x30) from [<c0058c20>] (set_irq_wake+0x7c/0xe4)
[<c0058c20>] (set_irq_wake+0x7c/0xe4) from [<c01b5e80>] (s3c_rtc_setalarm+0xa8/0xb8)
[<c01b5e80>] (s3c_rtc_setalarm+0xa8/0xb8) from [<c01b47a0>] (rtc_set_alarm+0x60/0x74)
[<c01b47a0>] (rtc_set_alarm+0x60/0x74) from [<c01b5a98>] (rtc_sysfs_set_wakealarm+0xc8/0xd8)
[<c01b5a98>] (rtc_sysfs_set_wakealarm+0xc8/0xd8) from [<c01891ec>] (dev_attr_store+0x20/0x24)
[<c01891ec>] (dev_attr_store+0x20/0x24) from [<c00be934>] (sysfs_write_file+0x104/0x13c)
[<c00be934>] (sysfs_write_file+0x104/0x13c) from [<c0080e7c>] (vfs_write+0xb0/0x158)
[<c0080e7c>] (vfs_write+0xb0/0x158) from [<c0080fcc>] (sys_write+0x3c/0x68)
[<c0080fcc>] (sys_write+0x3c/0x68) from [<c0020ec0>] (ret_fast_syscall+0x0/0x28)

Signed-off-by: Vladimir Zapolskiy <vzapolskiy@gmail.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Ben Dooks <ben@fluff.org.uk>
Cc: Atul Dahiya <atul.dahiya@samsung.com>
Cc: Taekgyun Ko <taeggyun.ko@samsung.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/rtc/rtc-s3c.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/drivers/rtc/rtc-s3c.c
+++ b/drivers/rtc/rtc-s3c.c
@@ -298,11 +298,6 @@ static int s3c_rtc_setalarm(struct devic
 
 	s3c_rtc_setaie(alrm->enabled);
 
-	if (alrm->enabled)
-		enable_irq_wake(s3c_rtc_alarmno);
-	else
-		disable_irq_wake(s3c_rtc_alarmno);
-
 	return 0;
 }
 
@@ -547,6 +542,10 @@ static int s3c_rtc_suspend(struct platfo
 		ticnt_en_save &= S3C64XX_RTCCON_TICEN;
 	}
 	s3c_rtc_enable(pdev, 0);
+
+	if (device_may_wakeup(&pdev->dev))
+		enable_irq_wake(s3c_rtc_alarmno);
+
 	return 0;
 }
 
@@ -560,6 +559,10 @@ static int s3c_rtc_resume(struct platfor
 		tmp = readb(s3c_rtc_base + S3C2410_RTCCON);
 		writeb(tmp | ticnt_en_save, s3c_rtc_base + S3C2410_RTCCON);
 	}
+
+	if (device_may_wakeup(&pdev->dev))
+		disable_irq_wake(s3c_rtc_alarmno);
+
 	return 0;
 }
 #else


