Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933167Ab2HPTWJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 15:22:09 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:44521 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932106Ab2HPTWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 15:22:05 -0400
MIME-Version: 1.0
In-Reply-To: <20120816180732.GA451@polaris.bitmath.org>
References: <1344807757-2217-1-git-send-email-rydberg@euromail.se>
	<1344807757-2217-10-git-send-email-rydberg@euromail.se>
	<CAF8JNhLBO72-Rpm7dFWfYLPvbhDZZsm2yOy_7sREnNhTWqZ04w@mail.gmail.com>
	<20120816180732.GA451@polaris.bitmath.org>
Date: Thu, 16 Aug 2012 12:22:03 -0700
Message-ID: <CAF8JNhJ1R68pU3aOCnYC8KvmfDDU7oKhMsvQV5hfRX2qE=X5WA@mail.gmail.com>
Subject: Re: [PATCH 09/19] Input: MT - Handle frame synchronization in core
From: Ping Cheng <pinglinux@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16, 2012 at 11:07 AM, Henrik Rydberg <rydberg@euromail.se> wrote:
> On Wed, Aug 15, 2012 at 04:28:17PM -0700, Ping Cheng wrote:
>> On Sun, Aug 12, 2012 at 2:42 PM, Henrik Rydberg <rydberg@euromail.se> wrote:
>> > Collect common frame synchronization tasks in a new function,
>> > input_mt_sync_frame(). Depending on the flags set, it drops
>> > unseen contacts and performs pointer emulation.
>> >
>> > Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
>>
>> I went through the patchset except those for bcm5974. Since there are
>> changes that affect other drivers, do you plan to update the affected
>> drivers as well?
>
> I am not sure what you mean here? There is a patch with in-kernel api
> changes, which also changes all drivers using the api. Some of those
> drivers will benefit from further changes, but that is a different
> story.

I meant that some new routines require individual MT drivers to be
updated to adapt to the new implementation.

For example, the new input_mt_init_slots() takes care of the
__set_bit() functions in one place. That is great. But, it requires
wacom_wac.c to be updated since it has an interface change. I guess
there are other drivers calling input_mt_init_slots as well.

I was wondering if you plan to update all drivers after this patchset
is accepted or if you need us to chime in.


>> > +void input_mt_sync_frame(struct input_dev *dev)
>> > +{
>> > +       struct input_mt *mt = dev->mt;
>> > +       struct input_mt_slot *s;
>> > +
>> > +       if (!mt)
>> > +               return;
>> > +
>> > +       if (mt->flags & INPUT_MT_DROP_UNUSED) {
>> > +               for (s = mt->slots; s != mt->slots + mt->num_slots; s++) {
>> > +                       if (s->frame == mt->frame)
>> > +                               continue;
>> > +                       input_mt_slot(dev, s - mt->slots);
>> > +                       input_event(dev, EV_ABS, ABS_MT_TRACKING_ID, -1);
>> > +               }
>> > +       }
>> > +
>> > +       if (mt->flags & INPUT_MT_POINTER)
>> > +               input_mt_report_pointer_emulation(dev, true);
>> > +
>> > +       if (mt->flags & INPUT_MT_DIRECT)
>> > +               input_mt_report_pointer_emulation(dev, false);
>> > +
>> > +       mt->frame++;
>>
>> Where do we reset this frame counter?
>
> Why would we reset it? It is used in the core to keep track of changes
> per frame, and may wrap around without issues.

>From what I see, frame/mt is only initialized when driver starts.
Frame will be increased by MT events while the driver running. If this
is true, won't it be possible the value gets too large?

I might have missed a detail about frame somewhere in the patchset.

Ping
