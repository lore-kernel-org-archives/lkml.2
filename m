Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757198Ab1FILJm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 07:09:42 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:57266 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753660Ab1FILJk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 07:09:40 -0400
X-Greylist: delayed 316 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 Jun 2011 07:09:40 EDT
Message-ID: <4DF0A8B3.8090900@mev.co.uk>
Date: Thu, 9 Jun 2011 12:04:19 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110526 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: "Prashant P. Shah" <pshah.mumbai@gmail.com>
CC: "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Frank Mori Hess <fmhess@users.sourceforge.net>,
        Ian Abbott <ian.abbott@mev.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] Staging: comedi: add dyna_pci10xx driver
References: <20110609092401.GA2777@mail.fossee.in>
In-Reply-To: <20110609092401.GA2777@mail.fossee.in>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/06/11 10:24, Prashant P. Shah wrote:
> For Dynalog PCI DAQ cards:
>   PCI-1050
> 
> Signed-off-by: Prashant P. Shah <pshah.mumbai@gmail.com>

It looks mostly okay to me as long as you got the PCI device ID
allocated by PLX (which they'll happily do for their customers if you
tell them what product the chip is is part of), and didn't just pull it
out of a hat!

A small criticism is a slight overuse of udelay(10) calls in the driver.
 Are they all necessary?  (I can understand its use in the code that
waits for AI conversions to complete.)  In the more general cases, you
might want to look at configuring wait states in the PLX chip instead of
relying on software delays.  It doesn't matter too much though.

I have a few more specific comments on the code (not many!):

> +/* digital output bit interface */
> +static int dyna_pci10xx_do_insn_bits(struct comedi_device *dev,
> +                             struct comedi_subdevice *s,
> +                             struct comedi_insn *insn, unsigned int *data)
> +{
> +       if (insn->n != 2)
> +               return -EINVAL;
> +
> +       /* The insn data is a mask in data[0] and the new data
> +        * in data[1], each channel cooresponding to a bit.
> +        * s->state contains the previous write data
> +        */
> +
> +       if (data[0]) {
> +               down(&devpriv->sem);
> +               s->state &= ~data[0];
> +               s->state |= (data[0] & data[1]);
> +               smp_mb();
> +               outw_p(s->state, devpriv->BADR3);
> +               udelay(10);
> +               up(&devpriv->sem);
> +       }
> +
> +       /*
> +        * On return, data[1] contains the value of the digital
> +        * input and output lines. We just return the software copy of the
> +        * output values if it was a purely digital output subdevice.
> +        */
> +       data[1] = s->state;
> +
> +       return 2;
> +}

Since you've gone to the bother of using a semaphore here, it may be
better to grab it before the 'if (data[0])' and release it after the
'data[1] = s->state;'.  Then data[1] will definitely be the value that
was written to the outputs by this ioctl.

It would be better to use a mutex than a semaphore for the reasons given
in Documentation/mutex-design.txt.

> +static int dyna_pci10xx_detach(struct comedi_device *dev)
> +{
> +       if (devpriv->pci_dev)
> +               comedi_pci_disable(devpriv->pci_dev);
> +
> +       return 0;
> +}

devpriv may be NULL when _detach is called, so you need to replace the
above test with 'if (devpriv && devpriv->pci_dev)' to avoid a possible
kernel oops.

Best regards,
Ian.

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
