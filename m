Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268Ab2HVXbE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 19:31:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47407 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751882Ab2HVXa7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 19:30:59 -0400
Message-ID: <50356BA9.5030906@zytor.com>
Date: Wed, 22 Aug 2012 16:30:49 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Jacob Shin <jacob.shin@amd.com>
CC: X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Tejun Heo <tj@kernel.org>, Borislav Petkov <borislav.petkov@amd.com>,
        Dave Young <dyoung@redhat.com>, Chao Wang <chaowang@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 3/4] x86: Only direct map addresses that are marked as
 E820_RAM
References: <1344983957-4996-1-git-send-email-jacob.shin@amd.com> <1344983957-4996-4-git-send-email-jacob.shin@amd.com>
In-Reply-To: <1344983957-4996-4-git-send-email-jacob.shin@amd.com>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14/2012 03:39 PM, Jacob Shin wrote:
> Currently direct mappings are created for [ 0 to max_low_pfn<<PAGE_SHIFT )
> and [ 4GB to max_pfn<<PAGE_SHIFT ), which may include regions that are not
> backed by actual DRAM. This is fine for holes under 4GB which are covered
> by fixed and variable range MTRRs to be UC. However, we run into trouble
> on higher memory addresses which cannot be covered by MTRRs.
> 
> Our system with 1TB of RAM has an e820 that looks like this:
> 
>  BIOS-e820: [mem 0x0000000000000000-0x00000000000983ff] usable
>  BIOS-e820: [mem 0x0000000000098400-0x000000000009ffff] reserved
>  BIOS-e820: [mem 0x00000000000d0000-0x00000000000fffff] reserved
>  BIOS-e820: [mem 0x0000000000100000-0x00000000c7ebffff] usable
>  BIOS-e820: [mem 0x00000000c7ec0000-0x00000000c7ed7fff] ACPI data
>  BIOS-e820: [mem 0x00000000c7ed8000-0x00000000c7ed9fff] ACPI NVS
>  BIOS-e820: [mem 0x00000000c7eda000-0x00000000c7ffffff] reserved
>  BIOS-e820: [mem 0x00000000fec00000-0x00000000fec0ffff] reserved
>  BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
>  BIOS-e820: [mem 0x00000000fff00000-0x00000000ffffffff] reserved
>  BIOS-e820: [mem 0x0000000100000000-0x000000e037ffffff] usable
>  BIOS-e820: [mem 0x000000e038000000-0x000000fcffffffff] reserved
>  BIOS-e820: [mem 0x0000010000000000-0x0000011ffeffffff] usable
> 
> and so direct mappings are created for huge memory hole between
> 0x000000e038000000 to 0x0000010000000000. Even though the kernel never
> generates memory accesses in that region, since the page tables mark
> them incorrectly as being WB, our (AMD) processor ends up causing a MCE
> while doing some memory bookkeeping/optimizations around that area.
> 
> This patch iterates through e820 and only direct maps ranges that are
> marked as E820_RAM, and keeps track of those pfn ranges. Depending on
> the alignment of E820 ranges, this may possibly result in using smaller
> size (i.e. 4K instead of 2M or 1G) page tables.
> 
> Signed-off-by: Jacob Shin <jacob.shin@amd.com>

I have one concern with this, which is that it leaves in place mapping
below the initial max_pfn_mapped.  Although that neatly resolves the
legacy area (0-1 MiB) issues, it really isn't right above the 1 MiB
point.  Any way I could get you to seek out and unmap any such ranges?
We have already seen some Dell machines which put memory holes in low
RAM, and perhaps there are still some machines out there with an I/O
hole at 15 MiB.

	-hpa

