Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965712Ab0HFT33 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 15:29:29 -0400
Received: from kroah.org ([198.145.64.141]:47520 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965616Ab0HFT2X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 15:28:23 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Aug  6 12:21:17 2010
Message-Id: <20100806192117.626052439@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 06 Aug 2010 12:20:16 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Christoph Fritz <chf.fritz@googlemail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [35/36] ssb: fix NULL ptr deref when pcihost_wrapper is used
In-Reply-To: <20100806192649.GA1614@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Christoph Fritz <chf.fritz@googlemail.com>

commit da1fdb02d9200ff28b6f3a380d21930335fe5429 upstream.

Ethernet driver b44 does register ssb by it's pcihost_wrapper
and doesn't set ssb_chipcommon. A check on this value
introduced with commit d53cdbb94a52a920d5420ed64d986c3523a56743
and ea2db495f92ad2cf3301623e60cb95b4062bc484 triggers:

BUG: unable to handle kernel NULL pointer dereference at 00000010
IP: [<c1266c36>] ssb_is_sprom_available+0x16/0x30

Signed-off-by: Christoph Fritz <chf.fritz@googlemail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ssb/pci.c   |    9 ++++++---
 drivers/ssb/sprom.c |    1 +
 2 files changed, 7 insertions(+), 3 deletions(-)

--- a/drivers/ssb/pci.c
+++ b/drivers/ssb/pci.c
@@ -625,9 +625,12 @@ static int ssb_pci_sprom_get(struct ssb_
 		ssb_printk(KERN_ERR PFX "No SPROM available!\n");
 		return -ENODEV;
 	}
-
-	bus->sprom_offset = (bus->chipco.dev->id.revision < 31) ?
-		SSB_SPROM_BASE1 : SSB_SPROM_BASE31;
+	if (bus->chipco.dev) {	/* can be unavailible! */
+		bus->sprom_offset = (bus->chipco.dev->id.revision < 31) ?
+			SSB_SPROM_BASE1 : SSB_SPROM_BASE31;
+	} else {
+		bus->sprom_offset = SSB_SPROM_BASE1;
+	}
 
 	buf = kcalloc(SSB_SPROMSIZE_WORDS_R123, sizeof(u16), GFP_KERNEL);
 	if (!buf)
--- a/drivers/ssb/sprom.c
+++ b/drivers/ssb/sprom.c
@@ -185,6 +185,7 @@ bool ssb_is_sprom_available(struct ssb_b
 	/* this routine differs from specs as we do not access SPROM directly
 	   on PCMCIA */
 	if (bus->bustype == SSB_BUSTYPE_PCI &&
+	    bus->chipco.dev &&	/* can be unavailible! */
 	    bus->chipco.dev->id.revision >= 31)
 		return bus->chipco.capabilities & SSB_CHIPCO_CAP_SPROM;
 


