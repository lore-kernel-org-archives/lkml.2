Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475Ab2GWRBD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 13:01:03 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:35612 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753296Ab2GWRBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 13:01:00 -0400
MIME-Version: 1.0
In-Reply-To: <CAFbHwiQNY+R56pbRJBcR9+BcGmJn6bV=7Y0ELNBT1bqkQ6D+kA@mail.gmail.com>
References: <1342808038-7558-1-git-send-email-dianders@chromium.org>
	<CAFbHwiQh-Cwo4xo6-vCbvWsmz_cheZK1m3SnwkvSziunV1ShBA@mail.gmail.com>
	<CAD=FV=WxcXFgf+0a1UfAPRWuvWptLm9RjSqW3tEZjyT0Z+4gkA@mail.gmail.com>
	<CAFbHwiQNY+R56pbRJBcR9+BcGmJn6bV=7Y0ELNBT1bqkQ6D+kA@mail.gmail.com>
Date: Mon, 23 Jul 2012 10:00:59 -0700
X-Google-Sender-Auth: AtFgG9R-tfer5TSkjjcBaI3Qk40
Message-ID: <CAD=FV=XuXUe1Jyd_urCzmS5+1vv7iuNTXYr23XYZp+MnTq1HGg@mail.gmail.com>
Subject: Re: [PATCH] mmc: dw_mmc: Disable low power mode if SDIO interrupts
 are used
From: Doug Anderson <dianders@chromium.org>
To: Will Newton <will.newton@gmail.com>, ki0351.kim@samsung.com
Cc: linux-mmc@vger.kernel.org, Chris Ball <cjb@laptop.org>,
        James Hogan <james.hogan@imgtec.com>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>, linux-kernel@vger.kernel.org,
        Grant Grundler <grundler@chromium.org>,
        Olof Johansson <olofj@chromium.org>, shashidharh@vayavyalabs.com
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23, 2012 at 2:19 AM, Will Newton <will.newton@gmail.com> wrote:
>> Very good question.  In my current setup I don't see setup_bus()
>> called during normal operation.  If it were, my kernel messages would
>> be constantly spammed with messages like:
>>     Bus speed (slot %d) = %dHz (slot req %dHz, actual %dHZ div = %d)
>>
>> ...and they're not.  Things may be different with different SDIO cards perhaps?
>
> Yeah I think setup_bus should only setup the card clock once at
> startup but it may also be required on resume?

We just got suspend/resume working yesterday, so I can now test this!  :)

With our current driver (which had some modifications to allow for
MMC_PM_KEEP_POWER that I assume will be posted before too long), I did
some testing with printk.  On my system I found that
dw_mci_setup_bus() is always called with SDIO interrupts turned off,
even during the resume path.  That means my previous posted patch is
OK.

I also looked more closely at the resume path.  I see this in the
current upstream code in the resume function:

	mci_writel(host, INTMASK, SDMMC_INT_CMD_DONE | SDMMC_INT_DATA_OVER |
		   SDMMC_INT_TXDR | SDMMC_INT_RXDR |
		   DW_MCI_ERROR_FLAGS | SDMMC_INT_CD);

This will clobber SDIO interrupts.  That means that if we have any
hope of SDIO interrupts working, someone will need to call
dw_mci_enable_sdio_irq() which will re-disable low power mode.  This
also points to my previous patch being OK.


...but putting the extra check in setup_bus() still doesn't hurt,
though, so I'll post that shortly.  I have looked into the SDIO code
and see that when the sdio_irq_thread exits it always disables SDIO
interrupts.  That means that I can still rely on setup_bus to properly
re-enable low power mode when it's called after an SDIO module is
removed.  :)


> I should probably mention I have not tested this driver with any SDIO
> devices, although I believe there are other people out there who do!

Agreed.  Given that I've seen recent patches (authored May 14th 2012,
for instance) fixing major SDIO issues with this driver, I'd conclude:

* Use of this driver for SDIO is very new and there may still be bugs.

* If others are using SDIO interrupts and haven't seen this issue,
they've got something different about their system.  Perhaps the SDIO
module they're using behaves in a way that SDIO interrupts always come
in at the same time as some other source?  ...or maybe they do some
type of periodic polling and are thus OK with missing some interrupts?
 The exynos manual that includes the dw mmc controller is very clear
that you can't use low power mode and SDIO interrupts and it was
definitely failing for us.

I've added the author of the most recent SDIO patch to this email
thread.  Sorry for missing that before.  Kyoungil: do you have any
comments on this?


-Doug
