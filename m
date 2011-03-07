Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756784Ab1CGX02 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 18:26:28 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46309 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755982Ab1CGX01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 18:26:27 -0500
Date: Mon, 7 Mar 2011 15:25:16 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>, Petr Holasek <pholasek@redhat.com>,
        linux-kernel@vger.kernel.org, emunson@mgebm.net, anton@redhat.com,
        Andi Kleen <ak@linux.intel.com>, Mel Gorman <mel@csn.ul.ie>,
        Wu Fengguang <fengguang.wu@intel.com>, linux-mm@kvack.org
Subject: Re: [PATCH] hugetlb: /proc/meminfo shows data for all sizes of
 hugepages
Message-Id: <20110307152516.fee931bb.akpm@linux-foundation.org>
In-Reply-To: <20110307231448.GA2946@spritzera.linux.bs1.fc.nec.co.jp>
References: <1299503155-6210-1-git-send-email-pholasek@redhat.com>
	<1299527214.8493.13263.camel@nimitz>
	<20110307145149.97e6676e.akpm@linux-foundation.org>
	<20110307231448.GA2946@spritzera.linux.bs1.fc.nec.co.jp>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Mar 2011 08:14:49 +0900
Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> wrote:

> On Mon, Mar 07, 2011 at 02:51:49PM -0800, Andrew Morton wrote:
> > On Mon, 07 Mar 2011 11:46:54 -0800
> > Dave Hansen <dave@linux.vnet.ibm.com> wrote:
> >
> > > On Mon, 2011-03-07 at 14:05 +0100, Petr Holasek wrote:
> > > > +       for_each_hstate(h)
> > > > +               seq_printf(m,
> > > > +                               "HugePages_Total:   %5lu\n"
> > > > +                               "HugePages_Free:    %5lu\n"
> > > > +                               "HugePages_Rsvd:    %5lu\n"
> > > > +                               "HugePages_Surp:    %5lu\n"
> > > > +                               "Hugepagesize:   %8lu kB\n",
> > > > +                               h->nr_huge_pages,
> > > > +                               h->free_huge_pages,
> > > > +                               h->resv_huge_pages,
> > > > +                               h->surplus_huge_pages,
> > > > +                               1UL << (huge_page_order(h) + PAGE_SHIFT - 10));
> > > >  }
> > >
> > > It sounds like now we'll get a meminfo that looks like:
> > >
> > > ...
> > > AnonHugePages:    491520 kB
> > > HugePages_Total:       5
> > > HugePages_Free:        2
> > > HugePages_Rsvd:        3
> > > HugePages_Surp:        1
> > > Hugepagesize:       2048 kB
> > > HugePages_Total:       2
> > > HugePages_Free:        1
> > > HugePages_Rsvd:        1
> > > HugePages_Surp:        1
> > > Hugepagesize:    1048576 kB
> > > DirectMap4k:       12160 kB
> > > DirectMap2M:     2082816 kB
> > > DirectMap1G:     2097152 kB
> > >
> > > At best, that's a bit confusing.  There aren't any other entries in
> > > meminfo that occur more than once.  Plus, this information is available
> > > in the sysfs interface.  Why isn't that sufficient?
> > >
> > > Could we do something where we keep the default hpage_size looking like
> > > it does now, but append the size explicitly for the new entries?
> > >
> > > HugePages_Total(1G):       2
> > > HugePages_Free(1G):        1
> > > HugePages_Rsvd(1G):        1
> > > HugePages_Surp(1G):        1
> > >
> >
> > Let's not change the existing interface, please.
> >
> > Adding new fields: OK.
> > Changing the way in whcih existing fields are calculated: OKish.
> > Renaming existing fields: not OK.
> 
> How about lining up multiple values in each field like this?
> 
>   HugePages_Total:       5 2
>   HugePages_Free:        2 1
>   HugePages_Rsvd:        3 1
>   HugePages_Surp:        1 1
>   Hugepagesize:       2048 1048576 kB
>   ...
> 
> This doesn't change the field names and the impact for user space
> is still small?

It might break some existing parsers, dunno.

It was a mistake to assume that all hugepages will have the same size
for all time, and we just have to live with that mistake.

I'd suggest that we leave meminfo alone, just ensuring that its output
makes some sense.  Instead create a new interface which presents all
the required info in a sensible fashion and migrate usersapce reporting
tools over to that interface.  Just let the meminfo field die a slow
death.

It's tempting to remove the meminfo hugepage fields altogether - most
parsers _should_ be able to cope with a CONFIG_HUGETLB=n kernel.  But
that's breakage as well - some applications may be using meminfo to
detect whether the kernel supports huge pages!
