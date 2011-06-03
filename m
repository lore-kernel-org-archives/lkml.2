Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169Ab1FCIxB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 04:53:01 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:62560 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311Ab1FCIw7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 04:52:59 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH v2] [media] at91: add Atmel Image Sensor Interface (ISI) support
Date: Fri, 3 Jun 2011 16:52:38 +0800
Message-ID: <4C79549CB6F772498162A641D92D532801DAC995@penmb01.corp.atmel.com>
In-Reply-To: <20110527120629.GA3603@game.jcrosoft.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH v2] [media] at91: add Atmel Image Sensor Interface (ISI) support
Thread-Index: AcwcaDqpgL6pXfdnQoOBGbgKgdYBqgFYqtBg
References: <1306496329-14535-1-git-send-email-josh.wu@atmel.com> <20110527120629.GA3603@game.jcrosoft.org>
From: "Wu, Josh" <Josh.wu@atmel.com>
To: "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>
Cc: <mchehab@redhat.com>, <g.liakhovetski@gmx.de>,
        <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        "Haring, Lars" <Lars.Haring@atmel.com>, <ryan@bluewatersys.com>,
        <arnd@arndb.de>
X-OriginalArrivalTime: 03 Jun 2011 08:52:44.0121 (UTC) FILETIME=[9A824C90:01CC21CB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Jean-Christophe

Thank you for the review.

Jean-Christophe PLAGNIOL-VILLARD wrote on Friday, May 27, 2011 8:06 PM:

>> +/* ISI interrupt service routine */
>> +static irqreturn_t isi_interrupt(int irq, void *dev_id) {
>> +	struct atmel_isi *isi = dev_id;
>> +	u32 status, mask, pending;
>> +	irqreturn_t ret = IRQ_NONE;
>> +
>> +	spin_lock(&isi->lock);
>> +
>> +	status = isi_readl(isi, ISI_STATUS);
>> +	mask = isi_readl(isi, ISI_INTMASK);
>> +	pending = status & mask;
>> +
>> +	if (pending & ISI_CTRL_SRST) {
>> +		complete(&isi->isi_complete);
>> +		isi_writel(isi, ISI_INTDIS, ISI_CTRL_SRST);
>> +		ret = IRQ_HANDLED;
>> +	}
>> +	if (pending & ISI_CTRL_DIS) {
>> +		complete(&isi->isi_complete);
>> +		isi_writel(isi, ISI_INTDIS, ISI_CTRL_DIS);
>> +		ret = IRQ_HANDLED;
>> +	}

> no else here?

>> +
>> +	if (pending & ISI_SR_VSYNC) {
>> +		switch (isi->state) {
>> +		case ISI_STATE_IDLE:
>> +			isi->state = ISI_STATE_READY;
>> +			wake_up_interruptible(&isi->capture_wq);
>> +			break;
>> +		}

> really switch here?

I will remove the switch here.

I think this part of IRQ handling code need to refine a little bit. The SRST and DIS_DONE is more independent. And other interrupts can compose together.
Following is the latest code, I think is more reasonable.

if (pending & ISI_CTRL_SRST) {
	complete(&isi->complete);
	isi_writel(isi, ISI_INTDIS, ISI_CTRL_SRST);
	ret = IRQ_HANDLED;
} else if (pending & ISI_CTRL_DIS) {
	complete(&isi->complete);
	isi_writel(isi, ISI_INTDIS, ISI_CTRL_DIS);
	ret = IRQ_HANDLED;
} else {
	if ((pending & ISI_SR_VSYNC) &&
			(isi->state == ISI_STATE_IDLE)) {
		isi->state = ISI_STATE_READY;
		wake_up_interruptible(&isi->vsync_wq);
		ret = IRQ_HANDLED;
	}
	if (likely(pending & ISI_SR_CXFR_DONE))
		ret = atmel_isi_handle_streaming(isi);
}

>> +	} else if (likely(pending & ISI_SR_CXFR_DONE)) {
>> +		ret = atmel_isi_handle_streaming(isi);
>> +	}
>> +
>> +	spin_unlock(&isi->lock);
>> +
>> +	return ret;
>> +}
>> +
>> +#define	WAIT_ISI_RESET		1
>> +#define	WAIT_ISI_DISABLE	0
>> +static int atmel_isi_wait_status(int wait_reset, struct atmel_isi 
>> +*isi)

>I thinkhave teh atmel_isti first parameter is better

I will fix it.

>> +{
>> +	unsigned long timeout;
>> +	/*
>> +	 * The reset or disable will only succeed if we have a
>> +	 * pixel clock from the camera.
>> +	 */
>> +	init_completion(&isi->isi_complete);
>> +
>> +	if (wait_reset) {
>> +		isi_writel(isi, ISI_INTEN, ISI_CTRL_SRST);
>> +		isi_writel(isi, ISI_CTRL, ISI_CTRL_SRST);
>> +	} else {
>> +		isi_writel(isi, ISI_INTEN, ISI_CTRL_DIS);
>> +		isi_writel(isi, ISI_CTRL, ISI_CTRL_DIS);
>> +	}
>> +
>> +	timeout = wait_for_completion_timeout(&isi->isi_complete,
>> +			msecs_to_jiffies(100));
>> +	if (timeout == 0)
>> +		return -ETIMEDOUT;
>> +
>> +	return 0;
>> +}
>> +
>> +/* ------------------------------------------------------------------
>> +	Videobuf operations
>> +   
>> +------------------------------------------------------------------*/
>> +static int queue_setup(struct vb2_queue *vq, unsigned int *nbuffers,
>> +				unsigned int *nplanes, unsigned long sizes[],
>> +				void *alloc_ctxs[])
>> +{
>> +	struct soc_camera_device *icd = soc_camera_from_vb2q(vq);
>> +	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
>> +	struct atmel_isi *isi = ici->priv;
>> +	unsigned long size;
>> +	int ret, bytes_per_line;
>> +
>> +	/* Reset ISI */
>> +	ret = atmel_isi_wait_status(WAIT_ISI_RESET, isi);
>> +	if (ret < 0) {
>> +		dev_err(icd->dev.parent, "Reset ISI timed out\n");
>> +		return ret;
>> +	}
>> +	/* Disable all interrupts */
>> +	isi_writel(isi, ISI_INTDIS, ~0UL);
>> +
>> +	bytes_per_line = soc_mbus_bytes_per_line(icd->user_width,
>> +						icd->current_fmt->host_fmt);
>> +
>> +	if (bytes_per_line < 0)
>> +		return bytes_per_line;
>> +
>> +	size = bytes_per_line * icd->user_height;
>> +
>> +	if (*nbuffers == 0)
>> +		*nbuffers = MAX_BUFFER_NUMS;
>> +	if (*nbuffers > MAX_BUFFER_NUMS)

> else here

I will add it.

>> +		*nbuffers = MAX_BUFFER_NUMS;
>> +
>> +	if (size * *nbuffers > VID_LIMIT_BYTES)
>> +		*nbuffers = VID_LIMIT_BYTES / size;
>> +
>> +	*nplanes = 1;
>> +	sizes[0] = size;
>> +	alloc_ctxs[0] = isi->alloc_ctx;
>> +
>> +	isi->sequence = 0;
>> +	isi->active = NULL;
>> +
>> +	dev_dbg(icd->dev.parent, "%s, count=%d, size=%ld\n", __func__,
>> +		*nbuffers, size);
>> +
>> +	return 0;
>> +}
>> +
>> +static int buffer_init(struct vb2_buffer *vb) {
>> +	struct frame_buffer *buf = container_of(vb, struct frame_buffer, 
>> +vb);
>> +
>> +	buf->p_fb_desc = NULL;
>> +	buf->fb_desc_phys = 0;

> memset 0?

OK.

>> +	INIT_LIST_HEAD(&buf->list);
>> +
>> +	return 0;
>> +}
>> +

>otherwise the patch look good
>if you fix the upper issue
>Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>

Thank you very much. I will send out version3 soon.

Best Regards,
Josh Wu
