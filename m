Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761004Ab0FRLdp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 07:33:45 -0400
Received: from ossa.mas.viperplatform.net.au ([202.147.75.25]:58369 "EHLO
	ossa.mas.viperplatform.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756645Ab0FRLdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 07:33:43 -0400
Date: Fri, 18 Jun 2010 21:33:35 +1000
From: Stuart Longland <redhatter@gentoo.org>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: ALSA Development List <alsa-devel@alsa-project.org>,
       Takashi Iwai <tiwai@suse.de>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ASoC: Add new TI TLV320AIC3204 CODEC driver
Message-ID: <20100618113335.GB30868@www.longlandclan.yi.org>
References: <1276833465-31702-1-git-send-email-redhatter@gentoo.org>
 <1276858862.3054.28.camel@odin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276858862.3054.28.camel@odin>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Clarity-Outbound-SpamScanned: YES
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

To others: In case you're wondering where the patch is... I pulled it
from the moderation queue because there were a few style errors, and
some definitions I forgot to delete.  A fresh one that meets coding
style requirements is on its way, as soon as scripts/checkpatch.pl is
finished (this seems to take a while on my hardware).

On Fri, Jun 18, 2010 at 12:01:02PM +0100, Liam Girdwood wrote:
> On Fri, 2010-06-18 at 13:57 +1000, Stuart Longland wrote:
> > The TLV320AIC3204 is a low-power stereo audio CODEC capable of sample
> > rates of up to 192kHz.  This driver implements basic functionality,
> > using I??C for the control channel.
> > 
> > The audio interface supports many data bus formats, including I??S
> > master/slave, DSP, left/right justified and TDM.
> 
> Just had a quick check and the register caching needs addressed.
> 
> I agree with your comments, I don't think we really want to cache all
> 16K of codec registers here as we will probably only ever use a handful
> of them. I think a smaller lookup table containing only the registers
> that we care about will do.

Yeah, I wasn't sure how to go about it.  It's inefficient, but it's
simple, and works.  Other options I've considered;

(1) Mark's suggestion of using per-page arrays
(2) Using address translation. that is:
	- Page 0 registers 0-127 stored in cache array elements 0-127
	- Page 1 registers 0-127 stored in cache array elements 128-255
	- Page 2..7 are skipped
	- Page 8 registers 0-127 stored in cache array elements 256-383
	... etc.

> Fwiw, a generic ASoC lookup table would be best as this could be used by
> other codecs with large register maps too. The table should be ordered
> (for quick lookup) and also contain a readable/writeable/volatile flag
> for each register.

Indeed, the 'AIC3204 is not the only CODEC to use sparse register maps.
16KB is not a lot of RAM these days, but it's a lot more RAM than I'm
comfortable using for an audio driver.  I'll give this some thought, but
for now I'll press on with what I have since I know it works reliably.

Another thought regarding register cache, rather than hard-coding it the
way we presently do, we could also build up the cache on demand... that
is, we maintain a table of previously read registers; if a register
value is read for the first time, an actual read is done from the CODEC
(or the value is copied from a static table).  All subsequent reads then
come from cache.  On suspend; if a register has not been touched, it is
deemed to be left at default settings, and skipped on resume.

The downside of this is having to maintain a table of what registers
have been read already; which would possibly be as big as the cache is
anyway.  But the flip side; if a company brought out a new CODEC which
had differing power-up defaults to a similar CODEC handled by the same
driver, it would prevent the wrong default getting assumed or loaded in.
-- 
Stuart Longland (aka Redhatter, VK4MSL)      .'''.
Gentoo Linux/MIPS Cobalt and Docs Developer  '.'` :
. . . . . . . . . . . . . . . . . . . . . .   .'.'
http://dev.gentoo.org/~redhatter             :.'

I haven't lost my mind...
  ...it's backed up on a tape somewhere.
