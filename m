Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753106Ab2ITRgn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 13:36:43 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:37097 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751693Ab2ITRgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 13:36:41 -0400
Date: Thu, 20 Sep 2012 18:35:56 +0100
From: Will Deacon <will.deacon@arm.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: hw_breakpoint: Clear breakpoints before enabling
 monitor mode
Message-ID: <20120920173556.GQ4654@mudshark.cambridge.arm.com>
References: <1348160260-19486-1-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348160260-19486-1-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Thu, Sep 20, 2012 at 05:57:40PM +0100, Stephen Boyd wrote:
> The reset value of the BCR, BVR, WCR, and WVR registers are all
> UNKNOWN on ARMv7. Unfortunately, reset_ctrl_regs() clears these
> registers *after* enabling monitor mode, not before, and so some
> implementations may experience UNPREDICTABLE behavior if the
> reset values of these registers are non-zero. Clear the
> breakpoints before enabling monitor mode so that we don't
> experience boot hangs/loops due to breakpoints being enabled
> out of reset.
> 
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>

Aha, thanks for the patch. We should definitely zero these registers before
enabling monitor mode. However...

> +/* Determine if halting mode is enabled */
> +static int halting_mode_enabled(void)
> +{
> +	u32 dscr;
> +
> +	ARM_DBG_READ(c1, 0, dscr);
> +
> +	if (WARN_ONCE(dscr & ARM_DSCR_HDBGEN,
> +		"halting debug mode enabled. Unable to access hardware resources.\n")) {
> +		return -EPERM;
> +	}
> +	return 0;
> +}

...it looks like debug arch 7.1 defines this bit as UNKNOWN when the OS lock
is clear, so we probably shouldn't be reading it at all. I'll pour myself a
stiff drink and start reading the debug arch docs to work out what on Earth
we should do.

Stay tuned.

Will
