Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759305Ab1FWNBn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 09:01:43 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53571 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758942Ab1FWNBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 09:01:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=VsYoDhTTw1UxUSqIIwMvMXLEKVAJLvQu5GMiJ17/alvqus/EHLcho3ZQTethi3K8kV
         UTdGf3IcyS4blcvmzYStyhfQiZtEJPZLpLjQyLjkX4itCLprpKKMc2cieZopDGtjkoKy
         fU3X1uOamhIqOxrfegMan7pJNJaShDNZp92bI=
MIME-Version: 1.0
In-Reply-To: <20110623115855.GF31593@tiehlicka.suse.cz>
References: <20110622120635.GB14343@tiehlicka.suse.cz>
	<20110622121516.GA28359@infradead.org>
	<20110622123204.GC14343@tiehlicka.suse.cz>
	<20110623150842.d13492cd.kamezawa.hiroyu@jp.fujitsu.com>
	<20110623074133.GA31593@tiehlicka.suse.cz>
	<20110623170811.16f4435f.kamezawa.hiroyu@jp.fujitsu.com>
	<20110623090204.GE31593@tiehlicka.suse.cz>
	<20110623190157.1bc8cbb9.kamezawa.hiroyu@jp.fujitsu.com>
	<20110623115855.GF31593@tiehlicka.suse.cz>
Date: Thu, 23 Jun 2011 22:01:40 +0900
Message-ID: <BANLkTimshUCY5Yq5g9dnY0gi2TRneGscug@mail.gmail.com>
Subject: Re: [PATCH] mm: preallocate page before lock_page at filemap COW.
 (WasRe: [PATCH V2] mm: Do not keep page locked during page fault while
 charging it for memcg
From: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        Michel Lespinasse <walken@google.com>, Mel Gorman <mgorman@suse.de>,
        Lutz Vieweg <lvml@5t9.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/6/23 Michal Hocko <mhocko@suse.cz>:
> On Thu 23-06-11 19:01:57, KAMEZAWA Hiroyuki wrote:
>> On Thu, 23 Jun 2011 11:02:04 +0200
>> Michal Hocko <mhocko@suse.cz> wrote:
>>
>> > On Thu 23-06-11 17:08:11, KAMEZAWA Hiroyuki wrote:
>> > > On Thu, 23 Jun 2011 09:41:33 +0200
>> > > Michal Hocko <mhocko@suse.cz> wrote:
>> > [...]
>> > > > Other than that:
>> > > > Reviewed-by: Michal Hocko <mhocko@suse.cz>
>> > > >
>> > >
>> > > I found the page is added to LRU before charging. (In this case,
>> > > memcg's LRU is ignored.) I'll post a new version with a fix.
>> >
>> > Yes, you are right. I have missed that.
>> > This means that we might race with reclaim which could evict the COWed
>> > page wich in turn would uncharge that page even though we haven't
>> > charged it yet.
>> >
>> > Can we postpone page_add_new_anon_rmap to the charging path or it would
>> > just race somewhere else?
>> >
>>
>> I got a different idea. How about this ?
>> I think this will have benefit for non-memcg users under OOM, too.
>
> Could you be more specific? I do not see how preallocation which might
> turn out to be pointless could help under OOM.
>

We'll have no page allocation under lock_page() held in this path.
I think it is good.

>>
>> A concerns is VM_FAULT_RETRY case but wait-for-lock will be much heavier
>> than preallocation + free-for-retry cost.
>
> Preallocation is rather costly when fault handler fails (e.g. SIGBUS
> which is the easiest one to trigger).
>
I think pcp cache of free page allocater does enough good job and I guess
we'll see no problem even if there is a storm of SIGBUS.

> I am not saying this approach is bad but I think that preallocation can
> be much more costly than unlock, charge and lock&recheck approach.

memcg_is_disabled() cannot help ROOT cgroup. And additional
lock/unlock method may kill FAULT_RETRY at lock contention optimization
which was added recently.


Thanks,
-Kame
