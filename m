Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751936Ab0EGBuG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 21:50:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45587 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751468Ab0EGBuE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 21:50:04 -0400
Message-ID: <4BE371AB.2000806@zytor.com>
Date: Thu, 06 May 2010 18:49:31 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       x86@kernel.org, linux-kernel@vger.kernel.org,
       Vadim Rozenfeld <vrozenfe@redhat.com>, Avi Kivity <avi@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Haiyang Zhang <haiyangz@microsoft.com>,
       Hank Janssen <hjanssen@microsoft.com>
Subject: Re: [PATCH] x86: detect running on a HyperV system
References: <20100506190841.GA1605@kroah.com> <4BE314CD.6060701@zytor.com> <20100506191816.GA20874@kroah.com>
In-Reply-To: <20100506191816.GA20874@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/2010 12:18 PM, Greg KH wrote:
> On Thu, May 06, 2010 at 12:13:17PM -0700, H. Peter Anvin wrote:
>> On 05/06/2010 12:08 PM, Greg KH wrote:
>>>
>>> x86-maintainers, we need this patch in the tree to get a -staging driver
>>> to work properly.  If you don't object, can I take it through the
>>> staging tree?  Or do you want to take it in -tip?
>>>
>>
>> I'd prefer to take it in -tip, partly because I would like to rework a
>> few things -- including preexisting braindamage like c->x86_hyper_vendor
>> (since when was hypervisor vendor a per-cpu property!?)
> 
> Heh, good point, but where should it live?
> 
> And I have no objection to taking it in -tip, thanks for doing so.
> 
>> I'll try to get to it today, if not feel free to bug me.
> 
> Will do :)
> 
> thanks again,
> 

Okay... we write something called x86_hyper_features, but it isn't
actually used for anything.  I'm assuming based on what I can see in
<asm/hyperv.h> that it is almost certainly not anything CPU-based.  I
really don't like a random field that can be stuffed with information
from random locations, and it doesn't look like it's even a flag field
in any meaningful way.  Worse, the field is just used to mix bits from
two different CPUID levels at what appears to be a completely arbitrary
boundary:

        /*
         * Extract the features, recommendations etc.
         * The first 9 bits will be used to track hypervisor features.
         * The next 6 bits will be used to track the hypervisor
         * recommendations.
         */
        cpuid(HYPERV_CPUID_FEATURES, &eax, &ebx, &ecx, &edx);
        c->x86_hyper_features |= (eax & 0x1ff);

        cpuid(HYPERV_CPUID_ENLIGHTMENT_INFO, &eax, &ebx, &ecx, &edx);
        c->x86_hyper_features |= ((eax & 0x3f) << 9);

Why 9?  Why 6?  The only thing that I can think of that justifies those
particular numbers is what the *current* version of Hyper-V does.

It would be better to just have a global variable where these two levels
are separately stuffed away instead of arbitrarily commingled (again,
I'm assuming none of the bits are actually per CPU.)

What does this driver of yours do with them?

	-hpa
