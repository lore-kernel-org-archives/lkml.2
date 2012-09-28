Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423331Ab2I1VcV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 17:32:21 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47839 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032624Ab2I1U17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:27:59 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Gertjan van Wingerde <gwingerde@gmail.com>,
        Ivo Van Doorn <ivdoorn@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 119/218] rt2x00: Fix rfkill polling prior to interface start.
Date: Fri, 28 Sep 2012 13:15:36 -0700
Message-Id: <20120928201515.139493990@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928201501.208384923@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gertjan van Wingerde <gwingerde@gmail.com>

commit a396e10019eaf3809b0219c966865aaafec12630 upstream.

We need to program the rfkill switch GPIO pin direction to input at
device initialization time, not only when the interface is brought up.
Doing this only when the interface is brought up could lead to rfkill
detecting the switch is turned on erroneously and inability to create
the interface and bringing it up.

Reported-and-tested-by: Andreas Messer <andi@bastelmap.de>
Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
Acked-by: Ivo Van Doorn <ivdoorn@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/rt2x00/rt2400pci.c |    9 +++++++++
 drivers/net/wireless/rt2x00/rt2400pci.h |    1 +
 drivers/net/wireless/rt2x00/rt2500pci.c |    9 +++++++++
 drivers/net/wireless/rt2x00/rt2500usb.c |    9 +++++++++
 drivers/net/wireless/rt2x00/rt2500usb.h |    1 +
 drivers/net/wireless/rt2x00/rt2800pci.c |    9 +++++++++
 drivers/net/wireless/rt2x00/rt2800usb.c |    9 +++++++++
 drivers/net/wireless/rt2x00/rt61pci.c   |    9 +++++++++
 drivers/net/wireless/rt2x00/rt61pci.h   |    1 +
 drivers/net/wireless/rt2x00/rt73usb.c   |    9 +++++++++
 drivers/net/wireless/rt2x00/rt73usb.h   |    3 +++
 11 files changed, 69 insertions(+)

--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -1611,6 +1611,7 @@ static int rt2400pci_probe_hw_mode(struc
 static int rt2400pci_probe_hw(struct rt2x00_dev *rt2x00dev)
 {
 	int retval;
+	u32 reg;
 
 	/*
 	 * Allocate eeprom data.
@@ -1624,6 +1625,14 @@ static int rt2400pci_probe_hw(struct rt2
 		return retval;
 
 	/*
+	 * Enable rfkill polling by setting GPIO direction of the
+	 * rfkill switch GPIO pin correctly.
+	 */
+	rt2x00pci_register_read(rt2x00dev, GPIOCSR, &reg);
+	rt2x00_set_field32(&reg, GPIOCSR_BIT8, 1);
+	rt2x00pci_register_write(rt2x00dev, GPIOCSR, reg);
+
+	/*
 	 * Initialize hw specifications.
 	 */
 	retval = rt2400pci_probe_hw_mode(rt2x00dev);
--- a/drivers/net/wireless/rt2x00/rt2400pci.h
+++ b/drivers/net/wireless/rt2x00/rt2400pci.h
@@ -670,6 +670,7 @@
 #define GPIOCSR_BIT5			FIELD32(0x00000020)
 #define GPIOCSR_BIT6			FIELD32(0x00000040)
 #define GPIOCSR_BIT7			FIELD32(0x00000080)
+#define GPIOCSR_BIT8			FIELD32(0x00000100)
 
 /*
  * BBPPCSR: BBP Pin control register.
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -1929,6 +1929,7 @@ static int rt2500pci_probe_hw_mode(struc
 static int rt2500pci_probe_hw(struct rt2x00_dev *rt2x00dev)
 {
 	int retval;
+	u32 reg;
 
 	/*
 	 * Allocate eeprom data.
@@ -1942,6 +1943,14 @@ static int rt2500pci_probe_hw(struct rt2
 		return retval;
 
 	/*
+	 * Enable rfkill polling by setting GPIO direction of the
+	 * rfkill switch GPIO pin correctly.
+	 */
+	rt2x00pci_register_read(rt2x00dev, GPIOCSR, &reg);
+	rt2x00_set_field32(&reg, GPIOCSR_DIR0, 1);
+	rt2x00pci_register_write(rt2x00dev, GPIOCSR, reg);
+
+	/*
 	 * Initialize hw specifications.
 	 */
 	retval = rt2500pci_probe_hw_mode(rt2x00dev);
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1768,6 +1768,7 @@ static int rt2500usb_probe_hw_mode(struc
 static int rt2500usb_probe_hw(struct rt2x00_dev *rt2x00dev)
 {
 	int retval;
+	u16 reg;
 
 	/*
 	 * Allocate eeprom data.
@@ -1781,6 +1782,14 @@ static int rt2500usb_probe_hw(struct rt2
 		return retval;
 
 	/*
+	 * Enable rfkill polling by setting GPIO direction of the
+	 * rfkill switch GPIO pin correctly.
+	 */
+	rt2500usb_register_read(rt2x00dev, MAC_CSR19, &reg);
+	rt2x00_set_field16(&reg, MAC_CSR19_BIT8, 0);
+	rt2500usb_register_write(rt2x00dev, MAC_CSR19, reg);
+
+	/*
 	 * Initialize hw specifications.
 	 */
 	retval = rt2500usb_probe_hw_mode(rt2x00dev);
--- a/drivers/net/wireless/rt2x00/rt2500usb.h
+++ b/drivers/net/wireless/rt2x00/rt2500usb.h
@@ -197,6 +197,7 @@
 #define MAC_CSR19_BIT5			FIELD16(0x0020)
 #define MAC_CSR19_BIT6			FIELD16(0x0040)
 #define MAC_CSR19_BIT7			FIELD16(0x0080)
+#define MAC_CSR19_BIT8			FIELD16(0x0100)
 
 /*
  * MAC_CSR20: LED control register.
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -973,6 +973,7 @@ static int rt2800pci_validate_eeprom(str
 static int rt2800pci_probe_hw(struct rt2x00_dev *rt2x00dev)
 {
 	int retval;
+	u32 reg;
 
 	/*
 	 * Allocate eeprom data.
@@ -986,6 +987,14 @@ static int rt2800pci_probe_hw(struct rt2
 		return retval;
 
 	/*
+	 * Enable rfkill polling by setting GPIO direction of the
+	 * rfkill switch GPIO pin correctly.
+	 */
+	rt2x00pci_register_read(rt2x00dev, GPIO_CTRL_CFG, &reg);
+	rt2x00_set_field32(&reg, GPIO_CTRL_CFG_GPIOD_BIT2, 1);
+	rt2x00pci_register_write(rt2x00dev, GPIO_CTRL_CFG, reg);
+
+	/*
 	 * Initialize hw specifications.
 	 */
 	retval = rt2800_probe_hw_mode(rt2x00dev);
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -736,6 +736,7 @@ static int rt2800usb_validate_eeprom(str
 static int rt2800usb_probe_hw(struct rt2x00_dev *rt2x00dev)
 {
 	int retval;
+	u32 reg;
 
 	/*
 	 * Allocate eeprom data.
@@ -749,6 +750,14 @@ static int rt2800usb_probe_hw(struct rt2
 		return retval;
 
 	/*
+	 * Enable rfkill polling by setting GPIO direction of the
+	 * rfkill switch GPIO pin correctly.
+	 */
+	rt2x00usb_register_read(rt2x00dev, GPIO_CTRL_CFG, &reg);
+	rt2x00_set_field32(&reg, GPIO_CTRL_CFG_GPIOD_BIT2, 1);
+	rt2x00usb_register_write(rt2x00dev, GPIO_CTRL_CFG, reg);
+
+	/*
 	 * Initialize hw specifications.
 	 */
 	retval = rt2800_probe_hw_mode(rt2x00dev);
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -2832,6 +2832,7 @@ static int rt61pci_probe_hw_mode(struct
 static int rt61pci_probe_hw(struct rt2x00_dev *rt2x00dev)
 {
 	int retval;
+	u32 reg;
 
 	/*
 	 * Disable power saving.
@@ -2850,6 +2851,14 @@ static int rt61pci_probe_hw(struct rt2x0
 		return retval;
 
 	/*
+	 * Enable rfkill polling by setting GPIO direction of the
+	 * rfkill switch GPIO pin correctly.
+	 */
+	rt2x00pci_register_read(rt2x00dev, MAC_CSR13, &reg);
+	rt2x00_set_field32(&reg, MAC_CSR13_BIT13, 1);
+	rt2x00pci_register_write(rt2x00dev, MAC_CSR13, reg);
+
+	/*
 	 * Initialize hw specifications.
 	 */
 	retval = rt61pci_probe_hw_mode(rt2x00dev);
--- a/drivers/net/wireless/rt2x00/rt61pci.h
+++ b/drivers/net/wireless/rt2x00/rt61pci.h
@@ -372,6 +372,7 @@ struct hw_pairwise_ta_entry {
 #define MAC_CSR13_BIT10			FIELD32(0x00000400)
 #define MAC_CSR13_BIT11			FIELD32(0x00000800)
 #define MAC_CSR13_BIT12			FIELD32(0x00001000)
+#define MAC_CSR13_BIT13			FIELD32(0x00002000)
 
 /*
  * MAC_CSR14: LED control register.
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -2177,6 +2177,7 @@ static int rt73usb_probe_hw_mode(struct
 static int rt73usb_probe_hw(struct rt2x00_dev *rt2x00dev)
 {
 	int retval;
+	u32 reg;
 
 	/*
 	 * Allocate eeprom data.
@@ -2190,6 +2191,14 @@ static int rt73usb_probe_hw(struct rt2x0
 		return retval;
 
 	/*
+	 * Enable rfkill polling by setting GPIO direction of the
+	 * rfkill switch GPIO pin correctly.
+	 */
+	rt2x00usb_register_read(rt2x00dev, MAC_CSR13, &reg);
+	rt2x00_set_field32(&reg, MAC_CSR13_BIT15, 0);
+	rt2x00usb_register_write(rt2x00dev, MAC_CSR13, reg);
+
+	/*
 	 * Initialize hw specifications.
 	 */
 	retval = rt73usb_probe_hw_mode(rt2x00dev);
--- a/drivers/net/wireless/rt2x00/rt73usb.h
+++ b/drivers/net/wireless/rt2x00/rt73usb.h
@@ -282,6 +282,9 @@ struct hw_pairwise_ta_entry {
 #define MAC_CSR13_BIT10			FIELD32(0x00000400)
 #define MAC_CSR13_BIT11			FIELD32(0x00000800)
 #define MAC_CSR13_BIT12			FIELD32(0x00001000)
+#define MAC_CSR13_BIT13			FIELD32(0x00002000)
+#define MAC_CSR13_BIT14			FIELD32(0x00004000)
+#define MAC_CSR13_BIT15			FIELD32(0x00008000)
 
 /*
  * MAC_CSR14: LED control register.


