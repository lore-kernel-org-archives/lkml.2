Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636Ab1AFAcu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:32:50 -0500
Received: from kroah.org ([198.145.64.141]:36166 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754848Ab1AFAcA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:32:00 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 16:23:10 2011
Message-Id: <20110106002310.722196020@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 16:24:09 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [150/152] orinoco: initialise priv->hw before assigning the interrupt
In-Reply-To: <20110106002500.GA3172@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David Kilroy <kilroyd@googlemail.com>

commit 229bd792be0bad245b78ed8f119952733a4752e5 upstream.

The interrupt handler takes a lock - but since commit bcad6e80f3f this
lock goes through an indirection specified in the hermes_t structure.
We must therefore initialise the structure before setting up the
interrupt handler.

Fix orinoco_cs and spectrum_cs

<https://bugzilla.kernel.org/show_bug.cgi?id=23932>

Bisected by: Matt Domsch <Matt_Domsch@dell.com>
Signed-off by: David Kilroy <kilroyd@googlemail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/orinoco/orinoco_cs.c  |   14 +++++++-------
 drivers/net/wireless/orinoco/spectrum_cs.c |   14 +++++++-------
 2 files changed, 14 insertions(+), 14 deletions(-)

--- a/drivers/net/wireless/orinoco/orinoco_cs.c
+++ b/drivers/net/wireless/orinoco/orinoco_cs.c
@@ -248,20 +248,20 @@ orinoco_cs_config(struct pcmcia_device *
 		goto failed;
 	}
 
-	ret = pcmcia_request_irq(link, orinoco_interrupt);
-	if (ret)
-		goto failed;
-
-	/* We initialize the hermes structure before completing PCMCIA
-	 * configuration just in case the interrupt handler gets
-	 * called. */
 	mem = ioport_map(link->resource[0]->start,
 			resource_size(link->resource[0]));
 	if (!mem)
 		goto failed;
 
+	/* We initialize the hermes structure before completing PCMCIA
+	 * configuration just in case the interrupt handler gets
+	 * called. */
 	hermes_struct_init(hw, mem, HERMES_16BIT_REGSPACING);
 
+	ret = pcmcia_request_irq(link, orinoco_interrupt);
+	if (ret)
+		goto failed;
+
 	/*
 	 * This actually configures the PCMCIA socket -- setting up
 	 * the I/O windows and the interrupt mapping, and putting the
--- a/drivers/net/wireless/orinoco/spectrum_cs.c
+++ b/drivers/net/wireless/orinoco/spectrum_cs.c
@@ -310,21 +310,21 @@ spectrum_cs_config(struct pcmcia_device
 		goto failed;
 	}
 
-	ret = pcmcia_request_irq(link, orinoco_interrupt);
-	if (ret)
-		goto failed;
-
-	/* We initialize the hermes structure before completing PCMCIA
-	 * configuration just in case the interrupt handler gets
-	 * called. */
 	mem = ioport_map(link->resource[0]->start,
 			resource_size(link->resource[0]));
 	if (!mem)
 		goto failed;
 
+	/* We initialize the hermes structure before completing PCMCIA
+	 * configuration just in case the interrupt handler gets
+	 * called. */
 	hermes_struct_init(hw, mem, HERMES_16BIT_REGSPACING);
 	hw->eeprom_pda = true;
 
+	ret = pcmcia_request_irq(link, orinoco_interrupt);
+	if (ret)
+		goto failed;
+
 	/*
 	 * This actually configures the PCMCIA socket -- setting up
 	 * the I/O windows and the interrupt mapping, and putting the


