Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751147Ab1ABJmg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 04:42:36 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:33263 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753727Ab1ABJmd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 04:42:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=lDOqPG/IZdk02escA1I1DfVPEvGlFDBcjl1nuH+8hy8nth36KNQLXhY0uL1nJdtuW0
         4uLS4B6MBfrqVQjrWmxTbAL8U8zGHZPKt4wz076PW2HrP+OcGH+120cJ+7Xq4zaNMYrN
         Y9zFqI7+q1madb33nQwsKts5J9epIFMQ2tHYE=
MIME-Version: 1.0
In-Reply-To: <20101231215018.GB5012@n2100.arm.linux.org.uk>
References: <1276270031-1607-1-git-send-email-linus.walleij@stericsson.com>
	<20101221182037.GA4783@n2100.arm.linux.org.uk>
	<20101222122904.GC14693@n2100.arm.linux.org.uk>
	<AANLkTikpyAggDCPef1pS=_QHnu9-FyLcpddGyVHnGwWx@mail.gmail.com>
	<20101223001012.GF29368@n2100.arm.linux.org.uk>
	<AANLkTimirgsuoM2che_ocrkvCZqGu6xEJjrjdmt9-69p@mail.gmail.com>
	<AANLkTikP+JZkN7AjqaNfHY8jZ7bVsV-af=YR=MTdfnNU@mail.gmail.com>
	<20101231215018.GB5012@n2100.arm.linux.org.uk>
Date: Sun, 2 Jan 2011 01:42:31 -0800
X-Google-Sender-Auth: qhUWw05IUomW9wO-N5OXqZ1ToJc
Message-ID: <AANLkTim08yVM2NceT-8tukJNNNG3WUdjPs-7MD9QBV-u@mail.gmail.com>
Subject: Re: [PATCH 06/13] DMAENGINE: driver for the ARM PL080/PL081 PrimeCells
From: Dan Williams <dan.j.williams@intel.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Viresh Kumar <viresh.kumar@st.com>, Kukjin Kim <kgene.kim@samsung.com>,
        yuanyabin1978@sina.com, linux-kernel@vger.kernel.org,
        Ben Dooks <ben-linux@fluff.org>, Peter Pearse <peter.pearse@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Alessandro Rubini <rubini@unipv.it>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 31, 2010 at 1:50 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Wed, Dec 22, 2010 at 05:31:25PM -0800, Dan Williams wrote:
>> On Wed, Dec 22, 2010 at 5:11 PM, Dan Williams <dan.j.williams@intel.com> wrote:
>> > Drivers that do not
>> > want to meet the constraints expected by the opportunistic offload
>> > clients should do what ste_dma40 does and add "depends on !(NET_DMA ||
>> > ASYNC_TX_DMA)"
>>
>> Sorry I was looking at a local change it does not do this today, but I
>> recommended it to workaround the broken >64k transfer support that was
>> reported recently.
>
> Dan,
>
> Is there any documentation on the DMA engine APIs than what's in
> crypto/async-tx-api.txt?

No, the dma slave usage model is undocumented, and the generic offload
case needs updating.  I will write up the results of this thread in
Documentation/dmaengine.txt.

> Reason for asking is that there's no way at the moment to tell what the
> expectations are from a lot of the DMA engine support code - and that is
> _very_ bad news if you want DMA engine drivers to behave the same.

For the generic offload usage case dma drivers need to present
consistent behaviour because they are reused generically.

The slave usages are not generic.  They grew up around wanting to
reuse dmaengine's channel allocation boilerplate, while maintaining
architecture-specific (dma driver / slave driver pairing) behaviour.
Certainly the ->device_prep* methods can be made to present a
consistent/documented interface.  The ->device_control() method, on
the other hand, defines a common interface to pass control messages,
but the semantics are implementation specific (slave drivers take
liberties with the knowledge that they will only ever talk to a given
dma driver/channel).

> I can already see that drivers on both sides of the DMA engine API have
> different expectations between their respective implementations, and this
> is just adding to confusion.
>
> For instance, the sequence in a driver:
>
>        desc = dmadev->device_prep_slave_sg(chan, ...);
>        if (!desc)
>                /* what DMA engine cleanup is expected here? */

None, if prep fails then no descriptor was allocated and no cleanup
should be required.

>
>        cookie = dmaengine_submit(desc);
>        if (dma_submit_error(cookie))
>                /* what DMA engine cleanup of desc is expected here? */

dma_submit_error() is something I should have removed after commit
a0587bcf "ioat1: move descriptor allocation from submit to prep" all
errors should be notified by prep failing to return a descriptor
handle.  Negative dma_cookie_t values are only returned by the
dma_async_memcpy* calls which translate a prep failure into -ENOMEM.

> Note: I don't trust what's written in 3.3 of async-tx-api.txt, because
> that seems to be talking about the the async_* APIs rather than the
> DMA engine API. (see below.)
>
> 1. Is it valid to call dmaengine_terminate_all(chan) in those paths?
>
> 2. What is the expectations wrt the callback of a previously submitted
>   job at the point that dmaengine_terminate_all() returns?
>
> 3. What if the callback is running on a different CPU, waiting for a
>   spinlock you're holding at the time you call dmaengine_terminate_all()
>   within that very same spinlock?
>
> 4. What if dmaengine_terminate_all() is running, but parallel with it
>   the tasklet runs on a different CPU, and queues another DMA job?
>
> These can all be solved by requiring that the termination implementations
> call tasklet_disable(), then clean up the DMA state, followed by
> tasklet_enable().  tasklet_disable() will prevent the tasklet being
> scheduled, and wait for the tasklet to finish running before proceeding.
> This means that (2) becomes "the tasklet will not be running", (3)
> becomes illegal (due to deadlock), and (4) becomes predictable as we
> know that after tasklet_disable() we have consistent DMA engine state
> and we can terminate everything that's been queued.
>

This assumes that all submission and completion occurs in tasklet
context?  I think something is wrong if the terminate_all
implementation is not taking the channel spinlock or otherwise
guaranteeing that it is not racing against new submissions and the
completion tasklet.

> That still leaves the issue of (1), and also what cleanup is expected.

A single thread must not call any other dmaengine methods between prep
and submit.  Some drivers lock in prep and unlock in submit as they
need to ensure in-order submission.  The only reason they are separate
calls is to preclude needing to specify callback information to every
prep call as some usages will never need it.

Now for the case of ->prep() on cpu0 with an intervening call to
terminate_all on cpu1 before the submit.  I would say that the
terminate_all operation should ignore the yet-to-be-submitted
descriptor, i.e. terminate_all stops all submitted operations.

> I'm not entirely clear about the usage of DMA_CTRL_ACK:
>  * @DMA_CTRL_ACK - if clear, the descriptor cannot be reused until the client
>  *  acknowledges receipt, i.e. has has a chance to establish any dependency
>  *  chains
>
> Some DMA engine using drivers set DMA_CTRL_ACK, others don't.
>

Proper handling of that flag is only required by drivers that select
ASYNC_TX_ENABLE_CHANNEL_SWITCH.  These are raid offload drivers where
the memory copy operation is implemented on a separate channel from
the xor operation.  The flag allows cross channel dependency chains to
be established.  In the slave case they are a no-op because we are
only ever performing one operation type, and a single client is never
using more than one channel at a time.

> Should drivers using prep_slave_sg() be requesting their descriptors
> with DMA_CTRL_ACK in the flags argument?  Doesn't that mean that the
> DMA engine driver is free to re-use this descriptor beneath the driver?

I asked Linus a similar question [1] wrt the lifetime rules of when
the transaction status could be retrieved, but we did not reach a
conclusion.

> Almost no one checks the result of dmaengine_submit() (or its open-coded
> equivalent).  Are all such drivers potentially leaking descriptors?  If
> not, how are the failed descriptors re-used?

As per above, submit must fail if prep succeeds.

> Also, I think that the DMA engine core code needs to provide some
> essential helper functions to prevent buggy bodgerations such as
> what's happening in amba-pl08x.c, such as:
>
> dma_cookie_t dmaengine_alloc_cookie(struct dma_async_tx_descriptor *tx)
> {
>        struct dma_chan *chan = tx->chan;
>
>        chan->cookie += 1;
>        if (chan->cookie < 0)
>                chan->cookie = 1;
>        return (tx->cookie = chan->cookie);
> }

I should have caught the amba-pl08x excursions... my only concern with
this is specifying the locking which is driver specific.  However,
maybe it would make things cleaner if the core could take a generic
channel lock that was also taken by the drivers.

> What should be the initial value of tx->cookie after a successful
> prep_slave_sg() call?

Drivers are using -EBUSY to indicate descriptor is in the process of
being submitted.

> Also a helper function for dmaengine drivers to call when a descriptor
> is complete to handle all the tx descriptor cleanup on completion, so
> that all dmaengine drivers don't have to re-implement the cleanup in
> their own ways, each with differing behaviour.  (Can the TX desciptor
> structure be expanded to hold all the information needed so that core
> code can implement the DMA unmapping for the asynctx stuff there?)

Currently it is driver specific because the dma mapped addresses are
only saved in the physical descriptors.  But looking at it now this is
really an implementation wart carried forward from when there was a
device_prep call for every source / destination address type
permutation (single vs page).  If all clients were required to keep a
scatterlist around for the duration of the transaction that would
eliminate the need to recover dma addresses from the physical
descriptors.  (It probably is also the only way to solve the "dma_map
twice" problem you point out later in this thread.)

> I think that's enough to think about for the time being - I'm sure
> there's lots more...

Now that this upstart dma-slave usage model has grown to overtake the
original generic offload usage model we definitely need defined
semantics and a clear line drawn between the two usages.

--
Dan

[1]: http://marc.info/?l=linux-arm-kernel&m=126947350019600&w=2
