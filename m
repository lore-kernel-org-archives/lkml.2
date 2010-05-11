Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253Ab0EKPy5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 11:54:57 -0400
Received: from mail-wy0-f180.google.com ([74.125.82.180]:33119 "EHLO
	mail-wy0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852Ab0EKPyz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 11:54:55 -0400
X-Greylist: delayed 1129 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 May 2010 11:54:54 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=mWDVvR8pA/PffJLpMjJEXYcK0bWYvnx5gZ5UgHuxKfnReogjP6hDJqCZ9HRJamvd3E
         4U60uzD14rnYuEFhlU8ZU9wV5rwB4SluiIMQOstd2jEr9Ac7AQ4zUyV3sukqJntCs06X
         odEkspwj5p/J4/1/SKiXN//sM7UsMYnDSn858=
MIME-Version: 1.0
In-Reply-To: <AANLkTikkSRI6u_mp6mNQReECB84t3oh-_MPVzAYEQULN@mail.gmail.com>
References: <AANLkTikkSRI6u_mp6mNQReECB84t3oh-_MPVzAYEQULN@mail.gmail.com>
Date: Tue, 11 May 2010 18:27:52 +0300
Message-ID: <AANLkTikoNc6oAY5JthYX1jWx1w2KeJ1fGab72Z-OvIVG@mail.gmail.com>
Subject: Re: [BUG] bug when enabling VM DEBUG
From: saeed bishara <saeed.bishara@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: "DE/ATA development list" <linux-ide@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff,
seems that the libata do pio to buffer which was allocated with
kmalloc, and under arm arch, the flush_dcache_page() is needed to
prevent cache aliasing, the later function calls the page_mapping
which falls on PageSlab(page)

as the flush_dcache_page() is needed to prevent aliasing, it can be
skipped if the page is Slab as such pages are used only by the kernel.
here a suggested patch:

--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -894,7 +894,7 @@ static void ata_pio_sector(struct ata_queued_cmd *qc)
                                       do_write);
        }

-       if (!do_write)
+       if (!do_write && !PageSlab(page))
                flush_dcache_page(page);

saeed


On Mon, May 10, 2010 at 4:06 PM, saeed bishara <saeed.bishara@gmail.com> wrote:
> Hi,
>  I got the following bug when enabling the VM_DEBGU on 2.6.34-rc6:
>
> Unable to handle kernel NULL pointer dereference at virtual address 00000000
> pgd = c0004000
> [00000000] *pgd=00000000
> Internal error: Oops: 805 [#1]
> last sysfs file:
> Modules linked in:
> CPU: 0    Not tainted  (2.6.34-rc6-00176-g00047b8-dirty #331)
> PC is at flush_dcache_page+0x2c/0xc4
> LR is at ata_pio_sector+0xd8/0x124
> pc : [<c002d30c>]    lr : [<c01c29d4>]    psr: 20000013
> sp : f5513ee8  ip : 79a50000  fp : 00001ee8
> r10: 00000058  r9 : f54f0000  r8 : 00000000
> r7 : f54f1358  r6 : c03e6b84  r5 : 00000000  r4 : 00000000
> r3 : 00000000  r2 : 00000000  r1 : f54f17b8  r0 : c0ac4e20
> Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
> Control: 10c5387d  Table: 00004019  DAC: 00000017
> Process ata/0 (pid: 145, stack limit = 0xf55122f0)
> Stack: (0xf5513ee8 to 0xf5514000)
> 3ee0:                   c0ac4e20 c01c29d4 00000009 f54f1358 f54f1358 00000001
> 3f00: c040d18c c01c2ad8 00000005 00000009 f54f0000 c01c3204 c03cfe78 00000000
> 3f20: 00200200 f54f13d4 c00446e4 00000001 f54f1424 00000000 00000000 00000000
> 3f40: 00000000 00000000 ffffffff 00000009 f54f0000 f54f1358 00000001 c040d18c
> 3f60: 00000005 0000000a 00001ee8 c01c46d8 f5413c70 f54b5b68 c01c45d4 f54b5b60
> 3f80: f5512000 f5513f9c 00000000 00000000 00000000 c004b2c0 00000000 00000000
> 3fa0: f54be0c0 c004e12c f5513fa8 f5513fa8 f5429ec8 f5513fd4 f5429ec8 f54b5b60
> 3fc0: c004b1c8 00000000 00000000 c004e014 00000000 00000000 f5513fd8 f5513fd8
> 3fe0: 00000000 00000000 00000000 00000000 00000000 c0026dec bc7e4afb 6a3a8a30
> [<c002d30c>] (flush_dcache_page+0x2c/0xc4) from [<c01c29d4>]
> (ata_pio_sector+0xd8/0x124)
> [<c01c29d4>] (ata_pio_sector+0xd8/0x124) from [<c01c2ad8>]
> (ata_pio_sectors+0xb8/0xc4)
> [<c01c2ad8>] (ata_pio_sectors+0xb8/0xc4) from [<c01c3204>]
> (ata_sff_hsm_move+0x618/0x76c)
> [<c01c3204>] (ata_sff_hsm_move+0x618/0x76c) from [<c01c46d8>]
> (ata_pio_task+0x104/0x124)
> [<c01c46d8>] (ata_pio_task+0x104/0x124) from [<c004b2c0>]
> (worker_thread+0xf8/0x170)
> [<c004b2c0>] (worker_thread+0xf8/0x170) from [<c004e014>] (kthread+0x78/0x80)
> [<c004e014>] (kthread+0x78/0x80) from [<c0026dec>] (kernel_thread_exit+0x0/0x8)
> Code: e5904010 e3130080 0a000002 e3a03000 (e5833000)
> ---[ end trace 8a7ce1ae66250005 ]---
>
