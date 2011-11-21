Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755252Ab1KUIyj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 03:54:39 -0500
Received: from metasoft.pl ([195.149.224.191]:43272 "EHLO smtp.metasoft.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752825Ab1KUIyi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 03:54:38 -0500
X-clamdmail: clamdmail 0.18a
Message-ID: <4ECA11C5.802@metasoft.pl>
Date: Mon, 21 Nov 2011 09:54:29 +0100
From: Rafal Prylowski <prylowski@metasoft.pl>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Mika Westerberg <mika.westerberg@iki.fi>
CC: linux-arm-kernel@lists.infradead.org, rmallon@gmail.com,
        vinod.koul@intel.com, broonie@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        hsweeten@visionengravers.com, dan.j.williams@intel.com, lrg@ti.com
Subject: Re: [PATCH v2 1/5] dmaengine: add ep93xx DMA support
References: <cover.1306662317.git.mika.westerberg@iki.fi> <3ea8d56034f25cbe3fd8a4c31d7d0d1540b6ac7e.1306662317.git.mika.westerberg@iki.fi> <4EC27EED.4030108@metasoft.pl> <20111116065512.GB2703@mwesterb-mobl.ger.corp.intel.com> <4EC374F0.8000400@metasoft.pl> <20111119123837.GA2711@mwesterb-mobl.ger.corp.intel.com> <4ECA0147.4020806@metasoft.pl> <20111121080158.GA2713@mwesterb-mobl.ger.corp.intel.com>
In-Reply-To: <20111121080158.GA2713@mwesterb-mobl.ger.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> I'm calling dma_terminate_all from interrupt. It seems that tasklet_kill is not
>> allowed to be called from this context.
> 
> Ah, right.
> 
> One more try - this time we set a flag which prevents the tasktlet from
> referencing an empty list.
> 
> diff --git a/drivers/dma/ep93xx_dma.c b/drivers/dma/ep93xx_dma.c
> index 6181811..f7244b3 100644
> --- a/drivers/dma/ep93xx_dma.c
> +++ b/drivers/dma/ep93xx_dma.c
> @@ -155,6 +155,8 @@ struct ep93xx_dma_chan {
>  	unsigned long			flags;
>  /* Channel is configured for cyclic transfers */
>  #define EP93XX_DMA_IS_CYCLIC		0
> +/* Channel is enabled */
> +#define EP93xx_DMA_IS_RUNNING		1
>  
>  	int				buffer;
>  	dma_cookie_t			last_completed;
> @@ -673,6 +675,9 @@ static void ep93xx_dma_tasklet(unsigned long data)
>  	void *callback_param;
>  	LIST_HEAD(list);
>  
> +	if (!test_bit(EP93XX_DMA_IS_RUNNING, &edmac->flags))
> +		return;
> +
>  	spin_lock_irq(&edmac->lock);
>  	desc = ep93xx_dma_get_active(edmac);
>  	if (desc->complete) {
> @@ -758,6 +763,8 @@ static dma_cookie_t ep93xx_dma_tx_submit(struct dma_async_tx_descriptor *tx)
>  	edmac->chan.cookie = cookie;
>  	desc->txd.cookie = cookie;
>  
> +	set_bit(EP93XX_DMA_IS_RUNNING, &edmac->flags);
> +
>  	/*
>  	 * If nothing is currently prosessed, we push this descriptor
>  	 * directly to the hardware. Otherwise we put the descriptor
> @@ -1106,6 +1113,7 @@ static int ep93xx_dma_terminate_all(struct ep93xx_dma_chan *edmac)
>  	spin_lock_irqsave(&edmac->lock, flags);
>  	/* First we disable and flush the DMA channel */
>  	edmac->edma->hw_shutdown(edmac);
> +	clear_bit(EP93XX_DMA_IS_RUNNING, &edmac->flags);
>  	clear_bit(EP93XX_DMA_IS_CYCLIC, &edmac->flags);
>  	list_splice_init(&edmac->active, &list);
>  	list_splice_init(&edmac->queue, &list);
> 

This patch works partially for me. Drive is detected correctly, I can do simple test with
hdparm, mount partitions, create file with 'touch' command, but when trying to fill
partition with data I get:

# dd if=/dev/zero of=/mnt/b/zero4 bs=4M
Internal error: Oops - undefined instruction: 0 [#1]
CPU: 0    Not tainted  (3.2.0-rc2EP-1+ #1017)
PC is at 0xc1862868
LR is at ep93xx_dma_tasklet+0xc4/0x174
pc : [<c1862868>]    lr : [<c012b498>]    psr: 00000013
sp : c10c3b60  ip : ffffffff  fp : c10c3b94
r10: 00000100  r9 : 80000013  r8 : c10c3b40
r7 : c10c3b60  r6 : c10c3b94  r5 : 00000094  r4 : c10c3b60
r3 : c10c320d  r2 : a0e96520  r1 : c1862758  r0 : c10c3b94
Flags: nzcv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
Control: c000717f  Table: c1240000  DAC: 00000015
Process dd (pid: 619, stack limit = 0xc10c2270)
Stack: (0xc10c3b60 to 0xc10c4000)
3b60: c10c3b94 c10c3b60 00000001 c02bd5c4 c02d60e0 00000000 00000000 c02bd44c
3b80: c02d60e0 00000100 c10c3bb4 c10c3b98 c001c49c c012b3e4 00000018 00000001
3ba0: c02d60e0 c10c2000 c10c3bf4 c10c3bb8 c001cbc0 c001c3e4 c10c3bdc c10c3bc8
3bc0: 00000006 0000000a c02bf6e4 c02c4578 00000012 00000000 c10c3c6c 00000000
3be0: 00000000 00000000 c10c3c04 c10c3bf8 c001cdd0 c001cb38 c10c3c24 c10c3c08
3c00: c000983c c001cd98 c00e1160 80000013 fefb0001 c10c3c6c c10c3c34 c10c3c28
3c20: c0008190 c0009810 c10c3ccc c10c3c38 c0008b64 c0008190 c1a44058 00000003
3c40: ffffb58e ffffffc7 c156a000 c1a70060 c10c2000 c1a44000 00000000 00000000
3c60: 00000000 c10c3ccc c1a4404c c10c3c80 c0011a28 c00e1160 80000013 ffffffff
3c80: 00000000 00001000 c10c3cb4 c10c3c98 c00d9eac c00e0f88 c156a000 c1791250
3ca0: c156a000 00000000 c0242f4c c1a44600 03605000 00000000 00000000 00001000
3cc0: c10c3cec c10c3cd0 c00d9eac c00e0f88 c1791250 c02f9860 c156a000 03605000
3ce0: c10c3d2c c10c3cf0 c00d3d7c c00d9e94 00001000 00001000 c02f9860 c008df3c
3d00: c10c3d58 c0242d18 c10c2000 c1791308 00000000 c10c3d58 00001000 00204000
3d20: c10c3d9c c10c3d30 c0046f00 c00d3cbc 00001000 00001000 c02f9860 c008df3c
3d40: 00000000 00001000 c0242d18 c19e4000 03604000 00000000 c10c3f10 00000001
3d60: 00204000 001fc000 c008df3c c02f9860 00000073 c10c3ec8 c10c2000 c19e4000
3d80: 000001fe 00000000 c10c3f10 c1791308 c10c3e2c c10c3da0 c0049028 c0046e10
3da0: 03400000 00000000 c10c3ec8 00400000 00000000 c10c3dd0 c10c3dc4 00400000
3dc0: 03800000 00000000 00000001 c10c3ec8 c10c3e90 c02d8148 03400000 00000000
3de0: c10c3dec 00000001 c00443e8 00000001 c02d60e0 00000008 c02bf6e4 00400000
3e00: 00000000 c10c3e40 c17912ac c19e4000 03400000 c10c3e90 c10c3f10 00000001
3e20: c10c3e84 c10c3e30 c00492a4 c0048cf0 c10c3e3c c0045198 c0044954 00000000
3e40: 91827364 c10c3e44 c10c3e44 c10c3e4c c10c3e4c 00000000 c10c3e64 c10c3e90
3e60: c19e4000 c10c3f10 fffffdee c10c3f78 03400000 00000000 c10c3f44 c10c3e88
3e80: c0079114 c0049234 03400000 00000000 c0008190 40b90a78 00000000 00000001
3ea0: ffffffff c19e4000 00000000 00000000 00000000 00000000 c1aea000 c10c2000
3ec0: 00000000 00000000 03400000 00000000 c10c3f0c c10c3ee0 00400000 c0034478
3ee0: 00400000 c1a03658 00001000 40b95008 00001000 003ff000 c10c2000 c1818780
3f00: c19e4288 00000001 c01197e8 00000000 40796008 00400000 c01474b0 c19e4000
3f20: 00400000 40796008 c10c3f78 c0009124 c10c2000 00000000 c10c3f74 c10c3f48
3f40: c0079c7c c0079064 00000000 00000000 c0009124 c19e4000 03400000 00000000
3f60: 00000004 c0009124 c10c3fa4 c10c3f78 c0079df4 c0079bd0 03400000 00000000
3f80: 00000004 00000000 c10c2000 00400000 40796008 4004f7e0 00000000 c10c3fa8
3fa0: c0008fa0 c0079db8 00400000 40796008 00000001 40796008 00400000 000abfc4
3fc0: 00400000 40796008 4004f7e0 00000004 40796008 40796008 bedb5f34 00000000
3fe0: 00000001 bedb5ba0 0000ef78 40180dcc 60000010 00000001 00000000 00000000
Backtrace:
[<c012b3d4>] (ep93xx_dma_tasklet+0x0/0x174) from [<c001c49c>] (tasklet_action+0x
c8/0xdc)
[<c001c3d4>] (tasklet_action+0x0/0xdc) from [<c001cbc0>] (__do_softirq+0x98/0x15
4)
 r7:c10c2000 r6:c02d60e0 r5:00000001 r4:00000018
[<c001cb28>] (__do_softirq+0x0/0x154) from [<c001cdd0>] (irq_exit+0x48/0x50)
[<c001cd88>] (irq_exit+0x0/0x50) from [<c000983c>] (handle_IRQ+0x3c/0x8c)
[<c0009800>] (handle_IRQ+0x0/0x8c) from [<c0008190>] (asm_do_IRQ+0x10/0x14)
 r7:c10c3c6c r6:fefb0001 r5:80000013 r4:c00e1160
[<c0008180>] (asm_do_IRQ+0x0/0x14) from [<c0008b64>] (__irq_svc+0x24/0xc0)
Exception stack(0xc10c3c38 to 0xc10c3c80)
3c20:                                                       c1a44058 00000003
3c40: ffffb58e ffffffc7 c156a000 c1a70060 c10c2000 c1a44000 00000000 00000000
3c60: 00000000 c10c3ccc c1a4404c c10c3c80 c0011a28 c00e1160 80000013 ffffffff
[<c00e0f78>] (journal_stop+0x0/0x2bc) from [<c00d9eac>] (__ext3_journal_stop+0x2
8/0x58)
[<c00d9e84>] (__ext3_journal_stop+0x0/0x58) from [<c00d3d7c>] (ext3_writeback_wr
ite_end+0xd0/0x174)
 r7:03605000 r6:c156a000 r5:c02f9860 r4:c1791250
[<c00d3cac>] (ext3_writeback_write_end+0x0/0x174) from [<c0046f00>] (generic_fil
e_buffered_write+0x100/0x25c)
[<c0046e00>] (generic_file_buffered_write+0x0/0x25c) from [<c0049028>] (__generi
c_file_aio_write+0x348/0x544)
[<c0048ce0>] (__generic_file_aio_write+0x0/0x544) from [<c00492a4>] (generic_fil
e_aio_write+0x80/0xe8)
[<c0049224>] (generic_file_aio_write+0x0/0xe8) from [<c0079114>] (do_sync_write+
0xc0/0xf8)
[<c0079054>] (do_sync_write+0x0/0xf8) from [<c0079c7c>] (vfs_write+0xbc/0x150)
[<c0079bc0>] (vfs_write+0x0/0x150) from [<c0079df4>] (sys_write+0x4c/0x84)
 r8:c0009124 r7:00000004 r6:00000000 r5:03400000 r4:c19e4000
[<c0079da8>] (sys_write+0x0/0x84) from [<c0008fa0>] (ret_fast_syscall+0x0/0x2c)
 r6:4004f7e0 r5:40796008 r4:00400000
Code: 42555300 54535953 643d4d45 65766972 (53007372)
---[ end trace 8f90267a5628d8bf ]---
Kernel panic - not syncing: Fatal exception in interrupt

I don't get this exception when using my patch, posted in first email.
