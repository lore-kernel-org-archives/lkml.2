Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754613Ab0GVXPP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 19:15:15 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:39350 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752950Ab0GVXPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 19:15:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=dMnUkjHMhL/m06KMF6jLVEKWqzxaIYJOTPItkZIVSc8cKrmWKZUKlIz5goQ2ItHHA6
         xe/bmL+IjxANG0EebhWZa4hF2vRu55ymNJ2sEEXuzMTM0nJvzuU0BwtR5Zf2S0rqq4Yq
         Wf4E3SBjklHynSj1i5WYZ9pG2kqzT+b4azFSg=
MIME-Version: 1.0
In-Reply-To: <438BB0150E931F4B9CE701519A44630104A3914683@bgsmsx502.gar.corp.intel.com>
References: <1279740148-22186-1-git-send-email-linus.walleij@stericsson.com>
	<AANLkTimmJJcMXxICZHjksp_TjqO_JRx9HwCTJ6UpZQOZ@mail.gmail.com>
	<438BB0150E931F4B9CE701519A44630104A3914683@bgsmsx502.gar.corp.intel.com>
Date: Thu, 22 Jul 2010 16:15:12 -0700
X-Google-Sender-Auth: wnBf9LXFr_6u3Au-ivF9rynOeuc
Message-ID: <AANLkTikazExFqUMc3ibOSRW8a8FoANJ5qUYBpR_rv2-w@mail.gmail.com>
Subject: Re: [PATCH 1/3] DMAENGINE: generic slave channel control v2
From: Dan Williams <dan.j.williams@intel.com>
To: "Koul, Vinod" <vinod.koul@intel.com>
Cc: Linus Walleij <linus.ml.walleij@gmail.com>,
        Alan Cox <alan@linux.intel.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 22, 2010 at 9:13 AM, Koul, Vinod <vinod.koul@intel.com> wrote:
>> 2010/7/22 Linus Walleij <linus.walleij@stericsson.com>:
>>
>> > This adds an interface to the DMAengine to make it possible to
>> > reconfigure a slave channel at runtime. We add a few foreseen
>> > config parameters to the passed struct, with a void * pointer
>> > for custom per-device or per-platform runtime slave data.
>>
>> BTW Vinod, if you're happy with this API, then please ACK it so
>> Dan has some indication whether it'll fit the Moorestown too.
>
> Shouldn't this patch remove the private member in dma_chan structure
>
> Currently chan->private is used for sending slave or similar channel specific
> information. Now if we want to add struct dma_slave_config, then IMHO it
> would make sense to remove private variable and replace with dma_slave_config
> struture. That way we can reuse this struture there as well and if someone wants
> to add more stuff he can use the private_config.
>
> Dan, what do you think about this?

If you take a look at the current usages of chan->private I don't
think all of them are met by this interface.

We have:

struct at_dma_slave {
        struct device           *dma_dev;
        dma_addr_t              tx_reg;
        dma_addr_t              rx_reg;
        enum at_dma_slave_width reg_width;
        u32                     cfg;
        u32                     ctrla;
};

struct dw_dma_slave {
        struct device           *dma_dev;
        dma_addr_t              tx_reg;
        dma_addr_t              rx_reg;
        enum dw_dma_slave_width reg_width;
        u32                     cfg_hi;
        u32                     cfg_lo;
};

struct fsl_dma_slave {

        /* List of hardware address/length pairs */
        struct list_head addresses;

        /* Support for extra controller features */
        unsigned int request_count;
        unsigned int src_loop_size;
        unsigned int dst_loop_size;
        bool external_start;
        bool external_pause;
};

struct dma_pl330_peri {
        /*
         * Peri_Req i/f of the DMAC that is
         * peripheral could be reached from.
         */
        u8 peri_id; /* {0, 31} */
        enum pl330_reqtype rqtype;

        /* For M->D and D->M Channels */
        int burst_sz; /* in power of 2 */
        dma_addr_t fifo_addr;
};

struct sh_dmae_slave {
        unsigned int                    slave_id; /* Set by the platform */
        struct device                   *dma_dev; /* Set by the platform */
        const struct sh_dmae_slave_config       *config;  /* Set by
the driver */
};

struct sh_dmae_slave_config {
        unsigned int                    slave_id;
        dma_addr_t                      addr;
        u32                             chcr;
        char                            mid_rid;
};

struct txx9dmac_slave {
        u64             tx_reg;
        u64             rx_reg;
        unsigned int    reg_width;
};

...and I don't think this interface should try to meet all these
requirements because there will always be arch-specific quirks that
make things fall down.  I think we should just start with an interface
that is minimally useful for the drivers that want to take advantage
of it.  We could, since there is usually driver-specific knowledge
known by the client in the dma-slave case, just require that a
dma_slave_config be container_of() promoted to a driver specific
config.  This lets the non-esoteric platform configurations use the
generic definition.

--
Dan
