Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760373Ab1IKTXL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Sep 2011 15:23:11 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:40992 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760342Ab1IKTXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Sep 2011 15:23:09 -0400
Date: Sun, 11 Sep 2011 12:23:00 -0700
From: Kent Overstreet <kent.overstreet@gmail.com>
To: NeilBrown <neilb@suse.de>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, rdunlap@xenotime.net, axboe@kernel.dk,
        akpm@linux-foundation.org
Subject: Re: [GIT] Bcache version 12
Message-ID: <20110911192259.GA3743@moria>
References: <20110910064531.GA32536@moria>
 <20110911081854.2958fdc8@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110911081854.2958fdc8@notabene.brown>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 11, 2011 at 08:18:54AM +0200, NeilBrown wrote:
> On Fri, 9 Sep 2011 23:45:31 -0700 Kent Overstreet <kent.overstreet@gmail.com>
> > The code is up at
> > git://evilpiepirate.org/~kent/linux-bcache.git
> 
> In particular it is in the bcache-3.1 branch I assume.
> The  HEAD branch is old 2.6.34 code.

Yeah. I've still got to work off of 2.6.34, alas.

> > git://evilpiepirate.org/~kent/bcache-tools.git
> > 
> > The wiki is woefully out of date, but that might change one day:
> > http://bcache.evilpiepirate.org
> > 
> > The most up to date documentation is in the kernel tree -
> > Documentation/bcache.txt
> > 
> >  Documentation/ABI/testing/sysfs-block-bcache |  156 +
> >  Documentation/bcache.txt                     |  265 +
> >  block/Kconfig                                |   36 +
> >  block/Makefile                               |    4 +
> >  block/bcache.c                               | 8479 ++++++++++++++++++++++++++
> >  block/bcache_util.c                          |  661 ++
> >  block/bcache_util.h                          |  555 ++
> >  fs/bio.c                                     |    9 +-
> 
> Any change that a new driver needs to existing code much raise a big question
> mark.
> This change in bio.c looks like a bit of a hack.

It certainly is, but IMO it's justifiable as it improves the rest of the
code.

> Could you just provide a
> 'front_pad' to bioset_create to give you space in each bio to store the
> bio pool that the bio was allocated from.  See use of
> mddev_bio_destructor in drivers/md/md.c for an example.

I could, but it gets ugly - the inner details of bio allocation pretty
much have to spill out into the users of the code.

The reason this is more of an issue for me is I can't always allocate
from biosets, if it's running out of generic_make_request() that could
deadlock, so it's got to use bio_kmalloc() and punt to workqueue if that
allocation fails.

So it's not the prettiest thing in the world but it does provide some
useful generic functionality that could simplify code in other parts of
the kernel too.

> >  include/linux/blk_types.h                    |    2 +
> >  include/linux/sched.h                        |    4 +
> 
> Could we have a few words justifying the new fields in task_struct?

Yeah, they're for maintaining a rolling average of the sequential IO
sizes each task has been doing.

So if you want sequential IOs greater than 4 mb to skip the cache, this
way if you start copying a bunch of large files, after the first couple
files bcache can just start skipping every new file instead of caching
the first 4 mb (since the bios will never be that big).

Could be that they belong in struct io_context or somewhere else, I was
pointed towards struct io_context fairly recently but still haven't
gotten around to looking at it in detail.

> In general your commit logs are much much to brief (virtually non-existent).
> It is much easier to review code if you also tell us what the purpose is :-)

Yeah, comments have never been my strong point. I'll work on filling
those out :)
> 
> 
> >  include/trace/events/bcache.h                |   53 +
> >  kernel/fork.c                                |    3 +
> 
> Does this code even compile?
> fork.c now has
> +#ifdef CONFIG_BLK_CACHE
> +       p->sequential_io = p->nr_ios = 0;
> +#endif
> 
> but you have removed nr_ios from task_struct ??

Hah. It wouldn't compile if it ever tried. I renamed BLK_CACHE to BCACHE
at one point and it seems I missed that one.

> 
> 
> 
> >  12 files changed, 10225 insertions(+), 2 deletions(-)
> 
> 
> Looking at bcache.txt....
> 
> To make bcache devices known to the kernel, echo them to /sys/fs/bcache/register
>   echo /dev/sdb > /sys/fs/bcache/register
>   echo /dev/sdc > /sys/fs/bcache/register
> 
> ???
> I know that /sys is heading the way of /proc and becoming a disorganised ad
> hoc mess, but we don't need to actively encourage that.
> So when you are created a new block device type, putting controls
> under /sys/fs (where I believe 'fs' stands for "file system") seem ill
> advised.
> 
> My personal preference would be to see this as configuring the module and us
>   /sys/modules/bcache/parameters/register

I don't think that makes any more sense, as module paramaters AFAIK are
even more explicitly just a value you can stick in and pull out.
/sys/fs/bcache/register is really more analagous to mount().

You're not the first person to complain about that, I moved it to
configfs for awhile at Greg K-H's behest... but when I added cache sets
I had to move it back to sysfs.

> 
> Alternately you could device a new 'bus' type for bcache and do some sort of
> device-model magic to attach something as a new device of that type.

I like that, I think that could make a lot of sense.

I'm not sure what to do about register though, I do prefer to have it a
file you can echo to but it doesn't really fit anywhere.
