Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532Ab2BROEy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Feb 2012 09:04:54 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35202 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751776Ab2BROEw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Feb 2012 09:04:52 -0500
Date: Sat, 18 Feb 2012 15:04:49 +0100
From: Holger Macht <holger@homac.de>
To: Hillf Danton <dhillf@gmail.com>
Cc: Hugh Dickins <hughd@google.com>, Matthew Garrett <mjg@redhat.com>,
        Jeff Garzik <jgarzik@redhat.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: dock_link_device is oopsy
Message-ID: <20120218140449.GA2558@homac.suse.de>
References: <alpine.LSU.2.00.1202171320590.5994@eggly.anvils>
 <20120217222922.GA2741@homac.suse.de>
 <alpine.LSU.2.00.1202171436490.10222@eggly.anvils>
 <20120217230107.GA12929@homac.suse.de>
 <alpine.LSU.2.00.1202171541040.3155@eggly.anvils>
 <20120218111419.GA2488@homac.suse.de>
 <CAJd=RBDRZSizawvRYqr7=U75Su5TLvMfgdagRA49wzJr40DqSg@mail.gmail.com>
 <20120218132610.GA15265@homac.suse.de>
 <CAJd=RBAhnsuP4+pRS=MLyOaqx8O1gOR30bcoZC0Owabh1-1nzA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJd=RBAhnsuP4+pRS=MLyOaqx8O1gOR30bcoZC0Owabh1-1nzA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sa 18. Feb - 21:37:18, Hillf Danton wrote:
> On Sat, Feb 18, 2012 at 9:26 PM, Holger Macht <holger@homac.de> wrote:
> Hi  Holger
> 
> Lets check the following snippet from what you posted,
> 
> > @@ -320,12 +324,17 @@ EXPORT_SYMBOL_GPL(dock_link_device);
> >  */
> >  struct device **dock_unlink_device(acpi_handle handle)
> >  {
> > -       struct device *dev = acpi_get_physical_device(handle);
> > +       struct device *dev;
> >        struct dock_station *dock_station;
> >        int dock = 0;
> > -       struct device **devices =
> > -               kmalloc(dock_station_count * sizeof(struct device *),
> > -                       GFP_KERNEL);
> > +       struct device **devices;
> > +
> > +       if (!dock_station_count)
> > +               return NULL;
> > +
> > +       dev = acpi_get_physical_device(handle);
> > +       devices = kmalloc(dock_station_count * sizeof(struct device *),
> > +                         GFP_KERNEL);
> >
> >        if (!dev)
> >                return NULL;  <=== here return without freeing the newly
>                                                allocated devices after checking
>                                                dock_station_count is not zero

How about that one?

acpi: Bail out when linking devices and there are no dock stations

If dock_station_count is zero, we allocate zero memory and don't check
this at future references. So bail out if there are actually no dock
stations. Fix some possible memory leaks on the way.

Signed-off-by: Holger Macht <holger@homac.de>
---
 drivers/acpi/dock.c |   23 ++++++++++++++++-------
 1 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/acpi/dock.c b/drivers/acpi/dock.c
index b5e4142..b2e8730 100644
--- a/drivers/acpi/dock.c
+++ b/drivers/acpi/dock.c
@@ -281,14 +281,15 @@ EXPORT_SYMBOL_GPL(is_dock_device);
  */
 struct device **dock_link_device(acpi_handle handle)
 {
-	struct device *dev = acpi_get_physical_device(handle);
+	struct device *dev;
 	struct dock_station *dock_station;
 	int ret, dock = 0;
 	struct device **devices;
 
-	devices = kmalloc(dock_station_count * sizeof(struct device *),
-			  GFP_KERNEL);
+	if (!dock_station_count)
+		return NULL;
 
+	dev = acpi_get_physical_device(handle);
 	if (!dev)
 		return NULL;
 
@@ -297,6 +298,9 @@ struct device **dock_link_device(acpi_handle handle)
 		return NULL;
 	}
 
+	devices = kmalloc(dock_station_count * sizeof(struct device *),
+			  GFP_KERNEL);
+
 	list_for_each_entry(dock_station, &dock_stations, sibling) {
 		if (find_dock_dependent_device(dock_station, handle)) {
 			ret = sysfs_create_link(&dock_station->dock_device->dev.kobj,
@@ -320,13 +324,15 @@ EXPORT_SYMBOL_GPL(dock_link_device);
  */
 struct device **dock_unlink_device(acpi_handle handle)
 {
-	struct device *dev = acpi_get_physical_device(handle);
+	struct device *dev;
 	struct dock_station *dock_station;
 	int dock = 0;
-	struct device **devices =
-		kmalloc(dock_station_count * sizeof(struct device *),
-			GFP_KERNEL);
+	struct device **devices;
+
+	if (!dock_station_count)
+		return NULL;
 
+	dev = acpi_get_physical_device(handle);
 	if (!dev)
 		return NULL;
 
@@ -335,6 +341,9 @@ struct device **dock_unlink_device(acpi_handle handle)
 		return NULL;
 	}
 
+	devices = kmalloc(dock_station_count * sizeof(struct device *),
+			  GFP_KERNEL);
+
 	list_for_each_entry(dock_station, &dock_stations, sibling) {
 		if (find_dock_dependent_device(dock_station, handle)) {
 			sysfs_remove_link(&dock_station->dock_device->dev.kobj,
-- 
1.7.7

