Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030535Ab2COO60 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 10:58:26 -0400
Received: from www.linutronix.de ([62.245.132.108]:40729 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030266Ab2COO6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 10:58:23 -0400
Date: Thu, 15 Mar 2012 15:58:20 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Sasha Levin <levinsasha928@gmail.com>
cc: John Stultz <john.stultz@linaro.org>, Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: ntp: BUG: spinlock lockup on CPU#1
In-Reply-To: <alpine.LFD.2.02.1203151440590.2466@ionos>
Message-ID: <alpine.LFD.2.02.1203151556090.2466@ionos>
References: <CA+1xoqcGcfYzjrvRU-z=mUSq+wgqfBqdM51shV5gk4ohfe5Wng@mail.gmail.com> <alpine.LFD.2.02.1203151440590.2466@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Mar 2012, Thomas Gleixner wrote:
> CPU 0                                                    CPU 1
> do_adjtimex()
>   spin_lock_irq(&ntp_lock);
>     process_adjtimex_modes();				 timer_interrupt()
>       process_adj_status();                                do_timer()
>         ntp_start_leap_timer();                             write_lock(&xtime_lock);
>           hrtimer_start();                                  update_wall_time();
>              hrtimer_reprogram();                            ntp_tick_length()
>                tick_program_event()                            spin_lock(&ntp_lock);
>                  clockevents_program_event()
> 		   ktime_get()
>                      seq = req_seqbegin(xtime_lock);
> 
> So CPU0 waits for xtime seqence to become valid and CPU1 cant make
> progress because it's stuck on ntp_lock.

The same problem exists with ntp_clear() being called under the
xtime/timekeeper lock write locked. Nasty ...
