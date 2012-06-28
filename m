Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246Ab2F1UZ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 16:25:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61308 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751012Ab2F1UZ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 16:25:28 -0400
Subject: Re: [PATCH 3/9] arm/PCI: move final fixup quirks from __init to
 __devinit
From: Myron Stowe <mstowe@redhat.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Myron Stowe <myron.stowe@redhat.com>, linux-pci@vger.kernel.org,
        linux@arm.linux.org.uk, ralf@linux-mips.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org
In-Reply-To: <CAErSpo5yNxjjBVaTXjAKCY4SfRWj7uXK2cS3BtkugmoF4fYn6g@mail.gmail.com>
References: <20120621202415.16865.6226.stgit@amt.stowe>
	 <20120621202435.16865.1340.stgit@amt.stowe>
	 <CAErSpo5yNxjjBVaTXjAKCY4SfRWj7uXK2cS3BtkugmoF4fYn6g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 Jun 2012 14:25:20 -0600
Message-ID: <1340915120.2411.27.camel@zim.stowe>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-06-26 at 16:33 -0600, Bjorn Helgaas wrote:
> On Thu, Jun 21, 2012 at 2:24 PM, Myron Stowe <myron.stowe@redhat.com> wrote:
> > The PCI subsystem's final fixups are executed once during boot, after the
> > pci-device is found.  As long as the system does not support hot-plug,
> > specifying __init is fine.
> >
> > With hot-plug, either physically based hot-plug events or pseudo hot-plug
> > events such as "echo 1 > /sys/bus/pci/rescan", it is possible to remove a
> > PCI bus during run time and have it rediscovered which will require the
> > call of the fixups again in order for the device to function properly.
> >
> > This patch prepares specific quirk(s) for use with hot-plug events.
> >
> > Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
> > ---
> >
> >  arch/arm/mach-iop32x/n2100.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> >
> > diff --git a/arch/arm/mach-iop32x/n2100.c b/arch/arm/mach-iop32x/n2100.c
> > index 5a7ae91..04c4110 100644
> > --- a/arch/arm/mach-iop32x/n2100.c
> > +++ b/arch/arm/mach-iop32x/n2100.c
> > @@ -126,7 +126,7 @@ static struct hw_pci n2100_pci __initdata = {
> >  * the ->broken_parity_status flag for both ports so that the r8169
> >  * driver knows it should ignore error interrupts.
> >  */
> > -static void n2100_fixup_r8169(struct pci_dev *dev)
> > +static void __devinit n2100_fixup_r8169(struct pci_dev *dev)
> 
> These actually move functions from normal text to __devinit, not from
> __init to __devinit.

Yes (as I hang my head sheepishly).  What got me started down this path
was seeing the recent series by Sabastian Andrzej
( http://marc.info/?l=linux-pci&m=133875179103880&w=2 ).
> 
> That should be safe for most quirks (although enable, suspend, resume,
> and resume_early quirks can be called after we free initmem, even if
> we have CONFIG_HOTPLUG=n), but given the discussion about whether we
> should even bother with __devinit any more, I think I'll hold off on
> these for now.  If we were to get rid of __devinit, these would all
> have to revert to being normal text.

Agreed, and I've only recently (after posting this series) became aware
of James Bottomley's thoughts about __devinit so lets skip these changes
within the series.  I don't want to start a lot of unnecessary churn if
we end up just dropping __devinit altogether.

It's the last patch in the series that is of the most interest - trying
to solve PCI's "final" quirks with respect to hot-plug events and the
asymmetry I ended up discovering while working that issue.  Wish we
would have received some feedback from others about that.

Thanks,
 Myron

Thanks,
 Myron
> 
> >  {
> >        if (dev->bus->number == 0 &&
> >            (dev->devfn == PCI_DEVFN(1, 0) ||
> >


