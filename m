Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902Ab0DEOUu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 10:20:50 -0400
Received: from smtp-out.google.com ([74.125.121.35]:13936 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753619Ab0DEOUo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 10:20:44 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=jxRiuffNq1r1VQfjmVTI/6+EoBvDzBoRK6V3c4l/ZrH68AHEsatY5ww9NQ71CjRye
	GdEPZvBrgOTzdhx8p0BMw==
MIME-Version: 1.0
In-Reply-To: <20100325005228.GA13225@redhat.com>
References: <1269473756-30327-1-git-send-email-rickyb@google.com>
	 <20100325005228.GA13225@redhat.com>
Date: Mon, 5 Apr 2010 07:20:41 -0700
Message-ID: <v2g23904f641004050720pc0d7aa04n294381af44047dd3@mail.gmail.com>
Subject: Re: [PATCH] Expose the statistics in blkio.time and blkio.sectors for 
	the root cgroup
From: Manuel Benitez <rickyb@google.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Vivek Goyal <vgoyal@redhat.com>, Corrado Zoccolo <czoccolo@gmail.com>,
       Jeff Moyer <jmoyer@redhat.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens,

Please let me know if this patch is/isn't acceptable. Not having the
statistics exposed at the root is a little bit problematic for our
user-level control programs.

-Ricky

On Wed, Mar 24, 2010 at 5:52 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Wed, Mar 24, 2010 at 04:35:56PM -0700, Ricky Benitez wrote:
>> Currently, the io statistics for the root cgroup are maintained, but
>> they are not shown because the device information is not available at
>> the point that the root blkio cgroup is created. This patch updates
>> the device information when the statistics are updated so that the
>> statistics become visible.
>>
>
> Ok, root group is created when request queue is being initialized and
> device information like major/minor number is not available. This is
> not the cleanest solution but can't think of something better right now.
>
> Acked-by: Vivek Goyal <vgoyal@redhat.com>
>
> Thanks
> Vivek
>
>> Signed-off-by: Ricky Benitez <rickyb@google.com>
>> ---
>>  block/cfq-iosched.c |    5 +++++
>>  1 files changed, 5 insertions(+), 0 deletions(-)
>>
>> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
>> index dee9d93..4a3579a 100644
>> --- a/block/cfq-iosched.c
>> +++ b/block/cfq-iosched.c
>> @@ -947,6 +947,11 @@ cfq_find_alloc_cfqg(struct cfq_data *cfqd, struct cgroup *cgroup, int create)
>>       unsigned int major, minor;
>>
>>       cfqg = cfqg_of_blkg(blkiocg_lookup_group(blkcg, key));
>> +     if (cfqg && !cfqg->blkg.dev && bdi->dev && dev_name(bdi->dev)) {
>> +             sscanf(dev_name(bdi->dev), "%u:%u", &major, &minor);
>> +             cfqg->blkg.dev = MKDEV(major, minor);
>> +             goto done;
>> +     }
>>       if (cfqg || !create)
>>               goto done;
>>
>> --
>> 1.7.0.1
>
