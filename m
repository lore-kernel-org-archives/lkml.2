Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754289Ab2D2Qn3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 12:43:29 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:53203 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754222Ab2D2QnR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 12:43:17 -0400
Message-ID: <1335717794.12022.19.camel@joe2Laptop>
Subject: Re: [PATCH EDACv16 1/2] edac: Change internal representation to
 work with layers
From: Joe Perches <joe@perches.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Borislav Petkov <bp@amd64.org>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aristeu Rozanski <arozansk@redhat.com>,
        Doug Thompson <norsk5@yahoo.com>
Date: Sun, 29 Apr 2012 09:43:14 -0700
In-Reply-To: <4F9D6A39.6040209@redhat.com>
References: <1335289087-11337-1-git-send-email-mchehab@redhat.com>
	 <1335291342-14922-1-git-send-email-mchehab@redhat.com>
	 <20120427133304.GE9626@aftab.osrc.amd.com>
	 <1335535895.25521.7.camel@joe2Laptop> <4F9AC44A.5000509@redhat.com>
	 <20120428085223.GB26065@aftab.osrc.amd.com> <4F9D4F6E.4070106@redhat.com>
	 <4F9D5A2E.2030506@redhat.com> <4F9D6A39.6040209@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-04-29 at 13:20 -0300, Mauro Carvalho Chehab wrote:
> The script below is even better. After that, only 113 occurrences of __func__
> is now found at drivers/edac, and some of them are not related to debugf[1-9],
> so they shouldn't be cover on a patch like that.
> I'll do some manual cleanup on it.

Hi Mauro.

Another thing you could do would be to
separate the level from the multiple macros,
use a single macro, and convert the uses.

#define debugf(level, fmt, ...)
and change the uses to
debugf([0-n], "some format", args...)

I believe that's the more predominate
kernel style for debugging macros with
a tested level or mask.

Perhaps also add !CONFIG_EDAC_DEBUG
format/args checking to the debug statements.

Lastly, indenting the messages 2 tabs isn't
really useful, one or two spaces is probably
enough.

I did this a bit ago so it may not apply
after your changes:

commit 42f8f2d6fad6b62ab1d122c68984f4afd8a243f7
Author: Joe Perches <joe@perches.com>
Date:   Sat Apr 28 12:41:46 2012 -0700

edac: Use more normal debugging macro style

Convert macros to a simpler style and enforce appropriate
format checking when not CONFIG_EDAC_DEBUG.

Use fmt and __VA_ARGS__, neaten macros.

Move some string arrays to the debugfx uses and remove the
now unnecessary CONFIG_EDAC_DEBUG variable block definitions.

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/drivers/edac/edac_core.h b/drivers/edac/edac_core.h
index e48ab31..6198181 100644
--- a/drivers/edac/edac_core.h
+++ b/drivers/edac/edac_core.h
@@ -71,29 +71,30 @@ extern const char *edac_mem_types[];
 #ifdef CONFIG_EDAC_DEBUG
 extern int edac_debug_level;
 
-#define edac_debug_printk(level, fmt, arg...)                           \
-	do {                                                            \
-		if (level <= edac_debug_level)                          \
-			edac_printk(KERN_DEBUG, EDAC_DEBUG,		\
-				    "%s: " fmt, __func__, ##arg);	\
-	} while (0)
-
-#define debugf0( ... ) edac_debug_printk(0, __VA_ARGS__ )
-#define debugf1( ... ) edac_debug_printk(1, __VA_ARGS__ )
-#define debugf2( ... ) edac_debug_printk(2, __VA_ARGS__ )
-#define debugf3( ... ) edac_debug_printk(3, __VA_ARGS__ )
-#define debugf4( ... ) edac_debug_printk(4, __VA_ARGS__ )
+#define edac_debug_printk(level, fmt, ...)				\
+do {									\
+	if (level <= edac_debug_level)					\
+		edac_printk(KERN_DEBUG, EDAC_DEBUG,			\
+			    "%s: " fmt, __func__, ##__VA_ARGS__);	\
+} while (0)
 
 #else				/* !CONFIG_EDAC_DEBUG */
 
-#define debugf0( ... )
-#define debugf1( ... )
-#define debugf2( ... )
-#define debugf3( ... )
-#define debugf4( ... )
+#define edac_debug_printk(level, fmt, ...)				\
+do {									\
+	if (0)								\
+		edac_printk(KERN_DEBUG, EDAC_DEBUG,			\
+			    "%s: " fmt, __func__, ##__VA_ARGS__);	\
+} while (0)
 
 #endif				/* !CONFIG_EDAC_DEBUG */
 
+#define debugf0(fmt, ...) edac_debug_printk(0, fmt, ##__VA_ARGS__)
+#define debugf1(fmt, ...) edac_debug_printk(1, fmt, ##__VA_ARGS__)
+#define debugf2(fmt, ...) edac_debug_printk(2, fmt, ##__VA_ARGS__)
+#define debugf3(fmt, ...) edac_debug_printk(3, fmt, ##__VA_ARGS__)
+#define debugf4(fmt, ...) edac_debug_printk(4, fmt, ##__VA_ARGS__)
+
 #define PCI_VEND_DEV(vend, dev) PCI_VENDOR_ID_ ## vend, \
 	PCI_DEVICE_ID_ ## vend ## _ ## dev
 
diff --git a/drivers/edac/i5000_edac.c b/drivers/edac/i5000_edac.c
index a2680d8..1745a38 100644
--- a/drivers/edac/i5000_edac.c
+++ b/drivers/edac/i5000_edac.c
@@ -272,7 +272,7 @@
 #define NUM_MTRS		4
 #define CHANNELS_PER_BRANCH	(2)
 
-/* Defines to extract the vaious fields from the
+/* Defines to extract the various fields from the
  *	MTRx - Memory Technology Registers
  */
 #define MTR_DIMMS_PRESENT(mtr)		((mtr) & (0x1 << 8))
@@ -286,22 +286,6 @@
 #define MTR_DIMM_COLS(mtr)		((mtr) & 0x3)
 #define MTR_DIMM_COLS_ADDR_BITS(mtr)	(MTR_DIMM_COLS(mtr) + 10)
 
-#ifdef CONFIG_EDAC_DEBUG
-static char *numrow_toString[] = {
-	"8,192 - 13 rows",
-	"16,384 - 14 rows",
-	"32,768 - 15 rows",
-	"reserved"
-};
-
-static char *numcol_toString[] = {
-	"1,024 - 10 columns",
-	"2,048 - 11 columns",
-	"4,096 - 12 columns",
-	"reserved"
-};
-#endif
-
 /* enables the report of miscellaneous messages as CE errors - default off */
 static int misc_messages;
 
@@ -984,8 +968,16 @@ static void decode_mtr(int slot_row, u16 mtr)
 	debugf2("\t\tWIDTH: x%d\n", MTR_DRAM_WIDTH(mtr));
 	debugf2("\t\tNUMBANK: %d bank(s)\n", MTR_DRAM_BANKS(mtr));
 	debugf2("\t\tNUMRANK: %s\n", MTR_DIMM_RANK(mtr) ? "double" : "single");
-	debugf2("\t\tNUMROW: %s\n", numrow_toString[MTR_DIMM_ROWS(mtr)]);
-	debugf2("\t\tNUMCOL: %s\n", numcol_toString[MTR_DIMM_COLS(mtr)]);
+	debugf2("\t\tNUMROW: %s\n",
+		MTR_DIMM_ROWS(mtr) == 0 ? "8,192 - 13 rows" :
+		MTR_DIMM_ROWS(mtr) == 1 ? "16,384 - 14 rows" :
+		MTR_DIMM_ROWS(mtr) == 2 ? "32,768 - 15 rows" :
+		"reserved");
+	debugf2("\t\tNUMCOL: %s\n",
+		MTR_DIMM_COLS(mtr) == 0 ? "1,024 - 10 columns" :
+		MTR_DIMM_COLS(mtr) == 1 ? "2,048 - 11 columns" :
+		MTR_DIMM_COLS(mtr) == 2 ? "4,096 - 12 columns" :
+		"reserved");
 }
 
 static void handle_channel(struct i5000_pvt *pvt, int csrow, int channel,
diff --git a/drivers/edac/i5400_edac.c b/drivers/edac/i5400_edac.c
index 1869a10..4d17641 100644
--- a/drivers/edac/i5400_edac.c
+++ b/drivers/edac/i5400_edac.c
@@ -298,24 +298,6 @@ static inline int extract_fbdchan_indx(u32 x)
 	return (x>>28) & 0x3;
 }
 
-#ifdef CONFIG_EDAC_DEBUG
-/* MTR NUMROW */
-static const char *numrow_toString[] = {
-	"8,192 - 13 rows",
-	"16,384 - 14 rows",
-	"32,768 - 15 rows",
-	"65,536 - 16 rows"
-};
-
-/* MTR NUMCOL */
-static const char *numcol_toString[] = {
-	"1,024 - 10 columns",
-	"2,048 - 11 columns",
-	"4,096 - 12 columns",
-	"reserved"
-};
-#endif
-
 /* Device name and register DID (Device ID) */
 struct i5400_dev_info {
 	const char *ctl_name;	/* name for this device */
@@ -909,8 +891,16 @@ static void decode_mtr(int slot_row, u16 mtr)
 
 	debugf2("\t\tNUMBANK: %d bank(s)\n", MTR_DRAM_BANKS(mtr));
 	debugf2("\t\tNUMRANK: %s\n", MTR_DIMM_RANK(mtr) ? "double" : "single");
-	debugf2("\t\tNUMROW: %s\n", numrow_toString[MTR_DIMM_ROWS(mtr)]);
-	debugf2("\t\tNUMCOL: %s\n", numcol_toString[MTR_DIMM_COLS(mtr)]);
+	debugf2("\t\tNUMROW: %s\n",
+		MTR_DIMM_ROWS(mtr) == 0 ? "8,192 - 13 rows" :
+		MTR_DIMM_ROWS(mtr) == 1 ? "16,384 - 14 rows" :
+		MTR_DIMM_ROWS(mtr) == 2 ? "32,768 - 15 rows" :
+		"65,536 - 16 rows");
+	debugf2("\t\tNUMCOL: %s\n",
+		MTR_DIMM_COLS(mtr) == 0 ? "1,024 - 10 columns" :
+		MTR_DIMM_COLS(mtr) == 1 ? "2,048 - 11 columns" :
+		MTR_DIMM_COLS(mtr) == 2 ? "4,096 - 12 columns" :
+		"reserved");
 }
 
 static void handle_channel(struct i5400_pvt *pvt, int csrow, int channel,
diff --git a/drivers/edac/i7300_edac.c b/drivers/edac/i7300_edac.c
index 3bafa3b..9271da3 100644
--- a/drivers/edac/i7300_edac.c
+++ b/drivers/edac/i7300_edac.c
@@ -182,24 +182,6 @@ static const u16 mtr_regs[MAX_SLOTS] = {
 #define MTR_DIMM_COLS(mtr)		((mtr) & 0x3)
 #define MTR_DIMM_COLS_ADDR_BITS(mtr)	(MTR_DIMM_COLS(mtr) + 10)
 
-#ifdef CONFIG_EDAC_DEBUG
-/* MTR NUMROW */
-static const char *numrow_toString[] = {
-	"8,192 - 13 rows",
-	"16,384 - 14 rows",
-	"32,768 - 15 rows",
-	"65,536 - 16 rows"
-};
-
-/* MTR NUMCOL */
-static const char *numcol_toString[] = {
-	"1,024 - 10 columns",
-	"2,048 - 11 columns",
-	"4,096 - 12 columns",
-	"reserved"
-};
-#endif
-
 /************************************************
  * i7300 Register definitions for error detection
  ************************************************/
@@ -659,8 +641,16 @@ static int decode_mtr(struct i7300_pvt *pvt,
 
 	debugf2("\t\tNUMBANK: %d bank(s)\n", MTR_DRAM_BANKS(mtr));
 	debugf2("\t\tNUMRANK: %s\n", MTR_DIMM_RANKS(mtr) ? "double" : "single");
-	debugf2("\t\tNUMROW: %s\n", numrow_toString[MTR_DIMM_ROWS(mtr)]);
-	debugf2("\t\tNUMCOL: %s\n", numcol_toString[MTR_DIMM_COLS(mtr)]);
+	debugf2("\t\tNUMROW: %s\n",
+		MTR_DIMM_ROWS(mtr) == 0 ? "8,192 - 13 rows" :
+		MTR_DIMM_ROWS(mtr) == 1 ? "16,384 - 14 rows" :
+		MTR_DIMM_ROWS(mtr) == 2 ? "32,768 - 15 rows" :
+		"65,536 - 16 rows");
+	debugf2("\t\tNUMCOL: %s\n",
+		MTR_DIMM_COLS(mtr) == 0 ? "1,024 - 10 columns" :
+		MTR_DIMM_COLS(mtr) == 1 ? "2,048 - 11 columns" :
+		MTR_DIMM_COLS(mtr) == 2 ? "4,096 - 12 columns" :
+		"reserved");
 	debugf2("\t\tSIZE: %d MB\n", dinfo->megabytes);
 
 	p_csrow->grain = 8;



