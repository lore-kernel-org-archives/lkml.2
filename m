Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753606Ab3AGPrf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 10:47:35 -0500
Received: from mail-vc0-f171.google.com ([209.85.220.171]:60015 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753432Ab3AGPre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 10:47:34 -0500
MIME-Version: 1.0
In-Reply-To: <50E754C1.3060104@windriver.com>
References: <1356799386-4212-1-git-send-email-fweisbec@gmail.com>
	<1356799386-4212-4-git-send-email-fweisbec@gmail.com>
	<50E754C1.3060104@windriver.com>
Date: Mon, 7 Jan 2013 16:47:31 +0100
Message-ID: <CAFTL4hy6ebq21Z9=5_F1K81_42bcpt+nmswMxKMbwnRbRTz9rQ@mail.gmail.com>
Subject: Re: [PATCH 03/27] cputime: Allow dynamic switch between tick/virtual
 based cputime accounting
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Paul,

2013/1/4 Paul Gortmaker <paul.gortmaker@windriver.com>:
> On 12-12-29 11:42 AM, Frederic Weisbecker wrote:
>> Allow to dynamically switch between tick and virtual based cputime accounting.
>> This way we can provide a kind of "on-demand" virtual based cputime
>> accounting. In this mode, the kernel will rely on the user hooks
>> subsystem to dynamically hook on kernel boundaries.
>>
>> This is in preparation for beeing able to stop the timer tick further
>> idle. Doing so will depend on CONFIG_VIRT_CPU_ACCOUNTING which makes
>
> s/beeing/being/  -- also I know what you mean, but it may not be
> 100% clear to everyone -- perhaps "...for being able to stop the
> timer tick in more places than just the idle state."

Thanks! Fixed for the next version!

[...]
>> +static inline bool vtime_accounting(void) { return false; }
>
> It wasn't 100% obvious what vtime_accounting() was doing until I
> saw its definition below.  I wonder if it should be something like
> vtime_accounting_on() or vtime_accounting_enabled() instead?

Agreed, I've renamed into vtime_accounting_enabled().

>
>>  #endif
>>
>>  #ifdef CONFIG_VIRT_CPU_ACCOUNTING_GEN
>> diff --git a/init/Kconfig b/init/Kconfig
>> index dad2b88..307bc35 100644
>> --- a/init/Kconfig
>> +++ b/init/Kconfig
>> @@ -342,6 +342,7 @@ config VIRT_CPU_ACCOUNTING
>>       bool "Deterministic task and CPU time accounting"
>>       depends on HAVE_VIRT_CPU_ACCOUNTING || HAVE_CONTEXT_TRACKING
>>       select VIRT_CPU_ACCOUNTING_GEN if !HAVE_VIRT_CPU_ACCOUNTING
>> +     select VIRT_CPU_ACCOUNTING_NATIVE if HAVE_VIRT_CPU_ACCOUNTING
>>       help
>>         Select this option to enable more accurate task and CPU time
>>         accounting.  This is done by reading a CPU counter on each
>> @@ -366,11 +367,16 @@ endchoice
>>
>>  config VIRT_CPU_ACCOUNTING_GEN
>>       select CONTEXT_TRACKING
>> +     depends on VIRT_CPU_ACCOUNTING && HAVE_CONTEXT_TRACKING
>
> Should the 2nd half of this depends been already here, i.e. introduced
> with the prev. patch that created VIRT_CPU_ACCOUNTING_GEN?

Yeah, Li Zhong suggested that I turn *_GEN and *_NATIVE options into
distinct choices for the user. So I moved that part to the previous
patch.

Thanks!
