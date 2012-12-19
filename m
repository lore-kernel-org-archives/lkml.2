Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752254Ab2LSPsn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 10:48:43 -0500
Received: from mail-lb0-f181.google.com ([209.85.217.181]:64623 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755495Ab2LSPsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 10:48:38 -0500
X-Greylist: delayed 106859 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Dec 2012 10:48:37 EST
Message-ID: <50D1E1D1.4040803@openvz.org>
Date: Wed, 19 Dec 2012 19:48:33 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.11) Gecko/20121123 Firefox/10.0.11 Iceape/2.7.11
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] drivers/watchdog/eurotechwdt: handle spurious interrupts
 on wrong hardware
References: <20121218100023.26480.13240.stgit@zurg>
In-Reply-To: <20121218100023.26480.13240.stgit@zurg>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Konstantin Khlebnikov wrote:
> "eurotechwdt" hasn't any PCI-ID or DMI checks, thus is can be loaded on any
> hardware. On my PC this leads to immediate reboot, because driver got irq right
> after registering irq handler. This patch rejects interrupts until device
> activation. There is no sense to load this driver without special hardware,
> but such bugs blocks mine automatic testing for allmodconfig kernels.

Ah, this hack does not fixes the problem. Please ignore this patch.
I'll blacklist this module instead, because I have no idea how to fix this properly.

>
> Signed-off-by: Konstantin Khlebnikov<khlebnikov@openvz.org>
> Cc: Wim Van Sebroeck<wim@iguana.be>
> Cc: linux-watchdog@vger.kernel.org
> Cc: Alan Cox<alan@lxorguk.ukuu.org.uk>
>
> ---
>
> by default driver uses 10th irq, on my machine it's free:
>
> root@buzz:~# cat /proc/interrupts
>             CPU0       CPU1
>    0:        187          0   IO-APIC-edge      timer
>    1:          0          8   IO-APIC-edge      i8042
>    7:          2          0   IO-APIC-edge      parport0
>    8:          0          1   IO-APIC-edge      rtc0
>    9:          0          0   IO-APIC-fasteoi   acpi
>   10:          1          0   IO-APIC-edge
>   14:          1         61   IO-APIC-edge      pata_amd
>   15:          0          0   IO-APIC-edge      pata_amd
>   20:          0        317   IO-APIC-fasteoi   snd_hda_intel
>   22:          0          2   IO-APIC-fasteoi   ehci_hcd:usb1, sata_nv
>   23:          6       3667   IO-APIC-fasteoi   ohci_hcd:usb2, sata_nv
>   41:         93     776888   PCI-MSI-edge      eth0
> NMI:          0          2   Non-maskable interrupts
> LOC:      13293      32610   Local timer interrupts
> SPU:          0          0   Spurious interrupts
> PMI:          0          2   Performance monitoring interrupts
> IWI:          0          0   IRQ work interrupts
> RTR:          0          0   APIC ICR read retries
> RES:      11427       7619   Rescheduling interrupts
> CAL:        182         52   Function call interrupts
> TLB:        824        580   TLB shootdowns
> TRM:          0          0   Thermal event interrupts
> THR:          0          0   Threshold APIC interrupts
> MCE:          0          0   Machine check exceptions
> MCP:          2          2   Machine check polls
> ERR:          1
> MIS:          0
> ---
>   drivers/watchdog/eurotechwdt.c |    7 +++++++
>   1 file changed, 7 insertions(+)
>
> diff --git a/drivers/watchdog/eurotechwdt.c b/drivers/watchdog/eurotechwdt.c
> index cd31b8a..7d24914 100644
> --- a/drivers/watchdog/eurotechwdt.c
> +++ b/drivers/watchdog/eurotechwdt.c
> @@ -65,6 +65,7 @@
>   static unsigned long eurwdt_is_open;
>   static int eurwdt_timeout;
>   static char eur_expect_close;
> +static bool eurwdt_is_active;
>   static DEFINE_SPINLOCK(eurwdt_lock);
>
>   /*
> @@ -139,6 +140,7 @@ static inline void eurwdt_disable_timer(void)
>   static void eurwdt_activate_timer(void)
>   {
>   	eurwdt_disable_timer();
> +	eurwdt_is_active = true;
>   	eurwdt_write_reg(WDT_CTRL_REG, 0x01);	/* activate the WDT */
>   	eurwdt_write_reg(WDT_OUTPIN_CFG,
>   		!strcmp("int", ev) ? WDT_EVENT_INT : WDT_EVENT_REBOOT);
> @@ -164,6 +166,11 @@ static void eurwdt_activate_timer(void)
>
>   static irqreturn_t eurwdt_interrupt(int irq, void *dev_id)
>   {
> +	if (!eurwdt_is_active) {
> +		pr_crit("spurious interrupt\n");
> +		return IRQ_NONE;
> +	}
> +
>   	pr_crit("timeout WDT timeout\n");
>
>   #ifdef ONLY_TESTING
>

