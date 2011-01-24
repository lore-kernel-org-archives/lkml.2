Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752477Ab1AXJvv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 04:51:51 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:48160 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751606Ab1AXJvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 04:51:50 -0500
Date: Mon, 24 Jan 2011 09:51:38 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Sven Neumann <s.neumann@raumfeld.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Eric Miao <eric.y.miao@gmail.com>, Daniel Mack <daniel@caiaq.de>
Subject: Re: kernel NULL pointer dereference in pxa_pm_enter (2.6.38-rc2)
Message-ID: <20110124095138.GC16202@n2100.arm.linux.org.uk>
References: <1295861380.2044.26.camel@sven>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295861380.2044.26.camel@sven>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 24, 2011 at 10:29:39AM +0100, Sven Neumann wrote:
> I am still trying to get our Raumfeld platform working with kernels
> newer than 2.6.36 and this morning I've updated to 2.6.38-rc2 to see if
> any of the remaining problems with 2.6.37 have been fixed. Kernel boots
> fine, but it crashes on suspend:

It seems that aae8224d is wrong:

@@ -225,9 +201,6 @@ static int pxa3xx_cpu_pm_valid(suspend_state_t state)
 }

 static struct pxa_cpu_pm_fns pxa3xx_cpu_pm_fns = {
-       .save_count     = SLEEP_SAVE_COUNT,
-       .save           = pxa3xx_cpu_pm_save,
-       .restore        = pxa3xx_cpu_pm_restore,
        .valid          = pxa3xx_cpu_pm_valid,
        .enter          = pxa3xx_cpu_pm_enter,
 };

whereas the generic code does this:

        /* skip registers saving for standby */
        if (state != PM_SUSPEND_STANDBY) {
                pxa_cpu_pm_fns->save(sleep_save);

so, pxa_cpu_pm_fns->save is now a NULL pointer, hence the PC address in
the oops of 0x0.
