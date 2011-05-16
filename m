Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546Ab1EPTe7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 15:34:59 -0400
Received: from christianhoffmann.info ([88.175.101.52]:57949 "EHLO
	christianhoffmann.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242Ab1EPTe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 15:34:57 -0400
Message-ID: <4DD17C5A.1050501@christianhoffmann.info>
Date: Mon, 16 May 2011 21:34:50 +0200
From: Christian Hoffmann <email@christianhoffmann.info>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: john stultz <johnstul@us.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Long timeout when booting >= 2.6.38
References: <4DBEFCBA.3070501@christianhoffmann.info>  <1304363375.3226.5.camel@work-vm> <4DBF1725.3030800@christianhoffmann.info>  <1304372955.3226.15.camel@work-vm>  <4DBF2FB4.8000304@christianhoffmann.info> <1304470839.3037.12.camel@work-vm> <4DC100D0.1030302@christianhoffmann.info> <alpine.LFD.2.02.1105041015220.3005@ionos> <4DC1832E.5030806@christianhoffmann.info> <alpine.LFD.2.02.1105041931510.3005@ionos> <4DC1AB9B.8080501@christianhoffmann.info> <alpine.LFD.2.02.1105042154410.3005@ionos> <4DC2DE2C.40108@christianhoffmann.info> <alpine.LFD.2.02.1105091020450.2895@ionos> <4DD0335A.6050400@christianhoffmann.info> <alpine.LFD.2.02.1105161105170.3078@ionos>
In-Reply-To: <alpine.LFD.2.02.1105161105170.3078@ionos>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>
> Nothing to be sorry about. Thanks for providing the information. If I
> decoded the problem correctly then this just unearthed a real long
> standing bug. Does the patch below solve the problem ?
>
> Thanks,
>
> 	tglx
>
> --- linux-2.6.orig/kernel/time/tick-broadcast.c
> +++ linux-2.6/kernel/time/tick-broadcast.c
> @@ -522,10 +522,11 @@ static void tick_broadcast_init_next_eve
>    */
>   void tick_broadcast_setup_oneshot(struct clock_event_device *bc)
>   {
> +	int cpu = smp_processor_id();
> +
>   	/* Set it up only once ! */
>   	if (bc->event_handler != tick_handle_oneshot_broadcast) {
>   		int was_periodic = bc->mode == CLOCK_EVT_MODE_PERIODIC;
> -		int cpu = smp_processor_id();
>
>   		bc->event_handler = tick_handle_oneshot_broadcast;
>   		clockevents_set_mode(bc, CLOCK_EVT_MODE_ONESHOT);
> @@ -551,6 +552,15 @@ void tick_broadcast_setup_oneshot(struct
>   			tick_broadcast_set_event(tick_next_period, 1);
>   		} else
>   			bc->next_event.tv64 = KTIME_MAX;
> +	} else {
> +		/*
> +		 * The first cpu which switches to oneshot mode sets
> +		 * the bit for all other cpus which are in the general
> +		 * (periodic) broadcast mask. So the bit is set and
> +		 * would prevent the first broadcast enter after this
> +		 * to program the bc device.
> +		 */
> +		tick_broadcast_clear_oneshot(cpu);
>   	}
>   }
>

Hi,

I booted a couple of times now, and the problem seems solved.

[    1.423793] TCP reno registered
[    1.423805] UDP hash table entries: 4096 (order: 5, 131072 bytes)
[    1.423847] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
[    1.423944] NET: Registered protocol family 1
[    1.423953] pci 0000:00:01.0: MSI quirk detected; subordinate MSI 
disabled
[    2.300205] pci 0000:01:05.0: Boot video device
[    2.300218] PCI: CLS 64 bytes, default 64
[    2.300262] Trying to unpack rootfs image as initramfs...
[    2.438632] Freeing initrd memory: 10540k freed
[    2.442368] PCI-DMA: Disabling AGP.
[    2.442501] PCI-DMA: aperture base @ c0000000 size 65536 KB
[    2.442503] PCI-DMA: using GART IOMMU.
[    2.442505] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[    2.446264] audit: initializing netlink socket (disabled)

Thanks a lot!!!

Kind regards,
Chris
