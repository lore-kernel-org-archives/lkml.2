Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756478Ab2EQIdq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 04:33:46 -0400
Received: from linux-sh.org ([111.68.239.195]:41494 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754305Ab2EQIdm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 04:33:42 -0400
Date: Thu, 17 May 2012 17:32:13 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Minchan Kim <minchan@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Russell King <linux@arm.linux.org.uk>,
        Ralf Baechle <ralf@linux-mips.org>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Chen Liqin <liqin.chen@sunplusct.com>
Subject: Re: [PATCH v2 1/3] zsmalloc: support zsmalloc to ARM, MIPS, SUPERH
Message-ID: <20120517083213.GC14027@linux-sh.org>
References: <1337133919-4182-1-git-send-email-minchan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337133919-4182-1-git-send-email-minchan@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2012 at 11:05:17AM +0900, Minchan Kim wrote:
> About local_flush_tlb_kernel_range,
> If architecture is very smart, it could flush only tlb entries related to vaddr.
> If architecture is smart, it could flush only tlb entries related to a CPU.
> If architecture is _NOT_ smart, it could flush all entries of all CPUs.
> So, it would be best to support both portability and performance.
> 
..

> Need double check about supporting local_flush_tlb_kernel_range
> in ARM, MIPS, SUPERH maintainers. And I will Ccing unicore32 and
> score maintainers because arch directory in those arch have
> local_flush_tlb_kernel_range, too but I'm very unfamiliar with those
> architecture so pass it to maintainers.
> I didn't coded up dumb local_flush_tlb_kernel_range which flush
> all cpus. I expect someone need ZSMALLOC will implement it easily in future.
> 

One thing you might consider is providing a stubbed definition that wraps
to flush_tlb_kernel_range() in the !SMP case, as this will extend your
testing coverage for staging considerably.

Once you exclude all of the non-SMP platforms, you're left with the
following:

	- blackfin: doesn't count, no TLB to worry about.
	- hexagon: seems to imply that the SMP case uses thread-based
	  CPUs that share an MMU, so no additional cost.
	- ia64: Does a global flush, which already has a FIXME comment.
	- m32r, mn10300: local_flush_tlb_all() could be wrapped.
	- parisc: global flush?
	- s390: Tests the cpumask to do a local flush, otherwise has a
	  __tlb_flush_local() that can be wrapped.
	- sparc32: global flush
	- sparc64: __flush_tlb_kernel_range() looks like a local flush.
	- tile: does strange hypervisory things, presumably global.
	- x86: has a local_flush_tlb() that could be wrapped.

Which doesn't look quite that bad. You could probably get away with a
Kconfig option for optimized local TLB flushing or something, since
single function Kconfig options seem to be all the rage these days.
