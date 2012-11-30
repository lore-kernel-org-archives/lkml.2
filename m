Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759276Ab2K3SHM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 13:07:12 -0500
Received: from mail-vc0-f170.google.com ([209.85.220.170]:60003 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466Ab2K3SHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 13:07:10 -0500
X-Greylist: delayed 1731 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 Nov 2012 13:07:10 EST
MIME-Version: 1.0
In-Reply-To: <1354125783-15816-1-git-send-email-hakanakkan@gmail.com>
References: <1354091364-7920-1-git-send-email-hakanakkan@gmail.com>
	<1354125783-15816-1-git-send-email-hakanakkan@gmail.com>
Date: Fri, 30 Nov 2012 18:38:16 +0100
Message-ID: <CAFTL4hwSva0eBK1f=K7Hus0ybiEACtebQbhEUDsJjLZcmmeCtA@mail.gmail.com>
Subject: Re: [PATCH] nohz/cpuset: Make a CPU stick with do_timer() duty in the
 presence of nohz cpusets
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Hakan Akkan <hakanakkan@gmail.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/11/28 Hakan Akkan <hakanakkan@gmail.com>:
> +static int check_drop_timer_duty(int cpu)
> +{
> +       int curr_handler, prev_handler, new_handler;
> +       int nrepeat = -1;
> +       bool drop_recheck;
> +
> +repeat:
> +       WARN_ON_ONCE(++nrepeat > 1);
> +       drop_recheck = false;
> +       curr_handler = cpu;
> +       new_handler = TICK_DO_TIMER_NONE;
> +
> +#ifdef CONFIG_CPUSETS_NO_HZ
> +       if (atomic_read(&nr_cpus_user_nohz) > 0) {

Note atomic_read() is not SMP ordered. If another CPU does
atomic_add() or atomic_add_return(), you may not see the new value as
expected with atomic_read(). Doing atomic_add_return(0, &atomic_thing)
returns the fully ordered result.

You also need to do that to ensure full ordering against
tick_cpu_sched.user_nohz.

On the current layout we have:

(Write side)                                      (Read side)

ts->user_nohz = 1;
atomic_inc(&nr_cpus_user_nohz)

                                                      if
(atomic_read(&nr_cpus_user_nohz))
                                                            if
(per_cpu(tick_cpu_sched, curr_handler).user_nohz)
                                                                ....

If you want to make sure that you see the expected value on user_nohz
from the read side, you need to correctly order the write and read
against nr_cpus_user_nohz.

For this you can use atomic_add_return() which implies the full barrier:


(Write side)                                      (Read side)

ts->user_nohz = 1;
atomic_inc_return(&nr_cpus_user_nohz)

                                                      if
(atomic_add_return(0, &nr_cpus_user_nohz))
                                                            if
(per_cpu(tick_cpu_sched, curr_handler).user_nohz)
                                                                ....

I have much more comments on this patch, I will come back on this soon.

Thanks.
