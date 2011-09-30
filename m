Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615Ab1I3FCQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 01:02:16 -0400
Received: from smtp-out.google.com ([74.125.121.67]:25712 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754174Ab1I3FCP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 01:02:15 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=HI2jiTDvQ/H3/n5rqhd4VZPXMPVwNvG3kRy60miuKJi4EmeLRC4cyKIeZCX4h6eHs
	OqUl9wzQKBbVIJbTRsL7w==
MIME-Version: 1.0
In-Reply-To: <20110930001633.GA11436@myri.com>
References: <4E82017C.3010304@redhat.com> <CAPoiz9w4LyTkmAACHQYR5GSJ+TmN7ePJSb-UuRQ7EjY=QYVn5Q@mail.gmail.com>
 <4E8215B6.1020108@redhat.com> <20110930001633.GA11436@myri.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 29 Sep 2011 23:01:47 -0600
Message-ID: <CAErSpo7Vw94PfhDO8kXtNCPm+m2oXL42R51X9bCh_YvkG=k3ZA@mail.gmail.com>
Subject: Re: Workaround for Intel MPS errata
To: Jon Mason <mason@myri.com>
Cc: Avi Kivity <avi@redhat.com>, Sven Schnelle <svens@stackframe.org>,
        Simon Kirby <sim@hostway.ca>, Eric Dumazet <eric.dumazet@gmail.com>,
        Niels Ole Salscheider <niels_ole@salscheider-online.de>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Ben Hutchings <bhutchings@solarflare.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 29, 2011 at 6:16 PM, Jon Mason <mason@myri.com> wrote:
> Hey Avi,
> Can you try this patch?  It should resolve the issue you are seeing.
>
> Thanks,
> Jon
>
>    PCI: Workaround for Intel MPS errata
>
>    Intel 5000 and 5100 series memory controllers have a known issue if read
>    completion coalescing is enabled (the default setting) and the PCI-E
>    Maximum Payload Size is set to 256B.  To work around this issue, disable
>    read completion coalescing if the MPS is 256B.

I'd much rather see this done as an early quirk so it doesn't clutter probe.c.

I don't know how you decide whether
    - no coalescing with MPS=256, or
    - coalescing with MPS=128
is better.  I suspect that having a quirk that doesn't change the
setting, but merely limits MPS to 128 if the BIOS enabled coalescing,
would be simplest and would stay in the best-tested chipset
configuration.

If you do end up changing the coalescing setting, I think you should
check the current setting, then log something in dmesg if you change
it.  If the quirk limits the max MPS, I think dmesg should reflect
that, too.

I think you're missing a pci_dev_put().

Even if we work out these issues and Avi reports that it fixes his
hang, I'm still concerned about MPS configuration being enabled by
default in 3.1.  It feels like we happened to trip over a few issues
and fix them, but I'm worried that with wider testing, we'll find
more.

I'd feel more comfortable if everything were disabled in 3.1 (it'd be
OK to have a command-line flag to enable it), then turned on by
default early in the 3.2 merge window.

Bjorn

> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> index a919db2..13c733a 100644
> --- a/drivers/pci/probe.c
> +++ b/drivers/pci/probe.c
> @@ -1361,6 +1361,80 @@ static int pcie_find_smpss(struct pci_dev *dev, void *data)
>        return 0;
>  }
>
> +static void pcie_errata_check(int mps)
> +{
> +       struct pci_dev *dev = NULL;
> +       static bool done = false;
> +
> +       if (done)
> +               return;
> +
> +       /* Intel 5000 and 5100 Memory controllers have an errata with read
> +        * completion coalescing (which is enabled by default) and MPS of 256B.
> +        */
> +       /* 5000X Chipset Memory Controller Hub */
> +       dev = pci_get_device(PCI_VENDOR_ID_INTEL, 0x25C0, NULL);
> +       if (dev)
> +               goto fixup;
> +
> +       /* 5000Z Chipset Memory Controller Hub */
> +       dev = pci_get_device(PCI_VENDOR_ID_INTEL, 0x25D0, NULL);
> +       if (dev)
> +               goto fixup;
> +
> +       /* 5000V Chipset Memory Controller Hub */
> +       dev = pci_get_device(PCI_VENDOR_ID_INTEL, 0x25D4, NULL);
> +       if (dev)
> +               goto fixup;
> +
> +       /* 5000P Chipset Memory Controller Hub */
> +       dev = pci_get_device(PCI_VENDOR_ID_INTEL, 0x25D8, NULL);
> +       if (dev)
> +               goto fixup;
> +
> +       /* 5100 Chipset Memory Controller Hub */
> +       dev = pci_get_device(PCI_VENDOR_ID_INTEL, 0x65C0, NULL);
> +       if (dev)
> +               goto fixup;
> +
> +       /* No Intel 5000 or 5100 Memory controller in the system, no need to
> +        * check again
> +        */
> +       if (!dev) {
> +               done = true;
> +               return;
> +       }
> +
> +fixup:
> +       /* Disable read completion coalescing to allow an MPS of 256 */
> +       if (mps == 256) {
> +               int err;
> +               u16 rcc;
> +
> +               /* Intel errata specifies bits to change but does not say what
> +                * they are.  Keeping them magical until such time as the
> +                * registers and values can be explained.
> +                */
> +               err = pci_read_config_word(dev, 0x48, &rcc);
> +               if (err) {
> +                       dev_err(&dev->dev, "Error attempting to read the read "
> +                               "completion coalescing register.\n");
> +                       return;
> +               }
> +
> +               rcc &= ~(1 << 10);
> +
> +               err = pci_write_config_word(dev, 0x48, rcc);
> +               if (err) {
> +                       dev_err(&dev->dev, "Error attempting to read the read "
> +                               "completion coalescing register.\n");
> +                       return;
> +               }
> +
> +               done = true;
> +       }
> +}
> +
>  static void pcie_write_mps(struct pci_dev *dev, int mps)
>  {
>        int rc;
> @@ -1384,6 +1458,8 @@ static void pcie_write_mps(struct pci_dev *dev, int mps)
>                        mps = min(mps, pcie_get_mps(dev->bus->self));
>        }
>
> +       pcie_errata_check(mps);
> +
>        rc = pcie_set_mps(dev, mps);
>        if (rc)
>                dev_err(&dev->dev, "Failed attempting to set the MPS\n");
> @@ -1445,7 +1521,7 @@ static int pcie_bus_configure_set(struct pci_dev *dev, void *data)
>        return 0;
>  }
>
> -/* pcie_bus_configure_mps requires that pci_walk_bus work in a top-down,
> +/* pcie_bus_configure_settings requires that pci_walk_bus work in a top-down,
>  * parents then children fashion.  If this changes, then this code will not
>  * work as designed.
>  */
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
