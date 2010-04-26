Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752431Ab0DZOoe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 10:44:34 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:55811 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981Ab0DZOod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 10:44:33 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4BD5A6C0.3030704@s5r6.in-berlin.de>
Date: Mon, 26 Apr 2010 16:44:16 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100415 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Clemens Ladisch <clemens@ladisch.de>
CC: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] firewire: ohci: add MSI support
References: <4BD5667B.1030900@ladisch.de>
In-Reply-To: <4BD5667B.1030900@ladisch.de>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(adding Cc: lkml, quoting in full)

Clemens Ladisch wrote:
> This patch adds support for message-signaled interrupts.
> 
> Any native PCI-Express OHCI controller should support MSI, but most are
> just PCI cores behind a PCI-E/PCI bridge.  The only chips that are known
> to claim to support MSI are the Lucent/Agere/LSI FW643 and the VIA
> VT6315, none of which I have been able to test.

I got a FW643 card a few days ago and can test that one.  Also, I have a
JMicron JMB381 native PCIe 1394a controller.  The latter is a less ideal
test specimen since it is buggy already without MSI (soon stops to
operate if one dares to mix isochronous and asynchronous I/O; sometimes
also if there is a bus reset at an inconvenient time).

>From lspci:

04:00.0 FireWire (IEEE 1394): Agere Systems FW643 PCI Express1394b
Controller (PHY/Link) (rev 07) (prog-if 10 [OHCI])

        [...]
        Capabilities: [4c] MSI: Enable- Count=1/1 Maskable- 64bit+

                Address: 0000000000000000  Data: 0000

        Capabilities: [60] Express (v1) Endpoint, MSI 00

        [...]

0a:00.0 FireWire (IEEE 1394): JMicron Technology Corp. IEEE 1394 Host
Controller (prog-if 10 [OHCI])

        [...]
        Capabilities: [80] Express (v1) Endpoint, MSI 00

        [...]
        Capabilities: [94] MSI: Enable- Count=1/1 Maskable- 64bit-

                Address: fffffffc  Data: 0000

        [...]

Does "MSI 00", "MSI: Enable-" mean they do or don't support MSI?  Asks a
PCIe newbie.

The FW643 (actually two of them) sits behind a PCIe switch:

03:04.0 PCI bridge: PLX Technology, Inc. PEX 8505 5-lane, 5-port PCI
Express Switch (rev aa) (prog-if 00 [Normal decode])

        [...]
        Capabilities: [48] MSI: Enable+ Count=1/2 Maskable+ 64bit+

                Address: 00000000fee0f00c  Data: 41a1

                Masking: 00000003  Pending: 00000000

        Capabilities: [68] Express (v1) Downstream Port (Slot+), MSI 00

        [...]

I hope this switch does not make things any more interesting.

> Due to the high level of trust I have in the competence of these and any
> future chip makers, I thought it a good idea to add a disable-MSI quirk.
> 
> Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
> ---
>  drivers/firewire/ohci.c |   13 ++++++++++---
>  1 file changed, 10 insertions(+), 3 deletions(-)
> 
> --- a/drivers/firewire/ohci.c
> +++ b/drivers/firewire/ohci.c
> @@ -237,6 +237,7 @@ static char ohci_driver_name[] = KBUILD_
>  #define QUIRK_RESET_PACKET		2
>  #define QUIRK_BE_HEADERS		4
>  #define QUIRK_NO_1394A			8
> +#define QUIRK_NO_MSI			16
>  
>  /* In case of multiple matches in ohci_quirks[], only the first one is used. */
>  static const struct {
> @@ -260,6 +261,7 @@ MODULE_PARM_DESC(quirks, "Chip quirks (d
>  	", reset packet generation = "	__stringify(QUIRK_RESET_PACKET)
>  	", AR/selfID endianess = "	__stringify(QUIRK_BE_HEADERS)
>  	", no 1394a enhancements = "	__stringify(QUIRK_NO_1394A)
> +	", disable MSI = "		__stringify(QUIRK_NO_MSI)
>  	")");
>  
>  #define OHCI_PARAM_DEBUG_AT_AR		1
> @@ -1718,10 +1720,13 @@ static int ohci_enable(struct fw_card *c
>  
>  	reg_write(ohci, OHCI1394_AsReqFilterHiSet, 0x80000000);
>  
> +	if (!(ohci->quirks & QUIRK_NO_MSI))
> +		pci_enable_msi(dev);
>  	if (request_irq(dev->irq, irq_handler,
> -			IRQF_SHARED, ohci_driver_name, ohci)) {
> +			pci_dev_msi_enabled(dev) ? 0 : IRQF_SHARED,
> +			ohci_driver_name, ohci)) {
> -		fw_error("Failed to allocate shared interrupt %d.\n",
> -			 dev->irq);
> +		fw_error("Failed to allocate interrupt %d.\n", dev->irq);
> +		pci_disable_msi(dev);
>  		dma_free_coherent(ohci->card.device, CONFIG_ROM_SIZE,
>  				  ohci->config_rom, ohci->config_rom_bus);
>  		return -EIO;
> @@ -2625,6 +2630,7 @@ static void pci_remove(struct pci_dev *d
>  	context_release(&ohci->at_response_ctx);
>  	kfree(ohci->it_context_list);
>  	kfree(ohci->ir_context_list);
> +	pci_disable_msi(dev);
>  	pci_iounmap(dev, ohci->registers);
>  	pci_release_region(dev, 0);
>  	pci_disable_device(dev);
> @@ -2642,6 +2648,7 @@ static int pci_suspend(struct pci_dev *d
>  
>  	software_reset(ohci);
>  	free_irq(dev->irq, ohci);
> +	pci_disable_msi(dev);
>  	err = pci_save_state(dev);
>  	if (err) {
>  		fw_error("pci_save_state failed\n");

Looks right, but what do I know?
-- 
Stefan Richter
-=====-==-=- -=-- ==-=-
http://arcgraph.de/sr/
