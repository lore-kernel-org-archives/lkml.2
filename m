Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755328Ab0GKW2M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 18:28:12 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:43075 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754753Ab0GKW2L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 18:28:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=SFNW1nI9QvOL4S458wwhQ2WVSV7A9CDuvTtaQ4GKlGQATRKp+98/NMTr9TS/hpPyaF
         rEjyIvSjhcp+VUUnuyRKFFOec8CnBw4QPxV66v6zE7QR0/8ZZtlOe9OWYm/PS/E7FmcK
         vHjUf4ftq5JTffrXElEab19Fnoq68PGXCS6x0=
MIME-Version: 1.0
In-Reply-To: <20100709195625.FA28.A69D9226@jp.fujitsu.com>
References: <20100709191308.FA25.A69D9226@jp.fujitsu.com>
	<AANLkTins0OMGnj3JmUjIctO0dSnXPsQV1AUsbMEVt2D1@mail.gmail.com>
	<20100709195625.FA28.A69D9226@jp.fujitsu.com>
Date: Mon, 12 Jul 2010 07:28:09 +0900
Message-ID: <AANLkTilA2rzWVVLqDQjhivHmnt0ZfaQBGEDh2TU6OfcJ@mail.gmail.com>
Subject: Re: [PATCH] vmscan: stop meaningless loop iteration when no 
	reclaimable slab
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Mel Gorman <mel@csn.ul.ie>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 9, 2010 at 8:04 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
>> On Fri, Jul 9, 2010 at 7:13 PM, KOSAKI Motohiro
>> <kosaki.motohiro@jp.fujitsu.com> wrote:
>> > If number of reclaimable slabs are zero, shrink_icache_memory() and
>> > shrink_dcache_memory() return 0. but strangely shrink_slab() ignore
>> > it and continue meaningless loop iteration.
>> >
>> > This patch fixes it.
>> >
>> > Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>> > ---
>> >  mm/vmscan.c |    5 +++++
>> >  1 files changed, 5 insertions(+), 0 deletions(-)
>> >
>> > diff --git a/mm/vmscan.c b/mm/vmscan.c
>> > index 0f9f624..8f61adb 100644
>> > --- a/mm/vmscan.c
>> > +++ b/mm/vmscan.c
>> > @@ -243,6 +243,11 @@ unsigned long shrink_slab(unsigned long scanned, gfp_t gfp_mask,
>> >                        int nr_before;
>> >
>> >                        nr_before = (*shrinker->shrink)(0, gfp_mask);
>> > +                       /* no slab objects, no more reclaim. */
>> > +                       if (nr_before == 0) {
>> > +                               total_scan = 0;
>>
>> Why do you reset totoal_scan to 0?
>
> If shab objects are zero, we don't need more reclaim.
>
>> I don't know exact meaning of shrinker->nr.
>
> similar meaning of reclaim_stat->nr_saved_scan.
> If total_scan can't divide SHRINK_BATCH(128), saving remainder and using at next shrink_slab().
>
>> AFAIU, it can affect next shrinker's total_scan.
>> Isn't it harmful?
>
> No.  This loop is
>
>                total_scan = shrinker->nr;              /* Reset and init total_scan */
>                shrinker->nr = 0;
>
>                while (total_scan >= SHRINK_BATCH) {
>                        nr_before = (*shrinker->shrink)(0, gfp_mask);
>                        /* no slab objects, no more reclaim. */
>                        if (nr_before == 0) {
>                                total_scan = 0;
>                                break;
>                        }
>                        shrink_ret = (*shrinker->shrink)(this_scan, gfp_mask);
>                        if (shrink_ret == -1)
>                                break;
>                        if (shrink_ret < nr_before)
>                                ret += nr_before - shrink_ret;
>                        total_scan -= this_scan;
>                }
>
>                shrinker->nr += total_scan;             /* save remainder #of-scan */
>
>
I can't understand your point.


old shrink_slab

shrinker->nr += delta; /* Add delta to previous shrinker's remained count */
total_scan = shrinker->nr;

while(total_scan >= SHRINK_BATCH) {
	nr_before = shrink(xxx);
	total_scan =- this_scan;
}

shrinker->nr += total_scan;

The total_scan can always be the number < SHRINK_BATCH.
So, when next shrinker calcuates loop count, the number can affect.

new shrink_slab

shrinker->nr += delta; /* nr is always zero by your patch */
total_scan = shrinker->nr;

while(total_scan >= SHRINK_BATCH) {
	nr_before = shrink(xxx);
	if (nr_before == 0) {
		total_scan = 0;
		break;
	}
}

shrinker->nr += 0;

But after your patch, total_scan is always zero. It never affect
next shrinker's loop count.

Am I missing something?
-- 
Kind regards,
Minchan Kim
