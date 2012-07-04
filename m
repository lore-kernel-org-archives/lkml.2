Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754374Ab2GDFcc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 01:32:32 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:45513 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752771Ab2GDFca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 01:32:30 -0400
X-AuditID: 9c930179-b7cceae000004195-bf-4ff3d56c2f20
Message-ID: <4FF3D598.4070708@kernel.org>
Date: Wed, 04 Jul 2012 14:33:12 +0900
From: Minchan Kim <minchan@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>, linux-mm@kvack.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] zsmalloc improvements
References: <1341263752-10210-1-git-send-email-sjenning@linux.vnet.ibm.com>
In-Reply-To: <1341263752-10210-1-git-send-email-sjenning@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for not reviewing yet.
By urgent works, I will review this patches on next week.

I hope others can review it.
Thanks.

On 07/03/2012 06:15 AM, Seth Jennings wrote:

> This patchset removes the current x86 dependency for zsmalloc
> and introduces some performance improvements in the object
> mapping paths.
> 
> It was meant to be a follow-on to my previous patchest
> 
> https://lkml.org/lkml/2012/6/26/540
> 
> However, this patchset differed so much in light of new performance
> information that I mostly started over.
> 
> In the past, I attempted to compare different mapping methods
> via the use of zcache and frontswap.  However, the nature of those
> two features makes comparing mapping method efficiency difficult
> since the mapping is a very small part of the overall code path.
> 
> In an effort to get more useful statistics on the mapping speed,
> I wrote a microbenchmark module named zsmapbench, designed to
> measure mapping speed by calling straight into the zsmalloc
> paths.
> 
> https://github.com/spartacus06/zsmapbench
> 
> This exposed an interesting and unexpected result: in all
> cases that I tried, copying the objects that span pages instead
> of using the page table to map them, was _always_ faster.  I could
> not find a case in which the page table mapping method was faster.
> 
> zsmapbench measures the copy-based mapping at ~560 cycles for a
> map/unmap operation on spanned object for both KVM guest and bare-metal,
> while the page table mapping was ~1500 cycles on a VM and ~760 cycles
> bare-metal.  The cycles for the copy method will vary with
> allocation size, however, it is still faster even for the largest
> allocation that zsmalloc supports.
> 
> The result is convenient though, as mempcy is very portable :)
> 
> This patchset replaces the x86-only page table mapping code with
> copy-based mapping code. It also makes changes to optimize this
> new method further.
> 
> There are no changes in arch/x86 required.
> 
> Patchset is based on greg's staging-next.
> 
> Seth Jennings (4):
>   zsmalloc: remove x86 dependency
>   zsmalloc: add single-page object fastpath in unmap
>   zsmalloc: add details to zs_map_object boiler plate
>   zsmalloc: add mapping modes
> 
>  drivers/staging/zcache/zcache-main.c     |    6 +-
>  drivers/staging/zram/zram_drv.c          |    7 +-
>  drivers/staging/zsmalloc/Kconfig         |    4 -
>  drivers/staging/zsmalloc/zsmalloc-main.c |  124 ++++++++++++++++++++++--------
>  drivers/staging/zsmalloc/zsmalloc.h      |   14 +++-
>  drivers/staging/zsmalloc/zsmalloc_int.h  |    6 +-
>  6 files changed, 114 insertions(+), 47 deletions(-)
> 



-- 
Kind regards,
Minchan Kim
