Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475Ab0GMXGP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 19:06:15 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:54064 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714Ab0GMXGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 19:06:13 -0400
Subject: [RFC PATCH] Kconfig: Enable Kconfig fragments to be used for defconfig
To: linuxppc-dev@lists.ozlabs.org, Nicolas Pitre <nico@fluxnic.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Russell King <rmk@arm.linux.org.uk>
From: Grant Likely <grant.likely@secretlab.ca>
Cc: Tony Lindgren <tony@atomide.com>, Daniel Walker <dwalker@codeaurora.org>,
        Uwe =?utf-8?q?Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
Date: Tue, 13 Jul 2010 17:04:58 -0600
Message-ID: <20100713230352.6781.18644.stgit@angua>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a proof of concept at the moment, but if the corner cases
can be sorted out, then this might be the best way to replace
the defconfig functionality.  This patch implements Linus' idea
for using Kconfig fragments to replicate the *_defconfig functionality

Essentially, this patch adds a new <board>_defconfig target that is
processed if a <board>.Kconfig file is present in the $(ARCH)/configs
directory instead of the current <board>_defconfig file.  The target
works by passing the $(ARCH)/configs/<board>.Kconfig to Kconfig
instead of the architecture's default $(ARCH)/Kconfig file.

<board>.Kconfig defines new board specific config items (prefixed with
"generateconfig_" which default to 'y' or 'm' and select the options
that the platform cares about.  It also then either the architecture
default Kconfig, or another Kconfig fragment that includes the default
one (therefore the fragments can be 'stacked' to include, say, default
options for the architecture, or particular chipset).

This patch includes sample Kconfig fragments for the PowerPC 83xx and
5200 platforms to demonstrate the concept, but it should work in exactly
the same way for ARM or any other architecture.  With the sample,
'mpc5200_defconfig', 'mpc83xx_defconfig' and even 'ppc32_defconfig' are
all valid targets (although the ppc32_defconfig won't actually include
any particular board support).

An interesting side effect of this approach is that it can be used to
'overlay' the configuration for a board over top of the existing config.
I went ahead and added the %_oldconfig option to do this which could
be useful for building a kernel that supports multiple boards, or for
adding in a set of debug options.

Another advantage of this approach is that it doesn't immediately
eliminate the old defconfig files so that platforms can be migrated to
this new method one at a time.

Current problems:
- I haven't figured out a way for the fragment to force an option to
  be "n", or to set a value, for example "CONFIG_LOG_BUF_SHIFT=16".
  This may require changing the syntax.
- It still doesn't resolve dependencies.  A solver would help with this.
  For the time being I work around the problem by running the generated
  config through 'oldconfig' and looking for differences.  If the files
  differ (ignoring comments and generateconfig_* options) after oldconfig,
  then the <board>_defconfig target returns a failure.  (but leaves the
  new .config intact so the user can resolve it with menuconfig).  This
  way at least the user is told when a Kconfig fragment is invalid.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 arch/powerpc/configs/mpc5200.Kconfig |   24 +++++++++++++++++++++
 arch/powerpc/configs/mpc83xx.Kconfig |   35 +++++++++++++++++++++++++++++++
 arch/powerpc/configs/ppc32.Kconfig   |   39 ++++++++++++++++++++++++++++++++++
 scripts/kconfig/Makefile             |   18 +++++++++++++++-
 4 files changed, 115 insertions(+), 1 deletions(-)
 create mode 100644 arch/powerpc/configs/mpc5200.Kconfig
 create mode 100644 arch/powerpc/configs/mpc83xx.Kconfig
 create mode 100644 arch/powerpc/configs/ppc32.Kconfig

diff --git a/arch/powerpc/configs/mpc5200.Kconfig b/arch/powerpc/configs/mpc5200.Kconfig
new file mode 100644
index 0000000..1281dd1
--- /dev/null
+++ b/arch/powerpc/configs/mpc5200.Kconfig
@@ -0,0 +1,24 @@
+config generateconfig_MPC5200_YES
+	def_bool y
+	select PPC_MPC52xx
+	select PPC_MPC5200_SIMPLE
+	select PPC_EFIKA
+	select PPC_LITE5200
+	select PPC_MEDIA5200
+	select PPC_MPC5200_BUGFIX
+	select PPC_MPC5200_GPIO
+	select PPC_MPC5200_LPBFIFO
+	select PPC_BESTCOMM
+	select SIMPLE_GPIO
+	select SERIAL_MPC52xx
+	select SERIAL_MPC52xx_CONSOLE
+	select MTD
+	select PATA_MPC52xx
+	select SPI_MPC52xx
+	select SPI_MPC52xx_PSC
+	select I2C_MPC
+	select FEC_MPC52xx
+	select LXT_PHY
+	select WATCHDOG
+
+source arch/powerpc/configs/ppc32.Kconfig
diff --git a/arch/powerpc/configs/mpc83xx.Kconfig b/arch/powerpc/configs/mpc83xx.Kconfig
new file mode 100644
index 0000000..818fdec
--- /dev/null
+++ b/arch/powerpc/configs/mpc83xx.Kconfig
@@ -0,0 +1,35 @@
+config generateconfig_MPC83xx_YES
+	def_bool y
+	select PPC_83xx
+	select EMBEDDED
+	select MPC831x_RDB
+	select MPC832x_MDS
+	select MPC832x_RDB
+	select MPC834x_MDS
+	select MPC834x_ITX
+	select MPC836x_MDS
+	select MPC836x_RDK
+	select MPC837x_MDS
+	select MPC837x_RDB
+	select SBC834x
+	select ASP834x
+	select QUICC_ENGINE
+	select OE_GPIO
+	select MATH_EMULATION
+	select SATA_FSL
+	select SATA_SIL
+	select MARVELL_PHY
+	select DAVICOM_PHY
+	select VITESSE_PHY
+	select ICPLUS_PHY
+	select FIXED_PHY
+	select FSL_PQ_MDIO
+	select GIANFAR
+	select UCC_GETH
+	select SERIAL_8250
+	select SERIAL_8250_CONSOLE
+	select I2C_MPC
+	select GPIOLIB
+	select WATCHDOG
+
+source arch/powerpc/configs/ppc32.Kconfig
diff --git a/arch/powerpc/configs/ppc32.Kconfig b/arch/powerpc/configs/ppc32.Kconfig
new file mode 100644
index 0000000..66e39f0
--- /dev/null
+++ b/arch/powerpc/configs/ppc32.Kconfig
@@ -0,0 +1,39 @@
+config generateconfig_PPC32_YES
+	def_bool y
+	select EXPERIMENTAL
+	select DEVTMPFS
+	select PPC32
+	select SYSVIPC
+	select BLK_DEV_INITRD
+	select NO_HZ
+	select HIGH_RES_TIMERS
+	select GPIO
+	select SPI
+	select SPI_SPIDEV
+	select I2C
+	select I2C_CHARDEV
+	select USB
+	select NET
+	select SCSI
+	select BLK_DEV_SD
+	select ATA
+	select PACKET
+	select UNIX
+	select INET
+	select IP_MULTICAST
+	select IP_PNP
+	select IP_PNP_DHCP
+	select NETDEVICES
+	select NET_ETHERNET
+	select PROC_DEVICETREE
+	select INOTIFY
+	select TMPFS
+	select NFS_FS
+	select ROOT_NFS
+	select PRINTK_TIME
+
+config generateconfig_PPC32_MODULE
+	def_tristate m
+
+source arch/powerpc/Kconfig
+
diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
index 7ea649d..4e9afd9 100644
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -117,7 +117,23 @@ else
 	$(Q)$< -D arch/$(SRCARCH)/configs/$(KBUILD_DEFCONFIG) $(Kconfig)
 endif
 
-%_defconfig: $(obj)/conf
+# New-style defconfig using Kconfig fragments
+%_defconfig: $(obj)/conf arch/$(SRCARCH)/configs/%.Kconfig
+	$(Q)$< -D /dev/null arch/$(SRCARCH)/configs/$*.Kconfig
+	$(Q)sed '/^#/d;/^CONFIG_generateconfig_/d' $(objtree)/.config > $(objtree)/.config-diff1
+	$(Q)$< -o $(Kconfig) > /dev/null # oldconfig test to make sure it doesn't change
+	$(Q)sed '/^#/d' $(objtree)/.config > $(objtree)/.config-diff2
+	$(Q)diff -u $(objtree)/.config-diff1 $(objtree)/.config-diff2
+
+# This is kind of useful.  The new-style defconfig using Kconfig fragments
+# can also be used to successively pull in the options a defconfig cares
+# about overtop of the current config.
+%_oldconfig: $(obj)/conf arch/$(SRCARCH)/configs/%.Kconfig
+	$(Q)$< -o arch/$(SRCARCH)/configs/$*.Kconfig
+	$(Q)$< -o $(Kconfig) > /dev/null # oldconfig to clear out the temporary items
+
+# Old-style defconfig using full (or trimmed) .config files.
+%_defconfig: $(obj)/conf arch/$(SRCARCH)/configs/%_defconfig
 	$(Q)$< -D arch/$(SRCARCH)/configs/$@ $(Kconfig)
 
 # Help text used by make help

