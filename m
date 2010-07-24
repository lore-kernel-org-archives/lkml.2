Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319Ab0GXKyt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jul 2010 06:54:49 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:50400 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754479Ab0GXKys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jul 2010 06:54:48 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Nick Piggin <npiggin@kernel.dk>
Subject: Re: VFS scalability git tree
Cc: kosaki.motohiro@jp.fujitsu.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Frank Mayhar <fmayhar@google.com>, John Stultz <johnstul@us.ibm.com>
In-Reply-To: <20100724174038.3C96.A69D9226@jp.fujitsu.com>
References: <20100722190100.GA22269@amd> <20100724174038.3C96.A69D9226@jp.fujitsu.com>
Message-Id: <20100724174648.3C9F.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Sat, 24 Jul 2010 19:54:43 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > At this point, I would be very interested in reviewing, correctness
> > testing on different configurations, and of course benchmarking.
> 
> I haven't review this series so long time. but I've found one misterious
> shrink_slab() usage. can you please see my patch? (I will send it as
> another mail)

Plus, I have one question. upstream shrink_slab() calculation and your
calculation have bigger change rather than your patch description explained.

upstream:

  shrink_slab()

                                lru_scanned        max_pass
      basic_scan_objects = 4 x -------------  x -----------------------------
                                lru_pages        shrinker->seeks (default:2)

      scan_objects = min(basic_scan_objects, max_pass * 2)

  shrink_icache_memory()

                                          sysctl_vfs_cache_pressure
      max_pass = inodes_stat.nr_unused x --------------------------
                                                   100


That said, higher sysctl_vfs_cache_pressure makes higher slab reclaim.


In the other hand, your code: 
  shrinker_add_scan()

                           scanned          objects
      scan_objects = 4 x -------------  x -----------  x SHRINK_FACTOR x SHRINK_FACTOR
                           total            ratio

  shrink_icache_memory()

     ratio = DEFAULT_SEEKS * sysctl_vfs_cache_pressure / 100

That said, higher sysctl_vfs_cache_pressure makes smaller slab reclaim.


So, I guess following change honorly refrect your original intention.

New calculation is, 

  shrinker_add_scan()

                       scanned          
      scan_objects = -------------  x objects x ratio
                        total            

  shrink_icache_memory()

     ratio = DEFAULT_SEEKS * sysctl_vfs_cache_pressure / 100

This has the same behavior as upstream. because upstream's 4/shrinker->seeks = 2.
also the above has DEFAULT_SEEKS = SHRINK_FACTORx2.



===============
o move 'ratio' from denominator to numerator
o adapt kvm/mmu_shrink
o SHRINK_FACTOR / 2 (default seek) x 4 (unknown shrink slab modifier)
    -> (SHRINK_FACTOR*2) == DEFAULT_SEEKS

---
 arch/x86/kvm/mmu.c |    2 +-
 mm/vmscan.c        |   10 ++--------
 2 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index ae5a038..cea1e92 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2942,7 +2942,7 @@ static int mmu_shrink(struct shrinker *shrink,
 	}
 
 	shrinker_add_scan(&nr_to_scan, scanned, global, cache_count,
-			DEFAULT_SEEKS*10);
+			DEFAULT_SEEKS/10);
 
 done:
 	cache_count = shrinker_do_scan(&nr_to_scan, SHRINK_BATCH);
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 89b593e..2d8e9ab 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -208,14 +208,8 @@ void shrinker_add_scan(unsigned long *dst,
 {
 	unsigned long long delta;
 
-	/*
-	 * The constant 4 comes from old code. Who knows why.
-	 * This could all use a good tune up with some decent
-	 * benchmarks and numbers.
-	 */
-	delta = (unsigned long long)scanned * objects
-			* SHRINK_FACTOR * SHRINK_FACTOR * 4UL;
-	do_div(delta, (ratio * total + 1));
+	delta = (unsigned long long)scanned * objects * ratio;
+	do_div(delta, total+ 1);
 
 	/*
 	 * Avoid risking looping forever due to too large nr value:
-- 
1.6.5.2




