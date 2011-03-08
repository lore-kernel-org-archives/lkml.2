Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755634Ab1CHA5T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 19:57:19 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:59378 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753933Ab1CHA5S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 19:57:18 -0500
Date: Mon, 7 Mar 2011 16:57:06 -0800
From: Nishanth Aravamudan <nacc@us.ibm.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Petr Holasek <pholasek@redhat.com>, linux-kernel@vger.kernel.org,
        emunson@mgebm.net, anton@redhat.com, Andi Kleen <ak@linux.intel.com>,
        Mel Gorman <mel@csn.ul.ie>, Wu Fengguang <fengguang.wu@intel.com>,
        linux-mm@kvack.org
Subject: Re: [PATCH] hugetlb: /proc/meminfo shows data for all sizes of
 hugepages
Message-ID: <20110308005706.GB5169@us.ibm.com>
References: <1299503155-6210-1-git-send-email-pholasek@redhat.com>
 <1299527214.8493.13263.camel@nimitz>
 <20110307145149.97e6676e.akpm@linux-foundation.org>
 <20110307231448.GA2946@spritzera.linux.bs1.fc.nec.co.jp>
 <20110307152516.fee931bb.akpm@linux-foundation.org>
 <alpine.DEB.2.00.1103071543460.22274@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1103071543460.22274@chino.kir.corp.google.com>
X-Operating-System: Linux 2.6.35-27-generic (x86_64)
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On 07.03.2011 [15:47:23 -0800], David Rientjes wrote:
> On Mon, 7 Mar 2011, Andrew Morton wrote:
> 
> > > > > On Mon, 2011-03-07 at 14:05 +0100, Petr Holasek wrote:
> > > > > > +       for_each_hstate(h)
> > > > > > +               seq_printf(m,
> > > > > > +                               "HugePages_Total:   %5lu\n"
> > > > > > +                               "HugePages_Free:    %5lu\n"
> > > > > > +                               "HugePages_Rsvd:    %5lu\n"
> > > > > > +                               "HugePages_Surp:    %5lu\n"
> > > > > > +                               "Hugepagesize:   %8lu kB\n",
> > > > > > +                               h->nr_huge_pages,
> > > > > > +                               h->free_huge_pages,
> > > > > > +                               h->resv_huge_pages,
> > > > > > +                               h->surplus_huge_pages,
> > > > > > +                               1UL << (huge_page_order(h) + PAGE_SHIFT - 10));
> > > > > >  }
> > > > >
> > > > > It sounds like now we'll get a meminfo that looks like:
> > > > >
> > > > > ...
> > > > > AnonHugePages:    491520 kB
> > > > > HugePages_Total:       5
> > > > > HugePages_Free:        2
> > > > > HugePages_Rsvd:        3
> > > > > HugePages_Surp:        1
> > > > > Hugepagesize:       2048 kB
> > > > > HugePages_Total:       2
> > > > > HugePages_Free:        1
> > > > > HugePages_Rsvd:        1
> > > > > HugePages_Surp:        1
> > > > > Hugepagesize:    1048576 kB
> > > > > DirectMap4k:       12160 kB
> > > > > DirectMap2M:     2082816 kB
> > > > > DirectMap1G:     2097152 kB
> > > > >
> > > > > At best, that's a bit confusing.  There aren't any other entries in
> > > > > meminfo that occur more than once.  Plus, this information is available
> > > > > in the sysfs interface.  Why isn't that sufficient?
> > > > >
> > > > > Could we do something where we keep the default hpage_size looking like
> > > > > it does now, but append the size explicitly for the new entries?
> > > > >
> > > > > HugePages_Total(1G):       2
> > > > > HugePages_Free(1G):        1
> > > > > HugePages_Rsvd(1G):        1
> > > > > HugePages_Surp(1G):        1
> > > > >
> > > >
> > > > Let's not change the existing interface, please.
> > > >
> > > > Adding new fields: OK.
> > > > Changing the way in whcih existing fields are calculated: OKish.
> > > > Renaming existing fields: not OK.
> > > 
> > > How about lining up multiple values in each field like this?
> > > 
> > >   HugePages_Total:       5 2
> > >   HugePages_Free:        2 1
> > >   HugePages_Rsvd:        3 1
> > >   HugePages_Surp:        1 1
> > >   Hugepagesize:       2048 1048576 kB
> > >   ...
> > > 
> > > This doesn't change the field names and the impact for user space
> > > is still small?
> > 
> > It might break some existing parsers, dunno.
> > 
> > It was a mistake to assume that all hugepages will have the same size
> > for all time, and we just have to live with that mistake.
> > 
> 
> I'm not sure it was a mistake: the kernel has a default hugepage size and 
> that's what the global /proc/sys/vm/nr_hugepages tunable uses, so it seems 
> appropriate that its statistics are exported in the global /proc/meminfo.

Yep, the intent was for meminfo to (continue to) document the default
hugepage size's usage, and for any other size's statistics to be
accessed by the appropriate sysfs entries.

> > I'd suggest that we leave meminfo alone, just ensuring that its output
> > makes some sense.  Instead create a new interface which presents all
> > the required info in a sensible fashion and migrate usersapce reporting
> > tools over to that interface.  Just let the meminfo field die a slow
> > death.
> > 
> 
> (Adding Nishanth to the cc)
> 
> It's already there, all this data is available for all the configured
> hugepage sizes via /sys/kernel/mm/hugepages/hugepages-<size>kB/ as
> described by Documentation/ABI/testing/sysfs-kernel-mm-hugepages.
> 
> It looks like Nishanth and others put quite a bit of effort into
> making as stable of an API as possible for this information.

I'm not sure if libhugetlbfs already has a tool for parsing the values
there (i.e., to give an end-user a quick'n'dirty snapshot of overall
current hugepage usage). Eric? If not, probably something worth having.
I believe we also have the per-node information in sysfs too, in case
that's relevant to tooling.

Thanks,
Nish

-- 
Nishanth Aravamudan <nacc@us.ibm.com>
IBM Linux Technology Center
