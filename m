Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238Ab1IVOca (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 10:32:30 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:49228 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752650Ab1IVOc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 10:32:28 -0400
Date: Thu, 22 Sep 2011 10:32:02 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org
Subject: Re: [PATCH] sysfs: add per pci device msi[x] irq listing (v3)
Message-ID: <20110922143202.GC13359@shamino.rdu.redhat.com>
References: <1316025413-5855-1-git-send-email-nhorman@tuxdriver.com>
 <1316447235-31345-1-git-send-email-nhorman@tuxdriver.com>
 <20110922135428.GC16740@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110922135428.GC16740@parisc-linux.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -3.5 (---)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 22, 2011 at 07:54:28AM -0600, Matthew Wilcox wrote:
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
> 
> This approach feels like building bigger rockets instead of a space
> elevator :-)
> 
In which case your comments make me think that you're trying to build the
Death Star instead of buying more tie fighters :)
https://docs.google.com/viewer?url=http://www.dau.mil/pubscats/ATL%20Docs/Sep-Oct11/Ward.pdf

> What we need is to allow device drivers to ask for per-CPU interrupts,
> and implement them in terms of MSI-X.  I've made a couple of stabs at
> implementing this, but haven't got anything working yet.  It would solve
Yes, IIRC you were trying to do this the first time I proposed this:
https://lkml.org/lkml/2011/4/21/315

> a number of problems:
> 
Thats great, I don't see how this precludes what I'm trying to do here.  All
this patch does is expose a definitive relationship between msi irqs and the pci
devices that allocate them.  The kernel internal model used to allocate msi
interrupts can change, the kobject creation and removal just has to change with
it (presumably to create and destroy the msi irq kobjects when the individual
irqs are allocated/freed, rather than in a batch).  I don't see why we should
block enhancements to the existing msi implementation until you get new model
sorted, especially when this feature works equally well, despite the model we
use internally.
