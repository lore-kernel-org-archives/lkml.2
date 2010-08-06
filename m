Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965102Ab0HFT3V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 15:29:21 -0400
Received: from kroah.org ([198.145.64.141]:47515 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965608Ab0HFT2W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 15:28:22 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Aug  6 12:21:17 2010
Message-Id: <20100806192117.542411162@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 06 Aug 2010 12:20:15 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        =?ISO-8859-15?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [34/36] ssb: Look for SPROM at different offset on higher rev CC
In-Reply-To: <20100806192649.GA1614@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Rafał Miłecki <zajec5@gmail.com>

commit ea2db495f92ad2cf3301623e60cb95b4062bc484 upstream.

Our offset handling becomes even a little more hackish now. For some reason I
do not understand all offsets as inrelative. It assumes base offset is 0x1000
but it will work for now as we make offsets relative anyway by removing base
0x1000. Should be cleaner however.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 drivers/ssb/pci.c            |    9 ++++++---
 include/linux/ssb/ssb.h      |    1 +
 include/linux/ssb/ssb_regs.h |    3 ++-
 3 files changed, 9 insertions(+), 4 deletions(-)

--- a/drivers/ssb/pci.c
+++ b/drivers/ssb/pci.c
@@ -168,7 +168,7 @@ err_pci:
 }
 
 /* Get the word-offset for a SSB_SPROM_XXX define. */
-#define SPOFF(offset)	(((offset) - SSB_SPROM_BASE) / sizeof(u16))
+#define SPOFF(offset)	(((offset) - SSB_SPROM_BASE1) / sizeof(u16))
 /* Helper to extract some _offset, which is one of the SSB_SPROM_XXX defines. */
 #define SPEX16(_outvar, _offset, _mask, _shift)	\
 	out->_outvar = ((in[SPOFF(_offset)] & (_mask)) >> (_shift))
@@ -254,7 +254,7 @@ static int sprom_do_read(struct ssb_bus
 	int i;
 
 	for (i = 0; i < bus->sprom_size; i++)
-		sprom[i] = ioread16(bus->mmio + SSB_SPROM_BASE + (i * 2));
+		sprom[i] = ioread16(bus->mmio + bus->sprom_offset + (i * 2));
 
 	return 0;
 }
@@ -285,7 +285,7 @@ static int sprom_do_write(struct ssb_bus
 			ssb_printk("75%%");
 		else if (i % 2)
 			ssb_printk(".");
-		writew(sprom[i], bus->mmio + SSB_SPROM_BASE + (i * 2));
+		writew(sprom[i], bus->mmio + bus->sprom_offset + (i * 2));
 		mmiowb();
 		msleep(20);
 	}
@@ -626,6 +626,9 @@ static int ssb_pci_sprom_get(struct ssb_
 		return -ENODEV;
 	}
 
+	bus->sprom_offset = (bus->chipco.dev->id.revision < 31) ?
+		SSB_SPROM_BASE1 : SSB_SPROM_BASE31;
+
 	buf = kcalloc(SSB_SPROMSIZE_WORDS_R123, sizeof(u16), GFP_KERNEL);
 	if (!buf)
 		goto out;
--- a/include/linux/ssb/ssb.h
+++ b/include/linux/ssb/ssb.h
@@ -305,6 +305,7 @@ struct ssb_bus {
 	/* ID information about the Chip. */
 	u16 chip_id;
 	u16 chip_rev;
+	u16 sprom_offset;
 	u16 sprom_size;		/* number of words in sprom */
 	u8 chip_package;
 
--- a/include/linux/ssb/ssb_regs.h
+++ b/include/linux/ssb/ssb_regs.h
@@ -170,7 +170,8 @@
 #define SSB_SPROMSIZE_WORDS_R4		220
 #define SSB_SPROMSIZE_BYTES_R123	(SSB_SPROMSIZE_WORDS_R123 * sizeof(u16))
 #define SSB_SPROMSIZE_BYTES_R4		(SSB_SPROMSIZE_WORDS_R4 * sizeof(u16))
-#define SSB_SPROM_BASE			0x1000
+#define SSB_SPROM_BASE1			0x1000
+#define SSB_SPROM_BASE31		0x0800
 #define SSB_SPROM_REVISION		0x107E
 #define  SSB_SPROM_REVISION_REV		0x00FF	/* SPROM Revision number */
 #define  SSB_SPROM_REVISION_CRC		0xFF00	/* SPROM CRC8 value */


