Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932507Ab0JHRPn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 13:15:43 -0400
Received: from adelie.canonical.com ([91.189.90.139]:33319 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932426Ab0JHRPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 13:15:42 -0400
Subject: Re: [PATCH 0/3] Input: synaptics - multitouch and multifinger
 support
From: Chase Douglas <chase.douglas@canonical.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-input@vger.kernel.org, xorg-devel@lists.x.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Chris Bagwell <chris@cnpbagwell.com>,
        Andy Whitcroft <apw@canonical.com>,
        Henrik Rydberg <rydberg@euromail.se>, linux-kernel@vger.kernel.org,
        Peter Hutterer <peter.hutterer@who-t.net>,
        Duncan McGreggor <duncan.mcgreggor@canonical.com>
In-Reply-To: <s5hfwwg4p4t.wl%tiwai@suse.de>
References: <1286549880-32580-1-git-send-email-chase.douglas@canonical.com>
	 <s5hfwwg4p4t.wl%tiwai@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Oct 2010 13:15:35 -0400
Message-ID: <1286558135.22715.162.camel@mini>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-08 at 18:37 +0200, Takashi Iwai wrote:
> At Fri,  8 Oct 2010 10:57:57 -0400,
> Chase Douglas wrote:
> > 
> > Tobyn Bertram reverse engineered the multitouch protocol for Synaptics devices.
> > I've been able to take his work and produce a series of commits to enable MT
> > and multifinger (MF) support.
> > 
> > Unfortunately, there's a tricky issue with some Synaptics touchpads that have
> > integrated buttons. For example, the left and right buttons on the touchpad of
> > my Dell Mini 1012 consist of the lower ~20% of the touchpad surface. The
> > touchpad physically clicks under these areas.
> > 
> > The X synaptics input module now has a parameter to disable touches occuring
> > over the button area, but this solution still doesn't work perfectly. If you
> > click a button and drag with another finger near the clicking finger, the
> > touchpad gets confused.
> > 
> > Now that we have full MT support, we can try to handle this scenario better.
> > What I've found to work best is to make touches vanish if they occur over the
> > button area of the trackpad while any button is held. This works in conjunction
> > with the X synaptics driver to disable single touch control over the button
> > area. With full MT support, the touchpad doesn't seem to get confused when a
> > click and drag occurs with two fingers close to each other, and it enables MT
> > gestures and MF support across the entire trackpad when no buttons are held.
> > 
> > The first question is whether this seems appropriate to others, or if some
> > other method would work better. Secondarily, should the solution occur in the
> > kernel, like I have in the third patch of this series, or should it occur in
> > the X input module? Although we don't have this information today, we may be
> > able to query the touchpad in the future to know the area of the integrated
> > buttons. If that were possible, would the recommended location for the hack
> > change?
> 
> Great!  Finally someone found it out!
> I found this and made a series of patches in 4 months ago.  Since
> then, Novell legal prohibited me to send the patches to the upstream
> due to "possible patent infringing".  Now you cracked out.  Yay.
> 
> FWIW, my corresponding patch is below.  It really looks similar in the
> end ;)  I added a kconfig just to be safer.
> 
> Regarding the "clickpad" support: in my case, I implemented almost
> everything about it in xorg driver.  I'm going to submit xorg
> patches.

So I'm confused. I was working off of source code posted to:

https://bugs.launchpad.net/utouch/+bug/633225

I was under the impression that someone else had reverse engineered the
protocol and written patches. But the code is exactly the same as what
you've posted here. If you're the originator of the work, and my patch
is accepted, I think we'll need your SOB on it. Of course, if your patch
is accepted then the point is moot :).

My patch essentially is a rework of yours, incorporating changes that
allow for the driver to work in single touch and multitouch mode
simultaneously. As is done in other MT drivers, one touch is picked to
act as the single touch emulation.

However, as I sit here using the touchpad and thinking some more, I'm
not sure how to best handle single touch emulation for synaptics. Single
touch emulation only really works when touches are tracked. The touches
from the synaptics driver are swapped whenever one touch moves and the
other stays stationary. I think I'm noticing some issues with the
following sequence of events:

1. Two touches begin, triggering a DOUBLETAP key event
2. X synaptics treats DOUBLETAP as scroll events
3. One touch moves up, it's sent as ABS_{X,Y}, scroll performed
4. The touch in motion stops
5. Other touch moves up, it's now sent as ABS_{X,Y}
6. X synaptics scroll behaves poorly because this new touch's X,Y are in
a different place from the first touch's X,Y. Scrolling seems to snap
back to original location

Certainly it's not hard to perform touch tracking when only two touches
are active. However, Henrik, as the MT input guru, has resisted doing in
kernel tracking, at least in a hackish, per-driver manner. It's why he
wrote mtdev in user space, for example. However, unless mtdev is
extended to support single touch emulation, we're kind of stuck without
in kernel tracking.

-- Chase

