Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079Ab2HDV4y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2012 17:56:54 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:42242 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753833Ab2HDV4w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2012 17:56:52 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Paul Mundt <lethal@linux-sh.org>
Subject: Re: [Regression, post-3.5] System suspend broken on the Mackerel board
Date: Sun, 5 Aug 2012 00:02:43 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0+; KDE/4.6.0; x86_64; ; )
Cc: kuninori.morimoto.gx@renesas.com, Magnus Damm <magnus.damm@gmail.com>,
        "Linux-sh list" <linux-sh@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Kuninori Morimoto <kuninori.morimoto.gx@gmail.com>
References: <20120801073004.GE15380@linux-sh.org>
In-Reply-To: <20120801073004.GE15380@linux-sh.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208050002.43465.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, August 01, 2012, Paul Mundt wrote:
> On Sat, Jul 28, 2012 at 12:53:11AM +0200, Rafael J. Wysocki wrote:
> > Unfortunately, your commit
> > 
> > commit ca5481c68e9fbcea62bb3c78ae6cccf99ca8fb73
> > Author: Paul Mundt <lethal@linux-sh.org>
> > Date:   Tue Jul 10 12:08:14 2012 +0900
> > 
> >     sh: pfc: Rudimentary pinctrl-backed GPIO support.
> > 
> > breaks system suspend on the Mackerel board (.config attached).  The system
> > simply doesn't suspend and instead it hangs somewhere while suspending
> > devices (apparently before running the "late" callbacks).
> > 
> > If the above commit is reverted, system suspend works normally.
> 
> On Tue, Jul 31, 2012 at 08:57:02PM -0700, kuninori.morimoto.gx@renesas.com wrote:
> > gpio: sh7724_pfc handling gpio 0 -> 486
> > core: sh7724_pfc support registered
> > HW Breakpoints: SH-4A UBC support registered
> > autorequest GPIO-53
> > ------------[ cut here ]------------
> > WARNING: at /opt/usr/src/WORK/morimoto/gitlinux/linux-2.6/drivers/gpio/gpiolib.3
> > Modules linked in:
> > 
> > Pid : 1, Comm:          swapper
> > CPU : 0                 Not tainted  (3.5.0-rc6+ #1407)
> > 
> > PC is at gpio_ensure_requested+0x30/0x78
> > PR is at gpio_ensure_requested+0x30/0x78
> 
> Morimoto-san's logs off-list made it clear what happened. Both of these
> platforms are going gpio_request() calls at arch_initcall() time which
> completely screwed up the ordering of the pfc core. We seem to -ENODEV
> out in one place due to missing a pfc pointer initialization elsewhere
> resulting in -EPROBE_DEFER from gpiolib.
> 
> Turns out we can just collapse the probe/init stuff anyways, so this
> ought to fix it. I've verified that it fixes Morimoto-san's issue, my
> expectation is that the mackerel case is likewise getting tripped up but
> no one bothered implementing any error detecting logic for gpio_request()
> failing, so it doesn't fail gracefully.
> 
> I'll be pushing this out to Linus shortly:

Thanks, this helped.  Resume works correctly on Mackerel with 3.6-rc1.

However, I'm now seeing a different problem related to system suspend on that,
board which is that sh7372_enter_a3sm_common() returns immediately, as though
at least one of the wakeup signals was permanently asserted.  This hadn't
happened before your last pull request was merged, so I suspect that one
of the irqdomain patches might introduce this behavior.

Thanks,
Rafael
