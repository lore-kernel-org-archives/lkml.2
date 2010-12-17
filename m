Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546Ab0LQKcb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 05:32:31 -0500
Received: from thoth.sbs.de ([192.35.17.2]:23456 "EHLO thoth.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752698Ab0LQKca (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 05:32:30 -0500
Message-ID: <4D0B3C11.4090307@siemens.com>
Date: Fri, 17 Dec 2010 11:31:45 +0100
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Jan Kiszka <jan.kiszka@web.de>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kvm <kvm@vger.kernel.org>, Tom Lyon <pugs@cisco.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v3 2/4] genirq: Inform handler about line sharing state
References: <cover.1292281184.git.jan.kiszka@web.de> <a59c76552ebeaa128022ba9bcc7ea0753b312447.1292281184.git.jan.kiszka@web.de> <alpine.LFD.2.00.1012161410440.12146@localhost6.localdomain6> <4D0A75E3.3090900@web.de> <4D0B1CD9.5060601@web.de> <alpine.LFD.2.00.1012171116480.12146@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1012171116480.12146@localhost6.localdomain6>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 17.12.2010 11:23, Thomas Gleixner wrote:
> On Fri, 17 Dec 2010, Jan Kiszka wrote:
>> Am 16.12.2010 21:26, Jan Kiszka wrote:
>>> Am 16.12.2010 14:13, Thomas Gleixner wrote:
>>>> On Mon, 13 Dec 2010, Jan Kiszka wrote:
>>>>> +	if (old_action && (old_action->flags & IRQF_ADAPTIVE) &&
>>>>> +	    !(desc->irq_data.drv_status & IRQS_SHARED)) {
>>>>> +		/*
>>>>> +		 * Signal the old handler that is has to switch to shareable
>>>>> +		 * handling mode. Disable the line to avoid any conflict with
>>>>> +		 * a real IRQ.
>>>>> +		 */
>>>>> +		disable_irq(irq);
>>>>
>>>> This is weird, really. I thought you wanted to avoid waiting for the
>>>> threaded handler to finish if it's on the fly. So this should be
>>>> disable_irq_nosync() or did you change your mind ?
>>>
>>> No, I did not. I wanted to avoid that we set MAKE_SHAREABLE while there
>>> might be another IRQ in flight. The handler that is called due to a real
>>> IRQ might misinterpret MAKE_SHAREABLE as "there is no real event" and
>>> perform the wrong steps (at least the current implementation for KVM would).
>>
>> Actually, the requirement we have to fulfill here is to avoid that the
>> hardirq handler sees !SHARED while the threaded one reads "SHARED". To
>> achieve this without disabling the line, I'm still searching for a way
>> to couple the sharing state of associated hard and threaded handler runs
>> - but I think there is no reliable association, is there?
> 
> Unfortunately not. So the only way to solve that is disabling the
> interrupt which makes sure that all handlers have completed.

Hmm, what a pity.

> 
> OTOH, if we have to disable anyway, then we could simply keep it
> disabled across the installation of a new handler. That would make the
> notification business go away, wouldn't it ?

No, the notification is still necessary in case the registered handler
keeps the line off after returning from both hard and threaded handler.

Jan

-- 
Siemens AG, Corporate Technology, CT T DE IT 1
Corporate Competence Center Embedded Linux
