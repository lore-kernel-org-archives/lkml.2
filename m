Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096Ab0DNPOE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 11:14:04 -0400
Received: from mail-iw0-f197.google.com ([209.85.223.197]:55866 "EHLO
	mail-iw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939Ab0DNPN6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 11:13:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=jU2nXRoP2aRTIUkDe0OdSvWfuNHhH91uDfX8qYfMoYMj4NMA8xq6xlrMgEg+8d+Bwl
         7Gkg3bvIC9RKkYRw3vXILnJyAbRu7yJu3wPxSsv8m7j7bKYnOUuIhBA9DDJ2ncIWGap/
         KIX0qSZS/xDaonHRi911S3w8wIgTUREXKW1Q0=
MIME-Version: 1.0
In-Reply-To: <1271249354.7196.66.camel@localhost.localdomain>
References: <1271089672.7196.63.camel@localhost.localdomain>
	 <1271249354.7196.66.camel@localhost.localdomain>
Date: Thu, 15 Apr 2010 00:13:57 +0900
Message-ID: <m2g28c262361004140813j5d70a80fy1882d01436d136a6@mail.gmail.com>
Subject: Re: vmalloc performance
From: Minchan Kim <minchan.kim@gmail.com>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Nick Piggin <npiggin@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cced Nick.
He's Mr. Vmalloc.

On Wed, Apr 14, 2010 at 9:49 PM, Steven Whitehouse <swhiteho@redhat.com> wrote:
>
> Since this didn't attract much interest the first time around, and at
> the risk of appearing to be talking to myself, here is the patch from
> the bugzilla to better illustrate the issue:
>
>
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index ae00746..63c8178 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -605,8 +605,7 @@ static void free_unmap_vmap_area_noflush(struct
> vmap_area *va)
>  {
>        va->flags |= VM_LAZY_FREE;
>        atomic_add((va->va_end - va->va_start) >> PAGE_SHIFT, &vmap_lazy_nr);
> -       if (unlikely(atomic_read(&vmap_lazy_nr) > lazy_max_pages()))
> -               try_purge_vmap_area_lazy();
> +       try_purge_vmap_area_lazy();
>  }
>
>  /*
>
>
> Steve.
>
> On Mon, 2010-04-12 at 17:27 +0100, Steven Whitehouse wrote:
>> Hi,
>>
>> I've noticed that vmalloc seems to be rather slow. I wrote a test kernel
>> module to track down what was going wrong. The kernel module does one
>> million vmalloc/touch mem/vfree in a loop and prints out how long it
>> takes.
>>
>> The source of the test kernel module can be found as an attachment to
>> this bz: https://bugzilla.redhat.com/show_bug.cgi?id=581459
>>
>> When this module is run on my x86_64, 8 core, 12 Gb machine, then on an
>> otherwise idle system I get the following results:
>>
>> vmalloc took 148798983 us
>> vmalloc took 151664529 us
>> vmalloc took 152416398 us
>> vmalloc took 151837733 us
>>
>> After applying the two line patch (see the same bz) which disabled the
>> delayed removal of the structures, which appears to be intended to
>> improve performance in the smp case by reducing TLB flushes across cpus,
>> I get the following results:
>>
>> vmalloc took 15363634 us
>> vmalloc took 15358026 us
>> vmalloc took 15240955 us
>> vmalloc took 15402302 us
>>
>> So thats a speed up of around 10x, which isn't too bad. The question is
>> whether it is possible to come to a compromise where it is possible to
>> retain the benefits of the delayed TLB flushing code, but reduce the
>> overhead for other users. My two line patch basically disables the delay
>> by forcing a removal on each and every vfree.
>>
>> What is the correct way to fix this I wonder?
>>
>> Steve.
>>
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>



-- 
Kind regards,
Minchan Kim
