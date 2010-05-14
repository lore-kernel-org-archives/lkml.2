Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755222Ab0ENQZN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 12:25:13 -0400
Received: from atlas.linux2go.dk ([88.198.22.52]:35376 "EHLO atlas.linux2go.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751568Ab0ENQZJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 12:25:09 -0400
Message-Id: <0dd0991d71cac0a746891863264941c100bbc67a.1273825543.git.soren@linux2go.dk>
To: linux-kernel@vger.kernel.org
In-Reply-To: <cover.1273825543.git.soren@linux2go.dk>
References: <cover.1273825543.git.soren@linux2go.dk>
From: Soren Hansen <soren@linux2go.dk>
Date: Fri, 14 May 2010 18:10:12 +0200
Subject: [PATCH 1/2] Allow hvc tty's to pose as vt's
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow for hvc based tty's to take over the vt driver's major number
and namespace.

Signed-off-by: Soren Hansen <soren@linux2go.dk>
Tested-By: Major Hayden <major.hayden@rackspace.com>

---
 drivers/char/Kconfig       |    9 ++++++++-
 drivers/char/hvc_console.c |    9 +++++++++
 2 files changed, 17 insertions(+), 1 deletions(-)

diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index 6aad99e..8610179 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -5,7 +5,7 @@
 menu "Character devices"
 
 config VT
-	bool "Virtual terminal" if EMBEDDED
+	bool "Virtual terminal"
 	depends on !S390
 	select INPUT
 	default y
@@ -602,6 +602,13 @@ config PPDEV
 
 	  If unsure, say N.
 
+config HVC_TTY_HACK
+	bool "Apply various hacks to make hvc[0-] pretend to be tty[1-]"
+	depends on !VT
+	help
+	  Make unsuspecting guests work happily with the hvc concoles by
+	  tricking them into thinking they're plain old ttys.
+
 config HVC_DRIVER
 	bool
 	help
diff --git a/drivers/char/hvc_console.c b/drivers/char/hvc_console.c
index a632f25..4c6b03d 100644
--- a/drivers/char/hvc_console.c
+++ b/drivers/char/hvc_console.c
@@ -43,7 +43,11 @@
 
 #include "hvc_console.h"
 
+#ifdef CONFIG_HVC_TTY_HACK
+#define HVC_MAJOR	4
+#else /* CONFIG_HVC_TTY_HACK */
 #define HVC_MAJOR	229
+#endif /* CONFIG_HVC_TTY_HACK */
 #define HVC_MINOR	0
 
 /*
@@ -848,7 +852,12 @@ static int hvc_init(void)
 
 	drv->owner = THIS_MODULE;
 	drv->driver_name = "hvc";
+#ifdef CONFIG_HVC_TTY_HACK
+	drv->name = "tty";
+	drv->name_base = 1;
+#else /* CONFIG_HVC_TTY_HACK */
 	drv->name = "hvc";
+#endif /* CONFIG_HVC_TTY_HACK */
 	drv->major = HVC_MAJOR;
 	drv->minor_start = HVC_MINOR;
 	drv->type = TTY_DRIVER_TYPE_SYSTEM;
-- 
1.7.0.4

