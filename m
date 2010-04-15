Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757600Ab0DOJOO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 05:14:14 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:34244 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755635Ab0DOJOM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 05:14:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=R1QOWrp27BPE5RFaIBAw6GEIPnEpBIKXVooJGgrgMcxI2z+r0NwyZb1X/NQp13w8B9
         fEMgYXAeLM1+4r44kMgIfsplw58Bff5hNeRKO/Z5fFviNZjyGIHeKZaWuFhlCvmJKRkw
         6O3ofvTAiFR1VHJmpaA5d1Vg/XIR27VZki9YM=
MIME-Version: 1.0
In-Reply-To: <i2ge9c3a7c21004141708y87d01ab6h94c653e4efa11b8d@mail.gmail.com>
References: <x2i121039231004132342sa230bfd4k832950fce534113f@mail.gmail.com>
	 <i2ge9c3a7c21004141708y87d01ab6h94c653e4efa11b8d@mail.gmail.com>
Date: Thu, 15 Apr 2010 14:43:59 +0530
Message-ID: <j2i121039231004150213i76ecc96ahb5d9af96c46b27ae@mail.gmail.com>
Subject: Re: DMA Engine API performance issues
From: melwyn lobo <linux.melwyn@gmail.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks so much for your explanation.
OK..Looking at IPU implementation, irq handling is enrtirely in the
interrupt routine, therefore no need for spin_lock_bh stuff.
But for lower interrupt latency reasons we need to stick with the
tasklet handling for processing interrupts.

We were contemplating another solution for locking at our end for DMA
implementation
For locking
if(irqs_disabled())
    spin_lock(&chan->lock);
else
    spin_lock_bh(&chan->lock);

for unlocking:
if(irqs_disabled())
    spin_unlock(&chan->lock);
else
    spin_unlock_bh(&chan->lock);

Although this works  fine, but will this be OK when we submit the driver.

Regards,
M

On Thu, Apr 15, 2010 at 5:38 AM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Tue, Apr 13, 2010 at 11:42 PM, melwyn lobo <linux.melwyn@gmail.com> wrote:
>> Hello Dan,
>> I have some doubts regarding DMA API usage on its clients for example
>> MMC, ALSA, USB etc.
>>
>> I am going to take example of the ALSA framework. Audio data transfer
>> is initiated in soc_pcm_trigger(). This is called in an atomic
>> context,
>> with spinlock held and irqs disabled. Here most drivers enable data
>> transfer from the MSP peripheral to the audio codec via tx_submit
>> implementation
>> of the DMA engine driver. This enqueues the transaction in an active
>> list which calls for using spinlocks with bottom half disabled.
>> It is in this function when spin_unlock_bh() is called the kernel
>> detects irq's disabled and generates a warning.
>> So the workaround here for ALSA drivers would be to use tasklet or
>> workqueues to defer calling this in an interruptible context, which
>> would
>> cause performance problems (the same function soc_pcm_trigger is
>> called for stoppping the transfer) in cases where the stream has to be
>> repeatedly
>> stopped and started.
>>
>> So the core issue is use of spin_unlock_bh in an atomic context.
>> Workaround for removing the warnings would be:
>> 1. Use spin_lock with irqsave and corresponding unlock function which
>> does not generate a warning in a similar situation.
>>  But this could be futile in one case where the tasklet is scheduled
>> from ksoftirqd which could lead to corruption.
>>  Also this means the interrupts would be disabled (on the local cpu)
>> till the function executed which is not something
>>  desirable.
>> 2. Use local_irq_enable() before calling the DMA APIs and disable once
>> done. This is a crude solution and understandably undesirable and
>> dangerous.
>>
>> The DMA Engine framework assumes that the channel interrupt handling
>> is done in a tasklet (dma_run_dependencies), which I believe is the
>> reason for the issue.
>
> dma_run_dependencies() is only needed in the channel switching case
> which really only applies to the raid/mem-to-mem usage model (i.e. xor
> on one channel followed by copy on another).  In the mem-to-io model
> you should not need to perform channel switching.  I suggest following
> what the other mem-to-io drivers (ipu, dw_dmac, coh...) have
> implemented with their locks.
>
> In general the dmaengine api is meant to provide 1/ a method for
> matching dma consumers with capable dma devices 2/ a platform agnostic
> api for issuing mem-to-mem and simple mem-to-io (slave) dma.  If the
> current framework provides everything you need, then by all means use
> it, but you may find there are architecture specific concerns that
> cannot be supported under the existing mem-to-io model.  In other
> words the dmaengine abstraction stops being useful and gets in the way
> when there are specific architecture considerations beyond simple
> channel to slave-device associations.  For example, dw_dmac and ipu
> are successfully using the dma-slave interface while the PXA folks are
> sticking with their local dma api.
>
> So use it if it simplifies your development more than it complicates it.
>
> --
> Dan
>
