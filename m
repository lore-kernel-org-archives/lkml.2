Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752286Ab1BAU4v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 15:56:51 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:60519 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751023Ab1BAU4u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 15:56:50 -0500
Subject: Re: [RFC][PATCH 0/6] more detailed per-process transparent
 hugepage statistics
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Michael J Wolf <mjwolf@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20110201203936.GB16981@random.random>
References: <20110201003357.D6F0BE0D@kernel>
	 <20110201153857.GA18740@random.random> <1296580547.27022.3370.camel@nimitz>
	 <20110201203936.GB16981@random.random>
Content-Type: text/plain; charset="ANSI_X3.4-1968"
Date: Tue, 01 Feb 2011 12:56:41 -0800
Message-ID: <1296593801.27022.3920.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-01 at 21:39 +0100, Andrea Arcangeli wrote:
> So now the speedup
> from hugepages needs to also offset the cost of the more frequent
> split/collapse events that didn't happen before.

My concern here is the downward slope.  I interpret that as saying that
we'll eventually have _zero_ THPs.  Plus, the benefits are decreasing
constantly, even though the scanning overhead is fixed (or increasing
even).

> So I guess considering the time is of the order of 2/3 hours and there
> are "only" 88G of memory, speeding up khugepaged is going to be
> beneficial considering how big boost hugepages gives to the guest with
> NPT/EPT and even bigger boost for regular shadow paging, but it also
> depends on guest. In short khugepaged by default is tuned in a way
> that can't run in the way of the CPU. 

I guess we could also try and figure out whether the khugepaged CPU
overhead really comes from the scanning or the collapsing operations
themselves.  Should be as easy as some oprofiling.

If it really is the scanning, I bet we could be a lot more efficient
with khugepaged as well.  In the case of KVM guests, we're going to have
awfully fixed virtual addresses and processes where collapsing can take
place.

It might make sense to just have split_huge_page() stick the vaddr and
the mm in a queue.  khugepaged could scan those addresses first instead
of just going after the system as a whole.

For cases where the page got split, but wasn't modified, should we have
a non-copying, non-allocating fastpath to re-merge it?

-- Dave

