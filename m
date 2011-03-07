Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756632Ab1CGXrb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 18:47:31 -0500
Received: from smtp-out.google.com ([216.239.44.51]:42258 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754063Ab1CGXr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 18:47:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=I/0MQCfmty0Q/5GHfC/bekvbZuzmzMQ6x9xXeHFqhiY+2L+qN4ofWjiLBErEigFWi2
         3v9Vfm3qzIsBvHxgEWtg==
Date: Mon, 7 Mar 2011 15:47:23 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Petr Holasek <pholasek@redhat.com>, linux-kernel@vger.kernel.org,
        emunson@mgebm.net, anton@redhat.com, Andi Kleen <ak@linux.intel.com>,
        Mel Gorman <mel@csn.ul.ie>, Wu Fengguang <fengguang.wu@intel.com>,
        Nishanth Aravamudan <nacc@us.ibm.com>, linux-mm@kvack.org
Subject: Re: [PATCH] hugetlb: /proc/meminfo shows data for all sizes of
 hugepages
In-Reply-To: <20110307152516.fee931bb.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.1103071543460.22274@chino.kir.corp.google.com>
References: <1299503155-6210-1-git-send-email-pholasek@redhat.com> <1299527214.8493.13263.camel@nimitz> <20110307145149.97e6676e.akpm@linux-foundation.org> <20110307231448.GA2946@spritzera.linux.bs1.fc.nec.co.jp>
 <20110307152516.fee931bb.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Mar 2011, Andrew Morton wrote:

> > > > On Mon, 2011-03-07 at 14:05 +0100, Petr Holasek wrote:
> > > > > +       for_each_hstate(h)
> > > > > +               seq_printf(m,
> > > > > +                               "HugePages_Total:   %5lu\n"
> > > > > +                               "HugePages_Free:    %5lu\n"
> > > > > +                               "HugePages_Rsvd:    %5lu\n"
> > > > > +                               "HugePages_Surp:    %5lu\n"
> > > > > +                               "Hugepagesize:   %8lu kB\n",
> > > > > +                               h->nr_huge_pages,
> > > > > +                               h->free_huge_pages,
> > > > > +                               h->resv_huge_pages,
> > > > > +                               h->surplus_huge_pages,
> > > > > +                               1UL << (huge_page_order(h) + PAGE_SHIFT - 10));
> > > > >  }
> > > >
> > > > It sounds like now we'll get a meminfo that looks like:
> > > >
> > > > ...
> > > > AnonHugePages:    491520 kB
> > > > HugePages_Total:       5
> > > > HugePages_Free:        2
> > > > HugePages_Rsvd:        3
> > > > HugePages_Surp:        1
> > > > Hugepagesize:       2048 kB
> > > > HugePages_Total:       2
> > > > HugePages_Free:        1
> > > > HugePages_Rsvd:        1
> > > > HugePages_Surp:        1
> > > > Hugepagesize:    1048576 kB
> > > > DirectMap4k:       12160 kB
> > > > DirectMap2M:     2082816 kB
> > > > DirectMap1G:     2097152 kB
> > > >
> > > > At best, that's a bit confusing.  There aren't any other entries in
> > > > meminfo that occur more than once.  Plus, this information is available
> > > > in the sysfs interface.  Why isn't that sufficient?
> > > >
> > > > Could we do something where we keep the default hpage_size looking like
> > > > it does now, but append the size explicitly for the new entries?
> > > >
> > > > HugePages_Total(1G):       2
> > > > HugePages_Free(1G):        1
> > > > HugePages_Rsvd(1G):        1
> > > > HugePages_Surp(1G):        1
> > > >
> > >
> > > Let's not change the existing interface, please.
> > >
> > > Adding new fields: OK.
> > > Changing the way in whcih existing fields are calculated: OKish.
> > > Renaming existing fields: not OK.
> > 
> > How about lining up multiple values in each field like this?
> > 
> >   HugePages_Total:       5 2
> >   HugePages_Free:        2 1
> >   HugePages_Rsvd:        3 1
> >   HugePages_Surp:        1 1
> >   Hugepagesize:       2048 1048576 kB
> >   ...
> > 
> > This doesn't change the field names and the impact for user space
> > is still small?
> 
> It might break some existing parsers, dunno.
> 
> It was a mistake to assume that all hugepages will have the same size
> for all time, and we just have to live with that mistake.
> 

I'm not sure it was a mistake: the kernel has a default hugepage size and 
that's what the global /proc/sys/vm/nr_hugepages tunable uses, so it seems 
appropriate that its statistics are exported in the global /proc/meminfo.

> I'd suggest that we leave meminfo alone, just ensuring that its output
> makes some sense.  Instead create a new interface which presents all
> the required info in a sensible fashion and migrate usersapce reporting
> tools over to that interface.  Just let the meminfo field die a slow
> death.
> 

(Adding Nishanth to the cc)

It's already there, all this data is available for all the configured 
hugepage sizes via /sys/kernel/mm/hugepages/hugepages-<size>kB/ as 
described by Documentation/ABI/testing/sysfs-kernel-mm-hugepages.

It looks like Nishanth and others put quite a bit of effort into making as 
stable of an API as possible for this information.
