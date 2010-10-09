Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932445Ab0JIDTP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 23:19:15 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:59982 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650Ab0JIDTN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 23:19:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=EgOA8I9GRux9KWVVZHkbyO+2qVZ/oq6nNoyEJ5rSLpQ+PtqTtru5uHxE8IHE4fvnn9
         BZBhH3jGGk0967Exf3NOL4WJJeRnlm+uigb+WFfwXzdCGE6qX01JYF/xe0WGMzz4ZWUj
         8Dg1v2HqyKGifzl+PBOrGTr1vcXDsIhd5nnEM=
MIME-Version: 1.0
In-Reply-To: <20101008155343.GD5327@balbir.in.ibm.com>
References: <20101005124521.GA2602@darkstar>
	<20101008130916.GC5327@balbir.in.ibm.com>
	<AANLkTimd2Z3Yy9yxHZA6raeFxp6L7Wtvy5rLSrMyjEU1@mail.gmail.com>
	<20101008155343.GD5327@balbir.in.ibm.com>
Date: Sat, 9 Oct 2010 11:19:12 +0800
Message-ID: <AANLkTinoOkZ50B8SUvU=bZLiopSFpamGm+abHaC9CWLX@mail.gmail.com>
Subject: Re: [PATCH] kvm: add oom notifier for virtio balloon
From: Dave Young <hidave.darkstar@gmail.com>
To: balbir@linux.vnet.ibm.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
        Rusty Russell <rusty@rustcorp.com.au>,
        Anthony Liguori <anthony@codemonkey.ws>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 8, 2010 at 11:53 PM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> * Dave Young <hidave.darkstar@gmail.com> [2010-10-08 21:33:02]:
>
>> On Fri, Oct 8, 2010 at 9:09 PM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>> > * Dave Young <hidave.darkstar@gmail.com> [2010-10-05 20:45:21]:
>> >
>> >> Balloon could cause guest memory oom killing and panic.
>> >>
>> >> Add oom notify to leak some memory and retry fill balloon after 5 minutes.
>> >>
>> >> At the same time add a mutex to protect balloon operations
>> >> because we need leak balloon in oom notifier and give back freed value.
>> >>
>> >> Thanks Anthony Liguori for his sugestion about inflate retrying.
>> >> Sometimes it will cause endless inflate/oom/delay loop,
>> >> so I think next step is to add an option to do noretry-when-oom balloon.
>> >>
>> >> Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
>> >
>> > Won't __GFP_NORETRY prevent OOM? Could you please describe how you
>> > tested the patch?
>>
>> I have not tried __GFP_NORETRY, it should work, but balloon thread
>> will keep wasting cpu resource to allocating.
>>
>>
>> To test the patch, just balloon to small than minimal memory.
>>
>> I use "balloon 30" in qemu monitor to limit slackware guest memory
>> usage. The normal memory used is ~40M.
>>
>> Actually we need to differentiate the process which caused oom. If it
>> is balloon thread we should just stop ballooning, if it is others we
>> can do something like this patch, e.g. retry ballooning after 5
>> minutes.
>
> Ideally the balloon thread should never OOM with __GFP_NORETRY (IIRC).
> The other situation should be dealt with, we should free up any pages
> we have. I wonder if the timeout should be a sysctl tunable.

balbir, you are right,  the oom is not from balloon alloc_page.
balloon thread cause memory low, then afterwards vm readahead code
cause oom. With oom notifier patch oom killing does not happen in my
test

>
> --
>        Three Cheers,
>        Balbir
>



-- 
Regards
dave
