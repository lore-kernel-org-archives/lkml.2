Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932346Ab1BPAYn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:24:43 -0500
Received: from kroah.org ([198.145.64.141]:49672 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932265Ab1BPAYZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:24:25 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:47 2011
Message-Id: <20110216001447.521565564@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:14:41 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Olof Johansson <olof@lixom.net>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        James Morris <jmorris@namei.org>
Subject: [224/272] tpm: fix panic caused by "tpm: Autodetect itpm devices"
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Olof Johansson <olof@lixom.net>

commit e5cce6c13c25d9ac56955a3ae2fd562719848172 upstream.

commit 3f0d3d016d89a5efb8b926d4707eb21fa13f3d27 adds a check for
PNP device id to the common tpm_tis_init() function, which in some
cases (force=1) will be called without the device being a member of
a pnp_dev. Oopsing and panics ensue.

Move the test up to before the call to tpm_tis_init(), since it
just modifies a global variable anyway.

Signed-off-by: Olof Johansson <olof@lixom.net>
Acked-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Signed-off-by: James Morris <jmorris@namei.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/tpm/tpm_tis.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -493,9 +493,6 @@ static int tpm_tis_init(struct device *d
 		 "1.2 TPM (device-id 0x%X, rev-id %d)\n",
 		 vendor >> 16, ioread8(chip->vendor.iobase + TPM_RID(0)));
 
-	if (is_itpm(to_pnp_dev(dev)))
-		itpm = 1;
-
 	if (itpm)
 		dev_info(dev, "Intel iTPM workaround enabled\n");
 
@@ -637,6 +634,9 @@ static int __devinit tpm_tis_pnp_init(st
 	else
 		interrupts = 0;
 
+	if (is_itpm(pnp_dev))
+		itpm = 1;
+
 	return tpm_tis_init(&pnp_dev->dev, start, len, irq);
 }
 


