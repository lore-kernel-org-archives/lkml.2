Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755098Ab2CLJdC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 05:33:02 -0400
Received: from casper.infradead.org ([85.118.1.10]:41498 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251Ab2CLJdA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 05:33:00 -0400
Message-ID: <1331544767.18960.23.camel@twins>
Subject: Re: [PATCH] Fix the race between smp_call_function and CPU booting
From: Peter Zijlstra <peterz@infradead.org>
To: "Liu, Chuansheng" <chuansheng.liu@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>
Date: Mon, 12 Mar 2012 10:32:47 +0100
In-Reply-To: <27240C0AC20F114CBF8149A2696CBE4A053BE8@SHSMSX101.ccr.corp.intel.com>
References: <27240C0AC20F114CBF8149A2696CBE4A053BE8@SHSMSX101.ccr.corp.intel.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-12 at 09:27 +0000, Liu, Chuansheng wrote:
> From: liu chuansheng <chuansheng.liu@intel.com>
> Subject: [PATCH] Fix the race between smp_call_function and CPU booting
> 
> When system is waking up from suspend state, sometimes the
> smp_call_function is called which will cause deadlock specially on the
> platform which just has two CPUs.
> 
> CPU0:                                           CPU1:
> pm_suspend -->
> suspend_devices_and_enter -->
> enable_nonboot_cpus -->
> _cpu_up -->
> __cpu_up -->
> native_cpu_up
>                                                 start_secondary
>                                                         -- set cpu online
>                                                         -- waiting for the active state new thread call:
> smp_call_function -->
> smp_call_function_many -->
> smp_call_function_single -->
>    -- csd_lock
>    -- generic_exec_single -->
>    -- arch_send_call_function_single_ipi
>    -- csd_lock_wait
> 
> At this time, both CPUs are blocked. Normally the CPU0 will set the
> CPU1 with active state after finished the _cpu_up calling, but CPU1
> can not handle the IPI due to the corresponding irq is still disabled,
> which will be enabled after waiting for the active state.
> 
> The solution is just to send smp call to active cpus instead of online
> cpus.

Wouldn't http://lkml.org/lkml/2011/12/15/255 also solve that?
