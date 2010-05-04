Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760123Ab0EDX4h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 19:56:37 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38705 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756602Ab0EDX4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 19:56:35 -0400
Date: Wed, 5 May 2010 00:56:44 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Kevin Hilman <khilman@deeprootsystems.com>,
       Brian Swetland <swetland@google.com>,
       Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Paul Walmsley <paul@pwsan.com>,
       magnus.damm@gmail.com, mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>
Subject: Re: [PATCH 0/8] Suspend block api (version 6)
Message-ID: <20100504235644.GA5231@opensource.wolfsonmicro.com>
References: <1272667021-21312-1-git-send-email-arve@android.com>
 <20100504135907.GA3651@opensource.wolfsonmicro.com>
 <87r5lrh780.fsf@deeprootsystems.com>
 <201005042223.41370.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201005042223.41370.rjw@sisk.pl>
X-Cookie: Don't Worry, Be Happy.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 04, 2010 at 10:23:41PM +0200, Rafael J. Wysocki wrote:
> On Tuesday 04 May 2010, Kevin Hilman wrote:
> > Mark Brown <broonie@opensource.wolfsonmicro.com> writes:

> Guys, please.

> The opportunistic suspend feature is _not_ to replace runtime PM by any means!

Certainly in my case and I think Kevin's I agree with the need for the
bodge at the minute if we can get a clearer idea of how it's supposed to
work.

> when to put devices into low power states and save energy this way.  Still,
> even if all subsystems do that 100% efficiently, there may be more savings
> possible by putting the entire system into a sleep state (like on ACPI-based
> PCs) and we can reach there by runtime PM alone.

Right, this is likely to be a win for PCs - for embedded systems we
rarely have other software to interoperate with so if you can make the
hardware do it then it's unlikely there would be any fundamental issue
with Linux doing it at runtime.

> > > I'd be a lot more comfortable with this if it came with a mechanism for
> > > communicating the intended effect of a suspend on a per-device level so
> > > that the drivers have a clear way of figuring out what to do when the
> > > system suspends.  If there isn't one we can add subsystem or driver
> > > specific hooks, of course, but it'd be better to address this at the
> > > system level.

> > I agree.

> I'm not sure.  Why _exactly_ would you need that?

The use case that causes serious issues with this at the minute in the
domains I work is this:

On a mobile phone when the system is in a voice call the data flow for
the call is entirely handled outside the CPU (normally referred to as
Applications Processor or AP here) by the baseband and audio CODEC,
which are either integrated or directly connected by analogue or digital
audio links on the board.  If the user has the phone to their ear and is
talking away with the screen blanked then the AP is just waiting for
input, will appear idle and so trigger an opportunistic suspend.  If the
audio CODEC is managed by Linux (as is standard) then running through
the suspend process will as things stand cause the audio subsystem to be
suspended.  Since in the normal course of affairs suspend means power
down that's what will happen, but this is clearly highly undesirable in
this situation.

Now, the solution here if we're going to use opportunistic suspend like
this is to provide some method for the audio subsystem to figure out
that the system doesn't actually want it to suspend when it gets told do
do so.  Like I say ideally we'd provide some standard interface in the
PM subsystem for userspace to communicate this to subsystems and drivers
so that we've got a joined up story when people run into issues in cases
like this, though obviously if this goes in then we'll have to put in
something subsystem or driver specific for affected areas.  I know what
I'd implement generically for audio, but I've held back since the option
is fairly messy when not used in conjunction with a deliberate choice to
use opportunistic suspend and I was expecting a standard mechanism to
slot into to provide control for userspace.

In other words, the issue is that we run into situations where we need
an element of suspend control to go along with the opportunistic suspend
in order to allow some elements to be kept running - since suspend
blocking is taken suspend suppression seems like a reasonable term.
