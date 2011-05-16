Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751327Ab1EPFEE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 01:04:04 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:37310 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129Ab1EPFEC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 01:04:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=FJQGUUcMI40UtjMbSHLbRRjz015uJAtNSD0JH7U1H2QrZQLs4TS6ItT2k0CD69mNTm
         RJO8SpaxqIusUbm+r7CyDQIXTxeRzCic8vm1gRAFiqvDbN25TjbM2is+1DIrSjIRvXqG
         RtXNNdUfrICtnFYI6cohQvMnAQKC1eWlJB0h0=
MIME-Version: 1.0
In-Reply-To: <1305519711.4806.7.camel@mulgrave.site>
References: <1305295404-12129-1-git-send-email-mgorman@suse.de>
	<1305295404-12129-5-git-send-email-mgorman@suse.de>
	<4DCFAA80.7040109@jp.fujitsu.com>
	<1305519711.4806.7.camel@mulgrave.site>
Date: Mon, 16 May 2011 14:04:00 +0900
Message-ID: <BANLkTi=oe4Ties6awwhHFPf42EXCn2U4MQ@mail.gmail.com>
Subject: Re: [PATCH 4/4] mm: vmscan: If kswapd has been running too long,
 allow it to sleep
From: Minchan Kim <minchan.kim@gmail.com>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, mgorman@suse.de,
        akpm@linux-foundation.org, colin.king@canonical.com,
        raghu.prabhu13@gmail.com, jack@suse.cz, chris.mason@oracle.com,
        cl@linux.com, penberg@kernel.org, riel@redhat.com, hannes@cmpxchg.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 16, 2011 at 1:21 PM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Sun, 2011-05-15 at 19:27 +0900, KOSAKI Motohiro wrote:
>> (2011/05/13 23:03), Mel Gorman wrote:
>> > Under constant allocation pressure, kswapd can be in the situation where
>> > sleeping_prematurely() will always return true even if kswapd has been
>> > running a long time. Check if kswapd needs to be scheduled.
>> >
>> > Signed-off-by: Mel Gorman<mgorman@suse.de>
>> > ---
>> >   mm/vmscan.c |    4 ++++
>> >   1 files changed, 4 insertions(+), 0 deletions(-)
>> >
>> > diff --git a/mm/vmscan.c b/mm/vmscan.c
>> > index af24d1e..4d24828 100644
>> > --- a/mm/vmscan.c
>> > +++ b/mm/vmscan.c
>> > @@ -2251,6 +2251,10 @@ static bool sleeping_prematurely(pg_data_t *pgdat, int order, long remaining,
>> >     unsigned long balanced = 0;
>> >     bool all_zones_ok = true;
>> >
>> > +   /* If kswapd has been running too long, just sleep */
>> > +   if (need_resched())
>> > +           return false;
>> > +
>>
>> Hmm... I don't like this patch so much. because this code does
>>
>> - don't sleep if kswapd got context switch at shrink_inactive_list
>
> This isn't entirely true:  need_resched() will be false, so we'll follow
> the normal path for determining whether to sleep or not, in effect
> leaving the current behaviour unchanged.
>
>> - sleep if kswapd didn't
>
> This also isn't entirely true: whether need_resched() is true at this
> point depends on a whole lot more that whether we did a context switch
> in shrink_inactive. It mostly depends on how long we've been running
> without giving up the CPU.  Generally that will mean we've been round
> the shrinker loop hundreds to thousands of times without sleeping.
>
>> It seems to be semi random behavior.
>
> Well, we have to do something.  Chris Mason first suspected the hang was
> a kswapd rescheduling problem a while ago.  We tried putting
> cond_rescheds() in several places in the vmscan code, but to no avail.

Is it a result of  test with patch of Hannes(ie, !pgdat_balanced)?

If it isn't, it would be nop regardless of putting cond_reshed at vmscan.c.
Because, although we complete zone balancing, kswapd doesn't sleep as
pgdat_balance returns wrong result. And at last VM calls
balance_pgdat. In this case, balance_pgdat returns without any work as
kswap couldn't find zones which have not enough free pages and goto
out. kswapd could repeat this work infinitely. So you don't have a
chance to call cond_resched.

But if your test was with Hanne's patch, I am very curious how come
kswapd consumes CPU a lot.

> The need_resched() in sleeping_prematurely() seems to be about the best
> option.  The other option might be just to put a cond_resched() in
> kswapd_try_to_sleep(), but that will really have about the same effect.

I don't oppose it but before that, I think we have to know why kswapd
consumes CPU a lot although we applied Hannes' patch.

>
> James
>
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>



-- 
Kind regards,
Minchan Kim
