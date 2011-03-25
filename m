Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754329Ab1CYQRg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 12:17:36 -0400
Received: from adelie.canonical.com ([91.189.90.139]:34708 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754022Ab1CYQRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 12:17:35 -0400
Date: Fri, 25 Mar 2011 11:17:24 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Corentin Chary <corentin.chary@gmail.com>
Cc: Chris Bagwell <chris@cnpbagwell.com>, Matthew Garrett <mjg@redhat.com>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH 2/2] eeepc-wmi: Add support for T101MT Home/Express Gate
 key
Message-ID: <20110325161724.GC14328@thinkpad-t410>
Mail-Followup-To: Corentin Chary <corentin.chary@gmail.com>,
	Chris Bagwell <chris@cnpbagwell.com>,
	Matthew Garrett <mjg@redhat.com>,
	acpi4asus-user@lists.sourceforge.net,
	platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
References: <20110324195720.GB31713@thinkpad-t410>
 <1300997035-14104-2-git-send-email-seth.forshee@canonical.com>
 <AANLkTimF2UR8BVQW-3YJaGFEz39q8ydESAiMOjmdM1X7@mail.gmail.com>
 <20110325135311.GA14328@thinkpad-t410>
 <AANLkTin3MDYdL6x1Qs8Q9oMMgDMfsoO2GjWMJO_65GAR@mail.gmail.com>
 <AANLkTi=iWeKVww_XPm0PQa09NLtPCo4wvz7ZYkk1ajhQ@mail.gmail.com>
 <AANLkTinr2FJA2H3CJWx-wZ_g-hCZ3DT7PR6QsXqi5Rkw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTinr2FJA2H3CJWx-wZ_g-hCZ3DT7PR6QsXqi5Rkw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 25, 2011 at 03:43:11PM +0000, Corentin Chary wrote:
> > Here is how I envision using these keys.  I wanted to map quick press
> > to GNOME3/KDE4/Unity's Activities menu and map press-and-hold to
> > script that rotates screen.  I like the repeating of rotates but I
> > didn't really want a rotate to also force a pop up of the activities
> > menu.
> 
> Makes sense.
> 
> >>
> >>> And back to the question of KEY_HOME -- that's not really what you want,
> >>> is it? As in "move cursor to start of line"?
> >>
> >> Ho .. right, that's what mean KEY_HOME :/. So no, I don't want that...
> >> What about:
> >> - KEY_CYCLEWINDOWS
> >> - KEY_COMPUTER
> >> - KEY_HOMEPAGE
> >> - KEY_DASHBOARD
> >>
> >> I think KEY_HOMEPAGE is the best choice.
> >
> > I've only had limited time to look more.  So far, I found under udev a
> > toshiba tablet that maps what is probably a rotate button to
> > KEY_DIRECTION so thats one option for it instead of KEY_PROG2.  I
> > couldn't find anybody using that though.
> >
> > I see in /usr/share/X11/symbols/inet:
> >
> >    key <I162>   {      [ XF86RotateWindows     ]       };
> >
> > and in /usr/share/X11/xkb/symbols/evdev:
> >
> > xkb/keycodes/evdev:     <I162> = 162;   // #define KEY_CYCLEWINDOWS        154
> >
> > Looks like KEY_CYCLEWINDOWS is already hooked up to
> > gnome-settings-daemon to auto-rotate screen?
> 
> XF86RotateWindows is probably more "alt-tab" than "rotate screen".

Gnome at least seems to handle it by doing a screen rotation.

> > I ran into total dead end for finding a pre-existing example of home
> > button usage.  I'm really surprised we do not yet have a KEY_LAUNCHER
> > or similar because so many tablet PCs/smartphones/pads do have a
> > button with this specific concept of "bring up your icon based
> > application launcher".
> 
> KEY_LAUNCHER sounds like "Alt-F2" (that means krunner on KDE).
> The advantage over KEY_HOMEPAGE is that it would work even when a
> browser have the focus.
> 
> > - KEY_MENU
> > - KEY_EXIT (smartphones sometime mean this)
> > - KEY_PROG3 (basically all that Windows is doing)
> > - KEY_LAUNCHER (why not be the first to finally create it!)
> >
> > I vote for either KEY_PROG3 or KEY_HOMEPAGE for at least short term.
> 
> So now, I vote (in order):
> - KEY_LAUNCHER
> - KEY_DASHBOARD
> - KEY_PROG3
> 
> With this behavior (I'll use KEY_LAUCHER and KEY_PROG2)
> 
> - On press, do nothing
> - On release, emit KEY_LAUNCHER if KEY_PROG2 wasn't emited
> - On press, emit only one  KEY_PROG2 (I'd like to emit repeated

Do you mean on hold?

> KEY_PROG2, but I understand that it makes things harder for
> userspace).

I have a keyboard that emit repeated press events for hotkeys, so I
think userspace can handle this. It just waits for the release before
doing anything, so as long as it's multiple press events and a single
release I think we're okay.

Since it seems KEY_CYCLEWINDOWS might actually accomplish what a hold is
intended to do, I think I'll proceed with the following slightly amended
version of your plan.

 - On press, do nothing
 - On hold, emit KEY_CYCLEWINDOWS repeatedly
 - On release, emit KEY_LAUNCHER w/ autorelease if KEY_CYCLEWINDOWS
   wasn't released, else emit KEY_CYCLEWINDOWS release

Assuming of course that Dmitry agrees that adding KEY_LAUNCHER makes
sense.

Seth

