Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832Ab0L2VS5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 16:18:57 -0500
Received: from oproxy2-pub.bluehost.com ([67.222.39.60]:57898 "HELO
	oproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752795Ab0L2VS4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 16:18:56 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=eGApfWDWC2/nrBcfXOoEvNIgJ0YYvsY4fbsnICc+wz3CI7rrtAAyi8y4ZXxfcfuqC1f+xDlNOotJThMtGXRZYwzTk+2iCxX+dtpBNuI8ae/LpLSnd6BrOr+JrNmQg7wx;
Date: Wed, 29 Dec 2010 13:18:52 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Alex Riesen <raa.lkml@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, Jeff Chua <jeff.chua.linux@gmail.com>
Subject: Re: Linux 2.6.37-rc8 (no fb)
Message-ID: <20101229131852.0792aac0@jbarnes-desktop>
In-Reply-To: <AANLkTikMMpdMr66n-VL9xdNVhmGMaWR74UdF5UB7cdCW@mail.gmail.com>
References: <AANLkTi=-dNeeDjcSoznKtwcaNyw1mMXSqepFY89R2i+2@mail.gmail.com>
	<20101229102127.06c0e505.randy.dunlap@oracle.com>
	<AANLkTims54zDXZYjZiiHfSOwy0W=gOF2jV8yopQxFBny@mail.gmail.com>
	<20101229121601.179983b7@jbarnes-desktop>
	<AANLkTikMMpdMr66n-VL9xdNVhmGMaWR74UdF5UB7cdCW@mail.gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Dec 2010 22:11:09 +0100
Alex Riesen <raa.lkml@gmail.com> wrote:

> On Wed, Dec 29, 2010 at 21:16, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> > On Wed, 29 Dec 2010 11:40:04 -0800
> > Linus Torvalds <torvalds@linux-foundation.org> wrote:
> >> Chris - why did that lvds_ssc_freq thing suddenly start mattering? Can
> >> we please just disable spread-spectrum entirely? Or perhaps only if we
> >> notice that it was enabled already? Or something?
> >
> > Randy, Jeff and Alex, does the below help at all?  If so, it may be the
> > minimal fix we want for 2.6.37.
> 
> Something broke your patch: whitespace instead of tabs.

Yeah, just copy & pasted, sorry.

> > diff --git a/drivers/gpu/drm/i915/intel_bios.c b/drivers/gpu/drm/i915/intel_bios
> > index 2b20786..d27d016 100644
> > --- a/drivers/gpu/drm/i915/intel_bios.c
> > +++ b/drivers/gpu/drm/i915/intel_bios.c
> > @@ -263,6 +263,9 @@ parse_general_features(struct drm_i915_private *dev_priv,
> >                dev_priv->int_tv_support = general->int_tv_support;
> >                dev_priv->int_crt_support = general->int_crt_support;
> >                dev_priv->lvds_use_ssc = general->enable_ssc;
> > +               /* force disable until we can parse this correctly */
> 
> This comment seems to imply that SSC wasn't used at all until recently, right?

No, we enabled it previously, but it apparently doesn't work on all
platforms, probably because we're either looking in the wrong place for
the bit that tells us to enable it or not, or we're getting the wrong
frequency on some platforms.  Probably both (the VBIOS guys work
closely with the Windows driver team that consumes this data, and don't
always tell us when they make incompatible changes).

> > +               if (IS_GEN5(dev) || IS_GEN6(dev))
> > +                       dev_priv->lvds_use_ssc = 0;
> 
> Doesn't change anything here. Display stays blank.

Sounds like your problem is separate from SSC then, more likely related
to panel power or backlight control.  Have you tried bisecting for the
problem between 2.6.35 and 2.6.36?

-- 
Jesse Barnes, Intel Open Source Technology Center
