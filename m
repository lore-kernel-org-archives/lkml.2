Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751573Ab1ELERP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 00:17:15 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:35231 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845Ab1ELERO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 00:17:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=NXfVWcu8GYGk+/UqPVk+HI8sW69PFDmY/D5T+pbHzfwlR98UZjfQ7L+73vkCHfKgGK
         pU9f7zcJGYbocMr4GbqDBvUaaO/461+t4ofpCjkHVSuplcpu0Qg2U7M57b+SvZGGH30d
         dwNhlxnsOI8619fbI5BLiNelB4o1q8+qCdihM=
MIME-Version: 1.0
In-Reply-To: <20110512123942.4b641e2d.kamezawa.hiroyu@jp.fujitsu.com>
References: <20110509182110.167F.A69D9226@jp.fujitsu.com>
	<20110510171335.16A7.A69D9226@jp.fujitsu.com>
	<20110510171641.16AF.A69D9226@jp.fujitsu.com>
	<20110512095243.c57e3e83.kamezawa.hiroyu@jp.fujitsu.com>
	<BANLkTi=ya1rAqC+nMPHkBaMsoXpsCeHH=w@mail.gmail.com>
	<20110512105351.a57970d7.kamezawa.hiroyu@jp.fujitsu.com>
	<BANLkTimWOtKKj+Jq1vqHfOfQ2UvP7Xxa3g@mail.gmail.com>
	<20110512123942.4b641e2d.kamezawa.hiroyu@jp.fujitsu.com>
Date: Thu, 12 May 2011 13:17:13 +0900
Message-ID: <BANLkTi=dvb5tXxzLwY+vgG8o4eYq5f_X8Q@mail.gmail.com>
Subject: Re: [PATCH 2/4] oom: kill younger process first
From: Minchan Kim <minchan.kim@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        CAI Qian <caiqian@redhat.com>, avagin@gmail.com,
        Andrey Vagin <avagin@openvz.org>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        David Rientjes <rientjes@google.com>, Hugh Dickins <hughd@google.com>,
        Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 12, 2011 at 12:39 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Thu, 12 May 2011 11:23:38 +0900
> Minchan Kim <minchan.kim@gmail.com> wrote:
>
>> On Thu, May 12, 2011 at 10:53 AM, KAMEZAWA Hiroyuki
>> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>> > On Thu, 12 May 2011 10:30:45 +0900
>> > Minchan Kim <minchan.kim@gmail.com> wrote:
>
>> > As above implies, (B)->prev pointer is invalid pointer after list_del().
>> > So, there will be race with list modification and for_each_list_reverse under
>> > rcu_read__lock()
>> >
>> > So, when you need to take atomic lock (as tasklist lock is) is...
>> >
>> >  1) You can't check 'entry' is valid or not...
>> >    In above for_each_list_rcu(), you may visit an object which is under removing.
>> >    You need some flag or check to see the object is valid or not.
>> >
>> >  2) you want to use list_for_each_safe().
>> >    You can't do list_del() an object which is under removing...
>> >
>> >  3) You want to walk the list in reverse.
>> >
>> >  3) Some other reasons. For example, you'll access an object pointed by the
>> >    'entry' and the object is not rcu safe.
>> >
>> > make sense ?
>>
>> Yes. Thanks, Kame.
>> It seems It is caused by prev poisoning of list_del_rcu.
>> If we remove it, isn't it possible to traverse reverse without atomic lock?
>>
>
> IIUC, it's possible (Fix me if I'm wrong) but I don't like that because of 2 reasons.
>
> 1. LIST_POISON is very important information at debug.

Indeed.
But if we can get a better something although we lost debug facility,
I think it would be okay.

>
> 2. If we don't clear prev pointer, ok, we'll allow 2 directional walk of list
>   under RCU.
>   But, in following case
>   1. you are now at (C). you'll visit (C)->next...(D)
>   2. you are now at (D). you want to go back to (C) via (D)->prev.
>   3. But (D)->prev points to (B)
>
>  It's not a 2 directional list, something other or broken one.

Yes. but it shouldn't be a problem in RCU semantics.
If you need such consistency, you should use lock.

I recall old thread about it.
In http://lwn.net/Articles/262464/, mmutz and Paul already discussed
about it. :)

>  Then, the rculist is 1 directional list in nature, I think.

Yes. But Why RCU become 1 directional list is we can't find a useful usecases.

>
> So, without very very big reason, we should keep POISON.

Agree.
I don't insist on it as it's not a useful usecase for persuading Paul.
That's because it's not a hot path.

It's started from just out of curiosity.
Thanks for very much clarifying that, Kame!

-- 
Kind regards,
Minchan Kim
