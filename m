Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758120Ab2IEDkd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 23:40:33 -0400
Received: from gate.crashing.org ([63.228.1.57]:34130 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752016Ab2IEDkb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 23:40:31 -0400
Message-ID: <1346816407.2257.37.camel@pasglop>
Subject: Re: [PATCH V3 1/3] drivers/char/tpm: Add new device driver to
 support IBM vTPM
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Kent Yoder <key@linux.vnet.ibm.com>
Cc: Ashley Lai <adlai@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        tpmdd-devel@lists.sourceforge.net, linuxppc-dev@lists.ozlabs.org,
        rcj@linux.vnet.ibm.com, adlai@us.ibm.com
Date: Wed, 05 Sep 2012 13:40:07 +1000
In-Reply-To: <20120822214217.GB13519@linux.vnet.ibm.com>
References: <1344987282.4430.26.camel@footlong>
	 <1345670263.25124.7.camel@footlong>
	 <20120822214217.GB13519@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-08-22 at 16:42 -0500, Kent Yoder wrote:
> On Wed, Aug 22, 2012 at 04:17:43PM -0500, Ashley Lai wrote:
> > This patch adds a new device driver to support IBM virtual TPM
> > (vTPM) for PPC64.  IBM vTPM is supported through the adjunct
> > partition with firmware release 740 or higher.  With vTPM
> > support, each lpar is able to have its own vTPM without the
> > physical TPM hardware.
> > 
> > This driver provides TPM functionalities by communicating with
> > the vTPM adjunct partition through Hypervisor calls (Hcalls)
> > and Command/Response Queue (CRQ) commands.
> 
>  Thanks Ashley, I'll include this in my next pull request to James.

Oh ? I was about to put it in the powerpc tree ... But yeah, I notice
there's a change to tpm.h so it probably should be at least acked by the
TPM folks. As for the subsequent patches, they are powerpc specific so I
can add them, I don't think there's a strict dependency, is there ?

Now, while having a look at the driver, I found a few things that I'm
not sure I'm happy with:

Mainly:

> > + */
> > +static int tpm_ibmvtpm_recv(struct tpm_chip *chip, u8 *buf, size_t count)
> > +{
> > +	struct ibmvtpm_dev *ibmvtpm;
> > +	u16 len;
> > +
> > +	ibmvtpm = (struct ibmvtpm_dev *)chip->vendor.data;
> > +
> > +	if (!ibmvtpm->rtce_buf) {
> > +		dev_err(ibmvtpm->dev, "ibmvtpm device is not ready\n");
> > +		return 0;
> > +	}
> > +
> > +	wait_event_interruptible(wq, ibmvtpm->crq_res.len != 0);
> > +
> > +	if (count < ibmvtpm->crq_res.len) {

That doesn't look right. The "other side" as far as I can tell is:

> > +		case VTPM_TPM_COMMAND_RES:
> > +			ibmvtpm->crq_res.valid = crq->valid;
> > +			ibmvtpm->crq_res.msg = crq->msg;
> > +			ibmvtpm->crq_res.len = crq->len;
> > +			ibmvtpm->crq_res.data = crq->data;
> > +			wake_up_interruptible(&wq);

That looks racy to me. At the very least it should be doing:

			ibmvtpm->crq_res.data = crq->data;
			smp_wmb();
			ibmvtpm->crq_res.len = crq->len;

IE. Ensure that "len" is written last, and possibly have an
corresponding smp_rmb() after wait_event_interruptible() in the receive
case.

Also, I dislike having a global symbol called "wq". You also don't seem
to have any synchronization on access to that wq, can't you end up with
several clients trying to send messages & wait for responses getting all
mixed up ? You might need to make sure that at least you do a
wake_up_interruptible_all() to ensure you wake them all up (inefficient
but works). Unless you can track per-client ?

Or is the above TPM layer making sure only one command/response happens
at a given point in time ?

You also do an interruptible wait but don't seem to be checking for
signals (and not testing the result from wait_event_interruptible which
might be returning -ERESTARTSYS in this case).

That all sound a bit wrong to me ...
> > +static irqreturn_t ibmvtpm_interrupt(int irq, void *vtpm_instance)
> > +{
> > +	struct ibmvtpm_dev *ibmvtpm = (struct ibmvtpm_dev *) vtpm_instance;
> > +	unsigned long flags;
> > +
> > +	spin_lock_irqsave(&ibmvtpm->lock, flags);
> > +	vio_disable_interrupts(ibmvtpm->vdev);
> > +	tasklet_schedule(&ibmvtpm->tasklet);
> > +	spin_unlock_irqrestore(&ibmvtpm->lock, flags);
> > +
> > +	return IRQ_HANDLED;
> > +}

Tasklets ? We still use those things ? That's softirq iirc, do you
really need to offload ? I mean, it allows to limit the amount of time
an interrupt is disabled, but that's only useful if you assume you'll
have quite a lot of traffic here, is that the case ?

You might be actually increasing latency here in favor of throughput, is
that what you are aiming for ? Also keep in mind that
vio_disable/enable_interrupt() being an hcall, it can have significant
overhead. So again, only worth it if you're going to process a bulk of
data at a time.

Cheers,
Ben.


