Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262Ab1LLKRM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 05:17:12 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:38603 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105Ab1LLKRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 05:17:11 -0500
X-Auth-Info: 3xzxgDGLsm+YSxyw3YrjMm8xG4FYpR/F69s+G8kvf0Y=
From: Andreas Schwab <schwab@linux-m68k.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Michal Hocko <mhocko@suse.cz>,
        "Artem S. Tashkinov" <t.artem@mailcity.com>,
        Dave Jones <davej@redhat.com>, Alexey Dobriyan <adobriyan@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] procfs: do not confuse jiffies with cputime64_t
References: <m28vmi7ip3.fsf@igel.home> <201112120922.13633.arnd@arndb.de>
X-Yow: RELATIVES!!
Date: Mon, 12 Dec 2011 11:17:06 +0100
In-Reply-To: <201112120922.13633.arnd@arndb.de> (Arnd Bergmann's message of
	"Mon, 12 Dec 2011 09:22:13 +0000")
Message-ID: <m2wra2f61p.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann <arnd@arndb.de> writes:

> On Monday 12 December 2011, Andreas Schwab wrote:
>> @@ -46,7 +46,7 @@ static cputime64_t get_iowait_time(int cpu)
>>                 /* !NO_HZ so we can rely on cpustat.iowait */
>>                 iowait = kstat_cpu(cpu).cpustat.iowait;
>>         else
>> -               iowait = nsecs_to_jiffies64(1000 * iowait_time);
>> +               iowait = jiffies64_to_cputime64(nsecs_to_jiffies64(1000 * iowait_time));
>>  
>>         return iowait;
>
> Hmm, shouldn't this be using nsecs_to_cputime64()? For some reason however, that function
> is (incorrectly?) defined as 
>
> include/asm-generic/cputime.h:#define nsecs_to_cputime64(__ct)  nsecs_to_jiffies64(__ct)
>
> and only used in one place, in
>
> kernel/sched.c: if (cputime64_gt(nsecs_to_cputime64(latest_ns), cpustat->irq))
> kernel/sched.c: if (cputime64_gt(nsecs_to_cputime64(latest_ns), cpustat->softirq))
>
> I'm not sure what the correct solution is, but I would assume that ia64 and powerpc
> should fix their definitions of nsecs_to_cputime64() anyway.

There is no definition of nsecs_to_cputime64 on ia64/powerpc64 with
CONFIG_VIRT_CPU_ACCOUNTING yet, probably because
CONFIG_IRQ_TIME_ACCOUNTING is x86-only.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
