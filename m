Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755011Ab1CKUnS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 15:43:18 -0500
Received: from kroah.org ([198.145.64.141]:46620 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754931Ab1CKUnO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 15:43:14 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar 11 12:41:11 2011
Message-Id: <20110311204110.957498798@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 11 Mar 2011 12:40:17 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ian Abbott <abbotti@mev.co.uk>
Subject: [16/17] Staging: comedi: jr3_pci: Dont ioremap too much space. Check result.
In-Reply-To: <20110311204126.GA7223@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Ian Abbott <abbotti@mev.co.uk>

commit fa5c5f4ce0c9ba03a670c640cad17e14cb35678b upstream.

For the JR3/PCI cards, the size of the PCIBAR0 region depends on the
number of channels.  Don't try and ioremap space for 4 channels if the
card has fewer channels.  Also check for ioremap failure.

Thanks to Anders Blomdell for input and Sami Hussein for testing.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/comedi/drivers/jr3_pci.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/staging/comedi/drivers/jr3_pci.c
+++ b/drivers/staging/comedi/drivers/jr3_pci.c
@@ -856,8 +856,11 @@ static int jr3_pci_attach(struct comedi_
 	}
 
 	devpriv->pci_enabled = 1;
-	devpriv->iobase =
-	    ioremap(pci_resource_start(card, 0), sizeof(struct jr3_t));
+	devpriv->iobase = ioremap(pci_resource_start(card, 0),
+			offsetof(struct jr3_t, channel[devpriv->n_channels]));
+	if (!devpriv->iobase)
+		return -ENOMEM;
+
 	result = alloc_subdevices(dev, devpriv->n_channels);
 	if (result < 0)
 		goto out;


