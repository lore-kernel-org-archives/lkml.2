Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933122Ab2JWPSg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 11:18:36 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47496 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933013Ab2JWPSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 11:18:33 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1210231022230.1635-100000@iolanthe.rowland.org>
References: <CACVXFVMmszZWHaeNS6LSG4nHR4wWBLwM_BvynRwUW8X=nO+JWA@mail.gmail.com>
	<Pine.LNX.4.44L0.1210231022230.1635-100000@iolanthe.rowland.org>
Date: Tue, 23 Oct 2012 23:18:31 +0800
Message-ID: <CACVXFVN+=XH_f5BmRkXeagTNowz0o0-Pd7GcxCneO0FSq8xqEw@mail.gmail.com>
Subject: Re: [RFC PATCH v2 2/6] PM / Runtime: introduce pm_runtime_set_memalloc_noio()
From: Ming Lei <ming.lei@canonical.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-kernel@vger.kernel.org, Oliver Neukum <oneukum@suse.de>,
        Minchan Kim <minchan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Jens Axboe <axboe@kernel.dk>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 10:46 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Tue, 23 Oct 2012, Ming Lei wrote:
>
>> On Mon, Oct 22, 2012 at 10:33 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
>> >
>> > Tail recursion should be implemented as a loop, not as an explicit
>> > recursion.  That is, the function should be:
>> >
>> > void pm_runtime_set_memalloc_noio(struct device *dev, bool enable)
>> > {
>> >         do {
>> >                 dev->power.memalloc_noio_resume = enable;
>> >
>> >                 if (!enable) {
>> >                         /*
>> >                          * Don't clear the parent's flag if any of the
>> >                          * parent's children have their flag set.
>> >                          */
>> >                         if (device_for_each_child(dev->parent, NULL,
>> >                                           dev_memalloc_noio))
>> >                                 return;
>> >                 }
>> >                 dev = dev->parent;
>> >         } while (dev);
>> > }
>>
>> OK, will take the non-recursion implementation for saving kernel
>> stack space.
>>
>> >
>> > except that you need to add locking, for two reasons:
>> >
>> >         There's a race.  What happens if another child sets the flag
>> >         between the time device_for_each_child() runs and the next loop
>> >         iteration?
>>
>> Yes, I know the race, and not adding a lock because the function
>> is mostly called in .probe() or .remove() callback and its parent's device
>> lock is held to avoid this race.
>>
>> Considered that it may be called in async probe() (scsi disk), one lock
>> is needed, the simplest way is to add a global lock. Any suggestion?
>
> No.  Because of where you put the new flag, it must be protected by
> dev->power.lock.  And this means the iterative implementation shown
> above can't be used as is.  It will have to be more like this:
>
> void pm_runtime_set_memalloc_noio(struct device *dev, bool enable)
> {
>         spin_lock_irq(&dev->power.lock);
>         dev->power.memalloc_noio_resume = enable;
>
>         while (dev->parent) {
>                 spin_unlock_irq(&dev->power.lock);
>                 dev = dev->parent;
>
>                 spin_lock_irq(&dev->power.lock);
>                 /*
>                  * Don't clear the parent's flag if any of the
>                  * parent's children have their flag set.
>                  */
>                 if (!enable && device_for_each_child(dev->parent, NULL,

s/dev->parent/dev

>                                 dev_memalloc_noio))
>                         break;
>                 dev->power.memalloc_noio_resume = enable;
>         }
>         spin_unlock_irq(&dev->power.lock);
> }

With the problem of non-SMP-safe bitfields access, the power.lock should
be held, but that is not enough to prevent children from being probed or
disconnected. Looks another lock is still needed. I think a global lock
is OK in the infrequent path.

>
>> >         Even without a race, access to bitfields is not SMP-safe
>> >         without locking.
>>
>> You mean one ancestor device might not be in active when
>> one of its descendants is being probed or removed?
>
> No.  Consider this example:
>
>         struct foo {
>                 int a:1;
>                 int b:1;
>         } x;
>
> Consider what happens if CPU 0 does "x.a = 1" at the same time as
> another CPU 1 does "x.b = 1".  The compiler might produce object code
> looking like this for CPU 0:
>
>         move    x, reg1
>         or      0x1, reg1
>         move    reg1, x
>
> and this for CPU 1:
>
>         move    x, reg2
>         or      0x2, reg2
>         move    reg2, x
>
> With no locking, the two "or" instructions could execute
> simultaneously.  What will the final value of x be?
>
> The two CPUs will interfere, even though they are touching different
> bitfields.

Got it, thanks for your detailed explanation.

Looks the problem is worse than above, not only bitfields are affected, the
adjacent fields might be involved too, see:

           http://lwn.net/Articles/478657/


Thanks,
--
Ming Lei
