Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759315Ab0FQCrJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 22:47:09 -0400
Received: from stinky.trash.net ([213.144.137.162]:53517 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112Ab0FQCrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 22:47:07 -0400
Message-ID: <4C198CA7.4050204@trash.net>
Date: Thu, 17 Jun 2010 04:47:03 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100329)
MIME-Version: 1.0
To: Dominik Brodowski <linux@dominikbrodowski.net>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: pcmcia: fix 'driver ... did not release config properly' warning
Content-Type: multipart/mixed;
 boundary="------------060408030509060300010704"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060408030509060300010704
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit



--------------060408030509060300010704
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

commit b1be4845dffefe212959ee02b783571eead3e350
Author: Patrick McHardy <kaber@trash.net>
Date:   Thu Jun 17 04:43:07 2010 +0200

    pcmcia: fix 'driver ... did not release config properly' warning
    
    Up to 2.6.34 pcmcia_release_irq() reset p_dev->_irq to 0 after releasing
    the irq. The IRQ is now released in pcmcia_disable_device(), however
    p_dev->_irq is not reset, triggering a warning in pcmcia_device_remove().
    
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/drivers/pcmcia/pcmcia_resource.c b/drivers/pcmcia/pcmcia_resource.c
index 29f91fa..a4cd9ad 100644
--- a/drivers/pcmcia/pcmcia_resource.c
+++ b/drivers/pcmcia/pcmcia_resource.c
@@ -857,8 +857,10 @@ void pcmcia_disable_device(struct pcmcia_device *p_dev)
 {
 	pcmcia_release_configuration(p_dev);
 	pcmcia_release_io(p_dev, &p_dev->io);
-	if (p_dev->_irq)
+	if (p_dev->_irq) {
 		free_irq(p_dev->irq, p_dev->priv);
+		p_dev->_irq = 0;
+	}
 	if (p_dev->win)
 		pcmcia_release_window(p_dev, p_dev->win);
 }

--------------060408030509060300010704--
