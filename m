Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752498Ab2GDNXP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 09:23:15 -0400
Received: from merlin.infradead.org ([205.233.59.134]:58911 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022Ab2GDNXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 09:23:11 -0400
Subject: Re: [PATCH] printk: fixing the deadlock when calling printk in nmi
 handle
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Liu, Chuansheng" <chuansheng.liu@intel.com>
Cc: "'linux-kernel@vger.kernel.org' (linux-kernel@vger.kernel.org)" 
	<linux-kernel@vger.kernel.org>,
        "kay@vrfy.org" <kay@vrfy.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "mingo@elte.hu" <mingo@elte.hu>
In-Reply-To: <27240C0AC20F114CBF8149A2696CBE4A10C7F6@SHSMSX101.ccr.corp.intel.com>
References: <27240C0AC20F114CBF8149A2696CBE4A10C7F6@SHSMSX101.ccr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 Jul 2012 15:22:49 +0200
Message-ID: <1341408169.2507.111.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-07-04 at 13:00 +0000, Liu, Chuansheng wrote:
> From: liu chuansheng <chuansheng.liu@intel.com>
> Subject: [PATCH] printk: fixing the deadlock when calling printk in nmi handle
> 
> Current printk implementation can not fully support that
> calling it in nmi handler for SMP arch.
> 
> There is typical case in nmi handler function arch_trigger_all_cpu_backtrace_handler().
> 
> In my platform, there are 2 CPUs, when function arch_trigger_all_cpu_backtrace()
> is called, 2 CPUs will recevied the nmi interrupts, and the
> arch_trigger_all_cpu_backtrace_handler() will called on 2 CPUs:
> 
> case1:
> CPU0                                            CPU1
> calling arch_trigger_all_cpu_backtrace()        calling printk, and has obtain the logbuf_lock
> nmi interrupt received                          nmi interrupt received
> call arch_trigger_all_cpu_backtrace_handler()   call arch_trigger_all_cpu_backtrace_handler()
> Obtain arch_spin_lock(&lock);                   Waiting for arch_spin_lock(&lock);
> Continue to call printk()
> CPU0 will be blocked by logbuf_lock             CPU1 is blocked by arch_spin_lock(&lock)
> 
> The deadlock will be happening.
> 
> case2:
> CPU0                                             CPU1:(run dmesg command)
> calling arch_trigger_all_cpu_backtrace()         calling do_syslog
>                                                  Obtaining the logbuf_lock
> nmi interrupt received                           nmi interrupt received
> ....
> The dealock will happen also somtimes.
> 
> I just write a simple interface to run the arch_trigger_all_cpu_backtrace_handler() every 5s,
> it will trigger dead lock many times.
> 
> The solution is when printk is called in nmi handler, we will use trylock instead of lock.
> And in nmi handler, do the call the console write function because normal console write function
> include many spin locks also. This fix can confirm the traces in nmi handler can be output successfully
> almost.
> 
> Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>


Yuck.. and no. This makes sane things like early 8250 serial console
less reliable.



