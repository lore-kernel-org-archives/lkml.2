Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295Ab1HJJvF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 05:51:05 -0400
Received: from exprod5og116.obsmtp.com ([64.18.0.147]:59406 "EHLO
	exprod5og116.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753046Ab1HJJvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 05:51:04 -0400
Message-ID: <4E425483.2050400@ge.com>
Date: Wed, 10 Aug 2011 10:50:59 +0100
From: Martyn Welch <martyn.welch@ge.com>
Organization: GE Intelligent Platforms
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: "Emilio G. Cota" <cota@braap.org>
CC: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/8] staging: vme: add functions for bridge module refcounting
References: <20110805174728.GA1741@flamenco.cs.columbia.edu> <4E3F97EA.2020600@ge.com> <20110808091432.GA19570@flamenco.cs.columbia.edu> <4E3FABDA.8080204@ge.com> <20110808101140.GA21300@flamenco.cs.columbia.edu> <4E3FC33D.2080202@ge.com> <20110808172216.GA2311@flamenco.cs.columbia.edu> <4E40F719.1020100@ge.com> <20110809191915.GB28746@flamenco.cs.columbia.edu> <4E42359B.2050105@ge.com> <20110810091550.GA383@flamenco.cs.columbia.edu>
In-Reply-To: <20110810091550.GA383@flamenco.cs.columbia.edu>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Aug 2011 09:47:41.0592 (UTC) FILETIME=[8C0B7180:01CC5742]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/08/11 10:15, Emilio G. Cota wrote:
> On Wed, Aug 10, 2011 at 08:39:07 +0100, Martyn Welch wrote:
>> And I think you need to go and do a grep of the code and find out where those
>> functions are actually used, rather than blindly relying on the comment.
> (snip)
>> Go grep the code.
> 
> /me greps once again..
> 
> RapidIO: there are no rapidIO drivers upstream, only switches
> and rionet, which does not manage RapidIO devices (it just sends
> Ethernet packets on top of RapidIO's messaging).  So obviously
> there aren't any callers.
> 

Yes there are. In rio-driver.c for a start:

/**
 *  rio_device_probe - Tell if a RIO device structure has a matching RIO
device id structure
 *  @dev: the RIO device structure to match against
 *
 * return 0 and set rio_dev->driver when drv claims rio_dev, else error
 */
static int rio_device_probe(struct device *dev)
{
        struct rio_driver *rdrv = to_rio_driver(dev->driver);
        struct rio_dev *rdev = to_rio_dev(dev);
        int error = -ENODEV;
        const struct rio_device_id *id;

        if (!rdev->driver && rdrv->probe) {
                if (!rdrv->id_table)
                        return error;
                id = rio_match_device(rdrv->id_table, rdev);
                rio_dev_get(rdev);
                if (id)
                        error = rdrv->probe(rdev, id);
                if (error >= 0) {
                        rdev->driver = rdrv;
                        error = 0;
                } else
                        rio_dev_put(rdev);
        }
        return error;
}

Doing what Manohar suggested and I have agreed with.

> PCI: pci_dev_get() referenced in 60 files.  Another way of
> explicitly incrementing the refcount of a pci device is with
> pci_get_device(), which searches in the device list for a
> particular one by its vendor/device ID.  This function is
> referenced in 127 files.
> 

Again, in pci-driver.c:

static int pci_device_probe(struct device * dev)
{
        int error = 0;
        struct pci_driver *drv;
        struct pci_dev *pci_dev;

        drv = to_pci_driver(dev->driver);
        pci_dev = to_pci_dev(dev);
        pci_dev_get(pci_dev);
        error = __pci_device_probe(drv, pci_dev);
        if (error)
                pci_dev_put(pci_dev);

        return error;
}

Again, doing as Manohar suggested.


For those drivers using pci_get_device() - P313 of the Linux Device Drivers
3rd Ed, under "Old-style PCI Probing". Not a mechanism currently supported for
the VME bus.

> USB: usb_get_dev() referenced in 75 files.
> 

I've already explained that I don't think the USB bus is good for comparison
due to very real differences in bus topology and use.

> There are also lots of direct calls to get_device() from .probe
> methods of devices not tied to a particular bus.
> 

Which may therefore have nothing to do with a bus.

> Guess that was enough grepping.
> 

It seems not quite.

>> Suitable bug fixes are welcome.
> 
> I sent a fix (as part of an admittedly large patchset) in
> Nov 2010[1], ie 9 months ago, you were sick at the time and
> told me you'd have a look at the changes later[2], which
> unfortunately never happened, even after pinging you off-list.
> 

Some of those patches were applied:

http://git.kernel.org/gitweb.cgi?p=linux/kernel/git/gregkh/staging-2.6.git;a=history;f=drivers/staging/vme;hb=HEAD

The remaining patches completely changed the VME bus model. I said at the time
I wasn't overly happy with the model you had put forward. Take this as my review:

- I am not happy with the proposed alternative model.

Sorry for not getting back to you sooner. I'm afraid my TODO list sometimes
ends up acting as a stack rather than a FIFO.

> Anyway let's forget that, Manohar's patches are what matters now.
> 

Will do.

Martyn

-- 
Martyn Welch (Principal Software Engineer) | Registered in England and
GE Intelligent Platforms                   | Wales (3828642) at 100
T +44(0)127322748                          | Barbirolli Square, Manchester,
E martyn.welch@ge.com                      | M2 3AB  VAT:GB 927559189
