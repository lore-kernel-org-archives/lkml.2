Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224Ab1JOOFq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Oct 2011 10:05:46 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41504 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753130Ab1JOOFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Oct 2011 10:05:42 -0400
Date: Sat, 15 Oct 2011 07:05:37 -0700
From: mark gross <markgross@thegnar.org>
To: mark gross <markgross@thegnar.org>
Cc: NeilBrown <neilb@suse.de>, linux-kernel@vger.kernel.org,
        John Stultz <john.stultz@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, arve@android.com,
        Alan Stern <stern@rowland.harvard.edu>, amit.kucheria@linaro.org,
        farrowg@sg.ibm.com, "Dmitry Fink (Palm GBU)" <Dmitry.Fink@palm.com>,
        linux-pm@lists.linux-foundation.org, khilman@ti.com,
        Magnus Damm <damm@opensource.se>, mjg@redhat.com, peterz@infradead.org
Subject: Re: [markgross@thengar.org: [RFC] wake up notifications and suspend
 blocking (aka more wakelock stuff)]
Message-ID: <20111015140537.GA19162@mgross-G62>
Reply-To: markgross@thegnar.org
References: <20111002164456.GC14312@mgross-G62>
 <20111008221439.48f30263@notabene.brown>
 <20111008181638.GA12672@mgross-G62>
 <20111009093100.6c15be50@notabene.brown>
 <20111013034805.GC893@mgross-G62>
 <20111013163526.3863be01@notabene.brown>
 <20111014140116.GC27295@mgross-G62>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111014140116.GC27295@mgross-G62>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 14, 2011 at 07:01:16AM -0700, mark gross wrote:
> On Thu, Oct 13, 2011 at 04:35:26PM +1100, NeilBrown wrote:
> > On Wed, 12 Oct 2011 20:48:05 -0700 mark gross <markgross@thegnar.org> wrote:
> >

snip

> > Can you describe a race?
> > Here is the sequence as I see it.
> > 
> > 0: some user-space process is blocking suspend by telling the suspend daemon
> >    not to suspend.  There are no pending kernel wakeup events.
> >    All processes that handle wakeup events are registered with the daemon.
> > 1: last blocking user-space  process releases its "don't suspend" lock.
> > 2: suspend-daemon decides to initiate suspend.
> > 3: suspend_daemon reads wakeup_count and remembers number.
> > 4: suspend daemon tells all registered clients that suspend is imminent.
> > 5: each client executes 'poll' or 'select' or whatever and discovers that
> >    there are no events.
> > 6: each client tells daemon that it is OK to suspend
> > 7: when all votes are in, suspend daemon checks that no process is requesting
> >    that suspend be blocked.
> > 8: if that succeeds, suspend daemon writes the number back to wakeup_count
> > 9: if that succeeds, suspend daemon daemon writes 'mem' to 'state'.
> > 10: goto 1
> > 
> > If a wake_event happens after 3 and before 8, the write at 8 will fail.
> > If a wake_event happens after 8, and before 9, the suspend will abort.
> > If a wake_event happens after 9, the suspend will resume
> > If a wake_event happens before 3, one of the processes will get an event
> > notification from select or poll or whatever, and will ask the suspend
> > daemon not to suspend just now and this will be noticed at 7, so 8 and 9
> > will be skipped and we go straight to 10.
> > 
> > No race.
> 
> With the suspend daemon designed as above I see no race either.  I was
> thinking of a more trivial suspend daemon design and trying to fix it up
> in the kernel.
>

After responding to this yesterday I still feel I'm missing something
with respect to wake event acknowledgment.  After a wake source becomes
active how does it know its ok to become deactivate at the driver level?

The race I'm now worried about is say a button press going up through
the event layers.  The event manager process, or X, (registered with the
suspend daemon) is in a race to get the event and the socket based
notification handshake described above.

i.e. how is the key event delivery vrs unblocking of the suspend-daemon
read of wakeup_count in step 3 race dealt with?

Sorry for getting confused and flip flopping on you.  This is pretty
subtle stuff for me.

--mark

