Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758353Ab2CBVUX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 16:20:23 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:19460 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757088Ab2CBVUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 16:20:21 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6637"; a="166392802"
Message-ID: <4F513995.6050509@codeaurora.org>
Date: Fri, 02 Mar 2012 13:20:21 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Thunderbird/3.1.16
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: richard -rw- weinberger <richard.weinberger@gmail.com>,
        Witold Baryluk <baryluk@smp.if.uj.edu.pl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Marcin Slusarz <marcin.slusarz@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: ODEBUG: selftest warnings failed 4 != 5 (WARNING: at lib/debugobjects.c:908
 check_results.constprop.9)
References: <20120218023521.GB13538@smp.if.uj.edu.pl>	<CAFLxGvy0yWe2utG-+vFw4BhfH-i0vfjNy3k6kUsxkN7M4BSWQg@mail.gmail.com> <20120302131756.32e7f788.akpm@linux-foundation.org>
In-Reply-To: <20120302131756.32e7f788.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/02/12 13:17, Andrew Morton wrote:
> On Fri, 2 Mar 2012 00:18:37 +0100
> richard -rw- weinberger <richard.weinberger@gmail.com> wrote:
>
>> On Sat, Feb 18, 2012 at 3:35 AM, Witold Baryluk
>> <baryluk@smp.if.uj.edu.pl> wrote:
>>> Hello everybody,
>>>
>>> I recently enabled a CONFIG_DEBUG_OBJECTS kconfig option, and this is what I got when booting
>>>
>>> ...
>>> [ __ __0.000000] Linux version 3.3.0-rc3-t43-devel-smp-00278-g4903062-dirty (baryluk@sredniczarny) (gcc version 4.6.2 (Debian 4.6.2-14) ) #27 SMP Fri Feb 17 20:13:29 CE
>>> ...
>>> ...
>>> ...
>>> [ __ __0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
>>> [ __ __0.000000] Hierarchical RCU implementation.
>>> [ __ __0.000000] __RCU debugfs-based tracing is enabled.
>>> [ __ __0.000000] __RCU lockdep checking is enabled.
>>> [ __ __0.000000] NR_IRQS:2304 nr_irqs:256 16
>>> [ __ __0.000000] CPU 0 irqstacks, hard=f5408000 soft=f540a000
>>> [ __ __0.000000] Extended CMOS year: 2000
>>> [ __ __0.000000] Console: colour VGA+ 80x25
>>> [ __ __0.000000] console [tty0] enabled
>>> [ __ __0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
>>> [ __ __0.000000] ... MAX_LOCKDEP_SUBCLASSES: __8
>>> [ __ __0.000000] ... MAX_LOCK_DEPTH: __ __ __ __ __48
>>> [ __ __0.000000] ... MAX_LOCKDEP_KEYS: __ __ __ __8191
>>> [ __ __0.000000] ... CLASSHASH_SIZE: __ __ __ __ __4096
>>> [ __ __0.000000] ... MAX_LOCKDEP_ENTRIES: __ __ 16384
>>> [ __ __0.000000] ... MAX_LOCKDEP_CHAINS: __ __ __32768
>>> [ __ __0.000000] ... CHAINHASH_SIZE: __ __ __ __ __16384
>>> [ __ __0.000000] __memory used by lock dependency info: 3823 kB
>>> [ __ __0.000000] __per task-struct memory footprint: 1920 bytes
>>> [ __ __0.000000] ------------------------
>>> [ __ __0.000000] | Locking API testsuite:
>>> ...
>>> ...
>>> [ __ __0.000000] -------------------------------------------------------
>>> [ __ __0.000000] Good, all 218 testcases passed! |
>>> [ __ __0.000000] ---------------------------------
>>> [ __ __0.000000] ODEBUG: 14 of 14 active objects replaced
>>> [ __ __0.000000] ------------[ cut here ]------------
>>> [ __ __0.000000] WARNING: at lib/debugobjects.c:908 check_results.constprop.9+0x11c/0x140()
>>> [ __ __0.000000] Hardware name: 2669UYD
>>> [ __ __0.000000] ODEBUG: selftest warnings failed 4 != 5
>> This warning is still present.
>> Andrew?
> Dunno, sorry.  There are only two patches to bisect through - try
> reverting b84d435cc228e ("debugobjects: Extend to assert that an object
> is initialized") and then feac18dda25134 ("debugobjects: Be smarter
> about static objects")?  

The fix is in -mm. Can we send the patch to Linus directly? Or perhaps
go through Ingo since he sent the pull request in the first place?

> ------------------------------------------------------
> From: Stephen Boyd <sboyd@codeaurora.org>
> Subject: debugobjects: Fix selftest for static warnings
>
> debugobjects is now printing a warning when a fixup for a NOTAVAILABLE
> object is run.  This causes the selftest to fail like:
>
> [    0.000000] ODEBUG: selftest warnings failed 4 != 5
>
> We could just increase the number of warnings that the selftest is
> expecting to see because that is actually what has changed.  But, it turns
> out that fixup_activate() was written with inverted logic and thus a fixup
> for a static object returned 1 indicating the object had been fixed, and 0
> otherwise.  Fix the logic to be correct and update the counts to reflect
> that nothing needed fixing for a static object.
>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> Reported-By: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

