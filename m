Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751529Ab1LHHNj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 02:13:39 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:57529 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166Ab1LHHNe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 02:13:34 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1112072304010.28419@chino.kir.corp.google.com>
References: <1323327732-30817-1-git-send-email-consul.kautuk@gmail.com>
	<alpine.DEB.2.00.1112072304010.28419@chino.kir.corp.google.com>
Date: Thu, 8 Dec 2011 12:43:32 +0530
Message-ID: <CAFPAmTSJDXD1KNVBUz75yN_CeCT9f_+W9CaRNN467LSyCD+WXg@mail.gmail.com>
Subject: Re: [PATCH 1/1] vmalloc: purge_fragmented_blocks: Acquire spinlock
 before reading vmap_block
From: Kautuk Consul <consul.kautuk@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Joe Perches <joe@perches.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        David Vrabel <david.vrabel@citrix.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 8, 2011 at 12:37 PM, David Rientjes <rientjes@google.com> wrote:
> On Thu, 8 Dec 2011, Kautuk Consul wrote:
>
>> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
>> index 3231bf3..2228971 100644
>> --- a/mm/vmalloc.c
>> +++ b/mm/vmalloc.c
>> @@ -855,11 +855,14 @@ static void purge_fragmented_blocks(int cpu)
>>
>>       rcu_read_lock();
>>       list_for_each_entry_rcu(vb, &vbq->free, free_list) {
>> +             spin_lock(&vb->lock);
>>
>> -             if (!(vb->free + vb->dirty == VMAP_BBMAP_BITS && vb->dirty != VMAP_BBMAP_BITS))
>> +             if (!(vb->free + vb->dirty == VMAP_BBMAP_BITS &&
>> +                       vb->dirty != VMAP_BBMAP_BITS)) {
>> +                     spin_unlock(&vb->lock);
>>                       continue;
>> +             }
>>
>> -             spin_lock(&vb->lock);
>>               if (vb->free + vb->dirty == VMAP_BBMAP_BITS && vb->dirty != VMAP_BBMAP_BITS) {
>>                       vb->free = 0; /* prevent further allocs after releasing lock */
>>                       vb->dirty = VMAP_BBMAP_BITS; /* prevent purging it again */
>
> Nack, this is wrong because the if-clause you're modifying isn't the
> criteria that is used to determine whether the purge occurs or not.  It's
> merely an optimization to prevent doing exactly what your patch is doing:
> taking vb->lock unnecessarily.

I agree.

>
> In the original code, if the if-clause fails, the lock is only then taken
> and the exact same test occurs again while protected.  If the test now
> fails, the lock is immediately dropped.  A branch here is faster than a
> contented spinlock.

But, if there is some concurrent change happening to vb->free and
vb->dirty, dont you think
that it will continue and then go to the next vmap_block ?

If yes, then it will not be put into the purge list.


So, can we make a change where we simply remove the first check ?
