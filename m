Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757230Ab1LNNez (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 08:34:55 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:44408 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753859Ab1LNNex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 08:34:53 -0500
Date: Wed, 14 Dec 2011 13:34:48 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: James Hogan <james.hogan@imgtec.com>
Cc: Liam Girdwood <lrg@ti.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Neil <neil.jones@imgtec.com>
Subject: Re: bugs in "ASoC: core - Optimise and refactor pcm_new() to pass
 only rtd"?
Message-ID: <20111214133448.GD25088@sirena.org.uk>
References: <4EE89A06.80101@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EE89A06.80101@imgtec.com>
X-Cookie: Inside, I'm already SOBBING!
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 12:43:50PM +0000, James Hogan wrote:

> I've bisected a problem with an out of tree set of asoc drivers down to commit
> 552d1ef6b5a98d7b95959d5b139071e3c90cebf1 ("ASoC: core - Optimise and refactor
> pcm_new() to pass only rtd"). By the looks of it this change was intended not 
> to change the workings of the code, however the dai parameter of pcm_new used
> to be passed codec_dai in soc_new_pcm() (initialised from rtd->codec_dai), but
> each driver now sets it's dai to rtd->cpu_dai instead. This seems to make the
> driver check the wrong dai's driver->capture.channels_min in the pcm_new
> callback, which makes it dereference
> pcm->streams[SNDRV_PCM_STREAM_CAPTURE].substream in the driver's
> preallocate_dma_buffer() function which can be NULL. Is this a bug (in every
> pcm asoc driver) that just happens not to have been noticed, or have I
> misunderstood it?

Your drivers should never have beenn relying on this behaviour of the
core - see changes in the pxa and fsl drivers which remove similar
assumptions.  The CPU driver should be checking for the substream if
it's looking to see if a particular substream is present, not peering
inside the DAI for a random parameter.
