Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932345Ab1JRMHp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 08:07:45 -0400
Received: from server655-han.de-nserver.de ([85.158.177.45]:47411 "EHLO
	server655-han.de-nserver.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932223Ab1JRMHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 08:07:41 -0400
Message-ID: <4E9D6C0A.1030801@profihost.ag>
Date: Tue, 18 Oct 2011 14:07:38 +0200
From: Philipp Herz - Profihost AG <p.herz@profihost.ag>
Reply-To: p.herz@profihost.ag
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
To: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Vanilla-Kernel 3 - page allocation failure
References: <4E9D53FF.7090609@profihost.ag> <20111018113251.GA3782@oc1711230544.ibm.com>
In-Reply-To: <20111018113251.GA3782@oc1711230544.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-User-Auth: Auth by p.herz@profihost.ag through 85.158.179.66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Cascardo,

thanks for your detailed answer!

I have uploaded two call traces to pastebin for further investigation.

Maybe this can help you.

* http://pastebin.com/Psg2dGYC (kworker)
* http://pastebin.com/pPFjZqxL (php5)

Regards,
Philipp


Am 18.10.2011 13:32, schrieb Thadeu Lima de Souza Cascardo:
> On Tue, Oct 18, 2011 at 12:25:03PM +0200, Philipp Herz - Profihost AG wrote:
>> After updating kernel (x86_64) to stable version 3 there are a few
>> messages appearing in the kernel log such as
>>
>> kworker/0:1: page allocation failure: order:1, mode:0x20
>> mysql: page allocation failure: order:1, mode:0x20
>> php5: page allocation failure: order:1, mode:0x20
>>
>> Searching the net showed that these messages are known to occur since 2004.
>>
>> Some people were able to get rid of them by setting
>> /proc/sys/vm/min_free_kbytes to a high enough value. This does not
>> help in our case.
>>
>>
>> Is there a kernel comand line argument to avoid these messages?
>>
>> As of mm/page_alloc.c these messages are marked to be only warning
>> messages and would not appear if 'gpf_mask' was set to __GFP_NOWARN
>> in function warn_alloc_failed.
>>
>> How does this mask get set? Is it set by the "external" process
>> knocking at the memory manager?
>>
>
> Hello, Philipp.
>
> This happens when kernel tries to allocate memory, sometimes in response
> to some request by the user space, but also in other contexts. For
> example, an interrupt by a network driver may try to allocate memory. In
> this context, it will use GFP_ATOMIC as a mask, for example. The most
> usual flags in the kernel are GFP_KERNEL and GFP_ATOMIC.
>
>> What is the magic behind the 'order' and 'mode'?
>>
>
> The order is the binary log of the number of pages requested. So, order 1
> allocations are 2 pages, order 4 would be 16 pages, for example.
>
> The mode is, in fact, gfp_flags. 0x20 is GFP_ATOMIC. This kind of
> allocation cannot do IO or access the filesystem. Also, it cannot wait
> for reclaim memory from cache.
>
> This warning is usually followed by some statistics about memory use
> in your system. Please post it to give more information about this
> situation.
>
> I have watched some of this happen when lots of cache is used by some
> filesystems. Perhaps, some tweaking of the vm sysctl options may help,
> but I can point any magic tweaking right now.
>
> Regards,
> Cascardo.
>
>> I'm not a subscriber, so please CC me a copy of messages related to
>> the subject. I'm not sure if I can help much by looking at the
>> inside of the kernel, but I will try my best to answer any questions
>> concerning this issue.
>>
>> Best regards, Philipp
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>
