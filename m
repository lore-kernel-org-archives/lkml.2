Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757616Ab1DMIIG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 04:08:06 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:62431 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757301Ab1DMIID convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 04:08:03 -0400
From: =?UTF-8?q?Andreas=20Bie=C3=9Fmann?= <biessmann@corscience.de>
To: kernel@avr32linux.org
Cc: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>,
        =?UTF-8?q?Andreas=20Bie=C3=9Fmann?= <biessmann@corscience.de>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH V2] avr32: add ATAG_BOARDINFO
Date: Wed, 13 Apr 2011 10:07:35 +0200
Message-Id: <1302682057-6244-1-git-send-email-biessmann@corscience.de>
X-Mailer: git-send-email 1.7.2.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Provags-ID: V02:K0:cOsd4HKs5S2/bJd3RUrBHb0fFvaNtpMtwdDGhdcHY/t
 4KriA2sRnAwJ4/QmHYrf/W0uyJs+nozOAv9Qb7iKazK3X3mUP0
 dZ+sd6JZoBGyKxWg4fpyNPQJZlf/ZnnGX81SB8tuD0l9CSeZ79
 Fgt/3vQXIPAHRfeoOMaHdmSIkqKg8vISh/+kSKj36zedRFCkXo
 zRJAG143g4Uzt12VnCCYA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ATAG_BOARDINFO is intended to hand over the information
bd->bi_board_number from u-boot to the kernel.

This piece of information can be used to implement some kind of board
identification while booting the kernel. Therefore it is placed in .initdata
section and can be accessed via the new symbol board_number only while
initializing the kernel.

Signed-off-by: Andreas Bießmann <biessmann@corscience.de>
---
Changes in V2:
 - add more detailed explenation
 - move u32 board_number from head of setup.c directely before usage
 - add explenation in front of u32 board_number declaration
 - add extern u32 board_number to setup.h

 arch/avr32/include/asm/setup.h |    9 +++++++++
 arch/avr32/kernel/setup.c      |   15 +++++++++++++++
 2 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/arch/avr32/include/asm/setup.h b/arch/avr32/include/asm/setup.h
index ff5b7cf..160543d 100644
--- a/arch/avr32/include/asm/setup.h
+++ b/arch/avr32/include/asm/setup.h
@@ -94,6 +94,13 @@ struct tag_ethernet {
 
 #define ETH_INVALID_PHY	0xff
 
+/* board information */
+#define ATAG_BOARDINFO	0x54410008
+
+struct tag_boardinfo {
+	u32	board_number;
+};
+
 struct tag {
 	struct tag_header hdr;
 	union {
@@ -102,6 +109,7 @@ struct tag {
 		struct tag_cmdline cmdline;
 		struct tag_clock clock;
 		struct tag_ethernet ethernet;
+		struct tag_boardinfo boardinfo;
 	} u;
 };
 
@@ -128,6 +136,7 @@ extern struct tag *bootloader_tags;
 
 extern resource_size_t fbmem_start;
 extern resource_size_t fbmem_size;
+extern u32 board_number;
 
 void setup_processor(void);
 
diff --git a/arch/avr32/kernel/setup.c b/arch/avr32/kernel/setup.c
index 5c70839..bb0974c 100644
--- a/arch/avr32/kernel/setup.c
+++ b/arch/avr32/kernel/setup.c
@@ -391,6 +391,21 @@ static int __init parse_tag_clock(struct tag *tag)
 __tagtable(ATAG_CLOCK, parse_tag_clock);
 
 /*
+ * The board_number correspond to the bd->bi_board_number in U-Boot. This
+ * parameter is only available during initialisation and can be used in some
+ * kind of board identification.
+ */
+u32 __initdata board_number;
+
+static int __init parse_tag_boardinfo(struct tag *tag)
+{
+	board_number = tag->u.boardinfo.board_number;
+
+	return 0;
+}
+__tagtable(ATAG_BOARDINFO, parse_tag_boardinfo);
+
+/*
  * Scan the tag table for this tag, and call its parse function. The
  * tag table is built by the linker from all the __tagtable
  * declarations.
-- 
1.7.2.5

