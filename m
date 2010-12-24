Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751905Ab0LXKpG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Dec 2010 05:45:06 -0500
Received: from dtp.xs4all.nl ([80.101.171.8]:24888 "HELO abra2.bitwizard.nl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751200Ab0LXKpD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Dec 2010 05:45:03 -0500
Date: Fri, 24 Dec 2010 11:45:00 +0100
From: Rogier Wolff <R.E.Wolff@BitWizard.nl>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Rogier Wolff <R.E.Wolff@BitWizard.nl>,
        Greg Freemyer <greg.freemyer@gmail.com>,
        Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>,
        linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: Slow disks.
Message-ID: <20101224104500.GK30941@bitwizard.nl>
References: <20101220141553.GA6088@bitwizard.nl> <20101220190630.66084e1d@neptune.home> <AANLkTi=VAJbVSzX_DH9_==a3RonLJmawYu3MzF-uqGXC@mail.gmail.com> <20101222104306.GB30941@bitwizard.nl> <x49aajxsrh3.fsf@segfault.boston.devel.redhat.com> <20101222224416.GE30941@bitwizard.nl> <x494oa48scp.fsf@segfault.boston.devel.redhat.com> <20101223170109.GA31591@bitwizard.nl> <x49bp4c7555.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49bp4c7555.fsf@segfault.boston.devel.redhat.com>
Organization: BitWizard.nl
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 23, 2010 at 12:47:34PM -0500, Jeff Moyer wrote:
> Rogier Wolff <R.E.Wolff@BitWizard.nl> writes:
> 
> > On Thu, Dec 23, 2010 at 09:40:54AM -0500, Jeff Moyer wrote:
> >> > In my performance calculations, 10ms average seek (should be around
> >> > 7), 4ms average rotational latency for a total of 14ms. This would
> >> > degrade for read-modify-write to 10+4+8 = 22ms. Still 10 times better
> >> > than what we observe: service times on the order of 200-300ms. 
> >> 
> >> I didn't say it would account for all of your degradation, just that it
> >> could affect performance.  I'm sorry if I wasn't clear on that.
> >
> > We can live with a "2x performance degradation" due to stupid
> > configuration. But not with the 10x -30x that we're seeing now. 
> 
> Wow.  I'm not willing to give up any performance due to
> misconfiguration!

Suppose you have a hard-to-reach server somewhere. Suppose that you
find out that the <whatever> card could perform 15% better if you put
it in a different slot. Would you go and dig the server out to fix
this if you know the performance now will be adequate for the next few
years? Isn't it acceptable to keep things like this until a next
scheduled (or unscheduled) maintenance?

In reality I have two servers with 8T of RAID storage each. Together
with shuffling all important data around on these trying to get the
exactly optimal performance out of these storage systems is very
timeconsuming. Also each "move the data out of the way, reconfigure
the RAID, move the data back" cycle incurs risks of losing or
corrupting the data. 

I prefer concentrating on the most important part. In this case we
have a 30fold performance problem. If there is a 15fold one and a
2fold one then I'll settle for looking into and hopefully fixing the
15fold one, and I'll discard the 2fold one for the time being. Not
important enough to look into. The machine happens to have 30fold
performance margin. It can keep up with what it has to do with the
30fold slower disks. However work comes in batches so the queue grows
significantly during a higher-workload-period.

> >> >  > md1 : active raid5 sda2[0] sdd2[3](S) sdb2[1] sdc2[4]
> >> >> >       39067648 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3/3]
> >> >> > [UUU]
> >> >> 
> >> >> A 512KB raid5 chunk with 4KB I/Os?  That is a recipe for inefficiency.
> >> >> Again, blktrace data would be helpful.
> >> >
> >> > Where did you get the 4kb IOs from? You mean from the iostat -x
> >> > output?
> >> 
> >> Yes, since that's all I have to go on at the moment.
> >> 
> >> > The system/filesystem decided to do those small IOs. With the
> >> > throughput we're getting on the filesystem, it better not try to write
> >> > larger chuncks...
> >> 
> >> Your logic is a bit flawed, for so many reasons I'm not even going to
> >> try to enumerate them here.  Anyway, I'll continue to sound like a
> >> broken record and ask for blktrace data.
> >
> > Here it is. 
> >
> > http://prive.bitwizard.nl/blktrace.log
> >
> > I can't read those yet... Manual is unclear. 
> 
> OK, I should have made it clear that I wanted the binary logs.  No
> matter, we'll work with what you've sent.
> 
> > My friend confessed to me today that he determined the "optimal" RAID
> > block size with the exact same test as I had done, and reached the
> > same conclusion. So that explains his raid blocksize of 512k. 
> >
> > The system is a mailserver running on a raid on three of the disks.
> > most of the IOs are generated by the mail server software through the
> > FS driver, and the raid system. It's not that we're running a database
> > that inherently requires 4k IOs. Apparently what the
> > system needs are those small IOs. 
> 
> The log shows a lot of write barriers:
> 
>   8,32   0     1183   169.033279975   778  A WBS 481958 + 2 <- (8,34) 8
                                            ^^^
> 
> On pre-2.6.37 kernels, that will fully flush the device queue, which is
> why you're seeing such a small queue depth.  There was also a CFQ patch
> that sped up fsync performance for small files that landed in .37.  I
> can't remember if you ran with a 2.6.37-rc or not.  Have you?  It may be
> in your best interest to give the latest -rc a try and report back.

It is a production system. Wether my friend is willing to run a
prerelease kernel there remains to be seen.

On the other hand, if this were a MAJOR performance bottleneck it
wouldn't be on the "list of things to fix in december 2010, but it
would've been fixed years ago. 

Jeff, can you tell me where in that blktrace output do I see the
system noticing "we need to read block XXX from the disk", then that
gets queued, next it gets submitted to the hardware, and eventually
the hardware reports back: I got block XXX from the media here it
is. Can you point these events out in the logfile form me? (for any
single transaction that belongs together?)

It would be useful to see the XXX numbers (for things like block
device optimizers) and the timestamps (for us to debug this problem
today.) I strongly suspect that both are logged, right?

	Roger. 


-- 
** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2600998 **
**    Delftechpark 26 2628 XH  Delft, The Netherlands. KVK: 27239233    **
*-- BitWizard writes Linux device drivers for any device you may have! --*
Q: It doesn't work. A: Look buddy, doesn't work is an ambiguous statement. 
Does it sit on the couch all day? Is it unemployed? Please be specific! 
Define 'it' and what it isn't doing. --------- Adapted from lxrbot FAQ
