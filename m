Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752179Ab1IWIhd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 04:37:33 -0400
Received: from smtp-out.google.com ([216.239.44.51]:33536 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959Ab1IWIh3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 04:37:29 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=lwMjcxAMrj+WsuqCSnuasfNmnx1d1uiKZmiA4sJoBf7zWEEcY6JLXqTkr0GZOi4ix
	BBrMVXgeZzZP/BGBiAW8g==
MIME-Version: 1.0
In-Reply-To: <20110922161448.91a2e2b2.akpm@google.com>
References: <1316230753-8693-1-git-send-email-walken@google.com>
	<1316230753-8693-5-git-send-email-walken@google.com>
	<20110922161448.91a2e2b2.akpm@google.com>
Date: Fri, 23 Sep 2011 01:37:21 -0700
Message-ID: <CANN689G5CmhMVf_-jjwtKpb6P3jp+mxzV5cHz9qOMUK-UE1_DQ@mail.gmail.com>
Subject: Re: [PATCH 4/8] kstaled: minimalistic implementation.
From: Michel Lespinasse <walken@google.com>
To: Andrew Morton <akpm@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <jweiner@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Michael Wolf <mjwolf@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 22, 2011 at 4:14 PM, Andrew Morton <akpm@google.com> wrote:
> nit: please prefer to use identifier "memcg" when referring to a mem_cgroup.

OK. Done in my tree, will resend it shortly.

>> +     cb->fill(cb, "idle_clean", stats.idle_clean * PAGE_SIZE);
>> +     cb->fill(cb, "idle_dirty_file", stats.idle_dirty_file * PAGE_SIZE);
>> +     cb->fill(cb, "idle_dirty_swap", stats.idle_dirty_swap * PAGE_SIZE);
>
> So the user interface has units of bytes.  Was that documented
> somewhere?  Is it worth bothering with?  getpagesize() exists...

This is consistent with existing usage in memory.stat for example. I
think bytes is a good default unit, but I could be convinced to add
_in_bytes to all fields if you think that's needed.

> (Actually, do we have a documentation update for the entire feature?)

Patch 2 in the series augments Documentation/cgroups/memory.txt

>> +static inline void kstaled_scan_page(struct page *page)
>
> uninline this.  You may find that the compiler already uninlined it.
> Or it might inline it for you even if it wasn't declared inline.  gcc
> does a decent job of optimizing this stuff for us and hints are often
> unneeded.

I tend to manually inline functions that have one single call site.
Some time ago the compilers weren't smart about this, but I suppose
they might have improved. I don't care very strongly either way so
I'll just uninline it as suggested.

>> +     else if (!trylock_page(page)) {
>> +             /*
>> +              * We need to lock the page to dereference the mapping.
>> +              * But don't risk sleeping by calling lock_page().
>> +              * We don't want to stall kstaled, so we conservatively
>> +              * count locked pages as unreclaimable.
>> +              */
>
> hm.  Pages are rarely locked for very long.  They aren't locked during
> writeback.   I question the need for this?

Pages are locked during hard page faults; this is IMO sufficient
reason for the above code.

>> +     } else {
>> +             struct address_space *mapping = page->mapping;
>> +
>> +             is_locked = true;
>> +
>> +             /*
>> +              * The page is still anon - it has been continuously referenced
>> +              * since the prior check.
>> +              */
>> +             VM_BUG_ON(PageAnon(page) || mapping != page_rmapping(page));
>
> Really?  Are you sure that an elevated refcount is sufficient to
> stabilise both of these?

The elevated refcount stabilizes PageAnon().

The mapping is stable only after the page has been locked; note that
page->mapping was read after the page was locked. Essentially I'm
asserting that page_rmapping(page) == page->mapping, which is true for
non-anon pages.

>> +static int kstaled(void *dummy)
>> +{
>> +     while (1) {
>> +             int scan_seconds;
>> +             int nid;
>> +             struct mem_cgroup *mem;
>> +
>> +             wait_event_interruptible(kstaled_wait,
>> +                              (scan_seconds = kstaled_scan_seconds) > 0);
>> +             /*
>> +              * We use interruptible wait_event so as not to contribute
>> +              * to the machine load average while we're sleeping.
>> +              * However, we don't actually expect to receive a signal
>> +              * since we run as a kernel thread, so the condition we were
>> +              * waiting for should be true once we get here.
>> +              */
>> +             BUG_ON(scan_seconds <= 0);
>> +
>> +             for_each_mem_cgroup_all(mem)
>> +                     memset(&mem->idle_scan_stats, 0,
>> +                            sizeof(mem->idle_scan_stats));
>> +
>> +             for_each_node_state(nid, N_HIGH_MEMORY)
>> +                     kstaled_scan_node(NODE_DATA(nid));
>> +
>> +             for_each_mem_cgroup_all(mem) {
>> +                     write_seqcount_begin(&mem->idle_page_stats_lock);
>> +                     mem->idle_page_stats = mem->idle_scan_stats;
>> +                     mem->idle_page_scans++;
>> +                     write_seqcount_end(&mem->idle_page_stats_lock);
>> +             }
>> +
>> +             schedule_timeout_interruptible(scan_seconds * HZ);
>> +     }
>> +
>> +     BUG();
>> +     return 0;       /* NOT REACHED */
>> +}
>
> OK, I'm really confused.
>
> Take a minimal machine with a single node which contains one zone.
>
> AFAICT this code will measure the number of idle pages in that zone and
> then will attribute that number into *every* cgroup in the system.
> With no discrimination between them.  So it really provided no useful
> information at all.

what happens is that we maintain two sets of stats per cgroup:
- idle_scan_stats is reset to 0 at the start of the scan, its counters
get incremented as we scan the node and find idle pages.
- idle_page_stats is what we export; at the end of a scan the tally
from the same cgroup's idle_scan_stats gets copied into this.

> I was quite surprised to see a physical page scan!  I'd have expected
> kstaled to be doing pte tree walks.

We haven't gone that way for two reasons:
- we wanted to find hot and cold file pages as well, even for files
that never get mapped into processes.
- executable files that are run periodically should appear as hot,
even if the executable is not running at the time we happen to scan.

>> +static ssize_t kstaled_scan_seconds_store(struct kobject *kobj,
>> +                                       struct kobj_attribute *attr,
>> +                                       const char *buf, size_t count)
>> +{
>> +     int err;
>> +     unsigned long input;
>> +
>> +     err = strict_strtoul(buf, 10, &input);
>
> Please use the new kstrto*() interfaces when merging up to mainline.

Done. I wasn't aware of this interface, thanks!

> I wonder if one thread machine-wide will be sufficient.  We might end
> up with per-nice threads, for example.  Like kswapd.

I can comment on the history there.

In our fakenuma based implementation we started with per-node scanning
threads. However, it turned out that for very large files, two
scanning threads could end up scanning pages that share the same
mapping so that the mapping's i_mmap_mutex would get contended. And
the same problem would also show up with large anon VMA regions and
page_lock_anon_vma(). So, we ended up needing to ensure one thread
would scan all fakenuma nodes assigned to a given cgroup, in order to
avoid performance problems.

With memcg we can't as easily know which pages to scan for a given
cgroup, so we end up with one single thread scanning the entire
memory. It's been working good enough for the memory sized and scan
rates we're interested in so far.

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
