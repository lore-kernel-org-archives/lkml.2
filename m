Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758957Ab0DBBiy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 21:38:54 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:54486 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757653Ab0DBBiu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 21:38:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=STq3dW8MPqSO2VPuxrzdrj0FebtSyY2unDSLguAK4bshsBWXYOEYHlXv5aQofG+W90
         CS3U4nsBxnb3gzM5KPX4vEVpkgUMQrqMN1pzrV3eumwLjyzgLTYv2IERVQjKahKaNr5Y
         zHpTJSs3LUaiReH8cwtOD8XqVd8yeWT6LZr1k=
MIME-Version: 1.0
In-Reply-To: <t2t63386a3d1004011623m43212bb4z4dde424b30e3d184@mail.gmail.com>
References: <4BAAD5BB.7050101@samsung.com>
	 <1b68c6791003242234h106d9530p12b5a046a906227e@mail.gmail.com>
	 <63386a3d1003250130w6f34854ag2ca163799e9b7bed@mail.gmail.com>
	 <1b68c6791003250517y4e2789baoe147e5982c363682@mail.gmail.com>
	 <63386a3d1003250820x3cf81000i9d27e95c755b9ca8@mail.gmail.com>
	 <k2q1b68c6791003312234qe5da41e7oa1a0c7f535dbb179@mail.gmail.com>
	 <t2t63386a3d1004011623m43212bb4z4dde424b30e3d184@mail.gmail.com>
Date: Fri, 2 Apr 2010 10:38:48 +0900
Message-ID: <g2m1b68c6791004011838r2bcde1amd475c225604883e9@mail.gmail.com>
Subject: Re: [PATCH v2] PL330: Add PL330 DMA controller driver
From: jassi brar <jassisinghbrar@gmail.com>
To: Linus Walleij <linus.ml.walleij@gmail.com>
Cc: Joonyoung Shim <jy0922.shim@samsung.com>, dan.j.williams@intel.com,
       kyungmin.park@samsung.com, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Ben Dooks <ben-linux@fluff.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 2, 2010 at 8:23 AM, Linus Walleij
<linus.ml.walleij@gmail.com> wrote:
> Hi Jassi,
> The only advantage of the other driver by Joonyoung is that it is finished and
> ready for integration. If you finalize the DMA devices/engine API and post
> this in time for the next merge window I would easily vote for including this
> one rather than the other one. (Whatever that means for the world.)
> Simply for technical merits.
Thank you. I am working on it full time. This submission was solely as
a preview, the
code needs to be optimized, polished and tested, though I don't anticipate much
changes in the API. By when should I submit the final version?

........

> I understand it that as this is the core engine so you intend to keep the core
> in arch/arm/common/* and then a separate interface to the DMAdevices
> implementing <linux/dmaengine.h> in drivers/dma/ and this is what the
> "DMA API" referenced below refers to?
Yes, drivers/dma/pl330.c could be one DMA API driver.
Another may implement S3C DMA API and reside in arch/arm/plat-samsung/ or
wherever the S3C PL080 driver is atm.
So, DMA API driver is the frontend that makes use of the
arch/arm/common/pl330.c
backend driver.

> In that case I really like this clear separation between hardware driver
> and DMA devices/engine API. And I see that the DMA API is not far
> away. If you implement it you will be able to excersise this with the
> DMA engine memcpy test to assure it's working.
Yes, implementing PL330 core was supposed to be the major challenge.
DMA API drivers should be easy, though I plan to first test the pl330.c with
S3C DMA API because that way I'll have a benchmark to compare the stability
and performance of this new driver.
Of course, I'll like to see driver/dma driver as well, but maybe JoonYoung wants
to implement that part, if he doesn't show interest then I will.

> There is nothing wrong with moving this entire thing except the header
> file into drivers/dma it will be more comfortable there, with the other
> DMA drivers. Whether the header should be in include/linux/amba
> or include/linux/dma is however a good question for the philosophers,
> but I would stick it into linux/amba with the rest of the PrimeCells.
> But perhaps you have better ideas.
For platforms that choose to implement their own DMA API (how good or bad is a
different subject), arch/arm/common/ seems be more appropriate for this pl330.c
And all drivers in drivers/dma/ implement the include/linux/dmaengine.h API

> 2010/4/1 jassi brar <jassisinghbrar@gmail.com>:
>
>> o  The DMA API driver submits 'request' to PL330 engine.
>>     A request is a sequence of DMA 'xfers' to be done before the DMA
>> API driver wants to be notified.
>
> This hints that there is some other patch to provide that API
> <linux/dmaengine.h> that is not part of this patch, right?
Right, and that is what I call Client/DMA-API driver. Though the patch is not
ready yet.

>>     A req can be a scatter-Gather-List.
>
> This is great, do you also plan to support that for M<->M xfers like we
> added for the DMA40? Then we might want to lift that into the generic
> DMA engine.
It should already be working with this driver as such.

>> o  TODO: Desirable is to implement true LLI using MicroCode
>> modification during each
>>    request enqueue, so that the xfer continues even while IRQ is
>> handled and callbacks made.
>>    To me, there doesn't seem to be a way to flush ICACHE of a channel
>> without halting it, so we
>>    can't modify MicroCode in runtime. Using two channels per client
>> to achieve true LLI is the last resort.
>
> True, not as elegant as being able to do it with microcode but
> still quite elegant.
I hope the driver is efficient/fast enough for some tough test cases I have,
otherwise I might have to modify or add to the API to implement this
two-channels per user situation.

>>    So currently, cpu intervention is required to trigger each xfer,
>> hence interrupt latency might play
>>    some role.
>
> From the DMA API level in the PrimeCell drivers the crucial driver that
> need something like this is the AMBA PL011 UART driver, RX part,
> where data comes in from the outside and we have no control over
> the data flow. I trigger one transfer to a buffer here, then wait for it
> to complete or be interrupted. If it completes, I immediately trigger
> another transfer to the second buffer before I start processing the just
> recieved buffer (like front/back buffers).
If I get it right, that is common issue with any 'slave-receiver' type device
and it might do good to have timeout option support in DMA API for such receive
requests. That is provide whatever data is collected within some
amount of time,
provide that to upper layers and queue request again.

>> o  TODO: PAUSE/RESUME support. Currently the DMA API driver has to emulate it.
>
> The only PrimeCell that needs this is currently again the PL011.
> It needs to PAUSE then get the number of pending bytes and then
> terminate the transfer. This is done when we timeout transfers e.g.
> for UART consoles. So being able to pause and retrieve the number
> of bytes left and then cancel is the most advanced sequence that
> will be used by a PrimeCell currently.
Even with this implementation, for PAUSE, the DMA API driver can call
pl330_chan_status, saving remaining requests locally and calling
PL330_OP_ABORT. During RESUME it simply submit remaining requests again.

>> +/* Returns bytes consumed and updates bursts */
>> +static inline int _loop(unsigned dry_run, u8 buf[],
>> +               unsigned long *bursts, const struct _xfer_spec *pxs)
>> +{
>> +       int cyc, cycmax, szlp, szlpend, szbrst, off;
>> +       unsigned lcnt0, lcnt1, ljmp0, ljmp1;
>> +       struct _arg_LPEND lpend;
>> +
>> +       /* Max iterations possibile in DMALP is 256 */
>> +       if (*bursts >= 256*256) {
>> +               lcnt1 = 256;
>> +               lcnt0 = 256;
>> +               cyc = *bursts / lcnt1 / lcnt0;
>> +       } else if (*bursts > 256) {
>> +               lcnt1 = 256;
>> +               lcnt0 = *bursts / lcnt1;
>> +               cyc = 1;
>> +       } else {
>> +               lcnt1 = *bursts;
>> +               lcnt0 = 0;
>> +               cyc = 1;
>> +       }
>> +
>> +       szlp = _emit_LP(1, buf, 0, 0);
>> +       szbrst = _bursts(1, buf, pxs, 1);
>> +
>> +       lpend.cond = ALWAYS;
>> +       lpend.forever = false;
>> +       lpend.loop = 0;
>> +       lpend.bjump = 0;
>> +       szlpend = _emit_LPEND(1, buf, &lpend);
>> +
>> +       if (lcnt0) {
>> +               szlp *= 2;
>> +               szlpend *= 2;
>> +       }
>> +
>> +       /** Do not mess with the construct **/
>
> Which means? Hackers like to mess with stuff... Note to self?
> Usually comments like that is a trace of questionable design
> so if the design is solid, remove the comments because then it
> will be obvious that you don't want to mess with the construct.
That is mostly to self. It just means that every variable in the block
must be analyzed before making any change there.

......

>> +xfer_exit:
>> +       mutex_unlock(&thrd->mtx);
>> +       return ret;
>> +}
>> +EXPORT_SYMBOL(pl330_submit_req);
>
> For all exported symbols: I have a hard time seeing anyone compiling the
> DMA engine driver or anything else using this as a module and making use
> of all these exports. But maybe for testing, what do I know...
I think it is considered good practice to export every symbol of an API.

......

>> +
>> +       /* Check if we can handle this DMAC */
>> +       if (get_id(pl330, PERIPH_ID) != PERIPH_ID_VAL
>> +          || get_id(pl330, PCELL_ID) != PCELL_ID_VAL) {
>> +               printk(KERN_INFO "PERIPH_ID 0x%x, PCELL_ID 0x%x !\n",
>> +                       readl(regs + PERIPH_ID), readl(regs + PCELL_ID));
>
> dev_info(pl330->dev, ...)
>
>> +               return -EINVAL;
>> +       }
>
> If the parent device (IMO a DMAdevices/DMAengine) is an struct amba_device
> I don't think this ID check is necessary, there is already PrimeCell
> matching code in
> <linux/amba/bus.h>
As I said, this driver is designed to be usable with any DMA API, and
some, like S3C,
do not see the DMAC as some amba device.

>> +
>> +       /* Make sure it isn't already added */
>> +       list_for_each_entry(pt, &pl330_list, node)
>> +               if (pt == pl330)
>
> Perhaps print some warning here. Doesn't seem sound that this
> would happen.
The check is there just for some robustness.

......

>> +extern struct pl330_info *pl330_alloc(struct device *);
>> +extern int pl330_add(struct pl330_info *);
>> +extern void pl330_del(struct pl330_info *pi);
>> +extern int pl330_update(struct pl330_info *pi);
>> +extern void pl330_release_channel(void *ch_id);
>> +extern void *pl330_request_channel(struct pl330_info *pi);
>> +extern int pl330_chan_status(void *ch_id, struct pl330_chanstatus *pstatus);
>> +extern int pl330_chan_ctrl(void *ch_id, enum pl330_chan_op op);
>> +extern int pl330_submit_req(void *ch_id, struct pl330_req *r);
>> +extern void pl330_free(struct pl330_info *pi);
>
>
> Do you really need both pairs:
>
> pl330_alloc() + pl330_add() and
> pl330_del() + pl330_free()
yes I was already thinking on similar lines. I'll merge them to one.

As I said, this code was just for preview. It needs to undergo at
least one cycle of
optimizing->polishing->testing before I finally submit for inclusion.
comments, prints, types etc will be modified to match other code in
the directory
it will be aimed to be put in. Of course, I have taken every feedback you gave.

Thanks.
