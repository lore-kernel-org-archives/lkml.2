Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896Ab1BDIDu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 03:03:50 -0500
Received: from mail.sysgo.com ([195.145.229.155]:60386 "EHLO mail.sysgo.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752123Ab1BDIDt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 03:03:49 -0500
Date: Fri, 4 Feb 2011 09:03:43 +0100
From: Pavel Machek <pma@sysgo.com>
To: Russell King <rmk@arm.linux.org.uk>
Cc: kernel list <linux-kernel@vger.kernel.org>, cko@sysgo.com,
        linux@dominikbrodowski.net, eric.miao@marvell.com,
        Andrew Morton <akpm@osdl.org>
Subject: Re: pcmcia vs. MECR on pxa25x/sa1111
Message-ID: <20110204080343.GA31740@pma.sysgo.com>
References: <20110201120303.GA30464@pma.sysgo.com>
 <20110201125921.GA7984@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110201125921.GA7984@flint.arm.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


After 2.6.34 changes, __pxa2xx_drv_pcmcia_probe() was replaced by
sa1111_pcmcia_add(). That unfortunately means that configure_sockets()
is not called, leading to MECR not being set properly, leading to
strange crashes.

Tested on pxa255+sa1111, I do not have lubbock board nearby. Perhaps
cleaner solution exists?

Signed-off-by: Pavel Machek <pma@sysgo.com>

---

Here's updated version. I'd prefer not to do too extensive changes as
I do not have lubbock nearby.


--- a/drivers/pcmcia/pxa2xx_base.c
+++ b/drivers/pcmcia/pxa2xx_base.c
@@ -204,7 +204,7 @@ pxa2xx_pcmcia_frequency_change(struct soc_pcmcia_socket *skt,
 }
 #endif
 
-static void pxa2xx_configure_sockets(struct device *dev)
+void pxa2xx_configure_sockets(struct device *dev)
 {
 	struct pcmcia_low_level *ops = dev->platform_data;
 
--- a/drivers/pcmcia/pxa2xx_base.h
+++ b/drivers/pcmcia/pxa2xx_base.h
@@ -1,3 +1,4 @@
 int pxa2xx_drv_pcmcia_add_one(struct soc_pcmcia_socket *skt);
 void pxa2xx_drv_pcmcia_ops(struct pcmcia_low_level *ops);
+void pxa2xx_configure_sockets(struct device *dev);
 
--- a/drivers/pcmcia/pxa2xx_lubbock.c
+++ b/drivers/pcmcia/pxa2xx_lubbock.c
@@ -226,6 +226,7 @@ int pcmcia_lubbock_init(struct sa1111_dev *sadev)
 		lubbock_set_misc_wr((1 << 15) | (1 << 14), 0);
 
 		pxa2xx_drv_pcmcia_ops(&lubbock_pcmcia_ops);
+		pxa2xx_configure_sockets(&sadev->dev);
 		ret = sa1111_pcmcia_add(sadev, &lubbock_pcmcia_ops,
 				pxa2xx_drv_pcmcia_add_one);
 	}

