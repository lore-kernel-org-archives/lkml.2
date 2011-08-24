Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756840Ab1HXLCA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 07:02:00 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:54169 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756631Ab1HXLB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 07:01:57 -0400
Date: Wed, 24 Aug 2011 07:01:35 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Jovi Zhang <bookjovi@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
        =?iso-8859-1?Q?P=E1draig?= Brady <P@draigbrady.com>,
        dhowells@redhat.com, roland@redhat.com, viro@zeniv.linux.org.uk,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] coredump: fix pipe coredump when core limit is 0
Message-ID: <20110824110134.GA17362@hmsreliant.think-freely.org>
References: <48dnn9u5x3e4qoh8meht42xk.1313966177259@email.android.com>
 <4E527684.3020206@draigBrady.com>
 <20110822161914.GA9399@redhat.com>
 <CACV3sbJjDhzKq8YQEnrTQPVVw7YsZjLe45G5sWaMRBk3+Vxkcg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACV3sbJjDhzKq8YQEnrTQPVVw7YsZjLe45G5sWaMRBk3+Vxkcg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -1.5 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 24, 2011 at 06:14:24PM +0800, Jovi Zhang wrote:
> 2011/8/23 Oleg Nesterov <oleg@redhat.com>:
> > On 08/22, Pádraig Brady wrote:
> >>
> >> On 08/21/2011 11:36 PM, Neil Horman wrote:
> >> > Concur.  The comment should be changed
> >> > Neil
> >> >
> >> > Oleg Nesterov <oleg@redhat.com> wrote:
> >> >
> >> >> On 08/21, Oleg Nesterov wrote:
> >> >>>
> >> >>> On 08/21, bookjovi@gmail.com wrote:
> >> >>>>
> >> >>>> For non-pipe case, limit 0 also means drop the coredump, so just put
> >> >>>> the zero limit check at do_coredump function begining.
> >> >>>
> >> >>> Neil, what do you think? Should we change the code or the comment?
> >> >>
> >> >> Personally I think we should fix the comment. I think RLIMIT_CORE
> >> >> doesn't apply in this case, limit == 1 check is very special. And
> >> >> this is what linux always did, except between 725eae32 and 898b374a.
> >>
> >> Sorry for jumping in late here.
> >> I would really like `ulimit -c 0` to completely disable core dumps,
> >> including not running core_pattern, as I also mentioned here:
> >> https://bugs.launchpad.net/ubuntu/+source/apport/+bug/62511
> >> I noticed this in a script where ctrl-\ was taking a long
> >> time to be registered as the core_pattern was run unconditionally.
> >
> > May be. As I said, I do not really know and personally I agree with
> > everything. My only point was, this is not the bug, this is what we
> > always did.
> >
> > This is up to Neil, I think.
> >
> > Oleg.
> >
> >
> Well, so here have two questions.
> 1) That comments "but a limit of 0 skips the dump" definitely is wrong
> right now, it don't match with reality.
Agreed, I think your patch fixes this correctly.

> 2) In ispipe case, core limit 0 should skip the dump or not? this need
> more discussion.
>    from pipe coredump point of view, core limit is irrelevant, it
> doesn't write to file system.
>    from user point of view, there will be a lot of core files if we
> let core limit 0 create core file, user might be boring.
> 
The case (ispipe==true && cprm.lmit==0) has to result in us dumping a core. I
use to be convinced otherwise, but several user space developers changed my
mind, particularly the guys writing the abrt daemon.  The reason being, the
default process limit for RLIMIT_CORE is zero.  If you're writing a daemon like
abrt that wants to catch program crashes, even during boot, there are tons of
hoops you have to jump through to get core pipes enabled properly if you need to
change RLIMIT_CORE.  Specifically you have to modify all existing processes
RLIMIT_CORE values to be non-zero (a racy proposition) as well as modify the
init processes RLIMIT_CORE value (so that it gets inherited by future
processes).  Thats a pretty rickety thing to set up, and they really didn't want
to have that much fiddling to do to get it all working, and I don't blame them.
The fact that you're setting up a core pipe in the first place, implies to user
space that you want an executed notification of cores, and in that execution you
have the ability to filter which cores you actually care about.  If you're
worried about too many processes spawning or getting the cpu bogged with crash
handling, we have the core_limit sysctl to keep us throttled.

The long and the short of it is, making RLIMIT_CORE == 0 for the ispipe case
skip the core dump, breaks lots of user space expectations (which I know, is
counter-intuitive), but changing it will open up a large can of worms, it works
properly as it is.

> I fix the comments part by below patch(thanks Oleg's comments), please
> use attachment patch when merge.
> 
> From dc7b02a1e0e413fb96d22f1d4ef4da98115cfb9d Mon Sep 17 00:00:00 2001
> From: Jovi Zhang <bookjovi@gmail.com>
> Date: Wed, 17 Aug 2011 15:34:29 +0800
> Subject: [PATCH] coredump: fix wrong comments on core limits of pipe
> coredump case
> 
> In commit 898b374a, core limits recursive check vaule changed from 0 to 1,
> but the corresponding comments was not changed correctly.
> 
> Signed-off-by: Jovi Zhang <bookjovi@gmail.com>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Neil Horman <nhorman@tuxdriver.com>
Reviewed-by: Neil Horman <nhorman@tuxdriver.com>

