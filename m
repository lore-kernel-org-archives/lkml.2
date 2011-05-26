Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932831Ab1EZQVs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 12:21:48 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:35706 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756464Ab1EZQVr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 12:21:47 -0400
Date: Thu, 26 May 2011 12:21:38 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: "D. Jansen" <d.g.jansen@googlemail.com>
Cc: Oliver Neukum <oneukum@suse.de>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
        njs@pobox.com, bart@samwel.tk, jens.axboe@oracle.com
Subject: Re: [rfc] Ignore Fsync Calls in Laptop_Mode
Message-ID: <20110526162138.GN9520@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	"D. Jansen" <d.g.jansen@googlemail.com>,
	Oliver Neukum <oneukum@suse.de>, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
	njs@pobox.com, bart@samwel.tk, jens.axboe@oracle.com
References: <BANLkTikGxbcMBD=3W_9_mpZBoVDc8HrX8A@mail.gmail.com>
 <201105231012.06928.oneukum@suse.de>
 <20110525000003.GJ32466@dastard>
 <201105250850.12179.oneukum@suse.de>
 <BANLkTincvGV735PKb60Kg0dLX6a1CZ-iNA@mail.gmail.com>
 <410B37BE-E380-40D0-82AA-48B56F389E16@mit.edu>
 <BANLkTimNjt4=9v33Z9Nr12xa6GmyJ-Ue5A@mail.gmail.com>
 <20110526133155.GH9520@thunk.org>
 <BANLkTinTzNN2P45tgZAQ9FsL43CqyAJR3Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTinTzNN2P45tgZAQ9FsL43CqyAJR3Q@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 26, 2011 at 06:05:43PM +0200, D. Jansen wrote:
> Problem: any fsync call by any application spins up the hard disk any
> time even in laptop_mode

What you call a problem, I call a feature.  If an application doesn't
participate in the write aggregation protocol, the worst that happens
is that you waste battery power.  This I consider as a lesser evil
than data loss.

Similarly, if an application really _needs_ to write disk, and it
can't contact the coordinating daemon, or the coordinating daemon
doesn't respond in a reasonable amount of time, the application should
feel free to write the data to disk and fsync().  This might waste a
bit of power, but power is cheaper than lost data.

> Because though there is no possibility to destroy data that is on disk
> due to non FIFO flushing of application writes queued in the kernel,
> which seems to be the main kernel level problem, yet new problems come
> up.

I'm not sure what you're talking about here.  Buffered data can always
be reordered in terms of when it is written to disk.  This is
considered good, and normal.  If you want to guarantee that
application writes are pushed out to disk, then either (a) use
O_DIRECT, or (b) use fsync().  Those are your two options.

If we didn't (for example) reorder writes to avoid the hard disk head
from seeking all over the disk, that would actually cause more power
to be consumed!

> Now there is
> 1) special support needed on the application side.

Yep, because this is fundamentally an application-level problem, and
the kernel doesn't have enough semantic information to solve the
database coherency problem.

> 2) need for new out-of-kernel buffers.

Yes.  So?

> 3) need for inter-application write alignment nightmares. This sort of
> structure could cause very uncomfortable bugs that prevent writes from
> happening at all in cases that were not foreseen at all.

Huh?  I think you are talking about order that buffered writes happen,
and there's no problem here.  It's a feature that they can be
reordered.  See above.

> 4) need for resources wasted through yet another daemon.

A daemon doesn't have to take up much space.  If it is linked with all
of the GNOME libraries in the world, yeah, there'll be a problem, but
there's no reason that this daemon should take more than, say a few
tens of kilobytes at most.

> 5) If the _application_, but not the kernel crashes, the data is safe.
> In my experience this is the much more likely case than that the mail
> server on my netbook optimized for battery time receives an email in
> laptop mode, sends the other server "200" and then before the next
> commit window my battery slips out and it's all gone.

Huh?  What's the problem that you're worried about here.

> I think the alternative of ensuring the application writes are
> committed in order would make more sense:
> e..g a _user space library_ disables fsync etc. in laptop_mode if the
> user chooses to do so and kernel support for forced FIFO ordering or
> writes.
> This would fix 1) 2) 3) 4) 5) 6).

And if you do this to a mysql daemon, or to a firefox or chrome
process which uses sqllite, and you crash at a wrong time, the entire
database could be scrambled.  You can't fix this with your solution,
because you want to make fsync() lie to the database code.  And so all
of the extra work (and power) consumed by the database code to try to
make its database writes be safe, will be compromised by making
fsync() unreliable.

> So you've re-thought this "All that is necessary is a kernel patch to
> allow laptop_mode to disable fsync() calls(...)"
> (http://tytso.livejournal.com/2009/03/15/). That post had inspired my
> patch.

I was thinking about things only from a file system perspective.  The
problem is that more and more people are running databases or other
binary files which are updated in place on their laptops, and from a
more holistic perspective, we have to worry about making sure that
application-level databases are coherent in the face of a system
crash.  (For example, you drop your mobile phone, or your tablet, or
your laptop, and the battery slips out.)

						- Ted
