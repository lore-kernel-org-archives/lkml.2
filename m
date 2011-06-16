Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400Ab1FPARv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 20:17:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58183 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751573Ab1FPARs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 20:17:48 -0400
MIME-Version: 1.0
In-Reply-To: <4DF92FE1.5010208@linux.intel.com>
References: <1308097798.17300.142.camel@schen9-DESK> <1308101214.15392.151.camel@sli10-conroe>
 <1308138750.15315.62.camel@twins> <20110615161827.GA11769@tassilo.jf.intel.com>
 <1308156337.2171.23.camel@laptop> <1308163398.17300.147.camel@schen9-DESK>
 <1308169937.15315.88.camel@twins> <4DF91CB9.5080504@linux.intel.com>
 <1308172336.17300.177.camel@schen9-DESK> <1308173849.15315.91.camel@twins>
 <87ea4bd7-8b16-4b24-8fcb-d8e9b6f421ec@email.android.com> <4DF92FE1.5010208@linux.intel.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 15 Jun 2011 17:16:57 -0700
Message-ID: <BANLkTi=Tw6je7zpi4L=pE0JJpZfeEC9Jsg@mail.gmail.com>
Subject: Re: REGRESSION: Performance regressions from switching anon_vma->lock
 to mutex
To: Andi Kleen <ak@linux.intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Shaohua Li <shaohua.li@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Miller <davem@davemloft.net>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Russell King <rmk@arm.linux.org.uk>, Paul Mundt <lethal@linux-sh.org>,
        Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>,
        "Luck, Tony" <tony.luck@intel.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mel@csn.ul.ie>, Nick Piggin <npiggin@kernel.dk>,
        Namhyung Kim <namhyung@gmail.com>, "Shi, Alex" <alex.shi@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 15, 2011 at 3:19 PM, Andi Kleen <ak@linux.intel.com> wrote:
>
> Caching doesn't help because the library gets reinitialized in every child
> (it may already do caching, not fully sure for this; it does it for other
> sysconfs at least)

Why the hell do you continue to make excuses for glibc that are
*clearly*not*true*?

Stop this insanity, Andi. Do you realize that this kind of crazy
behavior just makes me convinced that there is no way in hell I should
*ever* take your sysconfig patch, since all your analysis for it is
totally worthless?

JUST LOOK AT THE NUMBERS, for chrissake!

When format_decode is 7% of the whole workload, and the top 15
functions of the profile look like this:

     6.40%        exim  [kernel.kallsyms]           [k] format_decode
     5.26%        exim  [kernel.kallsyms]           [k] page_fault
     5.05%        exim  [kernel.kallsyms]           [k] vsnprintf
     3.55%        exim  [kernel.kallsyms]           [k] number
     3.00%        exim  [kernel.kallsyms]           [k] copy_page_c
     2.88%        exim  [kernel.kallsyms]           [k] read_hpet
     2.38%        exim  libc-2.13.90.so             [.] __GI_vfprintf
     1.92%        exim  [kernel.kallsyms]           [k] kstat_irqs
     1.53%        exim  [kernel.kallsyms]           [k] find_vma
     1.47%        exim  [kernel.kallsyms]           [k] _raw_spin_lock
     1.40%        exim  [kernel.kallsyms]           [k] seq_printf
     1.34%        exim  [kernel.kallsyms]           [k] radix_tree_lookup
     1.21%        exim  [kernel.kallsyms]           [k]
page_cache_get_speculative
     1.20%        exim  [kernel.kallsyms]           [k] clear_page_c
     1.05%        exim  [kernel.kallsyms]           [k] do_page_fault

I can pretty much guarantee that it doesn't do just one /proc/stat
read per fork() just to get the number of CPU's.

/proc/stat may be slow, but it's not slower than doing real work -
unless you call it millions of times.

And you didn't actually look at glibc sources, did you? Because if you
had, you would ALSO have seen that you are totally full of sh*t. Glibc
at no point caches anything.

So repeat after me: stop making excuses and lying about glibc. It's
crap. End of story.

> I don't think glibc is crazy in this. It has no other choice.

Stop this insanity, Andi. Why do you lie or just make up arguments? WHY?

There is very clearly no caching going on. And since exim doesn't even
execve, it just forks, it's very clear that it could cache things just
ONCE, so your argument that caching wouldn't be possible at that level
is also bogus.

I can certainly agree that /proc/stat isn't wonderful (it used to be
better), but that's no excuse for just totally making up excuses for
just plain bad *stupid* behavior in user space. And it certainly
doesn't excuse just making shit up!

                           Linus
