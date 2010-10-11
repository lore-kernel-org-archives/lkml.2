Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756923Ab0JKWpP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 18:45:15 -0400
Received: from cpoproxy2-pub.bluehost.com ([67.222.39.38]:33905 "HELO
	cpoproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754590Ab0JKWpN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 18:45:13 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=L92fsrCraooDdKu7FL8/AjOokohHfDAiUwto4TtQfxM7O4QGyrzJhGLufBPIwriTL7eH4MbdOeRJbeBs8x6QpWueVtuDXR50jrBtA/uQVej6yAJHQg4lpzqMiknB/0Yf;
Date: Mon, 11 Oct 2010 15:48:26 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Dave Airlie <airlied@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Keith Packard <keithp@keithp.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: "do_IRQ: 0.89 No irq handler for vector (irq -1)"
Message-ID: <20101011154826.440b4990@jbarnes-desktop>
In-Reply-To: <AANLkTim=kmzwV+S-aP3+B1CNkS_XrvHuEewpmYZZtcA9@mail.gmail.com>
References: <AANLkTikZj21CtFwC2ttvc0wJPx2qyedn7b1xXaxH659E@mail.gmail.com>
	<alpine.LFD.2.00.1010072227420.2484@localhost6.localdomain6>
	<alpine.LFD.2.00.1010072329220.3354@localhost6.localdomain6>
	<alpine.LFD.2.00.1010080941160.7653@localhost6.localdomain6>
	<AANLkTim=kmzwV+S-aP3+B1CNkS_XrvHuEewpmYZZtcA9@mail.gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Oct 2010 21:46:50 +1000
Dave Airlie <airlied@gmail.com> wrote:

> On Fri, Oct 8, 2010 at 5:52 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > On Thu, 7 Oct 2010, Thomas Gleixner wrote:
> >  Oct  7 23:21:24 ionos kernel: Console: switching to colour VGA+ 80x25
> >> Oct  7 23:21:31 ionos kernel: drm: unregistered panic notifier
> >> Oct  7 23:21:31 ionos kernel: vga_switcheroo: disabled
> >> Oct  7 23:21:31 ionos kernel: [drm:drm_mm_takedown] *ERROR* Memory manager not clean. Delaying takedown
> >>
> >> That one scares me :)
> >>
> >> Oct  7 23:21:32 ionos kernel: BUG: unable to handle kernel paging request at 00000037362e313a
> >>
> >> We are again dereferencing a user space address.
> >
> > Further debugging shows that the interrupt is torn down and the
> > vectors are cleared. On modprobe the irq is set up again and a
> > different vector is assigned.
> >
> > The interrupt which comes in is going to the old vector. So something
> > is stale in the card.
> 
> Okay I've traced it with the hints Thomas gave me,
> 
> What happens is we have never called pci_disable_device on video
> devices for various reasons, like shutting down VGA devices could be
> hostile,
> 
> however on rmmod of the driver the PCI layer sets the device power
> state to PCI_UNKNOWN, when we next load the driver we call
> pci_enable_device
> which sees the enable cnt is 1, so never calls
> pci_set_power_state(PCI_D0), the MSI code won't actually write MSI
> msgs unless it knows we are in D0.
> 
> Not sure how best to fix, I can workaround by calling
> pci_set_power_state(PCI_D0) in the drm drivers, but I sorta thing the
> PCI layer should take care of this.

So I think we *should* be able to call pci_disable_device at remove
time.  But as you say, some platforms may not correctly re-route VGA
space to an existing device or disable it properly when we do that.
AFAICT x86 will be ok here though (seems to work ok locally too).

That said, it seems like we should update the current device state at
load time as well, once we've matched the driver it seems like there
should be no harm.

Rafael, what do you think?  Would having the correct power state at
load time cause any trouble with other PM code?  I know we've had
issues with setting it explicitly in the past...

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
