Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758278Ab0GTDor (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 23:44:47 -0400
Received: from mga11.intel.com ([192.55.52.93]:16642 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758246Ab0GTDop convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 23:44:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,230,1278313200"; 
   d="scan'208";a="819685734"
From: "Koul, Vinod" <vinod.koul@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>,
        Linus Walleij <linus.ml.walleij@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alan Cox <alan@linux.intel.com>
Date: Tue, 20 Jul 2010 09:13:52 +0530
Subject: RE: [PATCH 1/3] DMAENGINE: generic slave channel control
Thread-Topic: [PATCH 1/3] DMAENGINE: generic slave channel control
Thread-Index: AcsnlO22FIdBEiF+TEmdGuhnHWyXMAAJLyGA
Message-ID: <438BB0150E931F4B9CE701519A44630104A3640CF7@bgsmsx502.gar.corp.intel.com>
References: <1277770577-11024-1-git-send-email-linus.walleij@stericsson.com>
	<AANLkTimYqUZvxaWVvT5FPsW36NTpqLLCqCiSuRAy_ER5@mail.gmail.com>
	<AANLkTinqKHCYeGTLuTtKikcR2IA8TY0vy2tSznxLay0N@mail.gmail.com>
	<AANLkTimHBWMYAeFrET2EpeA8KogcUmQldAHM_uhSv-gt@mail.gmail.com>
	<AANLkTil_2nzwEUS56U48CJpdqkrpnGXAwfcE9bU_Wqhw@mail.gmail.com>
 <AANLkTilAGPmOuS_LjA3TEq1mIcqLxX-T7P-PI-lBTZi0@mail.gmail.com>
In-Reply-To: <AANLkTilAGPmOuS_LjA3TEq1mIcqLxX-T7P-PI-lBTZi0@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, Jul 19, 2010 at 3:44 PM, Linus Walleij
> <linus.ml.walleij@gmail.com> wrote:
> > 2010/7/19 Dan Williams <dan.j.williams@intel.com>:
> >
> >> The recently submitted intel_mid driver [1] seems to have a similar structure:
> >
> > This is very interesting, let's examine this closely as a comparison!
> > I'm looking at it from the point of a generic slave control mechanism,
> > though I suspect it is designed to be Intel-specific so keep that in mind.
> >
> >> +/**
> >> + * struct intel_mid_dma_slave - DMA slave structure
> >> + *
> >> + * @dma_dev: DMA master client
> >> + * @tx_reg: physical address of data register used for
> >> + *     memory-to-peripheral transfers
> >> + * @rx_reg: physical address of data register used for
> >> + *     peripheral-to-memory transfers
> >> + * @tx_width: tx register width
> >> + * @rx_width: rx register width
> >> + * @dirn: DMA trf direction
> >> + * @cfg_hi: Platform-specific initializer for the CFG_HI register
> >> + * @cfg_lo: Platform-specific initializer for the CFG_LO register
> >> + * @ tx_width: width of src and dstn
> >> + * @ hs_mode: SW or HW handskaking mode
> >> + * @ cfg_mode: Mode configuration, DMA mem to mem to dev & mem
> >> + */
> >> +struct intel_mid_dma_slave {
> >> +       enum dma_data_direction         dirn;
> >> +       enum intel_mid_dma_width        src_width; /*width of DMA src txn*/
> >> +       enum intel_mid_dma_width        dst_width; /*width of DMA dst txn*/
> >> +       enum intel_mid_dma_hs_mode      hs_mode;  /*handshaking*/
> >> +       enum intel_mid_dma_mode         cfg_mode; /*mode configuration*/
> >> +       enum intel_mid_dma_msize        src_msize; /*size if src burst*/
> >> +       enum intel_mid_dma_msize        dst_msize; /*size of dst burst*/
> >> +       dma_async_tx_callback           callback; /*callback function*/
> >> +       void                            *callback_param; /*param for callback*/
> >> +       unsigned int            device_instance; /*0, 1 for periphral instance*/
> >> +};
> >> +
> >
> > kerneldoc and struct members seem to be out-of-sync but I
> > see the general idea.
> >
> > Of these members handshaking, cfg_mode, hs_mode
> > and I suspect also device_instance are candidates for
> > the private config  since they cannot be assumed to
> > exist on all DMA engines. (Also goes for cfg_[lo|hi] from
> > the kerneldoc)
> >
> > The callback and callback param are configured
> > per-transfer in the current API, so I don't see what they
> > are doing here at all.
> 
> Yeah, I already pointed that out...
This is my current structure which I was hoping to submit upstream this week
after my testing on various controllers was complete
/**
 * struct intel_mid_dma_slave - DMA slave structure
 *
 * @dirn: DMA trf direction
 * @src_width: tx register width
 * @dst_width: rx register width
 * @hs_mode: HW/SW handshaking mode
 * @cfg_mode: DMA data transfer mode (per-per/mem-per/mem-mem)
 * @src_msize: Source DMA burst size
 * @dst_msize: Dst DMA burst size
 * @device_instance: DMA peripheral device instance, we can have multiple
 * 			peripheral device connected to single DMAC
 */
struct intel_mid_dma_slave {
	enum dma_data_direction		dirn;
	enum intel_mid_dma_width	src_width; /*width of DMA src txn*/
	enum intel_mid_dma_width	dst_width; /*width of DMA dst txn*/
	enum intel_mid_dma_hs_mode	hs_mode;  /*handshaking*/
	enum intel_mid_dma_mode		cfg_mode; /*mode configuration*/
	enum intel_mid_dma_msize	src_msize; /*size if src burst*/
	enum intel_mid_dma_msize	dst_msize; /*size of dst burst*/
	unsigned int		device_instance; /*0, 1 for peripheral instance*/
};

> 
> >
> > Remains: direction, then register address, burstsize and
> > word width of the source and destination.
> >
> > (Register address present in kerneldoc but not in struct,
> > burstsize present in struct but not in kerneldoc, whatever)
> >
> > I don't have src/dst pairs in my API, because since the
> > only data provision mechanisms to slaves are sglists,
> > and these provide either source or destination address
> > depending on transfer direction.
> >
> > Also I assume that since sglists will be mem->peripheral
> > or peripheral->mem, you know what is required on the
> > memory side of things for word width and burstsize, and
> > these only affect the device side of things.
> >
> > So that is why my API is more minimalistic.
> >
> > If you feel src/dst versions of wordwidth, register address
> > and burstsize are a must, I can add them, no big thing,
> > just makes for some nonused parameters, mostly.
> 
> Unused parameters is what I want to avoid, and getting drivers that
> can wrap dma_slave_config to actually do so is the final kicker.
> 
> Thoughts Vinod?
Yes the structures have various common things and would be good to abstract
generic stuff in this and move the rest to private_config.
But since we are talking about a generic DMA slave capabilities structure, I 
would recommend changing few.

I am not sure why do you want the I/O addr to be passed here, sorry I
don't follow that logic. If you notice in intel_mid_dma driver the I/O address
is passed by client driver in prep_memcpy in src and dst fields. Since the slave 
structure tell you the direction and mode you can interpret that src/dst address 
as IO address easily

Addr_width and Maxburst: talks about the I/O width and msize I guess, but what 
about mem-width, I have few configuration where we would like to have different 
mem width as well.
And why limit the generic API and what about per-per transfers which 
intel_mid_dma driver would need to support in future.
I would recommend renaming this field to src_addr_width etc and add dst_addr_xxx 
pair.

Yes I can have them in private_config but then again driver has to do a simple 
check on which one is src/dst in slave and which one is in privae_config. Again 
easily doable but little confusing, I am okay either way

Thanks
Vinod
