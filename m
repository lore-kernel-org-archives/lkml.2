Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932446Ab1FQSWS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 14:22:18 -0400
Received: from mga09.intel.com ([134.134.136.24]:13792 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932107Ab1FQSWP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 14:22:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,382,1304319600"; 
   d="scan'208";a="14850388"
Subject: Re: REGRESSION: Performance regressions from switching
 anon_vma->lock to mutex
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Andi Kleen <ak@linux.intel.com>,
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
In-Reply-To: <BANLkTinUBTYWxrF5TCuDSQuFUAyivXJXjQ@mail.gmail.com>
References: <1308097798.17300.142.camel@schen9-DESK>
	 <1308101214.15392.151.camel@sli10-conroe> <1308138750.15315.62.camel@twins>
	 <20110615161827.GA11769@tassilo.jf.intel.com>
	 <1308156337.2171.23.camel@laptop> <1308163398.17300.147.camel@schen9-DESK>
	 <1308169937.15315.88.camel@twins> <4DF91CB9.5080504@linux.intel.com>
	 <1308172336.17300.177.camel@schen9-DESK> <1308173849.15315.91.camel@twins>
	 <BANLkTim5TPKQ9RdLYRxy=mphOVKw5EXvTA@mail.gmail.com>
	 <1308255972.17300.450.camel@schen9-DESK>
	 <BANLkTinptaydNvK4ZvGvy0KVLnRmmza7tA@mail.gmail.com>
	 <BANLkTi=GPtwjQ-bYDNUYCwzW5h--y86Law@mail.gmail.com>
	 <BANLkTim-dBjva9w7AajqggKT3iUVYG2euQ@mail.gmail.com>
	 <BANLkTimLV8aCZ7snXT_Do+f4vRY0EkoS4A@mail.gmail.com>
	 <BANLkTinUBTYWxrF5TCuDSQuFUAyivXJXjQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 17 Jun 2011 11:22:43 -0700
Message-ID: <1308334963.17300.489.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-16 at 20:58 -0700, Linus Torvalds wrote:

> 
> So Tim, I'd like you to test out my first patch (that only does the
> anon_vma_clone() case) once again, but now in the cleaned-up version.
> Does this patch really make a big improvement for you? If so, this
> first step is probably worth doing regardless of the more complicated
> second step, but I'd want to really make sure it's ok, and that the
> performance improvement you saw is consistent and not a fluke.
> 
>                  Linus

Linus,

For this patch, I've run it 10 times and got an average throughput of
104.9% compared with 2.6.39 vanilla baseline.  Wide variations are seen
run to run and the difference between max and min throughput is 52% of
average value.

So to recap,

                        Throughput
2.6.39(vanilla)         100.0%
2.6.39+ra-patch         166.7%  (+66.7%)        
3.0-rc2(vanilla)         68.0%  (-32%)
3.0-rc2+linus           115.7%  (+15.7%)
3.0-rc2+linus+softirq    86.2%  (-17.3%)
3.0-rc2+linus (v2)      104.9%  (+4.9%)

The time spent in the anon_vma mutex seems to directly affect
throughput.

In one run on your patch, I got a low throughput of 90.1% vs 2.6.39
throughput. The mutex_lock occupied 15.6% of cpu.

In another run, I got a high throughput of 120.8% vs 2.6.39 throughput.
The mutex lock occupied 7.5% of cpu.

I've attached the profiles of the two runs and a 3.0-rc2 vanilla run for
your reference.

I will follow up later with numbers that has Peter's patch added.

Thanks.

Tim

----------Profiles Below-------------------------

3.0-rc2+linus(v2) run 1 (90.1% throughput vs 2.6.39)

-     15.60%          exim  [kernel.kallsyms]             [k] __mutex_lock_common.clone.5
   - __mutex_lock_common.clone.5
      - 99.99% __mutex_lock_slowpath
         - mutex_lock
            + 75.52% anon_vma_lock.clone.10
            + 23.88% anon_vma_clone
-      4.38%          exim  [kernel.kallsyms]             [k] _raw_spin_lock_irqsave
   - _raw_spin_lock_irqsave
      + 82.83% cpupri_set
      + 6.75% try_to_wake_up
      + 5.35% release_pages
      + 1.72% pagevec_lru_move_fn
      + 0.93% get_page_from_freelist
      + 0.51% lock_timer_base.clone.20
+      3.22%          exim  [kernel.kallsyms]             [k] page_fault
+      2.62%          exim  [kernel.kallsyms]             [k] do_raw_spin_lock
+      2.30%          exim  [kernel.kallsyms]             [k] mutex_unlock
+      2.02%          exim  [kernel.kallsyms]             [k] unmap_vmas


3.0-rc2_linus(v2) run 2 (120.8% throughput vs 2.6.39)

-      7.53%             exim  [kernel.kallsyms]             [k] __mutex_lock_common.clone.5
   - __mutex_lock_common.clone.5
      - 99.99% __mutex_lock_slowpath
         - mutex_lock
            + 75.99% anon_vma_lock.clone.10
            + 22.68% anon_vma_clone
            + 0.70% unlink_file_vma
-      4.15%             exim  [kernel.kallsyms]             [k] _raw_spin_lock_irqsave
   - _raw_spin_lock_irqsave
      + 83.37% cpupri_set
      + 7.06% release_pages
      + 2.74% pagevec_lru_move_fn
      + 2.18% try_to_wake_up
      + 0.99% get_page_from_freelist
      + 0.59% lock_timer_base.clone.20
      + 0.58% lock_hrtimer_base.clone.16
+      4.06%             exim  [kernel.kallsyms]             [k] page_fault
+      2.33%             exim  [kernel.kallsyms]             [k] unmap_vmas
+      2.22%             exim  [kernel.kallsyms]             [k] do_raw_spin_lock
+      2.05%             exim  [kernel.kallsyms]             [k] page_cache_get_speculative
+      1.98%             exim  [kernel.kallsyms]             [k] mutex_unlock


3.0-rc2 vanilla run 

-     18.60%          exim  [kernel.kallsyms]        [k] __mutex_lock_common.clone.5                                            ↑
   - __mutex_lock_common.clone.5                                                                                                ▮
      - 99.99% __mutex_lock_slowpath                                                                                            ▒
         - mutex_lock                                                                                                           ▒
            - 99.54% anon_vma_lock.clone.10                                                                                     ▒
               + 38.99% anon_vma_clone                                                                                          ▒
               + 37.56% unlink_anon_vmas                                                                                        ▒
               + 11.92% anon_vma_fork                                                                                           ▒
               + 11.53% anon_vma_free                                                                                           ▒
-      4.03%          exim  [kernel.kallsyms]        [k] _raw_spin_lock_irqsave                                                 ▒
   - _raw_spin_lock_irqsave                                                                                                     ▒
      + 87.25% cpupri_set                                                                                                       ▒
      + 4.75% release_pages                                                                                                     ▒
      + 3.68% try_to_wake_up                                                                                                    ▒
      + 1.17% pagevec_lru_move_fn                                                                                               ▒
      + 0.71% get_page_from_freelist                                                                                            ▒
+      3.00%          exim  [kernel.kallsyms]        [k] do_raw_spin_lock                                                       ▒
+      2.90%          exim  [kernel.kallsyms]        [k] page_fault                                                             ▒
+      2.25%          exim  [kernel.kallsyms]        [k] mutex_unlock                                                           ▒
+      1.82%          exim  [kernel.kallsyms]        [k] unmap_vmas                                                             ▒
+      1.62%          exim  [kernel.kallsyms]        [k] copy_page_c                                                            ▒


