Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026Ab0LHH7c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 02:59:32 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57680 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544Ab0LHH7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 02:59:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=hV5poCb7+xTKoelK7kaA+5DZemAj2/7+tuFCXEYb6YFC9MBIsU4FvSWnr0mq9c7yt6
         qZQe0pROj5/tKLF7BB7fIm7BBhswzvNuIVx4gNIebYbbVCMDyJnduD+HGd9Grw7/FERd
         KwPRPMh4GzjHYF3wQK84hRThq/wvRfB8wZv4k=
Subject: Re: [2.6.36.1] IGB driver handles all ethX interrupts on single
 cpu core.
From: Eric Dumazet <eric.dumazet@gmail.com>
To: =?UTF-8?Q?Pawe=C5=82?= Sikora <pluto@agmk.net>
Cc: Robert Hancock <hancockrwd@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <201012080845.49604.pluto@agmk.net>
References: <201012071906.47161.pluto@agmk.net> <4CFEE2F9.90600@gmail.com>
	 <201012080845.49604.pluto@agmk.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 08 Dec 2010 08:59:25 +0100
Message-ID: <1291795165.2883.7.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 08 décembre 2010 à 08:45 +0100, Paweł Sikora a écrit :
> On Wednesday 08 of December 2010 02:44:25 Robert Hancock wrote:
> > On 12/07/2010 12:06 PM, Paweł Sikora wrote:
> > > hi,
> > >
> > > i'm currently testing a new server with 2x opteron-6128 with dual gigabit port
> > > and observing that the igb driver uses only single core for all ethX interrupts.
> > > is it a correct behaviour for this driver?
> > >
> > > BR,
> > > Pawel.
> > 
> > The CPU affinity for the IRQ isn't really under the driver's control. It 
> > looks like all your interrupts are being handled on CPU0. You likely 
> > need to run the irqbalance daemon.
> 
> ok, so why e.g. on one machine (dual amd opteron) irqbalance daemon is required
> and on second machine (single intel quad-core) irqs are balanced w/o daemon?
> this looks inconsistent to me.
> 
> $ cat /proc/interrupts
>            CPU0       CPU1       CPU2       CPU3
>   0:         49          2          0          0   IO-APIC-edge      timer
>   1:          0          1          0          1   IO-APIC-edge      i8042
>   8:         13         11         12         13   IO-APIC-edge      rtc0
>   9:          0          0          0          0   IO-APIC-fasteoi   acpi
>  12:          0          0          3          1   IO-APIC-edge      i8042
>  16:        224        236        235        232   IO-APIC-fasteoi   pata_marvell, uhci_hcd:usb3
>  17:          0          0          0          0   IO-APIC-fasteoi   saa7133[0], saa7133[0]
>  18:          0          0          0          0   IO-APIC-fasteoi   ehci_hcd:usb1, uhci_hcd:usb5, uhci_hcd:usb8
>  19:        695        672        660        630   IO-APIC-fasteoi   uhci_hcd:usb7
>  21:          0          0          0          0   IO-APIC-fasteoi   uhci_hcd:usb4
>  23:          1          1          1          0   IO-APIC-fasteoi   ehci_hcd:usb2, uhci_hcd:usb6
>  40:       3409       3446       3441       3403   PCI-MSI-edge      ahci
>  41:         63         60         60         61   PCI-MSI-edge      hda_intel
>  42:       3219       3180       3237       3192   PCI-MSI-edge      radeon
>  43:        505        487        496        498   PCI-MSI-edge      eth0


irqbalance is not required.

You can decide yourself of IRQ affinities

Given data you provided :

echo 0f >/proc/irq/*/eth0/../smp_affinity

If your IGB card has 4 queues and you want each queue serviced by a
given cpu :

echo 01 >/proc/irq/*/eth0-fp-0/../smp_affinity
echo 02 >/proc/irq/*/eth0-fp-1/../smp_affinity
echo 04 >/proc/irq/*/eth0-fp-2/../smp_affinity
echo 08 >/proc/irq/*/eth0-fp-3/../smp_affinity

Note 1 : If under load, NAPI is triggered and no anymore hardirqs
are delivered, so load stay on one ksoftirqd (one cpu),
no matter changes you make on /proc/irq/...



