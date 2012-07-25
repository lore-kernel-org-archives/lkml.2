Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194Ab2GYT2x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 15:28:53 -0400
Received: from mga02.intel.com ([134.134.136.20]:39612 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751663Ab2GYT2v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 15:28:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="171395467"
Date: Wed, 25 Jul 2012 12:28:50 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Christoph Lameter <cl@linux.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, linux-mm@kvack.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Tim Chen <tim.c.chen@linux.intel.com>, Alex Shi <alex.shu@intel.com>,
        Jan Beulich <jbeulich@novell.com>,
        Robert Richter <robert.richter@amd.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RFC 0/6] Avoid cache trashing on clearing huge/gigantic
 page
Message-ID: <20120725192850.GA4952@tassilo.jf.intel.com>
References: <1342788622-10290-1-git-send-email-kirill.shutemov@linux.intel.com>
 <alpine.DEB.2.00.1207251346250.4995@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1207251346250.4995@router.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2012 at 01:51:01PM -0500, Christoph Lameter wrote:
> On Fri, 20 Jul 2012, Kirill A. Shutemov wrote:
> 
> > From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> >
> > Clearing a 2MB huge page will typically blow away several levels of CPU
> > caches.  To avoid this only cache clear the 4K area around the fault
> > address and use a cache avoiding clears for the rest of the 2MB area.
> 
> why exempt the 4K around the fault address? Is there a regression if that
> is not exempted?

You would get an immediate cache miss when the faulting instruction
is reexecuted.

> 
> I guess for anonymous huge pages one may assume that there will be at
> least one write to one cache line in the 4k page. Is it useful to get all
> the cachelines in the page in the cache.

We did some measurements -- comparing 4K and 2MB with some tracing 
of fault patterns -- and a lot of apps don't use the full 2MB area. 
The apps with THP regressions usually used less than others.
The patchkit significantly reduced some of the regressions.

> 
> Also note that if we get later into hugepage use for the page cache we
> would want the cache to be cold because the contents have to come in from
> a storage medium.

Page cache is not cleared, so never runs this code.


-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
