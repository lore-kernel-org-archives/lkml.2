Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751497Ab2HFEWs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 00:22:48 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:34600 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750847Ab2HFEWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 00:22:45 -0400
Date: Sun, 5 Aug 2012 21:21:56 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Takashi Iwai <tiwai@suse.de>
cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Giacomo Comes <comes@naic.edu>, linux-kernel@vger.kernel.org
Subject: Re: i915 regression on 3.6-rc1: lid blanks screen
In-Reply-To: <s5h3941ke2p.wl%tiwai@suse.de>
Message-ID: <alpine.LSU.2.00.1208052113530.1300@eggly.anvils>
References: <alpine.LSU.2.00.1208040936570.1161@eggly.anvils> <s5h3941ke2p.wl%tiwai@suse.de>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 5 Aug 2012, Takashi Iwai wrote:
> At Sat, 4 Aug 2012 10:01:13 -0700 (PDT),
> Hugh Dickins wrote:
> > 
> > Sorry to report that with 3.6-rc1, closing and opening the lid on
> > this ThinkPad T420s leaves the screen blank, and I have to reboot.
> > 
> > I understand there's also an nVidia graphics device in here,
> > but I have that configured out, preferring to use the i915:
> > 
> > 00:02.0 VGA compatible controller: Intel Corporation 2nd Generation Core Processor Family Integrated Graphics Controller (rev 09) (prog-if 00 [VGA controller])
> > 	Subsystem: Lenovo Device 21d3
> > 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
> > 	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> > 	Latency: 0
> > 	Interrupt: pin A routed to IRQ 41
> > 	Region 0: Memory at f1400000 (64-bit, non-prefetchable) [size=4M]
> > 	Region 2: Memory at e0000000 (64-bit, prefetchable) [size=256M]
> > 	Region 4: I/O ports at 5000 [size=64]
> > 	Expansion ROM at <unassigned> [disabled]
> > 	Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
> > 		Address: fee0100c  Data: 41c2
> > 	Capabilities: [d0] Power Management version 2
> > 		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
> > 		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
> > 	Capabilities: [a4] PCI Advanced Features
> > 		AFCap: TP+ FLR+
> > 		AFCtrl: FLR-
> > 		AFStatus: TP-
> > 	Kernel driver in use: i915
> > 
> > Bisection led to this commit, and reverting indeed gets my screen back:
> > 
> > commit 520c41cf2fa029d1e8b923ac2026f96664f17c4b
> > Author: Daniel Vetter <daniel.vetter@ffwll.ch>
> > Date:   Wed Jul 11 16:27:52 2012 +0200
> > 
> >     drm/i915/lvds: ditch ->prepare special case
...
> 
> Hm, it's surprising.
> 
> Could you check whether the counter-part intel_lvds_enable() is
> called?  If the prepare callback affects, it must be from the mode
> setting (drm_crtc_helper_set_mode()).

Yes, I put a dump_stack() in both, and intel_lvds_enable() gets called
about 0.28 seconds after the intel_lvds_disable() when I lift the lid;
but with no video display until I revert that commit.

Hugh

> 
> 
> Takashi
> 
> > 
> > diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel_lvds.c
> > index 49f09a8..e05c0d3 100644
> > --- a/drivers/gpu/drm/i915/intel_lvds.c
> > +++ b/drivers/gpu/drm/i915/intel_lvds.c
> > @@ -409,13 +409,7 @@ static void intel_lvds_prepare(struct drm_encoder *encoder)
> >  {
> >  	struct intel_lvds *intel_lvds = to_intel_lvds(encoder);
> >  
> > -	/*
> > -	 * Prior to Ironlake, we must disable the pipe if we want to adjust
> > -	 * the panel fitter. However at all other times we can just reset
> > -	 * the registers regardless.
> > -	 */
> > -	if (!HAS_PCH_SPLIT(encoder->dev) && intel_lvds->pfit_dirty)
> > -		intel_lvds_disable(intel_lvds);
> > +	intel_lvds_disable(intel_lvds);
> >  }
> >  
> >  static void intel_lvds_commit(struct drm_encoder *encoder)
