Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755715Ab0FCUnv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 16:43:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55323 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754833Ab0FCUnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 16:43:50 -0400
Date: Thu, 3 Jun 2010 13:43:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kevin Cernekee <cernekee@gmail.com>
Cc: Paul Mundt <lethal@linux-sh.org>, mingo@elte.hu,
       simon.kagstrom@netinsight.net, David.Woodhouse@intel.com,
       rgetz@analog.com, linux-kernel@vger.kernel.org,
       linux-mips@linux-mips.org
Subject: Re: [PATCH v2] printk: fix delayed messages from CPU hotplug events
Message-Id: <20100603134310.b5bae74e.akpm@linux-foundation.org>
In-Reply-To: <AANLkTinY8Htz2bb2I_oN5iWtAjxuDkGzAvX_4TbtmKBh@mail.gmail.com>
References: <ede63b5a20af951c755736f035d1e787772d7c28@localhost>
	<20100601031528.GC15411@linux-sh.org>
	<AANLkTinY8Htz2bb2I_oN5iWtAjxuDkGzAvX_4TbtmKBh@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 May 2010 21:04:42 -0700
Kevin Cernekee <cernekee@gmail.com> wrote:

> On Mon, May 31, 2010 at 8:15 PM, Paul Mundt <lethal@linux-sh.org> wrote:
> > If this is to be entirely restricted to CPU hotplug then you could use
> > the hotcpu notifier here instead of the open-coded cpu notifier directly,
> > the former wraps to the latter in the CPU hotplug case and is simply a
> > nop for the regular SMP case.
> 
> I ran some tests and saw the same problem during the regular MIPS SMP
> boot.  i.e. adding "while (1) { }" at the end of __cpu_up() prevents
> any of the probing/calibration messages originating on CPU1 from ever
> being echoed to the console.  Adding the semaphore code before the
> while loop caused the CPU1 messages to reappear.
> 
> Under normal circumstances you won't ever notice the problem at boot
> time, because printing "Brought up %ld CPUs" has the undocumented side
> effect of flushing out any messages that got stuck during SMP init.
> And if that printk() wasn't there, the next one (from NET, PCI, SCSI,
> ...) would surely take its place.
> 
> But in the case of MIPS CPU hotplug, there is no such printk() at the
> end, and so our luck runs out.

no....  What Paul means is "please use hotcpu_notifier".  It's a
higher-level interface which yields a smaller vmlinux if
CONFIG_HOTPLUG_CPU=n.  grep around for some examples...


other comments:
 
>  /**
> + * console_cpu_notify - print deferred console messages after CPU hotplug
> + *
> + * If printk() is called from a CPU that is not online yet, the messages
> + * will be spooled but will not show up on the console.  This function is
> + * called when a new CPU comes online and ensures that any such output
> + * gets printed.
> + */

It's conventional (although boring and usually useless) to kerneldocify
the arguments also.

> +static int __cpuinit console_cpu_notify(struct notifier_block *self,
> +	unsigned long action, void *hcpu)
> +{
> +	switch (action) {
> +	case CPU_ONLINE:
> +	case CPU_UP_CANCELED:
> +		if (try_acquire_console_sem() == 0)
> +			release_console_sem();
> +	}
> +	return NOTIFY_OK;
> +}

Would prefer to see acquire_console_sem() used here.  Because
try_acquire_console_sem() might simply fail, and the messages still get
stuck.  Possible?  If "not possible" then "needs a code comment".

> +static struct notifier_block __cpuinitdata console_nb = {
> +	.notifier_call		= console_cpu_notify,
> +};
> +
> +static int __init console_notifier_init(void)
> +{
> +	register_cpu_notifier(&console_nb);
> +	return 0;
> +}
> +late_initcall(console_notifier_init);

We don't really need two late_initcall() functions in printk.c.  We'd
save a few bytes by renaming disable_boot_consoles() to
printk_late_init() or something, then adding the hotcpu_notifier() call
there.

otoh, that's a bit of a reduction in source-level quality.

otoh2, perhaps late_initcall() was inappropriate for
console_notifier_init().  Why not do it earlier?

I'll let you decide ;)

