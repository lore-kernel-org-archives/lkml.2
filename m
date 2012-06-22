Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761174Ab2FVFZK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 01:25:10 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:58963 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761152Ab2FVFZI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 01:25:08 -0400
MIME-Version: 1.0
In-Reply-To: <1340323284.16104.4.camel@pasglop>
References: <1340171647-2815-1-git-send-email-b29396@freescale.com>
	<4FE1CB2C.5040208@gmail.com>
	<1340237796.28143.207.camel@pasglop>
	<20120621093702.GE21231@shlinux2.ap.freescale.net>
	<1340323284.16104.4.camel@pasglop>
Date: Fri, 22 Jun 2012 13:25:06 +0800
Message-ID: <CAA+hA=RoxfXWOQbZ2i=6w8GJShbpdi4EzkQRghSi2DL5F8pAng@mail.gmail.com>
Subject: Re: [PATCH 1/1] of: reform prom_update_property function
From: Dong Aisheng <dongas86@gmail.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Dong Aisheng <aisheng.dong@freescale.com>,
        Rob Herring <robherring2@gmail.com>,
        Dong Aisheng-B29396 <B29396@freescale.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2012 at 8:01 AM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
> On Thu, 2012-06-21 at 17:37 +0800, Dong Aisheng wrote:
>> Maybe we could change it as as follows.
>> It looks then the code follow is the same as before.
>> Do you think if it's ok?
>>
>> diff --git a/arch/powerpc/platforms/pseries/reconfig.c b/arch/powerpc/platforms/pseries/reconfig.c
>> index 7b3bf76..4c237f4 100644
>> --- a/arch/powerpc/platforms/pseries/reconfig.c
>> +++ b/arch/powerpc/platforms/pseries/reconfig.c
>> @@ -443,6 +443,9 @@ static int do_update_property(char *buf, size_t bufsize)
>>         if (!next_prop)
>>                 return -EINVAL;
>>
>> +       if (!strlen(name)
>> +               return -ENODEV;
>> +
>>         newprop = new_property(name, length, value, NULL);
>>         if (!newprop)
>>                 return -ENOMEM;
>> @@ -450,13 +453,6 @@ static int do_update_property(char *buf, size_t bufsize)
>>         if (!strcmp(name, "slb-size") || !strcmp(name, "ibm,slb-size"))
>>                 slb_set_size(*(int *)value);
>>
>> -       oldprop = of_find_property(np, name,NULL);
>> -       if (!oldprop) {
>> -               if (strlen(name))
>> -                       return prom_add_property(np, newprop);
>> -               return -ENODEV;
>> -       }
>
> No:
>
> IE. Old code did:
>
>        if (property doesn't exist) {
>                if (has a name)
>                        create_it()
>                return -ENODEV;
>        }
>
What i saw is:
       if (property doesn't exist) {
               if (has a name)
                       return create_it()
               return -ENODEV;
       }
Which seems the same behavior as the new prop_update_property api.
The only different is if no name, return -EINVAL;
Am i wrong?

> What you propose is:
>
>        if (!has_a_name)
>                return -ENODEV;
>
> Not at all the same semantic.
>
>  .../...
>
>> > IE. The allocation of the "old" property isn't disposed of. It can't
>> > because today we don't know whether any of those pointers was
>> > dynamically allocated or not. IE they could point to the fdt
>
>> Hmm, i did not see static allocated property before.
>> Where can we see an exist case?
>
> Almost all your property names and values. They are pointers to the
> original fdt block, so you can't free them. But dynamically added
> propreties will have kmalloc'ed pointers which should be freed. We need
> to add flags to indicate that if we want to avoid leaking memory in very
> dynamic environments.
>
Okay, got it, thanks for clarify.

>> If we really have this issue, it seems of_node_release also has the same issue,
>> since it frees the property without distinguish whether the property is allocated
>> dynamically.
>
> Well, actually we do have a flag:
>
>        if (!of_node_check_flag(node, OF_DYNAMIC))
>                return;
>
Oh, i see.

> So we use that. Good. So if update property uses that flag it should be
> able to know when to free or not. I forgot we had that :-)
>
I'm still not sure whether we should free the property in update
property function.
Looking at the code, it seems prom_update_property actually does not remove it.
It only move the property to "dead properties" list.
See the function comment in kernel:
/**
 * prom_remove_property - Remove a property from a node.
 *
 * Note that we don't actually remove it, since we have given out
 * who-knows-how-many pointers to the data using get-property.
 * Instead we just move the property to the "dead properties"
 * list, so it won't be found any more.
 */

Finally the dead properties will be freed in of_release_node
if the node has no users after calling of_node_put.

static void of_node_release(struct kref *kref)
{
.....
        struct property *prop = node->properties;
.......
        if (!of_node_check_flag(node, OF_DYNAMIC))
                return;

        while (prop) {
                struct property *next = prop->next;
                kfree(prop->name);
                kfree(prop->value);
                kfree(prop);
                prop = next;

                if (!prop) {
                        prop = node->deadprops;
                        node->deadprops = NULL;
                }
        }
        kfree(node->full_name);
        kfree(node->data);
        kfree(node);
}

So it looks to me there's no memory leak,
did i understand wrong?

>> > string list, data block, or could be bootmem ... or could be
>> > actual kernel memory.
>> >
>> > We might want to extend the struct property to contain indications of
>> > the allocation type so we can kfree dynamic properties properly.
>> >
>> I wonder the simplest way may be not allow static allocated property, like dt
>> node does i guess.
>
> No way. We generate the device-tree way before we have an allocator
> available.
>
Oh, got it.

>> > But then there's the question of the lifetime of a property... since
>> > they aren't reference counted like nodes are.
>> >
>> Yes, that's a real exist problem.
>>
>> Anyway, i guess we could do that work of this problem in another patch
>> rather than have to in this patch series.
>
> Cheers,
> Ben.
>
>

Regards
Dong Aisheng
