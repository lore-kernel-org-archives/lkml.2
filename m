Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320Ab1BEDZl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 22:25:41 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:36531 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751523Ab1BEDZj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 22:25:39 -0500
Date: Fri, 4 Feb 2011 19:25:35 -0800
From: Andres Salomon <dilinger@queued.net>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Peter Ujfalusi <peter.ujfalusi@nokia.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Timur Tabi <timur@freescale.com>,
        linux-input@vger.kernel.org, alsa-devel@alsa-project.org
Subject: Re: [PATCH 12/19] twl4030: mfd_cell is now implicitly available to
 drivers
Message-ID: <20110204192535.329d2280@queued.net>
In-Reply-To: <20110204183913.318e6664@debxo>
References: <20110202195417.228e2656@queued.net>
	<20110202201522.72d37f1e@queued.net>
	<20110203060521.GA25739@core.coreip.homeip.net>
	<20110202223959.244b4a01@queued.net>
	<20110203065339.GA5592@core.coreip.homeip.net>
	<20110202230326.167fe873@queued.net>
	<20110203093154.GC21591@opensource.wolfsonmicro.com>
	<20110204183913.318e6664@debxo>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Feb 2011 18:39:13 -0800
Andres Salomon <dilinger@queued.net> wrote:

> On Thu, 3 Feb 2011 09:31:54 +0000
> Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:
> 
> > On Wed, Feb 02, 2011 at 11:03:26PM -0800, Andres Salomon wrote:
> > > Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> > 
> > > > Then they are doing it incorrectly. One possible way is to have
> > > > parent device carry relevant data in its drvdata and have
> > > > children get it from there.
> > 
> > > I believe some drivers are even using the parent device already.
> > > See drivers/leds/leds-mc13783.c, for example, whose parent device
> > > drvdata is used to pass around a struct mc13783 to its children.
> > > Sounds like a possibility, will need to look into it further.
> > 
> > That's the current best practice approach.
> 
[rambling]
> Even that would require the weird API of mfd_add_devices needing to be
> passed the type of what's pointed to by the parent's drvdata.
> 

Actually, how about something like the following?  This would leave
drvdata unaffected.



diff --git a/drivers/mfd/mfd-core.c b/drivers/mfd/mfd-core.c
index d83ad0f..a324a83 100644
--- a/drivers/mfd/mfd-core.c
+++ b/drivers/mfd/mfd-core.c
@@ -25,6 +25,7 @@ static int mfd_add_device(struct device *parent, int id,
 {
 	struct resource *res;
 	struct platform_device *pdev;
+	struct mfd_platform_data pdata = { NULL, NULL };
 	int ret = -ENOMEM;
 	int r;
 
@@ -39,12 +40,18 @@ static int mfd_add_device(struct device *parent, int id,
 	pdev->dev.parent = parent;
 	platform_set_drvdata(pdev, cell->driver_data);
 
+	pdata.cell = cell;
 	if (cell->data_size) {
-		ret = platform_device_add_data(pdev,
-					cell->platform_data, cell->data_size);
-		if (ret)
+		pdata.platform_data = kmemdup(cell->platform_data,
+				cell->data_size, GFP_KERNEL);
+		if  (!pdata.platform_data) {
+			ret = -ENOMEM;
 			goto fail_res;
+		}
 	}
+	ret = platform_device_add_data(pdev, &pdata, sizeof(pdata));
+	if (ret)
+		goto fail_pdata;
 
 	for (r = 0; r < cell->num_resources; r++) {
 		res[r].name = cell->resources[r].name;
@@ -91,6 +98,9 @@ static int mfd_add_device(struct device *parent, int id,
 	return 0;
 
 /*	platform_device_del(pdev); */
+fail_pdata:
+	if (pdata.platform_data)
+		kfree(pdata.platform_data);
 fail_res:
 	kfree(res);
 fail_device:
@@ -122,6 +132,7 @@ EXPORT_SYMBOL(mfd_add_devices);
 
 static int mfd_remove_devices_fn(struct device *dev, void *unused)
 {
+	/* TODO: nuke pdata memory */
 	platform_device_unregister(to_platform_device(dev));
 	return 0;
 }
diff --git a/include/linux/mfd/core.h b/include/linux/mfd/core.h
index 835996e..dbc52a2 100644
--- a/include/linux/mfd/core.h
+++ b/include/linux/mfd/core.h
@@ -55,6 +55,26 @@ struct mfd_cell {
 	bool			pm_runtime_no_callbacks;
 };
 
+/* simple wrapper for a platform device's pdata */
+struct mfd_platform_data {
+	void *platform_data;
+	struct mfd_cell *cell;
+};
+
+/*
+ * Given a platform device that's been created by mfd_add_devices(), fetch
+ * the mfd_cell that created it.
+ */
+static inline const struct mfd_cell *mfd_get_cell(struct platform_device *pdev)
+{
+	return ((struct mfd_platform_data *)pdev->dev.platform_data)->cell;
+}
+
+static inline void *mfd_platform_data(struct platform_device *pdev)
+{
+	return ((struct mfd_platform_data *)pdev->dev.platform_data)->data;
+}
+
 extern int mfd_add_devices(struct device *parent, int id,
 			   const struct mfd_cell *cells, int n_devs,
 			   struct resource *mem_base,

