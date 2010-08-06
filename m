Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933918Ab0HFHQO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 03:16:14 -0400
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:41513 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933221Ab0HFHQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 03:16:11 -0400
Date: Fri, 6 Aug 2010 10:11:00 +0300
From: Alexander Shishkin <virtuoso@slind.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg KH <gregkh@suse.de>, john stultz <johnstul@us.ibm.com>,
        lkml@vger.kernel.org, "Kirill A. Shutemov" <kirill@shutemov.name>,
        Thomas Gleixner <tglx@linutronix.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jon Hunter <jon-hunter@ti.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Avi Kivity <avi@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, John Kacur <jkacur@redhat.com>,
        linux-kernel@vger.kernel.org, Alexander Shishkin <virtuoso@slind.org>
Subject: Re: [PATCH] [RFC] notify userspace about time changes
Message-ID: <20100806071100.GF28519@shisha.kicks-ass.net>
Mail-Followup-To: Kay Sievers <kay.sievers@vrfy.org>,
	Greg KH <gregkh@suse.de>, john stultz <johnstul@us.ibm.com>,
	lkml@vger.kernel.org, "Kirill A. Shutemov" <kirill@shutemov.name>,
	Thomas Gleixner <tglx@linutronix.de>,
	Martin Schwidefsky <schwidefsky@de.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jon Hunter <jon-hunter@ti.com>, Ingo Molnar <mingo@elte.hu>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	David Howells <dhowells@redhat.com>, Avi Kivity <avi@redhat.com>,
	"H. Peter Anvin" <hpa@zytor.com>, John Kacur <jkacur@redhat.com>,
	linux-kernel@vger.kernel.org
References: <1280926108-24668-1-git-send-email-virtuoso@slind.org>
 <1280937526.28884.21.camel@work-vm>
 <AANLkTin_5RVQo8qbJp=naN6WHdA39JM81Y+003E0SLOq@mail.gmail.com>
 <1281042665.3405.15.camel@localhost.localdomain>
 <20100805213851.GA13868@suse.de>
 <AANLkTimYmtXZe1Ue-z2D_5512RXz3xUSRWPiUUUY6rrz@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimYmtXZe1Ue-z2D_5512RXz3xUSRWPiUUUY6rrz@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 06, 2010 at 12:22:27 +0200, Kay Sievers wrote:
> On Thu, Aug 5, 2010 at 23:38, Greg KH <gregkh@suse.de> wrote:
> > On Thu, Aug 05, 2010 at 02:11:05PM -0700, john stultz wrote:
> >> On Thu, 2010-08-05 at 15:33 +0300, Alexander Shishkin wrote:
> >> > On 4 August 2010 18:58, john stultz <johnstul@us.ibm.com> wrote:
> >> > > Is there a actual use case that you need this for? šI don't really have
> >> > > an issue with the code I just really want to make sure the feature would
> >> > > be useful enough to justify the API and code maintenance going forward.
> >> >
> >> > Yes. What we have here is an application which takes care of different means
> >> > of time synchronization (trusted time servers, different GSM operators, etc)
> >> > and also different kinds of time-based events/notifications (like "dentist
> >> > appointment next thursday"). When it encounters a time change that is
> >> > made by some other application, it basically wants to disable automatic
> >> > time adjustment and trigger the events/notifications which are due at this
> >> > (new) time.
> >>
> >> Ok. Something specific is always more helpful then theoretical uses.
> >>
> >> I think the filtering is still a bit controversial, so you might want to
> >> respin it without that. But otherwise I'm ok with it as long as no one
> >> else objects to any of the minor details of the interface
> >>
> >> GregKH: Does /sys/kernel/time_notify seem ok by you?
> >
> > Um, it depends, what is that file going to do? šI don't see a
> > Documentation/ABI/ entry here that describes it fully :)
> 
> I think that's really awkward interface, to pass file descriptor
> numbers around and write them to magic sysfs files.

Unfortunately, the magic file descriptor is the only viable option for us
(see the usecase I described earlier), for a simple reason that it gives
you the *number of times* the system time has changed so that the user
can see when someone else is changing the time, for example.

Plus, using the magic sysfs file you can specify what kind of events you
want to subscribe to, eventually. Like "everything but my changes", "only
my changes", "everything", etc. It can be extendable.

> I would very much prefer a file that contains the current time, and
> wakes up possible users with a POLL_ERR on changes caused by some
> other process. That works very well for things like /proc/mounts, is
> easy to get, and does not need a full page of weird instructions to
> get stuff done. :)

So you get a POLLERR because there was a time change that you expected
and then someone who wants his time change to go unnoticed changes it
again before you started polling again.

Full page of weird instructions you are referring to is as follows (sans
error checking):

     efd = eventfd(0, 0);
     fd = open("/sys/kernel/time_notify", O_WRONLY);
     fdprintf(fd, "%d", efd);
     close(fd);

     fds[0].fd = efd;
     fds[0].events = POLLIN;
     while (poll(fds, 1, -1) > 0) {
     	   uint64_t n;

	   read(efd, &n, 8);
	   printf("system time has been modified %d time(s)\n", n);
     }

Regards,
--
Alex
