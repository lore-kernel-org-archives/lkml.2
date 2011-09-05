Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754420Ab1IEOzK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 10:55:10 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:60197 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803Ab1IEOzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 10:55:06 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] vt_ioctl.c: fix compile error with pm_set_vt_switch()
Date: Mon, 5 Sep 2011 16:54:28 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: H Hartley Sweeten <hartleys@visionengravers.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, gregkh@suse.de,
        akpm@linux-foundation.org, art@ified.ca, jslaby@suse.cz
References: <201109021402.42503.hartleys@visionengravers.com> <20110903114641.53170fef@lxorguk.ukuu.org.uk>
In-Reply-To: <20110903114641.53170fef@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109051654.28682.arnd@arndb.de>
X-Provags-ID: V02:K0:Db6Tide1/6IXv2fqT0QlMkJbhEdHG+G1c9IWrqlsex8
 3/2DhfW+YrrCf4TVjD0KtX3VZvaPZK2CE73K9ixNKqGcutpb/N
 7gHLcD1kP6bw5BCXG5SmQJ1nYDkTN1jfsM+0y9oL+/s6eq2fP+
 +2gkH5iLY1uo0dme+5nPP8VN8qcWPZVLo583KvdSHm3cqixHvH
 lb2YMedkP6frz3nsIDk1TPqlE1PvkMvASAbLy824bkmRml+5X6
 6rrCJdzgvOoXDcE1HgHzjCc9xlj9mC9Iw/2/WYH8+ltg2ePQS5
 W/eCy12hAn+337+RvJ/o+OO3C+U5fGfw62s2wGnWAaS1KEP9Bs
 CgIDF6/bpiV0fFpQ9r5U=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 03 September 2011, Alan Cox wrote:
> On Fri, 2 Sep 2011 14:02:42 -0700
> H Hartley Sweeten <hartleys@visionengravers.com> wrote:
> 
> > When CONFIG_PM_SLEEP, CONFIG_VT, and CONFIG_VT_CONSOLE are not enabled
> > the function pm_set_vt_switch() is defined as an inline in linux/suspend.h. This causes
> > a compile error if CONFIG_VT is enabled.
> > 
> > drivers/tty/vt/vt_ioctl.c:1794: error: redefinition of 'pm_set_vt_switch'
> > include/linux/suspend.h:17: error: previous definition of 'pm_set_vt_switch' was here
> > 
> > Fix this with an #if defined guard around the function in vt_ioctl.c.
> 
> Can you put the #if uglies into the buggy suspend.h header instead so the
> code proper is kept clean of ifdefs.

I had discovered the same problem earlier but did not get to submit a
fix yet. I think the patch below should do it. Hartley, can you confirm that?

	Arnd
---
vt/suspend: pm_set_vt_switch does not depend on CONFIG_PM_SLEEP

This avoid having multiple conflicting definitions of pm_set_vt_switch
when CONFIG_VT is set but CONFIG_PM_SLEEP or CONFIG_VT_CONSOLE are not.

drivers/tty/vt/vt_ioctl.c:1794: error: redefinition of 'pm_set_vt_switch'
include/linux/suspend.h:17: error: previous definition of 'pm_set_vt_switch' was here

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
diff --git a/include/linux/suspend.h b/include/linux/suspend.h
index 6bbcef2..69f3b39 100644
--- a/include/linux/suspend.h
+++ b/include/linux/suspend.h
@@ -8,15 +8,18 @@
 #include <linux/mm.h>
 #include <asm/errno.h>
 
-#if defined(CONFIG_PM_SLEEP) && defined(CONFIG_VT) && defined(CONFIG_VT_CONSOLE)
+#if defined(CONFIG_VT)
 extern void pm_set_vt_switch(int);
-extern int pm_prepare_console(void);
-extern void pm_restore_console(void);
 #else
 static inline void pm_set_vt_switch(int do_switch)
 {
 }
+#endif
 
+#if defined(CONFIG_PM_SLEEP) && defined(CONFIG_VT) && defined(CONFIG_VT_CONSOLE)
+extern int pm_prepare_console(void);
+extern void pm_restore_console(void);
+#else
 static inline int pm_prepare_console(void)
 {
 	return 0;
