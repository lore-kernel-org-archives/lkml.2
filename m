Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751409Ab0ENOic (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 10:38:32 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:33809 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748Ab0ENOia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 10:38:30 -0400
From: Sebastien Jan <s-jan@ti.com>
Organization: Texas Instruments
To: Carlos Chinea <carlos.chinea@nokia.com>
Subject: Re: [RFC PATCHv2 2/7] OMAP SSI: Introducing OMAP SSI driver
Date: Fri, 14 May 2010 16:41:59 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-20-generic; KDE/4.3.2; i686; ; )
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
References: <1273245517-30712-1-git-send-email-carlos.chinea@nokia.com> <1273245517-30712-3-git-send-email-carlos.chinea@nokia.com>
In-Reply-To: <1273245517-30712-3-git-send-email-carlos.chinea@nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005141641.59244.s-jan@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Carlos,

Please see my comments inlined.

On Friday 07 May 2010 17:18:32 Carlos Chinea wrote:
[strip]
> diff --git a/drivers/hsi/controllers/omap_ssi.c
[strip]
> +
> +/**
> + * struct omap_ssm_ctx - OMAP synchronous serial module (TX/RX) context
> + * @mode: Bit transmission mode
> + * @channels: Number of channels
> + * @framesize: Frame size in bits
> + * @timeout: RX frame timeout
> + * @divisot: TX divider

Typo: s/divisot/divisor

> + * @arb_mode: Arbitration mode for TX frame (Round robin, priority)
> + */
> +struct omap_ssm_ctx {
> +       u32     mode;
> +       u32     channels;
> +       u32     frame_size;
> +       union   {
> +                       u32     timeout; /* Rx Only */
> +                       struct  {
> +                                       u32     arb_mode;
> +                                       u32     divisor;
> +                       }; /* Tx only */
> +       };
> +};
> +
> +/**
> + * struct omap_ssi_port - OMAP SSI port data
> + * @dev: device associated to the port (HSI port)
> + * @sst_dma: SSI transmitter physical base address
> + * @ssr_dma: SSI receiver physical base address
> + * @sst_base: SSI transmitter base address
> + * @ssr_base: SSI receiver base address

wk_lock description is missing here

> + * @lock: Spin lock to serialize access to the SSI port
> + * @channels: Current number of channels configured (1,2,4 or 8)
> + * @txqueue: TX message queues
> + * @rxqueue: RX message queues
> + * @brkqueue: Queue of incoming HWBREAK requests (FRAME mode)
> + * @irq: IRQ number
> + * @wake_irq: IRQ number for incoming wake line (-1 if none)
> + * @pio_tasklet: Bottom half for PIO transfers and events
> + * @wake_tasklet: Bottom half for incoming wake events
> + * @wkin_cken: Keep track of clock references due to the incoming wake
>  line
>  + * @wake_refcount: Reference count for output wake line
 
s/wake_refcount/wk_refcount

> + * @sys_mpu_enable: Context for the interrupt enable register for irq 0
> + * @sst: Context for the synchronous serial transmitter
> + * @ssr: Context for the synchronous serial receiver
> + */
> +struct omap_ssi_port {
> +       struct device           *dev;
> +       dma_addr_t              sst_dma;
> +       dma_addr_t              ssr_dma;
> +       unsigned long           sst_base;
> +       unsigned long           ssr_base;
> +       spinlock_t              wk_lock;
> +       spinlock_t              lock;
> +       unsigned int            channels;
> +       struct list_head        txqueue[SSI_MAX_CHANNELS];
> +       struct list_head        rxqueue[SSI_MAX_CHANNELS];
> +       struct list_head        brkqueue;
> +       unsigned int            irq;
> +       int                     wake_irq;
> +       struct tasklet_struct   pio_tasklet;
> +       struct tasklet_struct   wake_tasklet;
> +       unsigned int            wkin_cken:1; /* Workaround */
> +       int                     wk_refcount;
> +       /* OMAP SSI port context */
> +       u32                     sys_mpu_enable; /* We use only one irq */
> +       struct omap_ssm_ctx     sst;
> +       struct omap_ssm_ctx     ssr;
> +};
> +

[strip]

> +
> +static void ssi_pio_complete(struct hsi_port *port, struct list_head
>  *queue) +{
> +       struct hsi_controller *ssi =
>  to_hsi_controller(port->device.parent); +       struct omap_ssi_controller
>  *omap_ssi = hsi_controller_drvdata(ssi); +       struct omap_ssi_port
>  *omap_port = hsi_port_drvdata(port);
> +       struct hsi_msg *msg;
> +       u32 *buf;
> +       u32 val;
> +
> +       spin_lock(&omap_port->lock);
> +       msg = list_first_entry(queue, struct hsi_msg, link);
> +       if ((!msg->sgt.nents) || (!msg->sgt.sgl->length)) {
> +               msg->actual_len = 0;
> +               msg->status = HSI_STATUS_PENDING;
> +       }
> +       if (msg->status == HSI_STATUS_PROCEDING) {
> +               buf = sg_virt(msg->sgt.sgl) + msg->actual_len;
> +               if (msg->ttype == HSI_MSG_WRITE)
> +                       __raw_writel(*buf, omap_port->sst_base +
> +                                      
>  SSI_SST_BUFFER_CH_REG(msg->channel)); +                else
> +                       *buf = __raw_readl(omap_port->ssr_base +
> +                                      
>  SSI_SSR_BUFFER_CH_REG(msg->channel)); +              
>  dev_dbg(&port->device, "ch %d ttype %d 0x%08x\n", msg->channel, +         
>                                               msg->ttype, *buf); +         
>       msg->actual_len += sizeof(*buf);
> +               if (msg->actual_len >= msg->sgt.sgl->length)
> +                       msg->status = HSI_STATUS_COMPLETED;
> +               /*
> +                * Wait for the last written frame to be really sent before
> +                * we call the complete callback
> +                */
> +               if ((msg->status == HSI_STATUS_PROCEDING) ||
> +                       ((msg->status == HSI_STATUS_COMPLETED) &&
> +                               (msg->ttype == HSI_MSG_WRITE)))
> +                       goto out;
> +
> +       }
> +       if (msg->status == HSI_STATUS_PROCEDING)
> +               goto out;
> +       /* Transfer completed at this point */
> +       val = __raw_readl(omap_ssi->sys + SSI_MPU_ENABLE_REG(port->num,
>  0)); +       if (msg->ttype == HSI_MSG_WRITE) {
> +               val &= ~SSI_DATAACCEPT(msg->channel);
> +               ssi_clk_disable(ssi); /* Release clocks for write transfer
>  */ +       } else {
> +               val &= ~SSI_DATAAVAILABLE(msg->channel);
> +       }
> +       __raw_writel(val, omap_ssi->sys + SSI_MPU_ENABLE_REG(port->num,
>  0)); +       list_del(&msg->link);
> +       spin_unlock(&omap_port->lock);
> +       msg->complete(msg);
> +       spin_lock(&omap_port->lock);
> +       ssi_start_transfer(queue);
> +out:
> +       spin_unlock(&omap_port->lock);
> +}
> +
> +static void ssi_gdd_complete(struct hsi_controller *ssi, unsigned int lch)
> +{
> +       struct omap_ssi_controller *omap_ssi = hsi_controller_drvdata(ssi);
> +       struct hsi_msg *msg = omap_ssi->gdd_trn[lch].msg;
> +       struct hsi_port *port = to_hsi_port(msg->cl->device.parent);
> +       unsigned int dir;
> +       u32 csr;
> +       u32 val;
> +
> +       spin_lock(&omap_ssi->lock);
> +
> +       val = __raw_readl(omap_ssi->sys + SSI_GDD_MPU_IRQ_ENABLE_REG);
> +       val &= ~SSI_GDD_LCH(lch);
> +       __raw_writel(val, omap_ssi->sys + SSI_GDD_MPU_IRQ_ENABLE_REG);
> +
> +       if (msg->ttype == HSI_MSG_READ) {
> +               dir = DMA_FROM_DEVICE;
> +               val = SSI_DATAAVAILABLE(msg->channel);
> +               ssi_clk_disable(ssi);
> +       } else {
> +               dir = DMA_TO_DEVICE;
> +               val = SSI_DATAACCEPT(msg->channel);
> +               /* Keep clocks reference for write pio event */
> +       }
> +       dma_unmap_sg(&ssi->device, msg->sgt.sgl, msg->sgt.nents, dir);
> +       csr = __raw_readw(omap_ssi->gdd + SSI_GDD_CSR_REG(lch));
> +       omap_ssi->gdd_trn[lch].msg = NULL; /* release GDD lch */
> +       if (csr & SSI_CSR_TOUR) { /* Timeout error */
> +               msg->status = HSI_STATUS_ERROR;
> +               msg->actual_len = 0;
> +               list_del(&msg->link); /* Dequeue msg */
> +               spin_unlock(&omap_ssi->lock);
> +               msg->complete(msg);
> +               return;
> +       }
> +
> +       val |= __raw_readl(omap_ssi->sys + SSI_MPU_ENABLE_REG(port->num,
>  0)); +       __raw_writel(val, omap_ssi->sys +
>  SSI_MPU_ENABLE_REG(port->num, 0)); +
> +       msg->status = HSI_STATUS_COMPLETED;
> +       msg->actual_len = sg_dma_len(msg->sgt.sgl);
> +       spin_unlock(&omap_ssi->lock);
> +}

Don't you need to check the queue related to this transfer at this point, to 
start the potentially next queued transfer on the same channel? (calling 
ssi_start_transfer(), like in ssi_pio_complete()?)

