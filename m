Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734Ab1HCK4U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 06:56:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51804 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753639Ab1HCK4N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 06:56:13 -0400
Date: Wed, 3 Aug 2011 11:56:07 +0100
From: Mel Gorman <mgorman@suse.de>
To: Kautuk Consul <consul.kautuk@gmail.com>
Cc: stable@kernel.org, "Russell King\"" <rmk@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM : sparsemem: Crashes on ARM platform when sparsemem
 enabled in linux-2.6.???35.13 due to pfn_valid(???) and
 pfn_valid_???within().
Message-ID: <20110803105607.GC19099@suse.de>
References: <CAFPAmTQGkTstM1j0kJWng8rf9_wfBa427r69-5rQpFJCSQGZkw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <CAFPAmTQGkTstM1j0kJWng8rf9_wfBa427r69-5rQpFJCSQGZkw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 02, 2011 at 01:36:49PM +0530, Kautuk Consul wrote:
> Hi,
> 
> On my ARM machine, I have linux-2.6.35.13 installed and the total
> kernel memory is not aligned to the section size SECTION_SIZE_BITS.
> 
> I observe kernel crashes in the following 3 scenarios:
> i)    When we do a "cat /proc/pagetypeinfo": This happens because the
> pfn_valid() macro is not able to detect invalid PFNs in the loop in
> vmstat.c: pagetypeinfo_showblockcount_print().
> ii)    When we do "echo xxxx > /proc/vm/sys/min_free_kbytes": This
> happens because the pfn_valid() macro is not able to detect invalid
> PFNs in page_alloc.c: setup_zone_migrate_reserve().
> iii)   When I try to copy a really huge file: This happens because the
> CONFIG_HOLES_IN_ZONE config option is not set.
>        The code then crashes in the VM_BUG_ON in loop in
> move_freepages() as pfn_valid_within() did not compile correctly to
> pfn_valid().
> 
> This patch is a combination of :
> a)  Back-ported changes of the patch from Will Deacon found at:
> http://git.kernel.org/?p=linux/kernel/git/stable/linux-3.0.y.git;a=commit;h=7b7bf499f79de3f6c85a340c8453a78789523f85
> b) Addition of the CONFIG_HOLES_IN_ZONE config option to
> arch/arm/Kconfig in order to prevent crashes in move_freepages()
> when/if the total kernel memory is not aligned to SECTION_SIZE_BITS.
> This also leads to
> proper compilation of the pfn_valid_within() macro which otherwise
> will always return 1 to the caller.
> 

Ok, for -stable backports, it is required that each patch is a backport
of a single commit. This is to ensure that there are no accidental
forks or fixes that get lost. If this patch is a combination of two
patches, then the expected format for review would be in three mails

Mail 1: [Patch 0/2] A leader explaining why the series is required. The
	information you have above is fine

Mail 2: [Patch 1/2] would be commit 
        [7b7bf499: ARM: 6913/1: sparsemem: allow pfn_valid to be
        overridden when using SPARSEMEM]

	The only difference between that commit and your commit would
	be that it's being sent to stable and at the beginning of the
	mail you should have

	"commit: 7b7bf499f79de3f6c85a340c8453a78789523f85"

	This is to the history of the patch is clear at a glance

Mail 3: [Patch 2/2] would be whatever commit introduces
	CONFIG_HOLES_IN_ZONE. If this is not in mainline already,
	it should be merged to mainline before backporting.

See Documentation/stable_kernel_rules.txt .

In this format for example, I would not even have to review patch 1/2
properly other than checking it's equivalent to the mainstream patch
that I already ack'd. It'd probably have been picked up by now :/ .

I don't know about patch 2 yet because I didn't go to the effort of
applying this patch, reverting the upstream commit and examining the
remainder.

I know this appears awkward but review bandwidth is extremely limited
and it's important that fixes do not get lost.

-- 
Mel Gorman
SUSE Labs
