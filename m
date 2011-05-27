Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753685Ab1E0MSn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 08:18:43 -0400
Received: from 64.mail-out.ovh.net ([91.121.185.65]:36763 "HELO
	64.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753466Ab1E0MSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 08:18:41 -0400
Date: Fri, 27 May 2011 14:06:29 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Josh Wu <josh.wu@atmel.com>
Cc: mchehab@redhat.com, g.liakhovetski@gmx.de, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        lars.haring@atmel.com, ryan@bluewatersys.com, arnd@arndb.de
Subject: Re: [PATCH v2] [media] at91: add Atmel Image Sensor Interface
 (ISI) support
Message-ID: <20110527120629.GA3603@game.jcrosoft.org>
References: <1306496329-14535-1-git-send-email-josh.wu@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306496329-14535-1-git-send-email-josh.wu@atmel.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 10852830677664115471
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +/* ISI interrupt service routine */
> +static irqreturn_t isi_interrupt(int irq, void *dev_id)
> +{
> +	struct atmel_isi *isi = dev_id;
> +	u32 status, mask, pending;
> +	irqreturn_t ret = IRQ_NONE;
> +
> +	spin_lock(&isi->lock);
> +
> +	status = isi_readl(isi, ISI_STATUS);
> +	mask = isi_readl(isi, ISI_INTMASK);
> +	pending = status & mask;
> +
> +	if (pending & ISI_CTRL_SRST) {
> +		complete(&isi->isi_complete);
> +		isi_writel(isi, ISI_INTDIS, ISI_CTRL_SRST);
> +		ret = IRQ_HANDLED;
> +	}
> +	if (pending & ISI_CTRL_DIS) {
> +		complete(&isi->isi_complete);
> +		isi_writel(isi, ISI_INTDIS, ISI_CTRL_DIS);
> +		ret = IRQ_HANDLED;
> +	}
no else here?
> +
> +	if (pending & ISI_SR_VSYNC) {
> +		switch (isi->state) {
> +		case ISI_STATE_IDLE:
> +			isi->state = ISI_STATE_READY;
> +			wake_up_interruptible(&isi->capture_wq);
> +			break;
> +		}
really switch here?
> +	} else if (likely(pending & ISI_SR_CXFR_DONE)) {
> +		ret = atmel_isi_handle_streaming(isi);
> +	}
> +
> +	spin_unlock(&isi->lock);
> +
> +	return ret;
> +}
> +
> +#define	WAIT_ISI_RESET		1
> +#define	WAIT_ISI_DISABLE	0
> +static int atmel_isi_wait_status(int wait_reset, struct atmel_isi *isi)
I thinkhave teh atmel_isti first parameter is better
> +{
> +	unsigned long timeout;
> +	/*
> +	 * The reset or disable will only succeed if we have a
> +	 * pixel clock from the camera.
> +	 */
> +	init_completion(&isi->isi_complete);
> +
> +	if (wait_reset) {
> +		isi_writel(isi, ISI_INTEN, ISI_CTRL_SRST);
> +		isi_writel(isi, ISI_CTRL, ISI_CTRL_SRST);
> +	} else {
> +		isi_writel(isi, ISI_INTEN, ISI_CTRL_DIS);
> +		isi_writel(isi, ISI_CTRL, ISI_CTRL_DIS);
> +	}
> +
> +	timeout = wait_for_completion_timeout(&isi->isi_complete,
> +			msecs_to_jiffies(100));
> +	if (timeout == 0)
> +		return -ETIMEDOUT;
> +
> +	return 0;
> +}
> +
> +/* ------------------------------------------------------------------
> +	Videobuf operations
> +   ------------------------------------------------------------------*/
> +static int queue_setup(struct vb2_queue *vq, unsigned int *nbuffers,
> +				unsigned int *nplanes, unsigned long sizes[],
> +				void *alloc_ctxs[])
> +{
> +	struct soc_camera_device *icd = soc_camera_from_vb2q(vq);
> +	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
> +	struct atmel_isi *isi = ici->priv;
> +	unsigned long size;
> +	int ret, bytes_per_line;
> +
> +	/* Reset ISI */
> +	ret = atmel_isi_wait_status(WAIT_ISI_RESET, isi);
> +	if (ret < 0) {
> +		dev_err(icd->dev.parent, "Reset ISI timed out\n");
> +		return ret;
> +	}
> +	/* Disable all interrupts */
> +	isi_writel(isi, ISI_INTDIS, ~0UL);
> +
> +	bytes_per_line = soc_mbus_bytes_per_line(icd->user_width,
> +						icd->current_fmt->host_fmt);
> +
> +	if (bytes_per_line < 0)
> +		return bytes_per_line;
> +
> +	size = bytes_per_line * icd->user_height;
> +
> +	if (*nbuffers == 0)
> +		*nbuffers = MAX_BUFFER_NUMS;
> +	if (*nbuffers > MAX_BUFFER_NUMS)
else here
> +		*nbuffers = MAX_BUFFER_NUMS;
> +
> +	if (size * *nbuffers > VID_LIMIT_BYTES)
> +		*nbuffers = VID_LIMIT_BYTES / size;
> +
> +	*nplanes = 1;
> +	sizes[0] = size;
> +	alloc_ctxs[0] = isi->alloc_ctx;
> +
> +	isi->sequence = 0;
> +	isi->active = NULL;
> +
> +	dev_dbg(icd->dev.parent, "%s, count=%d, size=%ld\n", __func__,
> +		*nbuffers, size);
> +
> +	return 0;
> +}
> +
> +static int buffer_init(struct vb2_buffer *vb)
> +{
> +	struct frame_buffer *buf = container_of(vb, struct frame_buffer, vb);
> +
> +	buf->p_fb_desc = NULL;
> +	buf->fb_desc_phys = 0;
memset 0?
> +	INIT_LIST_HEAD(&buf->list);
> +
> +	return 0;
> +}
> +
otherwise the patch look good
if you fix the upper issue
Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>

Best Regards,
J.
