Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757393Ab2INObu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 10:31:50 -0400
Received: from service87.mimecast.com ([91.220.42.44]:43046 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757151Ab2INObs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 10:31:48 -0400
Message-ID: <50533FD1.6000005@arm.com>
Date: Fri, 14 Sep 2012 15:31:45 +0100
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: "arnd@arndb.de" <arnd@arndb.de>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "Tim (Xen.org)" <tim@xen.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v4 16/24] xen: clear IRQ_NOAUTOEN and IRQ_NOREQUEST
References: <alpine.DEB.2.02.1209141145150.29232@kaball.uk.xensource.com> <1347621207-11294-16-git-send-email-stefano.stabellini@eu.citrix.com> <505338E6.4050504@arm.com> <alpine.DEB.2.02.1209141508130.29232@kaball.uk.xensource.com> <50533D46.5000704@arm.com> <alpine.DEB.2.02.1209141527030.29232@kaball.uk.xensource.com>
In-Reply-To: <alpine.DEB.2.02.1209141527030.29232@kaball.uk.xensource.com>
X-Enigmail-Version: 1.5a1pre
X-OriginalArrivalTime: 14 Sep 2012 14:31:46.0196 (UTC) FILETIME=[AB115D40:01CD9285]
X-MC-Unique: 112091415314607301
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/09/12 15:28, Stefano Stabellini wrote:
> On Fri, 14 Sep 2012, Marc Zyngier wrote:
>> On 14/09/12 15:13, Stefano Stabellini wrote:
>>> On Fri, 14 Sep 2012, Marc Zyngier wrote:
>>>> On 14/09/12 12:13, Stefano Stabellini wrote:
>>>>> Reset the IRQ_NOAUTOEN and IRQ_NOREQUEST flags that are enabled by
>>>>> default on ARM. If IRQ_NOAUTOEN is set, __setup_irq doesn't call
>>>>> irq_startup, that is responsible for calling irq_unmask at startup time.
>>>>> As a result event channels remain masked.
>>>>>
>>>>> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
>>>>> Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
>>>>> ---
>>>>>  drivers/xen/events.c |    1 +
>>>>>  1 files changed, 1 insertions(+), 0 deletions(-)
>>>>>
>>>>> diff --git a/drivers/xen/events.c b/drivers/xen/events.c
>>>>> index 5ecb596..8ffb7b7 100644
>>>>> --- a/drivers/xen/events.c
>>>>> +++ b/drivers/xen/events.c
>>>>> @@ -836,6 +836,7 @@ int bind_evtchn_to_irq(unsigned int evtchn)
>>>>>  		struct irq_info *info = info_for_irq(irq);
>>>>>  		WARN_ON(info == NULL || info->type != IRQT_EVTCHN);
>>>>>  	}
>>>>> +	irq_clear_status_flags(irq, IRQ_NOREQUEST|IRQ_NOAUTOEN);
>>>>
>>>> This one just sent a shiver down my spine. Are you doing this for a PPI?
>>>
>>> Not really: even though there is just one source of event notifications
>>> (that is a PPI), we have many event channels. When a domain receives a
>>> notification (via the PPI), it checks on a bitmask to which event channel
>>> it corresponds. From the Linux point of view every event channel is a
>>> Linux irq belonging to the xen_dynamic_chip (see
>>> drivers/xen/events.c:xen_dynamic_chip).
>>>
>>> So here I am not doing this for the one PPI, but I am doing this for
>>> every Linux irq (of chip xen_dynamic_chip) that represents an event
>>> channel.
>>
>> So this is some sort of secondary interrupt controller, cascaded into
>> your GIC emulation,
>     
> I guess it could be seen as a secondary interrupt controller
> 
> 
>> and this patch only affects the xen_dynamic_chip?
> 
> Yep

Thanks. I feel relieved... ;-)

	M.
-- 
Jazz is not dead. It just smells funny...

