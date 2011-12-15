Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932624Ab1LOQBp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 11:01:45 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:47477 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932541Ab1LOQBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 11:01:42 -0500
Date: Thu, 15 Dec 2011 11:01:41 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
cc: Clemens Ladisch <clemens@ladisch.de>, Greg Kroah-Hartman <gregkh@suse.de>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: fix number of mapped SG DMA entries
In-Reply-To: <20111215123927.GA19650@linutronix.de>
Message-ID: <Pine.LNX.4.44L0.1112151058090.1644-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Dec 2011, Sebastian Andrzej Siewior wrote:

> * Alan Stern | 2011-12-04 11:59:32 [-0500]:
> 
> >On Sat, 3 Dec 2011, Clemens Ladisch wrote:
> >
> >> Add a new field num_mapped_sgs to struct urb so that we have a place to
> >> store the number of mapped entries and can also retain the original
> >> value of entries in num_sgs.  Previously, usb_hcd_map_urb_for_dma()
> >> would overwrite this with the number of mapped entries, which would
> >> break dma_unmap_sg() because it requires the original number of entries.
> >> 
> >> This fixes warnings like the following when using USB storage devices:
> >>  ------------[ cut here ]------------
> >>  WARNING: at lib/dma-debug.c:902 check_unmap+0x4e4/0x695()
> >>  ehci_hcd 0000:00:12.2: DMA-API: device driver frees DMA sg list with different entry count [map count=4] [unmap count=1]
> >
> >Interesting.  Do you have any idea why this warning didn't show up 
> >earlier?  Is there perhaps a Kconfig option I ought to be using?
> 
> My question here is why don't we map the complete sg list but only
> one entry. What happens to the remaining few sg list entries? Don't we
> sent too less data?

I don't know exactly what happened in this particular case -- probably 
there's no way to find out.  However, all the data is supposed to be 
mapped, regardless of the number of entries.

> Is there anything special you do to get into this kind of situation?
> Like 16GiB of memory on 32bit with highmem and a brutal disk/io test
> case so?

As I understand it, the typical case is that two SG entries in a row 
refer to adjacent pages of physical memory.  The mapping routine then 
collapses them into a single entry referring to all the pages.

However, this is not the sort of thing you can deliberately cause, 
unless you set up your SG list by hand.

Alan Stern

