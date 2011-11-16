Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754442Ab1KPJBD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 04:01:03 -0500
Received: from metasoft.pl ([195.149.224.191]:34939 "EHLO smtp.metasoft.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752591Ab1KPJBB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 04:01:01 -0500
X-clamdmail: clamdmail 0.18a
Message-ID: <4EC37BBE.6030008@metasoft.pl>
Date: Wed, 16 Nov 2011 10:00:46 +0100
From: Rafal Prylowski <prylowski@metasoft.pl>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: H Hartley Sweeten <hartleys@visionengravers.com>
CC: Mika Westerberg <mika.westerberg@iki.fi>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "rmallon@gmail.com" <rmallon@gmail.com>,
        "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "lrg@ti.com" <lrg@ti.com>
Subject: Re: [PATCH v2 1/5] dmaengine: add ep93xx DMA support
References: <cover.1306662317.git.mika.westerberg@iki.fi> <3ea8d56034f25cbe3fd8a4c31d7d0d1540b6ac7e.1306662317.git.mika.westerberg@iki.fi> <4EC27EED.4030108@metasoft.pl> <ADE657CA350FB648AAC2C43247A983F001F3E93FDC22@AUSP01VMBX24.collaborationhost.net>
In-Reply-To: <ADE657CA350FB648AAC2C43247A983F001F3E93FDC22@AUSP01VMBX24.collaborationhost.net>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

> Nice to see someone is trying to get IDE support for the ep93xx into mainline!
> Unfortunately none of my ep93xx hardware supports IDE... :-(
> 

This driver is a result of work of several people, which I've seen on linux-ide
mailing list. I only added this dmaengine support. I really would like to
see it in mainline, but I think it's still not ready for inclusion.

>>  	default:
>> @@ -668,24 +669,28 @@ static void ep93xx_dma_unmap_buffers(str
>>  static void ep93xx_dma_tasklet(unsigned long data)
>>  {
>>  	struct ep93xx_dma_chan *edmac = (struct ep93xx_dma_chan *)data;
>> -	struct ep93xx_dma_desc *desc, *d;
>> -	dma_async_tx_callback callback;
>> -	void *callback_param;
>> +	struct ep93xx_dma_desc *desc = NULL, *d;
>> +	dma_async_tx_callback callback = NULL;
>> +	void *callback_param = NULL;
>>  	LIST_HEAD(list);
>>  
>>  	spin_lock_irq(&edmac->lock);
>> -	desc = ep93xx_dma_get_active(edmac);
>> -	if (desc->complete) {
>> -		edmac->last_completed = desc->txd.cookie;
>> -		list_splice_init(&edmac->active, &list);
>> +	if (!list_empty(&edmac->active)) {
>> +		desc = ep93xx_dma_get_active(edmac);
>> +		if (desc->complete) {
>> +			edmac->last_completed = desc->txd.cookie;
>> +			list_splice_init(&edmac->active, &list);
>> +		}
> 
> It looks like this might actually catch your BUG_ON issue above.

Yes, I only inserted BUG_ON in ep93xx_dma_get_active() to be sure, that
nowhere else in code happens similar problem.
But now I'm not so sure, that I encountered bug in ep93xx_dma.c, or
maybe I'm misusing dmaengine api (calling dmaengine_termiante_all from
invalid context?). I don't have enough knowledge to judge this.

> 
>>  	}
>>  	spin_unlock_irq(&edmac->lock);
>>  
>>  	/* Pick up the next descriptor from the queue */
>>  	ep93xx_dma_advance_work(edmac);
>>  
>> -	callback = desc->txd.callback;
>> -	callback_param = desc->txd.callback_param;
>> +	if (desc) {
>> +		callback = desc->txd.callback;
>> +		callback_param = desc->txd.callback_param;
>> +	}
> 
> These could be moved up to where 'desc' is getting set.  You have already
> verified that the list is not empty and have a valid 'desc' pointer.  Set
> the callback pointers there to remove this extra if (desc) test.
> 

Following is a patch with suggestions applied (patch addressing problem with
incorrect programming of control register is in another mail sent in reply to
Mika Westerberg).

Regards,
Rafal Prylowski.

Index: linux-2.6/drivers/dma/ep93xx_dma.c
===================================================================
--- linux-2.6.orig/drivers/dma/ep93xx_dma.c
+++ linux-2.6/drivers/dma/ep93xx_dma.c
@@ -669,24 +669,25 @@ static void ep93xx_dma_tasklet(unsigned 
 {
 	struct ep93xx_dma_chan *edmac = (struct ep93xx_dma_chan *)data;
 	struct ep93xx_dma_desc *desc, *d;
-	dma_async_tx_callback callback;
-	void *callback_param;
+	dma_async_tx_callback callback = NULL;
+	void *callback_param = NULL;
 	LIST_HEAD(list);
 
 	spin_lock_irq(&edmac->lock);
-	desc = ep93xx_dma_get_active(edmac);
-	if (desc->complete) {
-		edmac->last_completed = desc->txd.cookie;
-		list_splice_init(&edmac->active, &list);
+	if (!list_empty(&edmac->active)) {
+		desc = ep93xx_dma_get_active(edmac);
+		if (desc->complete) {
+			edmac->last_completed = desc->txd.cookie;
+			list_splice_init(&edmac->active, &list);
+		}
+		callback = desc->txd.callback;
+		callback_param = desc->txd.callback_param;
 	}
 	spin_unlock_irq(&edmac->lock);
 
 	/* Pick up the next descriptor from the queue */
 	ep93xx_dma_advance_work(edmac);
 
-	callback = desc->txd.callback;
-	callback_param = desc->txd.callback_param;
-
 	/* Now we can release all the chained descriptors */
 	list_for_each_entry_safe(desc, d, &list, node) {
 		/*

