Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063Ab0FRWnW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 18:43:22 -0400
Received: from ossa.mas.viperplatform.net.au ([202.147.75.25]:59823 "EHLO
	ossa.mas.viperplatform.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753456Ab0FRWnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 18:43:20 -0400
Date: Sat, 19 Jun 2010 08:43:14 +1000
From: Stuart Longland <redhatter@gentoo.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Takashi Iwai <tiwai@suse.de>,
       ALSA Development List <alsa-devel@alsa-project.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
       Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [alsa-devel] [PATCH] ASoC: Add new TI TLV320AIC3204 CODEC
 driver
Message-ID: <20100618224313.GC30868@www.longlandclan.yi.org>
References: <1276833465-31702-1-git-send-email-redhatter@gentoo.org>
 <1276858862.3054.28.camel@odin>
 <20100618113335.GB30868@www.longlandclan.yi.org>
 <20100618155322.GB16941@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100618155322.GB16941@rakim.wolfsonmicro.main>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 18, 2010 at 04:53:23PM +0100, Mark Brown wrote:
> On Fri, Jun 18, 2010 at 09:33:35PM +1000, Stuart Longland wrote:
> > On Fri, Jun 18, 2010 at 12:01:02PM +0100, Liam Girdwood wrote:
> > > On Fri, 2010-06-18 at 13:57 +1000, Stuart Longland wrote:
> 
> > > > The audio interface supports many data bus formats, including I??S
> > > > master/slave, DSP, left/right justified and TDM.
> 
> > > Just had a quick check and the register caching needs addressed.
> 
> > > I agree with your comments, I don't think we really want to cache all
> > > 16K of codec registers here as we will probably only ever use a handful
> > > of them. I think a smaller lookup table containing only the registers
> > > that we care about will do.
> 
> > Yeah, I wasn't sure how to go about it.  It's inefficient, but it's
> > simple, and works.  Other options I've considered;
> 
> > (1) Mark's suggestion of using per-page arrays
> > (2) Using address translation. that is:
> > 	- Page 0 registers 0-127 stored in cache array elements 0-127
> > 	- Page 1 registers 0-127 stored in cache array elements 128-255
> > 	- Page 2..7 are skipped
> > 	- Page 8 registers 0-127 stored in cache array elements 256-383
> > 	... etc.
> 
> Option 2 is what others have used here.  I do think that anything we do
> here really ought to have some sort of page mapping support whatever the
> actual implementation it uses - TI in particular have a bunch of chips
> which do this so there's a general call for something that can handle
> them.
> 
> If you are going to do a lookup table one way of doing this would be to
> have the lookup table be a table of range mappings (I've not looked at
> the patch, perhaps that's what you've done already) - just so long as
> it's got the concept of pages covered somehow.

Yeah... for now I've re-sent a new patch... it's on its way... with the
register cache in its present form.  It's huge and unsightly, but won't
otherwise cause a problem.

I'd sooner get the driver out there in its known working form, then come
up with a solution to fix the problem in a scalable fashion, then
quickly try to hack something up here (I'm at home presently) where I
have no test hardware to check I haven't broken something... and where
the implementation and design will likely be an appauling mess. ;-)

> > Another thought regarding register cache, rather than hard-coding it the
> > way we presently do, we could also build up the cache on demand... that
> > is, we maintain a table of previously read registers; if a register
> > value is read for the first time, an actual read is done from the CODEC
> > (or the value is copied from a static table).  All subsequent reads then
> > come from cache.  On suspend; if a register has not been touched, it is
> > deemed to be left at default settings, and skipped on resume.
> 
> The only problem with this is that for a number of reasons a lot of
> devices have no read functionality at all.  These need us to supply the
> defaults from outside the device, though other devices could use what
> you suggest.  I'd not be so bothered about the performance here - this
> has to be high performance in comparison with doing I/O on a slow bus
> such as I2C.  If we do run into performance issues we can always work on
> substituting in a higher performance algorithm later, if everything is
> well encapsulated this should be doable without much disruption.
> 
> It's also useful to have the actual defaults available for allowing
> writes to be skipped when powering up the device (eg, on resume) - these
> could be cached on first write so it's not insurmountable but it does
> need to be considered.

Indeed... I don't check if a register has been modified; I just copy it
across anyway.  I'm aware some devices do not implement reads, that was
a comment made about the TLV320AIC3X device driver that I based my
driver on... in this situation you'd have no choice but to do it the way
it's presently done now.

I'll think about this over the next few days... but I'm thinking the
basic structure of such a register cache would possibly take the form of
something like this:

struct soc_reg_cache_pg {
	/* Page index; for single-page registers, this would be zero */
	int index;
	/* Number of registers cached */
	int size;
	/* Register offset cached */
	int offset;
	/* Pointer to register flags */
	const int *flags_data[];
	/* Pointer to default values */
	const int *default_data[];
	/* Pointer to cached values */
	int *cached_data[];
	/* Pointer to next block of page registers (for sparse maps) */
	struct soc_reg_cache_pg *next_block;
};

... then you'd use several of these in an array... one for each block of
registers in a page.  If your device uses sparse registers, you can use
the next_block pointer to point to the next such struct that has the
next bank of registers, to save you scanning through *every* struct.

The register cache could be an array of pointers, size equal to the
total number of pages, if a page is not used; it is set to NULL.  If a
page is sparse, the other blocks would be accessed using the next_block
pointer.

The flags_data array would be optional; and could be used to indicate
the read/write status, volatile bits, and other information.  It'd be a
bitfield.

Thoughts?

Regards,
-- 
Stuart Longland (aka Redhatter, VK4MSL)      .'''.
Gentoo Linux/MIPS Cobalt and Docs Developer  '.'` :
. . . . . . . . . . . . . . . . . . . . . .   .'.'
http://dev.gentoo.org/~redhatter             :.'

I haven't lost my mind...
  ...it's backed up on a tape somewhere.
