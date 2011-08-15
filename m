Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751842Ab1HOKIQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 06:08:16 -0400
Received: from cernmx30.cern.ch ([137.138.144.177]:48704 "EHLO
	CERNMX30.cern.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351Ab1HOKIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 06:08:15 -0400
Date: Mon, 15 Aug 2011 12:05:03 +0200
From: Manohar Vanga <manohar.vanga@cern.ch>
To: "Emilio G. Cota" <cota@braap.org>
CC: <martyn.welch@ge.com>, <gregkh@suse.de>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/5] staging: vme: add functions for bridge module
 refcounting
Message-ID: <20110815100503.GA22344@becoht-mvanga>
Mail-Followup-To: "Emilio G. Cota" <cota@braap.org>, martyn.welch@ge.com,
	gregkh@suse.de, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
References: <1313145051-13397-1-git-send-email-manohar.vanga@cern.ch>
 <1313145051-13397-4-git-send-email-manohar.vanga@cern.ch>
 <20110813074714.GA32149@flamenco.cs.columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110813074714.GA32149@flamenco.cs.columbia.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [137.138.192.18]
Keywords: CERN SpamKiller Note: -50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If the driver doesn't provide a .probe, we would still increment
> the refcount of the bridge module. Is that reasonable? I dunno.
> 
> If there's no .probe then the device is doing something
> weird, and probably either it doesn't have much to do with a
> particular bridge (i.e. it manages no "real" devices) or
> it'd need to manage its own resources (in which case we could
> easily export vme_bridge_get/put.)
> 
> Perhaps then the following would be more appropriate,
> what do you think?
> 
> +	if (driver->probe) {
> +		if (vme_bridge_get(bridge->num))
> +			return -ENXIO; /* although this could change, see above comment */
> +
>  		retval = driver->probe(dev, bridge->num, vme_calc_slot(dev));
> +		if (retval)
> +			vme_bridge_put(bridge);
> +	}
> +
>  	return retval;
> 
> .. and then remember to do
> + 	if (probe)
> + 		vme_bridge_put(bridge)
> in vme_bus_remove(), which in your patch is unconditional (correctly
> matching the unconditional get() in vme_bus_probe)

I picked this default behaviour from the PCI driver code (drivers/pci/pci-driver.c):

	static int pci_device_probe(struct device * dev)
	{
		...
		pci_dev_get(pci_dev);
		error = __pci_device_probe(drv, pci_dev);
		if (error)
			pci_dev_put(pci_dev);
	
		return error;
	}

The __pci_device_probe() function checks if probe is present or not.

> I'm certainly no checkpatch taliban, but guess you probably
> didn't want to send this line change.

Gak! Will cleanup and resend.

--
/manohar
