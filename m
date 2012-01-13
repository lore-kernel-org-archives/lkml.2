Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248Ab2AMGcQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 01:32:16 -0500
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:46280 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753066Ab2AMGcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 01:32:15 -0500
X-IronPort-AV: E=Sophos;i="4.71,502,1320620400"; 
   d="scan'208";a="139077624"
Date: Fri, 13 Jan 2012 07:32:12 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: lawall@pl-59034.rocq.inria.fr
To: Dong Aisheng-B29396 <B29396@freescale.com>
cc: Julia Lawall <Julia.Lawall@lip6.fr>, Liam Girdwood <lrg@ti.com>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/15] sound/soc/mxs/mxs-saif.c: add missing iounmap
In-Reply-To: <7FE21149F4667147B645348EC605788508FBDB@039-SN2MPN1-013.039d.mgd.msft.net>
Message-ID: <alpine.DEB.2.00.1201130731470.16047@pl-59034.rocq.inria.fr>
References: <1326362117-29371-1-git-send-email-Julia.Lawall@lip6.fr> <7FE21149F4667147B645348EC605788508FBDB@039-SN2MPN1-013.039d.mgd.msft.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jan 2012, Dong Aisheng-B29396 wrote:

>> -----Original Message-----
>> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
>> owner@vger.kernel.org] On Behalf Of Julia Lawall
>> Sent: Thursday, January 12, 2012 5:55 PM
>> To: Liam Girdwood
>> Cc: kernel-janitors@vger.kernel.org; Mark Brown; Jaroslav Kysela; Takashi Iwai;
>> alsa-devel@alsa-project.org; linux-kernel@vger.kernel.org
>> Subject: [PATCH 1/15] sound/soc/mxs/mxs-saif.c: add missing iounmap
>>
>> From: Julia Lawall <Julia.Lawall@lip6.fr>
>>
>> Add missing iounmap in error handling code, in a case where the function already
>> preforms iounmap on some other execution path.
>>
>> A simplified version of the semantic match that finds this problem is as
>> follows: (http://coccinelle.lip6.fr/)
>>
>> // <smpl>
>> @@
>> expression e;
>> statement S,S1;
>> int ret;
>> @@
>> e = \(ioremap\|ioremap_nocache\)(...)
>> ... when != iounmap(e)
>> if (<+...e...+>) S
>> ... when any
>>     when != iounmap(e)
>> *if (...)
>>    { ... when != iounmap(e)
>>      return ...; }
>> ... when any
>> iounmap(e);
>> // </smpl>
>>
>> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
>>
>> ---
>>  sound/soc/mxs/mxs-saif.c |    3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/sound/soc/mxs/mxs-saif.c b/sound/soc/mxs/mxs-saif.c index
>> 049e543..5ee0adb 100644
>> --- a/sound/soc/mxs/mxs-saif.c
>> +++ b/sound/soc/mxs/mxs-saif.c
>> @@ -680,7 +680,7 @@ static int mxs_saif_probe(struct platform_device *pdev)
>>  		ret = -ENODEV;
>>  		dev_err(&pdev->dev, "failed to get dma resource: %d\n",
>>  			ret);
>> -		goto failed_ioremap;
>> +		goto failed_get_resource;
>>  	}
>>  	saif->dma_param.chan_num = dmares->start;
>>
>> @@ -739,6 +739,7 @@ failed_register:
>>  failed_get_irq2:
>>  	free_irq(saif->irq, saif);
>>  failed_get_irq1:
>> +failed_get_resource:
> There's already a 'failed_get_resource' there, wouldn't your change break
> The original code?
>
> BTW, I guess a better way is that you can submit a patch to change the driver
> To use devm_alloc_* and it's friend routines, then we do not need to fix
> Such things any more.

Thanks for the suggestions.  I will fix it up with the devm_ solution.

julia
