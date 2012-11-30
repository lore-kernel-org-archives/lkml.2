Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757665Ab2K3LHh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 06:07:37 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:56620 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757632Ab2K3LHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 06:07:32 -0500
X-AuditID: cbfee61b-b7f616d00000319b-35-50b8937287e2
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Jassi Brar <jassisinghbrar@gmail.com>
Subject: Re: [PATCH 1/4] DMA: PL330: fix locking in pl330_free_chan_resources()
Date: Fri, 30 Nov 2012 11:59:30 +0100
User-Agent: KMail/1.13.2 (Linux/3.5.0-rc2+; KDE/4.4.5; i686; ; )
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, vinod.koul@intel.com,
        kgene.kim@samsung.com, rob.herring@calxeda.com, dinguyen@altera.com,
        pawel.moll@arm.com, t.figa@samsung.com, kyungmin.park@samsung.com,
        Vinod Koul <vinod.koul@linux.intel.com>, Dan Williams <djbw@fb.com>
References: <1351504796-24788-1-git-send-email-b.zolnierkie@samsung.com>
 <1351504796-24788-2-git-send-email-b.zolnierkie@samsung.com>
 <CABb+yY3DJ8saXGmXO31nQjtmqObpJxf5-Zwv4YhkJLv6EA=Tfw@mail.gmail.com>
In-reply-to: <CABb+yY3DJ8saXGmXO31nQjtmqObpJxf5-Zwv4YhkJLv6EA=Tfw@mail.gmail.com>
MIME-version: 1.0
Content-type: Text/Plain; charset=us-ascii
Content-transfer-encoding: 7bit
Message-id: <201211301159.31098.b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrALMWRmVeSWpSXmKPExsVy+t9jQd2iyTsCDE6+EbS4vGsOm8WM8/uY
	HJg8Pm+SC2CM4rJJSc3JLEst0rdL4Mp4vWgac8EyxYonb+azNTCul+li5OCQEDCR+PGKq4uR
	E8gUk7hwbz1bFyMXh5DAdEaJo5dfMkI4LUwSs1uvsYJUsQlYSUxsX8UIYosIaEosez2PCcQW
	FvCXuD33HwuIzSKgKrF73iewuKiAg0Tn1AlgU5kFrjBJXGx8yAwx9RyjxKmJC8CmcgoES0x7
	8x/M5hUQlPgx+R7YJGYBLYnmN5sYIWx5ic1r3jJD1FhKrH25iHECo8AsJC2zkLTMQtKygJF5
	FaNoakFyQXFSeq6RXnFibnFpXrpecn7uJkZwOD6T3sG4qsHiEKMAB6MSDy/Dmu0BQqyJZcWV
	uYcYJTiYlUR49wnuCBDiTUmsrEotyo8vKs1JLT7EKM3BoiTO2+yREiAkkJ5YkpqdmlqQWgST
	ZeLglGpglNiqc+xon92tyPuWBVFN55Ys5Ek/cpNjsf7saV/6plp3MjImzc+8eej5z/9WxxQm
	3l26rO5hdUcxT9c+6zOufAeXHQ1tTP67//N03upLe7IrtuRLL1IQOuxU6rMoSyx+l2fCzp35
	+5PzD8zcafzFcMa+7ylPp6fNflHpLxw/de+F5WtO6JzYvluJpTgj0VCLuag4EQDJUKZkQwIA	AA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 29 October 2012 22:48:05 Jassi Brar wrote:
> On Mon, Oct 29, 2012 at 10:59 AM, Bartlomiej Zolnierkiewicz
> <b.zolnierkie@samsung.com> wrote:
> > tasklet_kill() may sleep so call it before taking pch->lock.
> >
> > Fixes following lockup:
> >
> > [  345.470000] BUG: scheduling while atomic: cat/2383/0x00000002
> > [  345.470000] Modules linked in:
> > [  345.470000] [<c0015858>] (unwind_backtrace+0x0/0xfc) from [<c004d980>] (__schedule_bug+0x4c/0x58)
> > [  345.470000] [<c004d980>] (__schedule_bug+0x4c/0x58) from [<c0360b6c>] (__schedule+0x690/0x6e0)
> > [  345.470000] [<c0360b6c>] (__schedule+0x690/0x6e0) from [<c004f2b4>] (sys_sched_yield+0x70/0x78)
> > [  345.470000] [<c004f2b4>] (sys_sched_yield+0x70/0x78) from [<c002acec>] (tasklet_kill+0x34/0x8c)
> > [  345.470000] [<c002acec>] (tasklet_kill+0x34/0x8c) from [<c01da4cc>] (pl330_free_chan_resources+0x24/0x88)
> > [  345.470000] [<c01da4cc>] (pl330_free_chan_resources+0x24/0x88) from [<c01d81f4>] (dma_chan_put+0x4c/0x50)
> > [  345.470000] [<c01d81f4>] (dma_chan_put+0x4c/0x50) from [<c01d82c0>] (dma_release_channel+0x28/0x98)
> > [...]
> > [  368.335000] BUG: spinlock lockup suspected on CPU#0, swapper/0/0
> > [  368.340000]  lock: 0xe52aa04c, .magic: dead4ead, .owner: cat/2383, .owner_cpu: 1
> > [  368.350000] [<c0015858>] (unwind_backtrace+0x0/0xfc) from [<c01b3d78>] (do_raw_spin_lock+0x194/0x204)
> > [  368.360000] [<c01b3d78>] (do_raw_spin_lock+0x194/0x204) from [<c0361adc>] (_raw_spin_lock_irqsave+0x20/0x28)
> > [  368.365000] [<c0361adc>] (_raw_spin_lock_irqsave+0x20/0x28) from [<c01da80c>] (pl330_tasklet+0x2c/0x5a8)
> > [  368.375000] [<c01da80c>] (pl330_tasklet+0x2c/0x5a8) from [<c002ac04>] (tasklet_action+0xfc/0x114)
> > [  368.385000] [<c002ac04>] (tasklet_action+0xfc/0x114) from [<c002b204>] (__do_softirq+0xe4/0x19c)
> > [  368.395000] [<c002b204>] (__do_softirq+0xe4/0x19c) from [<c002b398>] (irq_exit+0x98/0x9c)
> > [  368.405000] [<c002b398>] (irq_exit+0x98/0x9c) from [<c0013ebc>] (handle_IPI+0x124/0x16c)
> > [  368.410000] [<c0013ebc>] (handle_IPI+0x124/0x16c) from [<c000857c>] (gic_handle_irq+0x64/0x68)
> > [  368.420000] [<c000857c>] (gic_handle_irq+0x64/0x68) from [<c000e740>] (__irq_svc+0x40/0x70)
> > [  368.430000] Exception stack(0xc04a3f00 to 0xc04a3f48)
> > [  368.435000] 3f00: c04a3f48 00000000 6f9e23e8 00000050 c07492c8 c04a3f48 00000000 c04ccc88
> > [  368.440000] 3f20: 6f9dbac3 00000050 6f9e23e8 00000050 3b9aca00 c04a3f48 c005cfa4 c02946d4
> > [  368.450000] 3f40: 60000013 ffffffff
> > [  368.455000] [<c000e740>] (__irq_svc+0x40/0x70) from [<c02946d4>] (cpuidle_wrap_enter+0x4c/0xa0)
> > [  368.460000] [<c02946d4>] (cpuidle_wrap_enter+0x4c/0xa0) from [<c02940dc>] (cpuidle_enter_state+0x18/0x68)
> > [  368.470000] [<c02940dc>] (cpuidle_enter_state+0x18/0x68) from [<c02948e0>] (cpuidle_idle_call+0xac/0xe0)
> > [  368.480000] [<c02948e0>] (cpuidle_idle_call+0xac/0xe0) from [<c00102f8>] (cpu_idle+0xac/0xf0)
> > [  368.490000] [<c00102f8>] (cpu_idle+0xac/0xf0) from [<c04796a0>] (start_kernel+0x28c/0x294)
> >
> > Cc: Jassi Brar <jassisinghbrar@gmail.com>
> > Cc: Vinod Koul <vinod.koul@linux.intel.com>
> > Cc: Tomasz Figa <t.figa@samsung.com>
> > Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> > ---
> >  drivers/dma/pl330.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
> > index 665668b..db7574b 100644
> > --- a/drivers/dma/pl330.c
> > +++ b/drivers/dma/pl330.c
> > @@ -2459,10 +2459,10 @@ static void pl330_free_chan_resources(struct dma_chan *chan)
> >         struct dma_pl330_chan *pch = to_pchan(chan);
> >         unsigned long flags;
> >
> > -       spin_lock_irqsave(&pch->lock, flags);
> > -
> >         tasklet_kill(&pch->task);
> >
> > +       spin_lock_irqsave(&pch->lock, flags);
> > +
> >         pl330_release_channel(pch->pl330_chid);
> >         pch->pl330_chid = NULL;
> >
> Thanks.
> 
> Acked-by: Jassi Brar <jassisinghbrar@gmail.com>

Vinod/Dan could you please pick this patch for 3.8?  Thanks!

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung Poland R&D Center
