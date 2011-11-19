Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755928Ab1KSDcz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 22:32:55 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41480 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754132Ab1KSDcx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 22:32:53 -0500
MIME-Version: 1.0
In-Reply-To: <20111118115955.410af035.akpm@linux-foundation.org>
References: <1321616630-28281-1-git-send-email-consul.kautuk@gmail.com>
	<20111118115955.410af035.akpm@linux-foundation.org>
Date: Fri, 18 Nov 2011 22:32:52 -0500
Message-ID: <CAFPAmTRU7=LyoEMWnAkm4ZDz9G6wwUsPr=iHP7rEkU1zJ_JDEQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] mm/vmalloc.c: eliminate extra loop in
 pcpu_get_vm_areas error path
From: "kautuk.c @samsung.com" <consul.kautuk@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>, David Rientjes <rientjes@google.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oh yes, I missed that out. :)

We should also do that.

Do you need me to redo this patch with this change ?
Although, I do notice that you seem to have already accepted this patch.


On Fri, Nov 18, 2011 at 2:59 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Fri, 18 Nov 2011 17:13:50 +0530
> Kautuk Consul <consul.kautuk@gmail.com> wrote:
>
>> If either of the vas or vms arrays are not properly kzalloced,
>> then the code jumps to the err_free label.
>>
>> The err_free label runs a loop to check and free each of the array
>> members of the vas and vms arrays which is not required for this
>> situation as none of the array members have been allocated till this
>> point.
>>
>> Eliminate the extra loop we have to go through by introducing a new
>> label err_free2 and then jumping to it.
>>
>> Signed-off-by: Kautuk Consul <consul.kautuk@gmail.com>
>> ---
>>  mm/vmalloc.c |    3 ++-
>>  1 files changed, 2 insertions(+), 1 deletions(-)
>>
>> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
>> index b669aa6..1a0d4e2 100644
>> --- a/mm/vmalloc.c
>> +++ b/mm/vmalloc.c
>> @@ -2352,7 +2352,7 @@ struct vm_struct **pcpu_get_vm_areas(const unsigned long *offsets,
>>       vms = kzalloc(sizeof(vms[0]) * nr_vms, GFP_KERNEL);
>>       vas = kzalloc(sizeof(vas[0]) * nr_vms, GFP_KERNEL);
>>       if (!vas || !vms)
>> -             goto err_free;
>> +             goto err_free2;
>>
>>       for (area = 0; area < nr_vms; area++) {
>>               vas[area] = kzalloc(sizeof(struct vmap_area), GFP_KERNEL);
>> @@ -2455,6 +2455,7 @@ err_free:
>>               if (vms)
>>                       kfree(vms[area]);
>>       }
>> +err_free2:
>>       kfree(vas);
>>       kfree(vms);
>>       return NULL;
>
> Which means we can also do the below, yes?  (please check my homework!)
>
> --- a/mm/vmalloc.c~mm-vmallocc-eliminate-extra-loop-in-pcpu_get_vm_areas-error-path-fix
> +++ a/mm/vmalloc.c
> @@ -2449,10 +2449,8 @@ found:
>
>  err_free:
>        for (area = 0; area < nr_vms; area++) {
> -               if (vas)
> -                       kfree(vas[area]);
> -               if (vms)
> -                       kfree(vms[area]);
> +               kfree(vas[area]);
> +               kfree(vms[area]);
>        }
>  err_free2:
>        kfree(vas);
> _
>
>
>
