Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756625Ab0JDQbl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 12:31:41 -0400
Received: from www.tglx.de ([62.245.132.106]:39707 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752237Ab0JDQbk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 12:31:40 -0400
Date: Mon, 4 Oct 2010 18:31:23 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jiri Slaby <jslaby@suse.cz>
cc: LKML <linux-kernel@vger.kernel.org>, clemens@ladisch.de, venki@google.com,
        the arch/x86 maintainers <x86@kernel.org>
Subject: Re: HPET causes tasks to freeze (still in 2.6.36-rc6)
In-Reply-To: <4CA9F471.2080704@suse.cz>
Message-ID: <alpine.LFD.2.00.1010041747550.14550@localhost6.localdomain6>
References: <4CA9F471.2080704@suse.cz>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Oct 2010, Jiri Slaby wrote:

> Hi,
> 
> HPET as a clocksource has still issues in the latest kernels (confirmed
> in 2.6.36-rc6) at least on x86_64. Unless clocksource=jiffies,
> clocksource=tsc or nolapic_timer is used, the system is unusable. Tasks
> are not woken unless mouse is moved, key is pressed (or other hard irq
> triggered). 2.6.32 seems to be the last working.

The problem is not clocksource related, it's NOHZ related.

clocksource=jiffies, clocksource=tsc are disabling NOHZ simply because
we can not do NOHZ neither with jiffies nor with a TSC which stops in
deeper C-states.

nolapic_timer installs a dummy lapic timer so the lapic is not used,
but HPET is used instead and NOHZ is disabled as well.

So the real problem is that the hpet broadcast interrupts which are
used to work around the lapic timer stops in C3 problem are not coming
through for whatever reason.

So the question is what changed in the ACPI/idle NOHZ code which might
expose this problem.

Can we get dmesg, output of proc/timer_list and output of
/proc/acpi/processor/CPU0/power for a .32 and a non working kernel
please ?

> "My clock is seriously lagging behind. After having used hpet for 10.5
> hours now, the clock is 5.5 hours too late!"

That's probably a side effect.

> dmesg is attached. Any ideas what's still wrong with HPET?

Nothing as far as I can tell :)

Thanks,

	tglx
