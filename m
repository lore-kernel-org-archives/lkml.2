Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569Ab2H1Qpw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 12:45:52 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:4534 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752572Ab2H1Qpu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 12:45:50 -0400
X-Server-Uuid: 06151B78-6688-425E-9DE2-57CB27892261
Message-ID: <503CF5B3.8040201@broadcom.com>
Date: Tue, 28 Aug 2012 09:45:39 -0700
From: "Franky Lin" <frankyl@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714
 Thunderbird/14.0
MIME-Version: 1.0
To: "Wei Ni" <wni@nvidia.com>
cc: "Stephen Warren" <swarren@wwwdotorg.org>,
        "Arend van Spriel" <arend@broadcom.com>,
        "rvossen@broadcom.com" <rvossen@broadcom.com>,
        "Rakesh Kumar" <krakesh@nvidia.com>,
        "Laxman Dewangan" <ldewangan@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>
Subject: Re: [PATCH 2/6] brcmfmac: Handling the interrupt in ISR
 directly for non-OOB
References: <1346063114-30361-1-git-send-email-wni@nvidia.com>
 <1346063114-30361-3-git-send-email-wni@nvidia.com>
 <503B9F31.5050502@broadcom.com> <503BD345.6030501@wwwdotorg.org>
 <1346152413.3516.211.camel@tegra-chromium-2>
In-Reply-To: <1346152413.3516.211.camel@tegra-chromium-2>
X-WSS-ID: 7C222AF53MK25438571-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/28/2012 04:13 AM, Wei Ni wrote:
> On Tue, 2012-08-28 at 04:06 +0800, Stephen Warren wrote:
>> On 08/27/2012 09:24 AM, Arend van Spriel wrote:
>>> On 08/27/2012 12:25 PM, Wei Ni wrote:
>>>> In case of inband interrupts, if we handle the interrupt in dpc thread,
>>>> two level of thread switching takes place to process wifi interrupts.
>>>> One in SDHCI driver and the other in Wifi driver. This may cause the
>>>> system
>>>> instability.
>>>
>>> Looking into the sdhci/mmc code indeed shows that the brcmfmac irq
>>> handler is not called in true IRQ context. So the dpc thread may add
>>> unnecessary complexity, but to me there is not indication that there is
>>> a stability issue.
>
> The brcmfmac irq handler is called in the thread sdio_irq_thread(), this
> thread indeed is driven by the sdhci irq, although it's not the true IRQ
> context. If the brcmfmac doesn't clear the IRQ condition ASAP, the
> sdio_irq_thread will be triggered again and again, and in this condition
> it's too difficult to run the brcmfmac dpc thread, more and more
> interrupt can't be handled.
>
>>>
>>>> Because the SDHCI calls sdio_irq_thread() to handle the irq, this
>>>> thread locks
>>>> mmc host and calls wifi handler. It expects WiFi handler to be quick and
>>>> enables sdio interrupt from card at end. If wifi handler defers this
>>>> work for
>>>> a different thread, sdio_irq_thread() will be stuck on next wifi
>>>> interrupt
>>>> since mmc lock is not freed.
>>>
>>> Not sure if I can follow this explanation. The isr is called with host
>>> claimed (by sdio_irq_thread) and all it does is at a linked list member
>>> and signal the dpc thread. After doing this the host is released.
>>
>> Is the issue something like the ISR handler or first level of threading
>> does:
>>
>> * Trigger DPC
>> * Re-enable interrupt
>>
>> So that the interrupt then fires again before the triggered DPC can run
>> to handle/clear it, thus causing an interrupt storm?
>>
>> Whereas handling the interrupt directly prevents this race condition?
>
> Above is my understanding.
>

Hi Wei,

I understand the issue here and totally agree that we should treat 
in-band and out-band interrupts differently. But my concern is that the 
behavior of releasing the host before calling brcmf_sdbrcm_isr and grab 
it after is likely error prone. Also we are restructuring the dpc 
routine internally and it's almost done. I will find a better solution 
for in-band interrupt and get it the queue as well. So I suggest 
dropping this patch.

Thanks,
Franky

