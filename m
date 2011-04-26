Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757674Ab1DZHJK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 03:09:10 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59487 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757264Ab1DZHJI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 03:09:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=se5Dc3MpbM0exQkZAlLRM7mPTa55O6B/n3bqPyQG0UZ1E2hbImuxddz+nVWt0za1P6
         HEnSIDFjyEFyyqDOE5yI06nZkpNcRr2kmLcuTNYX8BB4TG5+YhNQzExoHPKS6/f+a7pU
         yQ9K1Qn9kdmvkwD+yjThQEwKZtBO7n9pFXhnU=
MIME-Version: 1.0
In-Reply-To: <20110426154037.F38B.A69D9226@jp.fujitsu.com>
References: <20110426052916.GA11933@darkstar>
	<20110426154037.F38B.A69D9226@jp.fujitsu.com>
Date: Tue, 26 Apr 2011 15:09:06 +0800
Message-ID: <BANLkTikXR-A-za7dd6FDqc6B0fLhi4LbJg@mail.gmail.com>
Subject: Re: [PATCH 1/2] virtio_balloon: disable oom killer when fill balloon
From: Dave Young <hidave.darkstar@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 26, 2011 at 2:38 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
>> When memory pressure is high, virtio ballooning will probably cause oom killing.
>> Even if alloc_page with GFP_NORETRY itself does not directly trigger oom it
>> will make memory becoming low then memory alloc of other processes will trigger
>> oom killing. It is not desired behaviour.
>>
>> Here disable oom killer in fill_balloon to address this issue.
>>
>> Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
>> ---
>>  drivers/virtio/virtio_balloon.c |    3 +++
>>  1 file changed, 3 insertions(+)
>>
>> --- linux-2.6.orig/drivers/virtio/virtio_balloon.c    2010-10-13 10:14:38.000000000 +0800
>> +++ linux-2.6/drivers/virtio/virtio_balloon.c 2011-04-26 11:38:43.979785141 +0800
>> @@ -25,6 +25,7 @@
>>  #include <linux/freezer.h>
>>  #include <linux/delay.h>
>>  #include <linux/slab.h>
>> +#include <linux/oom.h>
>>
>>  struct virtio_balloon
>>  {
>> @@ -102,6 +103,7 @@ static void fill_balloon(struct virtio_b
>>       /* We can only do one array worth at a time. */
>>       num = min(num, ARRAY_SIZE(vb->pfns));
>>
>> +     oom_killer_disable();
>
> I think this patch need proper comment at least. My first impression
> is, "Hm, __GFP_NORETRY should prevent oom, why is this necessary?".
> So, this actually prevent _another_ thread call out_of_memory().

Thanks, will fix.

> Also, Here doesn't have any exclusion against hibernation (ie another
> oom_killer_disable() callsite). It should be described why lock is
> unnecessary.

Good catch, but lock should better be handled in oom_killer_disable
function itself,
What do you think?

For oom killer multi user there's more problem, if process A disable
oom killer then Process B enable oom killer, it is not A want to see,
Any thoughts?

>
> Thanks.
>
>
>>       for (vb->num_pfns = 0; vb->num_pfns < num; vb->num_pfns++) {
>>               struct page *page = alloc_page(GFP_HIGHUSER | __GFP_NORETRY |
>>                                       __GFP_NOMEMALLOC | __GFP_NOWARN);
>> @@ -119,6 +121,7 @@ static void fill_balloon(struct virtio_b
>>               vb->num_pages++;
>>               list_add(&page->lru, &vb->pages);
>>       }
>> +     oom_killer_enable();
>>
>>       /* Didn't get any?  Oh well. */
>>       if (vb->num_pfns == 0)
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>
>
>
>



-- 
Regards
dave
