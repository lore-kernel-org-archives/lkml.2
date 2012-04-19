Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755947Ab2DSQk2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 12:40:28 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:43337 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335Ab2DSQk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 12:40:27 -0400
Date: Thu, 19 Apr 2012 18:41:25 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Dave Airlie <airlied@gmail.com>
Cc: Andy Whitcroft <apw@canonical.com>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1] [RFC] DRM locking issues during early open
Message-ID: <20120419164125.GI4256@phenom.ffwll.local>
Mail-Followup-To: Dave Airlie <airlied@gmail.com>,
	Andy Whitcroft <apw@canonical.com>, dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
References: <1334852525-14950-1-git-send-email-apw@canonical.com>
 <CAPM=9tzWO46u5L1jnRvi_zhgOhmzH1df7cQTnP6+0Kh4Znpn7g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPM=9tzWO46u5L1jnRvi_zhgOhmzH1df7cQTnP6+0Kh4Znpn7g@mail.gmail.com>
X-Operating-System: Linux phenom 3.2.0-2-amd64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2012 at 05:30:03PM +0100, Dave Airlie wrote:
> On Thu, Apr 19, 2012 at 5:22 PM, Andy Whitcroft <apw@canonical.com> wrote:
> > We have been carrying a (rather poor) patch for an issue we identified in
> > the DRM driver.  This issue is triggered when a DRM device is initialising
> > and userspace attempts to open it, typically in response to the sysfs
> > device added event.  Basically we allocate the minor numbers making
> > the device available, and then call the drm load callback.  Until this
> > completes the device is really not ready and these early opens typically
> > lead to oopses.
> >
> > We have been using the following patch to avoid this by marking the minors
> > as in error until the load method has completed.  This avoids the early
> > open by simply erroring out the opens with EAGAIN.  Obviously we should
> > be delaying the open until the load method complete.
> >
> > I include the existing patch for completness (it is not really ready for
> > merging) to illustrate the issue.  I think it is logical that the wait
> > should simply be delayed until the load has completed.  I am proposing
> > to include a wait queue associated with the idr cache for the drm minors
> > which we can use to allow open callers to wait_event_interruptible() on.
> > I'll be putting together a prototype shortly and will follow up with it.
> >
> > Thoughts?
> 
> Couldn't we just delay registering things until the driver is ready to
> accept an open?

It's somewhere on my eternal&epic todo list.

> Granted the midlayer of drm doesn't make that easy,

... after fixing this one ;-)

> thanks for sending this out, it keeps falling off my radar, I don't
> think I've ever seen this reported on RHEL/Fedora, which makes me
> wonder what we are doing that makes us lucky.

I think it's just a matter of races, if you load the drm module early
enough (like fedora does already in the initrd) and ensure that nothing
pokes drm devices for a few seconds, you'll be fine. Iirc ubuntus powerd
stuff is really got at brining everything down. Also, not loading the
module with udev, but loading it with X resulted in nice fireworks last
time I've tried that (radeon ums was trying to set up the card while the
kms code was doing the same, hilarity ensued).
-Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
