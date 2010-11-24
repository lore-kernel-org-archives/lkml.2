Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751354Ab0KXCof (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 21:44:35 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:43723 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083Ab0KXCoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 21:44:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Nt8J/fAK9sr6omHwjXAnGhHLdOo+OvSX+27S0rCpWPGLyESaAGYneIy5Swoz0/ProD
         I1uTRrDXYS2Iw7Lj4X+45SXajU0yvQrZN+zjKNfGkwTKfAQi5m6HU8l8bVSb3eoGl72R
         6bFa8KgQOC69mrwbsV+UIKGIRda0tV/GWxL/E=
Date: Tue, 23 Nov 2010 18:44:25 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Ping Cheng <pinglinux@gmail.com>
Cc: linux-kernel@vger.kernel.org, jkosina@suse.cz
Subject: Re: [PATCH] Add BTN_TOOL_BUTTONS to input.h
Message-ID: <20101124024425.GC27368@core.coreip.homeip.net>
References: <1290126335-12430-1-git-send-email-pingc@wacom.com>
 <20101122075554.GA27300@core.coreip.homeip.net>
 <AANLkTinVYUrD2a+6Z3K0nUze12ZoSc5N0AtR0xB=AjOa@mail.gmail.com>
 <20101123222458.GB20283@core.coreip.homeip.net>
 <AANLkTimht8osNw=L+1TkhYOW5AafQDPBX64Xa1qBbdfP@mail.gmail.com>
 <20101124003832.GA27368@core.coreip.homeip.net>
 <AANLkTinJZyDcORj5DBGNr6Ss8penFyLxw4YDBFaTNLSK@mail.gmail.com>
 <AANLkTi=_swc-_J+hO-UWYh1sbQj=Lr2gFW-rK88fE6Z6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=_swc-_J+hO-UWYh1sbQj=Lr2gFW-rK88fE6Z6@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 23, 2010 at 05:10:50PM -0800, Ping Cheng wrote:
> On Tue, Nov 23, 2010 at 4:51 PM, Ping Cheng <pinglinux@gmail.com> wrote:
> > On Tue, Nov 23, 2010 at 4:38 PM, Dmitry Torokhov
> > <dmitry.torokhov@gmail.com> wrote:
> >> On Tue, Nov 23, 2010 at 04:12:13PM -0800, Ping Cheng wrote:
> >>> On Tue, Nov 23, 2010 at 2:24 PM, Dmitry Torokhov
> >>> <dmitry.torokhov@gmail.com> wrote:
> >>> >
> >>> >> > The BTN_TOOL_* were introduced to indicate to the userspace tool that is
> >>> >> > currently touching the surface of the device. Buttons are expected to be
> >>> >> > always present and can change their state regardless of what tool is
> >>> >> > being used at the moment. I.e. The full hardware state (between
> >>> >> > EV_SYN/SYN_REPORT) could be, for example,
> >>> >> >
> >>> >> > Pen at 10,20, BTN_0, and BTN_2 (ABS_X 10, ABS_Y 20, BTN_TOOL_PEN, BTN_0,
> >>> >> > BTN_2) or
> >>> >> >
> >>> >> > Lens at 20,15 and BTN_1 (ABS_X 20, ABS_Y 15, BTN_TOOL_LENS, BTN_1).
> >>> >> >
> >>> >> > As you can see BTN_* events can accompany either BTN_TOOL_LENS or
> >>> >> > BTN_TOOL_PEN or any other BTN_TOOL_*.
> >>> >>
> >>> >> You are right. The tablet buttons can go with one of those other
> >>> >> BTN_TOOL_s _if_ they do not define the same event types (BTN_s) as the
> >>> >> tablet buttons.
> >>> >>
> >>> >> The new Bamboo MT code sends both BTN_LEFT and BTN_RIGHT events for
> >>> >> Tablet Buttons (refer to line 905 and 908 of wacom_wac.c). However,
> >>> >> BTN_LEFT and BTN_RIGHT are also sent by BTN_TOOL_MOUSE/LENS tool
> >>> >> (refer to wacom_wac.c line 622 to 665).
> >>> >>
> >>> >> If we remove BTN_TOOL_FINGER without a BTN_TOOL-something to replace
> >>> >> it, the two LEFT and RIGHT buttons will have a hard time to tell the
> >>> >> user land if they are from the MOUSE/LENS or the Tablet Buttons. The
> >>> >> worst case could be the LEFT/RIGHT sent later overwrites the earlier
> >>> >> ones.
> >>> >>
> >>> >> We could do some guesswork in the user land to figure out which
> >>> >> LEFT/RIGHT belongs to which BTN_TOOL_ if the above scenario does not
> >>> >> happen. But, it would be much cheaper and more reliable if we can tell
> >>> >> the user land where those LEFT and RIGHT come from. This is the whole
> >>> >> purpose of the kernel driver, isn't it?
> >>> >
> >>> > What would userspace want to figure what physical button was pressed?
> >>> > Input events convey _actions_, i.e. BTN_LEFT means that user pressed
> >>> > primary button on the device. It does not matter if it was pressed on
> >>> > tablet or the mouse/lens; the response should be the same.
> >>>
> >>> You're right, if the user wants a LEFT click. In a lot of cases, they
> >>> want to translate it into something else. LEFT is only a default value
> >>> that we give them if they do nothing.
> >>>
> >>> > If you expect different response, depending on which physical button is
> >>> > pressed, then they should emit different BTN_* events. If you are
> >>> > concerned that some users might want to have the same actions while
> >>> > others want different actions - then please implement key remapping in
> >>> > the driver.
> >>>
> >>> That is exactly what I am trying to convince you. Without being able
> >>> to tell one button event from the other, even just logically, how can
> >>> I and other clients remap them?
> >>
> >> EVIOCSKEYCODE. You just need to wire wacom driver to support this ioctl.
> 
> Hold on. I was too concentrated on the buttons then. There are touch
> rings (reported as ABS_WHEEL) on the tablet. How do we pass the raw
> ring data to the user land and tell if that ABS_WHEEL is from the ring
> or from a stylus' wheel? Should we add an ABS_RING then?

May be. Could you please describe exactly what it is? What is the
default application? Is it really used for scrolling the work area up
and down?

> 
> Also, if there is no tool on the tablet, which BTN_TOOL_* should we
> use to report those buttons and strips/rings? They are not PEN, not
> MOUSE, and not TOUCH. They are in fact an independent tool, like it or
> not.

No, the buttons on the device are not independent tool but rather fixed
features that are applicable to all tools and none in particular.

Considering that proper use of input protocol means that you describe
_entire_ state of the device how would BTN_TOOL_BUTTONS help you do that
if button is presses on both touchpad and mouse? What about pressed on
the tablet and released on mouse? Note that there should be no
ordering dependencies; userspace is expected to accumulate all data and
maybe cancel out opposites until it gets EV_SYN/SYN_REPORT.

I was thinking that while having pen and thouch as separate devices
might not be the best idea having mouse and maybe lens as separate
input devices might make more sense. I'll try to find some time and
play with my Graphire...

-- 
Dmitry
