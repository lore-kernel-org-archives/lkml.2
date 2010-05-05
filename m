Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933914Ab0EEAVo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 20:21:44 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44053 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932188Ab0EEAVm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 20:21:42 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH 0/8] Suspend block api (version 6)
Date: Wed, 5 May 2010 02:22:30 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc6-rjw; KDE/4.3.5; x86_64; ; )
Cc: Kevin Hilman <khilman@deeprootsystems.com>,
       Brian Swetland <swetland@google.com>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Paul Walmsley <paul@pwsan.com>,
       magnus.damm@gmail.com, mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>
References: <1272667021-21312-1-git-send-email-arve@android.com> <201005042223.41370.rjw@sisk.pl> <20100504235644.GA5231@opensource.wolfsonmicro.com>
In-Reply-To: <20100504235644.GA5231@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005050222.31038.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 05 May 2010, Mark Brown wrote:
> On Tue, May 04, 2010 at 10:23:41PM +0200, Rafael J. Wysocki wrote:
> > On Tuesday 04 May 2010, Kevin Hilman wrote:
> > > Mark Brown <broonie@opensource.wolfsonmicro.com> writes:
> 
> > Guys, please.
> 
> > The opportunistic suspend feature is _not_ to replace runtime PM by any means!
> 
> Certainly in my case and I think Kevin's I agree with the need for the
> bodge at the minute if we can get a clearer idea of how it's supposed to
> work.
> 
> > when to put devices into low power states and save energy this way.  Still,
> > even if all subsystems do that 100% efficiently, there may be more savings
> > possible by putting the entire system into a sleep state (like on ACPI-based
> > PCs) and we can reach there by runtime PM alone.
> 
> Right, this is likely to be a win for PCs - for embedded systems we
> rarely have other software to interoperate with so if you can make the
> hardware do it then it's unlikely there would be any fundamental issue
> with Linux doing it at runtime.

Evidently, the Android developers had a problem with that.  Of course, you can
argue that they didn't consider using runtime PM for this purpose, but the real
question is how much time it would take to achieve the same level of energy
saving using runtime PM without opportunistic suspend.

> > > > I'd be a lot more comfortable with this if it came with a mechanism for
> > > > communicating the intended effect of a suspend on a per-device level so
> > > > that the drivers have a clear way of figuring out what to do when the
> > > > system suspends.  If there isn't one we can add subsystem or driver
> > > > specific hooks, of course, but it'd be better to address this at the
> > > > system level.
> 
> > > I agree.
> 
> > I'm not sure.  Why _exactly_ would you need that?
> 
> The use case that causes serious issues with this at the minute in the
> domains I work is this:
> 
> On a mobile phone when the system is in a voice call the data flow for
> the call is entirely handled outside the CPU (normally referred to as
> Applications Processor or AP here) by the baseband and audio CODEC,
> which are either integrated or directly connected by analogue or digital
> audio links on the board.  If the user has the phone to their ear and is
> talking away with the screen blanked then the AP is just waiting for
> input, will appear idle and so trigger an opportunistic suspend.  If the
> audio CODEC is managed by Linux (as is standard) then running through
> the suspend process will as things stand cause the audio subsystem to be
> suspended.  Since in the normal course of affairs suspend means power
> down that's what will happen, but this is clearly highly undesirable in
> this situation.

In that case someone (either a driver or, most likely, user space) will need to
keep a suspend blocker active.

> Now, the solution here if we're going to use opportunistic suspend like
> this is to provide some method for the audio subsystem to figure out
> that the system doesn't actually want it to suspend when it gets told do
> do so.  Like I say ideally we'd provide some standard interface in the
> PM subsystem for userspace to communicate this to subsystems and drivers
> so that we've got a joined up story when people run into issues in cases
> like this, though obviously if this goes in then we'll have to put in
> something subsystem or driver specific for affected areas.

My understanding is that on Android suspend blockers are used for this
purpose.

> I know what I'd implement generically for audio, but I've held back since
> the option is fairly messy when not used in conjunction with a deliberate
> choice to use opportunistic suspend and I was expecting a standard mechanism
> to slot into to provide control for userspace.
> 
> In other words, the issue is that we run into situations where we need
> an element of suspend control to go along with the opportunistic suspend
> in order to allow some elements to be kept running - since suspend
> blocking is taken suspend suppression seems like a reasonable term.

Suspend really is a sledgehammer thing.  Either you suspend the whole system
or you don't suspend at all.  You can prevent opportunistic suspend from
happening using suspend blockers (that's what they are for), but that's pretty
much everything you can do about it.  If you want power savings while some
parts of the system are active, use runtime PM for that.

What I'd use opportunistic suspend for is not the saving of energy when there's
a call in progress, because in that case some parts of the system need to be
active, but to save energy when the device is completely idle, ie. the user
interface is not used, music is not played "in the background" etc. (my phone
is in such a state 90% of the time at least).

Rafael
