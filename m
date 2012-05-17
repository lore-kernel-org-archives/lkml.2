Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932846Ab2EQJbO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 05:31:14 -0400
Received: from casper.infradead.org ([85.118.1.10]:34119 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760865Ab2EQJbN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 05:31:13 -0400
Message-ID: <1337247064.4281.18.camel@twins>
Subject: Re: [PATCH] printk: do not flush the logbuf into console driver in
 interrupt
From: Peter Zijlstra <peterz@infradead.org>
To: "Liu, Chuansheng" <chuansheng.liu@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        Yanmin
	 "Zhang <yanmin_zhang@linux.intel.com> (yanmin_zhang@linux.intel.com)" 
	<yanmin_zhang@linux.intel.com>
Date: Thu, 17 May 2012 11:31:04 +0200
In-Reply-To: <27240C0AC20F114CBF8149A2696CBE4A0B1F0B@SHSMSX101.ccr.corp.intel.com>
References: <27240C0AC20F114CBF8149A2696CBE4A0B1F0B@SHSMSX101.ccr.corp.intel.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-17 at 07:46 +0000, Liu, Chuansheng wrote:
> From: liu chuansheng <chuansheng.liu@intel.com>
> Subject: [PATCH] printk: do not flush the logbuf into console driver in interrupt
> 
> When irq handle tried to call printk, and it also has the chance to obtain the console sem,
> then flush the log buf to console driver,but the console driver often give several ms latency
> or more when much data in log buf existed, it will delay the irq handle.
> 
> The solution is when calling the printk in interrupt, just write the chars into log buf,
> and expect other threads to flush it into console driver.
> 
> Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
> 
> diff --git a/kernel/printk.c b/kernel/printk.c index b663c2c..99959e1 100644
> --- a/kernel/printk.c
> +++ b/kernel/printk.c
> @@ -804,7 +804,8 @@ static int console_trylock_for_printk(unsigned int cpu)
>                  * the buffer. We need to hold the console semaphore
>                  * in order to do this test safely.
>                  */
> -               if (!can_use_console(cpu)) {
> +               if (!can_use_console(cpu) ||
> +                       (in_interrupt() && (!oops_in_progress))) {
>                         console_locked = 0;
>                         wake = 1;
>                         retval = 0;

Uhm no.. I would very much like to get my OOPSes from interrupt context
to make it out to the console.
