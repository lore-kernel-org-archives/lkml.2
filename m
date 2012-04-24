Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756505Ab2DXIsa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 04:48:30 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:44988 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754452Ab2DXIs2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 04:48:28 -0400
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <DD6B9D658496A2488636C8C75B9C0CB601DA3984@EXMAIL04.scwf.nsc.com>
References: <1335107508.6261.3.camel@phoenix> <20120423110912.GC8318@opensource.wolfsonmicro.com>
 <CAF+7xWkzy5e0rcpwprEE3VWTikOu2+qtsgfdhTN12-yonDxadA@mail.gmail.com> <DD6B9D658496A2488636C8C75B9C0CB601DA3984@EXMAIL04.scwf.nsc.com>
From: Axel Lin <axel.lin@gmail.com>
Date: Tue, 24 Apr 2012 16:48:08 +0800
Message-ID: <CAF+7xWmB1YWjwmQmf9gk0DX7DH5euBD1QH8d7VW6r_nat8FwYQ@mail.gmail.com>
Subject: Re: [PATCH] leds: lm3530: fix handling of already enabled regulators
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Girdwood, Liam" <lrg@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> In my opinion, current source code is the simplest way.
>
>        1. The variable 'drvdata->enabled' is initialized as false.
>        2. The regulator is enabled and the variable is updated when the driver is probed.
>           (If the regulator is already on, it's ok - keep going ...)
>        3. The variable is updated when regulator_enable()/regulator_disable() is called by the lm3530 driver.
>           (If another driver tries to turn off the regulator, it can't be allowed
>            because the reference count was incremented by the lm3530 driver.)

No. Current code is buggy.

Let me put it this way: Assume only this driver is using the regulator.
If the regulator is enabled on boot, which means the reference count
is init to 1.

In probe, the driver assumes the enable variable is false by default and it
calls regulator_enable() in lm3530_init_registers(). This increases
the reference count to 2.

Then if we set brt_val to 0 in lm3530_brightness_set, which will then call
regulator_disable(). In this case, the reference count becomes 1, note that
the reference count is not 0 so the LED may be left on even though the driver
thinks it's off.

Regards,
Axel
