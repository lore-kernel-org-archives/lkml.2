Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932087Ab2K0Qnn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 11:43:43 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:60270 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755935Ab2K0Qnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 11:43:41 -0500
MIME-Version: 1.0
In-Reply-To: <1353993325.14050.49.camel@ThinkPad-T5421.cn.ibm.com>
References: <1353993325.14050.49.camel@ThinkPad-T5421.cn.ibm.com>
Date: Tue, 27 Nov 2012 17:43:40 +0100
Message-ID: <CAFTL4hz4ehq1VNLvxvtmXJ5N-M-E4zoKSF-2wn=5aYfTTLYuuw@mail.gmail.com>
Subject: Re: [RFC PATCH] Fix abnormal rcu dynticks_nesting values related to
 async page fault
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: linux-next list <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, paulmck@linux.vnet.ibm.com,
        sasha.levin@oracle.com, gleb@redhat.com, avi@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/11/27 Li Zhong <zhong@linux.vnet.ibm.com>:
> I noticed some warnings complaining about dynticks_nesting value, like
>
> [  267.545032] ------------[ cut here ]------------
> [  267.545032] WARNING: at kernel/rcutree.c:382 rcu_eqs_enter+0xab/0xc0()
> [  267.545032] Hardware name: Bochs
> [  267.545032] Modules linked in:
> [  267.545032] Pid: 0, comm: swapper/2 Not tainted 3.7.0-rc5-next-20121115 #8
> [  267.545032] Call Trace:
> [  267.545032]  [<ffffffff8104714f>] warn_slowpath_common+0x7f/0xc0
> [  267.545032]  [<ffffffff810471aa>] warn_slowpath_null+0x1a/0x20
> [  267.545032]  [<ffffffff810e607b>] rcu_eqs_enter+0xab/0xc0
> [  267.545032]  [<ffffffff810e60bb>] rcu_idle_enter+0x2b/0x70
> [  267.545032]  [<ffffffff8100d44f>] cpu_idle+0x6f/0x100
> [  267.545032]  [<ffffffff814bf055>] start_secondary+0x205/0x20c
> [  267.545032] ---[ end trace 924ae80da035028d ]---
>
> After enabling rcu-dyntick tracing, I got following abnormal
> dynticks_nesting values (13fffffffffffff, ff00000000000001,etc):
>                         ...
>  1      <idle>-0     [002] dN.2 18739.518567: rcu_dyntick: End 0 140000000000000                rcu_idle_exit
>  2        sshd-696   [002] d..1 18739.518675: rcu_dyntick: ++= 140000000000000 140000000000001  rcu_irq_enter   - apf (not present)
>
>  3      <idle>-0     [002] d..2 18739.518705: rcu_dyntick: Start 140000000000001 0              rcu_idle_enter
>  4      <idle>-0     [002] d..2 18739.521252: rcu_dyntick: End 0 1                              rcu_irq_enter   - apf (page ready)
>  5      <idle>-0     [002] dN.2 18739.521261: rcu_dyntick: Start 1 0                            rcu_irq_exit    - apf (page ready)
>  6      <idle>-0     [002] dN.2 18739.521263: rcu_dyntick: End 0 140000000000000                rcu_idle_exit
>
>  7        sshd-696   [002] d..1 18739.521299: rcu_dyntick: --= 140000000000000 13fffffffffffff  rcu_irq_exit    - apf (not present)
>  8        sshd-696   [002] d..1 18739.521302: rcu_dyntick: Start 13fffffffffffff 0              rcu_user_enter
>  9        sshd-696   [002] d..1 18739.521330: rcu_dyntick: End 0 1                              rcu_irq_enter   - apf (not present)
>
> 10      <idle>-0     [002] d..2 18739.521346: rcu_dyntick: Start 1 0                            rcu_idle_enter - old value 1, warning

To be clear, what is illegal in the above? The fact we are calling
rcu_irq_enter() without rcu_irq_exit() while we are in idle mode? So
non matching rcu_irq_exit() is also only permitted in non-idle mode,
right?
