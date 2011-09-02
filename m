Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755932Ab1IBVDM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 17:03:12 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:29732 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755787Ab1IBVDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 17:03:08 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-4.tower-127.messagelabs.com!1314997385!30408591!1
X-Originating-IP: [216.166.12.178]
X-StarScan-Version: 6.3.6; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] vt_ioctl.c: fix compile error with pm_set_vt_switch()
Date: Fri, 2 Sep 2011 14:02:42 -0700
User-Agent: KMail/1.9.9
CC: <gregkh@suse.de>, <akpm@linux-foundation.org>, <art@ified.ca>,
        <arnd@arndb.de>, <jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201109021402.42503.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When CONFIG_PM_SLEEP, CONFIG_VT, and CONFIG_VT_CONSOLE are not enabled
the function pm_set_vt_switch() is defined as an inline in linux/suspend.h. This causes
a compile error if CONFIG_VT is enabled.

drivers/tty/vt/vt_ioctl.c:1794: error: redefinition of 'pm_set_vt_switch'
include/linux/suspend.h:17: error: previous definition of 'pm_set_vt_switch' was here

Fix this with an #if defined guard around the function in vt_ioctl.c.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Arthur Taylor <art@ified.ca>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Jiri Slaby <jslaby@suse.cz>

---

diff --git a/drivers/tty/vt/vt_ioctl.c b/drivers/tty/vt/vt_ioctl.c
index 5e096f4..7bb1b4d 100644
--- a/drivers/tty/vt/vt_ioctl.c
+++ b/drivers/tty/vt/vt_ioctl.c
@@ -1784,6 +1784,8 @@ int vt_move_to_console(unsigned int vt, int alloc)
 	return prev;
 }
 
+#if defined(CONFIG_PM_SLEEP) && defined(CONFIG_VT_CONSOLE)
+
 /*
  * Normally during a suspend, we allocate a new console and switch to it.
  * When we resume, we switch back to the original console.  This switch
@@ -1798,3 +1800,5 @@ void pm_set_vt_switch(int do_switch)
 	console_unlock();
 }
 EXPORT_SYMBOL(pm_set_vt_switch);
+
+#endif
