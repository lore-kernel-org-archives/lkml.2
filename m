Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755785Ab1CXOUo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 10:20:44 -0400
Received: from mail4.comsite.net ([205.238.176.238]:40839 "EHLO
	mail4.comsite.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811Ab1CXOUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 10:20:43 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=71.22.127.106;
Subject: Re: [KDUMP] Ignore spurious IPI
To: Takao Indoh <indou.takao@jp.fujitsu.com>
Message-Id: <smp-ipi-supurious-single-kdump@mdm.bga.com>
In-Reply-To: <C3CBE989BE8833indou.takao@jp.fujitsu.com>
References: <C3CBE989BE8833indou.takao@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org
From: Milton Miller <miltonm@bga.com>
Date: Thu, 24 Mar 2011 08:20:32 -0600
X-Originating-IP: 71.22.127.106
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Mar 2011 about 18:40:12 -0000, Takao Indoh wrote:
> Hi all,
> 
> I found a problem that kdump(2nd kernel) sometimes hangs up. It seems
> that system panic occurs as follows.
..
> (2)
> A pending IPI from 1st kernel comes after unmasking interrupts at the
> following point.
> 
> asmlinkage void __init start_kernel(void)
> {
> (snip)
>     time_init();
>     profile_init();
>     if (!irqs_disabled())
>             printk(KERN_CRIT "start_kernel(): bug: interrupts were "
>                              "enabled early\n");
>     early_boot_irqs_disabled = false;
>     local_irq_enable(); <=======================================HERE
> 
> (3)
> Kernel tries to handle the interrupt, but some data structures are not
> initialized yet at this point. As a result, in the
> generic_smp_call_function_single_interrupt(), NULL pointer dereference
> occurs when list_replace_init() tries to access &q->list.next.
> 
[tried to match lapic timer interrupt]
> Any comments?

So this occurs because unlike device interrupts, this vector has the action
defined statically and no per-interrupt disable on your architecture?


If so, just initialize the data structure earlier -- change
init_call_single_data from early_initcall to an explict call after the
per-cpu areas are initialized.

milton
