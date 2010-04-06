Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756976Ab0DFB2H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 21:28:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:55680 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756532Ab0DFB2B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 21:28:01 -0400
Message-ID: <4BBA8DF9.8010409@kernel.org>
Date: Tue, 06 Apr 2010 10:27:21 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Christoph Lameter <cl@linux-foundation.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>, alex.shi@intel.com,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Ma, Ling" <ling.ma@intel.com>, "Chen, Tim C" <tim.c.chen@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: hackbench regression due to commit 9dfc6e68bfe6e
References: <1269506457.4513.141.camel@alexs-hp.sh.intel.com>	 <alpine.DEB.2.00.1003250942080.2670@router.home>	 <1269570902.9614.92.camel@alexs-hp.sh.intel.com>	 <1270114166.2078.107.camel@ymzhang.sh.intel.com>	 <alpine.DEB.2.00.1004011050340.16531@router.home>	 <1270195589.2078.116.camel@ymzhang.sh.intel.com>	 <alpine.DEB.2.00.1004050853300.23149@router.home> <i2z84144f021004051030k7ff5190cyc083aa12c552dfac@mail.gmail.com>
In-Reply-To: <i2z84144f021004051030k7ff5190cyc083aa12c552dfac@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 06 Apr 2010 01:27:23 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 04/06/2010 02:30 AM, Pekka Enberg wrote:
>> Hmnmmm... The dynamic percpu areas use page tables and that data is used
>> in the fast path. Maybe the high thread count causes tlb trashing?
> 
> Hmm indeed. I don't see anything particularly funny in the SLUB percpu
> conversion so maybe this is a more issue with the new percpu
> allocator?

By default, percpu allocator embeds the first chunk in the kernel
linear mapping and accesses there shouldn't involve any TLB overhead.
>From the second chunk on, they're mapped page-by-page into vmalloc
area.  This can be updated to use larger page mapping but 2M page
per-cpu is pretty large and the trade off hasn't been right yet.

The amount reserved for dynamic allocation in the first chunk is
determined by PERCPU_DYNAMIC_RESERVE constant in
include/linux/percpu.h.  It's currently 20k on 64bit machines and 12k
on 32bit.  The intention was to size this such that most common stuff
is allocated from this area.  The 20k and 12k are numbers that I
pulled out of my ass :-) with the custom config I used.  Now that more
stuff has been converted to dynamic percpu, it's quite possible that
the area is too small.  Can you please try to increase the size of the
area (say 2 or 4 times) and see whether the performance regression
goes away?

Thanks.

-- 
tejun
