Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754382Ab2JKUBP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 16:01:15 -0400
Received: from gir.skynet.ie ([193.1.99.77]:55376 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752165Ab2JKUBO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 16:01:14 -0400
Date: Thu, 11 Oct 2012 21:01:09 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <pzijlstr@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Hillf Danton <dhillf@gmail.com>,
        Andrew Jones <drjones@redhat.com>, Dan Smith <danms@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>,
        Christoph Lameter <cl@linux.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 06/33] autonuma: teach gup_fast about pmd_numa
Message-ID: <20121011200109.GN3317@csn.ul.ie>
References: <1349308275-2174-1-git-send-email-aarcange@redhat.com>
 <1349308275-2174-7-git-send-email-aarcange@redhat.com>
 <20121011122255.GS3317@csn.ul.ie>
 <20121011170533.GP1818@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20121011170533.GP1818@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 11, 2012 at 07:05:33PM +0200, Andrea Arcangeli wrote:
> On Thu, Oct 11, 2012 at 01:22:55PM +0100, Mel Gorman wrote:
> > On Thu, Oct 04, 2012 at 01:50:48AM +0200, Andrea Arcangeli wrote:
> > > In the special "pmd" mode of knuma_scand
> > > (/sys/kernel/mm/autonuma/knuma_scand/pmd == 1), the pmd may be of numa
> > > type (_PAGE_PRESENT not set), however the pte might be
> > > present. Therefore, gup_pmd_range() must return 0 in this case to
> > > avoid losing a NUMA hinting page fault during gup_fast.
> > > 
> > 
> > So if gup_fast fails, presumably we fall back to taking the mmap_sem and
> > calling get_user_pages(). This is a heavier operation and I wonder if the
> > cost is justified. i.e. Is the performance loss from using get_user_pages()
> > offset by improved NUMA placement? I ask because we always incur the cost of
> > taking mmap_sem but only sometimes get it back from improved NUMA placement.
> > How bad would it be if gup_fast lost some of the NUMA hinting information?
> 
> Good question indeed. Now, I agree it wouldn't be bad to skip NUMA
> hinting page faults in gup_fast for no-virt usage like
> O_DIRECT/ptrace, but the only problem is that we'd lose AutoNUMA on
> the memory touched by the KVM vcpus.
> 

Ok I see, that could be in the changelog because it's not immediately
obvious. At least, it's not as obvious as the potential downside (more GUP
fallbacks). In this context there is no way to guess what type of access
it is. AFAIK, there is no way from here to tell if it's KVM calling gup
or if it's due to O_DIRECT.

> I've been also asked if the vhost-net kernel thread (KVM in kernel
> virtio backend) will be controlled by autonuma in between
> use_mm/unuse_mm and answer is yes, but to do that, it also needs
> this. (see also the flush to task_autonuma_nid and mm/task statistics in
> unuse_mm to reset it back to regular kernel thread status,
> uncontrolled by autonuma)

I can understand why it needs this now. The clearing of the statistics is
still not clear to me but I asked that question in the thread that adjusts
unuse_mm already.

> 
> $ git grep get_user_pages
> tcm_vhost.c:            ret = get_user_pages_fast((unsigned long)ptr, 1, write, &page);
> vhost.c:        r = get_user_pages_fast(log, 1, 1, &page);
> 

-- 
Mel Gorman
SUSE Labs
