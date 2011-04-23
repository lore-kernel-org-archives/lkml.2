Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753115Ab1DWKP5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 06:15:57 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:63083 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752877Ab1DWKP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 06:15:56 -0400
Message-ID: <4DB2A6A2.90803@metafoo.de>
Date: Sat, 23 Apr 2011 12:14:58 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110307 Icedove/3.0.11
MIME-Version: 1.0
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
CC: "'Grant Likely'" <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        toshiharu-linux@dsn.okisemi.com
Subject: Re: Question: GPIO driver how to get irq_base
References: <F9B588C24C5F470494D57D4EFFB14C6B@hacdom.okisemi.com> <4DAFE62A.105@metafoo.de> <20110421134524.GA32725@ponder.secretlab.ca> <4DB03A4B.9040807@metafoo.de> <20110421142422.GC32725@ponder.secretlab.ca> <4C95BE12C2D7458E9D2B54E7C30F712F@hacdom.okisemi.com>
In-Reply-To: <4C95BE12C2D7458E9D2B54E7C30F712F@hacdom.okisemi.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22/2011 03:12 AM, Tomoya MORINAGA wrote:
> Hi Grant, Lars-Peter Clausen,
> 
> - Executing the following command,
>   cd /sys/class/gpio/gpio244
>   echo "falling" > edge
> 
> - I can see the following error message.
>   IRQ handler type mismatch for IRQ 18
>   current handler: spi_topcliff_pch
>   Pid: 3269, comm: bash Not tainted 2.6.38.3.upstream_check+ #23
>   Call Trace:
>    [<c0470682>] ? __setup_irq+0x257/0x2a9
>    [<c054a45f>] ? gpio_sysfs_irq+0x0/0x11
>    [<c047077c>] ? request_threaded_irq+0xa8/0xce
>    [<c04707fb>] ? request_any_context_irq+0x59/0x64
>    [<c054a45f>] ? gpio_sysfs_irq+0x0/0x11
>    [<c054a8f5>] ? gpio_setup_irq.clone.4+0x1fa/0x292
>    [<c054ae2c>] ? gpio_edge_store+0xa3/0xd2
>    [<c054ad89>] ? gpio_edge_store+0x0/0xd2
>    [<c05bf270>] ? dev_attr_store+0x1b/0x23
>    [<c04e90a5>] ? sysfs_write_file+0xae/0xe7
>    [<c04e8ff7>] ? sysfs_write_file+0x0/0xe7
>    [<c04a71a1>] ? vfs_write+0x82/0xd9
>    [<c04a7366>] ? sys_write+0x3b/0x5d
>    [<c0403018>] ? sysenter_do_call+0x12/0x28
> 
>> Using the above, I can see "irq_base = 18d".
> - According to the following "/proc/interrupts" information,
>   I suspect pch_gpio can't use IRQ18.
> 
> [morinaga@localhost ~]$ cat /proc/interrupts 
>            CPU0       CPU1       
>   0:      30881          0   IO-APIC-edge      timer
>   1:          2          0   IO-APIC-edge      i8042
>   4:          2          0   IO-APIC-edge    
>   8:        128          0   IO-APIC-edge      rtc0
>   9:          0          0   IO-APIC-fasteoi   acpi
>  12:          4          0   IO-APIC-edge      i8042
>  16:        385          0   IO-APIC-fasteoi   intel-eg20t-pch, ehci_hcd:usb2, ohci_hcd:usb6, ohci_hcd:usb7, ohci_hcd:usb8,
> hda_intel
>  17:          0          0   IO-APIC-fasteoi   eth1
>  18:          0          0   IO-APIC-fasteoi   spi_topcliff_pch, i2c_eg20t, pch-dma, mmc0, mmc1
>  19:       3599          0   IO-APIC-fasteoi   ehci_hcd:usb1, ohci_hcd:usb3, ohci_hcd:usb4, ohci_hcd:usb5, pch-dma,
> mga@pci:0000:07:00.0
>  40:      10298          0   PCI-MSI-edge      ahci
>  42:         98          0   PCI-MSI-edge      eth0
> NMI:          0          0   Non-maskable interrupts
> LOC:      76268      72502   Local timer interrupts
> SPU:          0          0   Spurious interrupts
> PMI:          0          0   Performance monitoring interrupts
> IWI:          0          0   IRQ work interrupts
> RES:       1383       1842   Rescheduling interrupts
> CAL:         67        108   Function call interrupts
> TLB:        224        292   TLB shootdowns
> TRM:          0          0   Thermal event interrupts
> THR:          0          0   Threshold APIC interrupts
> MCE:          0          0   Machine check exceptions
> MCP:          1          1   Machine check polls
> ERR:          0
> MIS:          0
> 
> Let me know your opinion.
> 
> Thanks,
> -----------------------------------------
> Tomoya MORINAGA
> OKI SEMICONDUCTOR CO., LTD.
> 

Hi

It looks as both your driver and IO-APIC have allocated the same IRQ. You could
try to add some debug code to alloc_irq_and_cfg_at to figure out what is going
wrong.

- Lars
