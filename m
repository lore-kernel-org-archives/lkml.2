Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146Ab0GMGd7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 02:33:59 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:32919 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104Ab0GMGd6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 02:33:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=uUJlASYTjg83f21hjSLAeAZo8sUKOl/W1TRoFpkycY7PTEjmR5xPl8qVRGs72Febt+
         eNqCNdgfkfLobSh/KBcE9prv44TsWW9xhGpLqRsq3vU82mIomo4V3tL8E3S5oKlEj0CQ
         Z7RXEJD/riRR+oLtlsLrn+Q3dwakbGhjtkPks=
MIME-Version: 1.0
In-Reply-To: <20100712101237.EA0E.A69D9226@jp.fujitsu.com>
References: <20100709195625.FA28.A69D9226@jp.fujitsu.com>
	<AANLkTilA2rzWVVLqDQjhivHmnt0ZfaQBGEDh2TU6OfcJ@mail.gmail.com>
	<20100712101237.EA0E.A69D9226@jp.fujitsu.com>
Date: Tue, 13 Jul 2010 15:33:57 +0900
Message-ID: <AANLkTil3zWyAh-gZHJXAiAfvy524ukf9P7l9JBLSOPs5@mail.gmail.com>
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

On Tue, Jul 13, 2010 at 1:48 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
> Hi
>
>>
>> old shrink_slab
>>
>> shrinker->nr += delta; /* Add delta to previous shrinker's remained count */
>> total_scan = shrinker->nr;
>>
>> while(total_scan >= SHRINK_BATCH) {
>>       nr_before = shrink(xxx);
>>       total_scan =- this_scan;
>> }
>>
>> shrinker->nr += total_scan;
>>
>> The total_scan can always be the number < SHRINK_BATCH.
>> So, when next shrinker calcuates loop count, the number can affect.
>
> Correct.
>
>
>>
>> new shrink_slab
>>
>> shrinker->nr += delta; /* nr is always zero by your patch */
>
> no.
> my patch don't change delta calculation at all.
>
>
>> total_scan = shrinker->nr;
>>
>> while(total_scan >= SHRINK_BATCH) {
>>       nr_before = shrink(xxx);
>>       if (nr_before == 0) {
>>               total_scan = 0;
>>               break;
>>       }
>> }
>>
>> shrinker->nr += 0;
>>
>> But after your patch, total_scan is always zero. It never affect
>> next shrinker's loop count.
>
> No. after my patch this loop has two exiting way
>  1) total_scan are less than SHRINK_BATCH.
>      -> no behavior change.  we still pass shrinker->nr += total_scan code.
>  2) (*shrinker->shrink)(0, gfp_mask) return 0
>      don't increase shrinker->nr.  because two reason,
>      a) if total_scan are 10000,  we shouldn't carry over such big number.
>      b) now, we have zero slab objects, then we have been freed form the guilty of keeping
>          balance page and slab reclaim. shrinker->nr += 0; have zero side effect.

Totally, I agree with you.
Thanks for good explanation, Kosaki.

Reviewed-by: Minchan kim <minchan.kim@gmail.com>


-- 
Kind regards,
Minchan Kim
