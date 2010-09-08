Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758359Ab0IHJBy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 05:01:54 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:13295 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714Ab0IHJBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 05:01:52 -0400
Message-ID: <4C8750B8.6000107@atmel.com>
Date: Wed, 08 Sep 2010 11:00:40 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; fr; rv:1.9.2.8) Gecko/20100802 Lightning/1.0b2 Thunderbird/3.1.2
MIME-Version: 1.0
To: "avictor.za@gmail.com" <avictor.za@gmail.com>,
        linux-arm-kernel@lists.infradead.org
CC: linux-kernel@vger.kernel.org, Fabian Godehardt <fg@emlix.com>
Subject: Re: [PATCH] AT91: SAM9G45 - add a separate clock entry for every
 single TC block
References: <201009060548.18521.fg@emlix.com>	<1283772201-15453-1-git-send-email-nicolas.ferre@atmel.com> <AANLkTin+vCsG3FUvX6DTUfFe7ZJpbkYyqw_TLvH9ujrJ@mail.gmail.com>
In-Reply-To: <AANLkTin+vCsG3FUvX6DTUfFe7ZJpbkYyqw_TLvH9ujrJ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 07/09/2010 21:42, avictor.za@gmail.com :
> hi,
> 
>> +/* One additional fake clock for second TC block */
>> +static struct clk tcb1_clk = {
>> +       .name           = "tcb1_clk",
>> +       .pmc_mask       = 0,
>> +       .type           = CLK_TYPE_PERIPHERAL,
>> +       .parent         = &tcb0_clk,
>> +};
>> +
> 
> Looking at this again...  since type is CLK_TYPE_PERIPHERAL, when you
> call clk_register() the "parent" is changed to the master clock.
> 
> Which means, then later you call clk_enable() the "pmc_mask" is still
> 0, so 0 gets written (in pmc_periph_mode) to AT91_PMC_PCER.  So the
> TCB clock won't be enabled.
> 
> Or am I missing something?

You are absolutely right!

What do you think about this modification of clk_register() function?

--- a/arch/arm/mach-at91/clock.c
+++ b/arch/arm/mach-at91/clock.c
@@ -501,7 +501,8 @@ postcore_initcall(at91_clk_debugfs_init);
 int __init clk_register(struct clk *clk)
 {
        if (clk_is_peripheral(clk)) {
-               clk->parent = &mck;
+               if (!clk->parent)
+                       clk->parent = &mck;
                clk->mode = pmc_periph_mode;
                list_add_tail(&clk->node, &clocks);
        }

It is a very little modification which implements what I had in mind
while creating a kind of "child peripheral" clock.

Best regards,
-- 
Nicolas Ferre

