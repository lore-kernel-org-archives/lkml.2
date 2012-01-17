Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755786Ab2AQUYn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 15:24:43 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:49315 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755555Ab2AQUYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 15:24:41 -0500
Date: Tue, 17 Jan 2012 20:24:32 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Simon Glass <sjg@chromium.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH] ARM: Adjust backtrace messages to line up with x86
	kernel
Message-ID: <20120117202432.GW1068@n2100.arm.linux.org.uk>
References: <1326831362-28703-1-git-send-email-sjg@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326831362-28703-1-git-send-email-sjg@chromium.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 17, 2012 at 12:16:01PM -0800, Simon Glass wrote:
> It is nice to print the backtrace message on its own line, and also
> regardless of the setting of CONFIG_ARM_UNWIND. This means that tools
> which parse the backtrace don't need a special case for the first line.
> It also makes it more like the x86 kernel output.
> 
> I believe we should also put KERN_EMERG at the start of this. Otherwise
> it won't appear in console output (although it will appear in the logs
> after a reboot).
> 
> The impact of this change is that the log output changes from something
> like:
> 
> [    2.861692] 7fe0: 01beb1b8 befcb7d4 0000aebb 40284334 80000010 01be4668 00000000 00000000
> [    2.869866] Backtrace: [<c00bb3f4>] (module_put+0x44/0xc0) from [<c00bdd98>] (sys_init_module+0x186c/0x19c4)

You should not be getting it like this; I've never seen an oops dump
containing stuff formatted in this way on ARM.

If you care to look at the code, you'll notice that we have:

        printk("Backtrace: ");
...
	if () {
                printk("no frame pointer");
	} else if () {
                printk("invalid frame pointer 0x%08x", fp);
	} else if ()
                printk("frame pointer underflow");
	printk("\n");

	if (ok)
		c_backtrace();

So, by adding the '\n' at the end of the first printk, not only will you
add an additional blank line to the backtrace, but also move those
backtrace warning messages onto their own line, further pushing up the
number of lines an oops dump produces.

However, the lack of "Backtrace:" with ARM_UNWIND set needs fixing -
but please look at the unwind_backtrace() function first, and notice
that it contains its own version of this message (using __func__
instead - which is probably a bad idea.)  That needs fixing too.
