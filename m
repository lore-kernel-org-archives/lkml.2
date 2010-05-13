Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752744Ab0EMXhr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 19:37:47 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:34913 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591Ab0EMXhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 19:37:43 -0400
Date: Fri, 14 May 2010 00:36:08 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Greg KH <gregkh@suse.de>, Daniel Walker <dwalker@fifo99.com>,
       Matthew Garrett <mjg@redhat.com>, Brian Swetland <swetland@google.com>,
       Paul Walmsley <paul@pwsan.com>, Arve Hj?nnev?g <arve@android.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       Tony Lindgren <tony@atomide.com>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Alan Stern <stern@rowland.harvard.edu>, magnus.damm@gmail.com,
       "Theodore Ts'o" <tytso@mit.edu>, mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>, Beno?t Cousson <b-cousson@ti.com>,
       linux-omap@vger.kernel.org, Vitaly Wool <vitalywool@gmail.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 6)
Message-ID: <20100513233608.GA1582@sirena.org.uk>
References: <1272667021-21312-1-git-send-email-arve@android.com> <20100513214653.GA21120@suse.de> <20100513222748.GA3240@opensource.wolfsonmicro.com> <201005140046.33508.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201005140046.33508.rjw@sisk.pl>
X-Cookie: Microwaves frizz your heir.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 14, 2010 at 12:46:33AM +0200, Rafael J. Wysocki wrote:
> On Friday 14 May 2010, Mark Brown wrote:

> > Is that really the issue?  The ones I've looked at have mostly suffered
> > from being built on 2.6.29 and needing refreshes for current kernel APIs
> > or from general code quality issues - I don't recall ever looking at one
> > and thinking that the wakelocks were the one issue.

...

> > Chances are that if the driver is useful people will start using it in
> > non-Android systems anyway.

> You're missing the point IMO.  Even if they are only used on Android, there
> still is a problem if they don't go into the mainline, because that leads to
> code divergence that's growing over time and will ultimately create an entire
> ecosystem that's independent of the mainline.

See my first paragraph there.  My point here is that we appear to have
the standard vendor BSP ecosystem problem here rather than a wakelock
problem.

It's fairly common in the embedded space to get a whole bunch of work
done which doesn't make its way into mainline due to a SoC vendor having
produced a BSP for their SoC which is based around a particular kernel
version which never gets updated.  This means users with that SoC can't
boot anything newer until someone does the work of mainlining support
for the system, meaning that development on systems using that SoC gets
stuck on an old kernel which mainline drifts away from.  Users find it
hard to contribute back since they can't run current code easily and
often have to jump through serious hoops to backport drivers from newer
kernels.  If the SoC is successful enough then you do get something of
an ecosystem around the BSP, though eventually that usually results in
the community doing the mainline merge.

> We've been successful in avoiding that for quite some time and I don't think
> we should allow that to happen right now because of the opportunistic suspend
> feature.

This is still a work in progress in the embedded space (where wakelocks
are primarily relevant).  Many of the major vendors are working in the
right direction here, but it's far from universal and it's not something
that it's easy for vendors to change overnight.

> I'm not a big fan of suspend blockers myself, but let's face it, _currently_
> there's no alternative and we need to stop the trend, the sooner the better.

I don't think this is a major part of the trend - like I say, the fact
that people have been working with an old kernel version is generally
a much more substantial issue than the wakelocks in the code I've seen.

> > As people have already observed wakelocks
> > needn't have any practical effect on the running system so if the
> > drivers are broken without wakelocks they'd be broken anyway.  

> You need to prove the reverse, ie. that a driver working correctly with
> wakelocks will also work correctly without them, which is not a given.

If they can be compiled out then the updates really ought to be trivial.
If not I really need to go back and reexamine what's going on here to
make sure I understand what drivers are supposed to do, I have to
confess that I haven't looked too closely at the driver side API yet.

> > It's not particularly pretty but it'd deal with the driver merge
> > side of things.

> Again, I don't see why you hate that feature so much.  What is there to worry
> about?

As I have said previously I'm not actively opposed to merging wakelocks
at this point.  My major concern has been addressed, I now agree with
most of what the PM guys are saying - it's not the nicest thing ever but
it works for now.

The issue was that when I originally noticed the patch series was being
considered for mainline again was that one effect of using it in a
mobile phone with the standard Linux embedded audio subsystem would be
to break use cases such as audio on voice calls, which isn't really
desirable, and that there was no roadmap for how to fix that or any
other subsystems with similar issues.  This didn't seem like it would
have been a good situation given that the major user is expected to be
Android, which is mainly for mobile phones.

Since we seemed to all agree that no other subsystems were affected,
meaning nothing general was required, I've now implemented support in
the subsystem for ignoring suspends for some audio paths (this should
appear In the next merge window).  This should mesh well with wakelocks.
