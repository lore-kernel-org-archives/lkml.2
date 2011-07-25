Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751631Ab1GYOXH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 10:23:07 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:37713 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776Ab1GYOXG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 10:23:06 -0400
MIME-Version: 1.0
In-Reply-To: <4E2D678E.2010209@redhat.com>
References: <4E2987AE.2070707@redhat.com> <1311553130.1671.21.camel@mop>
 <4E2D4177.9000402@redhat.com> <CAPXgP101Jr3-k4p8ow-F3Phq+fNmC1eR8LD+j609xBvGfd1cUg@mail.gmail.com>
 <4E2D678E.2010209@redhat.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Mon, 25 Jul 2011 16:22:43 +0200
Message-ID: <CAPXgP12y2bPiGTJEpDQpwztUoooXX1DB=F8=VWzjop5roMhhhQ@mail.gmail.com>
Subject: Re: [dm-devel] [PATCH] Reduce number of KOBJ_REMOVE events
To: Zdenek Kabelac <zkabelac@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Greg KH <greg@kroah.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 25, 2011 at 14:54, Zdenek Kabelac <zkabelac@redhat.com> wrote:
> Dne 25.7.2011 14:17, Kay Sievers napsal(a):

>>>> Then have 'dm_blk_dops' add '.uevent' and let the core call into the dm
>>>> code to the needed properties to the 'remove' event, instead of sending
>>>> its own, and see the duplication.
>>>
>>> Sounds like complex solution
>>
>> I don't think so, It's clean, ~30 lines long, and technically correct, I expect.

In include/linux/blkdev.h add:
  int (*uevent) (struct gendisk *, struct kobj_uevent_env *env);
to
  struct block_device_operations

In block/genhd.c add:
  .uevent = block_uevent;
to
  struct class block_class
and have the block_uevent() callback check for an existing uevent() in
the block_device_operations, call it when it's specified.

In drivers/md/dm.c add:
  .dm_uevent;
to
  struct block_device_operations dm_blk_dops
and add all the needed variables there, instead of sending out a faked
device 'remove' event.

>>> maybe it would be easier to just register some
>>> environment variable on dm code side - like kobject_add_env() - so it would
>>> take envs from this internal kobject list and after sending uevent it would
>>> implicitly clear this list.
>>
>> So we would keep allocated per-event-type variables in the kobject, to
>> send when 'remove' is finally called? The callbacks are just much
>> simpler , I guess.
>
> No - nothing so complex - kobject would have the list - and you would be able
> to add some env param to this list - the nearest  kobject_uevent() would just
> splice those parameters to the env list it wants to send (something like 10
> lines of code). The only user would be probably dm so far - and it would check
> it wants to send REMOVE - and in this case it would add env to kobject and
> would skip kobject_uvent.

We don't want to encourage anybody to mess around with events that
way. We also don't want to keep track of subsystem specific event
properties in the core kobject. It's just wrong to send 'remove' from
a driver that uses 'struct device'. It should be changed in dm, not
worked-around in the core.

> On the other hand, it would probably extended kobject struct size without big
> use case - so Milan's solution that checks whether REMOVE has been already
> sent and skip all future REMOVE events seems by far the simplest here.

Yeah, I see the logic, but it doesn't make sending additional 'remove'
events any more correct. We don't want to encourage anybody with code
in the core to do this. 'Add' and 'remove' is nothing struct device
user should send on their own.

> I think your proposal also requires struct extension to store callback somewhere ?

Yeah, it's a block subsys callback, a pointer per block driver, not
per device, nothing that really matters, and it's looks generally
useful.

>>> So in dm case  dm-uevent would just register  env(cookie) for KOBJ_REMOVE and
>>> would left kobject_uevent() on block layer ?
>>>
>>> Also I'm aware that remove event would be delayed by leaving it on
>>> kobject_cleanup(), but since you mentioned 'del()' as a better place - why not
>>> move this implicit uvent call there.
>>
>> It's probably not wrong to do that, but I don't remember now why we
>> added it to release() that time.
>
> del() looks like the best natural place here - and safe few lines of code ;)

Yeah, but again, raw kobjects never send any event, not even 'add'.
It's up the caller to take care of that, if these events are needed.
Many things rightfully never send any event.

The code in the core exists only for the un-common use case that the
caller does send 'add' but does not clean-up the objects properly, and
would introduce an asymmetry with that. We don't want to encourage
anything like that.

The code isn't there to allow additional 'remove' events or to leave
the cleanup to the core in general.

Thanks,
Kay
