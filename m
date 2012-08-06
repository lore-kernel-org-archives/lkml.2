Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756852Ab2HFS0U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 14:26:20 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47524 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754788Ab2HFS0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 14:26:19 -0400
Date: Mon, 6 Aug 2012 11:25:30 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Daniel Vetter <daniel.vetter@ffwll.ch>
cc: Hugh Dickins <hughd@google.com>, Takashi Iwai <tiwai@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Giacomo Comes <comes@naic.edu>, linux-kernel@vger.kernel.org
Subject: Re: i915 regression on 3.6-rc1: lid blanks screen
In-Reply-To: <CAKMK7uHZ3F9neO6=ZX2MFLzYmincPeEF23udgZ-0YJ0R+WHEkg@mail.gmail.com>
Message-ID: <alpine.LSU.2.00.1208061122060.1425@eggly.anvils>
References: <alpine.LSU.2.00.1208040936570.1161@eggly.anvils> <s5h3941ke2p.wl%tiwai@suse.de> <alpine.LSU.2.00.1208052113530.1300@eggly.anvils> <CAKMK7uHZ3F9neO6=ZX2MFLzYmincPeEF23udgZ-0YJ0R+WHEkg@mail.gmail.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Aug 2012, Daniel Vetter wrote:
> On Mon, Aug 6, 2012 at 6:21 AM, Hugh Dickins <hughd@google.com> wrote:
> > On Sun, 5 Aug 2012, Takashi Iwai wrote:
> >> At Sat, 4 Aug 2012 10:01:13 -0700 (PDT),
> >> Hugh Dickins wrote:
> >> >
> >> > Sorry to report that with 3.6-rc1, closing and opening the lid on
> >> > this ThinkPad T420s leaves the screen blank, and I have to reboot.
> >> >
> >> > Bisection led to this commit, and reverting indeed gets my screen back:
> >> >
> >> > commit 520c41cf2fa029d1e8b923ac2026f96664f17c4b
> >> > Author: Daniel Vetter <daniel.vetter@ffwll.ch>
> >> > Date:   Wed Jul 11 16:27:52 2012 +0200
> >> >
> >> >     drm/i915/lvds: ditch ->prepare special case
> > ...
> >>
> >> Hm, it's surprising.
> >>
> >> Could you check whether the counter-part intel_lvds_enable() is
> >> called?  If the prepare callback affects, it must be from the mode
> >> setting (drm_crtc_helper_set_mode()).
> >
> > Yes, I put a dump_stack() in both, and intel_lvds_enable() gets called
> > about 0.28 seconds after the intel_lvds_disable() when I lift the lid;
> > but with no video display until I revert that commit.
> 
> Can you please boot with drm.debug=0xe added to your kernel cmdline,
> reproduce the issue (with the two dump_stack calls added) and then
> attach the full dmesg?

Collected, I'll send it to you both privately in a moment.

> 
> Also a few other things to try: What happens if you do a modeset on
> the LVDS while it's still working, e.g.

In the dmesg, I've only gone to runlevel 3, simply working on the
console without startx.  For these xrandrs to work, I did startx
and used the graphics screen.

> 
> xrandr --outpu LVDS1 --auto --crtc 1

Blanks and restores the screen.

> 
> then switch back to crtc 0 with
> 
> xrandr --outpu LVDS1 --auto --crtc 0

Blanks and restores the screen.

> 
> Would also be interesting to know whether this can resurrect your machine.

Indeed it does: the first (--crtc 1) restores the display from
its blank state after opening the lid, the second (--crtc 0) then
behaves as before, briefly blanking then restoring the display.

> 
> Also, how blank is the screen? I.e. is only the backlight off, but you
> can (dimly) see some screen contents, or is it completely off?

Completely off.

Thanks,
Hugh
