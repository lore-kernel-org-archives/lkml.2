Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901Ab0KXUQR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 15:16:17 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:48820 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691Ab0KXUQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 15:16:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=RzEgg/TRmyswf79HrckP1OMi4YcQ5PlcWMGrMHT21oveQoeWfeucStKDMumuQfZvcG
         1L+xzhe59XUvSU7ygI+7vUZPyU3SKeP/AmQ9nnvupVD6W+QTJ+rw/3ZHOizoMIB617lf
         LvGVEqXtKIfMTAZJAB2q7MjqFk5U+e1szvx+I=
Date: Wed, 24 Nov 2010 12:16:09 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Ping Cheng <pinglinux@gmail.com>
Cc: linux-kernel@vger.kernel.org, jkosina@suse.cz
Subject: Re: [PATCH] Add BTN_TOOL_BUTTONS to input.h
Message-ID: <20101124201608.GG27368@core.coreip.homeip.net>
References: <1290126335-12430-1-git-send-email-pingc@wacom.com>
 <20101122075554.GA27300@core.coreip.homeip.net>
 <AANLkTinVYUrD2a+6Z3K0nUze12ZoSc5N0AtR0xB=AjOa@mail.gmail.com>
 <20101123222458.GB20283@core.coreip.homeip.net>
 <AANLkTimht8osNw=L+1TkhYOW5AafQDPBX64Xa1qBbdfP@mail.gmail.com>
 <20101124003832.GA27368@core.coreip.homeip.net>
 <AANLkTinJZyDcORj5DBGNr6Ss8penFyLxw4YDBFaTNLSK@mail.gmail.com>
 <AANLkTi=_swc-_J+hO-UWYh1sbQj=Lr2gFW-rK88fE6Z6@mail.gmail.com>
 <20101124024425.GC27368@core.coreip.homeip.net>
 <AANLkTimRGdMvpqFz+ZNDE+Jn4Kpi-ta+wKt760_Y93kA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimRGdMvpqFz+ZNDE+Jn4Kpi-ta+wKt760_Y93kA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 24, 2010 at 09:46:48AM -0800, Ping Cheng wrote:
> On Tue, Nov 23, 2010 at 6:44 PM, Dmitry Torokhov
> <dmitry.torokhov@gmail.com> wrote:
> >
> >> >>> That is exactly what I am trying to convince you. Without being able
> >> >>> to tell one button event from the other, even just logically, how can
> >> >>> I and other clients remap them?
> >> >>
> >> >> EVIOCSKEYCODE. You just need to wire wacom driver to support this ioctl.
> >>
> >> Hold on. I was too concentrated on the buttons then. There are touch
> >> rings (reported as ABS_WHEEL) on the tablet. How do we pass the raw
> >> ring data to the user land and tell if that ABS_WHEEL is from the ring
> >> or from a stylus' wheel? Should we add an ABS_RING then?
> >
> > May be. Could you please describe exactly what it is?
> 
> Take a look at this page: http://www.wacom.com/intuos/. The ring is
> the one on the center of the left edge. We also have two strips on
> both edges of some tablets:
> http://www.wacom.com/cintiq/cintiq-12wx.php. I was not suggesting to
> add ABS_RING. Actually, adding ABS_RING is overkilling since we may
> add other stuff on the tablet which would require a new ABS_something.
> One BTN_TOOL_ groups everything on the tablet, which is much cleaner
> than adding more ABS_*.

What if you get 3 sets of rings? 4? 5? And some more buttons? Will we
need BTN_TOOL_BUTTONS_EXTRA? BTN_TOOL_BUTTONS_EVEN_MORE? This direction
leads to a dead end, it is not sustainable.

> 
> > What is the default application? Is it really used for scrolling the work area up
> > and down?
> 
> It can be used for scrolling, zooming, or any application specific
> functions. For example, it can be translated into some painting
> effect, such shadowing, dimming....

Right. However it is nice to know the default application as we use it
to provide default mapping.

> 
> >> Also, if there is no tool on the tablet, which BTN_TOOL_* should we
> >> use to report those buttons and strips/rings? They are not PEN, not
> >> MOUSE, and not TOUCH. They are in fact an independent tool, like it or
> >> not.
> >
> > No, the buttons on the device are not independent tool but rather fixed
> > features that are applicable to all tools and none in particular.
> 
> Which tool do you think we can use while no tool is on the tablet? No
> matter which one we use, it is confusing. The
> strips/ring/wheel/buttons on the tablet do not belong to those tools
> at all. They live without any of those tools.

Exactly. They are not a tool (BTN_TOOL_* in input protocol conveys that
a certain object touches working surface at certain coordinates with
certain pressure - the pressure is optional), and they do not belong to
any tool. So you should not try to associate them with any tools.

> 
> Plus, we are not just talking about buttons here. I started the
> argument with buttons and Bamboo since it is the first one that
> introduced the BTN_TOOL_FINGER in a different meaning. The need of
> BTN_TOOL_BUUTONS is not really for Bamboo. It is for the strips and
> rings on the Intuos and Cintiq (see the URL I refered above).
> 
> > Considering that proper use of input protocol means that you describe
> > _entire_ state of the device how would BTN_TOOL_BUTTONS help you do that
> > if button is presses on both touchpad and mouse?
> 
> There should be no confusion between pressing a button on a touchpad
> or a mouse from a driver's perspective. The driver should be able to
> tell user land which button has been pressed/released. It is up to the
> user to decide which function they want to assign to the button.

I know. I just asked you to provide the example of event stream for the
conditions below using your new BTN_TOOL_BUTTONS given the constraints I
mentioned.

> 
> We assign default values to the buttons just to be friendly to most
> common apps/users. But, we should not limit user land usability.
> Reporting raw strips/ring/wheel vaules gives the room for client to
> develop their own functions. But those raw data do not belong to any
> of the other tools.
> 
> > What about pressed on
> > the tablet and released on mouse? Note that there should be no
> > ordering dependencies; userspace is expected to accumulate all data and
> > maybe cancel out opposites until it gets EV_SYN/SYN_REPORT.
> >
> > I was thinking that while having pen and thouch as separate devices
> > might not be the best idea having mouse and maybe lens as separate
> > input devices might make more sense. I'll try to find some time and
> > play with my Graphire...
> 
> Yeah, Graphire may prove my point. Do you have a Graphire 4? How are
> you going to pass the REL_WHEEL event on the tablet while a mouse,
> which also has a REL_WHEEL, is on the tablet?

No, it is Graphire 3.

> 
> We are complicating a simple problem/request here.

No, we are trying to ram something in that might work for wacom driver
only and only for the short term.

Input protocol is set up so that events of the same type are combined;
there is only one logical BTN_LEFT with its state, only one horizontal
and vertical wheels, only one KEY_A and so forth. If several physical
switches are set up to emit the same event they are by design
indistinguishable from each other. We did relax this for multi-touch
devices where it is natural to have several independent contacts being
present and their number changes over time.

You are trying to devise the scheme to partition device into several
parts to work around this issue. But if you want to have the buttons
truly independent then just partition the device explicitly. Do split it
off into separate button/ring/misc device and it should work just fine
without need for new "tool" type. And it will continue to work if you
add more buttons, sliders, rings and so forth.

The only issue with the above is that we need to support more than 32
event devices. That was on my back burner but if someone were to beat me
to it - that would be even better.

Thanks.

-- 
Dmitry
