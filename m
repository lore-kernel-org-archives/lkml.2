Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932261Ab0DAUo2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 16:44:28 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:49927 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754459Ab0DAUoZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 16:44:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Q+KdGCesjUrahJfBX74V3omN72glyYMN6xRuYKjs5/v17TCInhFA7ViWfYHaXUa9hR
         BXmr4x5vSILPIScqOWaGNFAoTIpiWe//tkKb5ufQ1j/qwh6XBtxLZo2LTpqsqjmnjx6p
         J2yGrz7mX1SeSkIJInTwGpeFpUsoGJtonwcjY=
MIME-Version: 1.0
In-Reply-To: <s2xe6bf505b1004011146l201605ccz92a2aa99af11a57a@mail.gmail.com>
References: <l2me6bf505b1004011042oce87e64fn94bef56c78a1b10d@mail.gmail.com>
	 <alpine.LFD.2.00.1004012015070.32352@localhost.localdomain>
	 <s2xe6bf505b1004011146l201605ccz92a2aa99af11a57a@mail.gmail.com>
Date: Thu, 1 Apr 2010 14:44:23 -0600
Message-ID: <m2qe6bf505b1004011344hbf36fb5bt78b925ad75e64b19@mail.gmail.com>
Subject: Re: [ANNOUNCE] 2.6.33.1-rt11 - BUG?
From: Xianghua Xiao <xiaoxianghua@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is the new dmesg output:
BUG: sleeping function called from invalid context at kernel/rtmutex.c:684
pcnt: 1 0 in_atomic(): 1, irqs_disabled(): 1, pid: 5770, name: insmod
Call Trace:
[ce935dc0] [c00096cc] show_stack+0x6c/0x1a4 (unreliable)
[ce935df0] [c001f928] __might_sleep+0x104/0x108
[ce935e00] [c03cb414] rt_spin_lock+0xa0/0xa4
[ce935e10] [c00a4098] kmem_cache_alloc+0x50/0x17c
[ce935e40] [c0073570] irq_to_desc_alloc_node+0x104/0x5ec
[ce935e60] [c00064e0] irq_setup_virq+0x30/0xa8
[ce935e80] [c000665c] irq_create_mapping+0x104/0x168
[ce935ea0] [d1f69bc4] dma_init+0x118/0x1f0 [ipc]
[ce935ee0] [d1f75018] ipc_init+0x18/0x140 [ipc]
[ce935ef0] [c00038e0] do_one_initcall+0x54/0x210
[ce935f20] [c005e424] sys_init_module+0x120/0x240
[ce935f40] [c00139d4] ret_from_syscall+0x0/0x38

I chased from ipc_init to irq_to_desc_alloc_node and found no
interrupt-disabling.

By looking at irq_to_desc_alloc_node (kernel/irq/handler.c) it has
raw_spin_lock_irqsave(), with this raw spinlock irqsave I'm not sure
if it causes trouble at kmem_cache_alloc after rt11 is applied, still
checking on that.

thanks,
xianghua

On Thu, Apr 1, 2010 at 12:46 PM, Xianghua Xiao <xiaoxianghua@gmail.com> wrote:
> That fixed it. Thanks!
> However I'm seeing two more similar rtmutex:684 BUGs from dmesg now,
> they're from my own drivers and I'm tracking them down.
>
> Xianghua
>
>
> On Thu, Apr 1, 2010 at 1:23 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
>> On Thu, 1 Apr 2010, Xianghua Xiao wrote:
>>
>>> I'm testing 2.6.33.1 on ppc 834x with rt11 patch. After system is up I keep
>>> seeing this same message from dmesg:
>>>
>>> BUG: sleeping function called from invalid context at kernel/rtmutex.c:684
>>> pcnt: 0 0 in_atomic(): 0, irqs_disabled(): 1, pid: 16, name: events/0
>>> Call Trace:
>>> [cf85be80] [c00096cc] show_stack+0x6c/0x1a4 (unreliable)
>>> [cf85beb0] [c001f928] __might_sleep+0x104/0x108
>>> [cf85bec0] [c03cb444] rt_spin_lock+0xa0/0xa4
>>> [cf85bed0] [c0270b6c] lock_tx_qs+0x40/0x68
>>> [cf85bef0] [c02712cc] adjust_link+0x4c/0x240
>>> [cf85bf20] [c026d5ec] phy_state_machine+0x3bc/0x628
>>> [cf85bf40] [c003e69c] worker_thread+0x148/0x1f0
>>> [cf85bfa0] [c0042ec0] kthread+0x84/0x88
>>> [cf85bff0] [c00137f8] kernel_thread+0x4c/0x68
>>> BUG: sleeping function called from invalid context at kernel/rtmutex.c:684
>>> pcnt: 0 0 in_atomic(): 0, irqs_disabled(): 1, pid: 16, name: events/0
>>>
>>> #uname -a
>>> Linux 2.6.33.1-rt11 #3 PREEMPT RT Thu Apr 1 11:58:25 CDT 2010 ppc unknown
>>>
>>> This does not hang/lock the system yet...google reported similar 'bug' on
>>> older kernels. Is this a bug from 2.6.33.1-rt11 patch or I have to change
>>> phy.c somehow to avoid it? This traces back to a mutex lock in phy.c.
>>
>> No, it traces back to a call to lock_tx_qs() which is a spinlock in
>> mainline and gets converted to a "sleeping" spinlock in -RT. That
>> means it can't be called with interrupts disabled. But the code in
>> adjust_link does exaclty that.
>>
>> Does the patch below fix it ?
>>
>> Thanks,
>>
>>        tglx
>> ---
>> Subject: net-gianfar-fix-rt-splat.patch
>> From: Thomas Gleixner <tglx@linutronix.de>
>> Date: Thu, 01 Apr 2010 20:20:57 +0200
>>
>> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
>> ---
>>  drivers/net/gianfar.c |    4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> Index: linux-2.6-tip/drivers/net/gianfar.c
>> ===================================================================
>> --- linux-2.6-tip.orig/drivers/net/gianfar.c
>> +++ linux-2.6-tip/drivers/net/gianfar.c
>> @@ -2717,7 +2717,7 @@ static void adjust_link(struct net_devic
>>        struct phy_device *phydev = priv->phydev;
>>        int new_state = 0;
>>
>> -       local_irq_save(flags);
>> +       local_irq_save_nort(flags);
>>        lock_tx_qs(priv);
>>
>>        if (phydev->link) {
>> @@ -2785,7 +2785,7 @@ static void adjust_link(struct net_devic
>>        if (new_state && netif_msg_link(priv))
>>                phy_print_status(phydev);
>>        unlock_tx_qs(priv);
>> -       local_irq_restore(flags);
>> +       local_irq_restore_nort(flags);
>>  }
>>
>>  /* Update the hash table based on the current list of multicast
>>
>>
>>
>>
>>
>
