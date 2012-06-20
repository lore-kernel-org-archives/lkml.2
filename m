Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756666Ab2FTOkR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 10:40:17 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:36951 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753740Ab2FTOkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 10:40:15 -0400
Date: Wed, 20 Jun 2012 10:40:14 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: chao xie <xiechao.linux@gmail.com>
cc: linux-pm@vger.kernel.org, <linux-kernel@vger.kernel.org>, <rjw@sisk.pl>,
        <pavel@ucw.cz>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: pm runtime and system suspend resume
In-Reply-To: <CAK9wHMQ6kJX06ZRjk6w_bt2HDnu=7dQEKde-Cxu8t4QbgLyTCA@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1206201031590.1804-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jun 2012, chao xie wrote:

> >> It seems work well, but i have question about the suspend/resume of
> >> device. When the whole system will go to deep idle, and it will
> >> suspend the devices. for the function do device suspend
> >> __device_suspend,
> >
> > What source file is that function in?
> >
> 
> The function is located at drivers/base/power/main.c
> 
> >>  it will call pm_runtime_get_noresume(dev). As i
> >> think it will make the device not do runtime suspend any more. Is that
> >> correct?
> >
> > It sounds wrong.  Why would a suspend routine do that?
> >
> 
> I do knot know, but the code is there.

Okay, now I understand your question.  The problem is that system 
suspend uses a separate mechanism from runtime suspend, and we don't 
want the two things to happen at the same time.  Therefore 
__device_suspend does a get_noresume in order to prevent runtime 
suspend from occurring in the middle of a system suspend.

> >> There is the question, how device driver handle the logic surrounds
> >> it? I want to add pm_runtime_put_sync in dev->driver->pm->suspend
> >> function, and pm_runtime_get_sync in dev->driver->pm->resume.
> >
> > You must not do that.  If you do, your driver will hang.
> >
> 
> why it will hang?

Sorry, I misunderstood your question.  It will not hang.  But why do 
you want to add those calls?

> >> Because
> >> __device_suspend increase the usage_count, pm_runtime_put_sync will
> >> not do real work.
> >> So is that right that i directly call pm_runtime_suspend in
> >> dev->driver->pm->suspend and pm_runtime_resume in
> >> dev->driver->pm->resume?

No, don't call pm_runtime_suspend.  Just call your driver's
runtime_suspend routine directly.  Same for resume.

> Finally the real question is who will deal with the dev->pm_domain?
> when system go to sleep.

The __device_suspend routine in drivers/base/main.c uses 
dev->pm_domain.

> The driver will use pm_runtime_get/put to deal with dev->pm_domain
> when it want to work or is in idle. Then when system go to sleep, the
> driver need care about dev->pm_domain too.
> Usally, dev->pm_domain is a easy way to handle the difference SOCs
> with same device IP. For example, USB. Many vendor may have same usb
> IP but difference phy and clock configuration. putting these stuff
> into dev->pm_domain can make driver be shared by different SOCs.

Alan Stern

