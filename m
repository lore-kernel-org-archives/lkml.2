Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859Ab1AGWcY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 17:32:24 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:59659 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753524Ab1AGWcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 17:32:22 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Viresh Kumar <viresh.kumar@st.com>, Greg KH <greg@kroah.com>
Subject: Re: [PATCH V2] ST SPEAr: PCIE gadget suppport
Date: Fri, 7 Jan 2011 23:32:16 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Pratyush Anand <pratyush.anand@st.com>
References: <137dfad4a093ea0ac80396f5eb7fbf0c382be698.1294314772.git.viresh.kumar@st.com>
In-Reply-To: <137dfad4a093ea0ac80396f5eb7fbf0c382be698.1294314772.git.viresh.kumar@st.com>
MIME-Version: 1.0
Message-Id: <201101072332.16985.arnd@arndb.de>
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:4M6BejtQl4nqkoLY8PWU2CahZA29ejK35sP+CsgNUiy
 o0FPE4MY1lOY0OpnBZdVwcf4yB5pvDUz99iUPGS5RvBve0rkDJ
 ud7ES9wNzfx2EfCxU5jz71NC01WdaJ8ZUY50w1hrSoq45rzEFH
 0uuGR9Uep36oi9+zZvUXAEvBa9S3PQPn1E/bMnIF6vF6xPsG8/
 7JmTvZU6d5oWT25Vik6CA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 06 January 2011, Viresh Kumar wrote:
> From: Pratyush Anand <pratyush.anand@st.com>
> 
> This is a configurable gadget. can be configured by sysfs interface. Any
> IP available at PCIE bus can be programmed to be used by host
> controller.It supoorts both INTX and MSI.
> By default, gadget is configured for INTX and SYSRAM1 is mapped to BAR0
> with size 0x1000

The code looks reasonably clean, but I don't yet understand how you would
use this device for the interesting case of communicating with the host
side. I've put a lot of thought into similar hardware designs before, but
never got an implementation done myself.

Forwarding devices that don't need interrupts with your driver seems to
be the only case that will easily work, but that is also rather limited
in what you can use it for.

One concept that people have played with before is to export a virtio
channel through PCI that you can use with e.g. virtio-net  or virtfs.
This is very powerful and has  a lot of possible applications because
we have support for virtio drivers across a number of operating systems
and platforms already.

>  Documentation/misc-devices/spear-pcie-gadget.txt |  125 ++++
>  drivers/misc/Kconfig                             |   10 +
>  drivers/misc/Makefile                            |    1 +
>  drivers/misc/spear13xx_pcie_gadget.c             |  856 ++++++++++++++++++++++

Why would you put this under drivers/misc?

I think drivers/pci/gadget/ would be a better place. I would also
recommend splitting the user interface from the hardware dependent
parts, so someone else can easily do another gadget driver for
different hardware.

> +/*wait till link is up*/
> +# cat sys/devices/platform/pcie-gadget-spear.0/link
> +wait till it returns UP.

A blocking sysfs read is not a nice interface. This is probably where
the sysfs abstraction for your hardware stops making sense.

> +To assert INTA
> +# echo 1 >> sys/devices/platform/pcie-gadget-spear.0/inta
> +
> +To de-assert INTA
> +# echo 0 >> sys/devices/platform/pcie-gadget-spear.0/inta

And this looks somewhat impractical and slow. 

> +to send msi vector 2
> +# echo 2 >> sys/devices/platform/pcie-gadget-spear.0/send_msi

Using a sysfs file only for its side-effect is not very nice either.

The user interface for the interrupts looks to me like it should really
be based around a character device and either read/write/poll or
ioctl and poll. Using an eventfd might be cool here, because  then you
can combine this with other devices by passing the event file to
an interface that operates on eventfd. This would e.g. make it possible
to combine a UIO device generating interrupts with a PCIe gadget
sending the interrupts somewhere else, without leaving kernel
space.

For setting up the basic parameters, sysfs (or configfs, as Greg suggested)
is a reasonable choice, so there is no need to change that.

I don't know what the rules for configfs are though, i.e. if eventfd
files or ioctls are ok or not.

	Arnd

