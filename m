Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754390Ab1DMNwo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 09:52:44 -0400
Received: from cantor.suse.de ([195.135.220.2]:33865 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750868Ab1DMNwn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 09:52:43 -0400
Date: Wed, 13 Apr 2011 14:52:39 +0100
From: Mel Gorman <mgorman@suse.de>
To: naveen yadav <yad.naveen@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm <linux-mm@kvack.org>,
        linux-arm-kernel-request@lists.arm.linux.org.uk,
        linux newbie <linux.newbie79@gmail.com>
Subject: Re: [ARM] Issue of memory compaction on kernel 2.6.35.9
Message-ID: <20110413135239.GA22688@suse.de>
References: <BANLkTikHzq90xzK5+imnGKtc6mLNz84G-w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTikHzq90xzK5+imnGKtc6mLNz84G-w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 13, 2011 at 05:05:33PM +0530, naveen yadav wrote:
> Dear all,
> 
> we want to varify compaction on ARM and we are  using 2.6.25.9 kernel
> on cortex a9.
> 
> Since ARM does not have HUGETLB_PAGE support and compaction is HUGE
> PAGE independent so I removed from config file
> 

Bear in mind that if you intend to depend on compaction to allow
devices to use high-order allocations, you could be in trouble in
the future. Compaction gives no guarantees that high-order pages will
be available so a device must still be able to cope with allocation
failure. In the case of transparent hugepage support and hugetlbfs,
allocation failure is not a serious problem.

> ******************************************************************************************************************************
> # support for memory compaction
> config COMPACTION
>         bool "Allow for memory compaction"
>         select MIGRATION
>         #depends on EXPERIMENTAL && HUGETLB_PAGE && MMU
>         depends on EXPERIMENTAL && MMU
>    help
>           Allows the compaction of memory for the allocation of huge pages.	
> ******************************************************************************************************************************
> after triggering Memory Compaction by writing any value to
> /proc/sys/vm/compact_memory i am getting the SVC mode crash
> ******************************************************************************************************************************
> #echo 1 > /proc/sys/vm/compact_memory
> Unable to handle kernel paging request at virtual address ee420be4
> pgd = d9c6c000
> [ee420be4] *pgd=00000000
> Internal error: Oops: 805 [#1] PREEMPT
> last sysfs file:
> Modules linked in:
> CPU: 0    Not tainted  (2.6.35.9 #16)
> PC is at compact_zone+0x178/0x610
> LR is at compact_zone+0x138/0x610
> pc : [<c009f30c>]    lr : [<c009f2cc>]    psr: 40000093
> sp : d9d75e40  ip : c0380978  fp : d9d75e94
> r10: d9d74000  r9 : c03806c8  r8 : 00069704
> r7 : 00069800  r6 : 00d2e080  r5 : c04ea080  r4 : d9d75e9c
> r3 : 60000093  r2 : 00000002  r1 : ee420be4  r0 : ee430b82
> Flags: nZcv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment us	
> ******************************************************************************************************************************
> 
> 
> We  tried to narrow down the prob... I found crash is form
> ?del_page_from_lru_list(zone, page, page_lru(page)); ? function
> isolate_migratepages
> 

ARM punches holes in the mem_map structure to save memory and
memory compaction is not aware of them because it couldn't have been
configured.  Debug what PFN is failing and see if it is near a memory
hole. If it's within a memory hole, that's your problem.

-- 
Mel Gorman
SUSE Labs
