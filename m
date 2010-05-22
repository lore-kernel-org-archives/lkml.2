Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755317Ab0EVPVP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 11:21:15 -0400
Received: from sinclair.provo.novell.com ([137.65.248.137]:36224 "EHLO
	sinclair.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754614Ab0EVPVN convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-ksrinivasan@novell.com:5:1>);
	Sat, 22 May 2010 11:21:13 -0400
Message-Id: <4BF7A20602000030000859E3@sinclair.provo.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Sat, 22 May 2010 09:21:10 -0600
From: "Ky Srinivasan" <ksrinivasan@novell.com>
To: "Haiyang Zhang" <haiyangz@microsoft.com>, "Greg KH" <gregkh@suse.de>
Cc: "'devel@driverdev.osuosl.org'" <devel@driverdev.osuosl.org>,
       "'virtualization@lists.osdl.org'" <virtualization@lists.osdl.org>,
       "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/1] staging: hv: Fix race condition on IC channel
	 initialization
References: <1FB5E1D5CA062146B38059374562DF7266B8AE7C@TK5EX14MBXC128.redmond.corp.microsoft.com>
 <20100521201228.GA6712@suse.de>
 <1FB5E1D5CA062146B38059374562DF7266B8B5F2@TK5EX14MBXC128.redmond.corp.microsoft.com>
In-Reply-To: <1FB5E1D5CA062146B38059374562DF7266B8B5F2@TK5EX14MBXC128.redmond.corp.microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>>> On 5/21/2010 at  6:07 PM, in message
<1FB5E1D5CA062146B38059374562DF7266B8B5F2@TK5EX14MBXC128.redmond.corp.microsoft.
om>, Haiyang Zhang <haiyangz@microsoft.com> wrote: 
>>  From: Greg KH [mailto:gregkh@suse.de]
>> > +/* Counter of IC channels initialized */
>> > +atomic_t hv_utils_initcnt = ATOMIC_INIT(0);
>> 
>> This doesn't need to be an atomic variable, does it really?
>> 
>> Why not have a simple bool variable "vmbus_initialized" or something.
>> It starts out as false, and then turns true when you are up and ready.
>> Then provide a function that tests it:
>> 	bool hv_vmbus_ready(void)
>> 	{
>> 		return vmbus_initialized
>> 	}
>> 	EXPORT_SYMBOL_GPL(hv_vmbus_ready);
>> 
>> 
>> this turns into a simple function call, again, never needing to know
>> about message types or any other mess.
> 
> This looks good. I will add the hv_vmbus_ready() function. It doesn't even 
> have to be exported symbol, because it's only used in vmbus module to ensure 
> 
> all channels are ready before vmbus_init() returns. Other modules won't get 
> a 
> chance to see uninitialized channels after hv_vmbus is loaded.
> 
> Also, I'll cleanup the printk in hv_utils load/unload.
> 
> Regarding the atomic variable -- the channel offer processing function is 
> triggered by interrupts from host -- should we be concerned about "counter++" 
> racing with each other in two interrupts happening around the same time?
You would need to protect the increment, if interrupts are going to come in on any cpu and update the counter. While in your current implementation interrupts are only delivered on cpu0, it is still  probably good to deal with the more general case and protect the counter.

On a slightly different note, why don't you make the synchronization more explicit than what you currently have: Rather than polling the variable in a loop, why don't you put that context to sleep and the interrupt context that updates the count would be responsible for issuing the wakeup when the conditions are appropriate - when all channels are initialized.

Regards,

K. Y 
> 
> Thanks,
> 
> - Haiyang
> 
> _______________________________________________
> Virtualization mailing list
> Virtualization@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/virtualization


