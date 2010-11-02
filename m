Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310Ab0KBAxP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 20:53:15 -0400
Received: from mga03.intel.com ([143.182.124.21]:15788 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752816Ab0KBAxN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 20:53:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,277,1286175600"; 
   d="scan'208";a="343318061"
Subject: Re: [PATCH 1/2] mm: page allocator: Adjust the per-cpu counter
 threshold when memory is low
From: Shaohua Li <shaohua.li@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>
In-Reply-To: <20101029124002.356bd592.akpm@linux-foundation.org>
References: <1288278816-32667-1-git-send-email-mel@csn.ul.ie>
	 <1288278816-32667-2-git-send-email-mel@csn.ul.ie>
	 <20101028150433.fe4f2d77.akpm@linux-foundation.org>
	 <20101029101210.GG4896@csn.ul.ie>
	 <20101029124002.356bd592.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 02 Nov 2010 08:53:20 +0800
Message-ID: <1288659200.8722.963.camel@sli10-conroe.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-10-30 at 03:40 +0800, Andrew Morton wrote:
> On Fri, 29 Oct 2010 11:12:11 +0100
> Mel Gorman <mel@csn.ul.ie> wrote:
> 
> > On Thu, Oct 28, 2010 at 03:04:33PM -0700, Andrew Morton wrote:
> > > On Thu, 28 Oct 2010 16:13:35 +0100
> > 
> > > 
> > > I have a feeling this problem will bite us again perhaps due to those
> > > other callsites, but we haven't found the workload yet.
> > > 
> > > I don't undestand why restore/reduce_pgdat_percpu_threshold() were
> > > called around that particular sleep in kswapd and nowhere else.
> > > 
> > > > vanilla                      11.6615%
> > > > disable-threshold            0.2584%
> > > 
> > > Wow.  That's 12% of all CPUs?  How many CPUs and what workload?
> > > 
> > 
> > 112 threads CPUs 14 sockets. Workload initialisation creates NR_CPU sparse
> > files that are 10*TOTAL_MEMORY/NR_CPU in size. Workload itself is NR_CPU
> > processes just reading their own file.
> > 
> > The critical thing is the number of sockets. For single-socket-8-thread
> > for example, vanilla was just 0.66% of time (although the patches did
> > bring it down to 0.11%).
> 
> I'm surprised.  I thought the inefficiency here was caused by CPUs
> tromping through percpu data, adding things up.  But the above info
> would indicate that the problem was caused by lots of cross-socket
> traffic?  If so, where did that come from?
>From my understanding, the problem is zone_nr_free_pages() will try to
read each cpu's ->vm_stat_diff, while other CPUs are changing their
vm_stat_diff. This will cause a lot of cache bounce.

