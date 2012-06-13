Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637Ab2FMVlQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 17:41:16 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:48708 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750770Ab2FMVlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 17:41:14 -0400
X-Sasl-enc: 77ypXa3cX/fa/3S3uRq13KaX0o0Eue9OmS+hJcFGnF6h 1339623673
Date: Wed, 13 Jun 2012 18:41:10 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Borislav Petkov <bp@amd64.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Robert Richter <robert.richter@amd.com>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        andi@firstfloor.org, mingo@elte.hu, ming.m.lin@intel.com,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Dimitri Sivanich <sivanich@sgi.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: [PATCH] perf/x86: check ucode before disabling PEBS on
 SandyBridge
Message-ID: <20120613214110.GB6647@khazad-dum.debian.net>
References: <1339521203.31548.92.camel@twins>
 <20120612171734.GI8404@aftab.osrc.amd.com>
 <1339521493.31548.93.camel@twins>
 <20120612172352.GA4802@aftab.osrc.amd.com>
 <1339521996.31548.95.camel@twins>
 <20120612173506.GB4802@aftab.osrc.amd.com>
 <20120613010413.GA28174@khazad-dum.debian.net>
 <20120613065119.GB15661@aftab.osrc.amd.com>
 <20120613123649.GA26012@khazad-dum.debian.net>
 <20120613161139.GA18450@aftab.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120613161139.GA18450@aftab.osrc.amd.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Jun 2012, Borislav Petkov wrote:
> On Wed, Jun 13, 2012 at 09:36:49AM -0300, Henrique de Moraes Holschuh wrote:
> > Yes, please. I suggest we use core 0 for that. Using my Debian
> > maintainer hat, I'd rather you got rid of the sysfs entries for every
> > other core while at it, as it will make our life a lot simpler,
> > distro-side.
> 
> Wouldn't we have some sort of ABI breakage if I remove the sysfs files?

It wouldn't cause any problems in Debian, because currently our crap only
uses the deprecated /dev interface for Intel, and doesn't support AMD at
all.  This is something I am already addressing.

We would have to check the other distros, so maybe your -EINVAL idea is
better.

> Instead, I was thinking of having the rest of the files not on the BSP
> return -EINVAL and only the BSP reload ucode on the whole system.

That will work as well, although it will cause userspace to waste time
looping all CPUs for no good reason.  But userspace can be smart enough to
skip this on boot in the most common cases (modular microcode, with the
microcode already available at /lib/firmware at the time the module loads),
so I guess that doesn't matter much.

And obviously as soon as the system-wide microcode update sysfs node is
available, we can just test for the existence of that node, and ignore the
broken per-node interface when the system-wide node exists.

> > This is still not the proper fix, which would be to add a new sysfs node
> > to access the proper update-every-core functionality, but it is a damn
> > good start in the right direction and required to make it safe without
> > ripping out the old ABI entirely without a deprecation period.
> 
> Yes, I'd like to have the system-wide sysfs node somewhere under
> /sys/devices/system/cpu/microcode/ but we'll see how that goes.

Please set the sysfs node name ASAP, so that I can make sure the next Debian
stable ships knowing how to handle it :-)

> > Ok. Please CC me in the patches, if the new ABI arrives in time, I'll
> > even be able to get it supported on the next Debian stable (and push
> > to get this stuff backported to the kernel 3.2 which we will ship,
> > I consider this an important bug-fix to a pontentially very serious
> > issue. We have *zero* chance of finding out what's wrong if an users'
> > system start getting subtly crazy because it is running with skewed
> > microcode among cores.
> 
> Ok, will do.

Thank you!

> Btw, I have to think about whether we really want to backport this to
> stable since it is not a regression fix but functionality change which
> kinda fixes a some sort of bug. Hmm, the stable rules are kinda blurry
> here. I could write a minimal fix with stable in mind though... we'll
> see.

It is not a regression fix, but it is a major bugfix to the microcode
core...

> hpa, what is our take here, should we backport a minimal change
> disabling reloading of ucode per-cpu for stable? It is the wrong thing
> to do anyway.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
