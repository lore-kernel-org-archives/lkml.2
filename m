Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754343Ab1DDKDX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 06:03:23 -0400
Received: from mga11.intel.com ([192.55.52.93]:25577 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753642Ab1DDKDV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 06:03:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,296,1299484800"; 
   d="scan'208";a="674921237"
Date: Mon, 4 Apr 2011 12:03:15 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Andres Salomon <dilinger@queued.net>, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>, khali@linux-fr.org,
        ben-linux@fluff.org, Peter Korsgaard <jacmet@sunsite.dk>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        David Brownell <dbrownell@users.sourceforge.net>,
        linux-i2c@vger.kernel.org, linux-media@vger.kernel.org,
        netdev@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
        Mocean Laboratories <info@mocean-labs.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 07/19] timberdale: mfd_cell is now implicitly available
 to drivers
Message-ID: <20110404100314.GC2751@sortiz-mobl>
References: <20110202195417.228e2656@queued.net>
 <20110202200812.3d8d6cba@queued.net>
 <20110331230522.GI437@ponder.secretlab.ca>
 <20110401112030.GA3447@sortiz-mobl>
 <20110401104756.2f5c6f7a@debxo>
 <BANLkTi=bCd_+f=EG-O=U5VH_ZNjFhxkziQ@mail.gmail.com>
 <20110401235239.GE29397@sortiz-mobl>
 <BANLkTi=bq=OGzXFp7qiBr7x_BnGOWf=DRQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTi=bq=OGzXFp7qiBr7x_BnGOWf=DRQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 01, 2011 at 05:58:44PM -0600, Grant Likely wrote:
> On Fri, Apr 1, 2011 at 5:52 PM, Samuel Ortiz <sameo@linux.intel.com> wrote:
> > On Fri, Apr 01, 2011 at 11:56:35AM -0600, Grant Likely wrote:
> >> On Fri, Apr 1, 2011 at 11:47 AM, Andres Salomon <dilinger@queued.net> wrote:
> >> > On Fri, 1 Apr 2011 13:20:31 +0200
> >> > Samuel Ortiz <sameo@linux.intel.com> wrote:
> >> >
> >> >> Hi Grant,
> >> >>
> >> >> On Thu, Mar 31, 2011 at 05:05:22PM -0600, Grant Likely wrote:
> >> > [...]
> >> >> > Gah.  Not all devices instantiated via mfd will be an mfd device,
> >> >> > which means that the driver may very well expect an *entirely
> >> >> > different* platform_device pointer; which further means a very high
> >> >> > potential of incorrectly dereferenced structures (as evidenced by a
> >> >> > patch series that is not bisectable).  For instance, the xilinx ip
> >> >> > cores are used by more than just mfd.
> >> >> I agree. Since the vast majority of the MFD subdevices are MFD
> >> >> specific IPs, I overlooked that part. The impacted drivers are the
> >> >> timberdale and the DaVinci voice codec ones.
> >>
> >> Another option is you could do this for MFD devices:
> >>
> >> struct mfd_device {
> >>         struct platform_devce pdev;
> >>         struct mfd_cell *cell;
> >> };
> >>
> >> However, that requires that drivers using the mfd_cell will *never*
> >> get instantiated outside of the mfd infrastructure, and there is no
> >> way to protect against this so it is probably a bad idea.
> >>
> >> Or, mfd_cell could be added to platform_device directly which would
> >> *by far* be the safest option at the cost of every platform_device
> >> having a mostly unused mfd_cell pointer.  Not a significant cost in my
> >> opinion.
> > I thought about this one, but I had the impression people would want to kill
> > me for adding an MFD specific pointer to platform_device. I guess it's worth
> > giving it a try since it would be a simple and safe solution.
> > I'll look at it later this weekend.
> >
> > Thanks for the input.
> 
> [cc'ing gregkh because we're talking about modifying struct platform_device]
> 
> I'll back you up on this one.  It is a far better solution than the
> alternatives.  At least with mfd, it covers a large set of devices.  I
> think there is a strong argument for doing this.  Or alternatively,
> the particular interesting fields from mfd_cell could be added to
> platform_device.  What information do child devices need access to?
In some cases, they need the whole cell to clone it. So I'm up for adding an
mfd_cell pointer to the platform_device structure.
Below is a tentative patch. This is a first step and would fix all
regressions. I tried to keep the MFD dependencies as small as possible, which
is why I placed the pdev->mfd_cell building code in mfd-core.c
The second step would be to get rid of mfd_get_data() and have all subdrivers
going back to the regular platform_data way. They would no longer be dependant
on the MFD code except for those who really need it. In that case they could
just call mfd_get_cell() and get full access to their MFD cell.

--- 
 drivers/mfd/mfd-core.c          |   27 ++++++++++++++++++++++-----
 include/linux/mfd/core.h        |    7 +++++--
 include/linux/platform_device.h |    5 +++++
 3 files changed, 32 insertions(+), 7 deletions(-)

diff --git a/drivers/mfd/mfd-core.c b/drivers/mfd/mfd-core.c
index d01574d..c0fc1c0 100644
--- a/drivers/mfd/mfd-core.c
+++ b/drivers/mfd/mfd-core.c
@@ -18,6 +18,21 @@
 #include <linux/pm_runtime.h>
 #include <linux/slab.h>
 
+static int mfd_platform_add_cell(struct platform_device *pdev, const struct mfd_cell *cell)
+{
+	struct mfd_cell *c;
+
+	if (cell == NULL)
+		return 0;
+
+	c = kmemdup(cell, sizeof(struct mfd_cell), GFP_KERNEL);
+	if (c == NULL)
+		return -ENOMEM;
+
+	pdev->mfd_cell = c;
+	return 0;
+}
+
 int mfd_cell_enable(struct platform_device *pdev)
 {
 	const struct mfd_cell *cell = mfd_get_cell(pdev);
@@ -75,7 +90,7 @@ static int mfd_add_device(struct device *parent, int id,
 
 	pdev->dev.parent = parent;
 
-	ret = platform_device_add_data(pdev, cell, sizeof(*cell));
+	ret = mfd_platform_add_cell(pdev, cell);
 	if (ret)
 		goto fail_res;
 
@@ -104,17 +119,17 @@ static int mfd_add_device(struct device *parent, int id,
 		if (!cell->ignore_resource_conflicts) {
 			ret = acpi_check_resource_conflict(res);
 			if (ret)
-				goto fail_res;
+				goto fail_cell;
 		}
 	}
 
 	ret = platform_device_add_resources(pdev, res, cell->num_resources);
 	if (ret)
-		goto fail_res;
+		goto fail_cell;
 
 	ret = platform_device_add(pdev);
 	if (ret)
-		goto fail_res;
+		goto fail_cell;
 
 	if (cell->pm_runtime_no_callbacks)
 		pm_runtime_no_callbacks(&pdev->dev);
@@ -123,7 +138,8 @@ static int mfd_add_device(struct device *parent, int id,
 
 	return 0;
 
-/*	platform_device_del(pdev); */
+fail_cell:
+	kfree(pdev->mfd_cell);
 fail_res:
 	kfree(res);
 fail_device:
@@ -171,6 +187,7 @@ static int mfd_remove_devices_fn(struct device *dev, void *c)
 	if (!*usage_count || (cell->usage_count < *usage_count))
 		*usage_count = cell->usage_count;
 
+	kfree(pdev->mfd_cell);
 	platform_device_unregister(pdev);
 	return 0;
 }
diff --git a/include/linux/mfd/core.h b/include/linux/mfd/core.h
index ad1b19a..0e4d3a6 100644
--- a/include/linux/mfd/core.h
+++ b/include/linux/mfd/core.h
@@ -86,7 +86,7 @@ extern int mfd_clone_cell(const char *cell, const char **clones,
  */
 static inline const struct mfd_cell *mfd_get_cell(struct platform_device *pdev)
 {
-	return pdev->dev.platform_data;
+	return pdev->mfd_cell;
 }
 
 /*
@@ -95,7 +95,10 @@ static inline const struct mfd_cell *mfd_get_cell(struct platform_device *pdev)
  */
 static inline void *mfd_get_data(struct platform_device *pdev)
 {
-	return mfd_get_cell(pdev)->mfd_data;
+	if (pdev->mfd_cell != NULL)
+		return mfd_get_cell(pdev)->mfd_data;
+	else
+		return pdev->dev.platform_data;
 }
 
 extern int mfd_add_devices(struct device *parent, int id,
diff --git a/include/linux/platform_device.h b/include/linux/platform_device.h
index d96db98..734d254 100644
--- a/include/linux/platform_device.h
+++ b/include/linux/platform_device.h
@@ -14,6 +14,8 @@
 #include <linux/device.h>
 #include <linux/mod_devicetable.h>
 
+struct mfd_cell;
+
 struct platform_device {
 	const char	* name;
 	int		id;
@@ -23,6 +25,9 @@ struct platform_device {
 
 	const struct platform_device_id	*id_entry;
 
+	/* MFD cell pointer */
+	struct mfd_cell	*mfd_cell;
+
 	/* arch specific additions */
 	struct pdev_archdata	archdata;
 };

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
