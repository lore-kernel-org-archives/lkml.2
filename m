Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429Ab3AJSUc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 13:20:32 -0500
Received: from quartz.orcorp.ca ([184.70.90.242]:45796 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752388Ab3AJSU3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 13:20:29 -0500
Date: Thu, 10 Jan 2013 11:20:07 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Arnd Bergmann <arnd@arndb.de>, Stephen Warren <swarren@wwwdotorg.org>,
        linux-tegra@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 05/14] lib: Add I/O map cache implementation
Message-ID: <20130110182007.GA28004@obsidianresearch.com>
References: <1357764194-12677-1-git-send-email-thierry.reding@avionic-design.de>
 <20130109231758.GA27065@obsidianresearch.com>
 <20130110071937.GG15212@avionic-0098.adnet.avionic-design.de>
 <201301100917.19577.arnd@arndb.de>
 <20130110102544.GA5546@avionic-0098.adnet.avionic-design.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130110102544.GA5546@avionic-0098.adnet.avionic-design.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.162
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2013 at 11:25:44AM +0100, Thierry Reding wrote:
> On Thu, Jan 10, 2013 at 09:17:19AM +0000, Arnd Bergmann wrote:
> > On Thursday 10 January 2013, Thierry Reding wrote:
> > > On Wed, Jan 09, 2013 at 04:17:58PM -0700, Jason Gunthorpe wrote:
> > > > On Wed, Jan 09, 2013 at 04:12:31PM -0700, Stephen Warren wrote:
> > > > You could decrease the size of the mapping to only span the bus
> > > > numbers that are configured for use via DT.
> > > 
> > > That won't work, unfortunately. The mapping is such that the bus number
> > > is not encoded in the uppermost bits, the extended register number is.
> > > So the only thing that we could do is decrease the size of the extended
> > > register space for *all* devices.
> > 
> > But you could still a method to map 16 separate areas per bus, each 65536
> > bytes long, which results in 1MB per bus. That is probably ok, since
> > very few systems have more than a handful of buses in practice.
> > 
> > In theory, doing static mappings on a per-page base would let you
> > do 16 devices at a time, but it's probably worth doing at this fine
> > granularity.
> 
> I don't understand how this would help. The encoding is like this:
> 
> 	[27:24] extended register number
> 	[23:16] bus number
> 	[15:11] device number
> 	[10: 8] function number
> 	[ 7: 0] register number
> 
> So it doesn't matter whether I use separate areas per bus or not. As
> soon as the whole extended configuration space needs to be accessed a
> whopping 28 bits (256 MiB) are required.

You'd piece a mapping together, each bus requires 16 64k mappings, a
simple 2d array of busnr*16 of pointers would do the trick. A more
clever solution would be to allocate contiguous virtual memory and
split that up..

> > Actually, AER probably needs this, and I believe some broken devices 
> > need to mask interrupts using the PCI command word in the config space,
> > it it can happen.
> 
> Ugh... that would kill any such dynamic mapping approach. Perhaps if we
> could mark a device as requiring a static mapping we could pin that
> cache entry. But that doesn't sound very encouraging.

AER applies to pretty much every PCI-E device these days.

Jason
