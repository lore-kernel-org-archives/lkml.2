Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755749Ab0GHLDf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 07:03:35 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37956 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754081Ab0GHLDd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 07:03:33 -0400
Date: Thu, 8 Jul 2010 12:11:22 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: =?ISO-8859-14?B?RnLpZOlyaWMgQnJp6HJl?= <fbriere@fbriere.net>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
       linux-parport@lists.infradead.org
Subject: Re: [PATCH] parport/serial: add support for Timedia/SUNIX cards to
 parport_serial
Message-ID: <20100708121122.17d3e823@lxorguk.ukuu.org.uk>
In-Reply-To: <1277511823-6973-1-git-send-email-fbriere@fbriere.net>
References: <1277511823-6973-1-git-send-email-fbriere@fbriere.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-14
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jun 2010 20:23:43 -0400
Frédéric Brière <fbriere@fbriere.net> wrote:

> Timedia/SUNIX PCI cards with both serial and parallel ports are
> currently supported by 8250_pci and parport_pc individually.  Moving
> that support into parport_serial allows using both types of ports at the
> same time.

This seems to have fallen on silence so I'm getting around to looking at
it.  I'm not sure the sunix hack to avoid lots of entries is a good idea
- it'll eventually break horribly somewhere.


> + * Devices with a parallel port can be identified by their subdevice ID
> + * matching xx[7-9]x.  We thus mark them as class OTHER, so that they will be
> + * ignored by 8250_pci, and claimed by parport_serial instead.
> + */
> +static void __devinit quirk_timedia(struct pci_dev *dev)
> +{
> +	/* 0,2,3,5,6: serial only -- 7,8,9: serial + parallel */
> +	if ((dev->subsystem_device & 0x00f0) >= 0x70) {
> +		dev_info(&dev->dev, "Timedia %04x; "
> +			"changing class SERIAL to OTHER (use parport_serial)\n",
> +			dev->subsystem_device);
> +		dev->class = (PCI_CLASS_COMMUNICATION_OTHER << 8) |
> +		    (dev->class & 0xff);
> +	}
> +}
> +DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_TIMEDIA, PCI_DEVICE_ID_TIMEDIA_1889,
> +		quirk_timedia);

And this check probably should be done in the serial driver so that it
doesn't bind, rather than changing the class, which then lies to other
bits of the kernel so can have funny side effects.

If you did that check in the serial driver and returned -ENODEV to the
probe the id will be handed on to the next driver that matches (ie
parport_serial)

Alan
