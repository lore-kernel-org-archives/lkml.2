Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228Ab1ISReD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 13:34:03 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:57636 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752967Ab1ISReB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 13:34:01 -0400
Date: Mon, 19 Sep 2011 13:33:53 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH] sysfs: add per pci device msi[x] irq listing (v3)
Message-ID: <20110919173353.GB27819@hmsreliant.think-freely.org>
References: <1316025413-5855-1-git-send-email-nhorman@tuxdriver.com>
 <1316447235-31345-1-git-send-email-nhorman@tuxdriver.com>
 <20110919171411.GD31542@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110919171411.GD31542@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.6 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 19, 2011 at 10:14:11AM -0700, Greg KH wrote:
> On Mon, Sep 19, 2011 at 11:47:15AM -0400, Neil Horman wrote:
> > So a while back, I wanted to provide a way for irqbalance (and other apps) to
> > definitively map irqs to devices, which, for msi[x] irqs is currently not really
> > possible in user space.  My first attempt wen't not so well:
> > https://lkml.org/lkml/2011/4/21/308
> > 
> > It was plauged by the same issues that prior attempts were, namely that it
> > violated the one-file-one-value sysfs rule.  I wandered off but have recently
> > come back to this.  I've got a new implementation here that exports a new
> > subdirectory for every pci device,  called msi_irqs.  This subdirectory contanis
> > a variable number of numbered subdirectories, in which the number represents an
> > msi irq.  Each numbered subdirectory contains attributes for that irq, which
> > currently is only the mode it is operating in (msi vs. msix).  I think fits
> > within the constraints sysfs requires, and will allow irqbalance to properly map
> > msi irqs to devices without having to rely on rickety, best guess methods like
> > interface name matching.
> > 
> > Change Notes:
> > 
> > (v2)
> > Fixed up Documentation to put new sysfs interface descriptions in the right
> > place, as per request by Greg K-H
> > 
> > Fixed up oops that resulted from removing pci device.  Not 100% sure I did this
> > exactly right, but looking at the crash (triggered by echo 1 >
> > /sys/class/net/eth0/device/remove), it looked as though we were freeing the
> > pci_dev struct prior to all sysfs objects releasing their use of the device.  AS
> > such it seemed most appropriate to hold references on the pci_dev for each msi
> > irq sysfs object that we create, and release them on free accordingly.  With
> > this change in place, I can remove, and add (via rescan) msi enabled devices
> > ad-nauseum without a panic.  Again thanks to Greg K-H
> > 
> > (v3)
> > As per Gregs suggestion, I looked further and noted that in fact, yes, it wasn't
> > producing any errors on remove, but only because I had a refcounting problem,
> > and my new sysfs objects were left orphaned with a dangling refcount.  I've
> > fixed that, added a release method to the new ktype, which now drops the
> > reference I hold on the pci_dev for us and I've validated that all objects I've
> > created, along with the parent directory and pci device are cleaned up and freed
> > by enabling the kobject dyanic_debug set and observing the appropriate release
> > calls.  I can provide the logs if anyone wants to review them specifically.
> 
> Wonderful, thanks for doing this, the code now looks fine to me, and if
> the PCI maintainer has no objections to it, feel free to add my:
> 	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
> to it.
> 
> nice job, thanks for sticking with it.
> 
No problem, thanks for your reviews!
Neil

> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
