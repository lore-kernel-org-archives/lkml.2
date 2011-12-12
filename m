Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191Ab1LLJXA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 04:23:00 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:56172 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852Ab1LLJW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 04:22:58 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Andreas Schwab <schwab@linux-m68k.org>
Subject: Re: [PATCH] procfs: do not confuse jiffies with cputime64_t
Date: Mon, 12 Dec 2011 09:22:13 +0000
User-Agent: KMail/1.12.2 (Linux/3.2.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Michal Hocko <mhocko@suse.cz>,
        "Artem S. Tashkinov" <t.artem@mailcity.com>,
        Dave Jones <davej@redhat.com>, Alexey Dobriyan <adobriyan@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
References: <m28vmi7ip3.fsf@igel.home>
In-Reply-To: <m28vmi7ip3.fsf@igel.home>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201112120922.13633.arnd@arndb.de>
X-Provags-ID: V02:K0:JLOchBcr4a0+bi2poreYcUHoNrdRxt0khoAJ3PV5BfK
 ZTmK5i3bKn6Wzi/JqGzdx65skCcBebnp1LDCm5b2gxIeAmWQoR
 +wrdvPwZ5zv05rx/Io5xFqxU6+CRdCoQaOKAdE2lPmzneP9Vuj
 G1oHyWZmKwFULrdv0RQKEoGZN3NrL0eP2Hk9gGr0ex+kZo8GAN
 IqXhydY7waOqx1zUieNfW1IER8YZppmXQT/Loh/OkVih02FZAo
 nQBtTWP1WFZNkscYGfYc+EW7IliHXDLPtiMNqkdBa1OfOGu4P1
 kVyKzw6R3RBCece56iwbu5yGjq/6hiJegZkmjoJ+fOz+th5kG9
 iwSkPf+TM1717PPkAz8g=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 December 2011, Andreas Schwab wrote:
> @@ -46,7 +46,7 @@ static cputime64_t get_iowait_time(int cpu)
>                 /* !NO_HZ so we can rely on cpustat.iowait */
>                 iowait = kstat_cpu(cpu).cpustat.iowait;
>         else
> -               iowait = nsecs_to_jiffies64(1000 * iowait_time);
> +               iowait = jiffies64_to_cputime64(nsecs_to_jiffies64(1000 * iowait_time));
>  
>         return iowait;

Hmm, shouldn't this be using nsecs_to_cputime64()? For some reason however, that function
is (incorrectly?) defined as 

include/asm-generic/cputime.h:#define nsecs_to_cputime64(__ct)  nsecs_to_jiffies64(__ct)

and only used in one place, in

kernel/sched.c: if (cputime64_gt(nsecs_to_cputime64(latest_ns), cpustat->irq))
kernel/sched.c: if (cputime64_gt(nsecs_to_cputime64(latest_ns), cpustat->softirq))

I'm not sure what the correct solution is, but I would assume that ia64 and powerpc
should fix their definitions of nsecs_to_cputime64() anyway.

	Arnd
