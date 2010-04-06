Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751323Ab0DFI03 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 04:26:29 -0400
Received: from mga09.intel.com ([134.134.136.24]:38552 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751048Ab0DFI0X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 04:26:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.51,371,1267430400"; 
   d="scan'208";a="610551402"
Subject: Re: hackbench regression due to commit 9dfc6e68bfe6e
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <cl@linux-foundation.org>, alex.shi@intel.com,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Ma, Ling" <ling.ma@intel.com>, "Chen, Tim C" <tim.c.chen@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <4BBA8DF9.8010409@kernel.org>
References: <1269506457.4513.141.camel@alexs-hp.sh.intel.com>
	 <alpine.DEB.2.00.1003250942080.2670@router.home>
	 <1269570902.9614.92.camel@alexs-hp.sh.intel.com>
	 <1270114166.2078.107.camel@ymzhang.sh.intel.com>
	 <alpine.DEB.2.00.1004011050340.16531@router.home>
	 <1270195589.2078.116.camel@ymzhang.sh.intel.com>
	 <alpine.DEB.2.00.1004050853300.23149@router.home>
	 <i2z84144f021004051030k7ff5190cyc083aa12c552dfac@mail.gmail.com>
	 <4BBA8DF9.8010409@kernel.org>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Tue, 06 Apr 2010 16:28:17 +0800
Message-Id: <1270542497.2078.123.camel@ymzhang.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-04-06 at 10:27 +0900, Tejun Heo wrote:
> Hello,
> 
> On 04/06/2010 02:30 AM, Pekka Enberg wrote:
> >> Hmnmmm... The dynamic percpu areas use page tables and that data is used
> >> in the fast path. Maybe the high thread count causes tlb trashing?
> > 
> > Hmm indeed. I don't see anything particularly funny in the SLUB percpu
> > conversion so maybe this is a more issue with the new percpu
> > allocator?
> 
> By default, percpu allocator embeds the first chunk in the kernel
> linear mapping and accesses there shouldn't involve any TLB overhead.
> >From the second chunk on, they're mapped page-by-page into vmalloc
> area.  This can be updated to use larger page mapping but 2M page
> per-cpu is pretty large and the trade off hasn't been right yet.
> 
> The amount reserved for dynamic allocation in the first chunk is
> determined by PERCPU_DYNAMIC_RESERVE constant in
> include/linux/percpu.h.  It's currently 20k on 64bit machines and 12k
> on 32bit.  The intention was to size this such that most common stuff
> is allocated from this area.  The 20k and 12k are numbers that I
> pulled out of my ass :-) with the custom config I used.  Now that more
> stuff has been converted to dynamic percpu, it's quite possible that
> the area is too small.  Can you please try to increase the size of the
> area (say 2 or 4 times) and see whether the performance regression
> goes away?
Thanks. I tried 2 and 4 times and didn't see much improvement.
I checked /proc/vamallocinfo and it doesn't have item of pcpu_get_vm_areas
when I use 4 times of PERCPU_DYNAMIC_RESERVE.

I used perf to collect dtlb misses and LLC misses. dtlb miss data is not
stable. Sometimes, we have a bigger dtlb miss, but get a better result.

LLC misses data are more stable. Only LLC-load-misses is the clear sign now.
LLC-store-misses has no big difference.


