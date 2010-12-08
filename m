Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755923Ab0LHPXw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 10:23:52 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42620 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755676Ab0LHPXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 10:23:51 -0500
Date: Wed, 8 Dec 2010 15:23:29 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jeff Ohlstein <johlstei@codeaurora.org>
Cc: Daniel Walker <dwalker@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        David Brown <davidb@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>
Subject: Re: [PATCH v2 5/6] msm: hotplug: support cpu hotplug on msm
Message-ID: <20101208152329.GI9777@n2100.arm.linux.org.uk>
References: <1291782501-3909-1-git-send-email-johlstei@codeaurora.org> <1291782501-3909-6-git-send-email-johlstei@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291782501-3909-6-git-send-email-johlstei@codeaurora.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 07, 2010 at 08:28:20PM -0800, Jeff Ohlstein wrote:
> +static inline void cpu_enter_lowpower(void)
> +{
> +	flush_cache_all();
> +}
> +
> +static inline void cpu_leave_lowpower(void)
> +{
> +	pen_release = -1;
> +	smp_wmb();
> +}
> +
> +static inline void platform_do_lowpower(unsigned int cpu)
> +{
> +	/* Just enter wfe for now. */
> +	for (;;) {
> +		asm("wfe");
> +		if (pen_release == cpu) {
> +			/*
> +			 * OK, proper wakeup, we're done
> +			 */
> +			break;
> +		}
> +		smp_rmb();
> +
> +		/*
> +		 * getting here, means that we have come out of WFI without
> +		 * having been woken up - this shouldn't happen
> +		 *
> +		 * The trouble is, letting people know about this is not really
> +		 * possible, since we are currently running incoherently, and
> +		 * therefore cannot safely call printk() or anything else
> +		*/
> +		pr_debug("CPU%u: spurious wakeup call\n", cpu);
> +	}
> +}

BTW, just because Realview and Versatile Express implement their hotplug
CPU tihs way, does not mean that you have to as well.  If you can put the
CPU to sleep properly without keeping it in the kernel, that would be far
more preferable, than having platform_cpu_die() return on hot-plugging.
