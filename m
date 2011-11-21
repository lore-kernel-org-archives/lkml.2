Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301Ab1KUXZq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 18:25:46 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:55184 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753184Ab1KUXZp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 18:25:45 -0500
MIME-Version: 1.0
In-Reply-To: <1321891800.20742.11.camel@frodo>
References: <1321707028-12487-1-git-send-email-jkacur@redhat.com>
	<1321707028-12487-4-git-send-email-jkacur@redhat.com>
	<1321891800.20742.11.camel@frodo>
Date: Tue, 22 Nov 2011 00:18:59 +0100
X-Google-Sender-Auth: dr5b3S80SKtF1__ZQhQKAw0Fj5Q
Message-ID: <CAONaPpGz3NoKs9TfDHgNR5YcnfX-j0AT_bVttxPYXLRq5Y=SSg@mail.gmail.com>
Subject: Re: [PATCH 3/3] rcu: Drive configuration directly from SMP and PREEMPT
From: John Kacur <jkacur@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        rt-users <linux-rt-users@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 21, 2011 at 5:10 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Sat, 2011-11-19 at 13:50 +0100, John Kacur wrote:
>> From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
>>
>> This commit eliminates the possibility of running TREE_PREEMPT_RCU
>> when SMP=n and of running TINY_RCU when PREEMPT=y.  People who really
>> want these combinations can hand-edit init/Kconfig, but eliminating
>> them as choices for production systems reduces the amount of testing
>> required.  It will also allow cutting out a few #ifdefs.
>>
>> Note that running TREE_RCU and TINY_RCU on single-CPU systems using
>> SMP-built kernels is still supported.
>
> With this patch, I can see the need for the first patch (although
> there's things broken even for that), but is this really a stable fix?
>
> This looks more of an added feature than a bug fix. It's a bug fix if we
> consider running tree_rcu on UP a bug. Or better stated, will it break
> anything if we do that?
>
> -- Steve
>
>>
>> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
>>
>> commit 8008e129dc90ff4f7a56cb033d6bd042afe3ed52 upstream
>> Cherry-picked for v3.0-rt and fixed-up merge conflicts
>> Note: This makes the depends lines for these options in init/Kconfig for v3.0-rt
>> match those for v3.2-rc2-rt3
>> Signed-off-by: John Kacur <jkacur@redhat.com>
>> ---
>>  init/Kconfig |    6 +++---
>>  1 files changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/init/Kconfig b/init/Kconfig
>> index 89e40a4..5c1147e 100644
>> --- a/init/Kconfig
>> +++ b/init/Kconfig
>> @@ -391,7 +391,7 @@ config TREE_RCU
>>
>>  config TREE_PREEMPT_RCU
>>       bool "Preemptible tree-based hierarchical RCU"
>> -     depends on PREEMPT
>> +     depends on PREEMPT && SMP
>>       help
>>         This option selects the RCU implementation that is
>>         designed for very large SMP systems with hundreds or
>> @@ -401,7 +401,7 @@ config TREE_PREEMPT_RCU
>>
>>  config TINY_RCU
>>       bool "UP-only small-memory-footprint RCU"
>> -     depends on !SMP && !PREEMPT_RT_FULL
>> +     depends on !PREEMPT && !SMP
>>       help
>>         This option selects the RCU implementation that is
>>         designed for UP systems from which real-time response
>> @@ -410,7 +410,7 @@ config TINY_RCU
>>
>>  config TINY_PREEMPT_RCU
>>       bool "Preemptible UP-only small-memory-footprint RCU"
>> -     depends on !SMP && PREEMPT && !PREEMPT_RT_FULL
>> +     depends on PREEMPT && !SMP
>>       help
>>         This option selects the RCU implementation that is designed
>>         for real-time UP systems.  This option greatly reduces the
>

Imagine you have a uni-processor system and want to do real-time.
According to the descriptions in init/Kconfig, you would want to
select TINY_PREEMPT_RCU. The description is

	  This option selects the RCU implementation that is designed
	  for real-time UP systems.  This option greatly reduces the
	  memory footprint of RCU.

Without this patch, you cannot choose this option because of the &&
!PREEMPT_RT_FULL
So, that is a bug, and makes this patch appropriate for stable.

I suppose if you want to be really conservative, you can say we only
need that third hunk.
However, this upstream patch, makes these options in v3.0-rt match the
options in v3.2-rc2-rt3.

Furthermore, it doesn't seem like a good idea to me to support
configurations in a stable branch that are not supported upstream.

Thanks

John
