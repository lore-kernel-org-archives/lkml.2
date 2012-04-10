Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759358Ab2DJPQf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 11:16:35 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:45525 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759291Ab2DJPQW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 11:16:22 -0400
MIME-Version: 1.0
In-Reply-To: <CAJd=RBD6Sb4zmUkMTaT12cgwFLAQYmh6HuK1hLMa_Dda6FHBLQ@mail.gmail.com>
References: <1334000524-23972-1-git-send-email-yinghan@google.com>
	<CAJd=RBD6Sb4zmUkMTaT12cgwFLAQYmh6HuK1hLMa_Dda6FHBLQ@mail.gmail.com>
Date: Tue, 10 Apr 2012 23:16:19 +0800
Message-ID: <CAJd=RBAdRKaY1t_=ZxwW+u+1RmSJm7V=h8ywcxz5VJVe75O-PA@mail.gmail.com>
Subject: Re: [PATCH] Revert "mm: vmscan: fix misused nr_reclaimed in shrink_mem_cgroup_zone()"
From: Hillf Danton <dhillf@gmail.com>
To: Ying Han <yinghan@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        Hugh Dickins <hughd@google.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add lkml
On Tue, Apr 10, 2012 at 11:00 PM, Hillf Danton <dhillf@gmail.com> wrote:
> On Tue, Apr 10, 2012 at 3:42 AM, Ying Han <yinghan@google.com> wrote:
>> This reverts commit c38446cc65e1f2b3eb8630c53943b94c4f65f670.
>>
>> Before the commit, the code makes senses to me but not after the commit. The
>> "nr_reclaimed" is the number of pages reclaimed by scanning through the memcg's
>> lru lists. The "nr_to_reclaim" is the target value for the whole function. For
>> example, we like to early break the reclaim if reclaimed 32 pages under direct
>> reclaim (not DEF_PRIORITY).
>>
>> After the reverted commit, the target "nr_to_reclaim" is decremented each time
>> by "nr_reclaimed" but we still use it to compare the "nr_reclaimed". It just
>> doesn't make sense to me...
>>
> I downloaded mm/vmscan.c from the next tree a couple minutes ago, and
> see
>                .nr_to_reclaim = SWAP_CLUSTER_MAX,
> and
>        nr_reclaimed = do_try_to_free_pages(zonelist, &sc, &shrink);
>
> in try_to_free_pages().
>
> I also see
>                total_scanned += sc->nr_scanned;
>                if (sc->nr_reclaimed >= sc->nr_to_reclaim)
>                        goto out;
>
> in do_try_to_free_pages(),
>
> then would you please say a few words about the sense
> of the check of nr_to_reclaim?
>
>
>> Signed-off-by: Ying Han <yinghan@google.com>
>> ---
>>  mm/vmscan.c |    7 +------
>>  1 files changed, 1 insertions(+), 6 deletions(-)
>>
>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>> index 33c332b..1a51868 100644
>> --- a/mm/vmscan.c
>> +++ b/mm/vmscan.c
>> @@ -2107,12 +2107,7 @@ restart:
>>                 * with multiple processes reclaiming pages, the total
>>                 * freeing target can get unreasonably large.
>>                 */
>> -               if (nr_reclaimed >= nr_to_reclaim)
>> -                       nr_to_reclaim = 0;
>> -               else
>> -                       nr_to_reclaim -= nr_reclaimed;
>> -
>> -               if (!nr_to_reclaim && priority < DEF_PRIORITY)
>> +               if (nr_reclaimed >= nr_to_reclaim && priority < DEF_PRIORITY)
>>                        break;
>>        }
>>        blk_finish_plug(&plug);
>> --
>> 1.7.7.3
>>
