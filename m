Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215Ab1ISPXu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 11:23:50 -0400
Received: from service87.mimecast.com ([91.220.42.44]:35196 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752246Ab1ISPXt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 11:23:49 -0400
Message-ID: <4E775E95.2020806@arm.com>
Date: Mon, 19 Sep 2011 16:24:05 +0100
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Abhijeet Dharmapurikar <adharmap@codeaurora.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH 1/3] genirq: add support for per-cpu dev_id interrupts
References: <1316105551-17505-1-git-send-email-marc.zyngier@arm.com> <1316105551-17505-2-git-send-email-marc.zyngier@arm.com> <4E767CD6.6090208@codeaurora.org> <4E770B3E.9040401@arm.com> <4E775912.3060502@arm.com> <20110919150526.GV16381@n2100.arm.linux.org.uk>
In-Reply-To: <20110919150526.GV16381@n2100.arm.linux.org.uk>
X-Enigmail-Version: 1.2.1
X-OriginalArrivalTime: 19 Sep 2011 15:23:42.0566 (UTC) FILETIME=[1D71F060:01CC76E0]
X-MC-Unique: 111091916234616501
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/09/11 16:05, Russell King - ARM Linux wrote:
> On Mon, Sep 19, 2011 at 04:00:34PM +0100, Marc Zyngier wrote:
>> Replying to myself after a quick investigation... Looks like the Qualcomm
>> implementation does exactly what is mentioned above:
>>
>> arch/arm/mach-msm/platsmp.c:
>> void __cpuinit platform_secondary_init(unsigned int cpu)
>> {
>> 	/* Configure edge-triggered PPIs */
>> 	writel(GIC_PPI_EDGE_MASK, MSM_QGIC_DIST_BASE + GIC_DIST_CONFIG + 4);
>> 	[...]
>>
>> The way I understand it, this "MSM_QGIC_DIST_BASE + GIC_DIST_CONFIG + 4"
>> is a banked register (otherwise we would not do it in platform_secondary_init(),
>> right?) So doing a set_type() from __setup_irq() would be just wrong. It really
>> needs to be done on a per-CPU basis.
> 
> All the registers to do with the first 32 interrupts in the distributer
> are banked - the enable, configuration, and priority registers are all
> only accessible to the specific CPU which owns the PPIs and SGIs.

Indeed. The major difference is that the configuration registers for the
PPIs seem to be writable on MSM (11MP and A9 have them RO).

	M.
-- 
Jazz is not dead. It just smells funny...

