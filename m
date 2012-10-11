Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933325Ab2JKRdv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 13:33:51 -0400
Received: from qmta01.emeryville.ca.mail.comcast.net ([76.96.30.16]:43510 "EHLO
	qmta01.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933147Ab2JKRds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 13:33:48 -0400
Message-ID: <1349976523.7065.22.camel@rhapsody>
Subject: Re: [PATCH v3 1/2] x86, pci: Reset PCIe devices at boot time
From: Khalid Aziz <khalid@gonehiking.org>
To: Takao Indoh <indou.takao@jp.fujitsu.com>
Cc: martin.wilck@ts.fujitsu.com, linux-pci@vger.kernel.org, x86@kernel.org,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        hbabu@us.ibm.com, andi@firstfloor.org, ddutile@redhat.com,
        ishii.hironobu@jp.fujitsu.com, hpa@zytor.com, bhelgaas@google.com,
        tglx@linutronix.de, mingo@redhat.com, vgoyal@redhat.com
Date: Thu, 11 Oct 2012 11:28:43 -0600
In-Reply-To: <50766432.9000706@jp.fujitsu.com>
References: <20121010074553.1084.52175.sendpatchset@indoh>
	 <20121010074603.1084.92389.sendpatchset@indoh>
	 <1349899704.25679.14.camel@rhapsody> <50766432.9000706@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-10-11 at 15:16 +0900, Takao Indoh wrote:
> (2012/10/11 5:08), Khalid Aziz wrote:
.....
> >> +static void __init do_reset(u8 bus, u8 slot, u8 func)
> >> +{
> >> +	u16 ctrl;
> >> +
> >> +	printk(KERN_INFO "pci 0000:%02x:%02x.%d reset\n", bus, slot, func);
> >> +
> >> +	/* Assert Secondary Bus Reset */
> >> +	ctrl = read_pci_config_16(bus, slot, func, PCI_BRIDGE_CONTROL);
> >> +	ctrl |= PCI_BRIDGE_CTL_BUS_RESET;
> >> +	write_pci_config_16(bus, slot, func, PCI_BRIDGE_CONTROL, ctrl);
> >> +
> >> +	pci_udelay(5000);
> >> +
> >> +	/* De-assert Secondary Bus Reset */
> >> +	ctrl &= ~PCI_BRIDGE_CTL_BUS_RESET;
> >> +	write_pci_config_16(bus, slot, func, PCI_BRIDGE_CONTROL, ctrl);
> >> +
> >> +	pci_udelay(500000);
> >
> > This is 0.5 second. This will add up quickly on larger servers with
> > multiple busses. Is 0.5 second required by the spec?
> > aer_do_secondary_bus_reset() holds PCI_BRIDGE_CTL_BUS_RESET for 2 ms and
> > then waits another 200 ms after de-asserting it. Still long, but less
> > than half of the delay in above code..
> 
> According to PCIe spec, they should be more than 1ms and 100ms. The reason
> why they're 2ms and 200ms in aer_do_secondary_bus_reset() is that it's a
> kind of safety margin, I think.
> 
> At first these delay were 2ms and 200ms as well as
> aer_do_secondary_bus_reset(), but I found a problem that on certain
> machine it was not enough. I think this problem occurs because
> native_io_delay() is not precise. Therefore I extended them to have more
> margin.
> 
> If this delay should be shortened, I have two solutions.
> 
> 1)
> Call early_reset_pcie_devices() after calibrate_delay() so that we can
> use precise mdelay. Personally I don't want to do this because I think
> DMA should be stopped asap.
> 
> 2)
> Make it tuneable. For exmple, improve "reset_devices"
>      reset_devices=reset_delay=500
> or something like that. As default, 200ms is enough as far as I tested.
> But if it is not enough, we can adjust delay time using this.
> 
> Any other idea?
> 

I don't like the idea of asking end user to determine how many msec of
delay they would need on their system for a reset. If we have to go that
route, I would rather have a default of 200 msec and then add a kernel
option like "reset_devices=reset_delay=long" which changes the delay to
500 msec.

Here is another idea. The code you currently have does:

for (each device) {
  save config registers
  reset
  wait for 500 ms
  restore config registers
}

You need to wait for 500 ms because you can not access config registers
until reset is complete. So how about this - why not just save config
registers, reset each device and then wait only once for 500 ms before
restoring config registers on all devices. Here is what this will look
like:

for (each device) {
  save config registers
  reset
}
wait 500 ms
for (each device) {
  restore config registers
}

This is obviously more complex and requires you to allocate more space
for saving state, but it has the benefits of minimizing boot up delay
and making the delay constant irrespective of number of switches/bridges
on the system.

Does this sound reasonable?


> >
> > We have been seeing problems with kexec/kdump kernel for quite some time
> > that are related to I/O devices not being quiesced before kexec. I had
> > added code to clear Bus Master bit to help stop runaway DMAs which
> > helped many cases, but obviously not all. If resetting downstream ports
> > helps stop runaway I/O from PCIe devices, I am all for this approach.
> > This patch still doesn't do anything for old PCI devices though.
> 
> This patch does not reset PCI devices because of VGA problem. As I wrote
> in patch description, the monitor blacks out when VGA controller is
> reset. So when VGA device is found we need to skip it. In the case of
> PCIe, we can decide whether we do bus reset or not on each device, but
> we cannot in the case of PCI.

OK. My concern is there are plenty of older servers out there that
potentially have the problem with kexec/kdump failing often and we are
not solving the problem for them. If we can only solve it for PCIe for
now, I am ok with starting there.

--
Khalid


