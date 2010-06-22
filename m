Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758878Ab0FVCpr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 22:45:47 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:63450 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753323Ab0FVCpq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 22:45:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=NLEX05mz0RelB0ABkRKwmJNMVYSbMpYLZQ63JP2iWOOtcVUUKh5vvbOrfMbZl2Qd2S
         Be5JmXM7IWTCtu9bAQYbUS0zrfrJ3FK/x5j3R+R2rVcS00hTkhwQsDgD4arJEZwWtr3B
         Jm6P4HULA3tbWM6MThy7Uu7kDR2uZEfVwJbW8=
MIME-Version: 1.0
In-Reply-To: <20100622112416.B554.A69D9226@jp.fujitsu.com>
References: <20100618093954.FBE7.A69D9226@jp.fujitsu.com>
	<20100621141315.GB2456@barrios-desktop>
	<20100622112416.B554.A69D9226@jp.fujitsu.com>
Date: Tue, 22 Jun 2010 11:45:45 +0900
Message-ID: <AANLkTilN3EcYq400ajA2-rf3Xs4MhD-sKCg44fjzKlX1@mail.gmail.com>
Subject: Re: [Patch] Call cond_resched() at bottom of main look in 
	balance_pgdat()
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Larry Woodman <lwoodman@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 22, 2010 at 11:24 AM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
>> > =============================================================
>> > Subject: [PATCH] Call cond_resched() at bottom of main look in balance_pgdat()
>> > From: Larry Woodman <lwoodman@redhat.com>
>> >
>> > We are seeing a problem where kswapd gets stuck and hogs the CPU on a
>> > small single CPU system when an OOM kill should occur.  When this
>> > happens swap space has been exhausted and the pagecache has been shrunk
>> > to zero.  Once kswapd gets the CPU it never gives it up because at least
>> > one zone is below high.  Adding a single cond_resched() at the end of
>> > the main loop in balance_pgdat() fixes the problem by allowing the
>> > watchdog and tasks to run and eventually do an OOM kill which frees up
>> > the resources.
>> >
>> > kosaki note: This seems regression caused by commit bb3ab59683
>> > (vmscan: stop kswapd waiting on congestion when the min watermark is
>> >  not being met)
>> >
>> > Signed-off-by: Larry Woodman <lwoodman@redhat.com>
>> > Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>> > ---
>> >  mm/vmscan.c |    1 +
>> >  1 files changed, 1 insertions(+), 0 deletions(-)
>> >
>> > diff --git a/mm/vmscan.c b/mm/vmscan.c
>> > index 9c7e57c..c5c46b7 100644
>> > --- a/mm/vmscan.c
>> > +++ b/mm/vmscan.c
>> > @@ -2182,6 +2182,7 @@ loop_again:
>> >              */
>> >             if (sc.nr_reclaimed >= SWAP_CLUSTER_MAX)
>> >                     break;
>> > +           cond_resched();
>> >     }
>> >  out:
>> >     /*
>> > --
>> > 1.6.5.2
>>
>> Kosaki's patch's goal is that kswap doesn't yield cpu if the zone doesn't meet its
>> min watermark to avoid failing atomic allocation.
>> But this patch could yield kswapd's time slice at any time.
>> Doesn't the patch break your goal in bb3ab59683?
>
> No. it don't break.
>
> Typically, kswapd periodically call shrink_page_list() and it call
> cond_resched() even if bb3ab59683 case.

Hmm. If it is, bb3ab59683 is effective really?

The bb3ab59683's goal is prevent CPU yield in case of free < min_watermark.
But shrink_page_list can yield cpu from kswapd at any time.
So I am not sure what is bb3ab59683's benefit.
Did you have any number about bb3ab59683's effectiveness?
(Of course, I know it's very hard. Just out of curiosity)

As a matter of fact, when I saw this Larry's patch, I thought it would
be better to revert bb3ab59683. Then congestion_wait could yield CPU
to other process.

What do you think about?

-- 
Kind regards,
Minchan Kim
