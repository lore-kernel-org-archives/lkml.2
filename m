Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754923Ab2JBREl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 13:04:41 -0400
Received: from mail.anarazel.de ([217.115.131.40]:48702 "EHLO mail.anarazel.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752918Ab2JBREj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 13:04:39 -0400
From: Andres Freund <andres@anarazel.de>
To: Alex Deucher <alexdeucher@gmail.com>
Subject: Re: radeon: Regression between v3.6-rc4 and v3.6-rc6: unable to allocate a PPLL
Date: Tue, 2 Oct 2012 19:04:35 +0200
User-Agent: KMail/1.13.7 (Linux/3.5.0-rc3-andres-00231-g002b758; KDE/4.8.4; x86_64; ; )
Cc: "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
References: <201209171329.15699.andres@anarazel.de> <CADnq5_O0Y+=29ZkKxW-DgrAsFh+kiRAJBh0oC+a_SNEPu3VguQ@mail.gmail.com> <CADnq5_OOFuXhMrAifxN2pLnKNgX2CGSBP+BRCCf99LS2-BOs9A@mail.gmail.com>
In-Reply-To: <CADnq5_OOFuXhMrAifxN2pLnKNgX2CGSBP+BRCCf99LS2-BOs9A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201210021904.36503.andres@anarazel.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, September 27, 2012 06:19:53 PM Alex Deucher wrote:
> On Thu, Sep 27, 2012 at 10:54 AM, Alex Deucher <alexdeucher@gmail.com> 
wrote:
> > On Thu, Sep 27, 2012 at 9:23 AM, Andres Freund <andres@anarazel.de> wrote:
> >> On Thursday, September 27, 2012 03:14:31 PM Alex Deucher wrote:
> >>> On Thu, Sep 27, 2012 at 2:46 AM, Andres Freund <andres@anarazel.de> 
wrote:
> >>> > On Wednesday, September 26, 2012 03:42:40 PM Deucher, Alexander wrote:
> >>> >> > -----Original Message-----
> >>> >> > From: Andres Freund [mailto:andres@anarazel.de]
> >>> >> > Sent: Wednesday, September 26, 2012 9:41 AM
> >>> >> > To: Dan Carpenter
> >>> >> > Cc: Deucher, Alexander; LKML; David Airlie;
> >>> >> > dri-devel@lists.freedesktop.org Subject: Re: radeon: Regression
> >>> >> > between v3.6-rc4 and v3.6-rc6: unable to allocate a PPLL
> >>> >> > 
> >>> >> > On Wednesday, September 26, 2012 03:00:09 PM Dan Carpenter wrote:
> >>> >> > > This is fixed now?
> >>> >> > 
> >>> >> > Its been reverted in 2f1f4d9b60396d2df4cff829bd5376ffc8ed9a2c
> >>> >> > which is in rc6.
> >>> >> > 
> >>> >> > On Monday, September 17, 2012 09:30:12 PM Deucher, Alexander
> >>> >> > wrote: Sorry, I somehow accidentally marked your  email as read
> >>> >> > and thus didn't notice it.
> >>> >> > 
> >>> >> > > I think I see the problem.  I think it's a limitation of the
> >>> >> > > current current
> >>> >> > 
> >>> >> > modesetting API.  The current API sets up each display
> >>> >> > independently which doesn't work so well if there are resource
> >>> >> > restrictions.  There shouldn't be any contention on your board
> >>> >> > since you are only using 2 non-DP displays.  It looks like X is
> >>> >> > mapping different crtcs to displays than the kernel fb.
> >>> >> > 
> >>> >> > Initially the kernel set up the follow:
> >>> >> > > > [    2.134901] [drm] crtc 0 using pll 0x2
> >>> >> > > > [    2.362257] [drm] crtc 1 using pll 0x1
> >>> >> > > > [    2.386709] [drm] crtc 2 using pll 0x0
> >>> >> > > 
> >>> >> > > Crtc 0 -> DCPLL -> DP
> >>> >> > > Crtc 1 -> PPLL2 -> DVI
> >>> >> > > Crtc 2 -> PPLL1 -> DVI
> >>> >> > > 
> >>> >> > > When X loads, it tried to set a different crtc to display mapping:
> >>> >> > > > [   60.679310] [drm] crtc 0 using pll 0xff
> >>> >> > > > [   60.789183] [drm] crtc 1 using pll 0x2
> >>> >> > > > [   60.819594] [drm] crtc 2 using pll 0x1
> >>> >> > > 
> >>> >> > > Crtc 0 -> INVALID -> DVI 0
> >>> >> > > Crtc 1 -> DCPLL -> DP
> >>> >> > > Crtc 2 -> PPLL2 -> DVI 1
> >>> >> > > 
> >>> >> > > Crtc 0 should have used PPLL1 or PPLL2, but they were already in
> >>> >> > > use by crtc 1 and crtc  2 from the previous modeset.  Since the
> >>> >> > > modeset API is not atomic, it doesn't have the whole picture. 
> >>> >> > > I'm not sure of a good solution right now prior to the new
> >>> >> > > atomic modeset API that is under discussion.  I guess we can
> >>> >> > > revert the patch for 3.6.
> >>> >> > > 
> >>> >> > >  For 3.7 I guess we need to validate the actual connector to
> >>> >> > >  make
> >>> >> > > 
> >>> >> > > sure we aren't trying to set a different configuration relating
> >>> >> > > to the same connector without first tearing down the first one.
> >>> >> > >  In the interim, you should be able to work around it by
> >>> >> > > disabling the non-DP outputs and then bringing than back up.
> >>> >> > 
> >>> >> > Thanks! That explanation makes sense. I can work around it just
> >>> >> > fine, starting X multiple times works which coincides nicely with
> >>> >> > your explanation.
> >>> >> > 
> >>> >> > The code in the 3.7 branch doesn't do that extended validation
> >>> >> > yet, rigth? If you want/need you can CC for testing once thats
> >>> >> > ready.
> >>> >> 
> >>> >> It should handle it now.  If you could test it that would be great.
> >>> > 
> >>> > Ok, just to be sure I tested Linus' tree and everything works fine
> >>> > there.
> >>> > 
> >>> > Unfortunately thats not the case with a straight merge of
> >>> > alexdeucher/drm- next-3.7-wip. When gdm started *the first time* the
> >>> > DVI-connected (uhm, same sink type? Thats the saphire magic allowing
> >>> > more monitors on that type of graphics card?) I got a "unable to
> >>> > allocate a PPLL" error again. Logging in/starting a new X seems to
> >>> > fix that.
> >>> 
> >>> So you have a xorg.conf with a hardcoded configuration?  If so can you
> >>> send it to me?
> >> 
> >> Yes, but just setting the xrand positions:
> > Thanks.  I can't seem to reproduce it here, but I've pushed an updated
> > drm-next-3.7-wip which may help.  If not, can you apply the attached
> > patch and send me the output?
> 
> Ok, I was finally able to reproduce your issue and it's working fine
> here with my latest drm-next-3.7-wip branch.
Sorry for the delay, I was on the road and couldn't easily test this remotely. 
Works fine!

Thanks,

Andres
