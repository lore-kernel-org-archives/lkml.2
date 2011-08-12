Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751546Ab1HLIE3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 04:04:29 -0400
Received: from mx1.fusionio.com ([66.114.96.30]:45979 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750792Ab1HLIE0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 04:04:26 -0400
X-ASG-Debug-ID: 1313136264-03d6a510a82a68a0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4E44DE84.2030306@fusionio.com>
Date: Fri, 12 Aug 2011 10:04:20 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: "Asai Thambi Samymuthu Pattrayasamy (asamymuthupa) [CONTRACTOR]" 
	<asamymuthupa@micron.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Jeff Moyer <jmoyer@redhat.com>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeff Garzik <jgarzik@pobox.com>, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 1/3] drivers/block/mtip32xx: Adding header file and
  source for pci and block related operation
References: <22A973199D2C2F46933448F6E7990A3002C80025@ntxboimbx31.micron.com>
X-ASG-Orig-Subj: Re: [PATCH v3 1/3] drivers/block/mtip32xx: Adding header file and
  source for pci and block related operation
In-Reply-To: <22A973199D2C2F46933448F6E7990A3002C80025@ntxboimbx31.micron.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1313136264
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.71532
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-08-11 20:52, Asai Thambi Samymuthu Pattrayasamy (asamymuthupa) [CONTRACTOR] wrote:
> +#ifndef WIN_SMART
> + #define WIN_SMART       0xB0
> +#endif

We have defines for this, just use those.

> +#ifndef TRUE
> + #define TRUE 1
> +#endif
> +
> +#ifndef FALSE
> + #define FALSE 0
> +#endif

Get rid of any TRUE/FALSE, just use true/false.

> + * Use a tasklet for bottom half IRQ processing.
> + *
> + * Set to 1 to use a tasklet for bottom half IRQ processing.
> + */
> +#define MTIP_USE_TASKLET       1

As Christoph said, either get rid of this one or make it an option. My
advise would be to kill it completely. It's one of those design
decisions that you have to make, not a potential customer/user.

> +/* Macro to extract the tag bit number from a tag value. */
> +#define MTIP_TAG_BIT(tag)      (tag & 0x1f)
> +
> +/*
> + * Macro to extract the tag index from a tag value. The index
> + * is used to access the correct s_active/Command Issue register based
> + * on the tag value.
> + */
> +#define MTIP_TAG_INDEX(tag)    (tag >> 5)

You have these, but don't seem to use them consistently.

> +/* Forced Unit Access Bit */
> +#define FUA_BIT                        0x80

Ditto WIN_SMART.

> +       /*
> +        * Semaphore used to lock out read/write commands during the
> +        * execution of an internal command.
> +        */
> +       struct rw_semaphore internal_sem;

I hope you are not using that in a hot path...

> +/*
> + * BIO completion function.
> + *
> + * @bio    Pointer to the BIO that has completed.
> + * @status Completion status, 0 = success, non-zero = error.
> + *
> + * return value
> + *     0
> + */
> +static int mtip_complete_bio(struct bio *bio, int status)
> +{
> +       bio_endio(bio, status);
> +       return 0;
> +}

Why wrap this?

> +int mtip_block_initialize(struct driver_data *dd)
> +{
> +       int rv = 0;
> +       sector_t capacity;
> +       unsigned int index = 0;
> +       struct kobject *kobj;
> +
> +       /* Initialize the protocol layer. */
> +       rv = mtip_hw_init(dd);
> +       if (rv < 0) {
> +               dev_err(&dd->pdev->dev,
> +                       "Protocol layer initialization failed\n");
> +               rv = -EINVAL;
> +               goto protocol_init_error;
> +       }
> +
> +       /* Allocate the request queue. */
> +       dd->queue = blk_alloc_queue(GFP_KERNEL);

It'd be nice for a high perf device like this to allocate the queue node
local.

> +       /* Set device limits. */
> +       set_bit(QUEUE_FLAG_NOMERGES, &dd->queue->queue_flags);

This wont matter, if you are using ->make_request_fn entry.

-- 
Jens Axboe

