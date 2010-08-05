Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759180Ab0HETNF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 15:13:05 -0400
Received: from smtp-out.google.com ([74.125.121.35]:22142 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755792Ab0HETNC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 15:13:02 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=QC5zULXaGDu18p4FYg8IBNMFwA5K0qHfL8FJynhUfQRB6gndOMuBylDV9GCY/MQ6G
	TE8pOEp0WfIKhA34Ziw4g==
MIME-Version: 1.0
In-Reply-To: <20100804114631.16cacffe.kamezawa.hiroyu@jp.fujitsu.com>
References: <201007282320.39528.linux@rainbow-software.org>
	<201007282334.08063.rjw@sisk.pl>
	<20100729132325.59871484.kamezawa.hiroyu@jp.fujitsu.com>
	<AANLkTim5STgpNEdh3JSU_BG5X8Wxh-gbXDmWYLdufNb3@mail.gmail.com>
	<20100804083652.92b5b2df.kamezawa.hiroyu@jp.fujitsu.com>
	<20100804105054.af68ee5c.kamezawa.hiroyu@jp.fujitsu.com>
	<20100804113122.071a6b8c.kamezawa.hiroyu@jp.fujitsu.com>
	<20100804114631.16cacffe.kamezawa.hiroyu@jp.fujitsu.com>
Date: Thu, 5 Aug 2010 12:12:58 -0700
Message-ID: <AANLkTimi7iQbLeAS6DLZKLa7EED_eEc0WymCh-butmhm@mail.gmail.com>
Subject: Re: [BUGFIX][PATCH] fix corruption of hibernation caused by reusing 
	swap at saving image
From: Hugh Dickins <hughd@google.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrea Gelmini <andrea.gelmini@gmail.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Ondrej Zary <linux@rainbow-software.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Balbir Singh <balbir@in.ibm.com>, nigel@tuxonice.net,
        stable@kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 3, 2010 at 7:46 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Wed, 4 Aug 2010 11:31:22 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>
>> On Wed, 4 Aug 2010 10:50:54 +0900
>> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>>
>> > This patch is created against 2.6.35. CC'ed stable.
>> > Thank you for all helps.
>> >
>>
>> I'm sorry I now doubt this patch is wrong.
>
> Changed the description.
> Maybe the patch description/my understanding was wrong
> but the patch itself should work.
>
> ==
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>
> Since 2.6.31, swap_map[]'s refcounting was changed to show that
> a used swap entry is just for swap-cache, can be reused.
> Then, while scanning free entry in swap_map[], a swap entry may
> be able to be reclaimed and reused. It was by the commit
> c9e444103b5e7a5a3519f9913f59767f92e33baf.
>
> But this caused deta corruption at resume.
> The scenario is
>        - Assume a clean-swap cache, but mapped.
>        - at hibernation_snapshot[], clean-swap-cache is saved as
>          clean-swap-cache and swap_map[] is marked as SWAP_HAS_CACHE.
>        - then, save_image() is called. And reuse SWAP_HAS_CACHE entry
>          to save image, and break the contents.
>        After resume.
>        - the memory reclaim runs and finds clean-not-referenced-swap-cache
>          and discards it because it's marked as clean.
>          But here, the contents on disk and swap-cache is inconsistent.
>
> Here, memory is corrupted.

Yes, that's the scenario: I thought that was what you meant by your
original description, but this more detailed description is a better
one.

Hugh
