Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752963Ab0JMVQo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 17:16:44 -0400
Received: from cpoproxy2-pub.bluehost.com ([67.222.39.38]:49533 "HELO
	cpoproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752745Ab0JMVQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 17:16:43 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=EYWPx/n1U3r6Lwh9YKHMO4Lia+lMBbmmR+OUzgEuYi6T4XG2nVaWVqnLu3dciPlwEYkMwm6r5ztht1W5G2RzkQXhJBcSrpESCzsLufoMcAKxn33HoGBcj6MuS9wi5a6U;
Date: Wed, 13 Oct 2010 14:20:43 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Dave Airlie <airlied@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Keith Packard <keithp@keithp.com>
Subject: Re: "do_IRQ: 0.89 No irq handler for vector (irq -1)"
Message-ID: <20101013142043.4c24ebcd@jbarnes-desktop>
In-Reply-To: <201010122101.17812.rjw@sisk.pl>
References: <AANLkTikZj21CtFwC2ttvc0wJPx2qyedn7b1xXaxH659E@mail.gmail.com>
	<20101011154826.440b4990@jbarnes-desktop>
	<20101011164014.5a11ee48@jbarnes-desktop>
	<201010122101.17812.rjw@sisk.pl>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Oct 2010 21:01:17 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Tuesday, October 12, 2010, Jesse Barnes wrote:
> > On Mon, 11 Oct 2010 15:48:26 -0700
> > Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> > 
> > > On Fri, 8 Oct 2010 21:46:50 +1000
> > > Dave Airlie <airlied@gmail.com> wrote:
> > > > Not sure how best to fix, I can workaround by calling
> > > > pci_set_power_state(PCI_D0) in the drm drivers, but I sorta thing the
> > > > PCI layer should take care of this.
> > > 
> > > So I think we *should* be able to call pci_disable_device at remove
> > > time.  But as you say, some platforms may not correctly re-route VGA
> > > space to an existing device or disable it properly when we do that.
> > > AFAICT x86 will be ok here though (seems to work ok locally too).
> > 
> > Just tested this some more, and I think it's the right thing to do in
> > the KMS case at least.  When we load a KMS driver it takes over the gfx
> > device and nothing can assume anything about VGA state unless using the
> > VGA arbiter.  So calling pci_disable_device() in the shutdown path of a
> > KMS driver shouldn't make things any worse, and will work around this
> > issue.
> > 
> > Doing so in the non-KMS case violates some PC assumptions though, in
> > that things like vgacon and the BIOS will assume VGA memory is still
> > around, which on some platforms pci_disable_device() may affect (I only
> > checked the x86 implementation).
> > 
> > > That said, it seems like we should update the current device state at
> > > load time as well, once we've matched the driver it seems like there
> > > should be no harm.
> > > 
> > > Rafael, what do you think?  Would having the correct power state at
> > > load time cause any trouble with other PM code?  I know we've had
> > > issues with setting it explicitly in the past...
> > 
> > So we should probably make pci_enable_device pick up the current state
> > as well, instead of assuming it's unknown just because the enable count
> > was non-zero (which as Dave points out, can be affected by sysfs writes
> > too).
> > 
> > The only downside I can think of there is that if the device is already
> > enabled, we generally have to assume another driver owns it, and who
> > knows if the device is actually alive enough to read the current state
> > from.  But I think we handle those errors ok too, so pulling it out
> > should be safe.
> 
> I remember trying to do something like this and it didn't play well with the
> initialization.  Still, I didn't do that in pci_enable_device(), so I can't say
> for sure at the moment.  I _think_ it will be fine, though.

Here's what I had in mind.  I think it's safer than setting the power
state at enable time, and it works around the enable_cnt leak in the
DRM drivers.

-- 
Jesse Barnes, Intel Open Source Technology Center

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 7fa3cbd..37facc1 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -994,6 +994,18 @@ static int __pci_enable_device_flags(struct pci_dev *dev,
 	int err;
 	int i, bars = 0;
 
+	/*
+	 * Power state could be unknown at this point, either due to a fresh
+	 * boot or a device removal call.  So get the current power state
+	 * so that things like MSI message writing will behave as expected
+	 * (e.g. if the device really is in D0 at enable time).
+	 */
+	if (dev->pm_cap) {
+		u16 pmcsr;
+		pci_read_config_word(dev, dev->pm_cap + PCI_PM_CTRL, &pmcsr);
+		dev->current_state = (pmcsr & PCI_PM_CTRL_STATE_MASK);
+	}
+
 	if (atomic_add_return(1, &dev->enable_cnt) > 1)
 		return 0;		/* already enabled */
 

