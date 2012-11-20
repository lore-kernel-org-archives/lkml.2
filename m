Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361Ab2KTWjl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 17:39:41 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:51489 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753102Ab2KTWjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 17:39:39 -0500
MIME-Version: 1.0
Date: Tue, 20 Nov 2012 19:39:38 -0300
Message-ID: <CALF0-+WuaUn5b=2XrzqW7pvM=N1MfQf=sFwLFOrokTkHbOXh3w@mail.gmail.com>
Subject: [RFC/PATCH 0/1] ubi: Add ubiblock driver
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mtd@lists.infradead.org, Artem Bityutskiy <dedekind1@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, Tim Bird <tim.bird@am.sony.com>,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm happy to announce we finally have a read/write ubiblock implementation!

What follows are some historical notes and some implementation hints.
Feel free to comment on anything, ask questions or provide feedback.
You can even fire some flames if you like, my asbestos suite works just fine ;-)

* Some history

It appears this is a long wanted feature. There's a
thread [1] from January 2008, where Artem gives some
hints on implementation.

A year ago, some work was done by David Wagner to implement
a read-only ubi block device (called ubiblk).
His latest patch seems to be this from September, 2011 [1].
Unfortunately, his implementation never got merged.

I've taken his implementation as a starting point (courtesy of free-electrons!),
and taken as much as I could from mtdblock, mtd_blkdev and gluebi
to make the code as consistent as possible.

* About this ubiblock driver

Because ubiblk is unpronounceable (unless you're Russian ;-)
and to match mtdblock naming, I've chosen the simpler name
'ubiblock'.

Also, I've decided to make block devices get automatically created for
each ubi volume present.
This has been done to match gluebi behavior of automatically create an
mtd device
per ubi volume, and to save us the usertool trouble.

The latter is the most important reason: a new usertool means an added
complexity
for the user and yet more crap to maintain.

Besides, each ubiblock is fairly cheap since it's based on workqueues
and not on threads.
I don't know how many ubi volumes a user typically creates, but I
expect not to be too many.

* Read/write support

Yes, this implementation supports read/write access.
It's expected to work fairly well because the request queue at block elevator
is suppose to order block transfers to be space-effective.
In other words, it's expected that reads and writes gets ordered
to point to the same LEB (see Artem's hint at [1]).

To help this and reduce access to the UBI volume, a 1-LEB size
write-back cache has been implemented (similar to the one at mtdblock.c).

Every read and every write, goes through this cache and the write is only
done when a request arrives to read or write to a different LEB or when
the device is released, when the last file handle is closed.
This cache is 1-LEB bytes, vmalloced at open() and freed at release().

* But the bad news are...

I don't own raw flashes devices to test this on.
(Well, I do have a few but they're not supported upstream
and they run on an ancient kernel.)

I've tested this on a qemu environment, creating UBI volumes on top
of nandsim devices. No problems so far, but the testing phase is still ongoing.

I expect to have some flash boards to test in a near future,
but for now, please consider this as experimental stuff.

Feel free to test this on real hardware and report any bugs.
I'll be more than happy to fix them.

* The future

** Implement debugfs files to report statistics on cache behavior.
   This would help us to decide what's best.

** Compare different block evelators, and compare a request-queue
   based implementation (the current one),
   against a do-it-yourself make_request oriented one.
   The latter is used in ramdisk (brd.c) and in loop device (loop.c),
   though I don't expect to perform better.

This patch is based on today's l2-mtd branch, but probably will
apply on any recent branch.

Thanks,

    Ezequiel

[1] http://lists.infradead.org/pipermail/linux-mtd/2008-January/020381.html
[2] http://lwn.net/Articles/452944/
