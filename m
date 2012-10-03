Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933131Ab2JCAdH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 20:33:07 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:63139 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756469Ab2JCAdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 20:33:03 -0400
From: Kevin Hilman <khilman@deeprootsystems.com>
To: "Poddar\, Sourav" <sourav.poddar@ti.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Felipe Balbi <balbi@ti.com>, gregkh@linuxfoundation.org,
        paul@pwsan.com, tony@atomide.com, linux-kernel@vger.kernel.org,
        santosh.shilimkar@ti.com, linux-serial@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        alan@linux.intel.com
Subject: Re: [RFT/PATCH] serial: omap: prevent resume if device is not suspended.
Organization: Deep Root Systems, LLC
References: <1347972050-3509-1-git-send-email-sourav.poddar@ti.com>
	<CAKdam572krJZcayRdJ_AciCUZH3LuzD9yoHenhxrB6j9xDZ6JQ@mail.gmail.com>
	<20120925083029.GG31374@n2100.arm.linux.org.uk>
	<20120925083118.GI9137@arwen.pp.htv.fi>
	<20120925091228.GI31374@n2100.arm.linux.org.uk>
	<20120925091112.GK9137@arwen.pp.htv.fi>
	<20120925092118.GJ31374@n2100.arm.linux.org.uk>
	<CAKdam57bpTJ94Gn=mKVw1Fm-76fVPp3DGjFuNu_HfesybM1hPg@mail.gmail.com>
Date: Tue, 02 Oct 2012 17:33:02 -0700
In-Reply-To: <CAKdam57bpTJ94Gn=mKVw1Fm-76fVPp3DGjFuNu_HfesybM1hPg@mail.gmail.com>
	(Sourav Poddar's message of "Tue, 25 Sep 2012 15:26:06 +0530")
Message-ID: <87ipas2y4h.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Poddar, Sourav" <sourav.poddar@ti.com> writes:

> Hi,
>
> On Tue, Sep 25, 2012 at 2:51 PM, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
>> On Tue, Sep 25, 2012 at 12:11:14PM +0300, Felipe Balbi wrote:
>>> On Tue, Sep 25, 2012 at 10:12:28AM +0100, Russell King - ARM Linux wrote:
>>> > On Tue, Sep 25, 2012 at 11:31:20AM +0300, Felipe Balbi wrote:
>>> > > On Tue, Sep 25, 2012 at 09:30:29AM +0100, Russell King - ARM Linux wrote:
>>> > > > How is this happening?  I think that needs proper investigation - or if
>>> > > > it's had more investigation, then the results needs to be included in
>>> > > > the commit description so that everyone can understand the issue here.
>>> > > >
>>> > > > We should not be resuming a device which hasn't been suspended.  Maybe
>>> > > > the runtime PM enable sequence is wrong, and that's what should be fixed
>>> > > > instead?
>>> > > >
>>> > > > This sequence in the probe() function:
>>> > > >
>>> > > >         pm_runtime_irq_safe(&pdev->dev);
>>> > > >         pm_runtime_enable(&pdev->dev);
>>> > > >         pm_runtime_get_sync(&pdev->dev);
>>> > > >
>>> > > > would enable runtime PM while the s/w state indicates that it's disabled,
>>> > > > and then that pm_runtime_get_sync() will want to resume the device.  See
>>> > > > the section "5. Runtime PM Initialization, Device Probing and Removal"
>>> > > > in Documentation/power/runtime_pm.txt, specifically the second paragraph
>>> > > > of that section.
>>> > >
>>> > > that was tested. It worked in pandaboard but didn't work on beagleboard
>>> > > XM. Sourav tried to start a discussion about that, but it simply died...
>>> > >
>>> > > In any case, pm_runtime_get_sync() in probe will always call
>>> > > runtime_resume callback, right ?
>>> >
>>> > Well, if the runtime PM state says it's suspended, and then you enable
>>> > runtime PM, the first call to pm_runtime_get_sync() will trigger a resume
>>> > attempt.  The patch description is complaining about resume events without
>>> > there being a preceding suspend event.
>>> >
>>> > This could well be why.
>>>
>>> that's most likely, of course. But should we cause a regression to
>>> beagleboard XM because of that ?
>>
>> What would cause a regression on beagleboard XM?  I have not suggested
>> any change other than more investigation of the issue and a fuller patch
>> description - yet you're screaming (idiotically IMHO) that mere
>> investigation would break beagleboard.
>>
>> Well, if it's _that_ fragile, that mere investigation of this issue by
>> someone elsewhere on the planet would break your beagleboard, maybe it
>> deserves to be broken!
>
> The issue was observed at serial init itself in the N800 board and the
> log does not
> show up much.
> http://www.pwsan.com/omap/testlogs/test_tty_next_e36851d0/20120910020323/boot/2420n800/2420n800_log.txt
>  What we thought the problem might be with n800 is that it tries to
> resume when it didn't suspend before.
>
> There are two ways through which we thought of handling this issue:
>
> a) set device as active before enabling pm (which will prevent
>
> pm_runtime_set_active(dev);
> pm_runtime_enable(dev);
>
> OR
>
> b) adding a "suspended" flag to struct omap_uart_port which gets set on
> suspend and cleared on resume. Then on resume you can check:
>
> if (!up->suspended)
>         return 0;
>
> But using "pm_runtime_set_active" approach breaks things even on
> beagle board xm,  though
> it works fine on Panda.
> Therefore, we used the "suspended" flag approach.
>
> So. I just wanted to get some feedback from community about how using
> "pm_runtime_set_active"
> behaves differently in omap3 and omap4.

As Russell has already pointed out in great detail, the difference is
simply a mismatch between assumed HW stated and actual hardware state
between various boards.  Put simply, the driver assumes the HW is
disabled (runtime suspended) when it loads, and the first runtime resume
is meant to enable the HW.  If that assumption is wrong, it needs to be
fixed.

Have you figured out why the HW is already active on OMAP2?  (probably
bootloader?)  

That being said, already active HW should not cause this problem.  In
fact, because of possible early console use, the hwmod init of the UART
hwmods does not idle/reset them on boot, so they are left in the state
that the bootloader set them in.  

When the hwmod is later enabled for real during probe, the hwmod muxing
is done for that IP.  So, I suspect what is really happening is that the
mux settings are not right for the UARTS on n800, so when the probe
happens, the UART mux settings are changed and you lose the UART.

Can you double check the UART mux settings for that board?  You might
need some different mux settings in the board file.

Kevin

