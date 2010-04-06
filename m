Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751265Ab0DFEtX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 00:49:23 -0400
Received: from mga09.intel.com ([134.134.136.24]:53086 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751168Ab0DFEtN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 00:49:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.51,370,1267430400"; 
   d="scan'208";a="610512927"
Date: Tue, 6 Apr 2010 12:49:10 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Rik van Riel <riel@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH]vmscan: handle underflow for get_scan_ratio
Message-ID: <20100406044910.GA16303@localhost>
References: <20100406105324.7E30.A69D9226@jp.fujitsu.com> <20100406023043.GA12420@localhost> <20100406115543.7E39.A69D9226@jp.fujitsu.com> <20100406033114.GB13169@localhost> <4BBAAD3F.3090900@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BBAAD3F.3090900@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 06, 2010 at 11:40:47AM +0800, Rik van Riel wrote:
> On 04/05/2010 11:31 PM, Wu Fengguang wrote:
> > On Tue, Apr 06, 2010 at 10:58:43AM +0800, KOSAKI Motohiro wrote:
> >> Again, I didn't said his patch is no worth. I only said we don't have to
> >> ignore the downside.
> >
> > Right, we should document both the upside and downside.
> 
> The downside is obvious: streaming IO (used once data
> that does not fit in the cache) can push out data that
> is used more often - requiring that it be swapped in
> at a later point in time.
> 
> I understand what Shaohua's patch does, but I do not
> understand the upside.  What good does it do to increase
> the size of the cache for streaming IO data, which is
> generally touched only once?

Not that bad :)  With Shaohua's patch the anon list will typically
_never_ get scanned, just like before.

If it's mostly use-once IO, file:anon will be 1000 or even 10000, and
priority=12.  Then only anon lists larger than 16GB or 160GB will get
nr[0] >= 1.

> What kind of performance benefits can we get by doing
> that?

So vmscan behavior and performance remain the same as before.

For really large anon list, such workload is beyond our imagination.
So we cannot assert "don't scan anon list" will be a benefit.

On the other hand, in the test case of "do stream IO when most memory
occupied by tmpfs pages", it is very bad behavior refuse to scan anon
list in normal and suddenly start scanning _the whole_ anon list when
priority hits 0. Shaohua's patch helps it by gradually increasing the
scan nr of anon list as memory pressure increases.

Thanks,
Fengguang

> > The main difference happens when file:anon scan ratio>  100:1.
> >
> > For the current percent[] based computing, percent[0]=0 hence nr[0]=0
> > which disables anon list scan unconditionally, for good or for bad.
> >
> > For the direct nr[] computing,
> > - nr[0] will be 0 for typical file servers, because with priority=12
> >    and anon lru size<  1.6GB, nr[0] = (anon_size/4096)/100<  0
> > - nr[0] will be non-zero when priority=1 and anon_size>  100 pages,
> >    this stops OOM for Shaohua's test case, however may not be enough to
> >    guarantee safety (your previous reverting patch can provide this
> >    guarantee).
> >
> > I liked Shaohua's patch a lot -- it adapts well to both the
> > file-server case and the mostly-anon-pages case :)
> 
> 
