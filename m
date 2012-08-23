Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754939Ab2HWWf2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 18:35:28 -0400
Received: from db3ehsobe002.messaging.microsoft.com ([213.199.154.140]:17502
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750798Ab2HWWfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 18:35:24 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zzbb2dI98dI9371I1432Izz1202hzzz2dh668h839h944hd25hd2bhf0ah107ah1155h)
X-WSS-ID: 0M98C2R-02-1PM-02
X-M-MSG: 
Date: Thu, 23 Aug 2012 17:35:14 -0500
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
Message-ID: <20120823223514.GA6502@jshin-Toonie>
References: <1344983957-4996-1-git-send-email-jacob.shin@amd.com>
 <1344983957-4996-4-git-send-email-jacob.shin@amd.com>
 <50356BA9.5030906@zytor.com>
 <20120823145043.GA4671@jshin-Toonie>
 <50364E9E.6020104@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <50364E9E.6020104@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2012 at 08:39:10AM -0700, H. Peter Anvin wrote:
> On 08/23/2012 07:50 AM, Jacob Shin wrote:
> >>
> >>I have one concern with this, which is that it leaves in place mapping
> >>below the initial max_pfn_mapped.  Although that neatly resolves the
> >>legacy area (0-1 MiB) issues, it really isn't right above the 1 MiB
> >>point.  Any way I could get you to seek out and unmap any such ranges?
> >>We have already seen some Dell machines which put memory holes in low
> >>RAM, and perhaps there are still some machines out there with an I/O
> >>hole at 15 MiB.
> >
> >So I believe in V2 of the patchset this was done, however, Dave Young
> >from redhat reported that it broke their KVM guest with a user supplied
> >memory map that looked like this:
> >
> >>>[    0.000000] e820: user-defined physical RAM map:
> >>>[    0.000000] user: [mem 0x0000000000010000-0x000000000009dbff] usable
> >>>[    0.000000] user: [mem 0x0000000024000000-0x0000000033f6bfff] usable
> >

I looked into this a bit more, and I think what's happening is that this
user defined memory map leaves out the region where the kernel is loaded on
to during the boot process. The kernel and the direct mapped page tables up
to initial max_pfn_mapped reside somwhere under 512M (KERNEL_IMAGE_SIZE),
I guess it depends on how big your uncompressed kernel is.

And at the first attempt to set_fixmap_nocache(FIX_APIC_BASE, address) in
arch/x86/apic/apic.c: register_lapic_address runs into badness because the
memory region where the initial page tables live is no longer mapped
because of the above user supplied memory map.

So I guess there is a disconnect between really early code that seems to
rely on the boot loader as to where in physical memory it resides and its
initial page tables live, and the later memory initialization code where
it looks at the E820 (and here user can interject their own memory map
using the command line arguments)

Not really sure how to handle this case .. any advice?

