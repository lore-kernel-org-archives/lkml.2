Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116Ab2AaLKN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 06:10:13 -0500
Received: from relmlor4.renesas.com ([210.160.252.174]:56770 "EHLO
	relmlor4.renesas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753913Ab2AaLKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 06:10:10 -0500
X-Greylist: delayed 395 seconds by postgrey-1.27 at vger.kernel.org; Tue, 31 Jan 2012 06:10:10 EST
X-IronPort-AV: E=Sophos;i="4.71,595,1320591600";   d="scan'208";a="65921406"
Message-id: <4F27CA7D.601@renesas.com>
Date: Tue, 31 Jan 2012 20:03:25 +0900
From: "Shimoda, Yoshihiro" <yoshihiro.shimoda.uh@renesas.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:9.0) Gecko/20111222
 Thunderbird/9.0.1
MIME-version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
        Vinod Koul <vinod.koul@intel.com>, Magnus Damm <magnus.damm@gmail.com>,
        linux-mmc@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-serial@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH 1/7 v2] dmaengine: add a simple dma library
References: <1327589784-4287-1-git-send-email-g.liakhovetski@gmx.de>
 <1327589784-4287-2-git-send-email-g.liakhovetski@gmx.de>
 <4F22624E.2090201@renesas.com>
 <Pine.LNX.4.64.1201270946150.32661@axis700.grange>
In-reply-to: <Pine.LNX.4.64.1201270946150.32661@axis700.grange>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guennadi-san,

2012/01/27 17:48, Guennadi Liakhovetski wrote:
> Hi Shimoda-san
> 
> On Fri, 27 Jan 2012, Shimoda, Yoshihiro wrote:
[ snip ]
>>>
>>> 1. switch from using a tasklet to threaded IRQ, which allowed to
>>
>> I tested this driver on 2 environment, but it could not work correctly.
>>  - renesas_usbhs driver with shdma driver on the mackerel board
>>  - renesas_usbhs driver with experimental SUDMAC driver
>>
>> In this case, should we modify the renesas_usbhs driver?
> 
> Yes, you do. Please, see the respective version of the shdma patch. It 
> doesn't request channel IRQs any more directly, instead, it uses a 
> dma-simple wrapper function. Also operations change a bit.

Thank you for your comment.

I investigaed the issue. I found out the renesas_usbhs driver may
call tx_submit() in the callback() of the dma-simple finally.
In this case, the value of power_up in the simple_tx_submit is 0,
the start_xfer() is not called. And then, even if the ld_queue is
not empty, the DMA doesn't start.


So, if I add codes like the following in the dma-simple.c,
the renesas_usbhs driver can work correctly without the driver changes.
If you think the code is good, would you merge it to your code?
======= chan_irqt() =======
	simple_chan_ld_cleanup(schan, false);

+	spin_lock_irq(&schan->chan_lock);
+	/* Next desc */
+	simple_chan_xfer_ld_queue(schan);
+	spin_unlock_irq(&schan->chan_lock);

	return IRQ_HANDLED;
==============

Best regards,
Yoshihiro Shimoda

> Thanks
> Guennadi
> 
>> For reference, if I changed the threaded IRQ to tasklet,
>> the 2 environment worked correctly:
>> ==============
>> diff --git a/drivers/dma/dma-simple.c b/drivers/dma/dma-simple.c
>> index 49d8f7d..65a5170 100644
>> --- a/drivers/dma/dma-simple.c
>> +++ b/drivers/dma/dma-simple.c
>> @@ -715,16 +715,18 @@ static irqreturn_t chan_irq(int irq, void *dev)
>>
>>  	spin_lock(&schan->chan_lock);
>>
>> -	ret = ops->chan_irq(schan, irq) ? IRQ_WAKE_THREAD : IRQ_NONE;
>> +	ret = ops->chan_irq(schan, irq) ? IRQ_HANDLED : IRQ_NONE;
>> +	if (ret == IRQ_HANDLED)
>> +		tasklet_schedule(&schan->tasklet);
>>
>>  	spin_unlock(&schan->chan_lock);
>>
>>  	return ret;
>>  }
>>
>> -static irqreturn_t chan_irqt(int irq, void *dev)
>> +static void chan_irqt(unsigned long dev)
>>  {
>> -	struct dma_simple_chan *schan = dev;
>> +	struct dma_simple_chan *schan = (struct dma_simple_chan *)dev;
>>  	const struct dma_simple_ops *ops =
>>  		to_simple_dev(schan->dma_chan.device)->ops;
>>  	struct dma_simple_desc *sdesc;
>> @@ -744,15 +746,13 @@ static irqreturn_t chan_irqt(int irq, void *dev)
>>  	spin_unlock_irq(&schan->chan_lock);
>>
>>  	simple_chan_ld_cleanup(schan, false);
>> -
>> -	return IRQ_HANDLED;
>>  }
>>
>>  int dma_simple_request_irq(struct dma_simple_chan *schan, int irq,
>>  			   unsigned long flags, const char *name)
>>  {
>> -	int ret = request_threaded_irq(irq, chan_irq, chan_irqt,
>> -				       flags, name, schan);
>> +	int ret = request_irq(irq, chan_irq, flags, name, schan);
>> +	tasklet_init(&schan->tasklet, chan_irqt, (unsigned long)schan);
>>
>>  	schan->irq = ret < 0 ? ret : irq;
>>
>> diff --git a/include/linux/dma-simple.h b/include/linux/dma-simple.h
>> index 5336674..beb1489 100644
>> --- a/include/linux/dma-simple.h
>> +++ b/include/linux/dma-simple.h
>> @@ -68,6 +68,7 @@ struct dma_simple_chan {
>>  	int id;				/* Raw id of this channel */
>>  	int irq;			/* Channel IRQ */
>>  	enum dma_simple_pm_state pm_state;
>> +	struct tasklet_struct tasklet;
>>  };
>>
>>  /**
>> ==============
>>
>> Best regards,
>> Yoshihiro Shimoda
>>
> 
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
> 


-- 
Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
EC No.
