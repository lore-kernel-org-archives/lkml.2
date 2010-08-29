Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182Ab0H2VHa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 17:07:30 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:60405 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754072Ab0H2VGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 17:06:48 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 1/5] tty: move tty layer code to drivers/tty
Date: Sun, 29 Aug 2010 23:06:31 +0200
Message-Id: <1283115995-4734-2-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1283115995-4734-1-git-send-email-arnd@arndb.de>
References: <1283115995-4734-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:7uEDkpw0AaFWGEsJ5QeVecVQuWfmJXYuXAzlDK2zeSz
 BS3+pVX9fspCPg7Od/eHy1jAyCtHCXFqFnzqkNdcchEBOWf2IC
 8+p1PjUEIt9nxogXz/9Ijl41bbigQbP5Bf379lOwOQwX+Ef/VG
 hDuVGsC5+90LA0XOhBi/7vZ8HpoJR9ZpZo5p1tczP6Dp1iagxO
 znV1dpC3NvGm5oB2pK63w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This separates the core tty code from tty and other
character device drivers, in order to get a cleaner
structure.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 MAINTAINERS                        |    2 +-
 drivers/Makefile                   |    1 +
 drivers/char/Kconfig               |   97 +-----------------------------------
 drivers/char/Makefile              |   10 +---
 drivers/tty/Kconfig                |   96 +++++++++++++++++++++++++++++++++++
 drivers/tty/Makefile               |   22 ++++++++
 drivers/{char => tty}/n_gsm.c      |    0
 drivers/{char => tty}/n_hdlc.c     |    0
 drivers/{char => tty}/n_r3964.c    |    0
 drivers/{char => tty}/n_tty.c      |    0
 drivers/{char => tty}/pty.c        |    0
 drivers/{char => tty}/sysrq.c      |    0
 drivers/{char => tty}/tty_audit.c  |    0
 drivers/{char => tty}/tty_buffer.c |    0
 drivers/{char => tty}/tty_io.c     |    0
 drivers/{char => tty}/tty_ioctl.c  |    0
 drivers/{char => tty}/tty_ldisc.c  |    0
 drivers/{char => tty}/tty_mutex.c  |    0
 drivers/{char => tty}/tty_port.c   |    0
 19 files changed, 122 insertions(+), 106 deletions(-)
 create mode 100644 drivers/tty/Kconfig
 create mode 100644 drivers/tty/Makefile
 rename drivers/{char => tty}/n_gsm.c (100%)
 rename drivers/{char => tty}/n_hdlc.c (100%)
 rename drivers/{char => tty}/n_r3964.c (100%)
 rename drivers/{char => tty}/n_tty.c (100%)
 rename drivers/{char => tty}/pty.c (100%)
 rename drivers/{char => tty}/sysrq.c (100%)
 rename drivers/{char => tty}/tty_audit.c (100%)
 rename drivers/{char => tty}/tty_buffer.c (100%)
 rename drivers/{char => tty}/tty_io.c (100%)
 rename drivers/{char => tty}/tty_ioctl.c (100%)
 rename drivers/{char => tty}/tty_ldisc.c (100%)
 rename drivers/{char => tty}/tty_mutex.c (100%)
 rename drivers/{char => tty}/tty_port.c (100%)

diff --git a/MAINTAINERS b/MAINTAINERS
index 39d8c5c..794f630 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5734,7 +5734,7 @@ TTY LAYER
 M:	Greg Kroah-Hartman <gregkh@suse.de>
 S:	Maintained
 T:	quilt kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/
-F:	drivers/char/tty_*
+F:	drivers/tty/tty_*
 F:	drivers/serial/serial_core.c
 F:	include/linux/serial_core.h
 F:	include/linux/serial.h
diff --git a/drivers/Makefile b/drivers/Makefile
index ae47344..4e186dd 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -26,6 +26,7 @@ obj-$(CONFIG_REGULATOR)		+= regulator/
 
 # char/ comes before serial/ etc so that the VT console is the boot-time
 # default.
+obj-y				+= tty/
 obj-y				+= char/
 
 # gpu/ comes after char for AGP vs DRM startup
diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index 3d44ec7..7beee39 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -269,26 +269,6 @@ config SYNCLINK_GT
 	  synchronous and asynchronous serial adapters
 	  manufactured by Microgate Systems, Ltd. (www.microgate.com)
 
-config N_HDLC
-	tristate "HDLC line discipline support"
-	depends on SERIAL_NONSTANDARD
-	help
-	  Allows synchronous HDLC communications with tty device drivers that
-	  support synchronous HDLC such as the Microgate SyncLink adapter.
-
-	  This driver can be built as a module ( = code which can be
-	  inserted in and removed from the running kernel whenever you want).
-	  The module will be called n_hdlc. If you want to do that, say M
-	  here.
-
-config N_GSM
-	tristate "GSM MUX line discipline support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
-	depends on NET
-	help
-	  This line discipline provides support for the GSM MUX protocol and
-	  presents the mux as a set of 61 individual tty devices.
-
 config RISCOM8
 	tristate "SDL RISCom/8 card support"
 	depends on SERIAL_NONSTANDARD
@@ -428,70 +408,7 @@ config SGI_MBCS
 
 source "drivers/serial/Kconfig"
 
-config UNIX98_PTYS
-	bool "Unix98 PTY support" if EMBEDDED
-	default y
-	---help---
-	  A pseudo terminal (PTY) is a software device consisting of two
-	  halves: a master and a slave. The slave device behaves identical to
-	  a physical terminal; the master device is used by a process to
-	  read data from and write data to the slave, thereby emulating a
-	  terminal. Typical programs for the master side are telnet servers
-	  and xterms.
-
-	  Linux has traditionally used the BSD-like names /dev/ptyxx for
-	  masters and /dev/ttyxx for slaves of pseudo terminals. This scheme
-	  has a number of problems. The GNU C library glibc 2.1 and later,
-	  however, supports the Unix98 naming standard: in order to acquire a
-	  pseudo terminal, a process opens /dev/ptmx; the number of the pseudo
-	  terminal is then made available to the process and the pseudo
-	  terminal slave can be accessed as /dev/pts/<number>. What was
-	  traditionally /dev/ttyp2 will then be /dev/pts/2, for example.
-
-	  All modern Linux systems use the Unix98 ptys.  Say Y unless
-	  you're on an embedded system and want to conserve memory.
-
-config DEVPTS_MULTIPLE_INSTANCES
-	bool "Support multiple instances of devpts"
-	depends on UNIX98_PTYS
-	default n
-	---help---
-	  Enable support for multiple instances of devpts filesystem.
-	  If you want to have isolated PTY namespaces (eg: in containers),
-	  say Y here.  Otherwise, say N. If enabled, each mount of devpts
-	  filesystem with the '-o newinstance' option will create an
-	  independent PTY namespace.
-
-config LEGACY_PTYS
-	bool "Legacy (BSD) PTY support"
-	default y
-	---help---
-	  A pseudo terminal (PTY) is a software device consisting of two
-	  halves: a master and a slave. The slave device behaves identical to
-	  a physical terminal; the master device is used by a process to
-	  read data from and write data to the slave, thereby emulating a
-	  terminal. Typical programs for the master side are telnet servers
-	  and xterms.
-
-	  Linux has traditionally used the BSD-like names /dev/ptyxx
-	  for masters and /dev/ttyxx for slaves of pseudo
-	  terminals. This scheme has a number of problems, including
-	  security.  This option enables these legacy devices; on most
-	  systems, it is safe to say N.
-
-
-config LEGACY_PTY_COUNT
-	int "Maximum number of legacy PTY in use"
-	depends on LEGACY_PTYS
-	range 0 256
-	default "256"
-	---help---
-	  The maximum number of legacy PTYs that can be used at any one time.
-	  The default is 256, and should be more than enough.  Embedded
-	  systems may want to reduce this to save memory.
-
-	  When not in use, each legacy PTY occupies 12 bytes on 32-bit
-	  architectures and 24 bytes on 64-bit architectures.
+source "drivers/tty/Kconfig"
 
 config BRIQ_PANEL
 	tristate 'Total Impact briQ front panel driver'
@@ -917,18 +834,6 @@ config XILINX_HWICAP
 
 	  If unsure, say N.
 
-config R3964
-	tristate "Siemens R3964 line discipline"
-	---help---
-	  This driver allows synchronous communication with devices using the
-	  Siemens R3964 packet protocol. Unless you are dealing with special
-	  hardware like PLCs, you are unlikely to need this.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called n_r3964.
-
-	  If unsure, say N.
-
 config APPLICOM
 	tristate "Applicom intelligent fieldbus card support"
 	depends on PCI
diff --git a/drivers/char/Makefile b/drivers/char/Makefile
index dc96416..b7e6058 100644
--- a/drivers/char/Makefile
+++ b/drivers/char/Makefile
@@ -7,18 +7,13 @@
 #
 FONTMAPFILE = cp437.uni
 
-obj-y	 += mem.o random.o tty_io.o n_tty.o tty_ioctl.o tty_ldisc.o tty_buffer.o tty_port.o
+obj-y	 += mem.o random.o
 
-obj-y				+= tty_mutex.o
-obj-$(CONFIG_LEGACY_PTYS)	+= pty.o
-obj-$(CONFIG_UNIX98_PTYS)	+= pty.o
 obj-y				+= misc.o
 obj-$(CONFIG_VT)		+= vt_ioctl.o vc_screen.o selection.o keyboard.o
 obj-$(CONFIG_BFIN_JTAG_COMM)	+= bfin_jtag_comm.o
 obj-$(CONFIG_CONSOLE_TRANSLATIONS) += consolemap.o consolemap_deftbl.o
 obj-$(CONFIG_HW_CONSOLE)	+= vt.o defkeymap.o
-obj-$(CONFIG_AUDIT)		+= tty_audit.o
-obj-$(CONFIG_MAGIC_SYSRQ)	+= sysrq.o
 obj-$(CONFIG_MVME147_SCC)	+= generic_serial.o vme_scc.o
 obj-$(CONFIG_MVME162_SCC)	+= generic_serial.o vme_scc.o
 obj-$(CONFIG_BVME6000_SCC)	+= generic_serial.o vme_scc.o
@@ -40,8 +35,6 @@ obj-$(CONFIG_ISI)		+= isicom.o
 obj-$(CONFIG_SYNCLINK)		+= synclink.o
 obj-$(CONFIG_SYNCLINKMP)	+= synclinkmp.o
 obj-$(CONFIG_SYNCLINK_GT)	+= synclink_gt.o
-obj-$(CONFIG_N_HDLC)		+= n_hdlc.o
-obj-$(CONFIG_N_GSM)		+= n_gsm.o
 obj-$(CONFIG_AMIGA_BUILTIN_SERIAL) += amiserial.o
 obj-$(CONFIG_SX)		+= sx.o generic_serial.o
 obj-$(CONFIG_RIO)		+= rio/ generic_serial.o
@@ -73,7 +66,6 @@ obj-$(CONFIG_PRINTER)		+= lp.o
 obj-$(CONFIG_APM_EMULATION)	+= apm-emulation.o
 
 obj-$(CONFIG_DTLK)		+= dtlk.o
-obj-$(CONFIG_R3964)		+= n_r3964.o
 obj-$(CONFIG_APPLICOM)		+= applicom.o
 obj-$(CONFIG_SONYPI)		+= sonypi.o
 obj-$(CONFIG_RTC)		+= rtc.o
diff --git a/drivers/tty/Kconfig b/drivers/tty/Kconfig
new file mode 100644
index 0000000..a245618
--- /dev/null
+++ b/drivers/tty/Kconfig
@@ -0,0 +1,96 @@
+config UNIX98_PTYS
+	bool "Unix98 PTY support" if EMBEDDED
+	default y
+	---help---
+	  A pseudo terminal (PTY) is a software device consisting of two
+	  halves: a master and a slave. The slave device behaves identical to
+	  a physical terminal; the master device is used by a process to
+	  read data from and write data to the slave, thereby emulating a
+	  terminal. Typical programs for the master side are telnet servers
+	  and xterms.
+
+	  Linux has traditionally used the BSD-like names /dev/ptyxx for
+	  masters and /dev/ttyxx for slaves of pseudo terminals. This scheme
+	  has a number of problems. The GNU C library glibc 2.1 and later,
+	  however, supports the Unix98 naming standard: in order to acquire a
+	  pseudo terminal, a process opens /dev/ptmx; the number of the pseudo
+	  terminal is then made available to the process and the pseudo
+	  terminal slave can be accessed as /dev/pts/<number>. What was
+	  traditionally /dev/ttyp2 will then be /dev/pts/2, for example.
+
+	  All modern Linux systems use the Unix98 ptys.  Say Y unless
+	  you're on an embedded system and want to conserve memory.
+
+config DEVPTS_MULTIPLE_INSTANCES
+	bool "Support multiple instances of devpts"
+	depends on UNIX98_PTYS
+	default n
+	---help---
+	  Enable support for multiple instances of devpts filesystem.
+	  If you want to have isolated PTY namespaces (eg: in containers),
+	  say Y here.  Otherwise, say N. If enabled, each mount of devpts
+	  filesystem with the '-o newinstance' option will create an
+	  independent PTY namespace.
+
+config LEGACY_PTYS
+	bool "Legacy (BSD) PTY support"
+	default y
+	---help---
+	  A pseudo terminal (PTY) is a software device consisting of two
+	  halves: a master and a slave. The slave device behaves identical to
+	  a physical terminal; the master device is used by a process to
+	  read data from and write data to the slave, thereby emulating a
+	  terminal. Typical programs for the master side are telnet servers
+	  and xterms.
+
+	  Linux has traditionally used the BSD-like names /dev/ptyxx
+	  for masters and /dev/ttyxx for slaves of pseudo
+	  terminals. This scheme has a number of problems, including
+	  security.  This option enables these legacy devices; on most
+	  systems, it is safe to say N.
+
+
+config LEGACY_PTY_COUNT
+	int "Maximum number of legacy PTY in use"
+	depends on LEGACY_PTYS
+	range 0 256
+	default "256"
+	---help---
+	  The maximum number of legacy PTYs that can be used at any one time.
+	  The default is 256, and should be more than enough.  Embedded
+	  systems may want to reduce this to save memory.
+
+	  When not in use, each legacy PTY occupies 12 bytes on 32-bit
+	  architectures and 24 bytes on 64-bit architectures.
+
+config R3964
+	tristate "Siemens R3964 line discipline"
+	---help---
+	  This driver allows synchronous communication with devices using the
+	  Siemens R3964 packet protocol. Unless you are dealing with special
+	  hardware like PLCs, you are unlikely to need this.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called n_r3964.
+
+	  If unsure, say N.
+
+config N_HDLC
+	tristate "HDLC line discipline support"
+	depends on SERIAL_NONSTANDARD
+	help
+	  Allows synchronous HDLC communications with tty device drivers that
+	  support synchronous HDLC such as the Microgate SyncLink adapter.
+
+	  This driver can be built as a module ( = code which can be
+	  inserted in and removed from the running kernel whenever you want).
+	  The module will be called n_hdlc. If you want to do that, say M
+	  here.
+
+config N_GSM
+	tristate "GSM MUX line discipline support (EXPERIMENTAL)"
+	depends on EXPERIMENTAL
+	depends on NET
+	help
+	  This line discipline provides support for the GSM MUX protocol and
+	  presents the mux as a set of 61 individual tty devices.
diff --git a/drivers/tty/Makefile b/drivers/tty/Makefile
new file mode 100644
index 0000000..562a96f
--- /dev/null
+++ b/drivers/tty/Makefile
@@ -0,0 +1,22 @@
+#
+# Makefile for the kernel tty device drivers.
+#
+
+obj-y				+= tty_io.o
+obj-y				+= tty_ioctl.o
+obj-y				+= tty_ldisc.o
+obj-y				+= tty_buffer.o
+obj-y				+= tty_port.o
+obj-y				+= tty_mutex.o
+
+obj-$(CONFIG_LEGACY_PTYS)	+= pty.o
+obj-$(CONFIG_UNIX98_PTYS)	+= pty.o
+
+obj-$(CONFIG_AUDIT)		+= tty_audit.o
+
+obj-$(CONFIG_MAGIC_SYSRQ)	+= sysrq.o
+
+obj-y				+= n_tty.o
+obj-$(CONFIG_N_HDLC)		+= n_hdlc.o
+obj-$(CONFIG_N_GSM)		+= n_gsm.o
+obj-$(CONFIG_R3964)		+= n_r3964.o
diff --git a/drivers/char/n_gsm.c b/drivers/tty/n_gsm.c
similarity index 100%
rename from drivers/char/n_gsm.c
rename to drivers/tty/n_gsm.c
diff --git a/drivers/char/n_hdlc.c b/drivers/tty/n_hdlc.c
similarity index 100%
rename from drivers/char/n_hdlc.c
rename to drivers/tty/n_hdlc.c
diff --git a/drivers/char/n_r3964.c b/drivers/tty/n_r3964.c
similarity index 100%
rename from drivers/char/n_r3964.c
rename to drivers/tty/n_r3964.c
diff --git a/drivers/char/n_tty.c b/drivers/tty/n_tty.c
similarity index 100%
rename from drivers/char/n_tty.c
rename to drivers/tty/n_tty.c
diff --git a/drivers/char/pty.c b/drivers/tty/pty.c
similarity index 100%
rename from drivers/char/pty.c
rename to drivers/tty/pty.c
diff --git a/drivers/char/sysrq.c b/drivers/tty/sysrq.c
similarity index 100%
rename from drivers/char/sysrq.c
rename to drivers/tty/sysrq.c
diff --git a/drivers/char/tty_audit.c b/drivers/tty/tty_audit.c
similarity index 100%
rename from drivers/char/tty_audit.c
rename to drivers/tty/tty_audit.c
diff --git a/drivers/char/tty_buffer.c b/drivers/tty/tty_buffer.c
similarity index 100%
rename from drivers/char/tty_buffer.c
rename to drivers/tty/tty_buffer.c
diff --git a/drivers/char/tty_io.c b/drivers/tty/tty_io.c
similarity index 100%
rename from drivers/char/tty_io.c
rename to drivers/tty/tty_io.c
diff --git a/drivers/char/tty_ioctl.c b/drivers/tty/tty_ioctl.c
similarity index 100%
rename from drivers/char/tty_ioctl.c
rename to drivers/tty/tty_ioctl.c
diff --git a/drivers/char/tty_ldisc.c b/drivers/tty/tty_ldisc.c
similarity index 100%
rename from drivers/char/tty_ldisc.c
rename to drivers/tty/tty_ldisc.c
diff --git a/drivers/char/tty_mutex.c b/drivers/tty/tty_mutex.c
similarity index 100%
rename from drivers/char/tty_mutex.c
rename to drivers/tty/tty_mutex.c
diff --git a/drivers/char/tty_port.c b/drivers/tty/tty_port.c
similarity index 100%
rename from drivers/char/tty_port.c
rename to drivers/tty/tty_port.c
-- 
1.7.1

