Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758248Ab0DHAym (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 20:54:42 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:28343 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758205Ab0DHAyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 20:54:38 -0400
Date: Wed, 7 Apr 2010 17:52:28 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Yury Polyanskiy <ypolyans@princeton.edu>
Cc: john stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, Jan Glauber <jan.glauber@de.ibm.com>
Subject: Re: [PATCH] hangcheck-timer is broken on x86
Message-ID: <20100408005226.GD4573@mail.oracle.com>
Mail-Followup-To: Yury Polyanskiy <ypolyans@princeton.edu>,
	john stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@osdl.org>, Jan Glauber <jan.glauber@de.ibm.com>
References: <20100323233611.6dcbe4f4@penta.localdomain>
 <20100326214648.GF9984@mail.oracle.com>
 <1269824436.1880.2.camel@work-vm>
 <20100329101106.3678a312@penta.localdomain>
 <1269881007.1857.18.camel@work-vm>
 <20100329130418.2b5c068c@penta.localdomain>
 <1269888291.3968.5.camel@localhost.localdomain>
 <ea182b21003291408t5a4fe8a8l47c0041df043a3a9@mail.gmail.com>
 <1269899024.3968.27.camel@localhost.localdomain>
 <20100329183414.2f9e3966@penta.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100329183414.2f9e3966@penta.localdomain>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4BBD293D.00EE:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 29, 2010 at 06:34:14PM -0400, Yury Polyanskiy wrote:
> On Mon, 29 Mar 2010 14:43:44 -0700
> john stultz <johnstul@us.ibm.com> wrote:
> > On Mon, 2010-03-29 at 17:08 -0400, Yury Polyanskiy wrote:
> > > >> > What I'm saying is that if you're using getrawmonotonic() to detect
> > > >> > hangs, you might miss them, as getrawmonotonic may wrap (and thus stop
> > > >> > continually increasing) if the timer interrupt is delayed. This does not
> > > >> > apply to systems using the TSC clocksource, but does apply to systems
> > > >> > using the acpi_pm.
> > And something else I thought of, while the TSC won't wrap, the
> > multiplication done to convert to nanoseconds will overflow when you hit
> > a large enough cycle delta. So even TSC systems are not guaranteed to
> > have timekeeping (and thus getrawmonotonic) work over infinite time
> > without accumulation.

	Ugh.

> Agreed (large clock->shift, right?), but for hangcheck-timer this
> would hardly be a problem, since such a large overflow very unlikely to
> land inside allowed interval around the pre-planned timer fire instant.

	But if you go beyond that interval...

> > You might also have some trouble with small intervals. Since things like
> > tickless systems or other advanced power-savings systems might try to
> > collate or push timers together to save battery. So ticks may be delayed
> > a small amount (timers are only guaranteed to fire AFTER the time
> > specified, there really is no promised bound on how late they may be).
> > 
> > Additionally, on -rt systems, you might have higher priority FIFO tasks
> > blocking the hangcheck timer from executing for a smallish amount of
> > time.
> 
> Yes, these are the events I want to see logged. Essentially I use
> hangcheck timer to check stability of kernel's heartbeat.

	Which is neat, but not the original reason for hangcheck.

> > Something to also consider might also be to look at the softlockup
> > watchdog, which is fairly similar but somewhat more deeply integrated
> > into the kernel. Maybe some of this could be merged?
> 
> Yeah, for softlockup detection, I don't understand why one would
> prefer hangcheck-timer to watchdog. I am sure Joel has some reasons
> though. For me read_persistent_clock() is not a solution, and others
> perhaps are indeed would be using softlockup watchdog, which leaves the
> decision to Joel.

	hangcheck originally was designed to kill a box as fast as
possible.  It comes out of the cluster environment.  Imagine you have
two machines, node1 and node2, working against a shared data store.
They coordinate their access via a lock manager.
	Then node2 goes out to lunch.  Maybe qla2xxx decides to
udelay() while waiting for an FC device.  Something like that.  After a
time period, node1 decides that node2 must have crashed.  It recovers
any intermediate state, then proceeds as if node2 is gone.
	Now the udelay() finally finishes and node2 starts working
again.  node2 does not know that node1 has continued without it.  It
will write old data to the shared storage, corrupting it.
	hangcheck-timer reduces this exposure significantly, because the
timer interrupt will fire reliably and quickly.  hangcheck-timer - if
using the right clock source - will notice the time discrepancy and
immediately trigger the reset.  Note that the reset is the only valid
solution here.  We can't wait for node2 to try to figure anything out;
old data might be already queued in the I/O layer.
	This is why hangcheck-timer must rely on wallclock time.
softdog was originally tried, but after a true hang (udelay(), PCI,
something with timer interrupts off) the system clock doesn't actually
notice the time change.  So the system might have been hung for 30
seconds, but the system clock thinks it has only been gone for 10.
Softdog won't fire, but hangcheck-timer will.  This is also why
suspend/resume has to be treated as a hang.

Joel

-- 

"The lawgiver, of all beings, most owes the law allegiance.  He of all
 men should behave as though the law compelled him.  But it is the
 universal weakness of mankind that what we are given to administer we
 presently imagine we own."
        - H.G. Wells

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
