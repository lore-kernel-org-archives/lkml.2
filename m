Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751814Ab0I3A6k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 20:58:40 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50568 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751194Ab0I3A6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 20:58:39 -0400
Date: Wed, 29 Sep 2010 17:58:51 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Peter Hsiang <Peter.Hsiang@maxim-ic.com>
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Peter Ujfalusi <peter.ujfalusi@nokia.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jesse Marroquin <Jesse.Marroquin@maxim-ic.com>
Subject: Re: [PATCH] ASoC: Add max98088 CODEC driver
Message-ID: <20100930005850.GB4517@opensource.wolfsonmicro.com>
References: <B2150E1E4418E1438554A300EA5040E40D469C124D@ITSVLEX06.it.maxim-ic.internal>
 <20100929033757.GB29975@opensource.wolfsonmicro.com>
 <B2150E1E4418E1438554A300EA5040E40D46F2D8D8@ITSVLEX06.it.maxim-ic.internal>
 <20100929221826.GC31934@opensource.wolfsonmicro.com>
 <B2150E1E4418E1438554A300EA5040E40D46F2D9E9@ITSVLEX06.it.maxim-ic.internal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B2150E1E4418E1438554A300EA5040E40D46F2D9E9@ITSVLEX06.it.maxim-ic.internal>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 29, 2010 at 05:52:08PM -0700, Peter Hsiang wrote:
> On Wed, Sep 29, 2010, Mark Brown wrote:

> > You're looking for the non-DAPM equivalent of SND_SOC_DAPM_VALUE_MUX().

> This is a simple table lookup of a register value from the index
> number given by SOC_ENUM, the same way it's been done in other drivers.

Yes, exactly.

> I found a "case snd_soc_dapm_value_mux:" in dapm_set_path_status()
> Is this what you are referring to?
> How is the code there relevant to this?

No, I'm referring to the fact that it provides an enum that allows
arbatrary values to be set for each enum value rather than just allowing
indexes as the standard SOC_ENUM does.  This is essentially what you've
implemented, it would factor out the code so that others can use it too
(and IIRC save you some code since IIRC you had more than one of these
in the driver).

> > > > > +       /* powering down headphone gracefully */
> > > > > +       status = snd_soc_read(codec, M98088_REG_4D_PWR_EN_OUT);
> > > > > +       if ((status & M98088_HPEN) == M98088_HPEN) {
> > > > > +               max98088_hw_write(codec, M98088_REG_4D_PWR_EN_OUT,
> > > > > +                       (status & ~M98088_HPEN));
> > > > > +       }
> > > > > +       schedule_timeout(msecs_to_jiffies(20));

> > > > This looks rather like it should just be a post event implementing a
> > > > timeout?

> > > This needs to work as a pre event.

> > Again, why is this?

> When powering down the headphone, the way that DAPM works is it
> likes to power off one item at a time, for example, the left channel,
> then right channel.  The headphone hardware likes to see the 

Have you tested with current Linux versions?  For quite a few kernel
releases now register writes are batched so that all the controls of a
given type in a single register will be set together.

> headphone bits L and R be powered down together, for optimum result.
> This works best with the pre method.  Powering up one channel at a 
> time later is fine, when DAPM resumes.

With current Linux versions you should see the left and right channels
powered down together (if they are both being powered down, of course).
