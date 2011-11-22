Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758308Ab1KVLUd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 06:20:33 -0500
Received: from mga03.intel.com ([143.182.124.21]:32617 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754045Ab1KVLUc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 06:20:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,552,1315206000"; 
   d="scan'208";a="77913708"
Date: Tue, 22 Nov 2011 19:20:08 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] [PATCH] hda - fail ELD reading early
Message-ID: <20111122112008.GA9207@localhost>
References: <20111122084623.GA30050@localhost>
 <s5hlir8igp2.wl%tiwai@suse.de>
 <20111122105318.GB5730@localhost>
 <s5hfwhgifck.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hfwhgifck.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22, 2011 at 07:08:59PM +0800, Takashi Iwai wrote:
> At Tue, 22 Nov 2011 18:53:18 +0800,
> Wu Fengguang wrote:
> > 
> > On Tue, Nov 22, 2011 at 06:39:53PM +0800, Takashi Iwai wrote:
> > > At Tue, 22 Nov 2011 16:46:23 +0800,
> > > Wu Fengguang wrote:
> > > > 
> > > > With the ELD repoll mechanism, we can (and should) fail the ELD reading
> > > > immediately when find something obviously wrong and let the caller retry
> > > > after some delay.
> > > > 
> > > > Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> > > > ---
> > > >  sound/pci/hda/hda_eld.c |   28 +++++++++++++++++++---------
> > > >  1 file changed, 19 insertions(+), 9 deletions(-)
> > > > 
> > > > --- linux.orig/sound/pci/hda/hda_eld.c	2011-11-22 16:02:58.000000000 +0800
> > > > +++ linux/sound/pci/hda/hda_eld.c	2011-11-22 16:36:10.000000000 +0800
> > > > @@ -347,18 +347,28 @@ int snd_hdmi_get_eld(struct hdmi_eld *el
> > > >  
> > > >  	for (i = 0; i < size; i++) {
> > > >  		unsigned int val = hdmi_get_eld_data(codec, nid, i);
> > > > +		/*
> > > > +		 * Graphics driver might be writing to ELD buffer right now.
> > > > +		 * Just abort. The caller will repoll after a while.
> > > > +		 */
> > > >  		if (!(val & AC_ELDD_ELD_VALID)) {
> > > > -			if (!i) {
> > > > -				snd_printd(KERN_INFO
> > > > -					   "HDMI: invalid ELD data\n");
> > > > -				ret = -EINVAL;
> > > > -				goto error;
> > > > -			}
> > > >  			snd_printd(KERN_INFO
> > > >  				  "HDMI: invalid ELD data byte %d\n", i);
> > > > -			val = 0;
> > > > -		} else
> > > > -			val &= AC_ELDD_ELD_DATA;
> > > > +			ret = -EINVAL;
> > > > +			goto error;
> > > > +		}
> > > > +		val &= AC_ELDD_ELD_DATA;
> > > > +		/*
> > > > +		 * The first byte cannot be zero. This can happen on some DVI
> > > > +		 * connections. Some Intel chips may also need some 250ms delay
> > > > +		 * to return non-zero ELD data, even when the graphics driver
> > > > +		 * correctly writes ELD content before setting ELD_valid bit.
> > > > +		 */
> > > > +		if (!val && !i) {
> > > > +			snd_printdd(KERN_INFO "HDMI: 0 ELD data\n");
> > > > +			ret = -EINVAL;
> > > > +			goto error;
> > > > +		}
> > > 
> > > Shouldn't this zero-check be before the valid-bit check?
> > > Otherwise it'll never reach there.
> > 
> > It does reach there:
> > 
> >         [ 1191.016746] HDMI hot plug event: Codec=3 Pin=6 Presence_Detect=1 ELD_Valid=1
> >         [ 1191.019309] HDMI status: Codec=3 Pin=6 Presence_Detect=1 ELD_Valid=1
> > ==>     [ 1191.021803] ALSA hda_eld.c:368 HDMI: 0 ELD data
> >         [ 1191.324661] HDMI status: Codec=3 Pin=6 Presence_Detect=1 ELD_Valid=1
> >         [ 1191.333236] HDMI: detected monitor SONY TV at connection type HDMI
> >         [ 1191.335020] HDMI: available speakers: FL/FR
> >         [ 1191.335996] HDMI: supports coding type LPCM: channels = 2, rates = 32000 44100 48000, bits = 16 20 24
> > 
> > The funny thing is, it's reporting (invalid) 0 ELD data that has
> > the AC_ELDD_ELD_VALID bit set.
> 
> Ah OK.  Another slight concern is that your patch gives always the
> error when ELD_VALID isn't set, so it makes the check more strict in
> practice.  I guess it'd be OK, so I'll take it in.  But we need to
> carefully hear whether anyone cries with this.

Agreed, the original code simply sets data to 0 when !ELD_VALID. 
If the hardware does the illogical thing (who knows) of conditional
setting !ELD_VALID on some parts of the ELD buffer which happen to
contain 0, we'll be in bad luck...

Thanks,
Fengguang
