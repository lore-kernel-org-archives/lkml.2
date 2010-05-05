Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758472Ab0EEUfi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 16:35:38 -0400
Received: from mga10.intel.com ([192.55.52.92]:51055 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758398Ab0EEUfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 16:35:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,335,1270450800"; 
   d="scan'208";a="795779583"
Date: Wed, 5 May 2010 13:35:30 -0700
From: mark gross <mgross@linux.intel.com>
To: Kevin Hilman <khilman@deeprootsystems.com>
Cc: Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Paul Walmsley <paul@pwsan.com>,
       magnus.damm@gmail.com, Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>
Subject: Re: [PATCH 0/8] Suspend block api (version 6)
Message-ID: <20100505203530.GD27927@linux.intel.com>
Reply-To: mgross@linux.intel.com
References: <1272667021-21312-1-git-send-email-arve@android.com>
 <87wrvl5479.fsf@deeprootsystems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87wrvl5479.fsf@deeprootsystems.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 03, 2010 at 09:40:26AM -0700, Kevin Hilman wrote:
> Arve Hjønnevåg <arve@android.com> writes:
> 
> > This patch series adds a suspend-block api that provides the same
> > functionality as the android wakelock api. This version fixes a race
> > in suspend blocking work, has some documentation changes and
> > opportunistic suspend now uses the same workqueue as runtime pm.
> 
> Earlier this month, several folks intersted in embedded PM had a BoF
> as part of the Embedded Linux Conference[1] in San Francisco.  Many of
> us had concerns about wakelocks/suspend-blockers and I wanted to share
> some of mine here, since I don't know if embedded folks (other than
> Google) were included in discussions during the LF Collab summmit.
> 
> I hope other embedded folks will chime in here as well.  My background
> is in embedded as one of the kernel developers on the TI OMAP SoCs,
> and I work primarily on PM stuff.
> 
> My comments are not about this implementation of suspend blockers in
> particular, but rather on the potential implications of suspend
> blockers in general.  

I also think we need to take a hard look at the process here. 

--mgross

> Sorry for the lengthy mail, it's broken up in to 3 parts:
> 
> - suspend blockers vs. runtime PM
> - how to handle PM aware drivers?
> - what about dumb or untrusted apps
> 
> 
> Suspend blockers vs runtime PM
> ------------------------------
> 
> My primary concern is that suspend blockers attempt to address the
> same problem(s) as runtime PM, but with a very different approach.
> Suspend blockers use one very large hammer whereas runtime PM hands
> out many little hammers.  Since I believe power management to be a
> problem of many little nails, I think many little hammers are better
> suited for the job.
> 
> Currently in the kernel, we have two main forms of PM
> 
> - static PM (system PM, traditional suspend/resume etc.)
> - dynamic PM (runtime PM, CPUfreq, CPUidle, etc.)
> 
> And with the addition of suspend blockers we have something in
> between.  In my simple world, I think of suspend_blockers as static PM
> with a retrofit of some basic dynamic capabilities.  In my view, a
> poor man's dynamic PM.
> 
> The current design of suspend blockers was (presumably) taken due to
> major limitations and/or problems in dynamic PM when it was designed.
> However, since then, some very signifcant improvements in dynamic PM
> have come along, particularily in the form of runtime PM.  What I
> still feel is missing from this discussion are details about why the
> issues addressed by suspend blockers cannot be solved with runtime PM.
> 
> It seems to me the keypad/screen example given in the doc can very
> easily be solved with runtime PM.  The goal of that example is that
> the keypad not turn on the screen unless a specific key is pressed.
> That is rather easy to accomplish using runtime PM:
>  
> 1. system is idle, all devices/drivers runtime suspended
>    (display and keypad drivers are both runtime suspended)
> -  keypress triggers wakeup ->runtime_resume() of keypad (screen is
>    still runtime suspended)
> -  key press trickles up to userspace
> -  keypad driver is done, goes idle and is runtime supended
> -  userspace decides whether or not to turn on screen based on key
> -  if not, goto 1, (display is still runtime suspended)
> -  if so, start using display and it will be runtime resumed
> 
> I realize this keypad example was only one example usage of suspend
> blockers, but I suspect the others would be solved similarily using
> runtime PM.
> 
> But anyways, to get back to the main point: 
> 
> I feel the main problems tackled by _kernel_ suspend blockers (as I
> understand them) are the same problems already addressed by runtime
> PM.  First and formost, both have the same guiding principle:
> 
>   Rule #1: Always try for lowest power state, unless X
> 
> For runtime PM, X = "activity"
> For suspend blockers, X = a held suspend_blocker
> 
> In addition, both have the same secondary goals:
> 
> - keep device PM independent of other devices (e.g. don't wake up
>   screen just because keypad was pressed)
> 
> - wakeups/events can be handled in a device specific way, without
>   affecting other devices or rest of the system, unless desired
> 
> So, the goals are the same, but the approaches are different.  Runtime
> PM makes each of the drivers and subsystems do the work, where suspend
> blockers just forces the issue from on high.  IMHO, the more flexible
> and generic approach of runtime PM is more suited to a general purpose
> kernel than the one-big-hammer approach currently taken by suspend
> blockers.
> 
> 
> What about PM aware drivers?
> ----------------------------
> 
> All of this brings up a second major concern regarding how to write PM
> aware drivers.
> 
> At least from the kernel perspective, both suspend blockers and
> runtime PM have the same goal.  Given that, which framework should the
> driver writer target?  Both?  Seems like duplicate effort.  Using
> suspend blockers assumes the system is in opportunitstic suspend mode
> and (at least in the keypad example given) assumes a suspend-blocker
> aware userspace (Android.) Without both, targeted power savings will
> not be acheived.
> 
> To me, runtime PM is a generic and flexible approach that can be used
> with any userspace.  Driver writers should not have to care whether
> the system is in "opportunistic" mode or about whether userspace is
> suspend blocker capable.  They should only have to think about when
> the device is (or should be) idle.
> 
> >From my experience with OMAP, we *really* do not want to care about
> what userspace is or isn't capable of, or what suspend-mode the kernel
> is in.  Among other things, the OMAP linux kernel is used in the Nokia
> N900 (Maemo), the Motorola Droid (Android) and the Palm Pre (webOS).
> Comments on the future of each SW stack aside, we really want to run
> the same kernel and drivers across all of those platforms as well as
> whatever comes next.
> 
> 
> What about dumb or untrusted apps?
> ---------------------------------------
> 
> In my view, the truly significant difference between suspend blockers
> and runtime PM is what happens to userspace.  So far, to me the only
> compelling argument for suspend blockers is the goal of forcibly
> shutting down userspace and thus forcing the system into idle
> (although drivers could still reject a suspend request.)
> 
> Again, since suspend blockers were designed, there have been major
> efforts to track and fix userspace as well as underlying timer issues
> (deferrable timers, coalescing, timer slack ...) that led to
> unnecessary wakeups from userspace.  Wouldn't it be better to spend
> our collective efforts in continuing in that direction instead of just
> hiding the underlying problems by forcing suspend?  Fixing the root
> causes will be better for everyone, not just those using Android.
> 
> And if untrusted userspace apps remain as the major problem, maybe we
> should aim for a solution directly targetting that problem.  I'm just
> shooting from the hip now, but maybe containing (cgroups?) untrusted
> processes together into a set that could be frozen/idled so that runtime PM
> would be more effective would be a workable solution?
> 
> Anyways, that's enough rambling for now.  I hope that sheds some light
> on the concerns I have with suspend blockers.
> 
> Kevin
> 
> [1] http://embeddedlinuxconference.com/elc_2010/index.html
