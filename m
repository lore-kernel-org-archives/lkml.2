Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752626Ab2GZQvb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 12:51:31 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37390 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489Ab2GZQv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 12:51:29 -0400
MIME-Version: 1.0
In-Reply-To: <20120725162529.GN11152@aftab.osrc.amd.com>
References: <1343149213-10160-1-git-send-email-ming.lei@canonical.com>
	<1343149213-10160-11-git-send-email-ming.lei@canonical.com>
	<20120725162529.GN11152@aftab.osrc.amd.com>
Date: Fri, 27 Jul 2012 00:51:26 +0800
Message-ID: <CACVXFVNgMQGOULphipVi5L5wWFuEyuiZgzRCdh9pOSW=RA2dYA@mail.gmail.com>
Subject: Re: [RFC PATCH 10/13] driver core: devres: introduce devres_for_each_res
From: Ming Lei <ming.lei@canonical.com>
To: Borislav Petkov <bp@amd64.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 26, 2012 at 12:25 AM, Borislav Petkov <bp@amd64.org> wrote:
> On Wed, Jul 25, 2012 at 01:00:10AM +0800, Ming Lei wrote:
>> This patch introduces one devres API of devres_for_each_res
>> so that the device's driver can iterate each resource it has
>> interest in.
>>
>> The firmware loader will use the API to get each firmware name
>> from the device instance.
>>
>> Signed-off-by: Ming Lei <ming.lei@canonical.com>
>> ---
>>  drivers/base/devres.c  |   42 ++++++++++++++++++++++++++++++++++++++++++
>>  include/linux/device.h |    3 +++
>>  2 files changed, 45 insertions(+)
>>
>> diff --git a/drivers/base/devres.c b/drivers/base/devres.c
>> index 2360adb..8273ba5 100644
>> --- a/drivers/base/devres.c
>> +++ b/drivers/base/devres.c
>> @@ -144,6 +144,48 @@ EXPORT_SYMBOL_GPL(devres_alloc);
>>  #endif
>>
>>  /**
>> + * devres_for_each_res - Resource iterator
>> + * @dev: Device to iterate resource from
>> + * @release: Look for resources associated with this release function
>> + * @match: Match function (optional)
>> + * @match_data: Data for the match function
>> + * @fn: function to be called for each matched resource.
>> + *
>> + * Call @fn for each devres of @dev which is associated with @release
>> + * and for which @match returns 1.
>> + *
>> + * RETURNS:
>> + *   void
>> + */
>> +void devres_for_each_res(struct device *dev, dr_release_t release,
>> +                     dr_match_t match, void *match_data,
>> +                     void (*fn)(struct device *, void *))
>> +{
>> +     struct devres_node *node;
>> +     struct devres_node *tmp;
>> +     unsigned long flags;
>> +
>> +     if (!fn)
>> +             return;
>> +
>> +     spin_lock_irqsave(&dev->devres_lock, flags);
>> +     list_for_each_entry_safe_reverse(node, tmp,
>> +                     &dev->devres_head, entry) {
>
> Why break this line?
>
>         list_for_each_entry_safe_reverse(node, tmp, &dev->devres_head, entry) {
>
> is perfectly fine.
>
>> +             struct devres *dr = container_of(node, struct devres, node);
>> +
>> +             if (node->release != release)
>> +                     continue;
>> +             if (match && !match(dev, dr->data, match_data))
>> +                     continue;
>> +             spin_unlock_irqrestore(&dev->devres_lock, flags);
>> +             fn(dev, dr->data);
>> +             spin_lock_irqsave(&dev->devres_lock, flags);
>> +     }
>> +     spin_unlock_irqrestore(&dev->devres_lock, flags);
>
> This looks strange. For the last node on the list, we're grabbing the
> lock and releasing it right after.
>
> Probably check whether node is the last element and only re-grab the
> lock if it isn't?

It is not necessary since the lock isn't held in hot path.

>
> And btw, don't we need to hold the ->devres_lock during the whole search
> like callers of find_dr do, for example?

Because I don't want to put more constraint on the 'fn' about lock use, memory
allocation flag(gfp)..., from the view of API's user.

In fact, there is problem wrt. releasing lock since add_dr may add new node
during releasing lock.

So I plan to just hold the lock to cover calling 'fn' in -v1 instead
of using rcu list
helpers, which may introduce a lot change on devres.

Anyway the callers can copy the resources interested into a temporary list
in 'fn' and handle it later, which may simplify devres_for_each_res and other
devres helpers a lot.

Also I will introduce another parameter of 'void *data' to 'fn' in -v1.

Thanks,
--
Ming Lei
