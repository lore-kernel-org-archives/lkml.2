Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756081Ab2DSQzX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 12:55:23 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:36073 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753741Ab2DSQzV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 12:55:21 -0400
Date: Thu, 19 Apr 2012 09:55:16 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Dave Airlie <airlied@gmail.com>
Cc: Andy Whitcroft <apw@canonical.com>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org,
        Bryce Harrington <bryce@canonical.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1] [RFC] DRM locking issues during early open
Message-ID: <20120419095516.595649b3@jbarnes-desktop>
In-Reply-To: <CAPM=9txduppN_R9brXm8haattUn=jEOvQUaynN-vgxNerD7qUw@mail.gmail.com>
References: <1334852525-14950-1-git-send-email-apw@canonical.com>
	<CAPM=9tzWO46u5L1jnRvi_zhgOhmzH1df7cQTnP6+0Kh4Znpn7g@mail.gmail.com>
	<20120419164113.GA3467@shadowen.org>
	<CAPM=9twXZyo6qkwunuYARVsZM8EDX4O0Dja6Kgp7ofXH2Gys3Q@mail.gmail.com>
	<CAPM=9txduppN_R9brXm8haattUn=jEOvQUaynN-vgxNerD7qUw@mail.gmail.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Apr 2012 17:52:39 +0100
Dave Airlie <airlied@gmail.com> wrote:

> On Thu, Apr 19, 2012 at 5:47 PM, Dave Airlie <airlied@gmail.com> wrote:
> > On Thu, Apr 19, 2012 at 5:41 PM, Andy Whitcroft <apw@canonical.com> wrote:
> >> On Thu, Apr 19, 2012 at 05:30:03PM +0100, Dave Airlie wrote:
> >>> On Thu, Apr 19, 2012 at 5:22 PM, Andy Whitcroft <apw@canonical.com> wrote:
> >>> > We have been carrying a (rather poor) patch for an issue we identified in
> >>> > the DRM driver.  This issue is triggered when a DRM device is initialising
> >>> > and userspace attempts to open it, typically in response to the sysfs
> >>> > device added event.  Basically we allocate the minor numbers making
> >>> > the device available, and then call the drm load callback.  Until this
> >>> > completes the device is really not ready and these early opens typically
> >>> > lead to oopses.
> >>> >
> >>> > We have been using the following patch to avoid this by marking the minors
> >>> > as in error until the load method has completed.  This avoids the early
> >>> > open by simply erroring out the opens with EAGAIN.  Obviously we should
> >>> > be delaying the open until the load method complete.
> >>> >
> >>> > I include the existing patch for completness (it is not really ready for
> >>> > merging) to illustrate the issue.  I think it is logical that the wait
> >>> > should simply be delayed until the load has completed.  I am proposing
> >>> > to include a wait queue associated with the idr cache for the drm minors
> >>> > which we can use to allow open callers to wait_event_interruptible() on.
> >>> > I'll be putting together a prototype shortly and will follow up with it.
> >>> >
> >>> > Thoughts?
> >>>
> >>> Couldn't we just delay registering things until the driver is ready to
> >>> accept an open?
> >>>
> >>> Granted the midlayer of drm doesn't make that easy,
> >>
> >> It seems that we need the dri minor allocated before we hit the load
> >> function as things are done right now.
> >>
> >>> thanks for sending this out, it keeps falling off my radar, I don't
> >>> think I've ever seen this reported on RHEL/Fedora, which makes me
> >>> wonder what we are doing that makes us lucky.
> >>
> >> We never hit it until we started doing things earlier and quicker.  I first
> >> found it in the prettification of boot so we were keen to get plymouth
> >> running as soon as possible.  That lead to random panics and me finding
> >> this bug.  The window is tiny as far as I know and it tends to be specific
> >> machines and specific package combinations which trigger it reliably.
> >>
> >> I suspect that a proper fix would allow delaying the registration as you
> >> suggest but in the interim a wait would at least avoid the issues we are
> >> seeing.  I will see how awful it looks.
> >
> > Just to confirm its the drm_sysfs_device_add that causes the race we care about.
> >
> > it needs to happen after the driver is happy. Since it calls
> > device_register and that is what triggers udev magic to load the
> > userspace.
> >
> > If you have a userspace app banging on a static device node that might
> > need another set of fun fixes.
> 
> Okay the sysfs add and the idr_replace are the things we need to delay.

Since you can still get at things with a static node, it seems like
locking is the real issue here?  Is there no mutex we can take across
init to block any openers until we're done?

-- 
Jesse Barnes, Intel Open Source Technology Center
