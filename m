Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756613Ab1CXV0S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 17:26:18 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:48706 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755017Ab1CXV0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 17:26:17 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.5.1
From: Takao Indoh <indou.takao@jp.fujitsu.com>
To: Milton Miller <miltonm@bga.com>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Subject: Re: [KDUMP] Ignore spurious IPI
Date: Thu, 24 Mar 2011 17:25:18 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Mailer: HidemaruMail 5.38 (WinNT,501)
In-Reply-To: <smp-ipi-supurious-single-kdump@mdm.bga.com>
References: <C3CBE989BE8833indou.takao@jp.fujitsu.com> <smp-ipi-supurious-single-kdump@mdm.bga.com>
Message-Id: <C4CBEA69F94DFCindou.takao@jp.fujitsu.com>
X-Antivirus: avast! (VPS 110324-0, 2011/03/24), Outbound message
X-Antivirus-Status: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Mar 2011 08:20:32 -0600, Milton Miller wrote:

>On Wed, 23 Mar 2011 about 18:40:12 -0000, Takao Indoh wrote:
>> Hi all,
>> 
>> I found a problem that kdump(2nd kernel) sometimes hangs up. It seems
>> that system panic occurs as follows.
>..
>> (2)
>> A pending IPI from 1st kernel comes after unmasking interrupts at the
>> following point.
>> 
>> asmlinkage void __init start_kernel(void)
>> {
>> (snip)
>>     time_init();
>>     profile_init();
>>     if (!irqs_disabled())
>>             printk(KERN_CRIT "start_kernel(): bug: interrupts were "
>>                              "enabled early\n");
>>     early_boot_irqs_disabled = false;
>>     local_irq_enable(); <=======================================HERE
>> 
>> (3)
>> Kernel tries to handle the interrupt, but some data structures are not
>> initialized yet at this point. As a result, in the
>> generic_smp_call_function_single_interrupt(), NULL pointer dereference
>> occurs when list_replace_init() tries to access &q->list.next.
>> 
>[tried to match lapic timer interrupt]
>> Any comments?
>
>So this occurs because unlike device interrupts, this vector has the action
>defined statically and no per-interrupt disable on your architecture?

I think there is not per-interrupt disable for IPI.

>If so, just initialize the data structure earlier -- change
>init_call_single_data from early_initcall to an explict call after the
>per-cpu areas are initialized.

That makes sense. I'll do this, thanks.

Thanks,
Takao Indoh


>
>milton
