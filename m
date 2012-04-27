Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752481Ab2D0FPE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 01:15:04 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50000 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112Ab2D0FPC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 01:15:02 -0400
Message-ID: <1335504021.5311.0.camel@nisroch>
Subject: Re: Linux 3.4-rc4
From: Ben Skeggs <skeggsb@gmail.com>
Reply-To: skeggsb@gmail.com
To: Nick Bowler <nbowler@elliptictech.com>
Cc: Martin Peres <martin.peres@labri.fr>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
Date: Fri, 27 Apr 2012 15:20:21 +1000
In-Reply-To: <1335322574.1821.8.camel@nisroch>
References: <CA+55aFzQD4UyPVDQesrWq7JkM=BoQevdJpQt1YyaG10MtfM-Pw@mail.gmail.com>
	 <20120422040715.GA30689@elliptictech.com>
	 <CA+55aFwGrb_sOjHFWe6tYwf8mmNsFbqKAhz=bq2ofiU+F+wVvA@mail.gmail.com>
	 <20120422164023.GA32342@elliptictech.com>
	 <20120423000554.GA893@elliptictech.com>
	 <20120423024558.GD13840@phenom.dumpdata.com>
	 <20120424010345.GA30674@elliptictech.com>
	 <20120425013537.GA11959@elliptictech.com> <1335322574.1821.8.camel@nisroch>
Organization: 
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.1 (3.4.1-1.fc17) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-04-25 at 12:56 +1000, Ben Skeggs wrote:
> On Tue, 2012-04-24 at 21:35 -0400, Nick Bowler wrote:
> > On 2012-04-23 21:03 -0400, Nick Bowler wrote:
> > > On 2012-04-22 22:45 -0400, Konrad Rzeszutek Wilk wrote:
> > > > On Sun, Apr 22, 2012 at 08:05:54PM -0400, Nick Bowler wrote:
> > > > > Following up on the above, the commit which introduces the panics during
> > > > > boot is this one:
> > > > >
> > > > > commit 8e7e70522d760c4ccd4cd370ebfa0ba69e006c6e
> > > > > Author: Jerome Glisse <jglisse@redhat.com>
> > > > > Date:   Wed Nov 9 17:15:26 2011 -0500
> > > > > 
> > > > >     drm/ttm: isolate dma data from ttm_tt V4
> > [...]
> > > > dea7e0a ttm: fix agp since ttm tt rework
> > > > 
> > > > fixed that.
> > > 
> > > Yes, I just tested this commit and the one immediately before it.  The
> > > one before crashes in the usual way, and dea7e0a boots (with the VGA
> > > output black as in the original report).  So this fixed the crash.
> > 
> > OK, here's what I did:
> > 
> >  - Since dea7e0a is the first commit that both (a) boots and (b) has
> >    broken VGA, I checked it out on a new branch:
> > 
> >      git checkout -b crazy dea7e0a
> > 
> >  - Next, I reverted *all* (well, I missed one by accident) the remaining
> >    nouveau-specific commits between 3230cfc34 ("drm/nouveau: enable the
> >    ttm dma pool when swiotlb is active V3") (i.e., the last commit that
> >    (a) boots and (b) has non-broken VGA) and dea7e0a:
> > 
> >      git revert --no-edit 0c101461e267..f7b24c42da1a
> > 
> >  - Amazingly, the resulting kernel booted and had working VGA, so I did
> >    a "backwards" bisect on this branch of reverts.  In a strange twist
> >    of fate, this actually managed to produce bootable kernels the entire
> >    time.  The bisection pinpointed the following commit as the culprit:
> > 
> > commit a0b25635515ef5049f93b032a1e37f18b16e0f6f
> > Author: Ben Skeggs <bskeggs@redhat.com>
> > Date:   Mon Nov 21 16:41:48 2011 +1000
> > 
> >     drm/nouveau/gpio: reimplement as nouveau_gpio.c, fixing a number of issues
> >     
> >     - moves out of nouveau_bios.c and demagics the logical state definitions
> >     - simplifies chipset-specific driver interface
> >     - makes most of gpio irq handling common, will use for nv4x hpd later
> >     - api extended to allow both direct gpio access, and access using the
> >       logical function states
> >     - api extended to allow for future use of gpio extender chips
> >     - pre-nv50 was handled very badly, the main issue being that all GPIOs
> >       were being treated as output-only.
> >     - fixes nvd0 so gpio changes actually stick, magic reg needs bashing
> >     
> >     Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
> Excellent!  That makes things possible.
> 
> Are you able to mount debugfs, and email /debugfs/dri/0/vbios.rom for me
> (privately if you wish) and I'll attempt to track down what broke for
> you.
Does this patch help you at all?

http://cgit.freedesktop.org/nouveau/linux-2.6/commit/?id=a3a285f17867f0018de798b5ee85731ec1268305

Cheers,
Ben.
> 
> Thanks!
> Ben.
> 
> > 
> > Unfortunately, there are a number of seemingly non-trivial conflicts
> > trying to revert just this one gigantic commit.  So to avoid any
> > conflicts, I reverted all of the following (in this order) on top of
> > 3.3.3 (there are even more conflicts trying to revert on top of Linus'
> > master):
> > 
> >   7df898b1a70b ("drm/nouveau/disp: check that panel power gpio is enabled at init time")
> >   52c4d767437b ("drm/nouveau: move hpd enable/disable to common code")
> >   47e5d5cb83d4 ("drm/nv40/disp: implement support for hotplug irq")
> >   a0b25635515e ("drm/nouveau/gpio: reimplement as nouveau_gpio.c, fixing a number of issues")
> > 
> > and my VGA is working again!
> > 
> > Cheers,
> 
> 
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel


