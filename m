Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751613Ab2KQLUZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 06:20:25 -0500
Received: from ogre.sisk.pl ([193.178.161.156]:50568 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750742Ab2KQLUW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 06:20:22 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Cc: Jean Delvare <khali@linux-fr.org>, ben-linux@fluff.org,
        w.sang@pengutronix.de, linux-kernel@vger.kernel.org, lenb@kernel.org,
        rafael.j.wysocki@intel.com, broonie@opensource.wolfsonmicro.com,
        grant.likely@secretlab.ca, linus.walleij@linaro.org,
        mathias.nyman@linux.intel.com, linux-acpi@vger.kernel.org
Subject: Re: [PATCH v2 3/3 UPDATED] i2c / ACPI: add ACPI enumeration support
Date: Sat, 17 Nov 2012 12:24:45 +0100
Message-ID: <3790210.BPELRzTIaN@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.7.0-rc5; KDE/4.8.5; x86_64; ; )
In-Reply-To: <20121117080354.GB17774@intel.com>
References: <1352977397-2280-1-git-send-email-mika.westerberg@linux.intel.com> <CAErSpo6f4LtW0Sm8hs8bToyN8r8AhzrovJ_ybv62qDGP6+ABPA@mail.gmail.com> <20121117080354.GB17774@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, November 17, 2012 10:03:54 AM Mika Westerberg wrote:
> On Fri, Nov 16, 2012 at 11:46:40PM -0700, Bjorn Helgaas wrote:

[...]

> > In any event, after acpi_i2c_register(), I think we have a set of
> > i2c_client devices (with the above namespace, I assume we'd have two
> > of them).  I guess acpi_i2c_find_device() is useful now -- it looks
> > like it takes a "struct device *" (e.g., &client->dev from a struct
> > i2c_client), and and gives you back the acpi_handle corresponding to
> > it?
> > 
> > Here's the callchain of that path:
> > 
> >     acpi_i2c_find_device(struct device *)       # acpi_i2c_bus.find_device
> >       i2c_verify_client(dev)
> >       acpi_walk_namespace
> >         acpi_i2c_find_child
> >           acpi_bus_get_device
> >           acpi_bus_get_status
> >           acpi_dev_get_resources(..., acpi_i2c_find_child_address, ...)
> >             acpi_i2c_find_child_address
> >             found if (SERIAL_BUS && SERIAL_TYPE_I2C && slave_address == xx)
> >           acpi_dev_free_resource_list
> >       *handle = handle
> > 
> > That seems like an awful lot of work to do just to map a struct device
> > * back to the acpi_handle.  But I don't have any suggestion; just that
> > observation.
> 
> We had similar discussion internally about not using that
> drivers/acpi/glue.c but we decided to use it for now, even if it really
> backwards and makes things hard (like you observed as well). A much better
> way would be just to assign the handle once we make the device but it
> seemed not to be that simple after all.

The problem basically is that acpi_bind_one() creates the "physical_node"
and "firmware_node" sysfs files, so both directories of the device nodes
involved need to exist at this point.  Moreover, we want it to be called
before a driver is probed, so that the driver's .probe() routine can use
the information available from ACPI.  This means it needs to be called
from device_add() and more-or-less where platform_notify() is called.

That's the reason why we decided to use the code in glue.c for the time
being.  If you see a better way to do that, however, I'll be happy to
implement it. :-)

Well, maybe there is one.  Perhaps we can make acpi_platform_notify() 
call acpi_bind_one() upfront and only if that fails, do the whole
type->find_device() dance?  Of course, acpi_bind_one() would need to
be modified slightly too, like in the patch below.

If we did that, acpi_i2c_add_device() would only need to assign acpi_handle
as appropriate before calling i2c_new_device() (and analogously for SPI).

What do you think? 

Rafael


---
 drivers/acpi/glue.c |   40 +++++++++++++++++++++++++++++++---------
 1 file changed, 31 insertions(+), 9 deletions(-)

Index: linux/drivers/acpi/glue.c
===================================================================
--- linux.orig/drivers/acpi/glue.c
+++ linux/drivers/acpi/glue.c
@@ -135,8 +135,12 @@ static int acpi_bind_one(struct device *
 	int retval = -EINVAL;
 
 	if (dev->acpi_handle) {
-		dev_warn(dev, "Drivers changed 'acpi_handle'\n");
-		return -EINVAL;
+		if (handle) {
+			dev_warn(dev, "ACPI handle is already set\n");
+			return -EINVAL;
+		} else {
+			handle = dev->acpi_handle;
+		}
 	}
 
 	get_device(dev);
@@ -144,32 +148,40 @@ static int acpi_bind_one(struct device *
 	if (ACPI_FAILURE(status))
 		goto err;
 
-	physical_node = kzalloc(sizeof(struct acpi_device_physical_node),
-		GFP_KERNEL);
+	physical_node = kzalloc(sizeof(*physical_node), GFP_KERNEL);
 	if (!physical_node) {
 		retval = -ENOMEM;
 		goto err;
 	}
 
 	mutex_lock(&acpi_dev->physical_node_lock);
+
+	/* Sanity check. */
+	list_for_each_entry(physical_node, &acpi_dev->physical_node_list, node)
+		if (physical_node->dev == dev) {
+			dev_warn(dev, "Already associated with ACPI node\n");
+			retval = -EINVAL;
+			goto err_free;
+		}
+
 	/* allocate physical node id according to physical_node_id_bitmap */
 	physical_node->node_id =
 		find_first_zero_bit(acpi_dev->physical_node_id_bitmap,
 		ACPI_MAX_PHYSICAL_NODE);
 	if (physical_node->node_id >= ACPI_MAX_PHYSICAL_NODE) {
 		retval = -ENOSPC;
-		mutex_unlock(&acpi_dev->physical_node_lock);
-		kfree(physical_node);
-		goto err;
+		goto err_free;
 	}
 
 	set_bit(physical_node->node_id, acpi_dev->physical_node_id_bitmap);
 	physical_node->dev = dev;
 	list_add_tail(&physical_node->node, &acpi_dev->physical_node_list);
 	acpi_dev->physical_node_count++;
+
 	mutex_unlock(&acpi_dev->physical_node_lock);
 
-	dev->acpi_handle = handle;
+	if (!dev->acpi_handle)
+		dev->acpi_handle = handle;
 
 	if (!physical_node->node_id)
 		strcpy(physical_node_name, PHYSICAL_NODE_STRING);
@@ -189,6 +201,11 @@ static int acpi_bind_one(struct device *
  err:
 	put_device(dev);
 	return retval;
+
+ err_free:
+	mutex_unlock(&acpi_dev->physical_node_lock);
+	kfree(physical_node);
+	goto err;
 }
 
 static int acpi_unbind_one(struct device *dev)
@@ -247,6 +264,10 @@ static int acpi_platform_notify(struct d
 	acpi_handle handle;
 	int ret = -EINVAL;
 
+	ret = acpi_bind_one(dev, NULL);
+	if (!ret)
+		goto out;
+
 	if (!dev->bus || !dev->parent) {
 		/* bridge devices genernally haven't bus or parent */
 		ret = acpi_find_bridge_device(dev, &handle);
@@ -260,10 +281,11 @@ static int acpi_platform_notify(struct d
 	}
 	if ((ret = type->find_device(dev, &handle)) != 0)
 		DBG("Can't get handler for %s\n", dev_name(dev));
-      end:
+ end:
 	if (!ret)
 		acpi_bind_one(dev, handle);
 
+ out:
 #if ACPI_GLUE_DEBUG
 	if (!ret) {
 		struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
