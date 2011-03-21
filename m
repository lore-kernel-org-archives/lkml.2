Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500Ab1CUUP7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 16:15:59 -0400
Received: from smtp-out.google.com ([216.239.44.51]:39452 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753775Ab1CUUPz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 16:15:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=fd544ZChuC5+EUaCkjCRJsxAsCmxwl8JdfsMMw8JFgxdUJ9xCfRSifdwsF7zVIppIN
         e95W0syweVRulKJWSB9A==
MIME-Version: 1.0
In-Reply-To: <20110321192757.GK2694@redhat.com>
References: <1300374357-30686-1-git-send-email-teravest@google.com> <20110321192757.GK2694@redhat.com>
From: Justin TerAvest <teravest@google.com>
Date: Mon, 21 Mar 2011 13:15:33 -0700
Message-ID: <AANLkTik9r-5zXQKCHf9+8U9M1-3Y84mv9Aid7GsTaj2R@mail.gmail.com>
Subject: Re: [PATCH v3] Don't update group weights when on service tree.
To: Vivek Goyal <vgoyal@redhat.com>
Cc: jaxboe@fusionio.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 21, 2011 at 12:27 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Thu, Mar 17, 2011 at 08:05:57AM -0700, Justin TerAvest wrote:
>> Version 3 is updated to apply to for-2.6.39/core.
>>
>> For version 2, I took Vivek's advice and made sure we update the group
>> weight from cfq_group_service_tree_add().
>>
>> If a weight was updated while a group is on the service tree, the
>> calculation for the total weight of the service tree can be adjusted
>> improperly, which either leads to bad service tree weights, or
>> potentially crashes (if total_weight becomes 0).
>>
>> This patch defers updates to the weight until a group is off the service
>> tree.
>>
>> Signed-off-by: Justin TerAvest <teravest@google.com>
>> Acked-by: Vivek Goyal <vgoyal@redhat.com>
>> ---
>>  block/cfq-iosched.c |   53 +++++++++++++++++++++++++++++++++++++++-----------
>>  1 files changed, 41 insertions(+), 12 deletions(-)
>>
>> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
>> index 89e0d1c..12e380b 100644
>> --- a/block/cfq-iosched.c
>> +++ b/block/cfq-iosched.c
>> @@ -178,6 +178,8 @@ struct cfq_group {
>>       /* group service_tree key */
>>       u64 vdisktime;
>>       unsigned int weight;
>> +     unsigned int new_weight;
>> +     bool needs_update;
>>
>>       /* number of cfqq currently on this group */
>>       int nr_cfqq;
>> @@ -853,7 +855,27 @@ __cfq_group_service_tree_add(struct cfq_rb_root *st, struct cfq_group *cfqg)
>>  }
>>
>>  static void
>> -cfq_group_service_tree_add(struct cfq_data *cfqd, struct cfq_group *cfqg)
>> +cfq_update_group_weight(struct cfq_group *cfqg)
>> +{
>> +     BUG_ON(!RB_EMPTY_NODE(&cfqg->rb_node));
>> +     if (cfqg->needs_update) {
>> +             cfqg->weight = cfqg->new_weight;
>> +             cfqg->needs_update = false;
>> +     }
>> +}
>
> thinking more about it, looks like this code is still racy. If somebody
> updates the weights again while we are about to process previous weight
> change, we might lose the new weight and set needs_update=false. We might
> have to use xchg() to update cfqg->needs_update.

I think you're right, Vivek.

I wish we could just take a lock on blkcg->lock when updating, we
should expect the weights to be updated that often, right? I'm not
sure if there's a feasible way to do that, though.

I'll explore both options, I'd just prefer to not add xchg() code if I
don't have to, as it requires a bit more thinking.

Thanks,
Justin


>
> Thanks
> Vivek
>
