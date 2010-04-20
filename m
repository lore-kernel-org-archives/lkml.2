Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754962Ab0DTRgE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 13:36:04 -0400
Received: from 8bytes.org ([88.198.83.132]:57263 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754928Ab0DTRgB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 13:36:01 -0400
Date: Tue, 20 Apr 2010 19:35:59 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Greg KH <greg@kroah.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: pci_get_dev_by_id() from interrupt handlers
Message-ID: <20100420173552.GA15669@8bytes.org>
References: <20100420160423.GD31537@amd.com> <20100420163215.GB3270@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100420163215.GB3270@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 20, 2010 at 09:32:15AM -0700, Greg KH wrote:
> On Tue, Apr 20, 2010 at 06:04:24PM +0200, Joerg Roedel wrote:
> > Hi Jesse,
> > 
> > I have a question regarding the warning in the pci_get_dev_by_id()
> > [search.c] function which triggers when called from interrupt context.
> > As far as I have seen this function should be save to be called in
> > atomic mode.
> 
> Are you sure?

Not anymore. You proved me wrong ;-)

> > Is there any other reason it should not be called in interrupt
> > handlers?
> 
> klist traversal is not safe to be done in interrupt context as the
> spinlock is not told to be interrupt safe.  Now you could go and change
> the klist core to be interrupt safe, but you should probably rethink
> your need here first.

The idea was to capture IO page faults in the IOMMU and propagate them
to KVM instead of just printk into dmesg. KVM could do something better
then like killing the guest. Currently a malicious guest could flood
host dmesg by causing IO page faults.
For the AMD IOMMU the page faults are reported in an event log and the
cpu is informed by an interrupt about it. The event log entry contains
the bus/dev/function of the device. To get the necessary information to
propagate this to KVM I need to get the 'struct device' for it.
I could certainly do this in a tasklet instead but doing that only for
the task of converting bus/device/function into 'struct device' sounds
a bit complicated to me.

Regards,

	Joerg

