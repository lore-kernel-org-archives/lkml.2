Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751364Ab1HMHrn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Aug 2011 03:47:43 -0400
Received: from statler.bytemark.co.uk ([212.110.162.18]:41599 "EHLO
	statler.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791Ab1HMHrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Aug 2011 03:47:41 -0400
Date: Sat, 13 Aug 2011 03:47:14 -0400
From: "Emilio G. Cota" <cota@braap.org>
To: Manohar Vanga <manohar.vanga@cern.ch>
Cc: martyn.welch@ge.com, gregkh@suse.de, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] staging: vme: add functions for bridge module
 refcounting
Message-ID: <20110813074714.GA32149@flamenco.cs.columbia.edu>
References: <1313145051-13397-1-git-send-email-manohar.vanga@cern.ch>
 <1313145051-13397-4-git-send-email-manohar.vanga@cern.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313145051-13397-4-git-send-email-manohar.vanga@cern.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 12, 2011 at 12:30:49 +0200, Manohar Vanga wrote:
> This patch adds functions that allow for reference counting
> bridge modules. The patch introduces the functions
> 'vme_bridge_get()' and 'vme_bridge_put()'.
> 
> The functions are automatically called during .probe and .remove
> for drivers.
(snip)
> @@ -52,6 +52,48 @@ static struct vme_bridge *dev_to_bridge(struct device *dev)
(snip)
> +int vme_bridge_get(unsigned int bus_id)

If it isn't exported, it should be declared as static.

> +{
> +	int ret = -1;

hmm perhaps -ENXIO here would be better, since the outcome
of this function is either that or success.

> +	struct vme_bridge *bridge;
> +
> +	mutex_lock(&vme_buses_lock);
> +	list_for_each_entry(bridge, &vme_bus_list, bus_list) {
> +		if (bridge->num == bus_id) {
> +			if (!bridge->owner)
> +				dev_warn(bridge->parent,
> +					"bridge->owner not set\n");

Don't do this; it will throw a false warning if the kernel is
built without module support. Note that in that case

	THIS_MODULE == (struct module *)0.

try_module_get() and module_put() do the right thing for all
possible configs. Trust them.

> +			else if (try_module_get(bridge->owner))
> +				ret = 0;
> +			break;
> +void vme_bridge_put(struct vme_bridge *bridge)

should be static as well

> +{
> +	if (!bridge->owner)
> +		dev_warn(bridge->parent, "bridge->owner not set\n");
> +	else
> +		module_put(bridge->owner);

ditto, remove the warning.

> +
> +/*
>   * Find the bridge that the resource is associated with.
>   */
>  static struct vme_bridge *find_bridge(struct vme_resource *resource)
> @@ -1496,14 +1538,20 @@ static int vme_bus_probe(struct device *dev)
>  {
>  	struct vme_bridge *bridge;
>  	struct vme_driver *driver;
> -	int retval = -ENODEV;
> +	int retval = 0;
>  
>  	driver = dev_to_vme_driver(dev);
>  	bridge = dev_to_bridge(dev);
>  
> +	if (vme_bridge_get(bridge->num))
> +		return -ENXIO;
> +
>  	if (driver->probe != NULL)
>  		retval = driver->probe(dev, bridge->num, vme_calc_slot(dev));
>  
> +	if (driver->probe && retval)
> +		vme_bridge_put(bridge);

If the driver doesn't provide a .probe, we would still increment
the refcount of the bridge module. Is that reasonable? I dunno.

If there's no .probe then the device is doing something
weird, and probably either it doesn't have much to do with a
particular bridge (i.e. it manages no "real" devices) or
it'd need to manage its own resources (in which case we could
easily export vme_bridge_get/put.)

Perhaps then the following would be more appropriate,
what do you think?

+	if (driver->probe) {
+		if (vme_bridge_get(bridge->num))
+			return -ENXIO; /* although this could change, see above comment */
+
 		retval = driver->probe(dev, bridge->num, vme_calc_slot(dev));
+		if (retval)
+			vme_bridge_put(bridge);
+	}
+
 	return retval;

.. and then remember to do
+ 	if (probe)
+ 		vme_bridge_put(bridge)
in vme_bus_remove(), which in your patch is unconditional (correctly
matching the unconditional get() in vme_bus_probe)

> @@ -1519,6 +1567,8 @@ static int vme_bus_remove(struct device *dev)
>  	if (driver->remove != NULL)
>  		retval = driver->remove(dev, bridge->num, vme_calc_slot(dev));
>  
> +	vme_bridge_put(bridge);
> +
>  	return retval;
>  }
> diff --git a/drivers/staging/vme/vme.h b/drivers/staging/vme/vme.h
> index 4155d8c..eb00a5e 100644
> --- a/drivers/staging/vme/vme.h
> +++ b/drivers/staging/vme/vme.h
> @@ -165,6 +165,5 @@ int vme_slot_get(struct device *);
>  int vme_register_driver(struct vme_driver *);
>  void vme_unregister_driver(struct vme_driver *);
>  
> -
>  #endif /* _VME_H_ */

I'm certainly no checkpatch taliban, but guess you probably
didn't want to send this line change.

Cheers

		Emilio

