Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755687Ab1CAVzN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 16:55:13 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:48371 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753068Ab1CAVzM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 16:55:12 -0500
Date: Tue, 1 Mar 2011 13:55:07 -0800
From: Andres Salomon <dilinger@queued.net>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>, linux-kernel@vger.kernel.org
Subject: [PATCH] w1/ds1wm: silence warnings related to mfd_get_cell changes
Message-ID: <20110301135507.738d23c1@debxo>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


mfd_get_cell returns a const, so change the ds1wm client to store
a const mfd cell.  This silences type mismatch warnings.

Since we're guaranteed to have the mfd_cell, we can also simplify
the code a bit to get rid of a temporary variable and NULL check.

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 drivers/w1/masters/ds1wm.c |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/w1/masters/ds1wm.c b/drivers/w1/masters/ds1wm.c
index 22fc726..95921b7 100644
--- a/drivers/w1/masters/ds1wm.c
+++ b/drivers/w1/masters/ds1wm.c
@@ -90,7 +90,7 @@ struct ds1wm_data {
 	void		__iomem *map;
 	int		bus_shift; /* # of shifts to calc register offsets */
 	struct platform_device *pdev;
-	struct mfd_cell	*cell;
+	const struct mfd_cell *cell;
 	int		irq;
 	int		active_high;
 	int		slave_present;
@@ -330,16 +330,11 @@ static int ds1wm_probe(struct platform_device *pdev)
 	struct ds1wm_data *ds1wm_data;
 	struct ds1wm_driver_data *plat;
 	struct resource *res;
-	struct mfd_cell *cell;
 	int ret;
 
 	if (!pdev)
 		return -ENODEV;
 
-	cell = mfd_get_cell(pdev);
-	if (!cell)
-		return -ENODEV;
-
 	ds1wm_data = kzalloc(sizeof(*ds1wm_data), GFP_KERNEL);
 	if (!ds1wm_data)
 		return -ENOMEM;
@@ -362,7 +357,7 @@ static int ds1wm_probe(struct platform_device *pdev)
 	ds1wm_data->bus_shift = resource_size(res) >> 3;
 
 	ds1wm_data->pdev = pdev;
-	ds1wm_data->cell = cell;
+	ds1wm_data->cell = mfd_get_cell(pdev);
 
 	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
 	if (!res) {
-- 
1.7.2.3

