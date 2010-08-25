Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751812Ab0HYEbz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 00:31:55 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:45269 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330Ab0HYEbx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 00:31:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=tVZyrsdSGJuCUaGSDheFKU/2VXYeHv16vqPiyetxfqUHjHQt2K3fiWVjTcaaq/E0pR
         S1Xceyoq5i9oqmyDInK+sQWf6GO0tzcb2LjUSPNLrpJHmWemEyzvP2KrhowiRdSbsNsg
         z8zGNR8TXqrL6m4CFYsGjJK/yYkiYQmiYtwfI=
MIME-Version: 1.0
In-Reply-To: <20100824164622.a3b2c1ed.akpm@linux-foundation.org>
References: <1281974138-5553-1-git-send-email-shijie8@gmail.com>
	<20100824164622.a3b2c1ed.akpm@linux-foundation.org>
Date: Wed, 25 Aug 2010 12:31:52 +0800
Message-ID: <AANLkTin+0xZBFJSc48yqzrxQQL0ukA8Q0fksy1bM4mUj@mail.gmail.com>
Subject: Re: [PATCH] avoiding the same resource to be inserted
From: Huang Shijie <shijie8@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 25, 2010 at 7:46 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Mon, 16 Aug 2010 23:55:38 +0800
> Huang Shijie <shijie8@gmail.com> wrote:
>
>>   If the same resource is inserted to the resource tree
>> (maybe not on purpose), a dead loop will be created. In this situation,
>> The kernel does not report any warning or error       :(
>>
>>   The command below will show a endless print.
>>   #cat /proc/iomem
>
> OK, we shouldn't do that.
>
>>   So, adding the check for the same resource is needed for the stability
>> and reliability of the kernel.
>>
>> Signed-off-by: Huang Shijie <shijie8@gmail.com>
>> ---
>>  kernel/resource.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/kernel/resource.c b/kernel/resource.c
>> index 7b36976..60daab4 100644
>> --- a/kernel/resource.c
>> +++ b/kernel/resource.c
>> @@ -451,7 +451,7 @@ static struct resource * __insert_resource(struct resource *parent, struct resou
>>               if (!first)
>>                       return first;
>>
>> -             if (first == parent)
>> +             if (first == parent || first == new)
>>                       return first;
>
> However, inserting the same thing twice _is_ a bug, and we shouldn't
> silently accept it like this.  We should tell the programmer!

Indeed, this is a bug caused by the driver programmer.I had spent
nearly two day to find it in my colleague's code.


>
> But we can recover from the situation so let's not kill the box.  How
> does this look?
>
> --- a/kernel/resource.c~kernel-resourcec-handle-reinsertion-of-an-already-inserted-resource
> +++ a/kernel/resource.c
> @@ -453,6 +453,8 @@ static struct resource * __insert_resour
>
>                if (first == parent)
>                        return first;
> +               if (WARN_ON(first == new))      /* duplicated insertion */
> +                       return first;
>

Yes. This one is better.
Many drivers do not check the returned value of insert_resouce().


>                if ((first->start > new->start) || (first->end < new->end))
>                        break;
> _
>
>
