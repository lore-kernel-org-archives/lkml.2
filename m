Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836Ab2FMMgz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 08:36:55 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:37010 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752529Ab2FMMgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 08:36:53 -0400
X-Sasl-enc: cNVhquPb5b9XM+3Vv3d0pXPcOMoZy4QNlnHMbhyIyb0v 1339591012
Date: Wed, 13 Jun 2012 09:36:49 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Borislav Petkov <bp@amd64.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Robert Richter <robert.richter@amd.com>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        andi@firstfloor.org, mingo@elte.hu, ming.m.lin@intel.com,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Dimitri Sivanich <sivanich@sgi.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: [PATCH] perf/x86: check ucode before disabling PEBS on
 SandyBridge
Message-ID: <20120613123649.GA26012@khazad-dum.debian.net>
References: <20120612170725.GE5046@erda.amd.com>
 <CABPqkBRJAA7yRcswM1iYESSwhiGD4SEbir=q=ouQSevi7OAxqQ@mail.gmail.com>
 <1339521203.31548.92.camel@twins>
 <20120612171734.GI8404@aftab.osrc.amd.com>
 <1339521493.31548.93.camel@twins>
 <20120612172352.GA4802@aftab.osrc.amd.com>
 <1339521996.31548.95.camel@twins>
 <20120612173506.GB4802@aftab.osrc.amd.com>
 <20120613010413.GA28174@khazad-dum.debian.net>
 <20120613065119.GB15661@aftab.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120613065119.GB15661@aftab.osrc.amd.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Jun 2012, Borislav Petkov wrote:
> On Tue, Jun 12, 2012 at 10:04:13PM -0300, Henrique de Moraes Holschuh wrote:
> > On Tue, 12 Jun 2012, Borislav Petkov wrote:
> > > I'd guess this is still there to support mixed ucode revisions for some
> > 
> > It is still there because of the stable ABI rules.  As far as I can tell,
> > it was a crap interface when it got in, and it still is a crap interface
> > now because there simply isn't any sane usercase that requires it, it is
> > dangerous as implemented right now (at least in the Intel case), and even
> > if we fixed the kernel to do the right thing, userspace would not be able
> > to know that and would still need to request 1 microcode refresh per core.
> 
> Well, I'm disabling it on AMD.
> 
> We could make it iterate over _all_ cores and do the update on each one
> of them even though the user does a sysfs write only for a single core..

Yes, please.  I suggest we use core 0 for that.  Using my Debian
maintainer hat, I'd rather you got rid of the sysfs entries for every
other core while at it, as it will make our life a lot simpler,
distro-side.

This is still not the proper fix, which would be to add a new sysfs node
to access the proper update-every-core functionality, but it is a damn
good start in the right direction and required to make it safe without
ripping out the old ABI entirely without a deprecation period.

Since Intel processors don't want the per-core behaviour either, you
could fix it in the microcode core itself...

> > Perhaps we could make it work only for CPU 0 and return EBUSY or whatever
> > for all others (or just don't publish the sysfs attribute for the others),
> > and change the CPU0 refresh firmware request into a refresh all cores call.
> 
> That could also work, it sounds like a sane thing to do having in mind
> the current sysfs layout. I will cook up something soonish.
> 
> > We could then add a new sysfs attribute to cleanly do the
> > update-all-cores request.
> 
> That's what Fenghua is doing.

Ok.  Please CC me in the patches, if the new ABI arrives in time, I'll
even be able to get it supported on the next Debian stable (and push to
get this stuff backported to the kernel 3.2 which we will ship, I
consider this an important bug-fix to a pontentially very serious issue.
We have *zero* chance of finding out what's wrong if an users' system
start getting subtly crazy because it is running with skewed microcode
among cores.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
