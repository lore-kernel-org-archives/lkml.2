Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751578Ab1BAW31 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 17:29:27 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:42932 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276Ab1BAW30 (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 1 Feb 2011 17:29:26 -0500
Date: Tue, 1 Feb 2011 17:28:28 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Ian Campbell <Ian.Campbell@eu.citrix.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        "konrad@kernel.org" <konrad@kernel.org>,
        "jeremy@goop.org" <jeremy@goop.org>, "hpa@zytor.com" <hpa@zytor.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Subject: Re: [PATCH 06/11] xen/setup: Skip over 1st gap after System RAM.
Message-ID: <20110201222828.GD18656@dumpdata.com>
References: <1296513876-31415-1-git-send-email-konrad.wilk@oracle.com>
 <1296513876-31415-7-git-send-email-konrad.wilk@oracle.com>
 <1296572896.13091.240.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296572896.13091.240.camel@zakaz.uk.xensource.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 01, 2011 at 03:08:16PM +0000, Ian Campbell wrote:
> On Mon, 2011-01-31 at 22:44 +0000, Konrad Rzeszutek Wilk wrote:
> > If the kernel is booted with dom0_mem=max:512MB and the
> > machine has more than 512MB of RAM, the E820 we get is:
> > 
> > Xen: 0000000000100000 - 0000000020000000 (usable)
> > Xen: 00000000b7ee0000 - 00000000b7ee3000 (ACPI NVS)
> > 
> > while in actuality it is:
> > 
> > (XEN)  0000000000100000 - 00000000b7ee0000 (usable)
> > (XEN)  00000000b7ee0000 - 00000000b7ee3000 (ACPI NVS)
> > 
> > Based on that, we would determine that the "gap" between
> > 0x20000 -> 0xb7ee0 is not System RAM and try to assign it to
> > 1-1 mapping. This meant that later on when we setup the page tables
> > we would try to assign those regions to DOMID_IO and the
> > Xen hypervisor would fail such operation. This patch
> > guards against that and sets the "gap" to be after the first
> > non-RAM E820 region.
> 
> This seems dodgy to me and makes assumptions about the sanity of the
> BIOS provided e820 maps. e.g. it's not impossible that there are systems
> out there with 2 or more little holes under 1M etc.

[edit: I am droppping this patch.. explanation at the end of email]

Are you thinking of something like this:

   000->a00 [RAM]
   b00->c00 [reserved]
   dff->f00 [RAM]

So there is a gap between a00->b00, and c00->dff which is not System RAM
but real PCI space and as such should be considered identity mapping?
(Lets ignore the fact that we consider any access under ISA_END_ADDRESS
to be identity).

The hypervisor is the one that truncates the E820_RAM such that it is dangerous
to consider the gap after the end of E820_RAM to be not System RAM.
(You actually were hitting this way back when you ran my patchset the first time).
[edit: actually I was mistaken, read below..]



> 
> The truncation (from 0xb7ee0000 to 0x20000000 in this case) happens in
> the dom0 kernel not the hypervisor right? So we can at least know that
> we've done it.

The hypervisor does this. [edit: I missed this code:

280                 if (map[i].type == E820_RAM && end > mem_end) {
281                         /* RAM off the end - may be partially included */
282                         u64 delta = min(map[i].size, end - mem_end);
283                         

which shows that we, dom0, truncate the E820 entries.]

> 
> Can we do the identity setup before that truncation happens? If not can

Sadly no. [edit: happily yes]

There are two types of truncation:

1). The hypervisor truncates the E820_RAM to the proper PFN number. If
there are E820_RAM regions past the first one (see the
example in "x86/setup: Consult the raw E820 for zero sized E820 RAM regions.")
it makes the size of those E820_RAM to be zero. The patch I mentioned
consults the 'raw' E820 to see if this exists.
[edit: ignore this pls, the code in xen_memory_setup does the truncation]


2). The Linux kernel e820 library "sanititizes" the E820. This means
if you have E820_RAM regions with zero size they disappear. We can't
use the E820 before this sanitization b/c the increase/decrease code has to
run its course to fill up the E820_RAM past the 4GB.

> can we not remember the untruncated map too and refer to it as
> necessary. One way of doing that might be to insert an e820 region
> covering the truncated region to identify it as such (perhaps
> E820_UNUSABLE?) or maybe integrating e.g. with the memblock reservations
> (or whatever the early enough allocator is).
> 
> The scheme we have is that all pre-ballooned memory goes at the end of
> the e820 right, as opposed to allowing it to first fill truncated
> regions such as this? 

Correct. We siphon out any Sysem RAM memory that is under 4GB that can
be siphoned out and expand the E820_RAM entry past the 4GB with the count
of PFNs that we siphoned out.


[edit: reason why I am dropping this patch]

Your email got me thinking that maybe I missed something about the E820
and sure enough - I somehow skipped that whole process of figuring
out the delta and messing with e820->size. The weird part is
I knew about increase/decrease memory and the delta but somehow did not
connect that those numbers are gathered during the first loop over the E820.
Talk about tunnel vision.

Anyhow, your suggestion of refering to the raw, unmodified version of
the E820 makes this all work quite nicely and I can drop:

xen/setup: Skip over 1st gap after System RAM
x86/setup: Consult the raw E820 for zero sized E820 RAM regions.

I am attaching the patch I am talking about to the "xen/setup: Set
identity mapping for non-RAM E820 and E820 gaps"
