Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234Ab2KNGKD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 01:10:03 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54926 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751988Ab2KNFt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 00:49:58 -0500
Message-Id: <20121114053933.935584768@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 14 Nov 2012 05:39:34 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ulisses Furquim <ulisses@profusion.mobi>,
        Marcel Holtmann <marcel@holtmann.org>,
        "Gustavo F. Padovan" <padovan@profusion.mobi>
Subject: [ 01/82] Bluetooth: Always compile SCO and L2CAP in Bluetooth Core
In-Reply-To: <20121114053933.726869752@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ulisses Furquim <ulisses@profusion.mobi>

commit f1e91e1640d808d332498a6b09b2bcd01462eff9 upstream.

The handling of SCO audio links and the L2CAP protocol are essential to
any system with Bluetooth thus are always compiled in from now on.

Signed-off-by: Ulisses Furquim <ulisses@profusion.mobi>
Acked-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Gustavo F. Padovan <padovan@profusion.mobi>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/net/bluetooth/bluetooth.h |   22 ----------------------
 net/bluetooth/Kconfig             |   37 +++++++++----------------------------
 net/bluetooth/Makefile            |    5 ++---
 net/bluetooth/bnep/Kconfig        |    2 +-
 net/bluetooth/cmtp/Kconfig        |    2 +-
 net/bluetooth/hidp/Kconfig        |    2 +-
 net/bluetooth/rfcomm/Kconfig      |    2 +-
 7 files changed, 15 insertions(+), 57 deletions(-)

diff --git a/include/net/bluetooth/bluetooth.h b/include/net/bluetooth/bluetooth.h
index 980e59f..abaad6e 100644
--- a/include/net/bluetooth/bluetooth.h
+++ b/include/net/bluetooth/bluetooth.h
@@ -250,32 +250,10 @@ extern void bt_sysfs_cleanup(void);
 
 extern struct dentry *bt_debugfs;
 
-#ifdef CONFIG_BT_L2CAP
 int l2cap_init(void);
 void l2cap_exit(void);
-#else
-static inline int l2cap_init(void)
-{
-	return 0;
-}
-
-static inline void l2cap_exit(void)
-{
-}
-#endif
 
-#ifdef CONFIG_BT_SCO
 int sco_init(void);
 void sco_exit(void);
-#else
-static inline int sco_init(void)
-{
-	return 0;
-}
-
-static inline void sco_exit(void)
-{
-}
-#endif
 
 #endif /* __BLUETOOTH_H */
diff --git a/net/bluetooth/Kconfig b/net/bluetooth/Kconfig
index bfb3dc0..9ec85eb 100644
--- a/net/bluetooth/Kconfig
+++ b/net/bluetooth/Kconfig
@@ -6,7 +6,11 @@ menuconfig BT
 	tristate "Bluetooth subsystem support"
 	depends on NET && !S390
 	depends on RFKILL || !RFKILL
+	select CRC16
 	select CRYPTO
+	select CRYPTO_BLKCIPHER
+	select CRYPTO_AES
+	select CRYPTO_ECB
 	help
 	  Bluetooth is low-cost, low-power, short-range wireless technology.
 	  It was designed as a replacement for cables and other short-range
@@ -15,10 +19,12 @@ menuconfig BT
 	  Bluetooth can be found at <http://www.bluetooth.com/>.
 
 	  Linux Bluetooth subsystem consist of several layers:
-	     Bluetooth Core (HCI device and connection manager, scheduler)
+	     Bluetooth Core
+		HCI device and connection manager, scheduler
+		SCO audio links
+		L2CAP (Logical Link Control and Adaptation Protocol)
+		SMP (Security Manager Protocol) on LE (Low Energy) links
 	     HCI Device drivers (Interface to the hardware)
-	     SCO Module (SCO audio links)
-	     L2CAP Module (Logical Link Control and Adaptation Protocol)
 	     RFCOMM Module (RFCOMM Protocol)  
 	     BNEP Module (Bluetooth Network Encapsulation Protocol)
 	     CMTP Module (CAPI Message Transport Protocol)
@@ -33,31 +39,6 @@ menuconfig BT
 	  to Bluetooth kernel modules are provided in the BlueZ packages.  For
 	  more information, see <http://www.bluez.org/>.
 
-if BT != n
-
-config BT_L2CAP
-	bool "L2CAP protocol support"
-	select CRC16
-	select CRYPTO
-	select CRYPTO_BLKCIPHER
-	select CRYPTO_AES
-	select CRYPTO_ECB
-	help
-	  L2CAP (Logical Link Control and Adaptation Protocol) provides
-	  connection oriented and connection-less data transport.  L2CAP
-	  support is required for most Bluetooth applications.
-
-	  Also included is support for SMP (Security Manager Protocol) which
-	  is the security layer on top of LE (Low Energy) links.
-
-config BT_SCO
-	bool "SCO links support"
-	help
-	  SCO link provides voice transport over Bluetooth.  SCO support is
-	  required for voice applications like Headset and Audio.
-
-endif
-
 source "net/bluetooth/rfcomm/Kconfig"
 
 source "net/bluetooth/bnep/Kconfig"
diff --git a/net/bluetooth/Makefile b/net/bluetooth/Makefile
index 9b67f3d..2dc5a57 100644
--- a/net/bluetooth/Makefile
+++ b/net/bluetooth/Makefile
@@ -8,6 +8,5 @@ obj-$(CONFIG_BT_BNEP)	+= bnep/
 obj-$(CONFIG_BT_CMTP)	+= cmtp/
 obj-$(CONFIG_BT_HIDP)	+= hidp/
 
-bluetooth-y := af_bluetooth.o hci_core.o hci_conn.o hci_event.o mgmt.o hci_sock.o hci_sysfs.o lib.o
-bluetooth-$(CONFIG_BT_L2CAP)	+= l2cap_core.o l2cap_sock.o smp.o
-bluetooth-$(CONFIG_BT_SCO)	+= sco.o
+bluetooth-y := af_bluetooth.o hci_core.o hci_conn.o hci_event.o mgmt.o \
+	hci_sock.o hci_sysfs.o l2cap_core.o l2cap_sock.o smp.o sco.o lib.o
diff --git a/net/bluetooth/bnep/Kconfig b/net/bluetooth/bnep/Kconfig
index 35158b0..71791fc 100644
--- a/net/bluetooth/bnep/Kconfig
+++ b/net/bluetooth/bnep/Kconfig
@@ -1,6 +1,6 @@
 config BT_BNEP
 	tristate "BNEP protocol support"
-	depends on BT && BT_L2CAP
+	depends on BT
 	select CRC32
 	help
 	  BNEP (Bluetooth Network Encapsulation Protocol) is Ethernet
diff --git a/net/bluetooth/cmtp/Kconfig b/net/bluetooth/cmtp/Kconfig
index d6b0382..94cbf42 100644
--- a/net/bluetooth/cmtp/Kconfig
+++ b/net/bluetooth/cmtp/Kconfig
@@ -1,6 +1,6 @@
 config BT_CMTP
 	tristate "CMTP protocol support"
-	depends on BT && BT_L2CAP && ISDN_CAPI
+	depends on BT && ISDN_CAPI
 	help
 	  CMTP (CAPI Message Transport Protocol) is a transport layer
 	  for CAPI messages.  CMTP is required for the Bluetooth Common
diff --git a/net/bluetooth/hidp/Kconfig b/net/bluetooth/hidp/Kconfig
index 86a9154..4deaca7 100644
--- a/net/bluetooth/hidp/Kconfig
+++ b/net/bluetooth/hidp/Kconfig
@@ -1,6 +1,6 @@
 config BT_HIDP
 	tristate "HIDP protocol support"
-	depends on BT && BT_L2CAP && INPUT && HID_SUPPORT
+	depends on BT && INPUT && HID_SUPPORT
 	select HID
 	help
 	  HIDP (Human Interface Device Protocol) is a transport layer
diff --git a/net/bluetooth/rfcomm/Kconfig b/net/bluetooth/rfcomm/Kconfig
index 405a0e6..22e718b 100644
--- a/net/bluetooth/rfcomm/Kconfig
+++ b/net/bluetooth/rfcomm/Kconfig
@@ -1,6 +1,6 @@
 config BT_RFCOMM
 	tristate "RFCOMM protocol support"
-	depends on BT && BT_L2CAP
+	depends on BT
 	help
 	  RFCOMM provides connection oriented stream transport.  RFCOMM
 	  support is required for Dialup Networking, OBEX and other Bluetooth


