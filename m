Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385Ab2BRSqf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Feb 2012 13:46:35 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:60250 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922Ab2BRSqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Feb 2012 13:46:33 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of hughd@google.com designates 10.68.222.72 as permitted sender) smtp.mail=hughd@google.com; dkim=pass header.i=hughd@google.com
Date: Sat, 18 Feb 2012 10:46:04 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Holger Macht <holger@homac.de>
cc: Hillf Danton <dhillf@gmail.com>, Matthew Garrett <mjg@redhat.com>,
        Jeff Garzik <jgarzik@redhat.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: dock_link_device is oopsy
In-Reply-To: <20120218140449.GA2558@homac.suse.de>
Message-ID: <alpine.LSU.2.00.1202181034380.3512@eggly.anvils>
References: <alpine.LSU.2.00.1202171320590.5994@eggly.anvils> <20120217222922.GA2741@homac.suse.de> <alpine.LSU.2.00.1202171436490.10222@eggly.anvils> <20120217230107.GA12929@homac.suse.de> <alpine.LSU.2.00.1202171541040.3155@eggly.anvils>
 <20120218111419.GA2488@homac.suse.de> <CAJd=RBDRZSizawvRYqr7=U75Su5TLvMfgdagRA49wzJr40DqSg@mail.gmail.com> <20120218132610.GA15265@homac.suse.de> <CAJd=RBAhnsuP4+pRS=MLyOaqx8O1gOR30bcoZC0Owabh1-1nzA@mail.gmail.com> <20120218140449.GA2558@homac.suse.de>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 18 Feb 2012, Holger Macht wrote:
> How about that one?

It's more broken than that.  Here's my attempt.  It boots on the
systems with dock_station_count 0, and it boots on my laptop with
dock_station_count 2; but I don't actually have any docking station,
so it still doesn't test very much (dock is 0 after the loop).

I have no idea if what goes on in the loop is correct, but it looks
to me as if (as predicted) there's further breakage, that it would
have been writing beyond the end of what it allocated if I did have
a docking station.

Hugh

[PATCH] dock: fix bootup oops and other dock_link breakage

dock_link_device() and dock_unlink_device() should bail out early
to avoid oops on zero-length kmalloc() when dock_station_count is 0.

But isn't there an off-by-one in that kmalloc() length anyway?
An extra NULL appended at the end suggests so.

Rework the ordering with gotos on failure to fix several issues.

And presumably dock_unlink_device() should be presenting the same
interface as dock_link_device(), with NULL returned when none found.

Signed-off-by: Hugh Dickins <hughd@google.com>
---

 drivers/acpi/dock.c |   69 +++++++++++++++++++++++++++++-------------
 1 file changed, 49 insertions(+), 20 deletions(-)

--- linux-next/drivers/acpi/dock.c	2012-02-17 08:02:12.280064984 -0800
+++ fixed/drivers/acpi/dock.c	2012-02-18 09:57:54.926244796 -0800
@@ -281,21 +281,25 @@ EXPORT_SYMBOL_GPL(is_dock_device);
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
 
-	if (!dev)
+	if (is_dock(handle))
 		return NULL;
 
-	if (is_dock(handle)) {
-		put_device(dev);
+	dev = acpi_get_physical_device(handle);
+	if (!dev)
 		return NULL;
-	}
+
+	devices = kmalloc((dock_station_count + 1) * sizeof(struct device *),
+			  GFP_KERNEL);
+	if (!devices)
+		goto put;
 
 	list_for_each_entry(dock_station, &dock_stations, sibling) {
 		if (find_dock_dependent_device(dock_station, handle)) {
@@ -304,13 +308,23 @@ struct device **dock_link_device(acpi_ha
 			WARN_ON(ret);
 			devices[dock] = &dock_station->dock_device->dev;
 			dock++;
+			if (dock == dock_station_count)
+				goto out;
 		}
 	}
-	if (!dock)
-		put_device(dev);
 
+	if (!dock)
+		goto free;
+out:
+	/* Keep a reference to the device while the link exists */
 	devices[dock] = NULL;
 	return devices;
+
+free:
+	kfree(devices);
+put:
+	put_device(dev);
+	return NULL;
 }
 EXPORT_SYMBOL_GPL(dock_link_device);
 
@@ -320,20 +334,25 @@ EXPORT_SYMBOL_GPL(dock_link_device);
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
 
-	if (!dev)
+	if (!dock_station_count)
 		return NULL;
 
-	if (is_dock(handle)) {
-		put_device(dev);
+	if (is_dock(handle))
 		return NULL;
-	}
+
+	dev = acpi_get_physical_device(handle);
+	if (!dev)
+		return NULL;
+
+	devices = kmalloc((dock_station_count + 1) * sizeof(struct device *),
+			  GFP_KERNEL);
+	if (!devices)
+		goto put;
 
 	list_for_each_entry(dock_station, &dock_stations, sibling) {
 		if (find_dock_dependent_device(dock_station, handle)) {
@@ -341,15 +360,25 @@ struct device **dock_unlink_device(acpi_
 					  dev_name(dev));
 			devices[dock] = &dock_station->dock_device->dev;
 			dock++;
+			if (dock == dock_station_count)
+				goto out;
 		}
 	}
-	/* An extra reference has been held while the link existed */
-	if (dock)
-		put_device(dev);
 
+	if (!dock)
+		goto free;
+out:
+	/* An extra reference has been held while the link existed */
+	put_device(dev);
 	put_device(dev);
 	devices[dock] = NULL;
 	return devices;
+
+free:
+	kfree(devices);
+put:
+	put_device(dev);
+	return NULL;
 }
 EXPORT_SYMBOL_GPL(dock_unlink_device);
 
