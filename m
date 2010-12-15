Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752283Ab0LOJiU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 04:38:20 -0500
Received: from thoth.sbs.de ([192.35.17.2]:22703 "EHLO thoth.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752146Ab0LOJiS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 04:38:18 -0500
Message-ID: <4D088C77.8030701@siemens.com>
Date: Wed, 15 Dec 2010 10:37:59 +0100
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
References: <cover.1292281184.git.jan.kiszka@web.de> <a59c76552ebeaa128022ba9bcc7ea0753b312447.1292281184.git.jan.kiszka@web.de> <alpine.LFD.2.00.1012142243540.12146@localhost6.localdomain6> <4D07F738.8080204@web.de> <alpine.LFD.2.00.1012150903560.12146@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1012150903560.12146@localhost6.localdomain6>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 15.12.2010 09:05, Thomas Gleixner wrote:
> On Wed, 15 Dec 2010, Jan Kiszka wrote:
> 
>> Am 14.12.2010 22:46, Thomas Gleixner wrote:
>>> On Mon, 13 Dec 2010, Jan Kiszka wrote:
>>>> From: Jan Kiszka <jan.kiszka@siemens.com>
>>>>  	chip_bus_lock(desc);
>>>>  	retval = __setup_irq(irq, desc, action);
>>>>  	chip_bus_sync_unlock(desc);
>>>>  
>>>> -	if (retval)
>>>> +	if (retval) {
>>>> +		if (desc->action && !desc->action->next)
>>>> +			desc->irq_data.drv_status &= ~IRQS_SHARED;
>>>
>>> This is redundant. IRQS_SHARED gets set in a code path where all
>>> checks are done already.
>>
>> Nope, it's also set before entry of __setup_irq in case we call an
>> IRQF_ADAPTIVE handler.
>>
>> We need to set it that early as we may race with IRQ events for the
>> already registered handler happening between the sharing notification
>> and the actual registration of the second handler.
> 
> Hmm, ok. Though the MAKE_SHAREABLE flag should be sufficient to do the
> notification.

For notification, yes. But we need SHARED once we reenable the line
after the notification.

Jan

-- 
Siemens AG, Corporate Technology, CT T DE IT 1
Corporate Competence Center Embedded Linux
