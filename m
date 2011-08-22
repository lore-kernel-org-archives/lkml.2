Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828Ab1HVODq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 10:03:46 -0400
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:33508
	"EHLO DB3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752018Ab1HVODp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 10:03:45 -0400
X-SpamScore: -14
X-BigFish: VS-14(zz148cM1432N98dKzz1202hzzz2dh2a8h668h839h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Message-ID: <4E5261A5.5050608@freescale.com>
Date: Mon, 22 Aug 2011 09:03:17 -0500
From: Timur Tabi <timur@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.19) Gecko/20110429 Fedora/3.6.17-1.fc13 Firefox/3.6.17
MIME-Version: 1.0
To: Julia Lawall <julia@diku.dk>
CC: <kernel-janitors@vger.kernel.org>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        <alsa-devel@alsa-project.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH] sound/soc/fsl/fsl_dma.c: add missing of_node_put
References: <1313825025-17590-1-git-send-email-julia@diku.dk>
In-Reply-To: <1313825025-17590-1-git-send-email-julia@diku.dk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Julia Lawall wrote:
> diff --git a/sound/soc/fsl/fsl_dma.c b/sound/soc/fsl/fsl_dma.c
> index 0efc04a..b33271b 100644
> --- a/sound/soc/fsl/fsl_dma.c
> +++ b/sound/soc/fsl/fsl_dma.c
> @@ -880,10 +880,12 @@ static struct device_node *find_ssi_node(struct device_node *dma_channel_np)
>  		np = of_parse_phandle(ssi_np, "fsl,playback-dma", 0);
>  		if (np == dma_channel_np)
>  			return ssi_np;
> +		of_node_put(np);
>  
>  		np = of_parse_phandle(ssi_np, "fsl,capture-dma", 0);
>  		if (np == dma_channel_np)
>  			return ssi_np;
> +		of_node_put(np);
>  	}

Thanks for catching the problem, Julia, but the fix is not quite correct.  My
code assumes that of_parse_phandle() doesn't claim the node, but it doesn't
actually use the node pointer, either.  All I care about is whether 'np' is
equal to dma_channel_np.  I'm not going to use 'np'.  So I think the real fix is
this:

@@ -880,10 +880,12 @@ static struct device_node *find_ssi_node(struct
device_node *dma_channel_np)
 		np = of_parse_phandle(ssi_np, "fsl,playback-dma", 0);
+		of_node_put(np);
 		if (np == dma_channel_np)
 			return ssi_np;

 		np = of_parse_phandle(ssi_np, "fsl,capture-dma", 0);
+		of_node_put(np);
 		if (np == dma_channel_np)
 			return ssi_np;
 	}

 	return NULL;

-- 
Timur Tabi
Linux kernel developer at Freescale

