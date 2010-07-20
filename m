Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932785Ab0GTV0o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 17:26:44 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45789 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932597Ab0GTV0m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 17:26:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=mckNMGIVe9Djvz2t4jZkyUxq2EBXHRd10zUm7c5fFWsT2oZfvvebN/DpsbBvsk8VMQ
         0cxzOFkeMy5wDrb/0eyXZtTaU89DcL+q3NTjKTSSv8LVkAgzdnJl+H7d6OY1l5HMoWJ/
         PyICsuD4ZXP2S2h0vKXA2SeI/c7SMcj+kIWdM=
MIME-Version: 1.0
In-Reply-To: <438BB0150E931F4B9CE701519A44630104A3640CF7@bgsmsx502.gar.corp.intel.com>
References: <1277770577-11024-1-git-send-email-linus.walleij@stericsson.com>
	<AANLkTimYqUZvxaWVvT5FPsW36NTpqLLCqCiSuRAy_ER5@mail.gmail.com>
	<AANLkTinqKHCYeGTLuTtKikcR2IA8TY0vy2tSznxLay0N@mail.gmail.com>
	<AANLkTimHBWMYAeFrET2EpeA8KogcUmQldAHM_uhSv-gt@mail.gmail.com>
	<AANLkTil_2nzwEUS56U48CJpdqkrpnGXAwfcE9bU_Wqhw@mail.gmail.com>
	<AANLkTilAGPmOuS_LjA3TEq1mIcqLxX-T7P-PI-lBTZi0@mail.gmail.com>
	<438BB0150E931F4B9CE701519A44630104A3640CF7@bgsmsx502.gar.corp.intel.com>
Date: Tue, 20 Jul 2010 23:26:40 +0200
Message-ID: <AANLkTilZ14AEPqhwfvPbmvuBOIeSZPlHa1u4DR2GuoEC@mail.gmail.com>
Subject: Re: [PATCH 1/3] DMAENGINE: generic slave channel control
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: "Koul, Vinod" <vinod.koul@intel.com>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alan Cox <alan@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/7/20 Koul, Vinod <vinod.koul@intel.com>:

> /**
>  * struct intel_mid_dma_slave - DMA slave structure
>  *
>  * @dirn: DMA trf direction
>  * @src_width: tx register width
>  * @dst_width: rx register width
>  * @hs_mode: HW/SW handshaking mode
>  * @cfg_mode: DMA data transfer mode (per-per/mem-per/mem-mem)
>  * @src_msize: Source DMA burst size
>  * @dst_msize: Dst DMA burst size
>  * @device_instance: DMA peripheral device instance, we can have multiple
>  *                      peripheral device connected to single DMAC
>  */
> struct intel_mid_dma_slave {
>        enum dma_data_direction         dirn;
>        enum intel_mid_dma_width        src_width; /*width of DMA src txn*/
>        enum intel_mid_dma_width        dst_width; /*width of DMA dst txn*/
>        enum intel_mid_dma_hs_mode      hs_mode;  /*handshaking*/
>        enum intel_mid_dma_mode         cfg_mode; /*mode configuration*/
>        enum intel_mid_dma_msize        src_msize; /*size if src burst*/
>        enum intel_mid_dma_msize        dst_msize; /*size of dst burst*/
>        unsigned int            device_instance; /*0, 1 for peripheral instance*/
> };
>
> Yes the structures have various common things and would be good to abstract
> generic stuff in this and move the rest to private_config.
> But since we are talking about a generic DMA slave capabilities structure, I
> would recommend changing few.
>
> I am not sure why do you want the I/O addr to be passed here, sorry I
> don't follow that logic. If you notice in intel_mid_dma driver the I/O address
> is passed by client driver in prep_memcpy in src and dst fields. Since the slave
> structure tell you the direction and mode you can interpret that src/dst address
> as IO address easily

? Are you using memcpy() to talk to slaves?

I was assuming all slave communication was to use sglists through
the .device_prep_slave_sg() call. This is currently the design constraint,
memcpy() will by design increase both source and destination address
and also always operate on the memory bus.

(If you need reconfiguration also for memcpy() I think will be a
different issue, I'm only looking at slaves now.)

With only the slave interface the dma_chan struct can be deferred
by the DMA engine into a local struct which has this address configured
from the platform, statically.

The runtime configuration API is exactly about being able to reconfigure
even the source/destination address at runtime. This is why
these are on the interface.

> Addr_width and Maxburst: talks about the I/O width and msize I guess, but what
> about mem-width, I have few configuration where we would like to have different
> mem width as well.

OK then we need that for both src and dst.

> And why limit the generic API

Just trying to see how small we can get it, less things can go wrong.

> and what about per-per transfers which
> intel_mid_dma driver would need to support in future.

Yep per2per will definately need that.

> I would recommend renaming this field to src_addr_width
> etc and add dst_addr_xxx
> pair.

OK if Dan agrees I'll make a try.

> Yes I can have them in private_config but then again driver has to do a simple
> check on which one is src/dst in slave and which one is in privae_config. Again
> easily doable but little confusing, I am okay either way

No if you're already foreseeing that they'll be needed, lets put
them in from the beginning...

Yours,
Linus Walleij
