Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751732Ab2IXWrm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 18:47:42 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:55405 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012Ab2IXWrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 18:47:40 -0400
Message-ID: <5060E31B.3070203@gmail.com>
Date: Tue, 25 Sep 2012 00:47:55 +0200
From: Sasha Levin <levinsasha928@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120913 Thunderbird/15.0.1
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: paulmck@linux.vnet.ibm.com, Michael Wang <wangyun@linux.vnet.ibm.com>,
        Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: RCU idle CPU detection is broken in linux-next
References: <20120921121346.GD2458@linux.vnet.ibm.com> <505C6B03.7020305@gmail.com> <20120921151203.GA2454@linux.vnet.ibm.com> <505C855F.3060301@gmail.com> <505D7621.4040505@gmail.com> <20120922150913.GA2934@linux.vnet.ibm.com> <505DDBE7.7010706@gmail.com> <20120922155613.GB2934@linux.vnet.ibm.com> <505DFA65.3080805@gmail.com> <20120922212735.GG2934@linux.vnet.ibm.com> <20120923002105.GA1112@linux.vnet.ibm.com> <505EA09B.6040105@gmail.com> <CAFTL4hwqzS8iO2zOOGaizzMtT85MJExTxEgGbponJ4_gfv0nwA@mail.gmail.com>
In-Reply-To: <CAFTL4hwqzS8iO2zOOGaizzMtT85MJExTxEgGbponJ4_gfv0nwA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frederic,

On 09/24/2012 11:29 PM, Frederic Weisbecker wrote:
> Sasha,
> 
> Can you please test the following branch:
> 
> git://github.com/fweisbec/linux-dynticks.git  rcu/idle-for-v3.7-take3
> 
> with CONFIG_RCU_USER_QS and CONFIG_RCU_USER_QS_FORCE enabled.
> 
> I hope this fixes the warning.
> The changes are:
> 
> * add "x86: Unspaghettize do_general_protection()"
> * updated "x86: Exception hooks for userspace RCU extended QS" to
> handle some missed trap handlers. Especially do_general_protection()
> because I can see the problem triggered there in Sasha's warnings. I
> fixed more handlers in the way.

I've tested the branch above, and noticed two things:

 - I had merge conflicts when pulling it on top of latest linux-next which I've resolved:

diff --cc arch/x86/kernel/traps.c
index 1ba4850,cb20776..386b079
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@@ -644,8 -646,7 +647,9 @@@ EXPORT_SYMBOL_GPL(math_state_restore)
  dotraplinkage void __kprobes
  do_device_not_available(struct pt_regs *regs, long error_code)
  {
 +      BUG_ON(use_eager_fpu());
 +
+       exception_enter(regs);
  #ifdef CONFIG_MATH_EMULATION
        if (read_cr0() & X86_CR0_EM) {
                struct math_emu_info info = { };

 - While I no longer see the warnings I've originally noticed, if I run with Paul's last debug patch I see the following warning:

[  212.200137] WARNING: at arch/x86/kernel/process.c:392 cpu_idle+0x12a/0x1f0()
[  212.200141] Pid: 0, comm: swapper/3 Tainted: G        W    3.6.0-rc6-next-20120924-sasha-00030-g71f256c #5
[  212.200142] Call Trace:
[  212.200146]  [<ffffffff810799da>] ? cpu_idle+0x12a/0x1f0
[  212.200150]  [<ffffffff811078b6>] warn_slowpath_common+0x86/0xb0
[  212.200153]  [<ffffffff811079a5>] warn_slowpath_null+0x15/0x20
[  212.200156]  [<ffffffff810799da>] cpu_idle+0x12a/0x1f0
[  212.200160]  [<ffffffff839a3ee8>] ? setup_APIC_timer+0xb2/0xb6

Which is triggered by:
                        if (cpuidle_idle_call())
                                pm_idle();

                        rcu_idle_exit();
                        WARN_ON(rcu_is_cpu_idle()); <---- THIS
                        start_critical_timings();

                        /* In many cases the interrupt that ended idle
                           has already called exit_idle. But some idle
                           loops can be woken up without interrupt. */
                        WARN_ON(rcu_is_cpu_idle());
                        __exit_idle();
                        WARN_ON(rcu_is_cpu_idle());


Thanks,
Sasha
