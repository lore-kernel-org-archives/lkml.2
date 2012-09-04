Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932822Ab2IDW3f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 18:29:35 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:43485 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932695Ab2IDW3d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 18:29:33 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-13.tower-160.messagelabs.com!1346797771!7781788!2
X-Originating-IP: [216.166.12.31]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.3; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] staging: comedi: addi_amcc_S5920.[ch]: remove unnecessary files
Date: Tue, 4 Sep 2012 15:29:28 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-ID: <201209041529.28748.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The addi_amcc_S5920.c file only has the function i_AddiHeaderRW_ReadEeprom()
in it. The addi_amcc_S5920.h file has a prototype for this function and a
couple defines for the magic numbers used when accessing the eeprom.

The .c file is not actually built by any .config selection, or by an

The .h file is only #include'd by the hwdrv_apci3200.c file. That file
actually has a local version of the i_AddiHeaderRW_ReadEeprom() function
that is identical to the one in the .c file.

Just move the #define's from the .h file into hwdrv_apci3200.c and remove
the addi_amcc_S5920.[ch] files.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 .../comedi/drivers/addi-data/addi_amcc_S5920.c     | 195 ---------------------
 .../comedi/drivers/addi-data/addi_amcc_S5920.h     |  27 ---
 .../comedi/drivers/addi-data/hwdrv_apci3200.c      |  12 +-
 3 files changed, 7 insertions(+), 227 deletions(-)
 delete mode 100644 drivers/staging/comedi/drivers/addi-data/addi_amcc_S5920.c
 delete mode 100644 drivers/staging/comedi/drivers/addi-data/addi_amcc_S5920.h

diff --git a/drivers/staging/comedi/drivers/addi-data/addi_amcc_S5920.c b/drivers/staging/comedi/drivers/addi-data/addi_amcc_S5920.c
deleted file mode 100644
index b973095..0000000
--- a/drivers/staging/comedi/drivers/addi-data/addi_amcc_S5920.c
+++ /dev/null
@@ -1,195 +0,0 @@
-/**
-@verbatim
-
-Copyright (C) 2004,2005  ADDI-DATA GmbH for the source code of this module.
-
-	ADDI-DATA GmbH
-	Dieselstrasse 3
-	D-77833 Ottersweier
-	Tel: +19(0)7223/9493-0
-	Fax: +49(0)7223/9493-92
-	http://www.addi-data.com
-	info@addi-data.com
-
-This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.
-
-This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
-
-You should have received a copy of the GNU General Public License along with this program; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
-
-You should also find the complete GPL in the COPYING file accompanying this source code.
-
-@endverbatim
-*/
-/*
-  +-----------------------------------------------------------------------+
-  | (C) ADDI-DATA GmbH          Dieselstraße 3       D-77833 Ottersweier  |
-  +-----------------------------------------------------------------------+
-  | Tel : +49 (0) 7223/9493-0     | email    : info@addi-data.com         |
-  | Fax : +49 (0) 7223/9493-92    | Internet : http://www.addi-data.com   |
-  +-------------------------------+---------------------------------------+
-  | Project : ADDI HEADER READ WRITER |     Compiler   : Visual C++       |
-  | Module name : S5920.cpp           |     Version    : 6.0              |
-  +-------------------------------+---------------------------------------+
-  | Author : E. LIBS                      Date : 02/05/2002               |
-  +-----------------------------------------------------------------------+
-  | Description   : DLL with the S5920 PCI Controller functions           |
-  +-----------------------------------------------------------------------+
-  |                             UPDATE'S                                  |
-  +-----------------------------------------------------------------------+
-  |   Date   |   Author  |          Description of updates                |
-  +----------+-----------+------------------------------------------------+
-  | 28/08/02 | LIBS Eric | Add return codes each time a function of the   |
-  |          |           | Addi Library is called                         |
-  +-----------------------------------------------------------------------+
-  | 31/07/03 | KRAUTH J. | Changes for the MSX-Box                        |
-  +-----------------------------------------------------------------------+
-*/
-
-#include "addi_amcc_S5920.h"
-
-/*+----------------------------------------------------------------------------+*/
-/*| Function   Name   : int i_AddiHeaderRW_ReadEeprom                          |*/
-/*|                               (int    i_NbOfWordsToRead,                   |*/
-/*|                                unsigned int dw_PCIBoardEepromAddress,             |*/
-/*|                                unsigned short   w_EepromStartAddress,                |*/
-/*|                                unsigned short * pw_DataRead)                          |*/
-/*+----------------------------------------------------------------------------+*/
-/*| Task              : Read word from the 5920 eeprom.                        |*/
-/*+----------------------------------------------------------------------------+*/
-/*| Input Parameters  : int    i_NbOfWordsToRead : Nbr. of word to read        |*/
-/*|                     unsigned int dw_PCIBoardEepromAddress : Address of the eeprom |*/
-/*|                     unsigned short   w_EepromStartAddress : Eeprom start address     |*/
-/*+----------------------------------------------------------------------------+*/
-/*| Output Parameters : unsigned short * pw_DataRead : Read data                          |*/
-/*+----------------------------------------------------------------------------+*/
-/*| Return Value      : -                                                      |*/
-/*+----------------------------------------------------------------------------+*/
-
-int i_AddiHeaderRW_ReadEeprom(int i_NbOfWordsToRead,
-	unsigned int dw_PCIBoardEepromAddress,
-	unsigned short w_EepromStartAddress, unsigned short *pw_DataRead)
-{
-	unsigned int dw_eeprom_busy = 0;
-	int i_Counter = 0;
-	int i_WordCounter;
-	int i;
-	unsigned char pb_ReadByte[1];
-	unsigned char b_ReadLowByte = 0;
-	unsigned char b_ReadHighByte = 0;
-	unsigned char b_SelectedAddressLow = 0;
-	unsigned char b_SelectedAddressHigh = 0;
-	unsigned short w_ReadWord = 0;
-
-	for (i_WordCounter = 0; i_WordCounter < i_NbOfWordsToRead;
-		i_WordCounter++) {
-		do {
-			dw_eeprom_busy =
-				inl(dw_PCIBoardEepromAddress +
-				AMCC_OP_REG_MCSR);
-			dw_eeprom_busy = dw_eeprom_busy & EEPROM_BUSY;
-		} while (dw_eeprom_busy == EEPROM_BUSY);
-
-		for (i_Counter = 0; i_Counter < 2; i_Counter++) {
-			b_SelectedAddressLow = (w_EepromStartAddress + i_Counter) % 256;	/* Read the low 8 bit part */
-			b_SelectedAddressHigh = (w_EepromStartAddress + i_Counter) / 256;	/* Read the high 8 bit part */
-
-			/* Select the load low address mode */
-			outb(NVCMD_LOAD_LOW,
-				dw_PCIBoardEepromAddress + AMCC_OP_REG_MCSR +
-				3);
-
-			/* Wait on busy */
-			do {
-				dw_eeprom_busy =
-					inl(dw_PCIBoardEepromAddress +
-					AMCC_OP_REG_MCSR);
-				dw_eeprom_busy = dw_eeprom_busy & EEPROM_BUSY;
-			} while (dw_eeprom_busy == EEPROM_BUSY);
-
-			/* Load the low address */
-			outb(b_SelectedAddressLow,
-				dw_PCIBoardEepromAddress + AMCC_OP_REG_MCSR +
-				2);
-
-			/* Wait on busy */
-			do {
-				dw_eeprom_busy =
-					inl(dw_PCIBoardEepromAddress +
-					AMCC_OP_REG_MCSR);
-				dw_eeprom_busy = dw_eeprom_busy & EEPROM_BUSY;
-			} while (dw_eeprom_busy == EEPROM_BUSY);
-
-			/* Select the load high address mode */
-			outb(NVCMD_LOAD_HIGH,
-				dw_PCIBoardEepromAddress + AMCC_OP_REG_MCSR +
-				3);
-
-			/* Wait on busy */
-			do {
-				dw_eeprom_busy =
-					inl(dw_PCIBoardEepromAddress +
-					AMCC_OP_REG_MCSR);
-				dw_eeprom_busy = dw_eeprom_busy & EEPROM_BUSY;
-			} while (dw_eeprom_busy == EEPROM_BUSY);
-
-			/* Load the high address */
-			outb(b_SelectedAddressHigh,
-				dw_PCIBoardEepromAddress + AMCC_OP_REG_MCSR +
-				2);
-
-			/* Wait on busy */
-			do {
-				dw_eeprom_busy =
-					inl(dw_PCIBoardEepromAddress +
-					AMCC_OP_REG_MCSR);
-				dw_eeprom_busy = dw_eeprom_busy & EEPROM_BUSY;
-			} while (dw_eeprom_busy == EEPROM_BUSY);
-
-			/* Select the READ mode */
-			outb(NVCMD_BEGIN_READ,
-				dw_PCIBoardEepromAddress + AMCC_OP_REG_MCSR +
-				3);
-
-			/* Wait on busy */
-			do {
-				dw_eeprom_busy =
-					inl(dw_PCIBoardEepromAddress +
-					AMCC_OP_REG_MCSR);
-				dw_eeprom_busy = dw_eeprom_busy & EEPROM_BUSY;
-			} while (dw_eeprom_busy == EEPROM_BUSY);
-
-			/* Read data into the EEPROM */
-			*pb_ReadByte =
-				inb(dw_PCIBoardEepromAddress +
-				AMCC_OP_REG_MCSR + 2);
-
-			/* Wait on busy */
-			do {
-				dw_eeprom_busy =
-					inl(dw_PCIBoardEepromAddress +
-					AMCC_OP_REG_MCSR);
-				dw_eeprom_busy = dw_eeprom_busy & EEPROM_BUSY;
-			} while (dw_eeprom_busy == EEPROM_BUSY);
-
-			/* Select the upper address part */
-			if (i_Counter == 0)
-				b_ReadLowByte = pb_ReadByte[0];
-			else
-				b_ReadHighByte = pb_ReadByte[0];
-
-			/* Sleep */
-			msleep(1);
-
-		}
-		w_ReadWord =
-			(b_ReadLowByte | (((unsigned short)b_ReadHighByte) *
-				256));
-
-		pw_DataRead[i_WordCounter] = w_ReadWord;
-
-		w_EepromStartAddress += 2;	/*  to read the next word */
-
-	}			/*  for (...) i_NbOfWordsToRead */
-	return 0;
-}
diff --git a/drivers/staging/comedi/drivers/addi-data/addi_amcc_S5920.h b/drivers/staging/comedi/drivers/addi-data/addi_amcc_S5920.h
deleted file mode 100644
index 9afdb13..0000000
--- a/drivers/staging/comedi/drivers/addi-data/addi_amcc_S5920.h
+++ /dev/null
@@ -1,27 +0,0 @@
-/*
- *  Copyright (C) 2004,2005  ADDI-DATA GmbH for the source code of this module.
- *
- *	ADDI-DATA GmbH
- *	Dieselstrasse 3
- *	D-77833 Ottersweier
- *	Tel: +19(0)7223/9493-0
- *	Fax: +49(0)7223/9493-92
- *	http://www.addi-data.com
- *	info@addi-data.com
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by the Free
- * Software Foundation; either version 2 of the License, or (at your option)
- * any later version.
- */
-
-#define AMCC_OP_REG_MCSR	0x3c
-#define EEPROM_BUSY		0x80000000
-#define NVCMD_LOAD_LOW		(0x4 << 5)	/* nvRam load low command */
-#define NVCMD_LOAD_HIGH		(0x5 << 5)	/* nvRam load high command */
-#define NVCMD_BEGIN_READ	(0x7 << 5)	/* nvRam begin read command */
-#define NVCMD_BEGIN_WRITE	(0x6 << 5)	/* EEPROM begin write command */
-
-int i_AddiHeaderRW_ReadEeprom(int i_NbOfWordsToRead,
-			      unsigned int dw_PCIBoardEepromAddress,
-			      unsigned short w_EepromStartAddress, unsigned short *pw_DataRead);
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3200.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3200.c
index f9545b0..5aed4a1 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3200.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3200.c
@@ -57,11 +57,8 @@ You should also find the complete GPL in the COPYING file accompanying this sour
   +----------------------------------------------------------------------------+
 */
 #include "hwdrv_apci3200.h"
-/* Begin JK 21.10.2004: APCI-3200 / APCI-3300 Reading of EEPROM values */
-#include "addi_amcc_S5920.h"
-/* #define PRINT_INFO */
 
-/* End JK 21.10.2004: APCI-3200 / APCI-3300 Reading of EEPROM values */
+/* #define PRINT_INFO */
 
 /* BEGIN JK 06.07.04: Management of sevrals boards */
 /*
@@ -90,7 +87,12 @@ You should also find the complete GPL in the COPYING file accompanying this sour
 struct str_BoardInfos s_BoardInfos[100];	/*  100 will be the max number of boards to be used */
 /* END JK 06.07.04: Management of sevrals boards */
 
-/* Begin JK 21.10.2004: APCI-3200 / APCI-3300 Reading of EEPROM values */
+#define AMCC_OP_REG_MCSR	0x3c
+#define EEPROM_BUSY		0x80000000
+#define NVCMD_LOAD_LOW		(0x4 << 5)	/* nvRam load low command */
+#define NVCMD_LOAD_HIGH		(0x5 << 5)	/* nvRam load high command */
+#define NVCMD_BEGIN_READ	(0x7 << 5)	/* nvRam begin read command */
+#define NVCMD_BEGIN_WRITE	(0x6 << 5)	/* EEPROM begin write command */
 
 /*+----------------------------------------------------------------------------+*/
 /*| Function   Name   : int i_AddiHeaderRW_ReadEeprom                          |*/
-- 
1.7.11

