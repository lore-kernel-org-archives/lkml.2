Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452Ab0HYFD6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 01:03:58 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:33236 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755202Ab0HYFD4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 01:03:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=WPy11+GtbCmMqlRpY464uFQvpU3pv1ds9eQtrthAWk5n+a3FctJp8+4Z4KE1auZOdT
         4IMU6vfs9uHy4JXL3FOyjgom0G0Go/0indNB20Iu/Lb9qbImBU4lNk3pW0v+XBDgUH59
         nl57CaALT25hBqji/BnrNRFX39RtpBy6008uo=
MIME-Version: 1.0
In-Reply-To: <20100824164622.a3b2c1ed.akpm@linux-foundation.org>
References: <1281974138-5553-1-git-send-email-shijie8@gmail.com>
	<20100824164622.a3b2c1ed.akpm@linux-foundation.org>
Date: Wed, 25 Aug 2010 13:03:55 +0800
Message-ID: <AANLkTikSPB+8R4E7rsoVS2GN9ysROAPzKsLHqgMyP_yM@mail.gmail.com>
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

I think WARN_ON() is not power enough. If the CONFIG_BUG is not
defined, the warning message may not be printed. So I think using a
directly printk() here is better.

What about this ?

--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -453,6 +453,11 @@ static struct resource * __insert_resource(struct
resource *parent, struct resou

 		if (first == parent)
 			return first;
+		if (first == new) {
+			printk(KERN_ERR "You should not insert the"
+					"same resource twice!\n");
+			return first;
+		}

 		if ((first->start > new->start) || (first->end < new->end))
 			break;





>                if ((first->start > new->start) || (first->end < new->end))
>                        break;
> _
>
>
