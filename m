Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934563Ab0KQIJq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 03:09:46 -0500
Received: from dtp.xs4all.nl ([80.101.171.8]:54253 "HELO abra2.bitwizard.nl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1758081Ab0KQIJq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 03:09:46 -0500
Date: Wed, 17 Nov 2010 09:09:44 +0100
From: Rogier Wolff <R.E.Wolff@BitWizard.nl>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Sync semantics.
Message-ID: <20101117080943.GA5694@bitwizard.nl>
References: <20101111125219.GA945@bitwizard.nl> <20101116143149.GC6527@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101116143149.GC6527@ucw.cz>
Organization: BitWizard.nl
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 03:31:49PM +0100, Pavel Machek wrote:
> > I would expect that all buffers that are dirty at the time of the
> > "sync" call are written by the time that sync returns. I'm currently
> > bombarding my fileserver with some 40-60Mbytes per second of data to
> > be written (*). The fileserver has 8G of memory. So max 8000 Mb of
> 
> Are you sure? Hitting 40MB/sec is hard when it involves seeking...

Yeah... It's about 10 times slower than when no seeking is involved,
so that makes sense, doesn't it? The machine can sustain over 400 Mb
per second on linear reads:

procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
 2  0      0  50908 6667292 502040    0    0 430064     0 2171 1677  0 23 66 11
 4  0      0  51280 6713952 501976    0    0 429596     0 2430 1889 16 28 44 12
 1  0      0  51768 6754884 502100    0    0 423388     0 2460 2100 13 28 47 13
 0  1      0  50760 6793392 502416    0    0 422892     0 2174 1796  0 21 68 10

Through the filesystem I get:

1073741824 bytes (1.1 GB) copied, 2.70151 s, 397 MB/s
1073741824 bytes (1.1 GB) copied, 2.62782 s, 409 MB/s

Which impresses me. In practise I seldomly see high
1xxMb/sec. (i.e. 120-150Mb per second happens, while 180-190 is rare).

On the other hand, in the same run I also get: 
1073741824 bytes (1.1 GB) copied, 6.82678 s, 157 MB/s
1073741824 bytes (1.1 GB) copied, 6.66133 s, 161 MB/s
1073741824 bytes (1.1 GB) copied, 6.58995 s, 163 MB/s

which apparently is caused by these files being more fragmented. These
files (1Gb each) were written linearly, but some might have been
written wile other of these 1G files (in a different directory) were
written at the same time. I'm guessing these ended up more or less
interleaved.

Checking up on the fragmentation of these files, the fast ones have
about 600-800 fragments, while the slow ones have 1300-2000 fragments.

Mb/sec    #frags
 400       1252
 493        865
 391        755
 393        606
 395        819
 206        937
 159        901
 173       1940
 165       1806
 157       1481
 168       1351
 179       2692
 166       1541
 154       1151
 159        924
 149       1228
 155       1139
 151       1103
 150       1070
 155       1160

There is SOME correlation but not 100%. This is on an 8x1T RAID. 

> You may want to lower dirty_ratio...

You know, what I would REALLY want is that when say 400Mb of dirty
buffers exist, the machine would start alternating between the two or
three areas that require writing. All these should be "linear". If you
switch only once every second or so, the "seeking time" is less than
1%. In that case, my server should be able to write up to 400Mb per
second, except for that I can only supply 120Mb per second over the
Ethernet. But that would still be a 3x improvement over what the
machine can handle now.

In theory these things should work even better if things like
"dirty_ratio" are higher. 

In the current situation, the "sync" call will return when the IO
system falls to "idle". The chances of "nothing needing writing"
increases as the amount of allowed buffers is lower. But the problem
is that sync keeps on waiting for those new "dirty" buffers that have
become dirty AFTER the start of the sync call.

Suppose we have a mail handling daemon that just recieved an Email
from over the network. Instead of just saying: Ok, i'll take over from
here, it prefers to write it to disk, and calls sync, so that should
the power fail, the EMail is on permanent storage, and can be
correctly handled.

This works just great, until someone manages to get the server to
continue to get new dirty buffers, so that the sync takes over ten
minutes, and the other sides MTA will time out.....

Anyway, someone told me that it's been fixed, and sync won't behave
like this anymore.

	Roger. 

> -- 
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
> 

-- 
** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2600998 **
**    Delftechpark 26 2628 XH  Delft, The Netherlands. KVK: 27239233    **
*-- BitWizard writes Linux device drivers for any device you may have! --*
Q: It doesn't work. A: Look buddy, doesn't work is an ambiguous statement. 
Does it sit on the couch all day? Is it unemployed? Please be specific! 
Define 'it' and what it isn't doing. --------- Adapted from lxrbot FAQ
