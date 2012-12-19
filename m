Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885Ab2LSTSQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 14:18:16 -0500
Received: from quartz.orcorp.ca ([184.70.90.242]:51240 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751258Ab2LSTSD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 14:18:03 -0500
Date: Wed, 19 Dec 2012 12:18:00 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH] of: Support a PCI device that is compatible with
 'simple-bus'
Message-ID: <20121219191800.GA1169@obsidianresearch.com>
References: <20121210215119.GA32011@obsidianresearch.com>
 <20121214202629.BD40C3E0BDD@localhost>
 <20121214215814.GA14149@obsidianresearch.com>
 <20121219125451.3F1FB3E0AD7@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121219125451.3F1FB3E0AD7@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.162
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 19, 2012 at 12:54:51PM +0000, Grant Likely wrote:
 
> Then it sounds like you really don't want PCI addressing in the
> children. It sounds like the children addresses need to be in the form
> [bar#] [offset-from-base-of-bar]. In that case, you need the
> appropriate

They should be interchangeable - in 99% of cases with multiple BARs
each BAR will be a different address type, so tagging by address type
or tagging by bar number is basically the same. I started with the 3
dw format only because that made sense to me and tried to make that
work. As it turns out the 2dw or 1dw format works fine out without any
patching and has the same basic functionality via the ranges
remapping.

> ranges entries to translate from each bar to the PCI address space,
> which is exactly what other users are doing. Whether your address format
> uses 2 cells or 3, it shouldn't matter. The translation mechanism is
> the

It does matter, I could not make 3 cells work, I sent you the various
approaches I tested that fix this, but they were not terribly
general.. I'm still very unclear what the root problem is, though..

> In both cases, the type of transfer is encoded by the BAR address and
> does not get exposed to the child device. Exposing the PCI flags into
> the child bus(es) really isn't a very good idea because they don't make
> sense in that context. It may seem expedient, but it will be fragile.

Well, it makes as much sense as for a PCI driver - each of the three
transfer types has different coding requirements in the driver, so
each of the three type must be kept separate.

I haven't looked super closely at this, but the basic desire is to
have IORESOURCE_PREFETCH tagged on the struct resource that reaches
the platform driver. 'get_flags' for a non-PCI addresses scheme always
returns IORESOURCE_MEM, and translating through a ranges doesn't
appear to fix that. This is where 3dw is desirable because it uses a
get_flags that understands the three resource types.

> I apologize if I'm being dense here and missing something about why you
> need to use PCI addressing on a non-PCI bus segment. Please let me know
> if I'm missing something important.

I think you've got it basically right. I misunderstood some of what
you were originally saying about using ranges from your earlier
mail. What you described is fine for IORESOURCE_MEM style regions, and
I've confirmed that it works OK in my cases.

Regards,
Jason
