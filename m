Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756237Ab1FPQRv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 12:17:51 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:36470 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754697Ab1FPQRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 12:17:47 -0400
From: Alexander Holler <holler@ahsoftware.de>
To: gregkh@suse.de
Cc: Rabin Vincent <rabin@rab.in>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Arnd Bergmann <arnd@arndb.de>, Alexander Holler <holler@ahsoftware.de>
Subject: [PATCH] USB: ehci: use packed,aligned(4) instead of removing the packed attribute
Date: Thu, 16 Jun 2011 18:17:10 +0200
Message-Id: <1308241030-15201-1-git-send-email-holler@ahsoftware.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1303918648-7196-1-git-send-email-rabin@rab.in>
References: <1303918648-7196-1-git-send-email-rabin@rab.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In commit 139540170d9d9b7ead3caaf540f161756b356d56 the attribute
packed is removed from the structs which are used to access the EHCI-registers.

This is done to circumvent a problem with gcc 4.6, which might access members of
packed structs on a byte by byte basis. But using packed, aligned(4) fixes that
too and is imho the better solution. Otherwise (without packed) the compiler would be free
to choose whatever alignment he thinks fits best, which might be e.g. 8-byte on 64-bit machines.

Signed-off-by: Alexander Holler <holler@ahsoftware.de>
---
 include/linux/usb/ehci_def.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/usb/ehci_def.h b/include/linux/usb/ehci_def.h
index 7cc95ee..15c87a9 100644
--- a/include/linux/usb/ehci_def.h
+++ b/include/linux/usb/ehci_def.h
@@ -57,7 +57,7 @@ struct ehci_caps {
 #define HCC_PGM_FRAMELISTLEN(p) ((p)&(1 << 1))  /* true: periodic_size changes*/
 #define HCC_64BIT_ADDR(p)       ((p)&(1))       /* true: can use 64-bit addr */
 	u8		portroute[8];	 /* nibbles for routing - offset 0xC */
-};
+} __attribute__ ((packed, aligned(4)));
 
 
 /* Section 2.3 Host Controller Operational Registers */
@@ -155,7 +155,7 @@ struct ehci_regs {
 #define PORT_CSC	(1<<1)		/* connect status change */
 #define PORT_CONNECT	(1<<0)		/* device connected */
 #define PORT_RWC_BITS   (PORT_CSC | PORT_PEC | PORT_OCC)
-};
+} __attribute__ ((packed, aligned(4)));
 
 #define USBMODE		0x68		/* USB Device mode */
 #define USBMODE_SDIS	(1<<3)		/* Stream disable */
@@ -199,7 +199,7 @@ struct ehci_dbg_port {
 	u32	data47;
 	u32	address;
 #define DBGP_EPADDR(dev, ep)	(((dev)<<8)|(ep))
-};
+} __attribute__ ((packed, aligned(4)));
 
 #ifdef CONFIG_EARLY_PRINTK_DBGP
 #include <linux/init.h>
-- 
1.7.3.4

