Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757682Ab2GFSlZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 14:41:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45791 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756051Ab2GFSlX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 14:41:23 -0400
Message-ID: <4FF73106.3090802@redhat.com>
Date: Fri, 06 Jul 2012 14:40:06 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Dan Smith <danms@us.ibm.com>,
        Bharata B Rao <bharata.rao@gmail.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [RFC][PATCH 04/26] mm, mpol: add MPOL_MF_NOOP
References: <20120316144028.036474157@chello.nl> <20120316144240.368911012@chello.nl>
In-Reply-To: <20120316144240.368911012@chello.nl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/16/2012 10:40 AM, Peter Zijlstra wrote:

Reasonable idea, but we need something else than a blind
unmap and add to swap space, which requires people to run
with gigantic amounts of swap space they will likely never
use.

I suspect that Andrea's _PAGE_NUMA stuff could be implemented
using _PAGE_PROTNONE, and then we can simply call the NUMA
faulting/migration handler whenever we run into a _PAGE_PROTNONE
page in handle_mm_fault / handle_pte_fault.

This overloading of _PAGE_PROTNONE should work fine, because
do_page_fault will never call handle_mm_fault if the fault is
happening on a PROT_NONE VMA. Only if we have the correct VMA
permission will handle_mm_fault be called, at which point we
can fix the pte (and maybe migrate the page).

The same trick can be done at the pmd level for transparent
hugepages, allowing the entire THP to be migrated in one shot,
with just one fault.

Is there any reason why _PAGE_PROTNONE could not work instead
of _PAGE_NUMA or the swap cache thing?

-- 
All rights reversed
