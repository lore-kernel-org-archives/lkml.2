Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752514Ab1DUST1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 14:19:27 -0400
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:55230 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751888Ab1DUSTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 14:19:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=nanometrics.ca; s=google;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=CtzjChlFmqsNgcud4CjovLzcH+qnbd40iUNnMZ99fJl4UQ7YicJe9CN8njlvBQ5t6d
         GVPxcVbQprSGCAvH4LqRoKeSd8+j0VTcDQE0u/LSQZgIB7OM3GW2nGld225GUXZlKLYA
         7dwdpvMLDK/ycs4PYKmOfElk9s2WLWyqvnXjo=
From: Ben Gardiner <bengardiner@nanometrics.ca>
To: Liam Girdwood <lrg@slimlogic.co.uk>, alsa-devel@alsa-project.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Sekhar Nori <nsekhar@ti.com>,
        davinci-linux-open-source@linux.davincidsp.com,
        James Nuss <jamesnuss@nanometrics.ca>, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] davinci-mcasp: fix _CBM_CFS pin directions
Date: Thu, 21 Apr 2011 14:19:04 -0400
Message-Id: <a3e514e0152efcd95a7b07401889c4f30c3a092c.1303408522.git.bengardiner@nanometrics.ca>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <cover.1303408522.git.bengardiner@nanometrics.ca>
References: <cover.1303408522.git.bengardiner@nanometrics.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current davinci_mcasp_set_dai_fmt() sets bits ACLKX and ACLKR in the PDIR
register for the codec clock-master/frame-slave mode; however, this results in
the ACLKX and ACLKR pins being outputs according to SPRUFM1 [1]  which
conflicts with "codec is clock master."

Similarly to the previous patch in this series, "fix _CBM_CFS hw_params" --
For codec clock-master/frame-slave mode (_CMB_CFS), clear bits ACLKX and ACLKR
in the PDIR register to set the pins as inputs and hence allow externally
sourced bit-clocks.

[1] http://www.ti.com/litv/pdf/sprufm1

Signed-off-by: Ben Gardiner <bengardiner@nanometrics.ca>
Reviewed-by: James Nuss <jamesnuss@nanometrics.ca>
---
 sound/soc/davinci/davinci-mcasp.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/sound/soc/davinci/davinci-mcasp.c b/sound/soc/davinci/davinci-mcasp.c
index 8004643..0a3d891 100644
--- a/sound/soc/davinci/davinci-mcasp.c
+++ b/sound/soc/davinci/davinci-mcasp.c
@@ -445,8 +445,10 @@ static int davinci_mcasp_set_dai_fmt(struct snd_soc_dai *cpu_dai,
 		mcasp_clr_bits(base + DAVINCI_MCASP_ACLKRCTL_REG, ACLKRE);
 		mcasp_set_bits(base + DAVINCI_MCASP_RXFMCTL_REG, AFSRE);
 
+		mcasp_clr_bits(base + DAVINCI_MCASP_PDIR_REG,
+				ACLKX | ACLKR);
 		mcasp_set_bits(base + DAVINCI_MCASP_PDIR_REG,
-				ACLKX | AFSX | ACLKR | AFSR);
+				AFSX | AFSR);
 		break;
 	case SND_SOC_DAIFMT_CBM_CFM:
 		/* codec is clock and frame master */
-- 
1.7.1

