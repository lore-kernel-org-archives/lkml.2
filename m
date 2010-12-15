Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754251Ab0LOOTG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 09:19:06 -0500
Received: from thoth.sbs.de ([192.35.17.2]:24393 "EHLO thoth.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752839Ab0LOOTF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 09:19:05 -0500
Message-ID: <4D08CE44.6000407@siemens.com>
Date: Wed, 15 Dec 2010 15:18:44 +0100
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
References: <cover.1292281184.git.jan.kiszka@web.de> <a59c76552ebeaa128022ba9bcc7ea0753b312447.1292281184.git.jan.kiszka@web.de> <alpine.LFD.2.00.1012142147420.12146@localhost6.localdomain6> <4D07F70A.30209@web.de> <alpine.LFD.2.00.1012151357030.12146@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1012151357030.12146@localhost6.localdomain6>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 15.12.2010 14:04, Thomas Gleixner wrote:
> On Wed, 15 Dec 2010, Jan Kiszka wrote:
>> Am 14.12.2010 21:54, Thomas Gleixner wrote:
>>> On Mon, 13 Dec 2010, Jan Kiszka wrote:
>>>> @@ -943,6 +950,9 @@ static struct irqaction *__free_irq(unsigned int irq, void *dev_id)
>>>>  	/* Make sure it's not being used on another CPU: */
>>>>  	synchronize_irq(irq);
>>>>  
>>>> +	if (single_handler)
>>>> +		desc->irq_data.drv_status &= ~IRQS_SHARED;
>>>> +
>>>
>>> What's the reason to clear this flag outside of the desc->lock held
>>> region.
>>
>> We need to synchronize the irq first before clearing the flag.
>>
>> The problematic scenario behind this: An IRQ started in shared mode,
>> this the line was unmasked after the hardirq. Now we clear IRQS_SHARED
>> before calling into the threaded handler. And that handler may now think
>> that the line is still masked as IRQS_SHARED is set.
> 
> That should read "not set" I guess.

Can't remember who wrote this, but that guy might have been too tired
for clear sentences: Yes, of course, we could run into troubles, if
IRQS_SHARED was _not_ set while the IRQ line is unmasked between hard
and threaded handler.

> Hmm, needs more thoughts :(

Be warned, might be painful.

Jan

-- 
Siemens AG, Corporate Technology, CT T DE IT 1
Corporate Competence Center Embedded Linux
