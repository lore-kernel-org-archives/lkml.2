Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754284Ab1GMATW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 20:19:22 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:51009 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203Ab1GMATV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 20:19:21 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4E1CE48C.2070402@jp.fujitsu.com>
Date: Wed, 13 Jul 2011 09:19:24 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.18) Gecko/20110616 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: chris@chris-wilson.co.uk
CC: keithp@keithp.com, linux-kernel@vger.kernel.org, airlied@linux.ie,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH] i915: slab shrinker have to return -1 if it cant shrink
 any objects
References: <4E0444CA.3080407@jp.fujitsu.com> <yuny60kt1nx.fsf@aiko.keithp.com> <1309424153_44559@CP5-2952> <4E1C15B2.9020800@jp.fujitsu.com> <d08817$ot4e1@azsmga001.ch.intel.com>
In-Reply-To: <d08817$ot4e1@azsmga001.ch.intel.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/07/12 19:06), Chris Wilson wrote:
> On Tue, 12 Jul 2011 18:36:50 +0900, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
>> Hi,
>>
>> sorry for the delay.
>>
>>> On Wed, 29 Jun 2011 20:53:54 -0700, Keith Packard <keithp@keithp.com> wrote:
>>>> On Fri, 24 Jun 2011 17:03:22 +0900, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
>>>>
>>>>> Now, i915_gem_inactive_shrink() should return -1 instead of 0 if it
>>>>> can't take a lock. Otherwise, vmscan is getting a lot of confusing
>>>>> because vmscan can't distinguish "can't take a lock temporary" and
>>>>> "we've shrank all of i915 objects".
>>>>
>>>> This doesn't look like the cleanest change possible. I think it would be
>>>> better if the shrink function could uniformly return an error
>>>> indication so that we wouldn't need the weird looking conditional return.
>>
>> shrink_icache_memory() is good sample code.
>> It doesn't take a lock if sc->nr_to_scan==0. i915_gem_inactive_shrink() should do
>> it too, ideally.
>>
>> My patch only take a first-aid.
>>
>> Plus, if I understand correctly, i915_gem_inactive_shrink() have more fundamental
>> issue. actually, shrinker code shouldn't use mutex. Instead, use spinlock.
> Why? The shrinker code is run in a non-atomic context that is explicitly
> allowed to wait, or so I thought. Where's the caveat that prevents mutex?
> Why doesn't the kernel complain?

The matter is not in contention. The problem is happen if the mutex is taken
by shrink_slab calling thread. i915_gem_inactive_shrink() have no way to shink
objects. How do you detect such case?

>> IOW, Don't call kmalloc(GFP_KERNEL) while taking dev->struct_mutex. Otherwise,
>> vmscan in its call path completely fail to shrink i915 cache and it makes big
>> memory reclaim confusing if i915 have a lot of shrinkable pages.
> 
> i915 can have several GiB of shrinkable pages. Of which 2 GiB may be tied
> up in the GTT upon which we have to wait for the GPU to release. In the
> future, we will be able to tie up all of physical memory.
> 
> There is only a single potential kmalloc in the shrinker path, for which
> we could preallocate a request so that we always have one available here.

Again, waiting is no problem if it is enough little time. btw, I think
preallocation must be implemented, otherwise shrinker have no guarantee to
shrink.

thanks.


>>> Unless I am mistaken, and there are more patches in flight, the return
>>> code from i915_gem_inactive_shrink() is promoted to unsigned long and then
>>> used in the calculation of how may objects to evict...
>>
>> shrinker->shrink has int type value. you can't change i915_gem_inactive_shrink()
>> unless generic shrinker code.
>> Do you really want to change it?
> 
> No, just pointing out that the patch causes warnings from the shrinker
> code as it tries to process (unsigned long)-1 objects. shrink_slab() does
> not use <0 as an error code!

Look.

unsigned long shrink_slab(struct shrink_control *shrink,
                          unsigned long nr_pages_scanned,
                          unsigned long lru_pages)
{
(snip)
                while (total_scan >= SHRINK_BATCH) {
                        long this_scan = SHRINK_BATCH;
                        int shrink_ret;
                        int nr_before;

                        nr_before = do_shrinker_shrink(shrinker, shrink, 0);
                        shrink_ret = do_shrinker_shrink(shrinker, shrink,
                                                        this_scan);
                        if (shrink_ret == -1)
                                break;

