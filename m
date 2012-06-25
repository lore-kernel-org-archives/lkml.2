Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756764Ab2FYOYE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 10:24:04 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:58418 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755955Ab2FYOYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 10:24:01 -0400
Date: Mon, 25 Jun 2012 10:24:00 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: chao xie <xiechao.linux@gmail.com>
cc: linux-pm@vger.kernel.org, <linux-kernel@vger.kernel.org>, <rjw@sisk.pl>,
        <pavel@ucw.cz>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: pm runtime and system suspend resume
In-Reply-To: <CAK9wHMSp+h9dMjZivV=Y42D1JjvZCC9vCqa4HDBV7osYek70AQ@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1206251014260.1770-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Jun 2012, chao xie wrote:

> There is no more question about runtime_idle and runtime_suspend
> as i understand that runtime_idle indicates that the device is idle,
> clock may be off, no function there,

runtime_idle indicates the the device is idle and the usage counter is
0, right.  Your runtime_idle routine is allowed to call
pm_runtime_suspend, pm_runtime_autosuspend, or a similar function.

>  runtime_suspend means that the
> device my be power off, and making it rework may need some
> initialization work.
> So in the scenario, for USB, there are some clocks relates to it and
> there is a phy attached to it.
> When phy is powered off, it need to be initialized again, and it will
> take some time.
> So in the driver, when there is no action, we will call
> pm_runtime_put, and it will shut off the clocks, for
> pm_runtime_put_sync_suspend, it will shut off the phy to save more
> power.

I'm not sure what you mean.

There are only two differences between pm_runtime_put and 
pm_runtime_put_sync_suspend:

	pm_runtime_put calls pm_request_idle, which means your
	driver's runtime_idle routine gets called asynchronously;

	pm_runtime_put_sync_suspend pm_runtime_suspend, which means
	your driver's runtime_suspend routine gets called
	synchronously.

Your runtime_idle routine shouldn't turn off anything.  All it should 
do is call pm_runtime_suspend (or something similar).  Thus, in either 
case your driver's runtime_suspend routine will be called.  It can turn 
off both the clocks and the phy.

> Then how do we call pm_runtime_put_sync_suspend if it already calls
> pm_runtime_put? Do we need do call pm_runtime_get before call
> pm_runtime_put_sync_suspend because the usage_count is not 0?

You should always call pm_runtime_get (or one of its variants) before 
calling pm_runtime_put (or any of its variants).  Increments and 
decrements of the usage counter must balance.

Alan Stern

