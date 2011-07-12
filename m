Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752294Ab1GLJgt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 05:36:49 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:42751 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808Ab1GLJgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 05:36:48 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4E1C15B2.9020800@jp.fujitsu.com>
Date: Tue, 12 Jul 2011 18:36:50 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.18) Gecko/20110616 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: chris@chris-wilson.co.uk
CC: keithp@keithp.com, linux-kernel@vger.kernel.org, airlied@linux.ie,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH] i915: slab shrinker have to return -1 if it cant shrink
 any objects
References: <4E0444CA.3080407@jp.fujitsu.com> <yuny60kt1nx.fsf@aiko.keithp.com> <1309424153_44559@CP5-2952>
In-Reply-To: <1309424153_44559@CP5-2952>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

sorry for the delay.

> On Wed, 29 Jun 2011 20:53:54 -0700, Keith Packard <keithp@keithp.com> wrote:
>> On Fri, 24 Jun 2011 17:03:22 +0900, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
>>
>>> Now, i915_gem_inactive_shrink() should return -1 instead of 0 if it
>>> can't take a lock. Otherwise, vmscan is getting a lot of confusing
>>> because vmscan can't distinguish "can't take a lock temporary" and
>>> "we've shrank all of i915 objects".
>>
>> This doesn't look like the cleanest change possible. I think it would be
>> better if the shrink function could uniformly return an error
>> indication so that we wouldn't need the weird looking conditional return.

shrink_icache_memory() is good sample code.
It doesn't take a lock if sc->nr_to_scan==0. i915_gem_inactive_shrink() should do
it too, ideally.

My patch only take a first-aid.

Plus, if I understand correctly, i915_gem_inactive_shrink() have more fundamental
issue. actually, shrinker code shouldn't use mutex. Instead, use spinlock.
IOW, Don't call kmalloc(GFP_KERNEL) while taking dev->struct_mutex. Otherwise,
vmscan in its call path completely fail to shrink i915 cache and it makes big
memory reclaim confusing if i915 have a lot of shrinkable pages.


> Unless I am mistaken, and there are more patches in flight, the return
> code from i915_gem_inactive_shrink() is promoted to unsigned long and then
> used in the calculation of how may objects to evict...

shrinker->shrink has int type value. you can't change i915_gem_inactive_shrink()
unless generic shrinker code.
Do you really want to change it?


