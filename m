Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967161Ab0GSWv2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 18:51:28 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:63681 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967151Ab0GSWv0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 18:51:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=xz5X5Ba33jDi3TZDzUf/zTRDPiWSPxM+AFjIvFNph0CQeDj5GmA+ctqVqEa31hTkOL
         Bh2CLX2zJ8jiuDFEe0XDZh3BEgYYpcbNO1B3kHbLXy/a9so5UUgcsAveQjHO24f4sde0
         85SVXp66T2PXx7NwDQs11JaP7EF3prEibi9MA=
MIME-Version: 1.0
In-Reply-To: <AANLkTil_2nzwEUS56U48CJpdqkrpnGXAwfcE9bU_Wqhw@mail.gmail.com>
References: <1277770577-11024-1-git-send-email-linus.walleij@stericsson.com>
	<AANLkTimYqUZvxaWVvT5FPsW36NTpqLLCqCiSuRAy_ER5@mail.gmail.com>
	<AANLkTinqKHCYeGTLuTtKikcR2IA8TY0vy2tSznxLay0N@mail.gmail.com>
	<AANLkTimHBWMYAeFrET2EpeA8KogcUmQldAHM_uhSv-gt@mail.gmail.com>
	<AANLkTil_2nzwEUS56U48CJpdqkrpnGXAwfcE9bU_Wqhw@mail.gmail.com>
Date: Mon, 19 Jul 2010 15:51:23 -0700
X-Google-Sender-Auth: 41F3YJpE_VB8uDtlLTOOCq8g89o
Message-ID: <AANLkTilAGPmOuS_LjA3TEq1mIcqLxX-T7P-PI-lBTZi0@mail.gmail.com>
Subject: Re: [PATCH 1/3] DMAENGINE: generic slave channel control
From: Dan Williams <dan.j.williams@intel.com>
To: Linus Walleij <linus.ml.walleij@gmail.com>
Cc: linux-kernel@vger.kernel.org, vinod.koul@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 19, 2010 at 3:44 PM, Linus Walleij
<linus.ml.walleij@gmail.com> wrote:
> 2010/7/19 Dan Williams <dan.j.williams@intel.com>:
>
>> The recently submitted intel_mid driver [1] seems to have a similar structure:
>
> This is very interesting, let's examine this closely as a comparison!
> I'm looking at it from the point of a generic slave control mechanism,
> though I suspect it is designed to be Intel-specific so keep that in mind.
>
>> +/**
>> + * struct intel_mid_dma_slave - DMA slave structure
>> + *
>> + * @dma_dev: DMA master client
>> + * @tx_reg: physical address of data register used for
>> + *     memory-to-peripheral transfers
>> + * @rx_reg: physical address of data register used for
>> + *     peripheral-to-memory transfers
>> + * @tx_width: tx register width
>> + * @rx_width: rx register width
>> + * @dirn: DMA trf direction
>> + * @cfg_hi: Platform-specific initializer for the CFG_HI register
>> + * @cfg_lo: Platform-specific initializer for the CFG_LO register
>> + * @ tx_width: width of src and dstn
>> + * @ hs_mode: SW or HW handskaking mode
>> + * @ cfg_mode: Mode configuration, DMA mem to mem to dev & mem
>> + */
>> +struct intel_mid_dma_slave {
>> +       enum dma_data_direction         dirn;
>> +       enum intel_mid_dma_width        src_width; /*width of DMA src txn*/
>> +       enum intel_mid_dma_width        dst_width; /*width of DMA dst txn*/
>> +       enum intel_mid_dma_hs_mode      hs_mode;  /*handshaking*/
>> +       enum intel_mid_dma_mode         cfg_mode; /*mode configuration*/
>> +       enum intel_mid_dma_msize        src_msize; /*size if src burst*/
>> +       enum intel_mid_dma_msize        dst_msize; /*size of dst burst*/
>> +       dma_async_tx_callback           callback; /*callback function*/
>> +       void                            *callback_param; /*param for callback*/
>> +       unsigned int            device_instance; /*0, 1 for periphral instance*/
>> +};
>> +
>
> kerneldoc and struct members seem to be out-of-sync but I
> see the general idea.
>
> Of these members handshaking, cfg_mode, hs_mode
> and I suspect also device_instance are candidates for
> the private config  since they cannot be assumed to
> exist on all DMA engines. (Also goes for cfg_[lo|hi] from
> the kerneldoc)
>
> The callback and callback param are configured
> per-transfer in the current API, so I don't see what they
> are doing here at all.

Yeah, I already pointed that out...

>
> Remains: direction, then register address, burstsize and
> word width of the source and destination.
>
> (Register address present in kerneldoc but not in struct,
> burstsize present in struct but not in kerneldoc, whatever)
>
> I don't have src/dst pairs in my API, because since the
> only data provision mechanisms to slaves are sglists,
> and these provide either source or destination address
> depending on transfer direction.
>
> Also I assume that since sglists will be mem->peripheral
> or peripheral->mem, you know what is required on the
> memory side of things for word width and burstsize, and
> these only affect the device side of things.
>
> So that is why my API is more minimalistic.
>
> If you feel src/dst versions of wordwidth, register address
> and burstsize are a must, I can add them, no big thing,
> just makes for some nonused parameters, mostly.

Unused parameters is what I want to avoid, and getting drivers that
can wrap dma_slave_config to actually do so is the final kicker.

Thoughts Vinod?

Thanks,
Dan
