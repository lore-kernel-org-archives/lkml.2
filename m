Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544Ab2FSOsZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 10:48:25 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:50597 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751786Ab2FSOsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 10:48:23 -0400
Date: Tue, 19 Jun 2012 10:48:22 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: chao xie <xiechao.linux@gmail.com>
cc: linux-pm@vger.kernel.org, <linux-kernel@vger.kernel.org>, <rjw@sisk.pl>,
        <pavel@ucw.cz>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: pm runtime and system suspend resume
In-Reply-To: <CAK9wHMQ7ZLtMTfBKWOb4A8wmjP9EQV8gA_moh5dXxvU0-b-vMQ@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1206191046000.1814-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Jun 2012, chao xie wrote:

> hi
> PM_RUNTIME provide a way for device driver do runtime PM. so for some
> devices, they have some surrounded logic. For example, the device may
> get clock from outside, or it need PHY support(USB is a example).
> To get these dependency out of device driver, i define a struct
> dev_pm_domain, and make dev.pm_domain point to it. So in the device
> driver, when the hardware should be enabled, we can call
> pm_runtime_get_sync while when the hardware is idle or does not work,
> we can call pm_runtime_put_sync.
> It seems work well, but i have question about the suspend/resume of
> device. When the whole system will go to deep idle, and it will
> suspend the devices. for the function do device suspend
> __device_suspend,

What source file is that function in?

>  it will call pm_runtime_get_noresume(dev). As i
> think it will make the device not do runtime suspend any more. Is that
> correct?

It sounds wrong.  Why would a suspend routine do that?

> There is the question, how device driver handle the logic surrounds
> it? I want to add pm_runtime_put_sync in dev->driver->pm->suspend
> function, and pm_runtime_get_sync in dev->driver->pm->resume.

You must not do that.  If you do, your driver will hang.

> Because
> __device_suspend increase the usage_count, pm_runtime_put_sync will
> not do real work.
> So is that right that i directly call pm_runtime_suspend in
> dev->driver->pm->suspend and pm_runtime_resume in
> dev->driver->pm->resume?

No, it works the other way around.  pm_runtime_suspend calls 
dev->driver->pm->suspend, and pm_runtime_resume calls 
dev->driver->pm->resume.

Alan Stern

