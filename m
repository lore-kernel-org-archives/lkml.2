Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892Ab1IVUXm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 16:23:42 -0400
Received: from peace.netnation.com ([204.174.223.2]:49574 "EHLO
	peace.netnation.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753878Ab1IVUXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 16:23:38 -0400
Date: Thu, 22 Sep 2011 13:23:37 -0700
From: Simon Kirby <sim@hostway.ca>
To: Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org
Subject: Re: [3.1-rc6] kmalloc(64) leak from IDE
Message-ID: <20110922202337.GB32661@hostway.ca>
References: <20110922072643.GA27232@hostway.ca> <20110922084811.GC17640@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110922084811.GC17640@liondog.tnic>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 22, 2011 at 10:48:11AM +0200, Borislav Petkov wrote:

> On Thu, Sep 22, 2011 at 12:26:44AM -0700, Simon Kirby wrote:
> > All sorts of fun with 3.1-rc!
> > 
> > On an older x86 box still using the IDE code, I'm seeing a kmalloc(64)
> > leak (according to slabtop) that basically OOM'd the box in a few days
> > (640 MB of RAM). This has popped up since 2.6.36, which ran for a long
> > time on this box with no problems. Issues seen on -rc5, so I rebuilt with
> > CONFIG_DEBUG_KMEMLEAK on 9d037a777695993ec7437e5f451647dea7919d4c and
> > /sys/kernel/debug/kmemleak filled up with size 64 traces involving IDE
> > requests. Every trace seems to contain idedisk_prep_fn():
> > 
> > unreferenced object 0xe30c00c0 (size 64):
> >   comm "md6_raid1", pid 255, jiffies 4294903935 (age 23889.704s)
> >   hex dump (first 32 bytes):
> >     00 00 00 00 00 00 00 ea 00 00 00 00 00 00 00 00  ................
> >     7e 00 00 00 20 00 00 00 01 00 00 00 00 00 00 00  ~... ...........
> >   backtrace:
> >     [<c1495c37>] kmemleak_alloc+0x27/0x50
> >     [<c10b2f4a>] kmem_cache_alloc_trace+0x8a/0x120
> >     [<c131fe47>] idedisk_prep_fn+0x37/0xf0
> >     [<c12758b3>] blk_peek_request+0xa3/0x1e0
> >     [<c1311f15>] __ide_requeue_and_plug+0x25/0x30
> >     [<c131257d>] do_ide_request+0x3d/0x4e0
> >     [<c1270ff4>] __blk_run_queue+0x14/0x20
> >     [<c127699c>] __make_request+0x21c/0x290
> >     [<c1274f26>] generic_make_request+0x1a6/0x490
> >     [<c127526c>] submit_bio+0x5c/0xd0
> >     [<c13a651b>] md_super_write+0x6b/0x80
> >     [<c13a67ec>] md_update_sb+0x2bc/0x540
> >     [<c13a7d51>] md_check_recovery+0x2c1/0x5f0
> >     [<c138abce>] raid1d+0x2e/0xd90
> >     [<c13a58d5>] md_thread+0xe5/0x110
> >     [<c1047df4>] kthread+0x74/0x80
> > 
> > unreferenced object 0xc1c3d900 (size 64):
> >   comm "hardirq", pid 0, jiffies 5819438 (age 829.636s)
> >   hex dump (first 32 bytes):
> >     00 00 00 00 00 00 00 ea 00 00 00 00 00 00 00 00  ................
> >     7e 00 00 00 20 00 00 00 01 00 00 00 00 00 00 00  ~... ...........
> >   backtrace:
> >     [<c1495c37>] kmemleak_alloc+0x27/0x50
> >     [<c10b2f4a>] kmem_cache_alloc_trace+0x8a/0x120
> >     [<c131fe47>] idedisk_prep_fn+0x37/0xf0
> >     [<c12758b3>] blk_peek_request+0xa3/0x1e0
> >     [<c1311f15>] __ide_requeue_and_plug+0x25/0x30
> >     [<c1311f2f>] ide_requeue_and_plug+0xf/0x20
> >     [<c1311fb8>] ide_intr+0x78/0x1e0
> >     [<c1065c14>] handle_irq_event_percpu+0x54/0x1d0
> >     [<c1065dac>] handle_irq_event+0x1c/0x30
> >     [<c1067b8c>] handle_level_irq+0x4c/0xa0
> >     [<ffffffff>] 0xffffffff
> > 
> > idedisk_prep_fn() seems to allocate a command and return it as
> > rq->special, but I'm not following what happens after that.
> 
> AFAIR, that's blk_peek_request - it calls q->prep_rq_fn which is
> idedisk_prep_fn() and it unconditionally allocates those ide_cmd's
> without freeing them and I can imagine the upper layer requeue one
> request a couple of times back-to-back, leading to the leaks.
> 
> So maybe the following could work, it is a stab in the dark for all I
> know:
> 
> --
> diff --git a/drivers/ide/ide-disk.c b/drivers/ide/ide-disk.c
> index 274798068a54..16f69be820c7 100644
> --- a/drivers/ide/ide-disk.c
> +++ b/drivers/ide/ide-disk.c
> @@ -435,7 +435,12 @@ static int idedisk_prep_fn(struct request_queue *q, struct request *rq)
>  	if (!(rq->cmd_flags & REQ_FLUSH))
>  		return BLKPREP_OK;
>  
> -	cmd = kzalloc(sizeof(*cmd), GFP_ATOMIC);
> +	if (rq->special) {
> +		cmd = rq->special;
> +		memset(cmd, 0, sizeof(*cmd));
> +	} else {
> +		cmd = kzalloc(sizeof(*cmd), GFP_ATOMIC);
> +	}
>  
>  	/* FIXME: map struct ide_taskfile on rq->cmd[] */
>  	BUG_ON(cmd == NULL);
> --
> 
> Can you rerun it with kmemleak enabled and check whether it still
> triggers?

Yes, that seems to have made it stop complaining about the IDE path.
All I see from kmemleak now is:

unreferenced object 0xe7481a00 (size 256):
  comm "swapper", pid 1, jiffies 4294892509 (age 515.560s)
  hex dump (first 32 bytes):
    00 00 00 28 ff ff ef ff 60 78 4e e7 00 02 00 00  ...(....`xN.....
    47 01 f8 0c f8 0c 01 08 00 00 00 00 0c 03 00 00  G...............
  backtrace:
    [<c1495c47>] kmemleak_alloc+0x27/0x50
    [<c10b3563>] __kmalloc+0xf3/0x1c0
    [<c149e0b0>] pci_acpi_scan_root+0x11e/0x272
    [<c149916b>] acpi_pci_root_add+0x163/0x256
    [<c12adddc>] acpi_device_probe+0x3a/0xf4
    [<c1302e38>] driver_probe_device+0x68/0x160
    [<c1302fb9>] __driver_attach+0x89/0x90
    [<c1302718>] bus_for_each_dev+0x48/0x70
    [<c1302cc9>] driver_attach+0x19/0x20
    [<c130213f>] bus_add_driver+0x17f/0x240
    [<c1303345>] driver_register+0x65/0x120
    [<c12af273>] acpi_bus_register_driver+0x3a/0x3f
    [<c16d421f>] acpi_pci_root_init+0x1b/0x2a
    [<c1001030>] do_one_initcall+0x30/0x160
    [<c16b920b>] kernel_init+0x78/0x10c
    [<c14a1b76>] kernel_thread_helper+0x6/0xd
unreferenced object 0xe74e7860 (size 16):
  comm "swapper", pid 1, jiffies 4294892509 (age 515.560s)
  hex dump (first 16 bytes):
    50 43 49 20 42 75 73 20 30 30 30 30 3a 30 30 00  PCI Bus 0000:00.
  backtrace:
    [<c1495c47>] kmemleak_alloc+0x27/0x50
    [<c10b3563>] __kmalloc+0xf3/0x1c0
    [<c1290cce>] kvasprintf+0x2e/0x50
    [<c1290d01>] kasprintf+0x11/0x20
    [<c149e0da>] pci_acpi_scan_root+0x148/0x272
    [<c149916b>] acpi_pci_root_add+0x163/0x256
    [<c12adddc>] acpi_device_probe+0x3a/0xf4
    [<c1302e38>] driver_probe_device+0x68/0x160
    [<c1302fb9>] __driver_attach+0x89/0x90
    [<c1302718>] bus_for_each_dev+0x48/0x70
    [<c1302cc9>] driver_attach+0x19/0x20
    [<c130213f>] bus_add_driver+0x17f/0x240
    [<c1303345>] driver_register+0x65/0x120
    [<c12af273>] acpi_bus_register_driver+0x3a/0x3f
    [<c16d421f>] acpi_pci_root_init+0x1b/0x2a
    [<c1001030>] do_one_initcall+0x30/0x160

...which is probably a separate, non-recurring leak.

> Also, I'm sure you know IDE is deprecated, so what are the chances of
> moving this box to libata? Also, can you send me your .config pls?

Yeah, I was going to get around to that eventually. :) Config (and
earlier kmemleak output) here: http://0x.ca/sim/ref/3.1-rc6-blue/

Simon-
