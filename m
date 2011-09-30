Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755992Ab1I3CWC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 22:22:02 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54571 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755018Ab1I3CWA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 22:22:00 -0400
MIME-Version: 1.0
In-Reply-To: <20110930001633.GA11436@myri.com>
References: <4E82017C.3010304@redhat.com>
	<CAPoiz9w4LyTkmAACHQYR5GSJ+TmN7ePJSb-UuRQ7EjY=QYVn5Q@mail.gmail.com>
	<4E8215B6.1020108@redhat.com>
	<20110930001633.GA11436@myri.com>
Date: Thu, 29 Sep 2011 19:21:58 -0700
Message-ID: <CAEuXFEzESMrFLeTOq33RVQ7W3vsKuqKAuz8mx2o9K6QgBJZVnQ@mail.gmail.com>
Subject: Re: Workaround for Intel MPS errata
From: Jesse Brandeburg <jesse.brandeburg@gmail.com>
To: Jon Mason <mason@myri.com>
Cc: Avi Kivity <avi@redhat.com>, Sven Schnelle <svens@stackframe.org>,
        Simon Kirby <sim@hostway.ca>, Eric Dumazet <eric.dumazet@gmail.com>,
        Niels Ole Salscheider <niels_ole@salscheider-online.de>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Ben Hutchings <bhutchings@solarflare.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 29, 2011 at 5:16 PM, Jon Mason <mason@myri.com> wrote:
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

Hey Jon, glad I could help out by pointing this erratum out on IRC
today.  The patch looks mostly fine, with one nit, see below.


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

this should be "to write the read "

> +                               "completion coalescing register.\n");
> +                       return;
> +               }

do you have to do anything to change the bit back to 1 if something
sets the mps back to 128?
