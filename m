Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753Ab1IBR0e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 13:26:34 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:36869 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753584Ab1IBR0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 13:26:33 -0400
Date: Fri, 2 Sep 2011 18:22:59 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Ulrich Weigand <Ulrich.Weigand@de.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linaro-toolchain@lists.linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Tejun Heo <tj@kernel.org>,
        Martin Schwidefsky <martin.schwidefsky@de.ibm.com>
Subject: Re: try_to_freeze() called with IRQs disabled on ARM
Message-ID: <20110902172259.GA6619@n2100.arm.linux.org.uk>
References: <20110823220056.GK3895@n2100.arm.linux.org.uk> <20110825130907.GO3286@htj.dyndns.org> <20110825145558.GF8883@n2100.arm.linux.org.uk> <201108261644.26329.arnd@arndb.de> <OF2C5ADB6A.65B1BE36-ONC12578FE.00493A67-C12578FE.004B3315@de.ibm.com> <20110901140000.GF29729@n2100.arm.linux.org.uk> <OF69A57AB0.CF22689A-ONC12578FF.004EDD71-C12578FF.005142FF@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OF69A57AB0.CF22689A-ONC12578FF.004EDD71-C12578FF.005142FF@de.ibm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 02, 2011 at 04:47:35PM +0200, Ulrich Weigand wrote:
> Assume the scenario you initally describe, where a first signal is
> ignored and leads to system call restart.  With your latest patch,
> you call into syscall_restart which sets everything up to restart
> the call (with interrupts disabled).

I don't think SIG_IGN signals even set the TIF work flag, so they
never even cause a call into do_signal().  Therefore, as far as
syscalls go, attempting to send a process (eg) a SIGINT which its
handler is set to SIG_IGN results in the process not even being
notified about the attempt - we won't even wake up while the
syscall is sleeping.

> To really fix this case would probably require some way for the
> debugger to save and restore the restore_block saved state.  This
> is not quite trivial, since it would expose that state to user space,
> effectively creating a new ABI (and probably requiring sanity checks
> to ensure a valid state is restored).  This probably cannot be fixed
> by one architecture for itself, but would need support from common
> kernel code.

Such state would have to be crytographically signed or kept entirely
within the kernel, as it would otherwise mean that you could redirect
the kernel PC to anywhere...
