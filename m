Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932729Ab2DDTfp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 15:35:45 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:41136 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932282Ab2DDTfn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 15:35:43 -0400
MIME-Version: 1.0
In-Reply-To: <CAMjP1KmkS9aBXJm1GEavhcNx75ib7G4m+xYBe3_PcGSo6t5FsQ@mail.gmail.com>
References: <CAMjP1Kka6MmT2zLc95ZQ=vigS6w9diS9-tawzdUdhbzzfzMh3w@mail.gmail.com>
	<CAMjP1KmDxhOKOGtgKt=OWbcXoJgrbA_rAxdkV4j7Y8XC8yjnuA@mail.gmail.com>
	<CAMjP1KmkS9aBXJm1GEavhcNx75ib7G4m+xYBe3_PcGSo6t5FsQ@mail.gmail.com>
Date: Wed, 4 Apr 2012 14:35:41 -0500
Message-ID: <CAMjP1KkwMuQY4eBxmQeK_8xa11fDWHu_401Tg3iiXtqnHGV0jw@mail.gmail.com>
Subject: Re: Crash in __netif_receive_skb
From: Avleen Vig <avleen@gmail.com>
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 29, 2012 at 4:42 PM, Avleen Vig <avleen@gmail.com> wrote:
> On Wed, Mar 28, 2012 at 10:01 PM, Avleen Vig <avleen@gmail.com> wrote:
>> On Wed, Mar 28, 2012 at 8:31 PM, Avleen Vig <avleen@gmail.com> wrote:
>>> Hi folks, someone in #kernel recommended I email these two lists. Hope
>>> they're the right place.
>>>
>>> We're running 2.6.32-220.4.1.el6.x86_64 on Centos 6.2, and getting a
>>> repeated crash:
>>>    https://gist.github.com/2231998
>>>
>>> We can make this happen pretty easily just by passing some network
>>> traffic and waiting a while.
>>> I couldn't find any references to this particular issue.
>>> I have vmcore files and am happy to dig into it if it would help (as
>>> long as someone can tell me what to do :))
>>
>> I hope this debugging is legit, I'm really new to this level of insight.
>>
>> I think the problem is in include/linux/netpoll.h, at the "if"
>> statement at line 86:
>>    static inline int netpoll_receive_skb(struct sk_buff *skb)
>>    {
>>        if (!list_empty(&skb->dev->napi_list))
>>                return netpoll_rx(skb);
>>        return 0;
>>    }
>>
>>
>> This is based on poking around in the crash dump:
>>    BUG: unable to handle kernel NULL pointer dereference at 0000000000000060
>>    IP: [<ffffffff8142bb40>] __netif_receive_skb+0x60/0x6e0
>>    crash> dis -rl ffffffff8142bb40
>>    ....
>>    /usr/src/debug/kernel-2.6.32-220.7.1.el6/linux-2.6.32-220.7.1.el6.x86_64/include/linux/netpoll.h:
>> 86
>>    0xffffffff8142bb33 <__netif_receive_skb+83>:    mov    0x20(%rbx),%r12
>>    0xffffffff8142bb37 <__netif_receive_skb+87>:    mov    %r12,-0x38(%rbp)
>>    0xffffffff8142bb3b <__netif_receive_skb+91>:    lea    0x60(%r12),%rax
>>    0xffffffff8142bb40 <__netif_receive_skb+96>:    cmp    %rax,0x60(%r12)
>>
>>
>>
>> I *think* this means that "&skb->dev->napi_list" is null when we're
>> trying to compare it, rather than being a list.
>>
>> If it matters, this is inside LXC containers.
>
> We've traced this to a problem with machines that have multiple hard
> drives AND have NAPI enabled for the NIC driver.
>
> We recompiled the e1000e driver with NAPI disabled, with:
>    make CFLAGS_EXTRA=-DE1000E_NO_NAPI
>
> and everything works great now.

Untrue! This eventually failed too, but after a lot more debugging, we
think we've nailed it:
    Multicast

We use ganglia on all of our nodes (and we were setting it up inside
the LXC containers), and ganglia listens / sends on multicast.

When gmond was starting inside the containers, it was giving an error:
    Apr  4 17:00:42 hostname /usr/sbin/gmond[551]: Error creating
multicast server mcast_join=239.2.11.110 port=8649 mcast_if=NULL
family='inet4'. Exiting.

It occurred to me that if the kernel is trying to read a multicast
packet from a socket buffer, but the container can't handle multicast
(mcast_if=NULL), that would explain why we got a NULL pointer
dereference in &skb->dev->napi_list.
(at least, this makes sense in my head.)

We disabled gmond in the containers, so nothing should be listening
for multicast packets, and everything is stable again.
Note that this ONLY seems to happen for us when we're using the
onboard 82574L Intel NIC with the e1000e driver.
We have other servers with the 82575 NIC which uses the igb driver and
doesn't exhibit this problem.

Is anyone from Intel here who could look in to this?
