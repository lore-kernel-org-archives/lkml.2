Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756062Ab2ICFep (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 01:34:45 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:61177 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755096Ab2ICFeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 01:34:44 -0400
MIME-Version: 1.0
In-Reply-To: <1346572019-15806-11-git-send-email-yinghai@kernel.org>
References: <1346572019-15806-1-git-send-email-yinghai@kernel.org>
	<1346572019-15806-11-git-send-email-yinghai@kernel.org>
Date: Mon, 3 Sep 2012 08:34:43 +0300
X-Google-Sender-Auth: AzQZcoYIrDAQbdD2svUn88xy6WA
Message-ID: <CAOJsxLG6n==hVKwiJX_+yF+7M-NUsvUPRnxECADdn+MAP=Zj-g@mail.gmail.com>
Subject: Re: [PATCH -v2 10/13] x86: Only direct map addresses that are marked
 as E820_RAM
From: Pekka Enberg <penberg@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 2, 2012 at 10:46 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> From: Jacob Shin <jacob.shin@amd.com>
>
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
> -v2: move changes from setup.c to mm/init.c, also use for_each_mem_pfn_range
>         instead.  - Yinghai Lu
> -v3: add calculate_all_table_space_size() to get correct needed page table
>         size. - Yinghai Lu
>
> Signed-off-by: Jacob Shin <jacob.shin@amd.com>

Yinghai's sign-off is missing.

Reviewed-by: Pekka Enberg <penberg@kernel.org>
