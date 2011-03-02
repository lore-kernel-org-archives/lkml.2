Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072Ab1CBXtP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 18:49:15 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:57902 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755926Ab1CBXtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 18:49:13 -0500
X-Authenticated: #41721828
X-Provags-ID: V01U2FsdGVkX182godKt582AnnUHT1TrV2t7iCXWotx8y18Lv4kyF
	HPUTN50fq+Axsr
From: =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>
To: Greg Kroah-Hartman <gregkh@suse.de>, Al Cho <acho@novell.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>
Subject: [PATCH 2/2] staging: keucr: use kernel byteorder functions
Date: Thu,  3 Mar 2011 00:48:14 +0100
Message-Id: <1299109694-28758-2-git-send-email-j.neuschaefer@gmx.net>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1299109694-28758-1-git-send-email-j.neuschaefer@gmx.net>
References: <1299109694-28758-1-git-send-email-j.neuschaefer@gmx.net>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 drivers/staging/keucr/TODO     |    1 -
 drivers/staging/keucr/common.h |   12 ------------
 drivers/staging/keucr/ms.c     |   28 +++++++++++++++-------------
 3 files changed, 15 insertions(+), 26 deletions(-)

diff --git a/drivers/staging/keucr/TODO b/drivers/staging/keucr/TODO
index 179b7fe..1c48e40 100644
--- a/drivers/staging/keucr/TODO
+++ b/drivers/staging/keucr/TODO
@@ -6,7 +6,6 @@ TODO:
 	  be merged into the drivers/usb/storage/ directory and
 	  infrastructure instead.
 	- review by the USB developer community
-	- common.h: use kernel swap, le, & be functions
 	- smcommon.h & smilsub.c: use kernel hweight8(), hweight16()
 
 Please send any patches for this driver to Al Cho <acho@novell.com> and
diff --git a/drivers/staging/keucr/common.h b/drivers/staging/keucr/common.h
index f2be045..b87dc7a 100644
--- a/drivers/staging/keucr/common.h
+++ b/drivers/staging/keucr/common.h
@@ -9,17 +9,5 @@ typedef u16 *PWORD;
 typedef u32 DWORD;
 typedef u32 *PDWORD;
 
-#define swapWORD(w)	((((unsigned short)(w) << 8) & 0xff00) |	\
-			 (((unsigned short)(w) >> 8) & 0x00ff))
-#define swapDWORD(dw)	((((unsigned long)(dw) << 24) & 0xff000000) |	\
-			 (((unsigned long)(dw) <<  8) & 0x00ff0000) |	\
-			 (((unsigned long)(dw) >>  8) & 0x0000ff00) |	\
-			 (((unsigned long)(dw) >> 24) & 0x000000ff))
-
-#define LittleEndianWORD(w)	(w)
-#define LittleEndianDWORD(dw)	(dw)
-#define BigEndianWORD(w)	swapWORD(w)
-#define BigEndianDWORD(dw)	swapDWORD(dw)
-
 #endif
 
diff --git a/drivers/staging/keucr/ms.c b/drivers/staging/keucr/ms.c
index 452ea8f..e33b7e3 100644
--- a/drivers/staging/keucr/ms.c
+++ b/drivers/staging/keucr/ms.c
@@ -1,4 +1,6 @@
 #include <linux/slab.h>
+#include <asm/byteorder.h>
+
 #include "usb.h"
 #include "scsiglue.h"
 #include "transport.h"
@@ -166,8 +168,8 @@ int MS_CardInit(struct us_data *us)
 			continue;
 
 		if (((extdat.mngflg & MS_REG_MNG_SYSFLG) == MS_REG_MNG_SYSFLG_USER) ||
-			(BigEndianWORD(((MemStickBootBlockPage0 *)PageBuffer0)->header.wBlockID) != MS_BOOT_BLOCK_ID) ||
-			(BigEndianWORD(((MemStickBootBlockPage0 *)PageBuffer0)->header.wFormatVersion) != MS_BOOT_BLOCK_FORMAT_VERSION) ||
+			(be16_to_cpu(((MemStickBootBlockPage0 *)PageBuffer0)->header.wBlockID) != MS_BOOT_BLOCK_ID) ||
+			(be16_to_cpu(((MemStickBootBlockPage0 *)PageBuffer0)->header.wFormatVersion) != MS_BOOT_BLOCK_FORMAT_VERSION) ||
 			(((MemStickBootBlockPage0 *)PageBuffer0)->header.bNumberOfDataEntry != MS_BOOT_BLOCK_DATA_ENTRIES))
 				continue;
 
@@ -266,7 +268,7 @@ int MS_LibCheckDisableBlock(struct us_data *us, WORD PhyBlock)
 	MS_ReaderReadPage(us, PhyBlock, 1, (DWORD *)PageBuf, &extdat);
 	do
 	{
-		blk = BigEndianWORD(PageBuf[index]);
+		blk = be16_to_cpu(PageBuf[index]);
 		if (blk == MS_LB_NOT_USED)
 			break;
 		if (blk == us->MS_Lib.Log2PhyMap[0])
@@ -355,7 +357,7 @@ int MS_LibProcessBootBlock(struct us_data *us, WORD PhyBlock, BYTE *PageData)
 	SysInfo= &(((MemStickBootBlockPage0 *)PageData)->sysinf);
 
 	if ((SysInfo->bMsClass != MS_SYSINF_MSCLASS_TYPE_1)                                   ||
-		(BigEndianWORD(SysInfo->wPageSize) != MS_SYSINF_PAGE_SIZE)                       ||
+		(be16_to_cpu(SysInfo->wPageSize) != MS_SYSINF_PAGE_SIZE)                       ||
 		((SysInfo->bSecuritySupport & MS_SYSINF_SECURITY) == MS_SYSINF_SECURITY_SUPPORT) ||
 		(SysInfo->bReserved1 != MS_SYSINF_RESERVED1)                                     ||
 		(SysInfo->bReserved2 != MS_SYSINF_RESERVED2)                                     ||
@@ -376,12 +378,12 @@ int MS_LibProcessBootBlock(struct us_data *us, WORD PhyBlock, BYTE *PageData)
 			goto exit;
 	}
 
-	us->MS_Lib.blockSize        = BigEndianWORD(SysInfo->wBlockSize);
-	us->MS_Lib.NumberOfPhyBlock = BigEndianWORD(SysInfo->wBlockNumber);
-	us->MS_Lib.NumberOfLogBlock = BigEndianWORD(SysInfo->wTotalBlockNumber)- 2;
+	us->MS_Lib.blockSize        = be16_to_cpu(SysInfo->wBlockSize);
+	us->MS_Lib.NumberOfPhyBlock = be16_to_cpu(SysInfo->wBlockNumber);
+	us->MS_Lib.NumberOfLogBlock = be16_to_cpu(SysInfo->wTotalBlockNumber) - 2;
 	us->MS_Lib.PagesPerBlock    = us->MS_Lib.blockSize * SIZE_OF_KIRO / MS_BYTES_PER_PAGE;
 	us->MS_Lib.NumberOfSegment  = us->MS_Lib.NumberOfPhyBlock / MS_PHYSICAL_BLOCKS_PER_SEGMENT;
-	us->MS_Model                = BigEndianWORD(SysInfo->wMemorySize);
+	us->MS_Model                = be16_to_cpu(SysInfo->wMemorySize);
 
 	if (MS_LibAllocLogicalMap(us))			//Allocate to all number of logicalblock and physicalblock
 		goto exit;
@@ -394,10 +396,10 @@ int MS_LibProcessBootBlock(struct us_data *us, WORD PhyBlock, BYTE *PageData)
 	{
 		DWORD  EntryOffset, EntrySize;
 
-		if ((EntryOffset = BigEndianDWORD(SysEntry->entry[i].dwStart)) == 0xffffff)
+		if ((EntryOffset = be32_to_cpu(SysEntry->entry[i].dwStart)) == 0xffffff)
 			continue;
 
-		if ((EntrySize = BigEndianDWORD(SysEntry->entry[i].dwSize)) == 0)
+		if ((EntrySize = be32_to_cpu(SysEntry->entry[i].dwSize)) == 0)
 			continue;
 
 		if (EntryOffset + MS_BYTES_PER_PAGE + EntrySize > us->MS_Lib.blockSize * (DWORD)SIZE_OF_KIRO)
@@ -429,7 +431,7 @@ int MS_LibProcessBootBlock(struct us_data *us, WORD PhyBlock, BYTE *PageData)
 					PrevPageNumber = PageNumber;
 				}
 
-				if ((phyblk = BigEndianWORD(*(WORD *)(PageBuffer + (EntryOffset % MS_BYTES_PER_PAGE)))) < 0x0fff)
+				if ((phyblk = be16_to_cpu(*(WORD *)(PageBuffer + (EntryOffset % MS_BYTES_PER_PAGE)))) < 0x0fff)
 					MS_LibSetInitialErrorBlock(us, phyblk);
 
 				EntryOffset += 2;
@@ -455,10 +457,10 @@ int MS_LibProcessBootBlock(struct us_data *us, WORD PhyBlock, BYTE *PageData)
 			}
 
 			idi = &((MemStickBootBlockCIS_IDI *)(PageBuffer + (EntryOffset % MS_BYTES_PER_PAGE)))->idi.idi;
-			if (LittleEndianWORD(idi->wIDIgeneralConfiguration) != MS_IDI_GENERAL_CONF)
+			if (le16_to_cpu(idi->wIDIgeneralConfiguration) != MS_IDI_GENERAL_CONF)
 				goto exit;
 
-			us->MS_Lib.BytesPerSector = LittleEndianWORD(idi->wIDIbytesPerSector);
+			us->MS_Lib.BytesPerSector = be16_to_cpu(idi->wIDIbytesPerSector);
 			if (us->MS_Lib.BytesPerSector != MS_BYTES_PER_PAGE)
 				goto exit;
 		}
-- 
1.7.4.1

