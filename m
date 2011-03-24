Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756567Ab1CXJax (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 05:30:53 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:46574 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756057Ab1CXJaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 05:30:52 -0400
Date: Thu, 24 Mar 2011 09:30:36 +0000
From: Jamie Iles <jamie@jamieiles.com>
To: linux-kernel@vger.kernel.org
Cc: Greg KH <gregkh@suse.de>
Subject: Re: [RFC PATCH 1/2] picoxcell-otp: add support for picoxcell OTP
 devices
Message-ID: <20110324093035.GA3130@pulham.picochip.com>
References: <1300882619-19152-1-git-send-email-jamie@jamieiles.com>
 <1300882619-19152-2-git-send-email-jamie@jamieiles.com>
 <20110323144230.GD17369@suse.de>
 <20110323151242.GC2795@pulham.picochip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110323151242.GC2795@pulham.picochip.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replying to myself...

On Wed, Mar 23, 2011 at 03:12:42PM +0000, Jamie Iles wrote:
> On Wed, Mar 23, 2011 at 07:42:30AM -0700, Greg KH wrote:
> > On Wed, Mar 23, 2011 at 12:16:58PM +0000, Jamie Iles wrote:
> > > +What:           /sys/bus/picoxcell-otp/devices/.../size
> > > +Date:           March 2011
> > > +KernelVersion:  2.6.40+
> > > +Contact:        Jamie Iles <jamie@jamieiles.com>
> > > +Description:
> > > +                The effective storage size of the region. This is the amount
> > > +		of data that a user can store in the region taking into
> > > +		account the number of regions and the redundancy format of the
> > > +		region itself.
> > > diff --git a/Documentation/ABI/testing/sysfs-platform-picoxcell-otp b/Documentation/ABI/testing/sysfs-platform-picoxcell-otp
> > > new file mode 100644
> > > index 0000000..e5ee711
> > > --- /dev/null
> > > +++ b/Documentation/ABI/testing/sysfs-platform-picoxcell-otp
> > > @@ -0,0 +1,39 @@
> > > +What:		/sys/devices/platform/picoxcell-otp*/write_enable
> > 
> > Why are these in a platform subdirectory?  Shouldn't they be the devices
> > listed above in the previous file?
> 
> So the way I have it is that there is the real OTP device which can be 
> split into a number of regions.  These attributes affect the physical 
> device by programming the number of regions and write enable.
> 
> Each region is a virtual device to provide the character device and the 
> redundancy/size attributes but you can't split these regions down again.

[...]

> > > +/*
> > > + * Add all of the device entries to sysfs. This also includes creating the
> > > + * region device nodes and sysfs entries.
> > > + */
> > > +static int otp_sysfs_add(struct device *dev)
> > > +{
> > > +	int err;
> > > +
> > > +	err = device_create_file(dev, &dev_attr_write_enable);
> > > +	if (err)
> > > +		goto out;
> > > +
> > > +	err = device_create_file(dev, &dev_attr_num_regions);
> > > +	if (err)
> > > +		goto num_regions_fail;
> > > +
> > > +	err = device_create_file(dev, &dev_attr_bad_words);
> > > +	if (err)
> > > +		goto bad_words_fail;
> > > +
> > > +	err = device_create_file(dev, &dev_attr_strict_programming);
> > > +	if (err)
> > > +		goto strict_programming_fail;
> > > +
> > 
> > Shouldn't all of these be in an attribute group like the other sysfs
> > files are in this driver?  That way you add/remove them all at once.
> 
> I did look at doing this but I couldn't see a way to add an attribute 
> group to an existing device in a single step, or is this just the 
> wrong approach all together?

So the crucial thing I was missing was the device_type part of the 
driver model.  I'm now creating a virtual "otpa" device that is in the 
"otp" bus and has the regions has virtual child devices.   Both of these 
virtual devices have different device_types that have different 
attributes so that fits in very nicely.

Jamie
