Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096Ab0H2VGu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 17:06:50 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:55280 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754063Ab0H2VGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 17:06:48 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 2/5] tty/vt: move files to drivers/tty/vt/
Date: Sun, 29 Aug 2010 23:06:32 +0200
Message-Id: <1283115995-4734-3-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1283115995-4734-1-git-send-email-arnd@arndb.de>
References: <1283115995-4734-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:op6OiRisO3jlluwCb8OOX+LGTVkYcmLmuMMD/Iz2Hhq
 GvxorZb/X5G/1/o8jKN/F6JEoJt3XOO0HU0rO3I9wx8iXxWVVe
 TI8GCCid3drzfFVKNLXlPWEcVHVcpNGRjl1KzVsckUmEANT/iS
 jcWPZcEJ826aTkYXC2Ax4Z8BtJleZXbsOUWG2QzQ3vL+jZYrYh
 CuTohXn9QfP+wY5Lzu8KQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The virtual terminal is a very special tty driver, so
it deserves its own directory.

Signed-off-by: Armd Bergmann <arnd@arndb.de>
---
 drivers/char/Kconfig                         |   84 +-------------------------
 drivers/char/Makefile                        |   33 ----------
 drivers/tty/Makefile                         |    1 +
 drivers/tty/vt/Kconfig                       |   84 ++++++++++++++++++++++++++
 drivers/tty/vt/Makefile                      |   37 +++++++++++
 drivers/{char => tty/vt}/consolemap.c        |    0
 drivers/{char => tty/vt}/cp437.uni           |    0
 drivers/{char => tty/vt}/defkeymap.c_shipped |    0
 drivers/{char => tty/vt}/defkeymap.map       |    0
 drivers/{char => tty/vt}/keyboard.c          |    0
 drivers/{char => tty/vt}/selection.c         |    0
 drivers/{char => tty/vt}/vc_screen.c         |    0
 drivers/{char => tty/vt}/vt.c                |    0
 drivers/{char => tty/vt}/vt_ioctl.c          |    0
 14 files changed, 123 insertions(+), 116 deletions(-)
 create mode 100644 drivers/tty/vt/Kconfig
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

diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index 7beee39..52fa94d 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -4,89 +4,7 @@
 
 menu "Character devices"
 
-config VT
-	bool "Virtual terminal" if EMBEDDED
-	depends on !S390
-	select INPUT
-	default y
-	---help---
-	  If you say Y here, you will get support for terminal devices with
-	  display and keyboard devices. These are called "virtual" because you
-	  can run several virtual terminals (also called virtual consoles) on
-	  one physical terminal. This is rather useful, for example one
-	  virtual terminal can collect system messages and warnings, another
-	  one can be used for a text-mode user session, and a third could run
-	  an X session, all in parallel. Switching between virtual terminals
-	  is done with certain key combinations, usually Alt-<function key>.
-
-	  The setterm command ("man setterm") can be used to change the
-	  properties (such as colors or beeping) of a virtual terminal. The
-	  man page console_codes(4) ("man console_codes") contains the special
-	  character sequences that can be used to change those properties
-	  directly. The fonts used on virtual terminals can be changed with
-	  the setfont ("man setfont") command and the key bindings are defined
-	  with the loadkeys ("man loadkeys") command.
-
-	  You need at least one virtual terminal device in order to make use
-	  of your keyboard and monitor. Therefore, only people configuring an
-	  embedded system would want to say N here in order to save some
-	  memory; the only way to log into such a system is then via a serial
-	  or network connection.
-
-	  If unsure, say Y, or else you won't be able to do much with your new
-	  shiny Linux system :-)
-
-config CONSOLE_TRANSLATIONS
-	depends on VT
-	default y
-	bool "Enable character translations in console" if EMBEDDED
-	---help---
-	  This enables support for font mapping and Unicode translation
-	  on virtual consoles.
-
-config VT_CONSOLE
-	bool "Support for console on virtual terminal" if EMBEDDED
-	depends on VT
-	default y
-	---help---
-	  The system console is the device which receives all kernel messages
-	  and warnings and which allows logins in single user mode. If you
-	  answer Y here, a virtual terminal (the device used to interact with
-	  a physical terminal) can be used as system console. This is the most
-	  common mode of operations, so you should say Y here unless you want
-	  the kernel messages be output only to a serial port (in which case
-	  you should say Y to "Console on serial port", below).
-
-	  If you do say Y here, by default the currently visible virtual
-	  terminal (/dev/tty0) will be used as system console. You can change
-	  that with a kernel command line option such as "console=tty3" which
-	  would use the third virtual terminal as system console. (Try "man
-	  bootparam" or see the documentation of your boot loader (lilo or
-	  loadlin) about how to pass options to the kernel at boot time.)
-
-	  If unsure, say Y.
-
-config HW_CONSOLE
-	bool
-	depends on VT && !S390 && !UML
-	default y
-
-config VT_HW_CONSOLE_BINDING
-       bool "Support for binding and unbinding console drivers"
-       depends on HW_CONSOLE
-       default n
-       ---help---
-         The virtual terminal is the device that interacts with the physical
-         terminal through console drivers. On these systems, at least one
-         console driver is loaded. In other configurations, additional console
-         drivers may be enabled, such as the framebuffer console. If more than
-         1 console driver is enabled, setting this to 'y' will allow you to
-         select the console driver that will serve as the backend for the
-         virtual terminals.
-
-	 See <file:Documentation/console/console.txt> for more
-	 information. For framebuffer console users, please refer to
-	 <file:Documentation/fb/fbcon.txt>.
+source "drivers/tty/vt/Kconfig"
 
 config DEVKMEM
 	bool "/dev/kmem virtual device support"
diff --git a/drivers/char/Makefile b/drivers/char/Makefile
index b7e6058..f507df7 100644
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
 obj-y	 += mem.o random.o
 
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
index 562a96f..5845211 100644
--- a/drivers/tty/Makefile
+++ b/drivers/tty/Makefile
@@ -12,6 +12,7 @@ obj-y				+= tty_mutex.o
 obj-$(CONFIG_LEGACY_PTYS)	+= pty.o
 obj-$(CONFIG_UNIX98_PTYS)	+= pty.o
 
+obj-$(CONFIG_VT)		+= vt/
 obj-$(CONFIG_AUDIT)		+= tty_audit.o
 
 obj-$(CONFIG_MAGIC_SYSRQ)	+= sysrq.o
diff --git a/drivers/tty/vt/Kconfig b/drivers/tty/vt/Kconfig
new file mode 100644
index 0000000..7373eeb
--- /dev/null
+++ b/drivers/tty/vt/Kconfig
@@ -0,0 +1,84 @@
+config VT
+	bool "Virtual terminal" if EMBEDDED
+	depends on !S390
+	select INPUT
+	default y
+	---help---
+	  If you say Y here, you will get support for terminal devices with
+	  display and keyboard devices. These are called "virtual" because you
+	  can run several virtual terminals (also called virtual consoles) on
+	  one physical terminal. This is rather useful, for example one
+	  virtual terminal can collect system messages and warnings, another
+	  one can be used for a text-mode user session, and a third could run
+	  an X session, all in parallel. Switching between virtual terminals
+	  is done with certain key combinations, usually Alt-<function key>.
+
+	  The setterm command ("man setterm") can be used to change the
+	  properties (such as colors or beeping) of a virtual terminal. The
+	  man page console_codes(4) ("man console_codes") contains the special
+	  character sequences that can be used to change those properties
+	  directly. The fonts used on virtual terminals can be changed with
+	  the setfont ("man setfont") command and the key bindings are defined
+	  with the loadkeys ("man loadkeys") command.
+
+	  You need at least one virtual terminal device in order to make use
+	  of your keyboard and monitor. Therefore, only people configuring an
+	  embedded system would want to say N here in order to save some
+	  memory; the only way to log into such a system is then via a serial
+	  or network connection.
+
+	  If unsure, say Y, or else you won't be able to do much with your new
+	  shiny Linux system :-)
+
+config CONSOLE_TRANSLATIONS
+	depends on VT
+	default y
+	bool "Enable character translations in console" if EMBEDDED
+	---help---
+	  This enables support for font mapping and Unicode translation
+	  on virtual consoles.
+
+config VT_CONSOLE
+	bool "Support for console on virtual terminal" if EMBEDDED
+	depends on VT
+	default y
+	---help---
+	  The system console is the device which receives all kernel messages
+	  and warnings and which allows logins in single user mode. If you
+	  answer Y here, a virtual terminal (the device used to interact with
+	  a physical terminal) can be used as system console. This is the most
+	  common mode of operations, so you should say Y here unless you want
+	  the kernel messages be output only to a serial port (in which case
+	  you should say Y to "Console on serial port", below).
+
+	  If you do say Y here, by default the currently visible virtual
+	  terminal (/dev/tty0) will be used as system console. You can change
+	  that with a kernel command line option such as "console=tty3" which
+	  would use the third virtual terminal as system console. (Try "man
+	  bootparam" or see the documentation of your boot loader (lilo or
+	  loadlin) about how to pass options to the kernel at boot time.)
+
+	  If unsure, say Y.
+
+config HW_CONSOLE
+	bool
+	depends on VT && !S390 && !UML
+	default y
+
+config VT_HW_CONSOLE_BINDING
+       bool "Support for binding and unbinding console drivers"
+       depends on HW_CONSOLE
+       default n
+       ---help---
+         The virtual terminal is the device that interacts with the physical
+         terminal through console drivers. On these systems, at least one
+         console driver is loaded. In other configurations, additional console
+         drivers may be enabled, such as the framebuffer console. If more than
+         1 console driver is enabled, setting this to 'y' will allow you to
+         select the console driver that will serve as the backend for the
+         virtual terminals.
+
+	 See <file:Documentation/console/console.txt> for more
+	 information. For framebuffer console users, please refer to
+	 <file:Documentation/fb/fbcon.txt>.
+
diff --git a/drivers/tty/vt/Makefile b/drivers/tty/vt/Makefile
new file mode 100644
index 0000000..4d6714f
--- /dev/null
+++ b/drivers/tty/vt/Makefile
@@ -0,0 +1,37 @@
+#
+# Makefile for virtual terminal device driver
+#
+
+#
+# This file contains the font map for the default (hardware) font
+#
+FONTMAPFILE = cp437.uni
+
+obj-$(CONFIG_VT)		+= vt_ioctl.o vc_screen.o selection.o keyboard.o
+obj-$(CONFIG_CONSOLE_TRANSLATIONS) += consolemap.o consolemap_deftbl.o
+obj-$(CONFIG_HW_CONSOLE)	+= vt.o defkeymap.o
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
1.7.1

