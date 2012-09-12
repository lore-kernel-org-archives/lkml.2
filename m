Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932175Ab2ILOfZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 10:35:25 -0400
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:39935 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751638Ab2ILOfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 10:35:22 -0400
Message-ID: <50509DCC.4000503@ti.com>
Date: Wed, 12 Sep 2012 17:35:56 +0300
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120903 Thunderbird/15.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>, alsa-devel@alsa-project.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
        Ricardo Neri <ricardo.neri@ti.com>
Subject: Re: [PATCH 11/11] ASoC: omap-pcm: Convert to use dmaengine
References: <1347450427-27627-1-git-send-email-peter.ujfalusi@ti.com> <1347450427-27627-12-git-send-email-peter.ujfalusi@ti.com> <20120912120028.GC28448@n2100.arm.linux.org.uk> <505085DB.5000407@ti.com>
In-Reply-To: <505085DB.5000407@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2012 03:53 PM, Peter Ujfalusi wrote:
> I need to look at this, but at first look we do wait for the drain in
> omap_stop_dma(). We used to use omap_stop_dma/omap_start_dma for pause/resume
> operations.
> But sDMA also have a bit: CDPi: PAUSE_LINK_LIST which should do what we are
> looking for.
> Need to read the relevant parts of the TRM, but AFAIK we are using normal mode
> with linked list (self linking).
> I already have the patch for this, I just need to test it on HW.

We can get the PAUSE/RESUME work either:
1.
drivers/dma/omap-dma.c
static int omap_dma_pause(struct omap_chan *c)
 {
-       /* FIXME: not supported by platform private API */
-       return -EINVAL;
+       /* Only in cyclic mode */
+       if (!c->cyclic)
+               return -EINVAL;
+
+       if (!c->paused) {
+               omap_stop_dma(c->dma_ch);
+               c->paused = true;
+       }
+
+       return 0;
 }

 static int omap_dma_resume(struct omap_chan *c)
 {
-       /* FIXME: not supported by platform private API */
-       return -EINVAL;
+       /* Only in cyclic mode */
+       if (!c->cyclic)
+               return -EINVAL;
+
+       if (c->paused) {
+               omap_start_dma(c->dma_ch);
+               c->paused = false;
+       }
+
+       return 0;
 }


2.
arch/arm/plat-omap/dma.c
+void omap_pause_linked_dma(int lch)
+{
+       u32 l;
+       unsigned long flags;
+
+       local_irq_save(flags);
+       l = p->dma_read(CDP, lch);
+       l |= 0x80; /* PAUSE_LINK_LIST */
+       p->dma_write(l, CDP, lch);
+       local_irq_restore(flags);
+}
+EXPORT_SYMBOL(omap_pause_linked_dma);
+
+void omap_resume_linked_dma(int lch)
+{
+       u32 l;
+       unsigned long flags;
+
+       local_irq_save(flags);
+       l = p->dma_read(CDP, lch);
+       l &= (~0x80); /* PAUSE_LINK_LIST */
+       p->dma_write(l, CDP, lch);
+       local_irq_restore(flags);
+}
+EXPORT_SYMBOL(omap_resume_linked_dma);

drivers/dma/omap-dma.c
 static int omap_dma_pause(struct omap_chan *c)
 {
-       /* FIXME: not supported by platform private API */
-       return -EINVAL;
+       /* Only in cyclic mode */
+       if (!c->cyclic)
+               return -EINVAL;
+
+       if (!c->paused) {
+               omap_pause_linked_dma(c->dma_ch);
+               c->paused = true;
+       }
+
+       return 0;
 }

 static int omap_dma_resume(struct omap_chan *c)
 {
-       /* FIXME: not supported by platform private API */
-       return -EINVAL;
+       /* Only in cyclic mode */
+       if (!c->cyclic)
+               return -EINVAL;
+
+       if (c->paused) {
+               omap_resume_linked_dma(c->dma_ch);
+               c->paused = false;
+       }
+
+       return 0;
 }


Both works fine (have tested it on BeagleBoard with mplayer).
With [1] we have identical way of dealing with the PAUSE/RESUME as we had
previously, so it is know to work fine on OMAP1/2/3/4/5

We have never used [2] in the past, but I think that is not going to work on
OMAP1 and OMAP2420. Also we need to add code to arch/arm/plat-omap/dma.c for
this...

I can resend the series with either of these to fix this regression caused by
the dmaengine conversion (after cleanup off course).

-- 
Péter
