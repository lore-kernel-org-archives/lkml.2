Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933778Ab0HXXPA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 19:15:00 -0400
Received: from kroah.org ([198.145.64.141]:41151 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933503Ab0HXXCm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 19:02:42 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:45:06 2010
Message-Id: <20100824224506.462715902@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:45:05 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "David S. Miller" <davem@davemloft.net>
Subject: [060/114] sparc: Really fix "console=" for serial consoles.
In-Reply-To: <20100824224610.GA5424@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------


From: David S. Miller <davem@davemloft.net>

[ Upstream commit 0a492896ac07336c98f37ad7fab4a6387b6ada78 ]

If a video head and keyboard are hooked up, specifying "console=ttyS0"
or similar to use a serial console will not work properly.

The key issue is that we must register all serial console capable
devices with register_console(), otherwise the command line specified
device won't be found.  The sun serial drivers would only register
themselves as console devices if the OpenFirmware specified console
device node matched.  To fix this part we now unconditionally get
the serial console register by setting serial_drv->cons always.

Secondarily we must not add_preferred_console() using the firmware
provided console setting if the user gaven an override on the kernel
command line using "console="  The "primary framebuffer" matching
logic was always triggering o n openfirmware device node match, make
it not when a command line override was given.

Reported-by: Frans Pop <elendil@planet.nl>
Tested-by: Frans Pop <elendil@planet.nl>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/sparc/include/asm/fb.h |    4 ++++
 drivers/serial/suncore.c    |   15 +++++++++------
 2 files changed, 13 insertions(+), 6 deletions(-)

--- a/arch/sparc/include/asm/fb.h
+++ b/arch/sparc/include/asm/fb.h
@@ -1,5 +1,6 @@
 #ifndef _SPARC_FB_H_
 #define _SPARC_FB_H_
+#include <linux/console.h>
 #include <linux/fb.h>
 #include <linux/fs.h>
 #include <asm/page.h>
@@ -18,6 +19,9 @@ static inline int fb_is_primary_device(s
 	struct device *dev = info->device;
 	struct device_node *node;
 
+	if (console_set_on_cmdline)
+		return 0;
+
 	node = dev->of_node;
 	if (node &&
 	    node == of_console_device)
--- a/drivers/serial/suncore.c
+++ b/drivers/serial/suncore.c
@@ -55,7 +55,12 @@ EXPORT_SYMBOL(sunserial_unregister_minor
 int sunserial_console_match(struct console *con, struct device_node *dp,
 			    struct uart_driver *drv, int line, bool ignore_line)
 {
-	if (!con || of_console_device != dp)
+	if (!con)
+		return 0;
+
+	drv->cons = con;
+
+	if (of_console_device != dp)
 		return 0;
 
 	if (!ignore_line) {
@@ -69,12 +74,10 @@ int sunserial_console_match(struct conso
 			return 0;
 	}
 
-	con->index = line;
-	drv->cons = con;
-
-	if (!console_set_on_cmdline)
+	if (!console_set_on_cmdline) {
+		con->index = line;
 		add_preferred_console(con->name, line, NULL);
-
+	}
 	return 1;
 }
 EXPORT_SYMBOL(sunserial_console_match);


