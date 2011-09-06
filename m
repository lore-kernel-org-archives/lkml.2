Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029Ab1IFS0u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 14:26:50 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:22932 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617Ab1IFS0n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 14:26:43 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-6.tower-132.messagelabs.com!1315333582!26811161!18
X-Originating-IP: [216.166.12.178]
X-StarScan-Version: 6.3.6; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Arnd Bergmann <arnd@arndb.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "art@ified.ca" <art@ified.ca>, "jslaby@suse.cz" <jslaby@suse.cz>
Date: Tue, 6 Sep 2011 13:26:12 -0500
Subject: RE: [PATCH] vt_ioctl.c: fix compile error with pm_set_vt_switch()
Thread-Topic: [PATCH] vt_ioctl.c: fix compile error with pm_set_vt_switch()
Thread-Index: Acxr27rad0dcFkL0RVqipyfg+W2fswA5OY7g
Message-ID: <ADE657CA350FB648AAC2C43247A983F001F39D748B6E@AUSP01VMBX24.collaborationhost.net>
References: <201109021402.42503.hartleys@visionengravers.com>
 <20110903114641.53170fef@lxorguk.ukuu.org.uk>
 <201109051654.28682.arnd@arndb.de>
In-Reply-To: <201109051654.28682.arnd@arndb.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, September 05, 2011 7:54 AM, Arnd Bergmann wrote:
> On Saturday 03 September 2011, Alan Cox wrote:
>> On Fri, 2 Sep 2011 14:02:42 -0700
>> H Hartley Sweeten <hartleys@visionengravers.com> wrote:
>>
>>> When CONFIG_PM_SLEEP, CONFIG_VT, and CONFIG_VT_CONSOLE are not enabled
>>> the function pm_set_vt_switch() is defined as an inline in linux/suspend.h. This causes
>>> a compile error if CONFIG_VT is enabled.
>>> 
>>> drivers/tty/vt/vt_ioctl.c:1794: error: redefinition of 'pm_set_vt_switch'
>>> include/linux/suspend.h:17: error: previous definition of 'pm_set_vt_switch' was here
>>> 
>>> Fix this with an #if defined guard around the function in vt_ioctl.c.
>>
>> Can you put the #if uglies into the buggy suspend.h header instead so the
>> code proper is kept clean of ifdefs.
>
> I had discovered the same problem earlier but did not get to submit a
> fix yet. I think the patch below should do it. Hartley, can you confirm that?

Arnd,

Your patch below does appear to fix the problem.

Tested-by: H Hartley Sweeten <hsweeten@visionengravers.com>


There is still a bit of #if ugliness with the pm_{prepare,restore}_console.

The source file kernel/power/console.c is compiled when CONFIG_PM_SLEEP is
enabled.  But that file ends up empty if CONFIG_VT and CONFIG_VT_CONSOLE are
not defined.

I wonder if it would be cleaner to make a new entry in kernel/power/Kconfig:

config PM_SLEEP_CONSOLE
	def_bool y
	depends on PM_SLEEP && VT && VT_CONSOLE

Then use that config option in the Makefile and in suspend.h.

Regards,
Hartley



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
