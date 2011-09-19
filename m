Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755120Ab1ISPFu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 11:05:50 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:33622 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753134Ab1ISPFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 11:05:49 -0400
Date: Mon, 19 Sep 2011 16:05:26 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Abhijeet Dharmapurikar <adharmap@codeaurora.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH 1/3] genirq: add support for per-cpu dev_id
	interrupts
Message-ID: <20110919150526.GV16381@n2100.arm.linux.org.uk>
References: <1316105551-17505-1-git-send-email-marc.zyngier@arm.com> <1316105551-17505-2-git-send-email-marc.zyngier@arm.com> <4E767CD6.6090208@codeaurora.org> <4E770B3E.9040401@arm.com> <4E775912.3060502@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E775912.3060502@arm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 19, 2011 at 04:00:34PM +0100, Marc Zyngier wrote:
> Replying to myself after a quick investigation... Looks like the Qualcomm
> implementation does exactly what is mentioned above:
> 
> arch/arm/mach-msm/platsmp.c:
> void __cpuinit platform_secondary_init(unsigned int cpu)
> {
> 	/* Configure edge-triggered PPIs */
> 	writel(GIC_PPI_EDGE_MASK, MSM_QGIC_DIST_BASE + GIC_DIST_CONFIG + 4);
> 	[...]
> 
> The way I understand it, this "MSM_QGIC_DIST_BASE + GIC_DIST_CONFIG + 4"
> is a banked register (otherwise we would not do it in platform_secondary_init(),
> right?) So doing a set_type() from __setup_irq() would be just wrong. It really
> needs to be done on a per-CPU basis.

All the registers to do with the first 32 interrupts in the distributer
are banked - the enable, configuration, and priority registers are all
only accessible to the specific CPU which owns the PPIs and SGIs.
