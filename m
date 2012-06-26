Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758013Ab2FZBeJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 21:34:09 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:54681 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757862Ab2FZBeH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 21:34:07 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1206251014260.1770-100000@iolanthe.rowland.org>
References: <CAK9wHMSp+h9dMjZivV=Y42D1JjvZCC9vCqa4HDBV7osYek70AQ@mail.gmail.com>
	<Pine.LNX.4.44L0.1206251014260.1770-100000@iolanthe.rowland.org>
Date: Tue, 26 Jun 2012 09:34:06 +0800
Message-ID: <CAK9wHMRiTapv7LGtLES4_gR4-DWxWm7CU+L2Yw0e+tRUCN0wyA@mail.gmail.com>
Subject: Re: pm runtime and system suspend resume
From: chao xie <xiechao.linux@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org, rjw@sisk.pl,
        pavel@ucw.cz, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/6/25 Alan Stern <stern@rowland.harvard.edu>:
> On Mon, 25 Jun 2012, chao xie wrote:
>
>> There is no more question about runtime_idle and runtime_suspend
>> as i understand that runtime_idle indicates that the device is idle,
>> clock may be off, no function there,
>
> runtime_idle indicates the the device is idle and the usage counter is
> 0, right.  Your runtime_idle routine is allowed to call
> pm_runtime_suspend, pm_runtime_autosuspend, or a similar function.
>
>>  runtime_suspend means that the
>> device my be power off, and making it rework may need some
>> initialization work.
>> So in the scenario, for USB, there are some clocks relates to it and
>> there is a phy attached to it.
>> When phy is powered off, it need to be initialized again, and it will
>> take some time.
>> So in the driver, when there is no action, we will call
>> pm_runtime_put, and it will shut off the clocks, for
>> pm_runtime_put_sync_suspend, it will shut off the phy to save more
>> power.
>
> I'm not sure what you mean.
>
> There are only two differences between pm_runtime_put and
> pm_runtime_put_sync_suspend:
>
>        pm_runtime_put calls pm_request_idle, which means your
>        driver's runtime_idle routine gets called asynchronously;
>
>        pm_runtime_put_sync_suspend pm_runtime_suspend, which means
>        your driver's runtime_suspend routine gets called
>        synchronously.
>
> Your runtime_idle routine shouldn't turn off anything.  All it should
> do is call pm_runtime_suspend (or something similar).  Thus, in either
> case your driver's runtime_suspend routine will be called.  It can turn
> off both the clocks and the phy.
>
If we want to separate clocks off and phy off, what should we do?
in fact, in the driver, at some time, it can shutdown clock, and at
some time, it can shut down phy too. So what i want to do it make
runtime_idle to shut down the clocks while in runtime_suspend to
shutdown the clocks and phy.
So when the driver is in idle, and i can call pm_runtime_put which
will call runtime_idle to shutdown the clocks, while when the driver
want to turn off phy, it means it will enter deeper idle, so i need
call pm_runtime_put_sync_suspend.
The question is if when driver calls pm_runtime_put_sync_suspend, the
driver has already called pm_runtime_put, the usaga_count is 0 now, so
driver has to call pm_runtime_get and then call
pm_runtime_put_sync_suspend.
PM runtime provide runtime_idle and runtime_suspend, but the device
status has only two kinds of status, active or no-active. It confuses
me. It means that the pm runtime can not support multiple level of
power mode for device. actually, i think it has provided two kinds of
callback runtime_idle and runtime_suspend, and it should maintain at
least 3 state, idle, suspend, active for the device.

>> Then how do we call pm_runtime_put_sync_suspend if it already calls
>> pm_runtime_put? Do we need do call pm_runtime_get before call
>> pm_runtime_put_sync_suspend because the usage_count is not 0?
>


> You should always call pm_runtime_get (or one of its variants) before
> calling pm_runtime_put (or any of its variants).  Increments and
> decrements of the usage counter must balance.
>
> Alan Stern
>
