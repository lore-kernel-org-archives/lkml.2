Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755686Ab0KXRqw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 12:46:52 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:59769 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753051Ab0KXRqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 12:46:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=na9BBXhvvqdIO3iB2CIN7wKpOOdZ2RoRvT1mQPSkwfDhz1aC0DdywHTyvxaqirGXi0
         cuDOUZ0+ISDbqSP+xLgELUcuMxtMG9hhGjp5YVGNHVaLq9UHmOpo5o4+LvW6tAyYVKXl
         PD2+gSMJ1uVIu85c9PwD2qMHk/8c+Xv7fchuA=
MIME-Version: 1.0
In-Reply-To: <20101124024425.GC27368@core.coreip.homeip.net>
References: <1290126335-12430-1-git-send-email-pingc@wacom.com>
	<20101122075554.GA27300@core.coreip.homeip.net>
	<AANLkTinVYUrD2a+6Z3K0nUze12ZoSc5N0AtR0xB=AjOa@mail.gmail.com>
	<20101123222458.GB20283@core.coreip.homeip.net>
	<AANLkTimht8osNw=L+1TkhYOW5AafQDPBX64Xa1qBbdfP@mail.gmail.com>
	<20101124003832.GA27368@core.coreip.homeip.net>
	<AANLkTinJZyDcORj5DBGNr6Ss8penFyLxw4YDBFaTNLSK@mail.gmail.com>
	<AANLkTi=_swc-_J+hO-UWYh1sbQj=Lr2gFW-rK88fE6Z6@mail.gmail.com>
	<20101124024425.GC27368@core.coreip.homeip.net>
Date: Wed, 24 Nov 2010 09:46:48 -0800
Message-ID: <AANLkTimRGdMvpqFz+ZNDE+Jn4Kpi-ta+wKt760_Y93kA@mail.gmail.com>
Subject: Re: [PATCH] Add BTN_TOOL_BUTTONS to input.h
From: Ping Cheng <pinglinux@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org, jkosina@suse.cz
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 23, 2010 at 6:44 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
>
>> >>> That is exactly what I am trying to convince you. Without being able
>> >>> to tell one button event from the other, even just logically, how can
>> >>> I and other clients remap them?
>> >>
>> >> EVIOCSKEYCODE. You just need to wire wacom driver to support this ioctl.
>>
>> Hold on. I was too concentrated on the buttons then. There are touch
>> rings (reported as ABS_WHEEL) on the tablet. How do we pass the raw
>> ring data to the user land and tell if that ABS_WHEEL is from the ring
>> or from a stylus' wheel? Should we add an ABS_RING then?
>
> May be. Could you please describe exactly what it is?

Take a look at this page: http://www.wacom.com/intuos/. The ring is
the one on the center of the left edge. We also have two strips on
both edges of some tablets:
http://www.wacom.com/cintiq/cintiq-12wx.php. I was not suggesting to
add ABS_RING. Actually, adding ABS_RING is overkilling since we may
add other stuff on the tablet which would require a new ABS_something.
One BTN_TOOL_ groups everything on the tablet, which is much cleaner
than adding more ABS_*.

> What is the default application? Is it really used for scrolling the work area up
> and down?

It can be used for scrolling, zooming, or any application specific
functions. For example, it can be translated into some painting
effect, such shadowing, dimming....

>> Also, if there is no tool on the tablet, which BTN_TOOL_* should we
>> use to report those buttons and strips/rings? They are not PEN, not
>> MOUSE, and not TOUCH. They are in fact an independent tool, like it or
>> not.
>
> No, the buttons on the device are not independent tool but rather fixed
> features that are applicable to all tools and none in particular.

Which tool do you think we can use while no tool is on the tablet? No
matter which one we use, it is confusing. The
strips/ring/wheel/buttons on the tablet do not belong to those tools
at all. They live without any of those tools.

Plus, we are not just talking about buttons here. I started the
argument with buttons and Bamboo since it is the first one that
introduced the BTN_TOOL_FINGER in a different meaning. The need of
BTN_TOOL_BUUTONS is not really for Bamboo. It is for the strips and
rings on the Intuos and Cintiq (see the URL I refered above).

> Considering that proper use of input protocol means that you describe
> _entire_ state of the device how would BTN_TOOL_BUTTONS help you do that
> if button is presses on both touchpad and mouse?

There should be no confusion between pressing a button on a touchpad
or a mouse from a driver's perspective. The driver should be able to
tell user land which button has been pressed/released. It is up to the
user to decide which function they want to assign to the button.

We assign default values to the buttons just to be friendly to most
common apps/users. But, we should not limit user land usability.
Reporting raw strips/ring/wheel vaules gives the room for client to
develop their own functions. But those raw data do not belong to any
of the other tools.

> What about pressed on
> the tablet and released on mouse? Note that there should be no
> ordering dependencies; userspace is expected to accumulate all data and
> maybe cancel out opposites until it gets EV_SYN/SYN_REPORT.
>
> I was thinking that while having pen and thouch as separate devices
> might not be the best idea having mouse and maybe lens as separate
> input devices might make more sense. I'll try to find some time and
> play with my Graphire...

Yeah, Graphire may prove my point. Do you have a Graphire 4? How are
you going to pass the REL_WHEEL event on the tablet while a mouse,
which also has a REL_WHEEL, is on the tablet?

We are complicating a simple problem/request here.

Ping
