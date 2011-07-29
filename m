Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751578Ab1G2OL2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 10:11:28 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46631 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290Ab1G2OL0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 10:11:26 -0400
MIME-Version: 1.0
In-Reply-To: <20110728223505.GC829@flint.arm.linux.org.uk>
References: <CAJe_ZhcNM7m-eWA0nDUrOrHxeAhNS00gewf=txmvOFL_uOPhrw@mail.gmail.com>
	<1311740499.1536.56.camel@vkoul-udesk3>
	<CAJe_ZhfaPfobs5P+q+t-kRSK4fAvm-v_brYgqmco8fwOOBeT8A@mail.gmail.com>
	<1311757347.1536.103.camel@vkoul-udesk3>
	<20110727095909.GB16623@intel.com>
	<CAJe_ZhdkPpVSyCyiUsFhOUUms8=JSQOiC33ztFzriW8jQHaa_w@mail.gmail.com>
	<CABE8wwuAFMYHH67sjEuy7whiZD+QBmU6bvzUUzEqJQFaYpkgdQ@mail.gmail.com>
	<CAJe_Zhfm5k9gNPaTfpZdQ__cp9fKLZoiSvG0GPciVFbkkU=QCw@mail.gmail.com>
	<20110727202859.GA5028@flint.arm.linux.org.uk>
	<CAJe_ZheB0uKn=Rk-i2y1rn5ZHJUJJy7D_3Pb6d4ggjNDhh+6VA@mail.gmail.com>
	<20110728223505.GC829@flint.arm.linux.org.uk>
Date: Fri, 29 Jul 2011 19:41:24 +0530
Message-ID: <CAJe_Zhd3=MAhJOvLR2j-_GSQxhd6UyBUn9v8cdzRdTYKqxAcUQ@mail.gmail.com>
Subject: Re: [PATCHv2] DMAEngine: Let dmac drivers to set chan_id
From: Jaswinder Singh <jaswinder.singh@linaro.org>
To: Russell King <rmk@arm.linux.org.uk>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Koul, Vinod" <vinod.koul@intel.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, per.friden@stericsson.com,
        wei.zhang@freescale.com, ebony.zhu@freescale.com, iws@ovro.caltech.edu,
        s.hauer@pengutronix.de, maciej.sosnowski@intel.com, saeed@marvell.com,
        shawn.guo@freescale.com, yur@emcraft.com, agust@denx.de,
        iwamatsu.nobuhiro@renesas.com, per.forlin@stericsson.com,
        jonas.aberg@stericsson.com, anemo@mba.ocn.ne.jp
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29 July 2011 04:05, Russell King <rmk@arm.linux.org.uk> wrote:
> On Thu, Jul 28, 2011 at 04:14:34PM +0530, Jaswinder Singh wrote:
>> For ex, for 'PITA' board, the dmac driver (via info directly gotten
>> from platform) will announce
>>   cap_rs8  := 'MMC' | '2ndInstance' | 'Dev->Mem'   //via probe of DMAC0
>>   cap_rs31 := 'MMC' | '2ndInstance' | 'Dev->Mem'   //via probe of DMAC1
>>   cap_rs8  := 'MMC' | '2ndInstance' | 'Mem->Dev'   //via probe of DMAC3
>>   cap_rs57 := 'MMC' | '2ndInstance' | 'Mem->Dev'   //via probe of DMAC4
>
> Most of this didn't look too bad until I got to here.
>
>> Assuming
>> ************
>> a) There are no more than 256 types of DMA'able devices
>>    (MMC, USB, SPI etc) --  [8bits]
>
> Who allocates the 'type of dma' number ?
Look at it as a way for clients to tell the class of device they
drive, and for platforms to declare suitable candidate channel(s)
that have the capability to talk to that class of device controllers.

RequestSignal<->Peripheral link is fixed :-
    Platform --> dmac_driver   //from the DMAC chapter of the SoC's manual
RequestSignal<->Peripheral link is decided during board design :-
    Board --> platform --> dmac_driver

In kernel, there would be a list of global defines in DMAENGINE API's
namespace.
Please look at the end of this post to get an idea of how it might look.


>> b) A type of device never has more than 16 instances in a platform
>>    (MMC-0, MMC-1, MMC-2 etc) --  [4bits]
>
> How is the instance number given to devices ?
Same as how the 'type of dma' is decided on the dmac side of API.
RequestSignal<->Peripheral link is fixed :-
    Platform --> dmac_driver   //from the DMAC chapter of the SoC's manual
RequestSignal<->Peripheral link is decided during board design :-
    Board --> platform --> dmac_driver


> Are we expecting to have subsystems register with some kind of entity
> which gives out 'type' and 'instance' numbers just to satisfy this?
Nopes. Simply a matter of client-developer checking a header file and
the dmac_driver developer checking the same header file and DMAC chapter
of SoC's manual.


> In any case, if you look at Linus W's patches on LAKML for DMA on the
> Versatile/Realview platforms, or look at the way AMBA drivers like MMCI
> and PL011 UART deal with the 'filter' business, then I think you'd
> realize that there's ways to deal with this match problem which are far
> more flexible than your solution.

Looking at drivers/mmc/host/mmci.c and drivers/tty/serial/amba-pl011.c ...

They force platforms to have these members in the platform_data
	bool (*dma_filter)(struct dma_chan *chan, void *filter_param);
        void *dma_rx_param;
        void *dma_tx_param;

Only to ritualistically pass them back during dma_request_channel.
And that is the _least_ any client must do.

The 'filter' function and the 'data' simply have to loop back to the
dmac driver side of API and have _nothing_ to do with Client driver.

If we are to have common clients and reusable dmac drivers ...
Wouldn't this mechanism force _every_ platform to have the same two as
members of platform_data for _every_ controller it contains?
Afterall, most controllers could employ DMA.

Not to forget, you'll also have to standardize the dmac_driver<-->platform
interface.

Sorry, I don't think this, rather any, 'filter' thing could survive for long.

My proposal concentrates the whole channel selection logic within
the DMAENGINE API. Filter mechanism could be gotten away.



> What we do there is:
>
> 1. We provide a match function from the platform to the peripheral driver.
>   ==> this could be your special generic filter function.
> 2. We provide the match functions data from the platform to the peripheral
>   driver.
>   ==> this could be your special capability mask for that specific device.
I am no more talking about Samsung's channel selection mechanism.
If the filter callbacks are absolutely simplified by 'good' implementation on
the dmac side of the API -- why not drop the filter altogether ?
And if the filter callbacks would still contain platform specific stuff, sure
there is something crooked.
And as I said, we really need to rethink if this 'filter' mechanism
could survive.


> which your scheme can't handle, such as controlling an
> external MUX which has nothing to do with the DMAC or peripheral apart
> from sitting in the middle between the two - then it can do it its own
> way.
If it has nothing to do with the Client, nothing to do with the DMAC,
IMHO, it has absolutely nothing to do with the DMAENGINE API.

If anything, it should be folded into the {dmac_driver + platform + board}
logic. Perhaps, simply by having the dmac_driver do a callback on platform.
Something like
  err = rs_activate(DMACd_RSs)	//before starting the xfers
  rs_deactivate(DMACd_RSs)	//after xfers-done irq

And yes, this would very well work if clients and dmac_drivers are written
cleanly.
Client Drivers :- Whereever they request a channel, their design should
 take into account the fact that even after being allocated a channel,
 the DMAC might refuse to do a transfer due to contention on the bus.

DMAC Drivers :- They should not lock resources(like ReqSig) upon channel
allocation to a client, but only when they need to transfer.
Also, impo, they should completely dissociate actual h/w identity of a
req-sig from the 'token' they return to clients as the 'channel'.
That is, dma_request_channel should only pave a 'software-path' to actual
h/w channels - which may or may not be available when the client needs them.

Your scenario of ext-fpga-mux is similar to PL330 - main difference being the
request-signal activation mechanism is completely contained within the PL330
(only 8/32 can be active at a time) where as you need to manipulate ext-fpga for
channel selection.



-------------------------8<--------------------

***** In  include/linux/dmaengine.h  ****


/* ! This is just to give an idea. Please don't get hung on optimizations ! */

/*
 * _SAY_ we agree to use u32 for tag/capability-list
 *
 * Constraints/Capabilities
 * ************************
 * # MRWW - Max_RW_width/fifo_width, in power of 2 [3bits]
 *
 * # PMRWW - If Max_RW_Width is programmable(in geometric steps of 2) [1bit]
 *
 * # MBL - Max_Burst_Len for the channel, in power of 2 [4bits]
 *
 * # PMBL - If Max_Burst_Len is programmable(in geometric steps of 2) [1bit]
 *
 * # DIR - Mem->Mem, Mem->Dev, Dev->Mem, Dev->Devi capability [4bits]
 *
 * # DEV - Class of the device(MMC, USB, SPI etc) [7bits]
 *
 * # INST - Controller Instance(MMC-0, MMC-1, MMC-2 etc) [3bits]
 *
 * # PRI - Priority of a channel amoung set of equally capable ones [6bits]
 *
 * # XXX - Reserved for future use
 *
 * [XXX_3][MRWW_3][PMRWW_1][MBL_4][PMBL_1][DIR_4][DEV_7][INST_3][PRI_6]
 */

#define DCH_CAP_PRI_OFF		0
#define DCH_CAP_PRI_MASK	(0x3f << DCH_CAP_PRI_OFF)
#define DCH_CAP_INST_OFF	6
#define DCH_CAP_INST_MASK	(0x7 << DCH_CAP_INST_OFF)
#define DCH_CAP_DEV_OFF		9
#define DCH_CAP_DEV_MASK	(0x7f << DCH_CAP_DEV_OFF)

#define DCH_CAP_DIR_M2M	(1 << 15)
#define DCH_CAP_DIR_M2P	(1 << 16)
#define DCH_CAP_DIR_P2M	(1 << 17)
#define DCH_CAP_DIR_P2P	(1 << 18)

#define DCH_CAP_PMBL_OFF	20
#define DCH_CAP_PMBL_MASK	(0x1 << DCH_CAP_PMBL_OFF)
#define DCH_CAP_MBL_OFF		21
#define DCH_CAP_MBL_MASK	(0xf << DCH_CAP_MBL_OFF)
#define DCH_CAP_PMRWW_OFF	25
#define DCH_CAP_PMRWW_MASK	(0x1 << DCH_CAP_PMRWW_OFF)
#define DCH_CAP_MRWW_OFF	26
#define DCH_CAP_MRWW_MASK	(0x7 << DCH_CAP_MRWW_OFF)


/*** Helpers for DMAENGINE API ***/
#define GET_DEVTYPE(c)	(((c) & DCH_CAP_DEV_MASK) >> DCH_CAP_DEV_OFF)
#define GET_DEVINST(c)	(((c) & DCH_CAP_INST_MASK) >> DCH_CAP_INST_OFF)
#define GET_CHANPRI(c)	(((c) & DCH_CAP_PRI_MASK) >> DCH_CAP_PRI_OFF)
#define IS_DCH_M2M(c)	((c) & DCH_CAP_DIR_M2M)
#define IS_DCH_M2P(c)	((c) & DCH_CAP_DIR_M2P)
#define IS_DCH_P2M(c)	((c) & DCH_CAP_DIR_P2M)
#define IS_DCH_P2P(c)	((c) & DCH_CAP_DIR_P2P)


/*** Helpers for Platform ***/
#define SET_DEVTYPE(c, t) do {	\
				c &= ~DCH_CAP_DEV_MASK; \
				c |= ((t) << DCH_CAP_DEV_OFF); \
			  } while (0)

#define SET_DEVINST(c, i) do {	\
				c &= ~DCH_CAP_INST_MASK; \
				c |= ((t) << DCH_CAP_INST_OFF); \
			  } while (0)

#define SET_CHANPRI(c, p) do {	\
				c &= ~DCH_CAP_PRI_MASK; \
				c |= ((t) << DCH_CAP_PRI_OFF); \
			  } while (0)

#define SET_DCHDIR(c, m2m, m2p, p2m, p2p) do { \
						if (m2m) \
							c |= DCH_CAP_DIR_M2M; \
						else \
							c &= ~DCH_CAP_DIR_M2M; \
						if (m2p) \
							c |= DCH_CAP_DIR_M2P; \
						else \
							c &= ~DCH_CAP_DIR_M2P; \
						if (p2m) \
							c |= DCH_CAP_DIR_P2M; \
						else \
							c &= ~DCH_CAP_DIR_P2M; \
						if (p2p) \
							c |= DCH_CAP_DIR_P2P; \
						else \
							c &= ~DCH_CAP_DIR_P2P; \
					  } while (0)


/*** Helpers for Clients ***/
#define DCH_RESET_CAP(c)		do {c = 0;} while (0)
#define DCH_REQCAP_DEV(c, TYPE)		SET_DEVTYPE(c, TYPE)
#define DCH_REQCAP_INST(c, INST)	SET_DEVINST(c, INST)
#define DCH_REQCAP_TXRX(c)		SET_DCHDIR(c, 0, 1, 1, 0)
#define DCH_REQCAP_M2M(c)		SET_DCHDIR(c, 1, 0, 0, 0)
#define DCH_REQCAP_M2P(c)		SET_DCHDIR(c, 0, 1, 0, 0)
#define DCH_REQCAP_P2M(c)		SET_DCHDIR(c, 0, 0, 1, 0)
#define DCH_REQCAP_P2P(c)		SET_DCHDIR(c, 0, 0, 0, 1)


/*
 * A Client driver should add a new class to this list.
 * Platforms should only look-up this list to set appropriate
 * 'dev-type' for the DMA channel. Even if a platform has
 * many more channels, it doesn't matter if the client
 * driver doesn't exist.
 */
#define DCHAN_TODEV_AC97	0
#define DCHAN_TODEV_CAMERA	1
#define DCHAN_TODEV_GPU		2
#define DCHAN_TODEV_I2S		3
#define DCHAN_TODEV_LCD		4
#define DCHAN_TODEV_MMC		5
#define DCHAN_TODEV_SPI		6
#define DCHAN_TODEV_UART	7
#define DCHAN_TODEV_USBD	8
#define DCHAN_TODEV_NAND	9
#define DCHAN_TODEV_ATA		10


Thanks
