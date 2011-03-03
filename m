Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758859Ab1CCVlY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 16:41:24 -0500
Received: from mga03.intel.com ([143.182.124.21]:32573 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754793Ab1CCVlX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 16:41:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,260,1297065600"; 
   d="scan'208";a="397209384"
Date: Thu, 3 Mar 2011 16:41:04 -0500
From: Matthew Wilcox <willy@linux.intel.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [REVIEW] NVM Express driver
Message-ID: <20110303214104.GZ3663@linux.intel.com>
References: <20110303204749.GY3663@linux.intel.com>
 <20110303211336.GA32645@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110303211336.GA32645@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 03, 2011 at 01:13:36PM -0800, Greg KH wrote:
> > diff --git a/Documentation/ioctl/ioctl-number.txt b/Documentation/ioctl/ioctl-number.txt
> > index 63ffd78..f8159ba 100644
> > --- a/Documentation/ioctl/ioctl-number.txt
> > +++ b/Documentation/ioctl/ioctl-number.txt
> > @@ -148,6 +148,7 @@ Code  Seq#(hex)	Include File		Comments
> >  'M'	01-03	drivers/scsi/megaraid/megaraid_sas.h
> >  'M'	00-0F	drivers/video/fsl-diu-fb.h	conflict!
> >  'N'	00-1F	drivers/usb/scanner.h
> > +'N'	40-7F	drivers/block/nvme.c
> 
> I hate to ask this, but why do you have ioctls for this?  At first
> glance, a number of the ioctls you have should just be sysfs files to
> export the information.  What am I misunderstanding here?

I don't think you're arguing for SUBMIT_IO being done through sysfs, so
some ioctls are clearly needed.  I'll take a look at which ones can be
moved to sysfs.

> > +static int nvme_download_firmware(struct nvme_ns *ns,
> > +						struct nvme_dlfw __user *udlfw)
> > +{
> > +	struct nvme_dev *dev = ns->dev;
> > +	struct nvme_dlfw dlfw;
> > +	struct nvme_command c;
> > +	int nents, status;
> > +	struct scatterlist *sg;
> > +	struct nvme_prps *prps;
> > +
> > +	if (copy_from_user(&dlfw, udlfw, sizeof(dlfw)))
> > +		return -EFAULT;
> > +	if (dlfw.length >= (1 << 30))
> > +		return -EINVAL;
> > +
> > +	nents = nvme_map_user_pages(dev, 1, dlfw.addr, dlfw.length * 4, &sg);
> > +	if (nents < 0)
> > +		return nents;
> > +
> > +	memset(&c, 0, sizeof(c));
> > +	c.dlfw.opcode = nvme_admin_download_fw;
> > +	c.dlfw.numd = cpu_to_le32(dlfw.length);
> > +	c.dlfw.offset = cpu_to_le32(dlfw.offset);
> > +	prps = nvme_setup_prps(dev, &c.common, sg, dlfw.length * 4);
> > +
> > +	status = nvme_submit_admin_cmd(dev, &c, NULL);
> > +	nvme_unmap_user_pages(dev, 0, dlfw.addr, dlfw.length * 4, sg, nents);
> > +	nvme_free_prps(dev, prps);
> > +	return status;
> > +}
> 
> Shouldn't you be using the build-in firmware kernel interface instead of
> rolling your own in an ioctl?

There's a bit of an impedence mismatch there.  Think of this as
being drive firmware instead of controller firmware.  This isn't for
request_firmware() kind of uses, it's for some admin tool to come along
and tell the drive "Oh, here's some new firmware for you".

If you look at the spec [1], you'll see there are a number of firmware
slots in the device, and it's up to the managability utility to decide
which one to replace or activate.  I dno't think you want to pull all
that gnarly decision making code into the kernel, do you?

[1] http://download.intel.com/standards/nvmhci/NVM_Express_1_0_Gold.pdf
