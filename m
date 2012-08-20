Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755751Ab2HTVuw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 17:50:52 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41990 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755503Ab2HTVuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 17:50:44 -0400
From: Joe Millenbach <jmillenbach@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Josh Triplett <josh@joshtriplett.org>, team-fjord@googlegroups.com,
        Joe Millenbach <jmillenbach@gmail.com>
Subject: [PATCH] tty: Added a CONFIG_TTY option to allow removal of TTY
Date: Mon, 20 Aug 2012 14:50:31 -0700
Message-Id: <1345499431-21658-1-git-send-email-jmillenbach@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The option allows you to remove TTY and compile without errors. This
saves space on systems that won't support TTY interfaces anyway.
bloat-o-meter output is below.

The bulk of this patch consists of Kconfig changes adding "depends on
TTY" to various serial devices and similar drivers that require the TTY
layer.  Ideally, these dependencies would occur on a common intermediate
symbol such as SERIO, but most drivers "select SERIO" rather than
"depends on SERIO", and "select" does not respect dependencies.

bloat-o-meter output filtered to not show removed entries with awk
'$3 != "-"' as the list was very long.

add/remove: 0/385 grow/shrink: 2/18 up/down: 14/-54016 (-54002)
function                                     old     new   delta
chr_dev_init                                 193     205     +12
selinux_setprocattr                         1167    1169      +2
static.__warned                              557     556      -1
start_kernel                                 840     835      -5
proc_root_init                               167     162      -5
unregister_console                           165     157      -8
sys_setsid                                   213     205      -8
sys_vhangup                                   37      21     -16
daemonize                                    689     673     -16
t_stop                                        72      54     -18
t_next                                       129     108     -21
static.do_acct_process                       838     806     -32
release_task                                1157    1125     -32
do_exit                                     2325    2288     -37
t_start                                      269     221     -48
static.__func__                            18289   18219     -70
do_task_stat                                2962    2892     -70
flush_unauthorized_files                     740     614    -126
static._rs                                  1440    1280    -160
static.__key                                8560    8384    -176

Signed-off-by: Joe Millenbach <jmillenbach@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 arch/tile/Kconfig                   |    1 +
 drivers/bluetooth/Kconfig           |    1 +
 drivers/char/Kconfig                |    7 +-
 drivers/char/pcmcia/Kconfig         |    4 +-
 drivers/i2c/busses/Kconfig          |    2 +-
 drivers/input/joystick/Kconfig      |    7 ++
 drivers/input/keyboard/Kconfig      |    8 ++-
 drivers/input/mouse/Kconfig         |    3 +
 drivers/input/serio/Kconfig         |    1 +
 drivers/input/touchscreen/Kconfig   |   15 +++-
 drivers/isdn/Kconfig                |    1 +
 drivers/isdn/capi/Kconfig           |    1 +
 drivers/isdn/gigaset/Kconfig        |    1 +
 drivers/isdn/hardware/mISDN/Kconfig |    1 +
 drivers/lguest/Kconfig              |    2 +-
 drivers/media/radio/wl128x/Kconfig  |    2 +-
 drivers/misc/Kconfig                |    2 +-
 drivers/misc/ti-st/Kconfig          |    2 +-
 drivers/mmc/card/Kconfig            |    1 +
 drivers/net/caif/Kconfig            |    2 +-
 drivers/net/can/Kconfig             |    2 +-
 drivers/net/hamradio/Kconfig        |    4 +-
 drivers/net/irda/Kconfig            |    2 +-
 drivers/net/ppp/Kconfig             |    4 +-
 drivers/net/slip/Kconfig            |    1 +
 drivers/net/usb/Kconfig             |    4 +-
 drivers/net/wan/Kconfig             |    2 +-
 drivers/pps/clients/Kconfig         |    2 +-
 drivers/tty/Kconfig                 |   21 ++++--
 drivers/tty/Makefile                |    2 +-
 drivers/tty/hvc/Kconfig             |   21 +++---
 drivers/tty/serial/8250/Kconfig     |    1 +
 drivers/tty/serial/Kconfig          |  132 ++++++++++++++++++-----------------
 drivers/usb/class/Kconfig           |    2 +-
 drivers/usb/serial/Kconfig          |    2 +-
 fs/proc/Makefile                    |    4 +-
 include/linux/console.h             |    5 ++
 include/linux/proc_fs.h             |    5 ++
 include/linux/tty.h                 |   39 +++++++++++
 lib/Kconfig.kgdb                    |    1 +
 net/bluetooth/rfcomm/Kconfig        |    1 +
 net/irda/ircomm/Kconfig             |    2 +-
 sound/soc/codecs/Kconfig            |    3 +-
 43 files changed, 217 insertions(+), 109 deletions(-)

diff --git a/arch/tile/Kconfig b/arch/tile/Kconfig
index 11270ca..44620cd 100644
--- a/arch/tile/Kconfig
+++ b/arch/tile/Kconfig
@@ -102,6 +102,7 @@ config DEBUG_COPY_FROM_USER
 	def_bool n
 
 config HVC_TILE
+	depends on TTY
 	select HVC_DRIVER
 	def_bool y
 
diff --git a/drivers/bluetooth/Kconfig b/drivers/bluetooth/Kconfig
index 5ccf142..fb7acc2 100644
--- a/drivers/bluetooth/Kconfig
+++ b/drivers/bluetooth/Kconfig
@@ -26,6 +26,7 @@ config BT_HCIBTSDIO
 
 config BT_HCIUART
 	tristate "HCI UART driver"
+	depends on TTY
 	help
 	  Bluetooth HCI UART driver.
 	  This driver is required if you want to use Bluetooth devices with
diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index 4364303..955ee518 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -53,7 +53,7 @@ source "drivers/tty/serial/Kconfig"
 
 config TTY_PRINTK
 	bool "TTY driver to output user messages via printk"
-	depends on EXPERT
+	depends on EXPERT && TTY
 	default n
 	---help---
 	  If you say Y here, the support for writing user messages (i.e.
@@ -174,7 +174,7 @@ source "drivers/tty/hvc/Kconfig"
 
 config VIRTIO_CONSOLE
 	tristate "Virtio console"
-	depends on VIRTIO
+	depends on VIRTIO && TTY
 	select HVC_DRIVER
 	help
 	  Virtio console for use with lguest and other hypervisors.
@@ -407,6 +407,7 @@ config XILINX_HWICAP
 
 config R3964
 	tristate "Siemens R3964 line discipline"
+	depends on TTY
 	---help---
 	  This driver allows synchronous communication with devices using the
 	  Siemens R3964 packet protocol. Unless you are dealing with special
@@ -454,7 +455,7 @@ source "drivers/char/pcmcia/Kconfig"
 
 config MWAVE
 	tristate "ACP Modem (Mwave) support"
-	depends on X86
+	depends on X86 && TTY
 	select SERIAL_8250
 	---help---
 	  The ACP modem (Mwave) for Linux is a WinModem. It is composed of a
diff --git a/drivers/char/pcmcia/Kconfig b/drivers/char/pcmcia/Kconfig
index 6614416..2a166d5 100644
--- a/drivers/char/pcmcia/Kconfig
+++ b/drivers/char/pcmcia/Kconfig
@@ -7,7 +7,7 @@ menu "PCMCIA character devices"
 
 config SYNCLINK_CS
 	tristate "SyncLink PC Card support"
-	depends on PCMCIA
+	depends on PCMCIA && TTY
 	help
 	  Enable support for the SyncLink PC Card serial adapter, running
 	  asynchronous and HDLC communications up to 512Kbps. The port is
@@ -45,7 +45,7 @@ config CARDMAN_4040
 
 config IPWIRELESS
 	tristate "IPWireless 3G UMTS PCMCIA card support"
-	depends on PCMCIA && NETDEVICES
+	depends on PCMCIA && NETDEVICES && TTY
 	select PPP
 	help
 	  This is a driver for 3G UMTS PCMCIA card from IPWireless company. In
diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index 3101dd5..81eed4e 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -759,7 +759,7 @@ config I2C_PARPORT_LIGHT
 
 config I2C_TAOS_EVM
 	tristate "TAOS evaluation module"
-	depends on EXPERIMENTAL
+	depends on EXPERIMENTAL && TTY
 	select SERIO
 	select SERIO_SERPORT
 	default n
diff --git a/drivers/input/joystick/Kconfig b/drivers/input/joystick/Kconfig
index 56eb471..cd24588 100644
--- a/drivers/input/joystick/Kconfig
+++ b/drivers/input/joystick/Kconfig
@@ -134,6 +134,7 @@ source "drivers/input/joystick/iforce/Kconfig"
 
 config JOYSTICK_WARRIOR
 	tristate "Logitech WingMan Warrior joystick"
+	depends on TTY
 	select SERIO
 	help
 	  Say Y here if you have a Logitech WingMan Warrior joystick connected
@@ -144,6 +145,7 @@ config JOYSTICK_WARRIOR
 
 config JOYSTICK_MAGELLAN
 	tristate "LogiCad3d Magellan/SpaceMouse 6dof controllers"
+	depends on TTY
 	select SERIO
 	help
 	  Say Y here if you have a Magellan or Space Mouse 6DOF controller
@@ -154,6 +156,7 @@ config JOYSTICK_MAGELLAN
 
 config JOYSTICK_SPACEORB
 	tristate "SpaceTec SpaceOrb/Avenger 6dof controllers"
+	depends on TTY
 	select SERIO
 	help
 	  Say Y here if you have a SpaceOrb 360 or SpaceBall Avenger 6DOF
@@ -164,6 +167,7 @@ config JOYSTICK_SPACEORB
 
 config JOYSTICK_SPACEBALL
 	tristate "SpaceTec SpaceBall 6dof controllers"
+	depends on TTY
 	select SERIO
 	help
 	  Say Y here if you have a SpaceTec SpaceBall 2003/3003/4000 FLX
@@ -175,6 +179,7 @@ config JOYSTICK_SPACEBALL
 
 config JOYSTICK_STINGER
 	tristate "Gravis Stinger gamepad"
+	depends on TTY
 	select SERIO
 	help
 	  Say Y here if you have a Gravis Stinger connected to one of your
@@ -185,6 +190,7 @@ config JOYSTICK_STINGER
 
 config JOYSTICK_TWIDJOY
 	tristate "Twiddler as a joystick"
+	depends on TTY
 	select SERIO
 	help
 	  Say Y here if you have a Handykey Twiddler connected to your
@@ -195,6 +201,7 @@ config JOYSTICK_TWIDJOY
 
 config JOYSTICK_ZHENHUA
 	tristate "5-byte Zhenhua RC transmitter"
+	depends on TTY
 	select SERIO
 	help
 	  Say Y here if you have a Zhen Hua PPM-4CH transmitter which is
diff --git a/drivers/input/keyboard/Kconfig b/drivers/input/keyboard/Kconfig
index cdc385b..75f38e8 100644
--- a/drivers/input/keyboard/Kconfig
+++ b/drivers/input/keyboard/Kconfig
@@ -69,6 +69,7 @@ config KEYBOARD_ATARI
 config KEYBOARD_ATKBD
 	tristate "AT keyboard" if EXPERT || !X86
 	default y
+	depends on TTY
 	select SERIO
 	select SERIO_LIBPS2
 	select SERIO_I8042 if X86
@@ -153,6 +154,7 @@ config KEYBOARD_BFIN
 
 config KEYBOARD_LKKBD
 	tristate "DECstation/VAXstation LK201/LK401 keyboard"
+	depends on TTY
 	select SERIO
 	help
 	  Say Y here if you want to use a LK201 or LK401 style serial
@@ -265,7 +267,7 @@ config KEYBOARD_HIL_OLD
 
 config KEYBOARD_HIL
 	tristate "HP HIL keyboard/pointer support"
-	depends on GSC || HP300
+	depends on (GSC || HP300) && TTY
 	default y
 	select HP_SDC
 	select HIL_MLC
@@ -374,6 +376,7 @@ config KEYBOARD_IMX
 
 config KEYBOARD_NEWTON
 	tristate "Newton keyboard"
+	depends on TTY
 	select SERIO
 	help
 	  Say Y here if you have a Newton keyboard on a serial port.
@@ -451,6 +454,7 @@ config KEYBOARD_SAMSUNG
 
 config KEYBOARD_STOWAWAY
 	tristate "Stowaway keyboard"
+	depends on TTY
 	select SERIO
 	help
 	  Say Y here if you have a Stowaway keyboard on a serial port.
@@ -462,6 +466,7 @@ config KEYBOARD_STOWAWAY
 
 config KEYBOARD_SUNKBD
 	tristate "Sun Type 4 and Type 5 keyboard"
+	depends on TTY
 	select SERIO
 	help
 	  Say Y here if you want to use a Sun Type 4 or Type 5 keyboard,
@@ -560,6 +565,7 @@ config KEYBOARD_TWL4030
 
 config KEYBOARD_XTKBD
 	tristate "XT keyboard"
+	depends on TTY
 	select SERIO
 	help
 	  Say Y here if you want to use the old IBM PC/XT keyboard (or
diff --git a/drivers/input/mouse/Kconfig b/drivers/input/mouse/Kconfig
index 9c1e6ee..a9628c4 100644
--- a/drivers/input/mouse/Kconfig
+++ b/drivers/input/mouse/Kconfig
@@ -14,6 +14,7 @@ if INPUT_MOUSE
 
 config MOUSE_PS2
 	tristate "PS/2 mouse"
+	depends on TTY
 	default y
 	select SERIO
 	select SERIO_LIBPS2
@@ -138,6 +139,7 @@ config MOUSE_PS2_OLPC
 
 config MOUSE_SERIAL
 	tristate "Serial mouse"
+	depends on TTY
 	select SERIO
 	help
 	  Say Y here if you have a serial (RS-232, COM port) mouse connected
@@ -262,6 +264,7 @@ config MOUSE_RISCPC
 
 config MOUSE_VSXXXAA
 	tristate "DEC VSXXX-AA/GA mouse and VSXXX-AB tablet"
+	depends on TTY
 	select SERIO
 	help
 	  Say Y (or M) if you want to use a DEC VSXXX-AA (hockey
diff --git a/drivers/input/serio/Kconfig b/drivers/input/serio/Kconfig
index 55f2c22..56a6163 100644
--- a/drivers/input/serio/Kconfig
+++ b/drivers/input/serio/Kconfig
@@ -4,6 +4,7 @@
 config SERIO
 	tristate "Serial I/O support" if EXPERT || !X86
 	default y
+	depends on TTY
 	help
 	  Say Yes here if you have any input device that uses serial I/O to
 	  communicate with the system. This includes the
diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
index 4af2a18..21d4d31 100644
--- a/drivers/input/touchscreen/Kconfig
+++ b/drivers/input/touchscreen/Kconfig
@@ -113,7 +113,7 @@ config TOUCHSCREEN_AUO_PIXCIR
 
 config TOUCHSCREEN_BITSY
 	tristate "Compaq iPAQ H3600 (Bitsy) touchscreen"
-	depends on SA1100_BITSY
+	depends on SA1100_BITSY && TTY
 	select SERIO
 	help
 	  Say Y here if you have the h3600 (Bitsy) touchscreen.
@@ -159,6 +159,7 @@ config TOUCHSCREEN_DA9034
 
 config TOUCHSCREEN_DYNAPRO
 	tristate "Dynapro serial touchscreen"
+	depends on TTY
 	select SERIO
 	help
 	  Say Y here if you have a Dynapro serial touchscreen connected to
@@ -171,6 +172,7 @@ config TOUCHSCREEN_DYNAPRO
 
 config TOUCHSCREEN_HAMPSHIRE
 	tristate "Hampshire serial touchscreen"
+	depends on TTY
 	select SERIO
 	help
 	  Say Y here if you have a Hampshire serial touchscreen connected to
@@ -202,6 +204,7 @@ config TOUCHSCREEN_EGALAX
 
 config TOUCHSCREEN_FUJITSU
 	tristate "Fujitsu serial touchscreen"
+	depends on TTY
 	select SERIO
 	help
 	  Say Y here if you have the Fujitsu touchscreen (such as one
@@ -227,6 +230,7 @@ config TOUCHSCREEN_S3C2410
 
 config TOUCHSCREEN_GUNZE
 	tristate "Gunze AHL-51S touchscreen"
+	depends on TTY
 	select SERIO
 	help
 	  Say Y here if you have the Gunze AHL-51 touchscreen connected to
@@ -239,6 +243,7 @@ config TOUCHSCREEN_GUNZE
 
 config TOUCHSCREEN_ELO
 	tristate "Elo serial touchscreens"
+	depends on TTY
 	select SERIO
 	help
 	  Say Y here if you have an Elo serial touchscreen connected to
@@ -251,6 +256,7 @@ config TOUCHSCREEN_ELO
 
 config TOUCHSCREEN_WACOM_W8001
 	tristate "Wacom W8001 penabled serial touchscreen"
+	depends on TTY
 	select SERIO
 	help
 	  Say Y here if you have an Wacom W8001 penabled serial touchscreen
@@ -297,6 +303,7 @@ config TOUCHSCREEN_MCS5000
 
 config TOUCHSCREEN_MTOUCH
 	tristate "MicroTouch serial touchscreens"
+	depends on TTY
 	select SERIO
 	help
 	  Say Y here if you have a MicroTouch (3M) serial touchscreen connected to
@@ -309,6 +316,7 @@ config TOUCHSCREEN_MTOUCH
 
 config TOUCHSCREEN_INEXIO
 	tristate "iNexio serial touchscreens"
+	depends on TTY
 	select SERIO
 	help
 	  Say Y here if you have an iNexio serial touchscreen connected to
@@ -376,6 +384,7 @@ config TOUCHSCREEN_HTCPEN
 
 config TOUCHSCREEN_PENMOUNT
 	tristate "Penmount serial touchscreen"
+	depends on TTY
 	select SERIO
 	help
 	  Say Y here if you have a Penmount serial touchscreen connected to
@@ -408,6 +417,7 @@ config TOUCHSCREEN_TNETV107X
 
 config TOUCHSCREEN_TOUCHRIGHT
 	tristate "Touchright serial touchscreen"
+	depends on TTY
 	select SERIO
 	help
 	  Say Y here if you have a Touchright serial touchscreen connected to
@@ -420,6 +430,7 @@ config TOUCHSCREEN_TOUCHRIGHT
 
 config TOUCHSCREEN_TOUCHWIN
 	tristate "Touchwin serial touchscreen"
+	depends on TTY
 	select SERIO
 	help
 	  Say Y here if you have a Touchwin serial touchscreen connected to
@@ -683,6 +694,7 @@ config TOUCHSCREEN_USB_NEXIO
 
 config TOUCHSCREEN_TOUCHIT213
 	tristate "Sahara TouchIT-213 touchscreen"
+	depends on TTY
 	select SERIO
 	help
 	  Say Y here if you have a Sahara TouchIT-213 Tablet PC.
@@ -694,6 +706,7 @@ config TOUCHSCREEN_TOUCHIT213
 
 config TOUCHSCREEN_TSC_SERIO
 	tristate "TSC-10/25/40 serial touchscreen support"
+	depends on TTY
 	select SERIO
 	help
 	  Say Y here if you have a TSC-10, 25 or 40 serial touchscreen connected
diff --git a/drivers/isdn/Kconfig b/drivers/isdn/Kconfig
index a233ed5..37d50fc 100644
--- a/drivers/isdn/Kconfig
+++ b/drivers/isdn/Kconfig
@@ -22,6 +22,7 @@ if ISDN
 
 menuconfig ISDN_I4L
 	tristate "Old ISDN4Linux (deprecated)"
+	depends on TTY
 	---help---
 	  This driver allows you to use an ISDN adapter for networking
 	  connections and as dialin/out device.  The isdn-tty's have a built
diff --git a/drivers/isdn/capi/Kconfig b/drivers/isdn/capi/Kconfig
index 15c3ffd..f046865 100644
--- a/drivers/isdn/capi/Kconfig
+++ b/drivers/isdn/capi/Kconfig
@@ -18,6 +18,7 @@ config CAPI_TRACE
 
 config ISDN_CAPI_MIDDLEWARE
 	bool "CAPI2.0 Middleware support"
+	depends on TTY
 	help
 	  This option will enhance the capabilities of the /dev/capi20
 	  interface.  It will provide a means of moving a data connection,
diff --git a/drivers/isdn/gigaset/Kconfig b/drivers/isdn/gigaset/Kconfig
index b18a92c..dde5e09 100644
--- a/drivers/isdn/gigaset/Kconfig
+++ b/drivers/isdn/gigaset/Kconfig
@@ -1,5 +1,6 @@
 menuconfig ISDN_DRV_GIGASET
 	tristate "Siemens Gigaset support"
+	depends on TTY
 	select CRC_CCITT
 	select BITREVERSE
 	help
diff --git a/drivers/isdn/hardware/mISDN/Kconfig b/drivers/isdn/hardware/mISDN/Kconfig
index eadc1cd..b8611e3 100644
--- a/drivers/isdn/hardware/mISDN/Kconfig
+++ b/drivers/isdn/hardware/mISDN/Kconfig
@@ -76,6 +76,7 @@ config MISDN_NETJET
 	tristate "Support for NETJet cards"
 	depends on MISDN
 	depends on PCI
+	depends on TTY
 	select MISDN_IPAC
 	select ISDN_HDLC
 	select ISDN_I4L
diff --git a/drivers/lguest/Kconfig b/drivers/lguest/Kconfig
index 34ae49d..f9c4314 100644
--- a/drivers/lguest/Kconfig
+++ b/drivers/lguest/Kconfig
@@ -1,6 +1,6 @@
 config LGUEST
 	tristate "Linux hypervisor example code"
-	depends on X86_32 && EXPERIMENTAL && EVENTFD
+	depends on X86_32 && EXPERIMENTAL && EVENTFD && TTY
 	select HVC_DRIVER
 	---help---
 	  This is a very simple module which allows you to run
diff --git a/drivers/media/radio/wl128x/Kconfig b/drivers/media/radio/wl128x/Kconfig
index ea1e654..f359be7 100644
--- a/drivers/media/radio/wl128x/Kconfig
+++ b/drivers/media/radio/wl128x/Kconfig
@@ -4,7 +4,7 @@
 menu "Texas Instruments WL128x FM driver (ST based)"
 config RADIO_WL128X
 	tristate "Texas Instruments WL128x FM Radio"
-	depends on VIDEO_V4L2 && RFKILL && GPIOLIB
+	depends on VIDEO_V4L2 && RFKILL && GPIOLIB && TTY
 	select TI_ST if NET
 	help
 	Choose Y here if you have this FM radio chip.
diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index c779509..2cbf17f 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -136,7 +136,7 @@ config PHANTOM
 
 config INTEL_MID_PTI
 	tristate "Parallel Trace Interface for MIPI P1149.7 cJTAG standard"
-	depends on PCI
+	depends on PCI && TTY
 	default n
 	help
 	  The PTI (Parallel Trace Interface) driver directs
diff --git a/drivers/misc/ti-st/Kconfig b/drivers/misc/ti-st/Kconfig
index abb5de1..f34dcc5 100644
--- a/drivers/misc/ti-st/Kconfig
+++ b/drivers/misc/ti-st/Kconfig
@@ -5,7 +5,7 @@
 menu "Texas Instruments shared transport line discipline"
 config TI_ST
 	tristate "Shared transport core driver"
-	depends on NET && GPIOLIB
+	depends on NET && GPIOLIB && TTY
 	select FW_LOADER
 	help
 	  This enables the shared transport core driver for TI
diff --git a/drivers/mmc/card/Kconfig b/drivers/mmc/card/Kconfig
index 3b1f783..5562308 100644
--- a/drivers/mmc/card/Kconfig
+++ b/drivers/mmc/card/Kconfig
@@ -52,6 +52,7 @@ config MMC_BLOCK_BOUNCE
 
 config SDIO_UART
 	tristate "SDIO UART/GPS class support"
+	depends on TTY
 	help
 	  SDIO function driver for SDIO cards that implements the UART
 	  class, as well as the GPS class which appears like a UART.
diff --git a/drivers/net/caif/Kconfig b/drivers/net/caif/Kconfig
index abf4d7a..60c2142 100644
--- a/drivers/net/caif/Kconfig
+++ b/drivers/net/caif/Kconfig
@@ -6,7 +6,7 @@ comment "CAIF transport drivers"
 
 config CAIF_TTY
 	tristate "CAIF TTY transport driver"
-	depends on CAIF
+	depends on CAIF && TTY
 	default n
 	---help---
 	The CAIF TTY transport driver is a Line Discipline (ldisc)
diff --git a/drivers/net/can/Kconfig b/drivers/net/can/Kconfig
index ab45758..739c356 100644
--- a/drivers/net/can/Kconfig
+++ b/drivers/net/can/Kconfig
@@ -13,7 +13,7 @@ config CAN_VCAN
 
 config CAN_SLCAN
 	tristate "Serial / USB serial CAN Adaptors (slcan)"
-	depends on CAN
+	depends on CAN && TTY
 	---help---
 	  CAN driver for several 'low cost' CAN interfaces that are attached
 	  via serial lines or via USB-to-serial adapters using the LAWICEL
diff --git a/drivers/net/hamradio/Kconfig b/drivers/net/hamradio/Kconfig
index 95dbcfd..bf5e596 100644
--- a/drivers/net/hamradio/Kconfig
+++ b/drivers/net/hamradio/Kconfig
@@ -1,6 +1,6 @@
 config MKISS
 	tristate "Serial port KISS driver"
-	depends on AX25
+	depends on AX25 && TTY
 	select CRC16
 	---help---
 	  KISS is a protocol used for the exchange of data between a computer
@@ -18,7 +18,7 @@ config MKISS
 
 config 6PACK
 	tristate "Serial port 6PACK driver"
-	depends on AX25
+	depends on AX25 && TTY
 	---help---
 	  6pack is a transmission protocol for the data exchange between your
 	  PC and your TNC (the Terminal Node Controller acts as a kind of
diff --git a/drivers/net/irda/Kconfig b/drivers/net/irda/Kconfig
index e535137..34773ed 100644
--- a/drivers/net/irda/Kconfig
+++ b/drivers/net/irda/Kconfig
@@ -5,7 +5,7 @@ comment "SIR device drivers"
 
 config IRTTY_SIR
 	tristate "IrTTY (uses Linux serial driver)"
-	depends on IRDA
+	depends on IRDA && TTY
 	help
 	  Say Y here if you want to build support for the IrTTY line
 	  discipline.  To compile it as a module, choose M here: the module
diff --git a/drivers/net/ppp/Kconfig b/drivers/net/ppp/Kconfig
index 872df3e..192485f 100644
--- a/drivers/net/ppp/Kconfig
+++ b/drivers/net/ppp/Kconfig
@@ -150,7 +150,7 @@ config PPPOL2TP
 
 config PPP_ASYNC
 	tristate "PPP support for async serial ports"
-	depends on PPP
+	depends on PPP && TTY
 	select CRC_CCITT
 	---help---
 	  Say Y (or M) here if you want to be able to use PPP over standard
@@ -164,7 +164,7 @@ config PPP_ASYNC
 
 config PPP_SYNC_TTY
 	tristate "PPP support for sync tty ports"
-	depends on PPP
+	depends on PPP && TTY
 	---help---
 	  Say Y (or M) here if you want to be able to use PPP over synchronous
 	  (HDLC) tty devices, such as the SyncLink adapter. These devices
diff --git a/drivers/net/slip/Kconfig b/drivers/net/slip/Kconfig
index 211b160..48e6871 100644
--- a/drivers/net/slip/Kconfig
+++ b/drivers/net/slip/Kconfig
@@ -4,6 +4,7 @@
 
 config SLIP
 	tristate "SLIP (serial line) support"
+	depends on TTY
 	---help---
 	  Say Y if you intend to use SLIP or CSLIP (compressed SLIP) to
 	  connect to your Internet service provider or to connect to some
diff --git a/drivers/net/usb/Kconfig b/drivers/net/usb/Kconfig
index 2335761..de4e543 100644
--- a/drivers/net/usb/Kconfig
+++ b/drivers/net/usb/Kconfig
@@ -400,7 +400,7 @@ config USB_NET_KALMIA
 
 config USB_HSO
 	tristate "Option USB High Speed Mobile Devices"
-	depends on USB && RFKILL
+	depends on USB && RFKILL && TTY
 	default n
 	help
 	  Choose this option if you have an Option HSDPA/HSUPA card.
@@ -448,7 +448,7 @@ config USB_SIERRA_NET
 
 config USB_VL600
 	tristate "LG VL600 modem dongle"
-	depends on USB_NET_CDCETHER
+	depends on USB_NET_CDCETHER && TTY
 	select USB_ACM
 	help
 	  Select this if you want to use an LG Electronics 4G/LTE usb modem
diff --git a/drivers/net/wan/Kconfig b/drivers/net/wan/Kconfig
index 423eb26..636c950 100644
--- a/drivers/net/wan/Kconfig
+++ b/drivers/net/wan/Kconfig
@@ -460,7 +460,7 @@ config LAPBETHER
 
 config X25_ASY
 	tristate "X.25 async driver (EXPERIMENTAL)"
-	depends on LAPB && X25
+	depends on LAPB && X25 && TTY
 	---help---
 	  Send and receive X.25 frames over regular asynchronous serial
 	  lines such as telephone lines equipped with ordinary modems.
diff --git a/drivers/pps/clients/Kconfig b/drivers/pps/clients/Kconfig
index 445197d..6efd9b6 100644
--- a/drivers/pps/clients/Kconfig
+++ b/drivers/pps/clients/Kconfig
@@ -17,7 +17,7 @@ config PPS_CLIENT_KTIMER
 
 config PPS_CLIENT_LDISC
 	tristate "PPS line discipline"
-	depends on PPS
+	depends on PPS && TTY
 	help
 	  If you say yes here you get support for a PPS source connected
 	  with the CD (Carrier Detect) pin of your serial port.
diff --git a/drivers/tty/Kconfig b/drivers/tty/Kconfig
index 830cd62..71f93c6 100644
--- a/drivers/tty/Kconfig
+++ b/drivers/tty/Kconfig
@@ -1,6 +1,15 @@
+config TTY
+	bool "Enable TTY" if EXPERT
+	default y
+	---help---
+	  Allows you to remove TTY support which can save space, and
+	  blocks features that require TTY from inclusion in the kernel.
+	  TTY is required for any text terminals or serial port
+	  communication. Most users should leave this enabled.
+
 config VT
 	bool "Virtual terminal" if EXPERT
-	depends on !S390 && !UML
+	depends on !S390 && !UML && TTY
 	select INPUT
 	default y
 	---help---
@@ -88,6 +97,7 @@ config VT_HW_CONSOLE_BINDING
 
 config UNIX98_PTYS
 	bool "Unix98 PTY support" if EXPERT
+	depends on TTY
 	default y
 	---help---
 	  A pseudo terminal (PTY) is a software device consisting of two
@@ -122,6 +132,7 @@ config DEVPTS_MULTIPLE_INSTANCES
 
 config LEGACY_PTYS
 	bool "Legacy (BSD) PTY support"
+	depends on TTY
 	default y
 	---help---
 	  A pseudo terminal (PTY) is a software device consisting of two
@@ -166,7 +177,7 @@ config BFIN_JTAG_COMM_CONSOLE
 
 config SERIAL_NONSTANDARD
 	bool "Non-standard serial port support"
-	depends on HAS_IOMEM
+	depends on HAS_IOMEM && TTY
 	---help---
 	  Say Y here if you have any non-standard serial boards -- boards
 	  which aren't supported using the standard "dumb" serial driver.
@@ -285,7 +296,7 @@ config SYNCLINK_GT
 
 config NOZOMI
 	tristate "HSDPA Broadband Wireless Data Card - Globe Trotter"
-	depends on PCI && EXPERIMENTAL
+	depends on PCI && EXPERIMENTAL && TTY
 	help
 	  If you have a HSDPA driver Broadband Wireless Data Card -
 	  Globe Trotter PCMCIA card, say Y here.
@@ -317,8 +328,7 @@ config N_HDLC
 
 config N_GSM
 	tristate "GSM MUX line discipline support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
-	depends on NET
+	depends on EXPERIMENTAL && NET && TTY
 	help
 	  This line discipline provides support for the GSM MUX protocol and
 	  presents the mux as a set of 61 individual tty devices.
@@ -342,6 +352,7 @@ config TRACE_ROUTER
 
 config TRACE_SINK
 	tristate "Trace data sink for MIPI P1149.7 cJTAG standard"
+	depends on TTY
 	default n
 	help
 	  The trace sink uses the Linux line discipline framework to receive
diff --git a/drivers/tty/Makefile b/drivers/tty/Makefile
index 2953059..df5663d 100644
--- a/drivers/tty/Makefile
+++ b/drivers/tty/Makefile
@@ -1,4 +1,4 @@
-obj-y				+= tty_io.o n_tty.o tty_ioctl.o tty_ldisc.o \
+obj-$(CONFIG_TTY)		+= tty_io.o n_tty.o tty_ioctl.o tty_ldisc.o \
 				   tty_buffer.o tty_port.o tty_mutex.o
 obj-$(CONFIG_LEGACY_PTYS)	+= pty.o
 obj-$(CONFIG_UNIX98_PTYS)	+= pty.o
diff --git a/drivers/tty/hvc/Kconfig b/drivers/tty/hvc/Kconfig
index 4222035..81864d9 100644
--- a/drivers/tty/hvc/Kconfig
+++ b/drivers/tty/hvc/Kconfig
@@ -1,5 +1,6 @@
 config HVC_DRIVER
 	bool
+	depends on TTY
 	help
 	  Generic "hypervisor virtual console" infrastructure for various
 	  hypervisors (pSeries, iSeries, Xen, lguest).
@@ -11,7 +12,7 @@ config HVC_IRQ
 
 config HVC_CONSOLE
 	bool "pSeries Hypervisor Virtual Console support"
-	depends on PPC_PSERIES
+	depends on PPC_PSERIES && TTY
 	select HVC_DRIVER
 	select HVC_IRQ
 	help
@@ -26,7 +27,7 @@ config HVC_OLD_HVSI
 
 config HVC_ISERIES
 	bool "iSeries Hypervisor Virtual Console support"
-	depends on PPC_ISERIES
+	depends on PPC_ISERIES && TTY
 	default y
 	select HVC_DRIVER
 	select HVC_IRQ
@@ -36,7 +37,7 @@ config HVC_ISERIES
 
 config HVC_OPAL
 	bool "OPAL Console support"
-	depends on PPC_POWERNV
+	depends on PPC_POWERNV && TTY
 	select HVC_DRIVER
 	select HVC_IRQ
 	default y
@@ -45,21 +46,21 @@ config HVC_OPAL
 
 config HVC_RTAS
 	bool "IBM RTAS Console support"
-	depends on PPC_RTAS
+	depends on PPC_RTAS && TTY
 	select HVC_DRIVER
 	help
 	  IBM Console device driver which makes use of RTAS
 
 config HVC_BEAT
 	bool "Toshiba's Beat Hypervisor Console support"
-	depends on PPC_CELLEB
+	depends on PPC_CELLEB && TTY
 	select HVC_DRIVER
 	help
 	  Toshiba's Cell Reference Set Beat Console device driver
 
 config HVC_IUCV
 	bool "z/VM IUCV Hypervisor console support (VM only)"
-	depends on S390
+	depends on S390 && TTY
 	select HVC_DRIVER
 	select IUCV
 	default y
@@ -69,7 +70,7 @@ config HVC_IUCV
 
 config HVC_XEN
 	bool "Xen Hypervisor Console support"
-	depends on XEN
+	depends on XEN && TTY
 	select HVC_DRIVER
 	select HVC_IRQ
 	default y
@@ -78,13 +79,13 @@ config HVC_XEN
 
 config HVC_UDBG
        bool "udbg based fake hypervisor console"
-       depends on PPC && EXPERIMENTAL
+       depends on PPC && EXPERIMENTAL && TTY
        select HVC_DRIVER
        default n
 
 config HVC_DCC
        bool "ARM JTAG DCC console"
-       depends on ARM
+       depends on ARM && TTY
        select HVC_DRIVER
        help
          This console uses the JTAG DCC on ARM to create a console under the HVC
@@ -93,7 +94,7 @@ config HVC_DCC
 
 config HVC_BFIN_JTAG
 	bool "Blackfin JTAG console"
-	depends on BLACKFIN
+	depends on BLACKFIN && TTY
 	select HVC_DRIVER
 	help
 	 This console uses the Blackfin JTAG to create a console under the
diff --git a/drivers/tty/serial/8250/Kconfig b/drivers/tty/serial/8250/Kconfig
index 591f801..dd3f938 100644
--- a/drivers/tty/serial/8250/Kconfig
+++ b/drivers/tty/serial/8250/Kconfig
@@ -5,6 +5,7 @@
 
 config SERIAL_8250
 	tristate "8250/16550 and compatible serial support"
+	depends on TTY
 	select SERIAL_CORE
 	---help---
 	  This selects whether you want to include the driver for the standard
diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
index 2de9924..fbf0c04 100644
--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -11,7 +11,7 @@ comment "Non-8250 serial port support"
 
 config SERIAL_AMBA_PL010
 	tristate "ARM AMBA PL010 serial port support"
-	depends on ARM_AMBA && (BROKEN || !ARCH_VERSATILE)
+	depends on ARM_AMBA && (BROKEN || !ARCH_VERSATILE) && TTY
 	select SERIAL_CORE
 	help
 	  This selects the ARM(R) AMBA(R) PrimeCell PL010 UART.  If you have
@@ -22,7 +22,7 @@ config SERIAL_AMBA_PL010
 
 config SERIAL_AMBA_PL010_CONSOLE
 	bool "Support for console on AMBA serial port"
-	depends on SERIAL_AMBA_PL010=y
+	depends on SERIAL_AMBA_PL010=y && TTY
 	select SERIAL_CORE_CONSOLE
 	---help---
 	  Say Y here if you wish to use an AMBA PrimeCell UART as the system
@@ -38,7 +38,7 @@ config SERIAL_AMBA_PL010_CONSOLE
 
 config SERIAL_AMBA_PL011
 	tristate "ARM AMBA PL011 serial port support"
-	depends on ARM_AMBA
+	depends on ARM_AMBA && TTY
 	select SERIAL_CORE
 	help
 	  This selects the ARM(R) AMBA(R) PrimeCell PL011 UART.  If you have
@@ -49,7 +49,7 @@ config SERIAL_AMBA_PL011
 
 config SERIAL_AMBA_PL011_CONSOLE
 	bool "Support for console on AMBA serial port"
-	depends on SERIAL_AMBA_PL011=y
+	depends on SERIAL_AMBA_PL011=y && TTY
 	select SERIAL_CORE_CONSOLE
 	---help---
 	  Say Y here if you wish to use an AMBA PrimeCell UART as the system
@@ -65,7 +65,7 @@ config SERIAL_AMBA_PL011_CONSOLE
 
 config SERIAL_SB1250_DUART
 	tristate "BCM1xxx on-chip DUART serial support"
-	depends on SIBYTE_SB1xxx_SOC=y
+	depends on SIBYTE_SB1xxx_SOC=y && TTY
 	select SERIAL_CORE
 	default y
 	---help---
@@ -80,7 +80,7 @@ config SERIAL_SB1250_DUART
 
 config SERIAL_SB1250_DUART_CONSOLE
 	bool "Support for console on a BCM1xxx DUART serial port"
-	depends on SERIAL_SB1250_DUART=y
+	depends on SERIAL_SB1250_DUART=y && TTY
 	select SERIAL_CORE_CONSOLE
 	default y
 	---help---
@@ -93,7 +93,7 @@ config SERIAL_SB1250_DUART_CONSOLE
 
 config SERIAL_ATMEL
 	bool "AT91 / AT32 on-chip serial port support"
-	depends on (ARM && ARCH_AT91) || AVR32
+	depends on ((ARM && ARCH_AT91) || AVR32) && TTY
 	select SERIAL_CORE
 	help
 	  This enables the driver for the on-chip UARTs of the Atmel
@@ -143,7 +143,7 @@ config SERIAL_ATMEL_TTYAT
 
 config SERIAL_KS8695
 	bool "Micrel KS8695 (Centaur) serial port support"
-	depends on ARCH_KS8695
+	depends on ARCH_KS8695 && TTY
 	select SERIAL_CORE
 	help
 	  This selects the Micrel Centaur KS8695 UART.  Say Y here.
@@ -160,7 +160,7 @@ config SERIAL_KS8695_CONSOLE
 
 config SERIAL_CLPS711X
 	tristate "CLPS711X serial port support"
-	depends on ARM && ARCH_CLPS711X
+	depends on ARM && ARCH_CLPS711X && TTY
 	select SERIAL_CORE
 	help
 	  ::: To be written :::
@@ -179,7 +179,7 @@ config SERIAL_CLPS711X_CONSOLE
 
 config SERIAL_SAMSUNG
 	tristate "Samsung SoC serial support"
-	depends on ARM && PLAT_SAMSUNG
+	depends on ARM && PLAT_SAMSUNG && TTY
 	select SERIAL_CORE
 	help
 	  Support for the on-chip UARTs on the Samsung S3C24XX series CPUs,
@@ -189,14 +189,14 @@ config SERIAL_SAMSUNG
 
 config SERIAL_SAMSUNG_UARTS_4
 	bool
-	depends on ARM && PLAT_SAMSUNG
+	depends on ARM && PLAT_SAMSUNG && TTY
 	default y if !(CPU_S3C2410 || SERIAL_S3C2412 || CPU_S3C2440 || CPU_S3C2442)
 	help
 	  Internal node for the common case of 4 Samsung compatible UARTs
 
 config SERIAL_SAMSUNG_UARTS
 	int
-	depends on ARM && PLAT_SAMSUNG
+	depends on ARM && PLAT_SAMSUNG && TTY
 	default 6 if ARCH_S5P6450
 	default 4 if SERIAL_SAMSUNG_UARTS_4 || CPU_S3C2416
 	default 3
@@ -230,7 +230,7 @@ config SERIAL_SAMSUNG_CONSOLE
 
 config SERIAL_SIRFSOC
         tristate "SiRF SoC Platform Serial port support"
-        depends on ARM && ARCH_PRIMA2
+        depends on ARM && ARCH_PRIMA2 && TTY
         select SERIAL_CORE
         help
           Support for the on-chip UART on the CSR SiRFprimaII series,
@@ -252,21 +252,21 @@ config SERIAL_SIRFSOC_CONSOLE
 
 config SERIAL_MAX3100
 	tristate "MAX3100 support"
-	depends on SPI
+	depends on SPI && TTY
 	select SERIAL_CORE
 	help
 	  MAX3100 chip support
 
 config SERIAL_MAX3107
 	tristate "MAX3107 support"
-	depends on SPI
+	depends on SPI && TTY
 	select SERIAL_CORE
 	help
 	  MAX3107 chip support
 
 config SERIAL_DZ
 	bool "DECstation DZ serial driver"
-	depends on MACH_DECSTATION && 32BIT
+	depends on MACH_DECSTATION && 32BIT && TTY
 	select SERIAL_CORE
 	default y
 	---help---
@@ -291,7 +291,7 @@ config SERIAL_DZ_CONSOLE
 
 config SERIAL_ZS
 	tristate "DECstation Z85C30 serial support"
-	depends on MACH_DECSTATION
+	depends on MACH_DECSTATION && TTY
 	select SERIAL_CORE
 	default y
 	---help---
@@ -321,7 +321,7 @@ config SERIAL_ZS_CONSOLE
 
 config SERIAL_21285
 	tristate "DC21285 serial port support"
-	depends on ARM && FOOTBRIDGE
+	depends on ARM && FOOTBRIDGE && TTY
 	select SERIAL_CORE
 	help
 	  If you have a machine based on a 21285 (Footbridge) StrongARM(R)/
@@ -345,7 +345,7 @@ config SERIAL_21285_CONSOLE
 
 config SERIAL_MPSC
 	bool "Marvell MPSC serial port support"
-	depends on PPC32 && MV64X60
+	depends on PPC32 && MV64X60 && TTY
 	select SERIAL_CORE
 	help
 	  Say Y here if you want to use the Marvell MPSC serial controller.
@@ -359,7 +359,7 @@ config SERIAL_MPSC_CONSOLE
 
 config SERIAL_PXA
 	bool "PXA serial port support"
-	depends on ARCH_PXA || ARCH_MMP
+	depends on (ARCH_PXA || ARCH_MMP) && TTY
 	select SERIAL_CORE
 	help
 	  If you have a machine based on an Intel XScale PXA2xx CPU you
@@ -382,7 +382,7 @@ config SERIAL_PXA_CONSOLE
 
 config SERIAL_SA1100
 	bool "SA1100 serial port support"
-	depends on ARM && ARCH_SA1100
+	depends on (ARM && ARCH_SA1100) && TTY
 	select SERIAL_CORE
 	help
 	  If you have a machine based on a SA1100/SA1110 StrongARM(R) CPU you
@@ -407,7 +407,7 @@ config SERIAL_SA1100_CONSOLE
 
 config SERIAL_MRST_MAX3110
 	tristate "SPI UART driver for Max3110"
-	depends on SPI_DW_PCI
+	depends on SPI_DW_PCI && TTY
 	select SERIAL_CORE
 	select SERIAL_CORE_CONSOLE
 	help
@@ -417,7 +417,7 @@ config SERIAL_MRST_MAX3110
 
 config SERIAL_MFD_HSU
 	tristate "Medfield High Speed UART support"
-	depends on PCI
+	depends on PCI && TTY
 	select SERIAL_CORE
 
 config SERIAL_MFD_HSU_CONSOLE
@@ -427,7 +427,7 @@ config SERIAL_MFD_HSU_CONSOLE
 
 config SERIAL_BFIN
 	tristate "Blackfin serial port support"
-	depends on BLACKFIN
+	depends on BLACKFIN && TTY
 	select SERIAL_CORE
 	select SERIAL_BFIN_UART0 if (BF531 || BF532 || BF533 || BF561)
 	help
@@ -513,7 +513,7 @@ config BFIN_UART3_CTSRTS
 
 config SERIAL_IMX
 	bool "IMX serial port support"
-	depends on ARCH_MXC
+	depends on ARCH_MXC && TTY
 	select SERIAL_CORE
 	select RATIONAL
 	help
@@ -537,7 +537,7 @@ config SERIAL_IMX_CONSOLE
 
 config SERIAL_UARTLITE
 	tristate "Xilinx uartlite serial port support"
-	depends on PPC32 || MICROBLAZE || MFD_TIMBERDALE
+	depends on (PPC32 || MICROBLAZE || MFD_TIMBERDALE) && TTY
 	select SERIAL_CORE
 	help
 	  Say Y here if you want to use the Xilinx uartlite serial controller.
@@ -556,14 +556,14 @@ config SERIAL_UARTLITE_CONSOLE
 
 config SERIAL_SUNCORE
 	bool
-	depends on SPARC
+	depends on SPARC && TTY
 	select SERIAL_CORE
 	select SERIAL_CORE_CONSOLE
 	default y
 
 config SERIAL_SUNZILOG
 	tristate "Sun Zilog8530 serial support"
-	depends on SPARC
+	depends on SPARC && TTY
 	help
 	  This driver supports the Zilog8530 serial ports found on many Sparc
 	  systems.  Say Y or M if you want to be able to these serial ports.
@@ -578,7 +578,7 @@ config SERIAL_SUNZILOG_CONSOLE
 
 config SERIAL_SUNSU
 	tristate "Sun SU serial support"
-	depends on SPARC && PCI
+	depends on SPARC && PCI && TTY
 	help
 	  This driver supports the 8250 serial ports that run the keyboard and
 	  mouse on (PCI) UltraSPARC systems.  Say Y or M if you want to be able
@@ -594,7 +594,7 @@ config SERIAL_SUNSU_CONSOLE
 
 config SERIAL_MUX
 	tristate "Serial MUX support"
-	depends on GSC
+	depends on GSC && TTY
 	select SERIAL_CORE
 	default y
 	---help---
@@ -635,7 +635,7 @@ config PDC_CONSOLE
 
 config SERIAL_SUNSAB
 	tristate "Sun Siemens SAB82532 serial support"
-	depends on SPARC && PCI
+	depends on SPARC && PCI && TTY
 	help
 	  This driver supports the Siemens SAB82532 DUSCC serial ports on newer
 	  (PCI) UltraSPARC systems.  Say Y or M if you want to be able to these
@@ -651,14 +651,14 @@ config SERIAL_SUNSAB_CONSOLE
 
 config SERIAL_SUNHV
 	bool "Sun4v Hypervisor Console support"
-	depends on SPARC64
+	depends on SPARC64 && TTY
 	help
 	  This driver supports the console device found on SUN4V Sparc
 	  systems.  Say Y if you want to be able to use this device.
 
 config SERIAL_IP22_ZILOG
 	tristate "SGI Zilog8530 serial support"
-	depends on SGI_HAS_ZILOG
+	depends on SGI_HAS_ZILOG && TTY
 	select SERIAL_CORE
 	help
 	  This driver supports the Zilog8530 serial ports found on SGI
@@ -671,7 +671,7 @@ config SERIAL_IP22_ZILOG_CONSOLE
 
 config SERIAL_SH_SCI
 	tristate "SuperH SCI(F) serial port support"
-	depends on HAVE_CLK && (SUPERH || ARCH_SHMOBILE)
+	depends on HAVE_CLK && (SUPERH || ARCH_SHMOBILE) && TTY
 	select SERIAL_CORE
 
 config SERIAL_SH_SCI_NR_UARTS
@@ -690,7 +690,7 @@ config SERIAL_SH_SCI_DMA
 
 config SERIAL_PNX8XXX
 	bool "Enable PNX8XXX SoCs' UART Support"
-	depends on MIPS && (SOC_PNX8550 || SOC_PNX833X)
+	depends on MIPS && (SOC_PNX8550 || SOC_PNX833X) && TTY
 	select SERIAL_CORE
 	help
 	  If you have a MIPS-based Philips SoC such as PNX8550 or PNX8330
@@ -715,7 +715,7 @@ config CONSOLE_POLL
 
 config SERIAL_68328
 	bool "68328 serial support"
-	depends on M68328 || M68EZ328 || M68VZ328
+	depends on (M68328 || M68EZ328 || M68VZ328) && TTY
 	help
 	  This driver supports the built-in serial port of the Motorola 68328
 	  (standard, EZ and VZ varieties).
@@ -726,7 +726,7 @@ config SERIAL_68328_RTS_CTS
 
 config SERIAL_MCF
 	bool "Coldfire serial support"
-	depends on COLDFIRE
+	depends on COLDFIRE && TTY
 	select SERIAL_CORE
 	help
 	  This serial driver supports the Freescale Coldfire serial ports.
@@ -749,7 +749,7 @@ config SERIAL_MCF_CONSOLE
 
 config SERIAL_PMACZILOG
 	tristate "Mac or PowerMac z85c30 ESCC support"
-	depends on (M68K && MAC) || (PPC_OF && PPC_PMAC)
+	depends on ((M68K && MAC) || (PPC_OF && PPC_PMAC)) && TTY
 	select SERIAL_CORE
 	help
 	  This driver supports the Zilog z85C30 serial ports found on
@@ -792,7 +792,7 @@ config SERIAL_PMACZILOG_CONSOLE
 
 config SERIAL_CPM
 	tristate "CPM SCC/SMC serial port support"
-	depends on CPM2 || 8xx
+	depends on (CPM2 || 8xx) && TTY
 	select SERIAL_CORE
 	help
 	  This driver supports the SCC and SMC serial ports on Motorola 
@@ -816,7 +816,7 @@ config SERIAL_CPM_CONSOLE
 
 config SERIAL_SGI_L1_CONSOLE
 	bool "SGI Altix L1 serial console support"
-	depends on IA64_GENERIC || IA64_SGI_SN2
+	depends on (IA64_GENERIC || IA64_SGI_SN2) && TTY
 	select SERIAL_CORE
 	select SERIAL_CORE_CONSOLE
 	help
@@ -826,7 +826,7 @@ config SERIAL_SGI_L1_CONSOLE
 
 config SERIAL_MPC52xx
 	tristate "Freescale MPC52xx/MPC512x family PSC serial support"
-	depends on PPC_MPC52xx || PPC_MPC512x
+	depends on (PPC_MPC52xx || PPC_MPC512x) && TTY
 	select SERIAL_CORE
 	help
 	  This driver supports MPC52xx and MPC512x PSC serial ports. If you would
@@ -853,7 +853,7 @@ config SERIAL_MPC52xx_CONSOLE_BAUD
 
 config SERIAL_ICOM
 	tristate "IBM Multiport Serial Adapter"
-	depends on PCI && (PPC_ISERIES || PPC_PSERIES)
+	depends on PCI && (PPC_ISERIES || PPC_PSERIES) && TTY
 	select SERIAL_CORE
 	select FW_LOADER
 	help
@@ -866,7 +866,7 @@ config SERIAL_ICOM
 
 config SERIAL_M32R_SIO
 	bool "M32R SIO I/F"
-	depends on M32R
+	depends on M32R && TTY
 	default y
 	select SERIAL_CORE
 	help
@@ -895,7 +895,7 @@ config SERIAL_M32R_PLDSIO
 
 config SERIAL_TXX9
 	bool "TMPTX39XX/49XX SIO support"
-	depends on HAS_TXX9_SERIAL
+	depends on HAS_TXX9_SERIAL && TTY
 	select SERIAL_CORE
 	default y
 
@@ -918,7 +918,7 @@ config SERIAL_TXX9_STDSERIAL
 
 config SERIAL_VR41XX
 	tristate "NEC VR4100 series Serial Interface Unit support"
-	depends on CPU_VR41XX
+	depends on CPU_VR41XX && TTY
 	select SERIAL_CORE
 	help
 	  If you have a NEC VR4100 series processor and you want to use
@@ -935,7 +935,7 @@ config SERIAL_VR41XX_CONSOLE
 
 config SERIAL_JSM
 	tristate "Digi International NEO PCI Support"
-	depends on PCI
+	depends on PCI && TTY
 	select SERIAL_CORE
 	help
 	  This is a driver for Digi International's Neo series
@@ -951,7 +951,7 @@ config SERIAL_JSM
 
 config SERIAL_SGI_IOC4
 	tristate "SGI IOC4 controller serial support"
-	depends on (IA64_GENERIC || IA64_SGI_SN2) && SGI_IOC4
+	depends on (IA64_GENERIC || IA64_SGI_SN2) && SGI_IOC4 && TTY
 	select SERIAL_CORE
 	help
 		If you have an SGI Altix with an IOC4 based Base IO card
@@ -960,7 +960,7 @@ config SERIAL_SGI_IOC4
 
 config SERIAL_SGI_IOC3
 	tristate "SGI Altix IOC3 serial support"
-	depends on (IA64_GENERIC || IA64_SGI_SN2) && SGI_IOC3
+	depends on (IA64_GENERIC || IA64_SGI_SN2) && SGI_IOC3 && TTY
 	select SERIAL_CORE
 	help
 	  If you have an SGI Altix with an IOC3 serial card,
@@ -968,7 +968,7 @@ config SERIAL_SGI_IOC3
 
 config SERIAL_MSM
 	bool "MSM on-chip serial port support"
-	depends on ARM && ARCH_MSM
+	depends on ARM && ARCH_MSM && TTY
 	select SERIAL_CORE
 
 config SERIAL_MSM_CONSOLE
@@ -990,7 +990,7 @@ config SERIAL_MSM_HS
 
 config SERIAL_VT8500
 	bool "VIA VT8500 on-chip serial port support"
-	depends on ARM && ARCH_VT8500
+	depends on ARM && ARCH_VT8500 && TTY
 	select SERIAL_CORE
 
 config SERIAL_VT8500_CONSOLE
@@ -1000,7 +1000,7 @@ config SERIAL_VT8500_CONSOLE
 
 config SERIAL_NETX
 	tristate "NetX serial port support"
-	depends on ARM && ARCH_NETX
+	depends on (ARM && ARCH_NETX) && TTY
 	select SERIAL_CORE
 	help
 	  If you have a machine based on a Hilscher NetX SoC you
@@ -1029,7 +1029,7 @@ config SERIAL_OF_PLATFORM
 
 config SERIAL_OMAP
 	tristate "OMAP serial port support"
-	depends on ARCH_OMAP2PLUS
+	depends on ARCH_OMAP2PLUS && TTY
 	select SERIAL_CORE
 	help
 	  If you have a machine based on an Texas Instruments OMAP CPU you
@@ -1056,7 +1056,7 @@ config SERIAL_OMAP_CONSOLE
 
 config SERIAL_OF_PLATFORM_NWPSERIAL
 	tristate "NWP serial port driver"
-	depends on PPC_OF && PPC_DCR
+	depends on PPC_OF && PPC_DCR && TTY
 	select SERIAL_OF_PLATFORM
 	select SERIAL_CORE_CONSOLE
 	select SERIAL_CORE
@@ -1073,7 +1073,7 @@ config SERIAL_OF_PLATFORM_NWPSERIAL_CONSOLE
 
 config SERIAL_LANTIQ
 	bool "Lantiq serial driver"
-	depends on LANTIQ
+	depends on LANTIQ && TTY
 	select SERIAL_CORE
 	select SERIAL_CORE_CONSOLE
 	help
@@ -1081,7 +1081,7 @@ config SERIAL_LANTIQ
 
 config SERIAL_QE
 	tristate "Freescale QUICC Engine serial port support"
-	depends on QUICC_ENGINE
+	depends on QUICC_ENGINE && TTY
 	select SERIAL_CORE
 	select FW_LOADER
 	default n
@@ -1091,7 +1091,7 @@ config SERIAL_QE
 
 config SERIAL_SC26XX
 	tristate "SC2681/SC2692 serial port support"
-	depends on SNI_RM
+	depends on SNI_RM && TTY
 	select SERIAL_CORE
 	help
 	  This is a driver for the onboard serial ports of
@@ -1106,7 +1106,7 @@ config SERIAL_SC26XX_CONSOLE
 
 config SERIAL_BFIN_SPORT
 	tristate "Blackfin SPORT emulate UART"
-	depends on BLACKFIN
+	depends on BLACKFIN && TTY
 	select SERIAL_CORE
 	help
 	  Enable SPORT emulate UART on Blackfin series.
@@ -1169,14 +1169,15 @@ config SERIAL_BFIN_SPORT3_UART_CTSRTS
 
 config SERIAL_TIMBERDALE
 	tristate "Support for timberdale UART"
+	depends on TTY
 	select SERIAL_CORE
 	---help---
 	Add support for UART controller on timberdale.
 
 config SERIAL_BCM63XX
 	tristate "bcm63xx serial port support"
+	depends on BCM63XX && TTY
 	select SERIAL_CORE
-	depends on BCM63XX
 	help
 	  If you have a bcm63xx CPU, you can enable its onboard
 	  serial port by enabling this options.
@@ -1194,7 +1195,7 @@ config SERIAL_BCM63XX_CONSOLE
 
 config SERIAL_GRLIB_GAISLER_APBUART
 	tristate "GRLIB APBUART serial support"
-	depends on OF && SPARC
+	depends on OF && SPARC && TTY
 	select SERIAL_CORE
 	---help---
 	Add support for the GRLIB APBUART serial port.
@@ -1208,6 +1209,7 @@ config SERIAL_GRLIB_GAISLER_APBUART_CONSOLE
 
 config SERIAL_ALTERA_JTAGUART
 	tristate "Altera JTAG UART support"
+	depends on TTY
 	select SERIAL_CORE
 	help
 	  This driver supports the Altera JTAG UART port.
@@ -1229,6 +1231,7 @@ config SERIAL_ALTERA_JTAGUART_CONSOLE_BYPASS
 
 config SERIAL_ALTERA_UART
 	tristate "Altera UART support"
+	depends on TTY
 	select SERIAL_CORE
 	help
 	  This driver supports the Altera softcore UART port.
@@ -1260,13 +1263,13 @@ config SERIAL_ALTERA_UART_CONSOLE
 
 config SERIAL_IFX6X60
         tristate "SPI protocol driver for Infineon 6x60 modem (EXPERIMENTAL)"
-	depends on GPIOLIB && SPI && EXPERIMENTAL
+	depends on GPIOLIB && SPI && EXPERIMENTAL && TTY
 	help
 	  Support for the IFX6x60 modem devices on Intel MID platforms.
 
 config SERIAL_PCH_UART
 	tristate "Intel EG20T PCH/LAPIS Semicon IOH(ML7213/ML7223/ML7831) UART"
-	depends on PCI
+	depends on PCI && TTY
 	select SERIAL_CORE
 	help
 	  This driver is for PCH(Platform controller Hub) UART of Intel EG20T
@@ -1291,15 +1294,15 @@ config SERIAL_PCH_UART_CONSOLE
 
 config SERIAL_MSM_SMD
 	bool "Enable tty device interface for some SMD ports"
+	depends on MSM_SMD && TTY
 	default n
-	depends on MSM_SMD
 	help
 	  Enables userspace clients to read and write to some streaming SMD
 	  ports via tty device interface for MSM chipset.
 
 config SERIAL_MXS_AUART
-	depends on ARCH_MXS
 	tristate "MXS AUART support"
+	depends on ARCH_MXS && TTY
 	select SERIAL_CORE
 	help
 	  This driver supports the MXS Application UART (AUART) port.
@@ -1313,6 +1316,7 @@ config SERIAL_MXS_AUART_CONSOLE
 
 config SERIAL_XILINX_PS_UART
 	tristate "Xilinx PS UART support"
+	depends on TTY
 	select SERIAL_CORE
 	help
 	  This driver supports the Xilinx PS UART port.
@@ -1326,7 +1330,7 @@ config SERIAL_XILINX_PS_UART_CONSOLE
 
 config SERIAL_AR933X
 	bool "AR933X serial port support"
-	depends on SOC_AR933X
+	depends on SOC_AR933X && TTY
 	select SERIAL_CORE
 	help
 	  If you have an Atheros AR933X SOC based board and want to use the
diff --git a/drivers/usb/class/Kconfig b/drivers/usb/class/Kconfig
index 2519e32..316aac8 100644
--- a/drivers/usb/class/Kconfig
+++ b/drivers/usb/class/Kconfig
@@ -6,7 +6,7 @@ comment "USB Device Class drivers"
 
 config USB_ACM
 	tristate "USB Modem (CDC ACM) support"
-	depends on USB
+	depends on USB && TTY
 	---help---
 	  This driver supports USB modems and ISDN adapters which support the
 	  Communication Device Class Abstract Control Model interface.
diff --git a/drivers/usb/serial/Kconfig b/drivers/usb/serial/Kconfig
index 677f577..4a8e075 100644
--- a/drivers/usb/serial/Kconfig
+++ b/drivers/usb/serial/Kconfig
@@ -4,7 +4,7 @@
 
 menuconfig USB_SERIAL
 	tristate "USB Serial Converter support"
-	depends on USB
+	depends on USB && TTY
 	---help---
 	  Say Y here if you have a USB device that provides normal serial
 	  ports, or acts like a serial device, and you want to connect it to
diff --git a/fs/proc/Makefile b/fs/proc/Makefile
index c1c7293..a634e15 100644
--- a/fs/proc/Makefile
+++ b/fs/proc/Makefile
@@ -7,8 +7,8 @@ obj-y   += proc.o
 proc-y			:= nommu.o task_nommu.o
 proc-$(CONFIG_MMU)	:= mmu.o task_mmu.o
 
-proc-y       += inode.o root.o base.o generic.o array.o \
-		proc_tty.o
+proc-y       += inode.o root.o base.o generic.o array.o
+proc-$(CONFIG_TTY)	+= proc_tty.o
 proc-y	+= cmdline.o
 proc-y	+= consoles.o
 proc-y	+= cpuinfo.o
diff --git a/include/linux/console.h b/include/linux/console.h
index 7201ce4..84efbf7 100644
--- a/include/linux/console.h
+++ b/include/linux/console.h
@@ -151,7 +151,12 @@ extern int is_console_locked(void);
 extern int braille_register_console(struct console *, int index,
 		char *console_options, char *braille_options);
 extern int braille_unregister_console(struct console *);
+#ifdef CONFIG_TTY
 extern void console_sysfs_notify(void);
+#else
+static inline void console_sysfs_notify(void)
+{ }
+#endif
 extern bool console_suspend_enabled;
 
 /* Suspend and resume console messages over PM events */
diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index 85c5073..d82e473 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -123,7 +123,12 @@ extern void pid_ns_release_proc(struct pid_namespace *ns);
  * proc_tty.c
  */
 struct tty_driver;
+#ifdef CONFIG_TTY
 extern void proc_tty_init(void);
+#else
+static inline void proc_tty_init(void)
+{ }
+#endif
 extern void proc_tty_register_driver(struct tty_driver *driver);
 extern void proc_tty_unregister_driver(struct tty_driver *driver);
 
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 5dbb3cb..c1406e3 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -377,7 +377,12 @@ extern void tty_write_flush(struct tty_struct *);
 
 extern struct ktermios tty_std_termios;
 
+#ifdef CONFIG_TTY
 extern void console_init(void);
+#else
+static inline void console_init(void)
+{ }
+#endif
 extern int vcs_init(void);
 
 extern struct class *tty_class;
@@ -397,7 +402,12 @@ static inline struct tty_struct *tty_kref_get(struct tty_struct *tty)
 		kref_get(&tty->kref);
 	return tty;
 }
+#ifdef CONFIG_TTY
 extern void tty_kref_put(struct tty_struct *tty);
+#else
+static inline void tty_kref_put(struct tty_struct *tty)
+{ }
+#endif
 
 extern int tty_paranoia_check(struct tty_struct *tty, struct inode *inode,
 			      const char *routine);
@@ -426,18 +436,33 @@ extern void tty_driver_remove_tty(struct tty_driver *driver,
 extern void tty_shutdown(struct tty_struct *tty);
 extern void tty_free_termios(struct tty_struct *tty);
 extern int is_current_pgrp_orphaned(void);
+#ifdef CONFIG_TTY
 extern struct pid *tty_get_pgrp(struct tty_struct *tty);
+#else
+static inline struct pid *tty_get_pgrp(struct tty_struct *tty)
+{ return NULL; }
+#endif
 extern int is_ignored(int sig);
 extern int tty_signal(int sig, struct tty_struct *tty);
 extern void tty_hangup(struct tty_struct *tty);
 extern void tty_vhangup(struct tty_struct *tty);
 extern void tty_vhangup_locked(struct tty_struct *tty);
+#ifdef CONFIG_TTY
 extern void tty_vhangup_self(void);
+#else
+static inline void tty_vhangup_self(void)
+{ }
+#endif
 extern void tty_unhangup(struct file *filp);
 extern int tty_hung_up_p(struct file *filp);
 extern void do_SAK(struct tty_struct *tty);
 extern void __do_SAK(struct tty_struct *tty);
+#ifdef CONFIG_TTY
 extern void disassociate_ctty(int priv);
+#else
+static inline void disassociate_ctty(int priv)
+{ }
+#endif
 extern void no_tty(void);
 extern void tty_flip_buffer_push(struct tty_struct *tty);
 extern void tty_flush_to_ldisc(struct tty_struct *tty);
@@ -468,9 +493,18 @@ extern long tty_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
 extern int tty_mode_ioctl(struct tty_struct *tty, struct file *file,
 			unsigned int cmd, unsigned long arg);
 extern int tty_perform_flush(struct tty_struct *tty, unsigned long arg);
+#ifdef CONFIG_TTY
 extern dev_t tty_devnum(struct tty_struct *tty);
 extern void proc_clear_tty(struct task_struct *p);
 extern struct tty_struct *get_current_tty(void);
+#else
+static inline dev_t tty_devnum(struct tty_struct *tty)
+{ return 0; }
+static inline void proc_clear_tty(struct task_struct *p)
+{ }
+static inline struct tty_struct *get_current_tty(void)
+{ return NULL; }
+#endif
 extern void tty_default_fops(struct file_operations *fops);
 extern struct tty_struct *alloc_tty_struct(void);
 extern int tty_alloc_file(struct file *file);
@@ -578,7 +612,12 @@ static inline int tty_audit_push_task(struct task_struct *tsk,
 #endif
 
 /* tty_io.c */
+#ifdef CONFIG_TTY
 extern int __init tty_init(void);
+#else
+static inline int __init tty_init(void)
+{ return 0; }
+#endif
 
 /* tty_ioctl.c */
 extern int n_tty_ioctl_helper(struct tty_struct *tty, struct file *file,
diff --git a/lib/Kconfig.kgdb b/lib/Kconfig.kgdb
index 43cb93f..30894fa 100644
--- a/lib/Kconfig.kgdb
+++ b/lib/Kconfig.kgdb
@@ -22,6 +22,7 @@ config KGDB_SERIAL_CONSOLE
 	tristate "KGDB: use kgdb over the serial console"
 	select CONSOLE_POLL
 	select MAGIC_SYSRQ
+	depends on TTY
 	default y
 	help
 	  Share a serial console with kgdb. Sysrq-g must be used
diff --git a/net/bluetooth/rfcomm/Kconfig b/net/bluetooth/rfcomm/Kconfig
index 22e718b..18d352e 100644
--- a/net/bluetooth/rfcomm/Kconfig
+++ b/net/bluetooth/rfcomm/Kconfig
@@ -12,6 +12,7 @@ config BT_RFCOMM
 config BT_RFCOMM_TTY
 	bool "RFCOMM TTY support"
 	depends on BT_RFCOMM
+	depends on TTY
 	help
 	  This option enables TTY emulation support for RFCOMM channels.
 
diff --git a/net/irda/ircomm/Kconfig b/net/irda/ircomm/Kconfig
index 2d4c6b4..19492c1 100644
--- a/net/irda/ircomm/Kconfig
+++ b/net/irda/ircomm/Kconfig
@@ -1,6 +1,6 @@
 config IRCOMM
 	tristate "IrCOMM protocol"
-	depends on IRDA
+	depends on IRDA && TTY
 	help
 	  Say Y here if you want to build support for the IrCOMM protocol.
 	  To compile it as modules, choose M here: the modules will be
diff --git a/sound/soc/codecs/Kconfig b/sound/soc/codecs/Kconfig
index 7c205e7..125587a1 100644
--- a/sound/soc/codecs/Kconfig
+++ b/sound/soc/codecs/Kconfig
@@ -32,7 +32,7 @@ config SND_SOC_ALL_CODECS
 	select SND_SOC_CS42L73 if I2C
 	select SND_SOC_CS4270 if I2C
 	select SND_SOC_CS4271 if SND_SOC_I2C_AND_SPI
-	select SND_SOC_CX20442
+	select SND_SOC_CX20442 if TTY
 	select SND_SOC_DA7210 if I2C
 	select SND_SOC_DFBMCS320
 	select SND_SOC_JZ4740_CODEC
@@ -199,6 +199,7 @@ config SND_SOC_CS4271
 
 config SND_SOC_CX20442
 	tristate
+	depends on TTY
 
 config SND_SOC_JZ4740_CODEC
 	tristate
-- 
1.7.9.5

