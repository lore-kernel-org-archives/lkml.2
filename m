Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755154Ab2DSMWR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 08:22:17 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:27337
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752661Ab2DSMWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 08:22:16 -0400
X-IronPort-AV: E=Sophos;i="4.75,446,1330902000"; 
   d="scan'208";a="140796343"
Date: Thu, 19 Apr 2012 14:21:59 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Takashi Iwai <tiwai@suse.de>
cc: Jaroslav Kysela <perex@perex.cz>, kernel-janitors@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sound/isa/sc6000.c: add missing sc6000_setup_board
In-Reply-To: <s5h8vhs6iyf.wl%tiwai@suse.de>
Message-ID: <alpine.DEB.2.02.1204191418420.1866@hadrien>
References: <1334817640-15426-1-git-send-email-Julia.Lawall@lip6.fr> <s5h8vhs6iyf.wl%tiwai@suse.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Apr 2012, Takashi Iwai wrote:

> At Thu, 19 Apr 2012 08:40:40 +0200,
> Julia Lawall wrote:
>>
>> From: Julia Lawall <Julia.Lawall@lip6.fr>
>>
>> There seems to be no interaction between *port and the requested region, so
>> the clearing of *vport should take place if the request_region fails.
>>
>> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
>>
>> ---
>> Not tested.  sc6000_setup_board seems rather complicated, so my reasoning
>> could be completely wrong.
>
> This setup is called first at sc6000_init_board(), which is called
> much later than these error paths.  So, I don't think the need to call
> sc6000_setup_board(*vport, 0) at err_unmap1.

Thanks for the feedback.  I guess then it is not needed on the failure 
of devm_ioport_map either.  Is it needed on the failure of 
sc6000_init_board?  That can fail either before or after the calls to 
sc6000_setup_board hav taken place.

thanks,
julia



>
>
> thanks,
>
> Takashi
>
>>
>>  sound/isa/sc6000.c |    5 +++--
>>  1 file changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/sound/isa/sc6000.c b/sound/isa/sc6000.c
>> index d97d0f3..57679cb 100644
>> --- a/sound/isa/sc6000.c
>> +++ b/sound/isa/sc6000.c
>> @@ -594,7 +594,7 @@ static int __devinit snd_sc6000_probe(struct device *devptr, unsigned int dev)
>>  		snd_printk(KERN_ERR PFX
>>  			   "I/O port cannot be iomaped.\n");
>>  		err = -EBUSY;
>> -		goto err_unmap1;
>> +		goto err_unmap0;
>>  	}
>>
>>  	/* to make it marked as used */
>> @@ -678,9 +678,10 @@ static int __devinit snd_sc6000_probe(struct device *devptr, unsigned int dev)
>>  	return 0;
>>
>>  err_unmap2:
>> -	sc6000_setup_board(*vport, 0);
>>  	release_region(mss_port[dev], 4);
>>  err_unmap1:
>> +	sc6000_setup_board(*vport, 0);
>> +err_unmap0:
>>  	release_region(port[dev], 0x10);
>>  err_exit:
>>  	snd_card_free(card);
>>
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
