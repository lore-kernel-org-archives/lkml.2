Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758571Ab0FUU4J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 16:56:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:42123 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758466Ab0FUU4I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 16:56:08 -0400
Message-ID: <4C1FD1D0.4060803@kernel.org>
Date: Mon, 21 Jun 2010 22:55:44 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Tony Luck <tony.luck@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH UPDATED] sched: adjust when cpu_active and cpuset 	configurations
 are updated during cpu on/offlining
References: <4C08FF36.80806@kernel.org>	<4C0E9E03.1010508@kernel.org> <AANLkTimL2dEhIaxztoiDRBY3CsalcVNU54Mko6yg8ZqG@mail.gmail.com>
In-Reply-To: <AANLkTimL2dEhIaxztoiDRBY3CsalcVNU54Mko6yg8ZqG@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 21 Jun 2010 20:55:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 06/21/2010 08:28 PM, Tony Luck wrote:
> On Tue, Jun 8, 2010 at 12:46 PM, Tejun Heo <tj@kernel.org> wrote:
>> * Ingo's test discovered __cpuinit/exit markups were incorrect.
>>  Fixed.
> 
> No it isn't :-(

Ah, sorry, my original patch was broken on x86 too, so...

>> +static int __cpuexit cpuset_cpu_active(struct notifier_block *nfb,
>> +                                      unsigned long action, void *hcpu)
> ...
>> +static int __cpuexit cpuset_cpu_inactive(struct notifier_block *nfb,
>> +                                        unsigned long action, void *hcpu)
> 
> This patch arrived in linux-next (tag next-20100621) and breaks the
> ia64 build for configurations where CONFIG_HOTPLUG_CPU=n
> with the following cryptic error:
> 
> `.cpuexit.text' referenced in section `.IA_64.unwind.cpuexit.text' of
> kernel/built-in.o: defined in discarded section `.cpuexit.text' of
> kernel/built-in.o
> 
> This is because ia64 link stage drops __exit functions from
> built-in code (under the logic that they can never be called).
> 
> Is the problem in the !CONFIG_HOTPLUG_CPU definition of
> hotcpu_notifier() in <linux/cpu.h> which still references the
> function argument:
> 
> #define hotcpu_notifier(fn, pri)        do { (void)(fn); } while (0)
> 
> Or should these functions not be marked __cpuexit?

I see.  I think the right solution is removing __cpuexit but it's kind
of silly to have different rules on different architectures.  On x86,
__cpuexit currently means "you can drop it if you're not gonna be
removing cpus after system boot"; IOW, __cpuexit is strict subset of
__cpuinit.  If you define it as "don't include it in the text at all
if cpus are not gonna be removed", it actually forces you to carry
more text in the running system.  Is there any reason ia64 drops them
during linking?

Thanks.

-- 
tejun
