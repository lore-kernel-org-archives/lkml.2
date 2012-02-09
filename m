Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758518Ab2BIXsY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 18:48:24 -0500
Received: from mail.windriver.com ([147.11.1.11]:37267 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757903Ab2BIXsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 18:48:23 -0500
Date: Thu, 9 Feb 2012 18:48:19 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: David Miller <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>
Subject: Re: 8250 move broke the build on sparc
Message-ID: <20120209234818.GA814@windriver.com>
References: <20120209.163009.1594369939327153054.davem@davemloft.net>
 <4F344A85.4070005@windriver.com>
 <20120209.174817.1772850235758472350.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120209.174817.1772850235758472350.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Re: 8250 move broke the build on sparc] On 09/02/2012 (Thu 17:48) David Miller wrote:

> From: Paul Gortmaker <paul.gortmaker@windriver.com>
> Date: Thu, 9 Feb 2012 17:36:53 -0500
> 
> > It only uses suncore.h for sunserial_register_minors (and unreg).
> > Would you like it better if I killed all ifdefs and the include
> > and used an incantation of weak instead?  Might be cleaner....
> 
> It's the "../" that's ugly, not the include and usage itself.
> 
> If it's now going to be included from multiple dirs, we should
> probably move it to include/linux/sunserialcore.h or similar.

Thanks for the suggestion, I wasn't thinking in that direction.

I'm pretty sure the ifdef SPARC around the include in 8250.c 
could be tossed, but with my luck lately, I figured it would be
best to just leave it exactly as it was.

Paul.
--

>From 1b0bc62a6583e319f8b764ac34f799b916656590 Mon Sep 17 00:00:00 2001
From: Paul Gortmaker <paul.gortmaker@windriver.com>
Date: Thu, 9 Feb 2012 18:09:35 -0500
Subject: [PATCH] sparc: rename drivers/tty/serial/suncore.h ->
 include/linux/sunserialcore.h

There are multiple users of this file from different source
paths now, and rather than have ../ paths in include statements,
just move the file to the linux header dir.

Suggested-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---

[To bring the ../ patch in scope, this commit is based on the tag
 'tty-3.3-rc3' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty
 Build tested on sparc32/64 defconfigs, but with 8250 and 8250_CONSOLE=y ]

 MAINTAINERS                                        |    2 +-
 drivers/tty/serial/8250/8250.c                     |    7 +++----
 drivers/tty/serial/suncore.c                       |    2 +-
 drivers/tty/serial/sunhv.c                         |    3 +--
 drivers/tty/serial/sunsab.c                        |    2 +-
 drivers/tty/serial/sunsu.c                         |    3 +--
 drivers/tty/serial/sunzilog.c                      |    2 +-
 .../suncore.h => include/linux/sunserialcore.h     |    2 +-
 8 files changed, 10 insertions(+), 13 deletions(-)
 rename drivers/tty/serial/suncore.h => include/linux/sunserialcore.h (98%)

diff --git a/MAINTAINERS b/MAINTAINERS
index a1fce9a..97f1c1b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6187,8 +6187,8 @@ L:	sparclinux@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc-2.6.git
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc-next-2.6.git
 S:	Maintained
+F:	include/linux/sunserialcore.h
 F:	drivers/tty/serial/suncore.c
-F:	drivers/tty/serial/suncore.h
 F:	drivers/tty/serial/sunhv.c
 F:	drivers/tty/serial/sunsab.c
 F:	drivers/tty/serial/sunsab.h
diff --git a/drivers/tty/serial/8250/8250.c b/drivers/tty/serial/8250/8250.c
index 9b7336f..f0219b0 100644
--- a/drivers/tty/serial/8250/8250.c
+++ b/drivers/tty/serial/8250/8250.c
@@ -38,16 +38,15 @@
 #include <linux/nmi.h>
 #include <linux/mutex.h>
 #include <linux/slab.h>
+#ifdef CONFIG_SPARC
+#include <linux/sunserialcore.h>
+#endif
 
 #include <asm/io.h>
 #include <asm/irq.h>
 
 #include "8250.h"
 
-#ifdef CONFIG_SPARC
-#include "../suncore.h"
-#endif
-
 /*
  * Configuration:
  *   share_irqs - whether we pass IRQF_SHARED to request_irq().  This option
diff --git a/drivers/tty/serial/suncore.c b/drivers/tty/serial/suncore.c
index 6381a02..6e4ac8d 100644
--- a/drivers/tty/serial/suncore.c
+++ b/drivers/tty/serial/suncore.c
@@ -17,11 +17,11 @@
 #include <linux/errno.h>
 #include <linux/string.h>
 #include <linux/serial_core.h>
+#include <linux/sunserialcore.h>
 #include <linux/init.h>
 
 #include <asm/prom.h>
 
-#include "suncore.h"
 
 static int sunserial_current_minor = 64;
 
diff --git a/drivers/tty/serial/sunhv.c b/drivers/tty/serial/sunhv.c
index c0b7246..3ba5d28 100644
--- a/drivers/tty/serial/sunhv.c
+++ b/drivers/tty/serial/sunhv.c
@@ -29,8 +29,7 @@
 #endif
 
 #include <linux/serial_core.h>
-
-#include "suncore.h"
+#include <linux/sunserialcore.h>
 
 #define CON_BREAK	((long)-1)
 #define CON_HUP		((long)-2)
diff --git a/drivers/tty/serial/sunsab.c b/drivers/tty/serial/sunsab.c
index b5fa2a5..62dacd0 100644
--- a/drivers/tty/serial/sunsab.c
+++ b/drivers/tty/serial/sunsab.c
@@ -43,8 +43,8 @@
 #endif
 
 #include <linux/serial_core.h>
+#include <linux/sunserialcore.h>
 
-#include "suncore.h"
 #include "sunsab.h"
 
 struct uart_sunsab_port {
diff --git a/drivers/tty/serial/sunsu.c b/drivers/tty/serial/sunsu.c
index ad0f8f5..d3ca6da 100644
--- a/drivers/tty/serial/sunsu.c
+++ b/drivers/tty/serial/sunsu.c
@@ -47,8 +47,7 @@
 #endif
 
 #include <linux/serial_core.h>
-
-#include "suncore.h"
+#include <linux/sunserialcore.h>
 
 /* We are on a NS PC87303 clocked with 24.0 MHz, which results
  * in a UART clock of 1.8462 MHz.
diff --git a/drivers/tty/serial/sunzilog.c b/drivers/tty/serial/sunzilog.c
index 8e916e7..f845339 100644
--- a/drivers/tty/serial/sunzilog.c
+++ b/drivers/tty/serial/sunzilog.c
@@ -43,8 +43,8 @@
 #endif
 
 #include <linux/serial_core.h>
+#include <linux/sunserialcore.h>
 
-#include "suncore.h"
 #include "sunzilog.h"
 
 /* On 32-bit sparcs we need to delay after register accesses
diff --git a/drivers/tty/serial/suncore.h b/include/linux/sunserialcore.h
similarity index 98%
rename from drivers/tty/serial/suncore.h
rename to include/linux/sunserialcore.h
index db20579..68e7430 100644
--- a/drivers/tty/serial/suncore.h
+++ b/include/linux/sunserialcore.h
@@ -1,4 +1,4 @@
-/* suncore.h
+/* sunserialcore.h
  *
  * Generic SUN serial/kbd/ms layer.  Based entirely
  * upon drivers/sbus/char/sunserial.h which is:
-- 
1.7.9

