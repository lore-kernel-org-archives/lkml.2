Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757416Ab2HGD4J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 23:56:09 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59608 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757263Ab2HGDiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 23:38:08 -0400
Message-Id: <20120807032757.447370951@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Tue, 07 Aug 2012 04:28:04 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Luis Henriques <luis.henriques@canonical.com>,
        Jarod Wilson <jarod@redhat.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [ 09/70] [media] ene_ir: Fix driver initialisation
In-Reply-To: <20120807032755.803571133@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luis Henriques <luis.henriques@canonical.com>

commit b31b021988fed9e3741a46918f14ba9b063811db upstream.

commit 9ef449c6b31bb6a8e6dedc24de475a3b8c79be20 ("[media] rc: Postpone ISR
registration") fixed an early ISR registration on several drivers.  It did
however also introduced a bug by moving the invocation of pnp_port_start()
to the end of the probe function.

This patch fixes this issue by moving the invocation of pnp_port_start() to
an earlier stage in the probe function.

Cc: Jarod Wilson <jarod@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/media/rc/ene_ir.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/rc/ene_ir.c b/drivers/media/rc/ene_ir.c
index bef5296..647dd95 100644
--- a/drivers/media/rc/ene_ir.c
+++ b/drivers/media/rc/ene_ir.c
@@ -1018,6 +1018,8 @@ static int ene_probe(struct pnp_dev *pnp_dev, const struct pnp_device_id *id)
 
 	spin_lock_init(&dev->hw_lock);
 
+	dev->hw_io = pnp_port_start(pnp_dev, 0);
+
 	pnp_set_drvdata(pnp_dev, dev);
 	dev->pnp_dev = pnp_dev;
 
@@ -1072,7 +1074,6 @@ static int ene_probe(struct pnp_dev *pnp_dev, const struct pnp_device_id *id)
 
 	/* claim the resources */
 	error = -EBUSY;
-	dev->hw_io = pnp_port_start(pnp_dev, 0);
 	if (!request_region(dev->hw_io, ENE_IO_SIZE, ENE_DRIVER_NAME)) {
 		dev->hw_io = -1;
 		dev->irq = -1;


