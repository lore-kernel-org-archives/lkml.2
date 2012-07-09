Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753110Ab2GILBf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 07:01:35 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59365 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841Ab2GILBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 07:01:34 -0400
Message-ID: <1341831686.4343.7.camel@phoenix>
Subject: Re: [PATCH RFT 1/2] regulator: twl: Fix the formula to calculate
 vsel and voltage for twl6030ldo
From: Axel Lin <axel.lin@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Rajendra Nayak <rnayak@ti.com>, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Date: Mon, 09 Jul 2012 19:01:26 +0800
In-Reply-To: <1341804151.14367.1.camel@phoenix>
References: <1341804151.14367.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

於 一，2012-07-09 於 11:22 +0800，Axel Lin 提到：
> In twl6030ldo_set_voltage, current code use below formula to calculate vsel:
>         vsel = (min_uV/1000 - 1000)/100 + 1;
> This is worng because when min_uV is 1000000 uV, vsel is 1.
> It should be 0 in this case.
> Fix it by change the equation to: (This equation is common for linear mapping)
>         vsel = DIV_ROUND_UP(min_uV - rdev->desc->min_uV, rdev->desc->uV_step);
> 
> In twl6030ldo_get_voltage, current code use below formula to calculate voltage:
>         mV = 1000mv + 100mv * (vsel - 1)
> This is worng because when vsel is 0, mV is 900mV. Note the min_uV is 1000mV.
> Fix it by change the equation to: (This equation is common for linear mapping)
>         return rdev->desc->min_uV + vsel * rdev->desc->uV_step;

While I'm thinking I need to rework this patch so that it doesn't use
rdev->desc->min_uV and rdev->desc->uV_step and then can be applied
to current Linus' tree.

But while I am tracking back to commit 3e3d3be79c
Author: Rajendra Nayak <rnayak@ti.com>
Date:   Thu Apr 22 14:18:32 2010 +0530

    twl6030: regulator: Remove vsel tables and use formula for
calculation
    
    All twl6030 regulators can be programmed from 1.0v to 3.3v
    with 100mV steps.
    The below formula can be used to calculate the vsel values
    to be programmed in the VREG_VOLTAGE registers.
    
    Voltage(in mV) = 1000mv + 100mv * (vsel - 1)
    
    Ex: if vsel = 0x9, mV = 1000 + 100 * (9 -1) = 1800mV.
    
    This patch removes all existing VSEL tables for twl6030 adjustable
    regulators and just uses the formula directly for vsel calculations
    after verifing they fall in the allowed range.
    
    Signed-off-by: Rajendra Nayak <rnayak@ti.com>

I found a problem that before commit 3e3d3be79c, the voltage tables were
not linear mapping. So why we can convert these voltage mapping table to
Voltage(in mV) = 1000mv + 100mv * (vsel - 1)?

Did I miss something?

Regards,
Axel


