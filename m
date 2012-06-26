Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758035Ab2FZOaJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 10:30:09 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:34169 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757553Ab2FZOaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 10:30:07 -0400
Date: Tue, 26 Jun 2012 10:30:06 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: chao xie <xiechao.linux@gmail.com>
cc: linux-pm@vger.kernel.org, <linux-kernel@vger.kernel.org>, <rjw@sisk.pl>,
        <pavel@ucw.cz>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: pm runtime and system suspend resume
In-Reply-To: <CAK9wHMRiTapv7LGtLES4_gR4-DWxWm7CU+L2Yw0e+tRUCN0wyA@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1206261017440.1636-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Jun 2012, chao xie wrote:

> If we want to separate clocks off and phy off, what should we do?

Why do you want to separate them?

The Runtime PM framework doesn't have any notion of multiple low-power 
states.  It recognizes only two possibilities: active and suspended.

If turning the clocks on and off is very quick, you can simply have the
driver turn them on before each I/O operation and turn them off when
the operation is finished.

> in fact, in the driver, at some time, it can shutdown clock, and at
> some time, it can shut down phy too. So what i want to do it make
> runtime_idle to shut down the clocks while in runtime_suspend to
> shutdown the clocks and phy.

The runtime_idle routine is not supposed to turn anything off.  All it 
should do is decide whether or not to call pm_runtime_suspend.  The 
actual work of turning things on and off belongs in the driver's (or 
subsystem's or PM domain's) runtime_resume and runtime_suspend 
routines.

> So when the driver is in idle, and i can call pm_runtime_put which
> will call runtime_idle to shutdown the clocks, while when the driver
> want to turn off phy, it means it will enter deeper idle, so i need
> call pm_runtime_put_sync_suspend.

You can do that if you want, but it is not how the Runtime PM framework 
was intended to work.  Instead of calling pm_runtime_put, why not just 
turn off the clocks?

Or why not turn off the clocks at the same time as the phy?

> The question is if when driver calls pm_runtime_put_sync_suspend, the
> driver has already called pm_runtime_put, the usaga_count is 0 now, so
> driver has to call pm_runtime_get and then call
> pm_runtime_put_sync_suspend.

If you know the usage count is 0 already, you can just call
pm_runtime_suspend directly.

> PM runtime provide runtime_idle and runtime_suspend, but the device
> status has only two kinds of status, active or no-active. It confuses
> me.

Idle means "the device is active but the usage count is 0".  The 
purpose of the runtime_idle callback is to let your driver know that it 
can start a suspend if it wants to.

> It means that the pm runtime can not support multiple level of
> power mode for device.

That's right.

>  actually, i think it has provided two kinds of
> callback runtime_idle and runtime_suspend, and it should maintain at
> least 3 state, idle, suspend, active for the device.

No, that's not how it was designed.

Alan Stern

