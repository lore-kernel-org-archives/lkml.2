Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965068Ab1GMITZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 04:19:25 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:36211 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965047Ab1GMITX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 04:19:23 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4E1D550A.80301@jp.fujitsu.com>
Date: Wed, 13 Jul 2011 17:19:22 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.18) Gecko/20110616 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: chris@chris-wilson.co.uk
CC: keithp@keithp.com, linux-kernel@vger.kernel.org, airlied@linux.ie,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH] i915: slab shrinker have to return -1 if it cant shrink
 any objects
References: <4E0444CA.3080407@jp.fujitsu.com> <yuny60kt1nx.fsf@aiko.keithp.com> <1309424153_44559@CP5-2952> <4E1C15B2.9020800@jp.fujitsu.com> <d08817$ot4e1@azsmga001.ch.intel.com> <4E1CE48C.2070402@jp.fujitsu.com> <d08817$pb86v@azsmga001.ch.intel.com>
In-Reply-To: <d08817$pb86v@azsmga001.ch.intel.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/07/13 16:41), Chris Wilson wrote:
> On Wed, 13 Jul 2011 09:19:24 +0900, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
>> (2011/07/12 19:06), Chris Wilson wrote:
>>> On Tue, 12 Jul 2011 18:36:50 +0900, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
>>>> Hi,
>>>>
>>>> sorry for the delay.
>>>>
>>>>> On Wed, 29 Jun 2011 20:53:54 -0700, Keith Packard <keithp@keithp.com> wrote:
>>>>>> On Fri, 24 Jun 2011 17:03:22 +0900, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
>> The matter is not in contention. The problem is happen if the mutex is taken
>> by shrink_slab calling thread. i915_gem_inactive_shrink() have no way to shink
>> objects. How do you detect such case?
> 
> In the primary allocator for the backing pages whilst the mutex is held we
> do __NORETRY and a manual shrinkage of our buffers before failing. That's
> the largest allocator, all the others are tiny and short-lived by
> comparison and left to fail.

__NORETRY perhaps might help to avoid false positive oom. But, __NORETRY still makes
full page reclaim and may drop a lot of innocent page cache, and then system may
become slow down.

Of course, you don't meet such worst case scenario so easy. But you may need to
think worst case if you touch memory management code.

> For a second process to hit shrink_slab whilst the driver is blocked on
> the GPU, that is... unfortunate. Dropping that lock across that wait is
> achievable, just very complicated.

I think that's no problem. waiting and complicated slow path have no matter
if it's only exceptional case. That don't makes false positive memory starvation.

thx.


>>> No, just pointing out that the patch causes warnings from the shrinker
>>> code as it tries to process (unsigned long)-1 objects. shrink_slab() does
>>> not use <0 as an error code!
>>
>> Look.
>>
>> unsigned long shrink_slab(struct shrink_control *shrink,
>>                           unsigned long nr_pages_scanned,
>>                           unsigned long lru_pages)
>> {
>> (snip)
>>                 while (total_scan >= SHRINK_BATCH) {
>>                         long this_scan = SHRINK_BATCH;
>>                         int shrink_ret;
>>                         int nr_before;
>>
>>                         nr_before = do_shrinker_shrink(shrinker, shrink, 0);
>>                         shrink_ret = do_shrinker_shrink(shrinker, shrink,
>>                                                         this_scan);
>>                         if (shrink_ret == -1)
>>                                 break;
>>
> 
> And fifteen lines above that you have:
>   unsigned long max_pass = do_shrinker_shrink(shrinker, shrinker, 0);
>   ...
>   shrinker->nr += f(max_pass);
>   if (shrinker->nr < 0) printk(KERN_ERR "...");
> 
> That's the *error* I hit when I originally returned -1.

You misunderstand the code. The third argument is critically important.
Only if it's 0 (ie sc->nr_to_scan==0), shrinker must not return negative.
Thus, my patch checked nr_to_scan argument. and I've suggested look at
shrink_icache_memory().

If you are thinking the shrinker protocol is too complicated, doc update
patch is really welcome.

