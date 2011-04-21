Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677Ab1DUST3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 14:19:29 -0400
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:34301 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751816Ab1DUSTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 14:19:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=nanometrics.ca; s=google;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=SqVnwZsHN/Jyg8WONjYdczbnnjrwTlOlS6sEtn6/5tzGxthOifSBwWEMm8UMiNPs7t
         rIvjrIhL9017+xdF4d0AX7ZicbNmLgglACoOVt3Od69533Wf2HJURB9KKbLeta44Ty75
         WRrq9NQ1+8K9PQd8sH0Zd+s9O6woaRDDLaONU=
From: Ben Gardiner <bengardiner@nanometrics.ca>
To: Liam Girdwood <lrg@slimlogic.co.uk>, alsa-devel@alsa-project.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Sekhar Nori <nsekhar@ti.com>,
        davinci-linux-open-source@linux.davincidsp.com,
        James Nuss <jamesnuss@nanometrics.ca>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] davinci-mcasp: fix _CBM_CFS hw_params
Date: Thu, 21 Apr 2011 14:19:03 -0400
Message-Id: <831ad13442c7bca120d24d8679da614b20a0090d.1303408522.git.bengardiner@nanometrics.ca>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <cover.1303408522.git.bengardiner@nanometrics.ca>
References: <cover.1303408522.git.bengardiner@nanometrics.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current davinci_mcasp_set_dai_fmt() sets bits ACLKXE and ACLKRE (CLKXM
and CLKRM as they are reffered to in SPRUFM1 [1]) for codec clock-slave/
frame-slave mode (_CBS_CFS) which selects internally generated bit-clock and
frame-sync signals; however, it does the same thing again for codec
clock-master/frame-slave mode (_CBM_CFS) in the very next case statement which
is incorrectly selecting internally generated bit-clocks in this mode.

For codec clock-master/frame-slave mode (_CBM_CFS), clear bits ACLKXE and
ACLKRE to select externally-generated bit-clocks.

[1] http://www.ti.com/litv/pdf/sprufm1

Signed-off-by: Ben Gardiner <bengardiner@nanometrics.ca>
Reviewed-by: James Nuss <jamesnuss@nanometrics.ca>
---
 sound/soc/davinci/davinci-mcasp.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/davinci/davinci-mcasp.c b/sound/soc/davinci/davinci-mcasp.c
index 1aa24a1..8004643 100644
--- a/sound/soc/davinci/davinci-mcasp.c
+++ b/sound/soc/davinci/davinci-mcasp.c
@@ -439,10 +439,10 @@ static int davinci_mcasp_set_dai_fmt(struct snd_soc_dai *cpu_dai,
 		break;
 	case SND_SOC_DAIFMT_CBM_CFS:
 		/* codec is clock master and frame slave */
-		mcasp_set_bits(base + DAVINCI_MCASP_ACLKXCTL_REG, ACLKXE);
+		mcasp_clr_bits(base + DAVINCI_MCASP_ACLKXCTL_REG, ACLKXE);
 		mcasp_set_bits(base + DAVINCI_MCASP_TXFMCTL_REG, AFSXE);
 
-		mcasp_set_bits(base + DAVINCI_MCASP_ACLKRCTL_REG, ACLKRE);
+		mcasp_clr_bits(base + DAVINCI_MCASP_ACLKRCTL_REG, ACLKRE);
 		mcasp_set_bits(base + DAVINCI_MCASP_RXFMCTL_REG, AFSRE);
 
 		mcasp_set_bits(base + DAVINCI_MCASP_PDIR_REG,
-- 
1.7.1

