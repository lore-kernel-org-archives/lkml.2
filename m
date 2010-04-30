Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757421Ab0D3Qrv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 12:47:51 -0400
Received: from tex.lwn.net ([70.33.254.29]:56775 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757424Ab0D3Qqu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 12:46:50 -0400
Date: Fri, 30 Apr 2010 10:21:57 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Bruno =?ISO-8859-1?B?UHLpbW9udA==?= <bonbons@linux-vserver.org>
Cc: linux-kernel@vger.kernel.org, Harald Welte <laforge@gnumonks.org>,
       linux-fbdev@vger.kernel.org, JosephChan@via.com.tw,
       ScottFang@viatech.com.cn,
       Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: Re: [PATCH 13/30] viafb: Separate global and fb-specific data
Message-ID: <20100430102157.5eb59055@bike.lwn.net>
In-Reply-To: <20100429201902.6379f8d3@neptune.home>
References: <1272493051-25380-1-git-send-email-corbet@lwn.net>
	<1272493051-25380-14-git-send-email-corbet@lwn.net>
	<20100429201902.6379f8d3@neptune.home>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Apr 2010 20:19:02 +0200
Bruno Prémont <bonbons@linux-vserver.org> wrote:

> > +	vdev->engine_start = pci_resource_start(vdev->pdev, 1);
> > +	vdev->engine_len = pci_resource_len(vdev->pdev, 1);
> > +	/* If this fails, others will notice later */
> > +	vdev->engine_mmio = ioremap_nocache(vdev->engine_start,
> > +			vdev->engine_len);
> 
> Shouldn't this ioremap_nocache() have error-checking
> as the one below (instead of relying on later code to bail out)?

It would be better, yes, I'll add a patch to fix it up.

> > +	vdev->fbmem = ioremap_nocache(vdev->fbmem_start, vdev->fbmem_len);
> > +	if (vdev->fbmem == NULL)
> > +		return -ENOMEM;
> 
> IMHO it would be better to iounmap(vdev->engine_mmio) here
> instead of letting our caller run via_pci_teardown_mmio()

Not sure it matters, but I can make that change.

> Why goto out_teardown here?
> If via_pci_setup_mmio() failed it should undo its successful
> actions itself... (see also above)

Yes, I can fix that (see above :)

> > +	/*
> >  	 * Set up subsidiary devices
> >  	 */
> > -	ret = via_fb_pci_probe(pdev, ent);
> > +	ret = via_fb_pci_probe(&global_dev);
> >  	if (ret)
> >  		return ret;
> 
> In this case we should goto out_teardown so the mmio setup earlier gets
> undone.

This I'm less convinced about; as I split the functions apart, I've
tried to get away from the "all or nothing" mode of operation.  Now, if
framebuffer setup fails, there will likely be very little solace in
knowing that the GPIOs still work, but I would still rather allow
things that succeed to function when possible.

That said, the code doesn't currently quite work that way.  So I guess
I'll goto out_teardown here :)

jon

viafb: Fix initialization error paths

Properly localize error cleanup, and make sure that the iomem regions are
unmapped if framebuffer initialization fails.

Reported-by: Bruno Prémont <bonbons@linux-vserver.org>
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
---
 drivers/video/via/via-core.c |   26 ++++++++++++++++----------
 1 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/video/via/via-core.c b/drivers/video/via/via-core.c
index 2b5773a..b8a8783 100644
--- a/drivers/video/via/via-core.c
+++ b/drivers/video/via/via-core.c
@@ -454,26 +454,32 @@ static int viafb_get_fb_size_from_pci(int chip_type)
  */
 static int __devinit via_pci_setup_mmio(struct viafb_dev *vdev)
 {
+	int ret;
 	/*
 	 * Hook up to the device registers.
 	 */
 	vdev->engine_start = pci_resource_start(vdev->pdev, 1);
 	vdev->engine_len = pci_resource_len(vdev->pdev, 1);
-	/* If this fails, others will notice later */
 	vdev->engine_mmio = ioremap_nocache(vdev->engine_start,
 			vdev->engine_len);
-
+	if (vdev->engine_mmio == NULL)
+		return -ENOMEM;
 	/*
-	 * Likewise with I/O memory.
+	 * Likewise with framebuffer memory.
 	 */
 	vdev->fbmem_start = pci_resource_start(vdev->pdev, 0);
-	vdev->fbmem_len = viafb_get_fb_size_from_pci(vdev->chip_type);
-	if (vdev->fbmem_len < 0)
-		return vdev->fbmem_len;
+	ret = vdev->fbmem_len = viafb_get_fb_size_from_pci(vdev->chip_type);
+	if (ret < 0)
+		goto out_unmap;
 	vdev->fbmem = ioremap_nocache(vdev->fbmem_start, vdev->fbmem_len);
-	if (vdev->fbmem == NULL)
-		return -ENOMEM;
+	if (vdev->fbmem == NULL) {
+		ret = -ENOMEM;
+		goto out_unmap;
+	}
 	return 0;
+out_unmap:
+	iounmap(vdev->engine_mmio);
+	return ret;
 }
 
 static void __devexit via_pci_teardown_mmio(struct viafb_dev *vdev)
@@ -566,13 +572,13 @@ static int __devinit via_pci_probe(struct pci_dev *pdev,
 	spin_lock_init(&global_dev.reg_lock);
 	ret = via_pci_setup_mmio(&global_dev);
 	if (ret)
-		goto out_teardown;
+		return ret;
 	/*
 	 * Set up the framebuffer device
 	 */
 	ret = via_fb_pci_probe(&global_dev);
 	if (ret)
-		return ret;
+		goto out_teardown;
 	/*
 	 * Create our subdevices.
 	 */
-- 
1.7.0.1

