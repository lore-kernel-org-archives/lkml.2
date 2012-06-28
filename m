Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755164Ab2F1U0V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 16:26:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1687 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754412Ab2F1UZa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 16:25:30 -0400
Subject: Re: [PATCH 1/9] PCI: Remove redundant debug output in pci_do_fixups
From: Myron Stowe <mstowe@redhat.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Myron Stowe <myron.stowe@redhat.com>, linux-pci@vger.kernel.org,
        linux@arm.linux.org.uk, ralf@linux-mips.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org
In-Reply-To: <CAErSpo7+KoNNXcYBLm8C9M3RctugjzcTB6dbyeLD7R+7Jkeb1w@mail.gmail.com>
References: <20120621202415.16865.6226.stgit@amt.stowe>
	 <20120621202423.16865.50394.stgit@amt.stowe>
	 <CAErSpo7+KoNNXcYBLm8C9M3RctugjzcTB6dbyeLD7R+7Jkeb1w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 Jun 2012 14:25:08 -0600
Message-ID: <1340915108.2411.26.camel@zim.stowe>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-06-26 at 16:26 -0600, Bjorn Helgaas wrote:
> On Thu, Jun 21, 2012 at 2:24 PM, Myron Stowe <myron.stowe@redhat.com> wrote:
> > When the boot argument 'initcall_debug' is specified, redundant debug
> > output occurs for each device as a quirk is applied:
> >  ...
> >  pci 0000:00:1a.0: calling quirk_usb_early_handoff+0x0/0x620
> >  calling  quirk_usb_early_handoff+0x0/0x620 @ 1 for 0000:00:1a.0
> >  pci fixup quirk_usb_early_handoff+0x0/0x620 returned after 32 usecs for 0000:00: 1a.0
> >  ...
> >
> > This patch removes the redundancy by eliminating the first debug output
> > occurence in the sequence shown above when 'initcall_debug' is specified.
> 
> Here's what I don't like about this: adding "initcall_debug" *removes*
> some output.  My expectation is that it would only *add* output.

Well, the point to me was that it only removed output that was
completely redundant when "initcall_debug" was true.

I *really* wanted to change the "initcall_debug" output to follow the
convention already in place via 'dev_dbg()' but did not as I'm vaguely
aware of some scripting that parses "initcall_debug" output and did not
want to break that.
> 
> > Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
> > ---
> >
> >  drivers/pci/quirks.c |    5 +++--
> >  1 files changed, 3 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> > index a2d9d33..9c93558 100644
> > --- a/drivers/pci/quirks.c
> > +++ b/drivers/pci/quirks.c
> > @@ -2953,11 +2953,12 @@ static void pci_do_fixups(struct pci_dev *dev, struct pci_fixup *f,
> >                     f->vendor == (u16) PCI_ANY_ID) &&
> >                    (f->device == dev->device ||
> >                     f->device == (u16) PCI_ANY_ID)) {
> > -                       dev_dbg(&dev->dev, "calling %pF\n", f->hook);
> >                        if (initcall_debug)
> >                                do_one_fixup_debug(f->hook, dev);
> > -                       else
> > +                       else {
> > +                               dev_dbg(&dev->dev, "calling %pF\n", f->hook);
> >                                f->hook(dev);
> 
> This part isn't something you changed, but I also think it's a bit
> ugly that we have two possible call sites for the quirk: either inside
> do_one_fixup_debug() or directly in pci_do_fixups().  I wonder if this
> could be restructured a bit in the style of initcall_debug_start() and
> initcall_debug_report(), so we could have this:
> 
>     ktime_t calltime;
> 
>     calltime = initcall_debug_start(dev);
>     f->hook(dev);
>     initcall_debug_report(dev, calltime);
> 
> where initcall_debug_report() would only print something when
> initcall_debug is enabled.
> 
Nice observation!  Such a change would yield a better result.  Perhaps,
transitioning to this approach would also eventually help with my
earlier peeve concerning the redundant output.

Thanks,
 Myron
> > +                       }
> >                }
> >  }


