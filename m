Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279Ab0IUXIt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 19:08:49 -0400
Received: from kroah.org ([198.145.64.141]:35006 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751484Ab0IUXIi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 19:08:38 -0400
Date: Tue, 21 Sep 2010 16:08:30 -0700
From: Greg KH <greg@kroah.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Greg KH <gregkh@suse.de>, Jiri Slaby <jslaby@suse.cz>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        Rogier Wolff <R.E.Wolff@bitwizard.nl>,
        "Michael H. Warfield" <mhw@wittsend.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 2/2] TTY: create tty/vt and move the vt code there
Message-ID: <20100921230830.GC32346@kroah.com>
References: <1283115995-4734-1-git-send-email-arnd@arndb.de>
 <20100830184737.GA21339@suse.de>
 <201008302333.22447.arnd@arndb.de>
 <201009031729.58102.arnd@arndb.de>
 <20100921230733.GA32346@kroah.com>
 <20100921230804.GB32346@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100921230804.GB32346@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The vt and other related code is moved into the tty/vt directory.

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/Makefile                              |   18 +----------------
 tty/Makefile                                       |    2 +
 tty/vt/Makefile                                    |   21 ++++++++++++++++++++
 .../char/defkeymap.c_shipped => tty/vt/defkeymap.c |    0
 {drivers/char => tty/vt}/defkeymap.c_shipped       |    0
 {drivers/char => tty/vt}/defkeymap.map             |    0
 {drivers/char => tty/vt}/keyboard.c                |    0
 {drivers/char => tty/vt}/selection.c               |    0
 {drivers/char => tty/vt}/vc_screen.c               |    0
 {drivers/char => tty/vt}/vt.c                      |    0
 {drivers/char => tty/vt}/vt_ioctl.c                |    0
 11 files changed, 24 insertions(+), 17 deletions(-)
 create mode 100644 tty/vt/Makefile
 copy drivers/char/defkeymap.c_shipped => tty/vt/defkeymap.c (100%)
 rename {drivers/char => tty/vt}/defkeymap.c_shipped (100%)
 rename {drivers/char => tty/vt}/defkeymap.map (100%)
 rename {drivers/char => tty/vt}/keyboard.c (100%)
 rename {drivers/char => tty/vt}/selection.c (100%)
 rename {drivers/char => tty/vt}/vc_screen.c (100%)
 rename {drivers/char => tty/vt}/vt.c (100%)
 rename {drivers/char => tty/vt}/vt_ioctl.c (100%)

diff --git a/drivers/char/Makefile b/drivers/char/Makefile
index c999eac..acd1710 100644
--- a/drivers/char/Makefile
+++ b/drivers/char/Makefile
@@ -12,10 +12,8 @@ obj-y	 += mem.o random.o
 obj-$(CONFIG_LEGACY_PTYS)	+= pty.o
 obj-$(CONFIG_UNIX98_PTYS)	+= pty.o
 obj-y				+= misc.o
-obj-$(CONFIG_VT)		+= vt_ioctl.o vc_screen.o selection.o keyboard.o
 obj-$(CONFIG_BFIN_JTAG_COMM)	+= bfin_jtag_comm.o
 obj-$(CONFIG_CONSOLE_TRANSLATIONS) += consolemap.o consolemap_deftbl.o
-obj-$(CONFIG_HW_CONSOLE)	+= vt.o defkeymap.o
 obj-$(CONFIG_MAGIC_SYSRQ)	+= sysrq.o
 obj-$(CONFIG_MVME147_SCC)	+= generic_serial.o vme_scc.o
 obj-$(CONFIG_MVME162_SCC)	+= generic_serial.o vme_scc.o
@@ -114,7 +112,7 @@ obj-$(CONFIG_JS_RTC)		+= js-rtc.o
 js-rtc-y = rtc.o
 
 # Files generated that shall be removed upon make clean
-clean-files := consolemap_deftbl.c defkeymap.c
+clean-files := consolemap_deftbl.c
 
 quiet_cmd_conmk = CONMK   $@
       cmd_conmk = scripts/conmakehash $< > $@
@@ -122,18 +120,4 @@ quiet_cmd_conmk = CONMK   $@
 $(obj)/consolemap_deftbl.c: $(src)/$(FONTMAPFILE)
 	$(call cmd,conmk)
 
-$(obj)/defkeymap.o:  $(obj)/defkeymap.c
 
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
diff --git a/tty/Makefile b/tty/Makefile
index 3862838..91129af 100644
--- a/tty/Makefile
+++ b/tty/Makefile
@@ -6,3 +6,5 @@ obj-y				+= tty_buffer.o
 obj-y				+= tty_port.o
 obj-y				+= tty_mutex.o
 obj-$(CONFIG_AUDIT)		+= tty_audit.o
+obj-$(CONFIG_VT)		+= vt/
+obj-$(CONFIG_HW_CONSOLE)	+= vt/
diff --git a/tty/vt/Makefile b/tty/vt/Makefile
new file mode 100644
index 0000000..5cc32dc
--- /dev/null
+++ b/tty/vt/Makefile
@@ -0,0 +1,21 @@
+obj-$(CONFIG_VT)		+= vt_ioctl.o vc_screen.o selection.o keyboard.o
+obj-$(CONFIG_HW_CONSOLE)	+= vt.o defkeymap.o
+
+# Files generated that shall be removed upon make clean
+clean-files := defkeymap.c
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
diff --git a/drivers/char/defkeymap.c_shipped b/tty/vt/defkeymap.c
similarity index 100%
copy from drivers/char/defkeymap.c_shipped
copy to tty/vt/defkeymap.c
diff --git a/drivers/char/defkeymap.c_shipped b/tty/vt/defkeymap.c_shipped
similarity index 100%
rename from drivers/char/defkeymap.c_shipped
rename to tty/vt/defkeymap.c_shipped
diff --git a/drivers/char/defkeymap.map b/tty/vt/defkeymap.map
similarity index 100%
rename from drivers/char/defkeymap.map
rename to tty/vt/defkeymap.map
diff --git a/drivers/char/keyboard.c b/tty/vt/keyboard.c
similarity index 100%
rename from drivers/char/keyboard.c
rename to tty/vt/keyboard.c
diff --git a/drivers/char/selection.c b/tty/vt/selection.c
similarity index 100%
rename from drivers/char/selection.c
rename to tty/vt/selection.c
diff --git a/drivers/char/vc_screen.c b/tty/vt/vc_screen.c
similarity index 100%
rename from drivers/char/vc_screen.c
rename to tty/vt/vc_screen.c
diff --git a/drivers/char/vt.c b/tty/vt/vt.c
similarity index 100%
rename from drivers/char/vt.c
rename to tty/vt/vt.c
diff --git a/drivers/char/vt_ioctl.c b/tty/vt/vt_ioctl.c
similarity index 100%
rename from drivers/char/vt_ioctl.c
rename to tty/vt/vt_ioctl.c
-- 
1.7.1

