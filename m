Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751667Ab1BAWac (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 17:30:32 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:44762 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461Ab1BAWab (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 1 Feb 2011 17:30:31 -0500
Date: Tue, 1 Feb 2011 17:29:28 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "jeremy@goop.org" <jeremy@goop.org>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ian Campbell <Ian.Campbell@eu.citrix.com>,
        "konrad@kernel.org" <konrad@kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>
Subject: Re: [Xen-devel] Re: [PATCH 07/11] x86/setup: Consult the raw E820
 for zero sized E820 RAM regions.
Message-ID: <20110201222928.GE18656@dumpdata.com>
References: <1296513876-31415-1-git-send-email-konrad.wilk@oracle.com>
 <1296513876-31415-8-git-send-email-konrad.wilk@oracle.com>
 <alpine.DEB.2.00.1102011537050.7277@kaball-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1102011537050.7277@kaball-desktop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 01, 2011 at 05:52:15PM +0000, Stefano Stabellini wrote:
> On Mon, 31 Jan 2011, Konrad Rzeszutek Wilk wrote:
> > When the Xen hypervisor provides us with an E820, it can
> > contain zero sized RAM regions. Those are entries that have
> > been trimmed down due to the user utilizing the dom0_mem flag.
> > 
> > What it means is that there is RAM at those regions, and we
> > should _not_ be considering those regions as 1-1 mapping.
> > 
> > This dom0_mem parameter changes a nice looking E820 like this:
> > 
> > Xen: 0000000000000000 - 000000000009d000 (usable)
> > Xen: 000000000009d000 - 0000000000100000 (reserved)
> > Xen: 0000000000100000 - 000000009cf67000 (usable)
> > Xen: 000000009cf67000 - 000000009d103000 (ACPI NVS)
> > Xen: 000000009d103000 - 000000009f6bd000 (usable)
> > Xen: 000000009f6bd000 - 000000009f6bf000 (reserved)
> > Xen: 000000009f6bf000 - 000000009f714000 (usable)
> > 
> > (wherein we would happily set 9d->100, 9cf67->9d103, and
> > 9f6bd->9f6bf to identity mapping) .. but with a dom0_mem
> > argument (say dom0_mem=700MB) it looks as so:
> > 
> > Xen: 0000000000000000 - 000000000009d000 (usable)
> > Xen: 000000000009d000 - 0000000000100000 (reserved)
> > Xen: 0000000000100000 - 000000002bc00000 (usable)
> > Xen: 000000009cf67000 - 000000009d103000 (ACPI NVS)
> > Xen: 000000009f6bd000 - 000000009f6bf000 (reserved)
> > 
> > We would set 9d->100, and 9cf670->9f6bf to identity
> > mapping. The region from 9d103->9f6bd - which is
> > System RAM where a guest could be allocated from,
> > would be considered identity which is incorrect.
> > 
> > [Note: this printout of the E820 is after E820
> > sanitization, the raw E820 would look like this]:
> > 
> > Xen: 0000000000000000 - 000000000009d000 (usable)
> > Xen: 000000000009d000 - 0000000000100000 (reserved)
> > Xen: 0000000000100000 - 000000002bc00000 (usable)
> > Xen: 000000009cf67000 - 000000009d103000 (ACPI NVS)
> > Xen: 000000009d103000 - 000000009d103000 (usable)  <===
> > Xen: 000000009f6bd000 - 000000009f6bf000 (reserved)
> > 
> > [Notice the "usable" zero sized region]
> > 
> > This patch consults the non-sanitized version of the E820
> > and checks if there are zero-sized RAM regions right before
> > the non-RAM E820 entry we are currently evaluating.
> > If so, we utilize the 'ram_end' value to piggyback on the
> > code introduced by "xen/setup: Pay attention to zero sized
> > E820_RAM regions" patch. Also we add a printk to help
> > us determine which region has been set to 1-1 mapping and
> > add some sanity checking.
> > 
> > We must keep those regions zero-size E820 RAM regions
> > as is (so missing), otherwise the M2P override code can
> > malfunction if a guest grant page is present in those regions.
> > 
> > Shifting the "xen_set_identity" to be called earlier (so that
> > we are using the non-sanitized version of the &e820) does not
> > work as we need to take into account the E820 after the
> > initial increase/decrease reservation done and addition of a
> > new E820 region in 'xen_add_extra_mem').
> 
> Can we just call two different functions, one before sanitizing the e820
> and another after xen_add_extra_mem?
> We could just go through the original e820 and set as identity all the
> non-ram regions, after all we don't want to risk setting as identity
> valid ram regions.
> If the problem is caused by xen_memory_setup modifying the e820, maybe
> we could avoid doing that, adding all the extra memory regions to the
> balloon without moving them together to the end.
> It is just that this code (and xen_memory_setup) lookis a bit too
> complicated.

Another idea occured to me after I was ingesting Ian's comments
and that is just to parse the "raw" E820 from the hypervisor. It works
quite nicely, so dropping this patch.
