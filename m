Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753041Ab1HXRtI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 13:49:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44761 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752116Ab1HXRtG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 13:49:06 -0400
MIME-Version: 1.0
In-Reply-To: <CAOtrxKNVckzkxM=ahV13kV=7-Jtj=WWkx_So4pCdVX3e8mdjPw@mail.gmail.com>
References: <20110819175316.GA999@ime.usp.br> <CAOtrxKNVckzkxM=ahV13kV=7-Jtj=WWkx_So4pCdVX3e8mdjPw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 24 Aug 2011 10:47:43 -0700
Message-ID: <CA+55aFyyJNnL54o=xRH7CubFLDaQwcF31sqd7tfBcfR8XfnX5g@mail.gmail.com>
Subject: Re: [Bug 41622] [REGRESSION][BISECTED] Notebook crashes upon
 detecting the PCI subsystem with kernels >= 2.6.24-rc7
To: =?ISO-8859-1?Q?Rog=E9rio_Brito?= <rbrito@ime.usp.br>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Thomas Meyer <thomas@m3y3r.de>,
        Gary Hade <garyhade@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Bjorn Helgaas <bhelgaas@google.com>, bugme-daemon@bugzilla.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/8/19 Rogério Brito <rbrito@ime.usp.br>:
>
> Reverting the commit above with the patch below makes me able to
> compile and run Linus's v3.1-rc2:

Oh, I just noticed that the "revert" you did actually does way more than revert.

> diff --cc drivers/pci/setup-bus.c
> index 8a1d3c7,125e7b7..0000000
> --- a/drivers/pci/setup-bus.c
> +++ b/drivers/pci/setup-bus.c
> @@@ -783,16 -486,14 +783,14 @@@ void __ref __pci_bus_size_bridges(struc
>                break;
>
>        case PCI_CLASS_BRIDGE_PCI:
> +               /* don't size subtractive decoding (transparent)
> +                * PCI-to-PCI bridges */
> +               if (bus->self->transparent)
> +                       break;

The above is the real revert.

The below should be totally independent, and I'd like to make sure
that you test the revert without this change:

>                pci_bridge_check_ranges(bus);
> -               if (bus->self->is_hotplug_bridge) {
> -                       additional_io_size  = pci_hotplug_io_size;
> -                       additional_mem_size = pci_hotplug_mem_size;
> -               }
> -               /*
> -                * Follow thru
> -                */
> +               /* fall through */
>        default:
>  -              pbus_size_io(bus);
>  +              pbus_size_io(bus, 0, additional_io_size, add_head);

And in fact I think that last line is just broken, you can't apply
that on my current -git. What's going on?

Also, I'd like to see the output of:

 - cat /proc/iomem
 - cat /proc/ioports
 - /sbin/lspci -vvxxx

from that machine. And Bjorn asked for a full dmesg, and I see that
email, but it didn't get updated into the bugzilla entry (apparently
bugzilla is not smart enough to take email attachments and make them
bugzilla attachments). Rogério, can you do that so that it doesn't get
lost?

                                 Linus
