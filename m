Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933616Ab1I1Wwd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:52:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55119 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756017Ab1I1WvG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:51:06 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:49 2011
Message-Id: <20110928220149.093178233@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:03:09 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jarkko Nikula <jarkko.nikula@bitmer.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [225/244] ASoC: omap-mcbsp: Do not attempt to change DAI sysclk if stream is active
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jarkko Nikula <jarkko.nikula@bitmer.com>

commit 34c869855a28af3c6031d29e2267b5a3cce0d67d upstream.

Attempt to change McBSP CLKS source while another stream is active is not
safe after commit d135865 ("OMAP: McBSP: implement functional clock
switching via clock framework") in 2.6.37.

CLKS parent clock switching using clock framework have to idle the McBSP
before switching and then activate it again. This short break can cause a
DMA transaction error to already running stream which halts and recovers
only by closing and restarting the stream.

This goes more fatal after commit e2fa61d ("OMAP3: l3: Introduce
l3-interconnect error handling driver") in 2.6.39 where l3 driver detects a
severe timeout error and does BUG_ON().

Fix this by not changing any configuration in omap_mcbsp_dai_set_dai_sysclk
if the McBSP is already active. This test should have been here just from
the beginning anyway.

Signed-off-by: Jarkko Nikula <jarkko.nikula@bitmer.com>
Acked-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/soc/omap/omap-mcbsp.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/sound/soc/omap/omap-mcbsp.c
+++ b/sound/soc/omap/omap-mcbsp.c
@@ -516,6 +516,12 @@ static int omap_mcbsp_dai_set_dai_sysclk
 	struct omap_mcbsp_reg_cfg *regs = &mcbsp_data->regs;
 	int err = 0;
 
+	if (mcbsp_data->active)
+		if (freq == mcbsp_data->in_freq)
+			return 0;
+		else
+			return -EBUSY;
+
 	/* The McBSP signal muxing functions are only available on McBSP1 */
 	if (clk_id == OMAP_MCBSP_CLKR_SRC_CLKR ||
 	    clk_id == OMAP_MCBSP_CLKR_SRC_CLKX ||


