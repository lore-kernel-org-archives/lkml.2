Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932428Ab2GBHTb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 03:19:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15949 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751871Ab2GBHTa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 03:19:30 -0400
Message-ID: <4FF14B56.9090906@redhat.com>
Date: Mon, 02 Jul 2012 03:18:46 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Andrea Arcangeli <aarcange@redhat.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Hillf Danton <dhillf@gmail.com>, Dan Smith <danms@us.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Bharata B Rao <bharata.rao@gmail.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Christoph Lameter <cl@linux.com>, Alex Shi <alex.shi@intel.com>,
        Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Don Morris <don.morris@hp.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 40/40] autonuma: shrink the per-page page_autonuma struct
 size
References: <1340888180-15355-1-git-send-email-aarcange@redhat.com> <1340888180-15355-41-git-send-email-aarcange@redhat.com>
In-Reply-To: <1340888180-15355-41-git-send-email-aarcange@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2012 08:56 AM, Andrea Arcangeli wrote:
>  From 32 to 12 bytes, so the AutoNUMA memory footprint is reduced to
> 0.29% of RAM.

Still not ideal, however once we get native THP migration working
it could be practical to switch to a "have a bucket with N
page_autonuma structures for every N*M pages" approach.

For example, we could have 4 struct page_autonuma pages, for 32
memory pages. That would necessitate reintroducing the page pointer
into struct page_autonuma, but it would reduce memory use by roughly
a factor 8.

To get from a struct page to a struct page_autonuma, we would have
to look at the bucket and check whether one of the page_autonuma
structs points at us. If none do, we have to claim an available one.
On migration, we would have to free our page_autonuma struct, which
would make it available for other pages to use.

This would complicate the code somewhat, and potentially slow down
the migration of 4kB pages, but with 2MB pages things could continue
exactly the way they work today.

Does this seem reasonably in any way?

> +++ b/include/linux/autonuma_list.h
> @@ -0,0 +1,94 @@
> +#ifndef __AUTONUMA_LIST_H
> +#define __AUTONUMA_LIST_H
> +
> +#include<linux/types.h>
> +#include<linux/kernel.h>

> +typedef uint32_t autonuma_list_entry;
> +#define AUTONUMA_LIST_MAX_PFN_OFFSET	(AUTONUMA_LIST_HEAD-3)
> +#define AUTONUMA_LIST_POISON1		(AUTONUMA_LIST_HEAD-2)
> +#define AUTONUMA_LIST_POISON2		(AUTONUMA_LIST_HEAD-1)
> +#define AUTONUMA_LIST_HEAD		((uint32_t)UINT_MAX)
> +
> +struct autonuma_list_head {
> +	autonuma_list_entry anl_next_pfn;
> +	autonuma_list_entry anl_prev_pfn;
> +};

This stuff needs to be documented with a large comment, explaining
what is done, what the limitations are, etc...

Having that documentation in the commit message is not going to help
somebody who is browsing the source code.

I also wonder if it would make sense to have this available as a
generic list type, not autonuma specific but an "item number list"
include file with corresponding macros.

It might be useful to have lists with item numbers, instead of
prev & next pointers, in other places in the kernel.

Besides, introducing this list type separately could make things
easier to review.


-- 
All rights reversed
