Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612Ab0LXLkM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Dec 2010 06:40:12 -0500
Received: from dtp.xs4all.nl ([80.101.171.8]:25906 "HELO abra2.bitwizard.nl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752134Ab0LXLkK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Dec 2010 06:40:10 -0500
Date: Fri, 24 Dec 2010 12:40:08 +0100
From: Rogier Wolff <R.E.Wolff@BitWizard.nl>
To: Greg Freemyer <greg.freemyer@gmail.com>
Cc: Jaap Crezee <jaap@jcz.nl>, Jeff Moyer <jmoyer@redhat.com>,
        Rogier Wolff <R.E.Wolff@BitWizard.nl>,
        Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>,
        linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: Slow disks.
Message-ID: <20101224114008.GL30941@bitwizard.nl>
References: <AANLkTi=VAJbVSzX_DH9_==a3RonLJmawYu3MzF-uqGXC@mail.gmail.com> <20101222104306.GB30941@bitwizard.nl> <x49aajxsrh3.fsf@segfault.boston.devel.redhat.com> <20101222224416.GE30941@bitwizard.nl> <x494oa48scp.fsf@segfault.boston.devel.redhat.com> <20101223170109.GA31591@bitwizard.nl> <x49bp4c7555.fsf@segfault.boston.devel.redhat.com> <AANLkTikbhzopmyfbJuHUQdEBJLLP9e65n0cNBuUjhDdd@mail.gmail.com> <4D139EAE.9090307@jcz.nl> <AANLkTimXCb00Hj1iPG5XKdfSmvQCwtw1Oo7Qr14ZR=Ge@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimXCb00Hj1iPG5XKdfSmvQCwtw1Oo7Qr14ZR=Ge@mail.gmail.com>
Organization: BitWizard.nl
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 23, 2010 at 05:09:43PM -0500, Greg Freemyer wrote:
> On Thu, Dec 23, 2010 at 2:10 PM, Jaap Crezee <jaap@jcz.nl> wrote:
> > On 12/23/10 19:51, Greg Freemyer wrote:
> >> On Thu, Dec 23, 2010 at 12:47 PM, Jeff Moyer<jmoyer@redhat.com>  wrote:
> >> I suspect a mailserver on a raid 5 with large chunksize could be a lot
> >> worse than 2x slower.  But most of the blame is just raid 5.
> >
> > Hmmm, well if this really is so.. I use raid 5 to not "spoil" the storage
> > space of one disk. I am using some other servers with raid 5 md's which
> > seems to be running just fine; even under higher load than the machine we
> > are talking about.
> >
> > Looking at the vmstat block io the typical load (both write and read) seems
> > to be less than 20 blocks per second. Will this drop the performance of the
> > array (measured by dd if=/dev/md<x> of=/dev/null bs=1M) below 3MB/secs?
> >
> 
> You clearly have problems more significant than your raid choice, but
> hopefully you will find the below informative anyway.
> 
> ====
> 
> The above is a meaningless performance tuning test for a email server,
> but assuming it was a useful test for you:
> 
> With bs=1MB you should have optimum performance with a 3-disk raid5
> and 512KB chunks.
> 
> The reason is that a full raid stripe for that is 1MB  (512K data +
> 512K data + 512K parity = 1024K data)
> 
> So the raid software should see that as a full stripe update and not
> have to read in any of the old data.
> 
> Thus at the kernel level it is just:
> 
> write data1 chunk
> write data2 chunk
> write parity chunk
> 
> All those should happen in parallel, so a raid 5 setup for 1MB writes
> is actually just about optimal!

You are assuming that the kernel is blind and doesn't do any
readaheads. I've done some tests and even when I run dd with a
blocksize of 32k, the average request sizes that are hitting the disk
are about 1000k (or 1000 sectors I don't know what units that column
are in when I run with -k option).

So your argument that "it fits exactly when your blocksize is 1M, so
it is obvious that 512k blocksizes are optimal" doesn't hold water.

When the blocksize is too large, the system will be busy reading and
waiting for one disk, while leaving the second (and third and ...)
disk idle. Just because readahead is final. You indeed want the
readahead to hit many disks at the same time so that when you get
around to reading the data from the drives they can run at close to
bus speed.

When the block size is too small you'll spend to much time splitting
say a 1M readahead on the MD device into 16 64k chunks for individual
drives, and then (if that works) merging them back together again for
those drives to prevent the over head of too many commands to each
drive (for a 4-drive raid5, the first and fourth block are likely to
be consecutive on the same drive...). Hmmm. but those would have to go
into different spots in a buffer, so it might simply ahve to incur
that extra overhead....

> Anything smaller than a 1 stripe write is where the issues occur,
> because then you have the read-modify-write cycles.

Yes. But still they shouldn't be as heavy as we are seeing.  Besides
doing the "big searches" on my 8T array, I also sometimes write "lots
of small files". I'll see how many I can mange on that server.... 

	Roger. 

> 
> (And yes, the linux mdraid layer recognizes full stripe writes and
> thus skips the read-modify portion of the process.)
> 
> >> ie.
> >> write 4K from userspace
> >>
> >> Kernel
> >> Read old primary data, wait for data to actually arrive
> >> Read old parity data, wait again
> >> modify both for new data
> >> write primary data to drive queue
> >> write parity data to drive queue
> >
> > What if I (theoratically) change the chunksize to 4kb? (I can try that in
> > the new server...).
> 
> 4KB random writes is really just too small for an efficient raid 5
> setup.  Since that's your real workload, I'd get away from raid 5.
> 
> If you really want to optimize a 3-disk raid-5 for random 4K writes,
> you need to drop down to 2K chunks which gives you a 4K stripe.  I've
> never seen chunks that small used, so I have no idea how it would
> work.
> 
> ===> fyi: If reliability is one of the things pushing you away from raid-1
> 
> A 2 disk raid-1 is more reliable than a 3-disk raid-5.
> 
> The math is, assume each of your drives has a one in 1000 chance of
> dieing on a specific day.
> 
> So a raid-1 has a 1 in a million chance of a dual failure on that same
> specific day.
> 
> And a raid-5 would have 3 in a million chances of a dual failure on
> that same specific day.  ie. drive 1 and 2 can fail that day, or 1 and
> 3, or 2 and 3.
> 
> So a 2 drive raid-1 is 3 times as reliable as a 3-drive raid-5.
> 
> If raid-1 still makes you uncomfortable, then go with a 3-disk mirror
> (raid 1 or raid 10 depending on what you need.)
> 
> You can get 2TB sata drives now for about $100 on sale, so you could
> do a 2 TB 3-disk raid-1 for $300.  Not a bad price at all in my
> opinion.
> 
> fyi: I don't know if "enterprise" drives cost more or not.  But it is

They do. They cost about twice as much. 

> important you use those in a raid setup.  The reason being normal
> desktop drives have retry logic built into the drive that can take
> from 30 to 120 seconds.  Enterprise drives have fast fail logic that
> allows a media error to rapidly be reported back to the kernel so that
> it can read that data from the alternate drives available in a raid.

You're repeating what WD says about their enterprise drives versus
desktop drives. I'm pretty sure that they believe what they are saying
to be true. And they probably have done tests to see support for their
theory. But for Linux it simply isn't true.

WD apparently tested their drives with a certain unnamed operating
system. That operating system may wait for up to two minutes for a
drive to report "bad block" or "succesfully remapped this block, and
here is your data".

>From my experience, it is unlikely that a desktop user will sit behind
his/her workstation for two minutes for the screen to unfreeze while
the drive goes into deep recovery. The reset button will have been
pressed by that time. Both on Linux /and/ that other OS. 


Moreover, Linux uses a 30 second timeout. If a drive doesn't respond
in 30 second, it will be reset and the request tried again. I don't
think the drive will restart the "deep recovery" procedure after a
reset-identify-reread cycle where it left off. It will start all
over. 

The SCSI disks have it all figured out. There you can use standard
commands to set the maximum recovery time. If you set it to "20ms" the
drive can calculate that it has ONE retry option on the next
revolution (or two if it runs at more than xxx RPM) and nothing else.

WD claims a RAID array might quickly switch to a different drive if it
knows the block cannot be read from one drive. This is true. But at
least for Linux software raid, the drive will immediately be bumped
from the array, and never be used/read/written again until it is
replaced.

Now they might have a point there. For a drive a limited amount of bad
blocks, it might be MUCH better to mark the drive as "in desparate
need of replacement" instead of "Failed". One thing you can do to help
the drive is to rewrite the bad sectors with the recalculated
data. The drive can then remap the sectors.

We see MUCH too often raid arrays that lose a drive evict it from the
RAID and everything keeps on working, so nobody wakes up. Only after a
second drive fails, things stop working and the datarecovery company
gets called into action. Often we have a drive with a few bad blocks
and months-old data, and a totally failed drive which is neccesary for
a full recovery. It's much better to keep the failed/failing drive in
the array and up-to-date during the time that you're pushing the
operator to get it replaced.

	Roger. 

-- 
** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2600998 **
**    Delftechpark 26 2628 XH  Delft, The Netherlands. KVK: 27239233    **
*-- BitWizard writes Linux device drivers for any device you may have! --*
Q: It doesn't work. A: Look buddy, doesn't work is an ambiguous statement. 
Does it sit on the couch all day? Is it unemployed? Please be specific! 
Define 'it' and what it isn't doing. --------- Adapted from lxrbot FAQ
