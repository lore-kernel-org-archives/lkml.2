Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751288Ab0HTFF2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 01:05:28 -0400
Received: from mga11.intel.com ([192.55.52.93]:30143 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751016Ab0HTFF1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 01:05:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,237,1280732400"; 
   d="scan'208";a="598490657"
Date: Fri, 20 Aug 2010 13:05:24 +0800
From: Shaohua Li <shaohua.li@intel.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Wu, Fengguang" <fengguang.wu@intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [TESTCASE] Clean pages clogging the VM
Message-ID: <20100820050524.GA19952@sli10-desk.sh.intel.com>
References: <20100809133000.GB6981@wil.cx>
 <20100817195001.GA18817@linux.intel.com>
 <20100818141308.GD1779@cmpxchg.org>
 <20100818160613.GE9431@localhost>
 <20100818160731.GA15002@localhost>
 <20100819115106.GG1779@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100819115106.GG1779@cmpxchg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 19, 2010 at 07:51:06PM +0800, Johannes Weiner wrote:
> On Thu, Aug 19, 2010 at 12:07:31AM +0800, Wu Fengguang wrote:
> > On Thu, Aug 19, 2010 at 12:06:13AM +0800, Wu Fengguang wrote:
> > > On Wed, Aug 18, 2010 at 04:13:08PM +0200, Johannes Weiner wrote:
> > > > Hi Matthew,
> > > > 
> > > > On Tue, Aug 17, 2010 at 03:50:01PM -0400, Matthew Wilcox wrote:
> > > > > 
> > > > > No comment on this?  Was it just that I posted it during the VM summit?
> > > > 
> > > > I have not forgotten about it.  I just have a hard time reproducing
> > > > those extreme stalls you observed.
> > > > 
> > > > Running that test on a 2.5GHz machine with 2G of memory gives me
> > > > stalls of up to half a second.  The patchset I am experimenting with
> > > > gets me down to peaks of 70ms, but it needs further work.
> > > > 
> > > > Mapped file pages get two rounds on the LRU list, so once the VM
> > > > starts scanning, it has to go through all of them twice and can only
> > > > reclaim them on the second encounter.
> > > > 
> > > > At that point, since we scan without making progress, we start waiting
> > > > for IO, which is not happening in this case, so we sit there until a
> > > > timeout expires.
> > > 
> > > Right, this could lead to some 1s stall. Shaohua and me also noticed
> > > this when investigating the responsiveness issues. And we are wondering
> > > if it makes sense to do congestion_wait() only when the bdi is really
> > > congested? There are no IO underway anyway in this case.
> 
> I am currently trying to get rid of all the congestion_wait() in the VM.
> They are used for different purposes, so they need different replacement
> mechanisms.
> 
> I saw Shaohua's patch to make congestion_wait() cleverer.  But I really
> think that congestion is not a good predicate in the first place.  Why
> would the VM care about IO _congestion_?  It needs a bunch of pages to
> complete IO, whether the writing device is congested is not really
> useful information at this point, I think.
> 
> > > > since I can not reproduce your observations, I don't know if this is
> > > > the (sole) source of the problem.  Can I send you patches?
> > > 
> > > Sure.
> 
> Cool!
congestion_wait() isn't the sole source in my test.
with congestion_wait() removed, the max latency is ~50ms.
while if I made the mmaped page reclaimed in one round (makes page_check_references
return PAGEREF_RECLAIM_CLEAN for mmaped pages) in the test, the max latency is ~150us.

Thanks,
Shaohua
