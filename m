Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677Ab0JKXg5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 19:36:57 -0400
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:54744 "HELO
	cpoproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753509Ab0JKXg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 19:36:56 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=d/KFfFW3yZebcghPk2SOHyc2niBDFLt9SGazHIBoiAo7k3pk7kXZhUv8KdKGahXAPKfngDAVw5x9fkCKh+qDR5FosstPXzk2P4AqkX+cLK/2cavU8IlJsODXDEwGmAsD;
Date: Mon, 11 Oct 2010 16:40:14 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Dave Airlie <airlied@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Keith Packard <keithp@keithp.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: "do_IRQ: 0.89 No irq handler for vector (irq -1)"
Message-ID: <20101011164014.5a11ee48@jbarnes-desktop>
In-Reply-To: <20101011154826.440b4990@jbarnes-desktop>
References: <AANLkTikZj21CtFwC2ttvc0wJPx2qyedn7b1xXaxH659E@mail.gmail.com>
	<alpine.LFD.2.00.1010072227420.2484@localhost6.localdomain6>
	<alpine.LFD.2.00.1010072329220.3354@localhost6.localdomain6>
	<alpine.LFD.2.00.1010080941160.7653@localhost6.localdomain6>
	<AANLkTim=kmzwV+S-aP3+B1CNkS_XrvHuEewpmYZZtcA9@mail.gmail.com>
	<20101011154826.440b4990@jbarnes-desktop>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Oct 2010 15:48:26 -0700
Jesse Barnes <jbarnes@virtuousgeek.org> wrote:

> On Fri, 8 Oct 2010 21:46:50 +1000
> Dave Airlie <airlied@gmail.com> wrote:
> > Not sure how best to fix, I can workaround by calling
> > pci_set_power_state(PCI_D0) in the drm drivers, but I sorta thing the
> > PCI layer should take care of this.
> 
> So I think we *should* be able to call pci_disable_device at remove
> time.  But as you say, some platforms may not correctly re-route VGA
> space to an existing device or disable it properly when we do that.
> AFAICT x86 will be ok here though (seems to work ok locally too).

Just tested this some more, and I think it's the right thing to do in
the KMS case at least.  When we load a KMS driver it takes over the gfx
device and nothing can assume anything about VGA state unless using the
VGA arbiter.  So calling pci_disable_device() in the shutdown path of a
KMS driver shouldn't make things any worse, and will work around this
issue.

Doing so in the non-KMS case violates some PC assumptions though, in
that things like vgacon and the BIOS will assume VGA memory is still
around, which on some platforms pci_disable_device() may affect (I only
checked the x86 implementation).

> That said, it seems like we should update the current device state at
> load time as well, once we've matched the driver it seems like there
> should be no harm.
> 
> Rafael, what do you think?  Would having the correct power state at
> load time cause any trouble with other PM code?  I know we've had
> issues with setting it explicitly in the past...

So we should probably make pci_enable_device pick up the current state
as well, instead of assuming it's unknown just because the enable count
was non-zero (which as Dave points out, can be affected by sysfs writes
too).

The only downside I can think of there is that if the device is already
enabled, we generally have to assume another driver owns it, and who
knows if the device is actually alive enough to read the current state
from.  But I think we handle those errors ok too, so pulling it out
should be safe.

-- 
Jesse Barnes, Intel Open Source Technology Center
