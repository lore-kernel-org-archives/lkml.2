Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932116Ab0JSFLL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 01:11:11 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:33690 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388Ab0JSFLJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 01:11:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=GzGJ1Zs/pru1YiLi0+itgO/HZtFvUwXWQQS0MN/02R7P4yV8ra0fAjDr4Wkxgd0Twu
         DgNIiLvr7gDl9YIQKghKoxFynuFup98P0ZRyoteqEuw5wGD+z5aVTmxTbn9/v6iLk4rM
         PCMabS9QSNIKpZluzPvp/OkGhHeCSEbiN2moA=
MIME-Version: 1.0
In-Reply-To: <20101019121321.A1E1.A69D9226@jp.fujitsu.com>
References: <20101019030515.GB11924@localhost>
	<AANLkTinvcGjF2-dvu8kpDY4V7kGkRJjHTWDtQPNRKMU_@mail.gmail.com>
	<20101019121321.A1E1.A69D9226@jp.fujitsu.com>
Date: Tue, 19 Oct 2010 14:11:07 +0900
Message-ID: <AANLkTi=Akuku=Sz7kw0JRB-bzP8cmirbX4XJ8qyVqmze@mail.gmail.com>
Subject: Re: Deadlock possibly caused by too_many_isolated.
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, Neil Brown <neilb@suse.de>,
        Rik van Riel <riel@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Li, Shaohua" <shaohua.li@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 12:13 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
>> On Tue, Oct 19, 2010 at 12:05 PM, Wu Fengguang <fengguang.wu@intel.com> wrote:
>> > On Tue, Oct 19, 2010 at 10:52:47AM +0800, Minchan Kim wrote:
>> >> Hi Wu,
>> >>
>> >> On Tue, Oct 19, 2010 at 11:35 AM, Wu Fengguang <fengguang.wu@intel.com> wrote:
>> >> >> @@ -2054,10 +2069,11 @@ rebalance:
>> >> >>                 goto got_pg;
>> >> >>
>> >> >>         /*
>> >> >> -        * If we failed to make any progress reclaiming, then we are
>> >> >> -        * running out of options and have to consider going OOM
>> >> >> +        * If we failed to make any progress reclaiming and there aren't
>> >> >> +        * many parallel reclaiming, then we are unning out of options and
>> >> >> +        * have to consider going OOM
>> >> >>          */
>> >> >> -       if (!did_some_progress) {
>> >> >> +       if (!did_some_progress && !too_many_isolated_zone(preferred_zone)) {
>> >> >>                 if ((gfp_mask & __GFP_FS) && !(gfp_mask & __GFP_NORETRY)) {
>> >> >>                         if (oom_killer_disabled)
>> >> >>                                 goto nopage;
>> >> >
>> >> > This is simply wrong.
>> >> >
>> >> > It disabled this block for 99% system because there won't be enough
>> >> > tasks to make (!too_many_isolated_zone == true). As a result the LRU
>> >> > will be scanned like mad and no task get OOMed when it should be.
>> >>
>> >> If !too_many_isolated_zone is false, it means there are already many
>> >> direct reclaiming tasks.
>> >> So they could exit reclaim path and !too_many_isolated_zone will be true.
>> >> What am I missing now?
>> >
>> > Ah sorry, my brain get short circuited.. but I still feel uneasy with
>> > this change. It's not fixing the root cause and won't prevent too many
>> > LRU pages be isolated. It's too late to test too_many_isolated_zone()
>> > after direct reclaim returns (after sleeping for a long time).
>> >
>>
>> Intend to agree.
>> I think root cause is a infinite looping in too_many_isolated holding FS lock.
>> Would it be simple that too_many_isolated would be bail out after some try?
>
> How?
> A lot of caller don't have good recover logic when memory allocation fail occur.
>

I means following as.

1. shrink_inactive_list
2. if too_many_isolated is looping than 5 times, it marks some
variable to notice this fail is concurrent reclaim and bail out
3. __alloc_pages_slowpath see that did_some_progress is zero and the
mark which show bailout by concurrent reclaim.
4. Instead of OOM, congestion_wait and rebalance.

While I implement it, I knew it makes code rather ugly and I thought
lost is bigger than gain.

Okay. I will drop this idea.

Thanks for advising me, Wu, KOSAKI.
-- 
Kind regards,
Minchan Kim
