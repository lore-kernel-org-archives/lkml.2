Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189Ab0L0A1y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Dec 2010 19:27:54 -0500
Received: from dtp.xs4all.nl ([80.101.171.8]:25676 "HELO abra2.bitwizard.nl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752748Ab0L0A1x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Dec 2010 19:27:53 -0500
Date: Mon, 27 Dec 2010 01:27:50 +0100
From: Rogier Wolff <R.E.Wolff@BitWizard.nl>
To: Greg Freemyer <greg.freemyer@gmail.com>
Cc: Rogier Wolff <R.E.Wolff@BitWizard.nl>, Jaap Crezee <jaap@jcz.nl>,
        Jeff Moyer <jmoyer@redhat.com>,
        Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>,
        linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: Slow disks.
Message-ID: <20101227002750.GF18227@bitwizard.nl>
References: <x49aajxsrh3.fsf@segfault.boston.devel.redhat.com> <20101222224416.GE30941@bitwizard.nl> <x494oa48scp.fsf@segfault.boston.devel.redhat.com> <20101223170109.GA31591@bitwizard.nl> <x49bp4c7555.fsf@segfault.boston.devel.redhat.com> <AANLkTikbhzopmyfbJuHUQdEBJLLP9e65n0cNBuUjhDdd@mail.gmail.com> <4D139EAE.9090307@jcz.nl> <AANLkTimXCb00Hj1iPG5XKdfSmvQCwtw1Oo7Qr14ZR=Ge@mail.gmail.com> <20101224114008.GL30941@bitwizard.nl> <AANLkTi=e4aXeSSqCPRo4-t6j1GeW7Dj7hecHDK9KxhJ9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=e4aXeSSqCPRo4-t6j1GeW7Dj7hecHDK9KxhJ9@mail.gmail.com>
Organization: BitWizard.nl
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 26, 2010 at 06:05:05PM -0500, Greg Freemyer wrote:
> > You are assuming that the kernel is blind and doesn't do any
> > readaheads. I've done some tests and even when I run dd with a
> > blocksize of 32k, the average request sizes that are hitting the disk
> > are about 1000k (or 1000 sectors I don't know what units that column
> > are in when I run with -k option).
> 
> dd is not a benchmark tool.
> 
> You are building a email server that does 4KB random writes.
> Performance testing / tuning with dd is of very limited use.
> 
> For your load, read ahead is pretty much useless!

Greg, maybe it's wrong for me to tell you things about other systems
while we're discussing one system. But I do want to be able to tell you
that things are definitively different on that other server. 

That other server DOES Have loads similar to the access pattern that
dd generates. So that's why I benchmarked it that way, and base
decisions on that benchmark.

It turns out that, barring an easy way to "simulate the workload of a
mail server" my friend benchmarked his raid setup the same way.

This will at least provide for the benchmarked workload the optimal
setup. We all agree that this does not guarantee optimal performance
for the actual workload.

> > So your argument that "it fits exactly when your blocksize is 1M, so
> > it is obvious that 512k blocksizes are optimal" doesn't hold water.
> 
> If you were doing a real i/o benchmark, then 1MB random writes
> perfectly aligned to the Raid stripes would be perfect.  Raid really
> needs to be designed around the i/o pattern, not just optimizing dd.

Except when "dd" actually models the workload. Which in some cases it
does. Note that "some" doesn't refer to the badly performing
mailserver as you should know.

> >> Anything smaller than a 1 stripe write is where the issues occur,
> >> because then you have the read-modify-write cycles.
> >
> > Yes. But still they shouldn't be as heavy as we are seeing.  Besides
> > doing the "big searches" on my 8T array, I also sometimes write "lots
> > of small files". I'll see how many I can mange on that server....
> 
> <snip>
> >
> > You're repeating what WD says about their enterprise drives versus
> > desktop drives. I'm pretty sure that they believe what they are saying
> > to be true. And they probably have done tests to see support for their
> > theory. But for Linux it simply isn't true.
> 
> What kernel are you talking about.  mdraid has seen major improvements
> in this area in the last 2 o3 years or so.  Are you using a old kernel
> by chance?  Or reading old reviews?

OK. You might be right. I haven't had a RAID fail on me the last few
months. I don't tend to upgrade servers that are performing well. And
the things I can test and notice are for file servers things like
"serving files" not how they behave when a disk dies.

In my friends case, the server was in production doing its thing. He
doesn't like doing kernel upgrades unless he's near the machine. So
yes, the server could be running something several years old. 

However the issue is NOT that the raid system was badly configured or
could perform a few percent better, but that the disks (on which said
RAID array was running) were performing really bad: according to
"iostat -x" IO requests to the drives in the raid were taking on the
order of 200-300 ms, whereas normal drives service requests on the
order of 5-20ms. Now I wouldn't mind being told that for example the
stats from iostat -x are not accurate in suchandsuch case. Fine. We
can then do the measurements in a different way. But in my opinion the
observed slowness of the machine can be explained by the measurements
we see from iostat -x.


If you say that linux raid has been improved, I'm not sure I prefer
the new behaviour. Whatever a raidsubsystem does, things could be bad
in one situation or another.....

I don't like my system silently rewriting bad sectors on a failing
drive without making noise about the drive getting worse and
worse. I'd like to be informed that I have to swap out the drive. I
have zero tolerance for drives that manage to lose as little as 4096
bits (one sector) of my data..... But maybe it WILL start making noise
Then things would be good.

	Roger. 

-- 
** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2600998 **
**    Delftechpark 26 2628 XH  Delft, The Netherlands. KVK: 27239233    **
*-- BitWizard writes Linux device drivers for any device you may have! --*
Q: It doesn't work. A: Look buddy, doesn't work is an ambiguous statement. 
Does it sit on the couch all day? Is it unemployed? Please be specific! 
Define 'it' and what it isn't doing. --------- Adapted from lxrbot FAQ
