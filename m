Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308Ab2BFOAk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 09:00:40 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:38429 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754408Ab2BFOAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 09:00:39 -0500
Message-ID: <4F2FDCFB.3010408@codemonkey.ws>
Date: Mon, 06 Feb 2012 08:00:27 -0600
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110922 Lightning/1.0b2 Thunderbird/3.1.15
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: KVM list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        Gleb Natapov <gleb@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [Qemu-devel] [RFC] Next gen kvm api
References: <4F2AB552.2070909@redhat.com>	<20120205093723.GQ23536@redhat.com>	<4F2E4F8B.8090504@redhat.com>	<20120205095153.GA29265@redhat.com>	<4F2EAFF6.7030006@codemonkey.ws>	<4F2F9E89.7090607@redhat.com> <4F2FD692.5060708@codemonkey.ws> <4F2FDB91.80200@redhat.com>
In-Reply-To: <4F2FDB91.80200@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06/2012 07:54 AM, Avi Kivity wrote:
> On 02/06/2012 03:33 PM, Anthony Liguori wrote:
>>> Look at arch/x86/kvm/i8254.c:pit_ioport_read() for a counterexample.
>>> There are also interactions with other devices (for example the
>>> apic/ioapic interaction via the apic bus).
>>
>>
>> Hrm, maybe I'm missing it, but the path that would be hot is:
>>
>> if (!status_latched&&  !count_latched) {
>>     value = kpit_elapsed()
>>     // manipulate count based on mode
>>     // mask value depending on read_state
>> }
>>
>> This path is side-effect free, and applies relatively simple math to a
>> time counter.
>
> Do guests always read an unlatched counter?  Doesn't seem reasonable
> since they can't get a stable count this way.

Perhaps.  You could have the latching done by writing to persisted scratch 
memory but then locking becomes an issue.

>> The idea would be to allow the filter to not handle an I/O request
>> depending on existing state.  Anything that's modifies state (like
>> reading the latch counter) would drop to userspace.
>
> This restricts us to a subset of the device which is at the mercy of the
> guest.

Yes, but it provides an elegant solution to having a flexible way to do things 
in the fast path in a generic way without presenting additional security concerns.

A similar, albeit more complex and less elegant, approach would be to make use 
of something like the vtpm optimization to reflect certain exits back into 
injected code into the guest.  But this has the disadvantage of being very 
x86-centric and it's not clear if you can avoid double exits which would hurt 
the slow paths.

> We could define mmio registers for muldiv64, and for communicating over
> the APIC bus.  But then the device model for BPF ends up more
> complicated than the kernel devices we have put together.

Maybe what we really need is NaCL for kernel space :-D

Regards,

Anthony Liguori


