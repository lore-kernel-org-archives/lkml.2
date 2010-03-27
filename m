Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150Ab0C0W4U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Mar 2010 18:56:20 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:16786 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754122Ab0C0W4Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Mar 2010 18:56:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=VuhmnB166B9FmSAPbzVrEptbAhksyECjSeAvZUGz7k2Xz6dESmYSbTxezdsJpeeUhh
         Vj6RTUbZeD6QjyGLYuHd5lDXMgJRUH7ysjNJEutp/sX46PTbB7OF+diioPgpZHvNL4hx
         wRUwjTYTAYVjrhRkGMcEyIwsZqWFEUrYUlVtY=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1003261951330.3147@localhost.localdomain>
References: <520f0cf11003260502o5ecb23adpe69f6eb465142821@mail.gmail.com>
	 <alpine.LFD.2.00.1003261951330.3147@localhost.localdomain>
Date: Sat, 27 Mar 2010 23:56:14 +0100
X-Google-Sender-Auth: be4716e40525f915
Message-ID: <520f0cf11003271556n2b4e9774x8b15a6e34fbcf1bf@mail.gmail.com>
Subject: Re: [BUG-REPORT][PREEMPT-RT] 2.6.33.1-rt11 triggers 
	DEBUG_LOCKS_WARN_ON(!p->hardirqs_enabled), in a 32-bit kvm session
From: John Kacur <jkacur@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 26, 2010 at 8:01 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Fri, 26 Mar 2010, John Kacur wrote:
>
>> During boot-up of 2.6.33.1-rt11 in a 32-bit qemu-kvm machine,
>> The following warning is reliably (every time) triggered.
>>
>> ------------[ cut here ]------------
>> WARNING: at /home/jkacur/jk-2.6/kernel/fork.c:1065 copy_process+0x299/0x160f()
>> Hardware name:
>> Modules linked in:
>> Pid: 64, comm: khelper Not tainted 2.6.33.1-rt11 #1
>> Call Trace:
>>  [<c104961a>] warn_slowpath_common+0x83/0x9a
>>  [<c1049643>] warn_slowpath_null+0x12/0x15
>>  [<c1046f89>] copy_process+0x299/0x160f
>>  [<c1048711>] do_fork+0x235/0x4e2
>>  [<c107da08>] ? register_lock_class+0x17/0x22d
>>  [<c107e6dc>] ? mark_lock+0x1e/0x1c0
>>  [<c1064a2f>] ? ____call_usermodehelper+0x0/0x138
>>  [<c100ae09>] kernel_thread+0x79/0x81
>>  [<c1064a2f>] ? ____call_usermodehelper+0x0/0x138
>>  [<c100391c>] ? kernel_thread_helper+0x0/0x10
>>  [<c1064cc7>] __call_usermodehelper+0x75/0xa0
>>  [<c10673b6>] worker_thread+0x1f6/0x2fb
>>  [<c1067374>] ? worker_thread+0x1b4/0x2fb
>>  [<c1064c52>] ? __call_usermodehelper+0x0/0xa0
>>  [<c106a91e>] ? autoremove_wake_function+0x0/0x46
>>  [<c106a740>] kthread+0x6b/0x74
>>  [<c10671c0>] ? worker_thread+0x0/0x2fb
>>  [<c106a6d5>] ? kthread+0x0/0x74
>>  [<c106a6d5>] ? kthread+0x0/0x74
>>  [<c1003922>] kernel_thread_helper+0x6/0x10
>> ---[ end trace a22d306b065d4a66 ]---
>>
>> I am happy to provide more information to help debug this.
>
> Can you run the following patch please ?
>
> Thanks,
>
>        tglx
> ---
>
> diff --git a/kernel/fork.c b/kernel/fork.c
> index 340cbc8..b63e8f5 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -1062,7 +1062,9 @@ static struct task_struct *copy_process(unsigned long clone_flags,
>        rt_mutex_init_task(p);
>
>  #ifdef CONFIG_PROVE_LOCKING
> -       DEBUG_LOCKS_WARN_ON(!p->hardirqs_enabled);
> +       //DEBUG_LOCKS_WARN_ON(!p->hardirqs_enabled);
> +       if (!p->hardirqs_enabled)
> +               print_irqtrace_events(p);
>        DEBUG_LOCKS_WARN_ON(!p->softirqs_enabled);
>  #endif
>        retval = -EAGAIN;
> --

With the above patch I got the following.

8139cp: 10/100 PCI Ethernet driver v1.3 (Mar 22, 2004)
ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 10
8139cp 0000:00:03.0: PCI INT A -> Link[LNKC] -> GSI 10 (level, high) -> IRQ 10
eth0: RTL-8139C+ at 0xf886c000, 52:54:00:3c:11:54, IRQ 10
8139cp 0000:00:03.0: setting latency timer to 64
irq event stamp: 5988
hardirqs last  enabled at (5987): [<c13e4696>]
_raw_spin_unlock_irqrestore+0x49/0x8f
hardirqs last disabled at (5988): [<c13e4ce3>] call_function_interrupt+0x2f/0x3c
softirqs last  enabled at (0): [<c10470a6>] copy_process+0x3b6/0x15ad
softirqs last disabled at (0): [<(null)>] (null)
8139too Fast Ethernet driver 0.9.28
irq event stamp: 10638
hardirqs last  enabled at (10637): [<c13e4696>]
_raw_spin_unlock_irqrestore+0x49/0x8f
hardirqs last disabled at (10638): [<c13e4feb>] apic_timer_interrupt+0x2f/0x3c
softirqs last  enabled at (0): [<c10470a6>] copy_process+0x3b6/0x15ad
softirqs last disabled at (0): [<(null)>] (null)
irq event stamp: 2914
hardirqs last  enabled at (2913): [<c13e4696>]
_raw_spin_unlock_irqrestore+0x49/0x8f
hardirqs last disabled at (2914): [<c13e4feb>] apic_timer_interrupt+0x2f/0x3c
softirqs last  enabled at (0): [<c10470a6>] copy_process+0x3b6/0x15ad
softirqs last disabled at (0): [<(null)>] (null)


and then

irq event stamp: 36510
hardirqs last  enabled at (36509): [<c13e4696>]
_raw_spin_unlock_irqrestore+0x49/0x8f
hardirqs last disabled at (36510): [<c13e4feb>] apic_timer_interrupt+0x2f/0x3c
softirqs last  enabled at (0): [<c10470a6>] copy_process+0x3b6/0x15ad
softirqs last disabled at (0): [<(null)>] (null)
eth0: no IPv6 routers present
irq event stamp: 103682
hardirqs last  enabled at (103681): [<c13e4696>]
_raw_spin_unlock_irqrestore+0x49/0x8f
hardirqs last disabled at (103682): [<c13e4feb>] apic_timer_interrupt+0x2f/0x3c
softirqs last  enabled at (0): [<c10470a6>] copy_process+0x3b6/0x15ad
softirqs last disabled at (0): [<(null)>] (null)
