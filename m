Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756124Ab0D0Srf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 14:47:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22362 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755515Ab0D0Sre (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 14:47:34 -0400
Message-ID: <4BD73134.1030308@redhat.com>
Date: Tue, 27 Apr 2010 14:47:16 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091210 Fedora/3.0-4.el6 Thunderbird/3.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com, x86@kernel.org,
       clalance@redhat.com, drjones@redhat.com
Subject: Re: [LKML] [PATCH] Fix NULL pointer for Xen guests
References: <20100427152434.16193.49104.sendpatchset@prarit.bos.redhat.com> <20100427165816.GA24707@phenom.dumpdata.com> <4BD71A2D.6050309@redhat.com> <20100427183428.GA15385@phenom.dumpdata.com>
In-Reply-To: <20100427183428.GA15385@phenom.dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 04/27/2010 02:34 PM, Konrad Rzeszutek Wilk wrote:
>>> Can you provide a short example of test scenario? As in what I should do
>>> to reproduce this problem?
>>>
>>>        
>> Take the latest upstream (well ... to be honest, a bit older than that
>> because of some other bugs) -- take 2.6.33 and try to boot it as a PV
>>      
> 2.6.34-rc5 PV boots under Xen for me (and pretty much since 2.6.33 +
> Suresh fix for the CONFIG_RODATA_MARK).
>
> Perhaps I am missing some of the .config options you have set that make it not work?
>
> The irqbalance daemon looks to be running - but I think you are hitting
> this during bootup?  How long do you have to wait for this to trigger?
>
>    

It happens during bootup.   I don't have a 2.6.33 vanilla panic handy 
but I do have one from an earlier 2.6.32...

rip: ffffffff81256f45 delay_tsc+0x45

rsp: ffff8800fac95a98

rax: fffffffff6ef46d0   rbx: 00000002   rcx: f6ef46d0   rdx: 0010850c

rsi: 002b3bb6   rdi: 002b3bcc   rbp: ffff8800fac95ab8

  r8: ffffffff    r9: 00000002   r10: 00000002   r11: 00000000

r12: fffffffff6dec1c4   r13: 00000002   r14: 002b3bcc   r15: 00000001

  cs: 0000e033    ds: 00000000    fs: 00000000    gs: 00000000



Stack:

  000000000002ef45 ffff8800fac95c88 0000000000000009 ffff8800fac93540

  ffff8800fac95ac8 ffffffff81256ef6 ffff8800fac95b48 ffffffff814c6341

  0000000000000010 ffff8800fac95b38 ffff880000000008 ffff8800fac95b58

  ffff8800fac95b08 a22d306b065d4a66 0000000000000000 0000000000000000



Code:

f3 90 65 8b 1c 25 d8 e3 00 00 44 39 eb 75 23 66 66 90 0f ae e8<e8>  46 3d dc ff
66 90 48 98 48 89



Call Trace:

   [<ffffffff81256f45>] delay_tsc+0x45<--

   [<ffffffff81256ef6>] __const_udelay+0x46

   [<ffffffff814c6341>] panic+0x135

   [<ffffffff814ca23c>] oops_end+0xdc

   [<ffffffff81042272>] no_context+0xf2

   [<ffffffff8125946c>] __bitmap_weight+0x8c

   [<ffffffff81042505>] __bad_area_nosemaphore+0x125

   [<ffffffff8105fad4>] find_busiest_group+0x254

   [<ffffffff810425d3>] bad_area_nosemaphore+0x13

   [<ffffffff814cbccf>] do_page_fault+0x2ef

   [<ffffffff814c9595>] page_fault+0x25

   [<ffffffff810302f2>] irq_force_complete_move+0x12

   [<ffffffff81015214>] fixup_irqs+0xa4

   [<ffffffff8102ce59>] cpu_disable_common+0x1a9

   [<ffffffff8100f9c2>] check_events+0x12

   [<ffffffff810c2550>] __stop_machine+0x120

   [<ffffffff8100ff75>] xen_cpu_disable+0x25

   [<ffffffff814b0427>] take_cpu_down+0x17

   [<ffffffff810c25f9>] stop_cpu+0xa9

   [<ffffffff8108869d>] worker_thread+0x16d

   [<ffffffff8100f19d>] xen_force_evtchn_callback+0xd

   [<ffffffff8108dd00>] wake_up_bit+0x40

   [<ffffffff814c90f6>] _spin_unlock_irqrestore+0x16

   [<ffffffff81088530>] create_workqueue_thread+0xd0

   [<ffffffff8108d9a6>] kthread+0x96

   [<ffffffff8101418a>] child_rip+0xa

   [<ffffffff81013351>] int_ret_from_sys_call+0x7

   [<ffffffff81013add>] retint_restore_args+0x5

   [<ffffffff81014180>] kernel_thread+0xe0


> How many CPUs did you assign to your guest?
>
>    

It didn't matter as long as vcpus >1 and maxcpus > vcpus.

> What are the "other bugs" you speak off?
>    

I got a different panic (which I've yet to resolve).

>    
>> guest.  I'm using a RHEL5 Xen HV fwiw ...
>>      
> OK, so your control domain is RHEL5. Mine is the Jeremy's xen/next one
> (2.6.32). Let me try to compile RHEL5 under FC11 - any tricks necessary
> to do that?
>    

I haven't tried it -- it might work :)

Also, did you try booting with maxvcpus > vcpus as drjones suggested ?

P.
