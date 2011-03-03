Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932395Ab1CCVNs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 16:13:48 -0500
Received: from kroah.org ([198.145.64.141]:33849 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932290Ab1CCVNr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 16:13:47 -0500
Date: Thu, 3 Mar 2011 13:13:36 -0800
From: Greg KH <greg@kroah.com>
To: Matthew Wilcox <willy@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [REVIEW] NVM Express driver
Message-ID: <20110303211336.GA32645@kroah.com>
References: <20110303204749.GY3663@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110303204749.GY3663@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 03, 2011 at 03:47:49PM -0500, Matthew Wilcox wrote:
> 
> Hi everyone,
> 
> You may have seen the recent announcement of the NVM Express spec;
> here's the driver.  I've put a git tree up on kernel.org with
> all the history that's fit to be released (earlier versions
> were full of Intel codenames and are not suited to public
> consumption).  If you'd rather review the history, it's at
> http://git.kernel.org/?p=linux/kernel/git/willy/nvme.git;a=summary
> 
> Jens has already offered to pull my nvme tree into his block tree, so
> that's the route I intend to take into Linus' tree.  Comments appreciated,
> however in a masterpiece of bad timing I am going to be travelling for
> the next week, so please bear with me if I don't respond quickly.
> 
> diff --git a/Documentation/ioctl/ioctl-number.txt b/Documentation/ioctl/ioctl-number.txt
> index 63ffd78..f8159ba 100644
> --- a/Documentation/ioctl/ioctl-number.txt
> +++ b/Documentation/ioctl/ioctl-number.txt
> @@ -148,6 +148,7 @@ Code  Seq#(hex)	Include File		Comments
>  'M'	01-03	drivers/scsi/megaraid/megaraid_sas.h
>  'M'	00-0F	drivers/video/fsl-diu-fb.h	conflict!
>  'N'	00-1F	drivers/usb/scanner.h
> +'N'	40-7F	drivers/block/nvme.c

I hate to ask this, but why do you have ioctls for this?  At first
glance, a number of the ioctls you have should just be sysfs files to
export the information.  What am I misunderstanding here?

> +static int nvme_download_firmware(struct nvme_ns *ns,
> +						struct nvme_dlfw __user *udlfw)
> +{
> +	struct nvme_dev *dev = ns->dev;
> +	struct nvme_dlfw dlfw;
> +	struct nvme_command c;
> +	int nents, status;
> +	struct scatterlist *sg;
> +	struct nvme_prps *prps;
> +
> +	if (copy_from_user(&dlfw, udlfw, sizeof(dlfw)))
> +		return -EFAULT;
> +	if (dlfw.length >= (1 << 30))
> +		return -EINVAL;
> +
> +	nents = nvme_map_user_pages(dev, 1, dlfw.addr, dlfw.length * 4, &sg);
> +	if (nents < 0)
> +		return nents;
> +
> +	memset(&c, 0, sizeof(c));
> +	c.dlfw.opcode = nvme_admin_download_fw;
> +	c.dlfw.numd = cpu_to_le32(dlfw.length);
> +	c.dlfw.offset = cpu_to_le32(dlfw.offset);
> +	prps = nvme_setup_prps(dev, &c.common, sg, dlfw.length * 4);
> +
> +	status = nvme_submit_admin_cmd(dev, &c, NULL);
> +	nvme_unmap_user_pages(dev, 0, dlfw.addr, dlfw.length * 4, sg, nents);
> +	nvme_free_prps(dev, prps);
> +	return status;
> +}

Shouldn't you be using the build-in firmware kernel interface instead of
rolling your own in an ioctl?

thanks,

greg k-h
