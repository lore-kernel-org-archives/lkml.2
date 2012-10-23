Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932772Ab2JWJIu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 05:08:50 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:45740 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756666Ab2JWJIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 05:08:47 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1210221023300.1724-100000@iolanthe.rowland.org>
References: <1350894794-1494-3-git-send-email-ming.lei@canonical.com>
	<Pine.LNX.4.44L0.1210221023300.1724-100000@iolanthe.rowland.org>
Date: Tue, 23 Oct 2012 17:08:45 +0800
Message-ID: <CACVXFVMmszZWHaeNS6LSG4nHR4wWBLwM_BvynRwUW8X=nO+JWA@mail.gmail.com>
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

On Mon, Oct 22, 2012 at 10:33 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
>
> Tail recursion should be implemented as a loop, not as an explicit
> recursion.  That is, the function should be:
>
> void pm_runtime_set_memalloc_noio(struct device *dev, bool enable)
> {
>         do {
>                 dev->power.memalloc_noio_resume = enable;
>
>                 if (!enable) {
>                         /*
>                          * Don't clear the parent's flag if any of the
>                          * parent's children have their flag set.
>                          */
>                         if (device_for_each_child(dev->parent, NULL,
>                                           dev_memalloc_noio))
>                                 return;
>                 }
>                 dev = dev->parent;
>         } while (dev);
> }

OK, will take the non-recursion implementation for saving kernel
stack space.

>
> except that you need to add locking, for two reasons:
>
>         There's a race.  What happens if another child sets the flag
>         between the time device_for_each_child() runs and the next loop
>         iteration?

Yes, I know the race, and not adding a lock because the function
is mostly called in .probe() or .remove() callback and its parent's device
lock is held to avoid this race.

Considered that it may be called in async probe() (scsi disk), one lock
is needed, the simplest way is to add a global lock. Any suggestion?

>
>         Even without a race, access to bitfields is not SMP-safe
>         without locking.

You mean one ancestor device might not be in active when
one of its descendants is being probed or removed?


Thanks,
--
Ming Lei
