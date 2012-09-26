Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756449Ab2IZNmu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 09:42:50 -0400
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:55079
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753879Ab2IZNmt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 09:42:49 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -10
X-BigFish: VPS-10(zz98dI9371I103dK542M1432Id6f1izz1202h1d1ah1d2ahzz8275dhz2dh668h839h944hd25hf0ah107ah1220h1288h12a5h12a9h12bdh137ah13b6h1155h)
X-WSS-ID: 0MAYM34-02-F9C-02
X-M-MSG: 
From: "Deucher, Alexander" <Alexander.Deucher@amd.com>
To: Andres Freund <andres@anarazel.de>,
        Dan Carpenter <dan.carpenter@oracle.com>
CC: LKML <linux-kernel@vger.kernel.org>, David Airlie <airlied@linux.ie>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Subject: RE: radeon: Regression between v3.6-rc4 and v3.6-rc6: unable to
 allocate a PPLL
Thread-Topic: radeon: Regression between v3.6-rc4 and v3.6-rc6: unable to
 allocate a PPLL
Thread-Index: AQHNlMf4cJj+N2GqCk+osvT7J0ZY3JeOgYkggABg+QD//7NwcIAAhHWA//+4SPCADiVJgIAAC3WA//+scnA=
Date: Wed, 26 Sep 2012 13:42:40 +0000
Message-ID: <A3397C8B8B789E45844E7EC5DEAD89D02C435787@sausexdag03.amd.com>
References: <201209171329.15699.andres@anarazel.de>
 <A3397C8B8B789E45844E7EC5DEAD89D02C433574@sausexdag03.amd.com>
 <20120926130009.GE28937@mwanda> <201209261541.09835.andres@anarazel.de>
In-Reply-To: <201209261541.09835.andres@anarazel.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.224.13.246]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Andres Freund [mailto:andres@anarazel.de]
> Sent: Wednesday, September 26, 2012 9:41 AM
> To: Dan Carpenter
> Cc: Deucher, Alexander; LKML; David Airlie; dri-devel@lists.freedesktop.org
> Subject: Re: radeon: Regression between v3.6-rc4 and v3.6-rc6: unable to
> allocate a PPLL
> 
> On Wednesday, September 26, 2012 03:00:09 PM Dan Carpenter wrote:
> > This is fixed now?
> Its been reverted in 2f1f4d9b60396d2df4cff829bd5376ffc8ed9a2c which is in
> rc6.
> 
> On Monday, September 17, 2012 09:30:12 PM Deucher, Alexander wrote:
> Sorry, I somehow accidentally marked your  email as read and thus didn't
> notice it.
> 
> > I think I see the problem.  I think it's a limitation of the current current
> modesetting API.  The current API sets up each display independently which
> doesn't work so well if there are resource restrictions.  There shouldn't be
> any contention on your board since you are only using 2 non-DP displays.  It
> looks like X is mapping different crtcs to displays than the kernel fb.
> Initially the kernel set up the follow:
> > > [    2.134901] [drm] crtc 0 using pll 0x2
> > > [    2.362257] [drm] crtc 1 using pll 0x1
> > > [    2.386709] [drm] crtc 2 using pll 0x0
> >
> > Crtc 0 -> DCPLL -> DP
> > Crtc 1 -> PPLL2 -> DVI
> > Crtc 2 -> PPLL1 -> DVI
> >
> > When X loads, it tried to set a different crtc to display mapping:
> > > [   60.679310] [drm] crtc 0 using pll 0xff
> > > [   60.789183] [drm] crtc 1 using pll 0x2
> > > [   60.819594] [drm] crtc 2 using pll 0x1
> >
> > Crtc 0 -> INVALID -> DVI 0
> > Crtc 1 -> DCPLL -> DP
> > Crtc 2 -> PPLL2 -> DVI 1
> >
> > Crtc 0 should have used PPLL1 or PPLL2, but they were already in use by
> > crtc 1 and crtc  2 from the previous modeset.  Since the modeset API is
> > not atomic, it doesn't have the whole picture.  I'm not sure of a good
> > solution right now prior to the new atomic modeset API that is under
> > discussion.  I guess we can revert the patch for 3.6.  For 3.7 I guess we
> > need to validate the actual connector to make sure we aren't trying to set
> > a different configuration relating to the same connector without first
> > tearing down the first one.  In the interim, you should be able to work
> > around it by disabling the non-DP outputs and then bringing than back up.
> Thanks! That explanation makes sense. I can work around it just fine, starting
> X multiple times works which coincides nicely with your explanation.
> 
> The code in the 3.7 branch doesn't do that extended validation yet, rigth? If
> you want/need you can CC for testing once thats ready.

It should handle it now.  If you could test it that would be great.

Alex


