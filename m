Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756054Ab1IQSYA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Sep 2011 14:24:00 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:35968 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752835Ab1IQSX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Sep 2011 14:23:59 -0400
MIME-Version: 1.0
In-Reply-To: <4E74E3D6.8080401@gmx.de>
References: <1316088425.11294.78.camel@lappyti>
	<yunboul7sx7.fsf@aiko.keithp.com>
	<1316100594.23214.65.camel@deskari>
	<yun8vpp7qk7.fsf@aiko.keithp.com>
	<4E72320B.6020000@gmx.de>
	<CADnq5_NnzLtJmSzOgyppnBtv96DRTJ71u6ZSrs56KJ-F5CC-mw@mail.gmail.com>
	<4E724659.5080709@gmx.de>
	<20110915195804.4e6d965b@lxorguk.ukuu.org.uk>
	<CAMP44s1ywhCV+FaudnwjwJUvj5Cf3_oz1M++kjXxRDGQpJ6-0w@mail.gmail.com>
	<CAF6AEGu2-O+2KuCrQPJ6-xejg8TCScrFVZSimgkAV_5Xs-bgkg@mail.gmail.com>
	<4E74C6C3.2000704@gmx.de>
	<CAPM=9twmPVrBPmUuEuTYHSzjDGHtfsmiVX6cozpAFYEaV-NcCg@mail.gmail.com>
	<4E74E3D6.8080401@gmx.de>
Date: Sat, 17 Sep 2011 19:23:57 +0100
Message-ID: <CAPM=9txHu7mzH8p8g=FmHsjvmAT-aMy-xEFj4odXEvnbs-bhMw@mail.gmail.com>
Subject: Re: Proposal for a low-level Linux display framework
From: Dave Airlie <airlied@gmail.com>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Rob Clark <rob@ti.com>, Felipe Contreras <felipe.contreras@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linaro-dev@lists.linaro.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Archit Taneja <archit@ti.com>, linux-fbdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> Is it? Well, okay, I don't want to use any acceleration that can crash my
> machine, where can I select it, preferably as compile time option? I didn't find
> such a thing for Intel or Radeon. Don't say, I should rely on userspace here or
> use fbdev for this.

Just tell the X driver to not use acceleration, and it you won't get
any acceleration used, then you get complete stability. If a driver
writer wants to turn off all accel in the kernel driver, it can, its
not an option we've bothered with for intel or radeon since it really
makes no sense. To put it simply you don't really seem to understand
the driver model around KMS. If no userspace app uses acceleration
then no acceleration features will magically happen. If you want to
write a simple app against the KMS API like plymouth you can now use
the dumb ioctls to create and map a buffer that can be made into a
framebuffer. Also you get hw cursors + modesetting.

> The thing is that the core fbdev API does not expose any acceleration to
> userspace, maybe some drivers do via IOCTLs, but I hope that are only things
> that can be done in a sane way, otherwise I'd consider it a bug. The story is
> different for DRM/KMS, as I understand, as this was primarily for acceleration
> and only recently got modesetting capabilities.

The core drm/kms ioctls don't expose acceleration to userspace either,
again misinformation seems to drive most of your logic. You can't do
generic useful acceleration from the kernel. A lot of modern GPU
hardware doesn't even have bitblt engines.


> It's true that mmap can be PITA, but I don't see any real alternative given that
> you want directly map video memory, especially on low end systems. And there are
> ways around it, you can forbid mapping (though probably most userspace wouldn't
> like it, I guess) or use any other solution like defio.
> If you'd stop exposing the fbdev userspace interface it'd just harden my opinion
> that KMS is a piece of trash and that I should avoid hardware that does not have
> a native framebuffer driver. I think you shouldn't do this, as it's just a
> disadvantage for your end users, but I personally do not really care.

We've fixed this in KMS, we don't pass direct mappings to userspace
that we can't tear down and refault. We only provide objects via
handles. The only place its a problem is where we expose fbdev legacy
emulation, since we have to fix the pages.

Dave.
