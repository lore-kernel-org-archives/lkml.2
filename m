Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030432Ab2HWOvA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 10:51:00 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:55550 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932708Ab2HWOuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 10:50:55 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zzbb2dI98dI9371I1432Izz1202hzz8275bhz2dh668h839h944hd25hd2bhf0ah107ah)
X-WSS-ID: 0M97QKL-01-1D8-02
X-M-MSG: 
Date: Thu, 23 Aug 2012 09:50:43 -0500
From: Jacob Shin <jacob.shin@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Tejun Heo <tj@kernel.org>, Borislav Petkov <borislav.petkov@amd.com>,
        Dave Young <dyoung@redhat.com>, Chao Wang <chaowang@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 3/4] x86: Only direct map addresses that are marked as
 E820_RAM
Message-ID: <20120823145043.GA4671@jshin-Toonie>
References: <1344983957-4996-1-git-send-email-jacob.shin@amd.com>
 <1344983957-4996-4-git-send-email-jacob.shin@amd.com>
 <50356BA9.5030906@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <50356BA9.5030906@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2012 at 04:30:49PM -0700, H. Peter Anvin wrote:
> On 08/14/2012 03:39 PM, Jacob Shin wrote:
> > Currently direct mappings are created for [ 0 to max_low_pfn<<PAGE_SHIFT )
> > and [ 4GB to max_pfn<<PAGE_SHIFT ), which may include regions that are not
> > backed by actual DRAM. This is fine for holes under 4GB which are covered
> > by fixed and variable range MTRRs to be UC. However, we run into trouble
> > on higher memory addresses which cannot be covered by MTRRs.
> > 
> > Our system with 1TB of RAM has an e820 that looks like this:
> > 
> >  BIOS-e820: [mem 0x0000000000000000-0x00000000000983ff] usable
> >  BIOS-e820: [mem 0x0000000000098400-0x000000000009ffff] reserved
> >  BIOS-e820: [mem 0x00000000000d0000-0x00000000000fffff] reserved
> >  BIOS-e820: [mem 0x0000000000100000-0x00000000c7ebffff] usable
> >  BIOS-e820: [mem 0x00000000c7ec0000-0x00000000c7ed7fff] ACPI data
> >  BIOS-e820: [mem 0x00000000c7ed8000-0x00000000c7ed9fff] ACPI NVS
> >  BIOS-e820: [mem 0x00000000c7eda000-0x00000000c7ffffff] reserved
> >  BIOS-e820: [mem 0x00000000fec00000-0x00000000fec0ffff] reserved
> >  BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
> >  BIOS-e820: [mem 0x00000000fff00000-0x00000000ffffffff] reserved
> >  BIOS-e820: [mem 0x0000000100000000-0x000000e037ffffff] usable
> >  BIOS-e820: [mem 0x000000e038000000-0x000000fcffffffff] reserved
> >  BIOS-e820: [mem 0x0000010000000000-0x0000011ffeffffff] usable
> > 
> > and so direct mappings are created for huge memory hole between
> > 0x000000e038000000 to 0x0000010000000000. Even though the kernel never
> > generates memory accesses in that region, since the page tables mark
> > them incorrectly as being WB, our (AMD) processor ends up causing a MCE
> > while doing some memory bookkeeping/optimizations around that area.
> > 
> > This patch iterates through e820 and only direct maps ranges that are
> > marked as E820_RAM, and keeps track of those pfn ranges. Depending on
> > the alignment of E820 ranges, this may possibly result in using smaller
> > size (i.e. 4K instead of 2M or 1G) page tables.
> > 
> > Signed-off-by: Jacob Shin <jacob.shin@amd.com>
> 
> I have one concern with this, which is that it leaves in place mapping
> below the initial max_pfn_mapped.  Although that neatly resolves the
> legacy area (0-1 MiB) issues, it really isn't right above the 1 MiB
> point.  Any way I could get you to seek out and unmap any such ranges?
> We have already seen some Dell machines which put memory holes in low
> RAM, and perhaps there are still some machines out there with an I/O
> hole at 15 MiB.

So I believe in V2 of the patchset this was done, however, Dave Young
from redhat reported that it broke their KVM guest with a user supplied
memory map that looked like this:

>> [    0.000000] e820: user-defined physical RAM map:
>> [    0.000000] user: [mem 0x0000000000010000-0x000000000009dbff] usable
>> [    0.000000] user: [mem 0x0000000024000000-0x0000000033f6bfff] usable

And looking into that scenario, the early boot code seems to allocates
space for fixmap right under initial max_pfn_mapped, which is no longer
direct mapped with my patch, and that seems to cause problems for later
APIC code that initializes APIC base address into the fixmap area.

So I guess to address your concern, we need to go back to V2 and try to
resolve the fixmap problem with user supplied memory map that reserves
memory below initial max_pfn_mapped ?

> 
> 	-hpa
> 
> 

