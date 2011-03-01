Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757535Ab1CAVHg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 16:07:36 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40896 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757226Ab1CAVHf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 16:07:35 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pierre Tardy <tardyp@gmail.com>
Subject: Re: [linux-pm] [RFC,PATCHv3 0/3] sdhci runtime_pm implementation
Date: Tue, 1 Mar 2011 22:07:22 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc6+; KDE/4.4.4; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
        linux-pm@lists.linux-foundation.org, linux-mmc@vger.kernel.org
References: <cover.1298820825.git.tardyp@gmail.com> <Pine.LNX.4.44L0.1103011431400.2034-100000@iolanthe.rowland.org> <AANLkTi=ogThxB_2bxANV4hUsLGZs04gzHSCyH90Bm87U@mail.gmail.com>
In-Reply-To: <AANLkTi=ogThxB_2bxANV4hUsLGZs04gzHSCyH90Bm87U@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103012207.22798.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, March 01, 2011, Pierre Tardy wrote:
> On Tue, Mar 1, 2011 at 8:33 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> > On Tue, 1 Mar 2011, Pierre Tardy wrote:
> >
> >> Please find sdhci runtime_pm implementation.
> >>
> >> It uses clock gating fw as a tip to know when our chip is idle.
> >> It implements wake up from card insertion/removal.
> >>
> >> This is RFC, please dont merge yet. I really would like to have deep review
> >> from PCI linux-pm guys.
> >>
> >> Opens are:
> >>
> >> 1/ Not sure if the pci configs in the driver in rpm_suspend/resume flow
> >>  are not duplicate from what the core is doing.
> >
> > There may be one or two small errors.
> >
> >> 2/ Wakeup from D3hot: I cannot find any driver that is implementing it in current upstream,
> >
> > Other drivers do it, but they use PCI PME# instead of interrupts.
> Could you please elaborate?
> My understanding is that PCI PME will generate MSI, which translate in
> interrupt.

Your driver won't get those interrupts.

How it works is, basically, that when the device signals wakeup, it either
causes a PME# signal to be raised (parallel PCI), or a PME Message to be
sent upstream (PCIe).  In the first case it will cause a platform event
(eg. ACPI GPE) to occur and the handle of that event will resume your
device (using pm_request_resume()).  In the second case it will cause the PCIe
root port handling the PME Message to generate an interrupt and the handler of
that interrupt will resume your device.

And this is a good reason why your driver shouldn't touch the PCI-specific
part of suspend/resume handling (it may not really know what it's doing).

In fact, there are a few drivers in the tree using this mechanism already
(r8169, e1000e, i believe PCI HCDs too).

Thanks,
Rafael
