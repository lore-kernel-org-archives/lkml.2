Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389Ab3ADWCE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 17:02:04 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:60481 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755023Ab3ADWCB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 17:02:01 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH v7u1 31/31] x86, 64bit, mm: hibernate use generic mapping_init
Date: Fri, 04 Jan 2013 23:07:37 +0100
Message-ID: <1827179.UIfxDLWPxM@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc2+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAE9FiQX6pPE9EbqRNCRvN+a_rSU6Zdt4QKa4hNGApyYfVYySzw@mail.gmail.com>
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org> <61708402.lBGARq0J34@vostro.rjw.lan> <CAE9FiQX6pPE9EbqRNCRvN+a_rSU6Zdt4QKa4hNGApyYfVYySzw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, January 04, 2013 01:59:33 PM Yinghai Lu wrote:
> On Fri, Jan 4, 2013 at 3:43 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Thursday, January 03, 2013 04:48:51 PM Yinghai Lu wrote:
> >> Make it only map range in pfn_mapped array.
> >
> > Can you please explain why that should be sufficient?
> 
> It is needed.
> 
> http://git.kernel.org/?p=linux/kernel/git/tip/tip.git;a=commitdiff;h=66520ebc2df3fe52eb4792f8101fac573b766baf
> 
> Subject: [PATCH] x86, mm: Only direct map addresses that are marked as
>  E820_RAM
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
> >
> > Have you tested it?
> >
> 
> No
> 
> will update to
> 
> Subject: [PATCH] x86, 64bit, mm: hibernate use generic mapping_init
> 
> We should not set mapping for all under max_pfn.
> That causes same problem that is fixed by
>         x86, mm: Only direct map addresses that are marked as E820_RAM
> 
> Make it only map range in pfn_mapped array.

OK

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
