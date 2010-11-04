Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305Ab0KDWa0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 18:30:26 -0400
Received: from kroah.org ([198.145.64.141]:35677 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751849Ab0KDWaT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 18:30:19 -0400
Date: Thu, 4 Nov 2010 15:31:00 -0700
From: Greg KH <greg@kroah.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Greg KH <gregkh@suse.de>, Jiri Slaby <jslaby@suse.cz>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        Rogier Wolff <R.E.Wolff@bitwizard.nl>,
        "Michael H. Warfield" <mhw@wittsend.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [02/02] TTY: create drivers/tty/vt and move the vt code there
Message-ID: <20101104223100.GC3390@kroah.com>
References: <20101104222906.GA3390@kroah.com> <20101104223001.GB3390@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101104223001.GB3390@kroah.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@suse.de>

The vt and other related code is moved into the drivers/tty/vt directory.

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/Makefile                        |   33 -------------------------
 drivers/tty/Makefile                         |    2 +
 drivers/tty/vt/Makefile                      |   34 ++++++++++++++++++++++++++
 drivers/{char => tty/vt}/consolemap.c        |    0
 drivers/{char => tty/vt}/cp437.uni           |    0
 drivers/{char => tty/vt}/defkeymap.c_shipped |    0
 drivers/{char => tty/vt}/defkeymap.map       |    0
 drivers/{char => tty/vt}/keyboard.c          |    0
 drivers/{char => tty/vt}/selection.c         |    0
 drivers/{char => tty/vt}/vc_screen.c         |    0
 drivers/{char => tty/vt}/vt.c                |    0
 drivers/{char => tty/vt}/vt_ioctl.c          |    0
 12 files changed, 36 insertions(+), 33 deletions(-)
 create mode 100644 drivers/tty/vt/Makefile
 rename drivers/{char => tty/vt}/consolemap.c (100%)
 rename drivers/{char => tty/vt}/cp437.uni (100%)
 rename drivers/{char => tty/vt}/defkeymap.c_shipped (100%)
 rename drivers/{char => tty/vt}/defkeymap.map (100%)
 rename drivers/{char => tty/vt}/keyboard.c (100%)
 rename drivers/{char => tty/vt}/selection.c (100%)
 rename drivers/{char => tty/vt}/vc_screen.c (100%)
 rename drivers/{char => tty/vt}/vt.c (100%)
 rename drivers/{char => tty/vt}/vt_ioctl.c (100%)

diff --git a/drivers/char/Makefile b/drivers/char/Makefile
index f308494..ba53ec9 100644
--- a/drivers/char/Makefile
+++ b/drivers/char/Makefile
@@ -2,18 +2,10 @@
 # Makefile for the kernel character device drivers.
 #
 
-#
-# This file contains the font map for the default (hardware) font
-#
-FONTMAPFILE = cp437.uni
-
 obj-y				+= mem.o random.o
 obj-$(CONFIG_TTY_PRINTK)	+= ttyprintk.o
 obj-y				+= misc.o
-obj-$(CONFIG_VT)		+= vt_ioctl.o vc_screen.o selection.o keyboard.o
 obj-$(CONFIG_BFIN_JTAG_COMM)	+= bfin_jtag_comm.o
-obj-$(CONFIG_CONSOLE_TRANSLATIONS) += consolemap.o consolemap_deftbl.o
-obj-$(CONFIG_HW_CONSOLE)	+= vt.o defkeymap.o
 obj-$(CONFIG_MVME147_SCC)	+= generic_serial.o vme_scc.o
 obj-$(CONFIG_MVME162_SCC)	+= generic_serial.o vme_scc.o
 obj-$(CONFIG_BVME6000_SCC)	+= generic_serial.o vme_scc.o
@@ -106,28 +98,3 @@ obj-$(CONFIG_RAMOOPS)		+= ramoops.o
 
 obj-$(CONFIG_JS_RTC)		+= js-rtc.o
 js-rtc-y = rtc.o
-
-# Files generated that shall be removed upon make clean
-clean-files := consolemap_deftbl.c defkeymap.c
-
-quiet_cmd_conmk = CONMK   $@
-      cmd_conmk = scripts/conmakehash $< > $@
-
-$(obj)/consolemap_deftbl.c: $(src)/$(FONTMAPFILE)
-	$(call cmd,conmk)
-
-$(obj)/defkeymap.o:  $(obj)/defkeymap.c
-
-# Uncomment if you're changing the keymap and have an appropriate
-# loadkeys version for the map. By default, we'll use the shipped
-# versions.
-# GENERATE_KEYMAP := 1
-
-ifdef GENERATE_KEYMAP
-
-$(obj)/defkeymap.c: $(obj)/%.c: $(src)/%.map
-	loadkeys --mktable $< > $@.tmp
-	sed -e 's/^static *//' $@.tmp > $@
-	rm $@.tmp
-
-endif
diff --git a/drivers/tty/Makefile b/drivers/tty/Makefile
index 7f63b33..c43ef48 100644
--- a/drivers/tty/Makefile
+++ b/drivers/tty/Makefile
@@ -7,3 +7,5 @@ obj-$(CONFIG_MAGIC_SYSRQ)	+= sysrq.o
 obj-$(CONFIG_N_HDLC)		+= n_hdlc.o
 obj-$(CONFIG_N_GSM)		+= n_gsm.o
 obj-$(CONFIG_R3964)		+= n_r3964.o
+
+obj-y				+= vt/
diff --git a/drivers/tty/vt/Makefile b/drivers/tty/vt/Makefile
new file mode 100644
index 0000000..14a51c9
--- /dev/null
+++ b/drivers/tty/vt/Makefile
@@ -0,0 +1,34 @@
+#
+# This file contains the font map for the default (hardware) font
+#
+FONTMAPFILE = cp437.uni
+
+obj-$(CONFIG_VT)			+= vt_ioctl.o vc_screen.o \
+					   selection.o keyboard.o
+obj-$(CONFIG_CONSOLE_TRANSLATIONS)	+= consolemap.o consolemap_deftbl.o
+obj-$(CONFIG_HW_CONSOLE)		+= vt.o defkeymap.o
+
+# Files generated that shall be removed upon make clean
+clean-files := consolemap_deftbl.c defkeymap.c
+
+quiet_cmd_conmk = CONMK   $@
+      cmd_conmk = scripts/conmakehash $< > $@
+
+$(obj)/consolemap_deftbl.c: $(src)/$(FONTMAPFILE)
+	$(call cmd,conmk)
+
+$(obj)/defkeymap.o:  $(obj)/defkeymap.c
+
+# Uncomment if you're changing the keymap and have an appropriate
+# loadkeys version for the map. By default, we'll use the shipped
+# versions.
+# GENERATE_KEYMAP := 1
+
+ifdef GENERATE_KEYMAP
+
+$(obj)/defkeymap.c: $(obj)/%.c: $(src)/%.map
+	loadkeys --mktable $< > $@.tmp
+	sed -e 's/^static *//' $@.tmp > $@
+	rm $@.tmp
+
+endif
diff --git a/drivers/char/consolemap.c b/drivers/tty/vt/consolemap.c
similarity index 100%
rename from drivers/char/consolemap.c
rename to drivers/tty/vt/consolemap.c
diff --git a/drivers/char/cp437.uni b/drivers/tty/vt/cp437.uni
similarity index 100%
rename from drivers/char/cp437.uni
rename to drivers/tty/vt/cp437.uni
diff --git a/drivers/char/defkeymap.c_shipped b/drivers/tty/vt/defkeymap.c_shipped
similarity index 100%
rename from drivers/char/defkeymap.c_shipped
rename to drivers/tty/vt/defkeymap.c_shipped
diff --git a/drivers/char/defkeymap.map b/drivers/tty/vt/defkeymap.map
similarity index 100%
rename from drivers/char/defkeymap.map
rename to drivers/tty/vt/defkeymap.map
diff --git a/drivers/char/keyboard.c b/drivers/tty/vt/keyboard.c
similarity index 100%
rename from drivers/char/keyboard.c
rename to drivers/tty/vt/keyboard.c
diff --git a/drivers/char/selection.c b/drivers/tty/vt/selection.c
similarity index 100%
rename from drivers/char/selection.c
rename to drivers/tty/vt/selection.c
diff --git a/drivers/char/vc_screen.c b/drivers/tty/vt/vc_screen.c
similarity index 100%
rename from drivers/char/vc_screen.c
rename to drivers/tty/vt/vc_screen.c
diff --git a/drivers/char/vt.c b/drivers/tty/vt/vt.c
similarity index 100%
rename from drivers/char/vt.c
rename to drivers/tty/vt/vt.c
diff --git a/drivers/char/vt_ioctl.c b/drivers/tty/vt/vt_ioctl.c
similarity index 100%
rename from drivers/char/vt_ioctl.c
rename to drivers/tty/vt/vt_ioctl.c
-- 
1.7.3.1

