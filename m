Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933952Ab2C2Vmg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 17:42:36 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:35573 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933141Ab2C2Vmb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 17:42:31 -0400
MIME-Version: 1.0
In-Reply-To: <CAMjP1KmDxhOKOGtgKt=OWbcXoJgrbA_rAxdkV4j7Y8XC8yjnuA@mail.gmail.com>
References: <CAMjP1Kka6MmT2zLc95ZQ=vigS6w9diS9-tawzdUdhbzzfzMh3w@mail.gmail.com>
	<CAMjP1KmDxhOKOGtgKt=OWbcXoJgrbA_rAxdkV4j7Y8XC8yjnuA@mail.gmail.com>
Date: Thu, 29 Mar 2012 16:42:29 -0500
Message-ID: <CAMjP1KmkS9aBXJm1GEavhcNx75ib7G4m+xYBe3_PcGSo6t5FsQ@mail.gmail.com>
Subject: Re: Crash in __netif_receive_skb
From: Avleen Vig <avleen@gmail.com>
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 28, 2012 at 10:01 PM, Avleen Vig <avleen@gmail.com> wrote:
> On Wed, Mar 28, 2012 at 8:31 PM, Avleen Vig <avleen@gmail.com> wrote:
>> Hi folks, someone in #kernel recommended I email these two lists. Hope
>> they're the right place.
>>
>> We're running 2.6.32-220.4.1.el6.x86_64 on Centos 6.2, and getting a
>> repeated crash:
>>    https://gist.github.com/2231998
>>
>> We can make this happen pretty easily just by passing some network
>> traffic and waiting a while.
>> I couldn't find any references to this particular issue.
>> I have vmcore files and am happy to dig into it if it would help (as
>> long as someone can tell me what to do :))
>
> I hope this debugging is legit, I'm really new to this level of insight.
>
> I think the problem is in include/linux/netpoll.h, at the "if"
> statement at line 86:
>    static inline int netpoll_receive_skb(struct sk_buff *skb)
>    {
>        if (!list_empty(&skb->dev->napi_list))
>                return netpoll_rx(skb);
>        return 0;
>    }
>
>
> This is based on poking around in the crash dump:
>    BUG: unable to handle kernel NULL pointer dereference at 0000000000000060
>    IP: [<ffffffff8142bb40>] __netif_receive_skb+0x60/0x6e0
>    crash> dis -rl ffffffff8142bb40
>    ....
>    /usr/src/debug/kernel-2.6.32-220.7.1.el6/linux-2.6.32-220.7.1.el6.x86_64/include/linux/netpoll.h:
> 86
>    0xffffffff8142bb33 <__netif_receive_skb+83>:    mov    0x20(%rbx),%r12
>    0xffffffff8142bb37 <__netif_receive_skb+87>:    mov    %r12,-0x38(%rbp)
>    0xffffffff8142bb3b <__netif_receive_skb+91>:    lea    0x60(%r12),%rax
>    0xffffffff8142bb40 <__netif_receive_skb+96>:    cmp    %rax,0x60(%r12)
>
>
>
> I *think* this means that "&skb->dev->napi_list" is null when we're
> trying to compare it, rather than being a list.
>
> If it matters, this is inside LXC containers.

We've traced this to a problem with machines that have multiple hard
drives AND have NAPI enabled for the NIC driver.

We recompiled the e1000e driver with NAPI disabled, with:
    make CFLAGS_EXTRA=-DE1000E_NO_NAPI

and everything works great now.
