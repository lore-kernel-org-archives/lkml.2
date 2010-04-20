Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755066Ab0DTRvc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 13:51:32 -0400
Received: from kroah.org ([198.145.64.141]:59237 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755045Ab0DTRva (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 13:51:30 -0400
Date: Tue, 20 Apr 2010 10:52:02 -0700
From: Greg KH <greg@kroah.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: Joerg Roedel <joerg.roedel@amd.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: pci_get_dev_by_id() from interrupt handlers
Message-ID: <20100420175202.GA4874@kroah.com>
References: <20100420160423.GD31537@amd.com> <20100420163215.GB3270@kroah.com> <20100420173552.GA15669@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100420173552.GA15669@8bytes.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 20, 2010 at 07:35:59PM +0200, Joerg Roedel wrote:
> On Tue, Apr 20, 2010 at 09:32:15AM -0700, Greg KH wrote:
> > On Tue, Apr 20, 2010 at 06:04:24PM +0200, Joerg Roedel wrote:
> > > Is there any other reason it should not be called in interrupt
> > > handlers?
> > 
> > klist traversal is not safe to be done in interrupt context as the
> > spinlock is not told to be interrupt safe.  Now you could go and change
> > the klist core to be interrupt safe, but you should probably rethink
> > your need here first.
> 
> The idea was to capture IO page faults in the IOMMU and propagate them
> to KVM instead of just printk into dmesg. KVM could do something better
> then like killing the guest. Currently a malicious guest could flood
> host dmesg by causing IO page faults.

That's not good.

> For the AMD IOMMU the page faults are reported in an event log and the
> cpu is informed by an interrupt about it. The event log entry contains
> the bus/dev/function of the device. To get the necessary information to
> propagate this to KVM I need to get the 'struct device' for it.

Ok, that's reasonable.

> I could certainly do this in a tasklet instead but doing that only for
> the task of converting bus/device/function into 'struct device' sounds
> a bit complicated to me.

Why not do the whole thing in an interrupt task as the whole thing
sounds like something that shouldn't be done in interrupt context,
right?  Now that we have this type of functionality, we should take
advantage of it :)

Eventually, notifying KVM isn't something that you want to do from
interrupt context anyway, right?

thanks,

greg k-h
