Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196Ab1ASGaa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 01:30:30 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:2204 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751904Ab1ASGa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 01:30:29 -0500
From: "Tomoya MORINAGA" <tomoya-linux@dsn.okisemi.com>
To: "'Philip Rakity'" <prakity@marvell.com>, <cjb@laptop.org>
Cc: "'Kyungmin Park'" <kmpark@infradead.org>, <linux-mmc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <andrew.chih.howe.khor@intel.com>,
        <kok.howg.ewe@intel.com>,
        "Toshiharu Okada" <toshiharu-linux@dsn.okisemi.com>
References: <4CD8DE9C.4040505@dsn.okisemi.com> <AANLkTimfnj8GcSwmALjaZUBsiq6ssaVuzVZZsZHRYmiX@mail.gmail.com> <001701cb814c$71926bf0$66f8800a@maildom.okisemi.com> <001201cb90f4$4be8f790$66f8800a@maildom.okisemi.com> <2D50F985-2383-4406-8514-DFE462A5F546@marvell.com> <4D2E0464ABB54FFF9C10583336E27879@hacdom.okisemi.com> <4C4E7DE5-7CF1-4D97-9CAD-F600FCBE477A@marvell.com>
Subject: RE: A MMC card transfer issue
Date: Wed, 19 Jan 2011 15:30:23 +0900
Message-ID: <09611EF13E604BFABF76F582032C1526@hacdom.okisemi.com>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0053_01CBB7ED.CB488210"
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <4C4E7DE5-7CF1-4D97-9CAD-F600FCBE477A@marvell.com>
Thread-Index: Acu3ntJKG6DyjEujQZC6OmsMmZbjewAAc3iw
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5994
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

------=_NextPart_000_0053_01CBB7ED.CB488210
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Philip, Chris

> For 1 bit transcend cards you need these 2 patches.
Thank you for your information.
It seems these patches aren't applied for kernel-2.6.37, right ?

Will you apply these patches for kernel-2.6.38?

BTW, I attached dmesg log when inserts MMC card with kernel-2.6.37.

Thanks,
-----------------------------------------
Tomoya MORINAGA
OKI SEMICONDUCTOR CO., LTD.
 

> -----Original Message-----
> From: Philip Rakity [mailto:prakity@marvell.com] 
> Sent: Wednesday, January 19, 2011 3:05 PM
> To: Tomoya MORINAGA
> Cc: Kyungmin Park; linux-mmc@vger.kernel.org; 
> linux-kernel@vger.kernel.org; 
> andrew.chih.howe.khor@intel.com; kok.howg.ewe@intel.com
> Subject: Re: A MMC card transfer issue
> 
> 
> For 1 bit transcend cards you need these 2 patches.
> 
> 
> From 22113efd00491310da802f3b1a9a66cfcf415fac Mon Sep 17 00:00:00 2001
> From: Aries Lee <arieslee@jmicron.com>
> Date: Wed, 15 Dec 2010 08:14:24 +0100
> Subject: [PATCH] mmc: Test bus-width for old MMC devices
> 
> Some old MMC devices fail with the 4/8 bits the driver tries 
> to use exclusively.  This patch adds a test for the given bus 
> setup and falls back to the lower bit mode (until 1-bit mode) 
> when the test fails.
> 
> [Major rework and refactoring by tiwai]
> [Quirk addition and many fixes by prakity]
> 
> Signed-off-by: Aries Lee <arieslee@jmicron.com>
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> Signed-off-by: Philip Rakity <prakity@marvell.com>
> Tested-by: Philip Rakity <prakity@marvell.com>
> Signed-off-by: Chris Ball <cjb@laptop.org>
> ---
>  drivers/mmc/core/mmc.c     |   76 ++++++++++++++++++++-------------
>  drivers/mmc/core/mmc_ops.c |  101 
> ++++++++++++++++++++++++++++++++++++++++++++
>  drivers/mmc/core/mmc_ops.h |    1 +
>  drivers/mmc/host/sdhci.c   |    7 +++-
>  drivers/mmc/host/sdhci.h   |    1 +
>  include/linux/mmc/host.h   |    1 +
>  include/linux/mmc/mmc.h    |    2 +
>  7 files changed, 159 insertions(+), 30 deletions(-)
> 
> diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c 
> index 76bb621..1d8409f 100644
> --- a/drivers/mmc/core/mmc.c
> +++ b/drivers/mmc/core/mmc.c
> @@ -534,39 +534,57 @@ static int mmc_init_card(struct 
> mmc_host *host, u32 ocr,
>  	 */
>  	if ((card->csd.mmca_vsn >= CSD_SPEC_VER_4) &&
>  	    (host->caps & (MMC_CAP_4_BIT_DATA | MMC_CAP_8_BIT_DATA))) {
> -		unsigned ext_csd_bit, bus_width;
> -
> -		if (host->caps & MMC_CAP_8_BIT_DATA) {
> -			if (ddr)
> -				ext_csd_bit = EXT_CSD_DDR_BUS_WIDTH_8;
> -			else
> -				ext_csd_bit = EXT_CSD_BUS_WIDTH_8;
> -			bus_width = MMC_BUS_WIDTH_8;
> -		} else {
> -			if (ddr)
> -				ext_csd_bit = EXT_CSD_DDR_BUS_WIDTH_4;
> -			else
> -				ext_csd_bit = EXT_CSD_BUS_WIDTH_4;
> -			bus_width = MMC_BUS_WIDTH_4;
> +		static unsigned ext_csd_bits[][2] = {
> +			{ EXT_CSD_BUS_WIDTH_8, 
> EXT_CSD_DDR_BUS_WIDTH_8 },
> +			{ EXT_CSD_BUS_WIDTH_4, 
> EXT_CSD_DDR_BUS_WIDTH_4 },
> +			{ EXT_CSD_BUS_WIDTH_1, EXT_CSD_BUS_WIDTH_1 },
> +		};
> +		static unsigned bus_widths[] = {
> +			MMC_BUS_WIDTH_8,
> +			MMC_BUS_WIDTH_4,
> +			MMC_BUS_WIDTH_1
> +		};
> +		unsigned idx, bus_width = 0;
> +
> +		if (host->caps & MMC_CAP_8_BIT_DATA)
> +			idx = 0;
> +		else
> +			idx = 1;
> +		for (; idx < ARRAY_SIZE(bus_widths); idx++) {
> +			bus_width = bus_widths[idx];
> +			if (bus_width == MMC_BUS_WIDTH_1)
> +				ddr = 0; /* no DDR for 1-bit width */
> +			err = mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
> +					 EXT_CSD_BUS_WIDTH,
> +					 ext_csd_bits[idx][0]);
> +			if (!err) {
> +				/*
> +				 * If controller can't handle 
> bus width test,
> +				 * use the highest bus width to maintain
> +				 * compatibility with previous 
> MMC behavior.
> +				 */
> +				if (!(host->caps & 
> MMC_CAP_BUS_WIDTH_TEST))
> +					break;
> +				mmc_set_bus_width_ddr(card->host,
> +						      
> bus_width, MMC_SDR_MODE);
> +				err = mmc_bus_test(card, bus_width);
> +				if (!err)
> +					break;
> +			}
>  		}
>  
> -		err = mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
> -				 EXT_CSD_BUS_WIDTH, ext_csd_bit);
> -
> -		if (err && err != -EBADMSG)
> -			goto free_card;
> -
> +		if (!err && ddr) {
> +			err = mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
> +					EXT_CSD_BUS_WIDTH,
> +					ext_csd_bits[idx][1]);
> +		}
>  		if (err) {
>  			printk(KERN_WARNING "%s: switch to bus 
> width %d ddr %d "
> -			       "failed\n", mmc_hostname(card->host),
> -			       1 << bus_width, ddr);
> -			err = 0;
> -		} else {
> -			if (ddr)
> -				mmc_card_set_ddr_mode(card);
> -			else
> -				ddr = MMC_SDR_MODE;
> -
> +				"failed\n", mmc_hostname(card->host),
> +				1 << bus_width, ddr);
> +			goto free_card;
> +		} else if (ddr) {
> +			mmc_card_set_ddr_mode(card);
>  			mmc_set_bus_width_ddr(card->host, 
> bus_width, ddr);
>  		}
>  	}
> diff --git a/drivers/mmc/core/mmc_ops.c 
> b/drivers/mmc/core/mmc_ops.c index 326447c..60842f8 100644
> --- a/drivers/mmc/core/mmc_ops.c
> +++ b/drivers/mmc/core/mmc_ops.c
> @@ -462,3 +462,104 @@ int mmc_send_status(struct mmc_card 
> *card, u32 *status)
>  	return 0;
>  }
>  
> +static int
> +mmc_send_bus_test(struct mmc_card *card, struct mmc_host 
> *host, u8 opcode,
> +		  u8 len)
> +{
> +	struct mmc_request mrq;
> +	struct mmc_command cmd;
> +	struct mmc_data data;
> +	struct scatterlist sg;
> +	u8 *data_buf;
> +	u8 *test_buf;
> +	int i, err;
> +	static u8 testdata_8bit[8] = { 0x55, 0xaa, 0, 0, 0, 0, 0, 0 };
> +	static u8 testdata_4bit[4] = { 0x5a, 0, 0, 0 };
> +
> +	/* dma onto stack is unsafe/nonportable, but callers to this
> +	 * routine normally provide temporary on-stack buffers ...
> +	 */
> +	data_buf = kmalloc(len, GFP_KERNEL);
> +	if (!data_buf)
> +		return -ENOMEM;
> +
> +	if (len == 8)
> +		test_buf = testdata_8bit;
> +	else if (len == 4)
> +		test_buf = testdata_4bit;
> +	else {
> +		printk(KERN_ERR "%s: Invalid bus_width %d\n",
> +		       mmc_hostname(host), len);
> +		kfree(data_buf);
> +		return -EINVAL;
> +	}
> +
> +	if (opcode == MMC_BUS_TEST_W)
> +		memcpy(data_buf, test_buf, len);
> +
> +	memset(&mrq, 0, sizeof(struct mmc_request));
> +	memset(&cmd, 0, sizeof(struct mmc_command));
> +	memset(&data, 0, sizeof(struct mmc_data));
> +
> +	mrq.cmd = &cmd;
> +	mrq.data = &data;
> +	cmd.opcode = opcode;
> +	cmd.arg = 0;
> +
> +	/* NOTE HACK:  the MMC_RSP_SPI_R1 is always correct here, but we
> +	 * rely on callers to never use this with "native" 
> calls for reading
> +	 * CSD or CID.  Native versions of those commands use 
> the R2 type,
> +	 * not R1 plus a data block.
> +	 */
> +	cmd.flags = MMC_RSP_SPI_R1 | MMC_RSP_R1 | MMC_CMD_ADTC;
> +
> +	data.blksz = len;
> +	data.blocks = 1;
> +	if (opcode == MMC_BUS_TEST_R)
> +		data.flags = MMC_DATA_READ;
> +	else
> +		data.flags = MMC_DATA_WRITE;
> +
> +	data.sg = &sg;
> +	data.sg_len = 1;
> +	sg_init_one(&sg, data_buf, len);
> +	mmc_wait_for_req(host, &mrq);
> +	err = 0;
> +	if (opcode == MMC_BUS_TEST_R) {
> +		for (i = 0; i < len / 4; i++)
> +			if ((test_buf[i] ^ data_buf[i]) != 0xff) {
> +				err = -EIO;
> +				break;
> +			}
> +	}
> +	kfree(data_buf);
> +
> +	if (cmd.error)
> +		return cmd.error;
> +	if (data.error)
> +		return data.error;
> +
> +	return err;
> +}
> +
> +int mmc_bus_test(struct mmc_card *card, u8 bus_width) {
> +	int err, width;
> +
> +	if (bus_width == MMC_BUS_WIDTH_8)
> +		width = 8;
> +	else if (bus_width == MMC_BUS_WIDTH_4)
> +		width = 4;
> +	else if (bus_width == MMC_BUS_WIDTH_1)
> +		return 0; /* no need for test */
> +	else
> +		return -EINVAL;
> +
> +	/*
> +	 * Ignore errors from BUS_TEST_W.  BUS_TEST_R will fail if there
> +	 * is a problem.  This improves chances that the test will work.
> +	 */
> +	mmc_send_bus_test(card, card->host, MMC_BUS_TEST_W, width);
> +	err = mmc_send_bus_test(card, card->host, 
> MMC_BUS_TEST_R, width);
> +	return err;
> +}
> diff --git a/drivers/mmc/core/mmc_ops.h 
> b/drivers/mmc/core/mmc_ops.h index 653eb8e..e6d44b8 100644
> --- a/drivers/mmc/core/mmc_ops.h
> +++ b/drivers/mmc/core/mmc_ops.h
> @@ -26,6 +26,7 @@ int mmc_send_cid(struct mmc_host *host, u32 
> *cid);  int mmc_spi_read_ocr(struct mmc_host *host, int 
> highcap, u32 *ocrp);  int mmc_spi_set_crc(struct mmc_host 
> *host, int use_crc);  int mmc_card_sleepawake(struct mmc_host 
> *host, int sleep);
> +int mmc_bus_test(struct mmc_card *card, u8 bus_width);
>  
>  #endif
>  
> diff --git a/drivers/mmc/host/sdhci.c 
> b/drivers/mmc/host/sdhci.c index 5569886..d5febe5 100644
> --- a/drivers/mmc/host/sdhci.c
> +++ b/drivers/mmc/host/sdhci.c
> @@ -23,6 +23,7 @@
>  
>  #include <linux/leds.h>
>  
> +#include <linux/mmc/mmc.h>
>  #include <linux/mmc/host.h>
>  
>  #include "sdhci.h"
> @@ -1521,7 +1522,11 @@ static void sdhci_data_irq(struct 
> sdhci_host *host, u32 intmask)
>  
>  	if (intmask & SDHCI_INT_DATA_TIMEOUT)
>  		host->data->error = -ETIMEDOUT;
> -	else if (intmask & (SDHCI_INT_DATA_CRC | 
> SDHCI_INT_DATA_END_BIT))
> +	else if (intmask & SDHCI_INT_DATA_END_BIT)
> +		host->data->error = -EILSEQ;
> +	else if ((intmask & SDHCI_INT_DATA_CRC) &&
> +		SDHCI_GET_CMD(sdhci_readw(host, SDHCI_COMMAND))
> +			!= MMC_BUS_TEST_R)
>  		host->data->error = -EILSEQ;
>  	else if (intmask & SDHCI_INT_ADMA_ERROR) {
>  		printk(KERN_ERR "%s: ADMA error\n", 
> mmc_hostname(host->mmc)); diff --git 
> a/drivers/mmc/host/sdhci.h b/drivers/mmc/host/sdhci.h index 
> 1efe7dc..6e0969e 100644
> --- a/drivers/mmc/host/sdhci.h
> +++ b/drivers/mmc/host/sdhci.h
> @@ -52,6 +52,7 @@
>  #define  SDHCI_CMD_RESP_SHORT_BUSY 0x03
>  
>  #define SDHCI_MAKE_CMD(c, f) (((c & 0xff) << 8) | (f & 0xff))
> +#define SDHCI_GET_CMD(c) ((c>>8) & 0x3f)
>  
>  #define SDHCI_RESPONSE		0x10
>  
> diff --git a/include/linux/mmc/host.h 
> b/include/linux/mmc/host.h index 3a85e73..bcb793e 100644
> --- a/include/linux/mmc/host.h
> +++ b/include/linux/mmc/host.h
> @@ -172,6 +172,7 @@ struct mmc_host {
>  #define MMC_CAP_1_2V_DDR	(1 << 12)	/* can support */
>  						/* DDR mode at 1.2V */
>  #define MMC_CAP_POWER_OFF_CARD	(1 << 13)	/* Can 
> power off after boot */
> +#define MMC_CAP_BUS_WIDTH_TEST	(1 << 14)	/* 
> CMD14/CMD19 bus width ok */
>  
>  	mmc_pm_flag_t		pm_caps;	/* supported pm 
> features */
>  
> diff --git a/include/linux/mmc/mmc.h 
> b/include/linux/mmc/mmc.h index 956fbd87..612301f 100644
> --- a/include/linux/mmc/mmc.h
> +++ b/include/linux/mmc/mmc.h
> @@ -40,7 +40,9 @@
>  #define MMC_READ_DAT_UNTIL_STOP  11   /* adtc [31:0] dadr    
>     R1  */
>  #define MMC_STOP_TRANSMISSION    12   /* ac                  
>     R1b */
>  #define MMC_SEND_STATUS          13   /* ac   [31:16] RCA    
>     R1  */
> +#define MMC_BUS_TEST_R           14   /* adtc                
>     R1  */
>  #define MMC_GO_INACTIVE_STATE    15   /* ac   [31:16] RCA    
>         */
> +#define MMC_BUS_TEST_W           19   /* adtc                
>     R1  */
>  #define MMC_SPI_READ_OCR         58   /* spi                 
>  spi_R3 */
>  #define MMC_SPI_CRC_ON_OFF       59   /* spi  [0:0] flag     
>  spi_R1 */
>  
> --
> 1.7.3.5
> 
> 
> 
> From 08c82dfad2458f8f9b83126224a85e7ea9e2b046 Mon Sep 17 00:00:00 2001
> From: Takashi Iwai <tiwai@suse.de>
> Date: Wed, 22 Dec 2010 09:59:44 +0100
> Subject: [PATCH] mmc: fix mmc_set_bus_width_ddr() call 
> without bus-width-test cap
> 
> With the bus-width test patch, mmc_set_bus_width*() isn't 
> called properly
> when the driver doesn't set MMC_CAP_BUS_WIDTH and no DDR mode.
> This patch fixes the regression by moving the call up before 
> the cap test.
> 
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> Reviewed-by: Chris Ball <cjb@laptop.org>
> Signed-off-by: Chris Ball <cjb@laptop.org>
> ---
>  drivers/mmc/core/mmc.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
> index 1d8409f..c86dd73 100644
> --- a/drivers/mmc/core/mmc.c
> +++ b/drivers/mmc/core/mmc.c
> @@ -558,6 +558,8 @@ static int mmc_init_card(struct mmc_host 
> *host, u32 ocr,
>  					 EXT_CSD_BUS_WIDTH,
>  					 ext_csd_bits[idx][0]);
>  			if (!err) {
> +				mmc_set_bus_width_ddr(card->host,
> +						      
> bus_width, MMC_SDR_MODE);
>  				/*
>  				 * If controller can't handle 
> bus width test,
>  				 * use the highest bus width to maintain
> @@ -565,8 +567,6 @@ static int mmc_init_card(struct mmc_host 
> *host, u32 ocr,
>  				 */
>  				if (!(host->caps & 
> MMC_CAP_BUS_WIDTH_TEST))
>  					break;
> -				mmc_set_bus_width_ddr(card->host,
> -						      
> bus_width, MMC_SDR_MODE);
>  				err = mmc_bus_test(card, bus_width);
>  				if (!err)
>  					break;
> -- 
> 1.7.3.5
> 
> 
> 
> On Jan 18, 2011, at 4:36 PM, Tomoya MORINAGA wrote:
> 
> > Hi Philip,
> >  
> > On Wednesday, December 01, 2010 10:31 AM, Philip Rakity wrote:
> > > Thanks very much, I'll plan on sending this to Linus 
> tomorrow, along
> > > with the rest of my .37 queue, unless there are any more review
> > > comments from anyone.
> >  
> > We tried to use the MMC card like the following on kernel-2.6.37.
> >  
> > On Tuesday, November 09, 2010 2:40 PM, Tomoya MORINAGA wrote:
> > > I am facing the issue about some MMC cards on Intel EG20T PCH 
> > > (Platform Controller Hub).
> > > The linux version is 2.6.36.
> > > I can not transfer data the MMC cards (e.g. Transcned MMC card).
> > > The card is 1 bit bus width. And the card is according to MMC 
> > > specification V3.x.
> > > And the EG20T has a 4 bit bus width capability Linux MMC 
> > > standard driver decides the card bus width as 4 bit, if the 
> > > MMC specification version is larger than or equal to V4.0 
> like below.
> >  
> > However it seems the issue remains to be seen.
> > Have you fixed the MMC unrecognized issue in kernel-2.6.37?
> >  
> > Thanks,
> > -----------------------------------------
> > Tomoya MORINAGA
> > OKI SEMICONDUCTOR CO., LTD.
> 

------=_NextPart_000_0053_01CBB7ED.CB488210
Content-Type: application/octet-stream;
	name="mmc_log"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="mmc_log"

 error -84 transferring data, sector 3940338, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3940338=0A=
mmcblk0: error -84 transferring data, sector 3940339, nr 5, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3940339=0A=
mmcblk0: error -84 transferring data, sector 3940340, nr 4, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3940340=0A=
mmcblk0: error -84 transferring data, sector 3940341, nr 3, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3940341=0A=
mmcblk0: error -84 transferring data, sector 3940342, nr 2, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3940342=0A=
mmcblk0: error -84 transferring data, sector 3940343, nr 1, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3940343=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 0, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 0=0A=
mmcblk0: error -84 transferring data, sector 1, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 1=0A=
mmcblk0: error -84 transferring data, sector 2, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 2=0A=
mmcblk0: error -84 transferring data, sector 3, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3=0A=
mmcblk0: error -84 transferring data, sector 4, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 4=0A=
mmcblk0: error -84 transferring data, sector 5, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 5=0A=
mmcblk0: error -84 transferring data, sector 6, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 6=0A=
mmcblk0: error -84 transferring data, sector 7, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 7=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 0, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 0=0A=
mmcblk0: error -84 transferring data, sector 1, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 1=0A=
mmcblk0: error -84 transferring data, sector 2, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 2=0A=
mmcblk0: error -84 transferring data, sector 3, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3=0A=
mmcblk0: error -84 transferring data, sector 4, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 4=0A=
mmcblk0: error -84 transferring data, sector 5, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 5=0A=
mmcblk0: error -84 transferring data, sector 6, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 6=0A=
mmcblk0: error -84 transferring data, sector 7, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 7=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 8, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 8=0A=
mmcblk0: error -84 transferring data, sector 9, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 9=0A=
mmcblk0: error -84 transferring data, sector 10, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 10=0A=
mmcblk0: error -84 transferring data, sector 11, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 11=0A=
mmcblk0: error -84 transferring data, sector 12, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 12=0A=
mmcblk0: error -84 transferring data, sector 13, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 13=0A=
mmcblk0: error -84 transferring data, sector 14, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 14=0A=
mmcblk0: error -84 transferring data, sector 15, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 15=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 3940344, nr 8, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3940344=0A=
mmcblk0: error -84 transferring data, sector 3940345, nr 7, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3940345=0A=
mmcblk0: error -84 transferring data, sector 3940346, nr 6, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3940346=0A=
mmcblk0: error -84 transferring data, sector 3940347, nr 5, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3940347=0A=
mmcblk0: error -84 transferring data, sector 3940348, nr 4, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3940348=0A=
mmcblk0: error -84 transferring data, sector 3940349, nr 3, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3940349=0A=
mmcblk0: error -84 transferring data, sector 3940350, nr 2, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3940350=0A=
mmcblk0: error -84 transferring data, sector 3940351, nr 1, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3940351=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 3940344, nr 8, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3940344=0A=
mmcblk0: error -84 transferring data, sector 3940345, nr 7, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3940345=0A=
mmcblk0: error -84 transferring data, sector 3940346, nr 6, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3940346=0A=
mmcblk0: error -84 transferring data, sector 3940347, nr 5, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3940347=0A=
mmcblk0: error -84 transferring data, sector 3940348, nr 4, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3940348=0A=
mmcblk0: error -84 transferring data, sector 3940349, nr 3, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3940349=0A=
mmcblk0: error -84 transferring data, sector 3940350, nr 2, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3940350=0A=
mmcblk0: error -84 transferring data, sector 3940351, nr 1, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3940351=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 3940344, nr 8, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3940344=0A=
mmcblk0: error -84 transferring data, sector 3940345, nr 7, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3940345=0A=
mmcblk0: error -84 transferring data, sector 3940346, nr 6, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3940346=0A=
mmcblk0: error -84 transferring data, sector 3940347, nr 5, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3940347=0A=
mmcblk0: error -84 transferring data, sector 3940348, nr 4, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3940348=0A=
mmcblk0: error -84 transferring data, sector 3940349, nr 3, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3940349=0A=
mmcblk0: error -84 transferring data, sector 3940350, nr 2, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3940350=0A=
mmcblk0: error -84 transferring data, sector 3940351, nr 1, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3940351=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 3940344, nr 8, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3940344=0A=
mmcblk0: error -84 transferring data, sector 3940345, nr 7, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3940345=0A=
mmcblk0: error -84 transferring data, sector 3940346, nr 6, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3940346=0A=
mmcblk0: error -84 transferring data, sector 3940347, nr 5, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3940347=0A=
mmcblk0: error -84 transferring data, sector 3940348, nr 4, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3940348=0A=
mmcblk0: error -84 transferring data, sector 3940349, nr 3, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3940349=0A=
mmcblk0: error -84 transferring data, sector 3940350, nr 2, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3940350=0A=
mmcblk0: error -84 transferring data, sector 3940351, nr 1, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3940351=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 3940344, nr 8, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3940344=0A=
mmcblk0: error -84 transferring data, sector 3940345, nr 7, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3940345=0A=
mmcblk0: error -84 transferring data, sector 3940346, nr 6, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3940346=0A=
mmcblk0: error -84 transferring data, sector 3940347, nr 5, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3940347=0A=
mmcblk0: error -84 transferring data, sector 3940348, nr 4, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3940348=0A=
mmcblk0: error -84 transferring data, sector 3940349, nr 3, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3940349=0A=
mmcblk0: error -84 transferring data, sector 3940350, nr 2, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3940350=0A=
mmcblk0: error -84 transferring data, sector 3940351, nr 1, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3940351=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 3940344, nr 8, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3940344=0A=
mmcblk0: error -84 transferring data, sector 3940345, nr 7, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3940345=0A=
mmcblk0: error -84 transferring data, sector 3940346, nr 6, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3940346=0A=
mmcblk0: error -84 transferring data, sector 3940347, nr 5, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3940347=0A=
mmcblk0: error -84 transferring data, sector 3940348, nr 4, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3940348=0A=
mmcblk0: error -84 transferring data, sector 3940349, nr 3, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3940349=0A=
mmcblk0: error -84 transferring data, sector 3940350, nr 2, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3940350=0A=
mmcblk0: error -84 transferring data, sector 3940351, nr 1, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3940351=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 3940288, nr 8, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3940288=0A=
mmcblk0: error -84 transferring data, sector 3940289, nr 7, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3940289=0A=
mmcblk0: error -84 transferring data, sector 3940290, nr 6, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3940290=0A=
mmcblk0: error -84 transferring data, sector 3940291, nr 5, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3940291=0A=
mmcblk0: error -84 transferring data, sector 3940292, nr 4, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3940292=0A=
mmcblk0: error -84 transferring data, sector 3940293, nr 3, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3940293=0A=
mmcblk0: error -84 transferring data, sector 3940294, nr 2, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3940294=0A=
mmcblk0: error -84 transferring data, sector 3940295, nr 1, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3940295=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 3940336, nr 8, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3940336=0A=
mmcblk0: error -84 transferring data, sector 3940337, nr 7, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3940337=0A=
mmcblk0: error -84 transferring data, sector 3940338, nr 6, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3940338=0A=
mmcblk0: error -84 transferring data, sector 3940339, nr 5, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3940339=0A=
mmcblk0: error -84 transferring data, sector 3940340, nr 4, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3940340=0A=
mmcblk0: error -84 transferring data, sector 3940341, nr 3, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3940341=0A=
mmcblk0: error -84 transferring data, sector 3940342, nr 2, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3940342=0A=
mmcblk0: error -84 transferring data, sector 3940343, nr 1, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3940343=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 8, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 8=0A=
mmcblk0: error -84 transferring data, sector 9, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 9=0A=
mmcblk0: error -84 transferring data, sector 10, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 10=0A=
mmcblk0: error -84 transferring data, sector 11, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 11=0A=
mmcblk0: error -84 transferring data, sector 12, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 12=0A=
mmcblk0: error -84 transferring data, sector 13, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 13=0A=
mmcblk0: error -84 transferring data, sector 14, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 14=0A=
mmcblk0: error -84 transferring data, sector 15, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 15=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 8, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 8=0A=
mmcblk0: error -84 transferring data, sector 9, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 9=0A=
mmcblk0: error -84 transferring data, sector 10, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 10=0A=
mmcblk0: error -84 transferring data, sector 11, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 11=0A=
mmcblk0: error -84 transferring data, sector 12, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 12=0A=
mmcblk0: error -84 transferring data, sector 13, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 13=0A=
mmcblk0: error -84 transferring data, sector 14, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 14=0A=
mmcblk0: error -84 transferring data, sector 15, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 15=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 3940344, nr 8, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3940344=0A=
mmcblk0: error -84 transferring data, sector 3940345, nr 7, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3940345=0A=
mmcblk0: error -84 transferring data, sector 3940346, nr 6, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3940346=0A=
mmcblk0: error -84 transferring data, sector 3940347, nr 5, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3940347=0A=
mmcblk0: error -84 transferring data, sector 3940348, nr 4, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3940348=0A=
mmcblk0: error -84 transferring data, sector 3940349, nr 3, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3940349=0A=
mmcblk0: error -84 transferring data, sector 3940350, nr 2, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3940350=0A=
mmcblk0: error -84 transferring data, sector 3940351, nr 1, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3940351=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 3940344, nr 8, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3940344=0A=
mmcblk0: error -84 transferring data, sector 3940345, nr 7, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3940345=0A=
mmcblk0: error -84 transferring data, sector 3940346, nr 6, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3940346=0A=
mmcblk0: error -84 transferring data, sector 3940347, nr 5, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3940347=0A=
mmcblk0: error -84 transferring data, sector 3940348, nr 4, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3940348=0A=
mmcblk0: error -84 transferring data, sector 3940349, nr 3, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3940349=0A=
mmcblk0: error -84 transferring data, sector 3940350, nr 2, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3940350=0A=
mmcblk0: error -84 transferring data, sector 3940351, nr 1, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3940351=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 3940344, nr 8, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3940344=0A=
mmcblk0: error -84 transferring data, sector 3940345, nr 7, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3940345=0A=
mmcblk0: error -84 transferring data, sector 3940346, nr 6, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3940346=0A=
mmcblk0: error -84 transferring data, sector 3940347, nr 5, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3940347=0A=
mmcblk0: error -84 transferring data, sector 3940348, nr 4, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3940348=0A=
mmcblk0: error -84 transferring data, sector 3940349, nr 3, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3940349=0A=
mmcblk0: error -84 transferring data, sector 3940350, nr 2, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3940350=0A=
mmcblk0: error -84 transferring data, sector 3940351, nr 1, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3940351=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 0, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 0=0A=
mmcblk0: error -84 transferring data, sector 1, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 1=0A=
mmcblk0: error -84 transferring data, sector 2, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 2=0A=
mmcblk0: error -84 transferring data, sector 3, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3=0A=
mmcblk0: error -84 transferring data, sector 4, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 4=0A=
mmcblk0: error -84 transferring data, sector 5, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 5=0A=
mmcblk0: error -84 transferring data, sector 6, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 6=0A=
mmcblk0: error -84 transferring data, sector 7, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 7=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 0, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 0=0A=
mmcblk0: error -84 transferring data, sector 1, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 1=0A=
mmcblk0: error -84 transferring data, sector 2, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 2=0A=
mmcblk0: error -84 transferring data, sector 3, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3=0A=
mmcblk0: error -84 transferring data, sector 4, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 4=0A=
mmcblk0: error -84 transferring data, sector 5, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 5=0A=
mmcblk0: error -84 transferring data, sector 6, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 6=0A=
mmcblk0: error -84 transferring data, sector 7, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 7=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 0, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 0=0A=
mmcblk0: error -84 transferring data, sector 1, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 1=0A=
mmcblk0: error -84 transferring data, sector 2, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 2=0A=
mmcblk0: error -84 transferring data, sector 3, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3=0A=
mmcblk0: error -84 transferring data, sector 4, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 4=0A=
mmcblk0: error -84 transferring data, sector 5, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 5=0A=
mmcblk0: error -84 transferring data, sector 6, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 6=0A=
mmcblk0: error -84 transferring data, sector 7, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 7=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 0, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 0=0A=
mmcblk0: error -84 transferring data, sector 1, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 1=0A=
mmcblk0: error -84 transferring data, sector 2, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 2=0A=
mmcblk0: error -84 transferring data, sector 3, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3=0A=
mmcblk0: error -84 transferring data, sector 4, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 4=0A=
mmcblk0: error -84 transferring data, sector 5, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 5=0A=
mmcblk0: error -84 transferring data, sector 6, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 6=0A=
mmcblk0: error -84 transferring data, sector 7, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 7=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 0, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 0=0A=
mmcblk0: error -84 transferring data, sector 1, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 1=0A=
mmcblk0: error -84 transferring data, sector 2, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 2=0A=
mmcblk0: error -84 transferring data, sector 3, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3=0A=
mmcblk0: error -84 transferring data, sector 4, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 4=0A=
mmcblk0: error -84 transferring data, sector 5, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 5=0A=
mmcblk0: error -84 transferring data, sector 6, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 6=0A=
mmcblk0: error -84 transferring data, sector 7, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 7=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 0, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 0=0A=
mmcblk0: error -84 transferring data, sector 1, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 1=0A=
mmcblk0: error -84 transferring data, sector 2, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 2=0A=
mmcblk0: error -84 transferring data, sector 3, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3=0A=
mmcblk0: error -84 transferring data, sector 4, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 4=0A=
mmcblk0: error -84 transferring data, sector 5, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 5=0A=
mmcblk0: error -84 transferring data, sector 6, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 6=0A=
mmcblk0: error -84 transferring data, sector 7, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 7=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 0, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 0=0A=
mmcblk0: error -84 transferring data, sector 1, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 1=0A=
mmcblk0: error -84 transferring data, sector 2, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 2=0A=
mmcblk0: error -84 transferring data, sector 3, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3=0A=
mmcblk0: error -84 transferring data, sector 4, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 4=0A=
mmcblk0: error -84 transferring data, sector 5, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 5=0A=
mmcblk0: error -84 transferring data, sector 6, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 6=0A=
mmcblk0: error -84 transferring data, sector 7, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 7=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 2048, nr 8, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 2048=0A=
mmcblk0: error -84 transferring data, sector 2049, nr 7, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 2049=0A=
mmcblk0: error -84 transferring data, sector 2050, nr 6, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 2050=0A=
mmcblk0: error -84 transferring data, sector 2051, nr 5, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 2051=0A=
mmcblk0: error -84 transferring data, sector 2052, nr 4, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 2052=0A=
mmcblk0: error -84 transferring data, sector 2053, nr 3, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 2053=0A=
mmcblk0: error -84 transferring data, sector 2054, nr 2, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 2054=0A=
mmcblk0: error -84 transferring data, sector 2055, nr 1, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 2055=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 0, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 0=0A=
mmcblk0: error -84 transferring data, sector 1, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 1=0A=
mmcblk0: error -84 transferring data, sector 2, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 2=0A=
mmcblk0: error -84 transferring data, sector 3, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3=0A=
mmcblk0: error -84 transferring data, sector 4, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 4=0A=
mmcblk0: error -84 transferring data, sector 5, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 5=0A=
mmcblk0: error -84 transferring data, sector 6, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 6=0A=
mmcblk0: error -84 transferring data, sector 7, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 7=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 0, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 0=0A=
mmcblk0: error -84 transferring data, sector 1, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 1=0A=
mmcblk0: error -84 transferring data, sector 2, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 2=0A=
mmcblk0: error -84 transferring data, sector 3, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3=0A=
mmcblk0: error -84 transferring data, sector 4, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 4=0A=
mmcblk0: error -84 transferring data, sector 5, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 5=0A=
mmcblk0: error -84 transferring data, sector 6, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 6=0A=
mmcblk0: error -84 transferring data, sector 7, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 7=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 0, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 0=0A=
mmcblk0: error -84 transferring data, sector 1, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 1=0A=
mmcblk0: error -84 transferring data, sector 2, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 2=0A=
mmcblk0: error -84 transferring data, sector 3, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3=0A=
mmcblk0: error -84 transferring data, sector 4, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 4=0A=
mmcblk0: error -84 transferring data, sector 5, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 5=0A=
mmcblk0: error -84 transferring data, sector 6, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 6=0A=
mmcblk0: error -84 transferring data, sector 7, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 7=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 0, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 0=0A=
mmcblk0: error -84 transferring data, sector 1, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 1=0A=
mmcblk0: error -84 transferring data, sector 2, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 2=0A=
mmcblk0: error -84 transferring data, sector 3, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3=0A=
mmcblk0: error -84 transferring data, sector 4, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 4=0A=
mmcblk0: error -84 transferring data, sector 5, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 5=0A=
mmcblk0: error -84 transferring data, sector 6, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 6=0A=
mmcblk0: error -84 transferring data, sector 7, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 7=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 0, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 0=0A=
mmcblk0: error -84 transferring data, sector 1, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 1=0A=
mmcblk0: error -84 transferring data, sector 2, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 2=0A=
mmcblk0: error -84 transferring data, sector 3, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3=0A=
mmcblk0: error -84 transferring data, sector 4, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 4=0A=
mmcblk0: error -84 transferring data, sector 5, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 5=0A=
mmcblk0: error -84 transferring data, sector 6, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 6=0A=
mmcblk0: error -84 transferring data, sector 7, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 7=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 0, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 0=0A=
mmcblk0: error -84 transferring data, sector 1, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 1=0A=
mmcblk0: error -84 transferring data, sector 2, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 2=0A=
mmcblk0: error -84 transferring data, sector 3, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3=0A=
mmcblk0: error -84 transferring data, sector 4, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 4=0A=
mmcblk0: error -84 transferring data, sector 5, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 5=0A=
mmcblk0: error -84 transferring data, sector 6, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 6=0A=
mmcblk0: error -84 transferring data, sector 7, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 7=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 0, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 0=0A=
mmcblk0: error -84 transferring data, sector 1, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 1=0A=
mmcblk0: error -84 transferring data, sector 2, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 2=0A=
mmcblk0: error -84 transferring data, sector 3, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3=0A=
mmcblk0: error -84 transferring data, sector 4, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 4=0A=
mmcblk0: error -84 transferring data, sector 5, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 5=0A=
mmcblk0: error -84 transferring data, sector 6, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 6=0A=
mmcblk0: error -84 transferring data, sector 7, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 7=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 0, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 0=0A=
mmcblk0: error -84 transferring data, sector 1, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 1=0A=
mmcblk0: error -84 transferring data, sector 2, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 2=0A=
mmcblk0: error -84 transferring data, sector 3, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3=0A=
mmcblk0: error -84 transferring data, sector 4, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 4=0A=
mmcblk0: error -84 transferring data, sector 5, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 5=0A=
mmcblk0: error -84 transferring data, sector 6, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 6=0A=
mmcblk0: error -84 transferring data, sector 7, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 7=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 0, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 0=0A=
mmcblk0: error -84 transferring data, sector 1, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 1=0A=
mmcblk0: error -84 transferring data, sector 2, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 2=0A=
mmcblk0: error -84 transferring data, sector 3, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3=0A=
mmcblk0: error -84 transferring data, sector 4, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 4=0A=
mmcblk0: error -84 transferring data, sector 5, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 5=0A=
mmcblk0: error -84 transferring data, sector 6, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 6=0A=
mmcblk0: error -84 transferring data, sector 7, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 7=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 0, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 0=0A=
mmcblk0: error -84 transferring data, sector 1, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 1=0A=
mmcblk0: error -84 transferring data, sector 2, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 2=0A=
mmcblk0: error -84 transferring data, sector 3, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3=0A=
mmcblk0: error -84 transferring data, sector 4, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 4=0A=
mmcblk0: error -84 transferring data, sector 5, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 5=0A=
mmcblk0: error -84 transferring data, sector 6, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 6=0A=
mmcblk0: error -84 transferring data, sector 7, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 7=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 0, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 0=0A=
mmcblk0: error -84 transferring data, sector 1, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 1=0A=
mmcblk0: error -84 transferring data, sector 2, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 2=0A=
mmcblk0: error -84 transferring data, sector 3, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3=0A=
mmcblk0: error -84 transferring data, sector 4, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 4=0A=
mmcblk0: error -84 transferring data, sector 5, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 5=0A=
mmcblk0: error -84 transferring data, sector 6, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 6=0A=
mmcblk0: error -84 transferring data, sector 7, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 7=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 0, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 0=0A=
mmcblk0: error -84 transferring data, sector 1, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 1=0A=
mmcblk0: error -84 transferring data, sector 2, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 2=0A=
mmcblk0: error -84 transferring data, sector 3, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3=0A=
mmcblk0: error -84 transferring data, sector 4, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 4=0A=
mmcblk0: error -84 transferring data, sector 5, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 5=0A=
mmcblk0: error -84 transferring data, sector 6, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 6=0A=
mmcblk0: error -84 transferring data, sector 7, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 7=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 8, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 8=0A=
mmcblk0: error -84 transferring data, sector 9, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 9=0A=
mmcblk0: error -84 transferring data, sector 10, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 10=0A=
mmcblk0: error -84 transferring data, sector 11, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 11=0A=
mmcblk0: error -84 transferring data, sector 12, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 12=0A=
mmcblk0: error -84 transferring data, sector 13, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 13=0A=
mmcblk0: error -84 transferring data, sector 14, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 14=0A=
mmcblk0: error -84 transferring data, sector 15, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 15=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 8, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 8=0A=
mmcblk0: error -84 transferring data, sector 9, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 9=0A=
mmcblk0: error -84 transferring data, sector 10, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 10=0A=
mmcblk0: error -84 transferring data, sector 11, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 11=0A=
mmcblk0: error -84 transferring data, sector 12, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 12=0A=
mmcblk0: error -84 transferring data, sector 13, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 13=0A=
mmcblk0: error -84 transferring data, sector 14, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 14=0A=
mmcblk0: error -84 transferring data, sector 15, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 15=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 8, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 8=0A=
mmcblk0: error -84 transferring data, sector 9, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 9=0A=
mmcblk0: error -84 transferring data, sector 10, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 10=0A=
mmcblk0: error -84 transferring data, sector 11, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 11=0A=
mmcblk0: error -84 transferring data, sector 12, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 12=0A=
mmcblk0: error -84 transferring data, sector 13, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 13=0A=
mmcblk0: error -84 transferring data, sector 14, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 14=0A=
mmcblk0: error -84 transferring data, sector 15, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 15=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 24, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 24=0A=
mmcblk0: error -84 transferring data, sector 25, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 25=0A=
mmcblk0: error -84 transferring data, sector 26, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 26=0A=
mmcblk0: error -84 transferring data, sector 27, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 27=0A=
mmcblk0: error -84 transferring data, sector 28, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 28=0A=
mmcblk0: error -84 transferring data, sector 29, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 29=0A=
mmcblk0: error -84 transferring data, sector 30, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 30=0A=
mmcblk0: error -84 transferring data, sector 31, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 31=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 24, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 24=0A=
mmcblk0: error -84 transferring data, sector 25, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 25=0A=
mmcblk0: error -84 transferring data, sector 26, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 26=0A=
mmcblk0: error -84 transferring data, sector 27, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 27=0A=
mmcblk0: error -84 transferring data, sector 28, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 28=0A=
mmcblk0: error -84 transferring data, sector 29, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 29=0A=
mmcblk0: error -84 transferring data, sector 30, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 30=0A=
mmcblk0: error -84 transferring data, sector 31, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 31=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 24, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 24=0A=
mmcblk0: error -84 transferring data, sector 25, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 25=0A=
mmcblk0: error -84 transferring data, sector 26, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 26=0A=
mmcblk0: error -84 transferring data, sector 27, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 27=0A=
mmcblk0: error -84 transferring data, sector 28, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 28=0A=
mmcblk0: error -84 transferring data, sector 29, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 29=0A=
mmcblk0: error -84 transferring data, sector 30, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 30=0A=
mmcblk0: error -84 transferring data, sector 31, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 31=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 56, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 56=0A=
mmcblk0: error -84 transferring data, sector 57, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 57=0A=
mmcblk0: error -84 transferring data, sector 58, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 58=0A=
mmcblk0: error -84 transferring data, sector 59, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 59=0A=
mmcblk0: error -84 transferring data, sector 60, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 60=0A=
mmcblk0: error -84 transferring data, sector 61, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 61=0A=
mmcblk0: error -84 transferring data, sector 62, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 62=0A=
mmcblk0: error -84 transferring data, sector 63, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 63=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 56, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 56=0A=
mmcblk0: error -84 transferring data, sector 57, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 57=0A=
mmcblk0: error -84 transferring data, sector 58, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 58=0A=
mmcblk0: error -84 transferring data, sector 59, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 59=0A=
mmcblk0: error -84 transferring data, sector 60, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 60=0A=
mmcblk0: error -84 transferring data, sector 61, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 61=0A=
mmcblk0: error -84 transferring data, sector 62, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 62=0A=
mmcblk0: error -84 transferring data, sector 63, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 63=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 56, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 56=0A=
mmcblk0: error -84 transferring data, sector 57, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 57=0A=
mmcblk0: error -84 transferring data, sector 58, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 58=0A=
mmcblk0: error -84 transferring data, sector 59, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 59=0A=
mmcblk0: error -84 transferring data, sector 60, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 60=0A=
mmcblk0: error -84 transferring data, sector 61, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 61=0A=
mmcblk0: error -84 transferring data, sector 62, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 62=0A=
mmcblk0: error -84 transferring data, sector 63, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 63=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 120, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 120=0A=
mmcblk0: error -84 transferring data, sector 121, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 121=0A=
mmcblk0: error -84 transferring data, sector 122, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 122=0A=
mmcblk0: error -84 transferring data, sector 123, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 123=0A=
mmcblk0: error -84 transferring data, sector 124, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 124=0A=
mmcblk0: error -84 transferring data, sector 125, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 125=0A=
mmcblk0: error -84 transferring data, sector 126, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 126=0A=
mmcblk0: error -84 transferring data, sector 127, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 127=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 120, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 120=0A=
mmcblk0: error -84 transferring data, sector 121, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 121=0A=
mmcblk0: error -84 transferring data, sector 122, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 122=0A=
mmcblk0: error -84 transferring data, sector 123, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 123=0A=
mmcblk0: error -84 transferring data, sector 124, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 124=0A=
mmcblk0: error -84 transferring data, sector 125, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 125=0A=
mmcblk0: error -84 transferring data, sector 126, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 126=0A=
mmcblk0: error -84 transferring data, sector 127, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 127=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 120, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 120=0A=
mmcblk0: error -84 transferring data, sector 121, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 121=0A=
mmcblk0: error -84 transferring data, sector 122, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 122=0A=
mmcblk0: error -84 transferring data, sector 123, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 123=0A=
mmcblk0: error -84 transferring data, sector 124, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 124=0A=
mmcblk0: error -84 transferring data, sector 125, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 125=0A=
mmcblk0: error -84 transferring data, sector 126, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 126=0A=
mmcblk0: error -84 transferring data, sector 127, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 127=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 0, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 0=0A=
mmcblk0: error -84 transferring data, sector 1, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 1=0A=
mmcblk0: error -84 transferring data, sector 2, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 2=0A=
mmcblk0: error -84 transferring data, sector 3, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3=0A=
mmcblk0: error -84 transferring data, sector 4, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 4=0A=
mmcblk0: error -84 transferring data, sector 5, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 5=0A=
mmcblk0: error -84 transferring data, sector 6, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 6=0A=
mmcblk0: error -84 transferring data, sector 7, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 7=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 0, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 0=0A=
mmcblk0: error -84 transferring data, sector 1, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 1=0A=
mmcblk0: error -84 transferring data, sector 2, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 2=0A=
mmcblk0: error -84 transferring data, sector 3, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3=0A=
mmcblk0: error -84 transferring data, sector 4, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 4=0A=
mmcblk0: error -84 transferring data, sector 5, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 5=0A=
mmcblk0: error -84 transferring data, sector 6, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 6=0A=
mmcblk0: error -84 transferring data, sector 7, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 7=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 8, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 8=0A=
mmcblk0: error -84 transferring data, sector 9, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 9=0A=
mmcblk0: error -84 transferring data, sector 10, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 10=0A=
mmcblk0: error -84 transferring data, sector 11, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 11=0A=
mmcblk0: error -84 transferring data, sector 12, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 12=0A=
mmcblk0: error -84 transferring data, sector 13, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 13=0A=
mmcblk0: error -84 transferring data, sector 14, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 14=0A=
mmcblk0: error -84 transferring data, sector 15, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 15=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 8, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 8=0A=
mmcblk0: error -84 transferring data, sector 9, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 9=0A=
mmcblk0: error -84 transferring data, sector 10, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 10=0A=
mmcblk0: error -84 transferring data, sector 11, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 11=0A=
mmcblk0: error -84 transferring data, sector 12, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 12=0A=
mmcblk0: error -84 transferring data, sector 13, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 13=0A=
mmcblk0: error -84 transferring data, sector 14, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 14=0A=
mmcblk0: error -84 transferring data, sector 15, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 15=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 24, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 24=0A=
mmcblk0: error -84 transferring data, sector 25, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 25=0A=
mmcblk0: error -84 transferring data, sector 26, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 26=0A=
mmcblk0: error -84 transferring data, sector 27, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 27=0A=
mmcblk0: error -84 transferring data, sector 28, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 28=0A=
mmcblk0: error -84 transferring data, sector 29, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 29=0A=
mmcblk0: error -84 transferring data, sector 30, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 30=0A=
mmcblk0: error -84 transferring data, sector 31, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 31=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 24, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 24=0A=
mmcblk0: error -84 transferring data, sector 25, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 25=0A=
mmcblk0: error -84 transferring data, sector 26, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 26=0A=
mmcblk0: error -84 transferring data, sector 27, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 27=0A=
mmcblk0: error -84 transferring data, sector 28, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 28=0A=
mmcblk0: error -84 transferring data, sector 29, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 29=0A=
mmcblk0: error -84 transferring data, sector 30, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 30=0A=
mmcblk0: error -84 transferring data, sector 31, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 31=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 56, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 56=0A=
mmcblk0: error -84 transferring data, sector 57, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 57=0A=
mmcblk0: error -84 transferring data, sector 58, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 58=0A=
mmcblk0: error -84 transferring data, sector 59, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 59=0A=
mmcblk0: error -84 transferring data, sector 60, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 60=0A=
mmcblk0: error -84 transferring data, sector 61, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 61=0A=
mmcblk0: error -84 transferring data, sector 62, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 62=0A=
mmcblk0: error -84 transferring data, sector 63, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 63=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 56, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 56=0A=
mmcblk0: error -84 transferring data, sector 57, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 57=0A=
mmcblk0: error -84 transferring data, sector 58, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 58=0A=
mmcblk0: error -84 transferring data, sector 59, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 59=0A=
mmcblk0: error -84 transferring data, sector 60, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 60=0A=
mmcblk0: error -84 transferring data, sector 61, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 61=0A=
mmcblk0: error -84 transferring data, sector 62, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 62=0A=
mmcblk0: error -84 transferring data, sector 63, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 63=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 120, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 120=0A=
mmcblk0: error -84 transferring data, sector 121, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 121=0A=
mmcblk0: error -84 transferring data, sector 122, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 122=0A=
mmcblk0: error -84 transferring data, sector 123, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 123=0A=
mmcblk0: error -84 transferring data, sector 124, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 124=0A=
mmcblk0: error -84 transferring data, sector 125, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 125=0A=
mmcblk0: error -84 transferring data, sector 126, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 126=0A=
mmcblk0: error -84 transferring data, sector 127, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 127=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 120, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 120=0A=
mmcblk0: error -84 transferring data, sector 121, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 121=0A=
mmcblk0: error -84 transferring data, sector 122, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 122=0A=
mmcblk0: error -84 transferring data, sector 123, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 123=0A=
mmcblk0: error -84 transferring data, sector 124, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 124=0A=
mmcblk0: error -84 transferring data, sector 125, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 125=0A=
mmcblk0: error -84 transferring data, sector 126, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 126=0A=
mmcblk0: error -84 transferring data, sector 127, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 127=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 0, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 0=0A=
mmcblk0: error -84 transferring data, sector 1, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 1=0A=
mmcblk0: error -84 transferring data, sector 2, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 2=0A=
mmcblk0: error -84 transferring data, sector 3, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3=0A=
mmcblk0: error -84 transferring data, sector 4, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 4=0A=
mmcblk0: error -84 transferring data, sector 5, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 5=0A=
mmcblk0: error -84 transferring data, sector 6, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 6=0A=
mmcblk0: error -84 transferring data, sector 7, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 7=0A=
quiet_error: 204 callbacks suppressed=0A=
Buffer I/O error on device mmcblk0, logical block 0=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 0, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 0=0A=
mmcblk0: error -84 transferring data, sector 1, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 1=0A=
mmcblk0: error -84 transferring data, sector 2, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 2=0A=
mmcblk0: error -84 transferring data, sector 3, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3=0A=
mmcblk0: error -84 transferring data, sector 4, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 4=0A=
mmcblk0: error -84 transferring data, sector 5, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 5=0A=
mmcblk0: error -84 transferring data, sector 6, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 6=0A=
mmcblk0: error -84 transferring data, sector 7, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 7=0A=
Buffer I/O error on device mmcblk0, logical block 0=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 0, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 0=0A=
mmcblk0: error -84 transferring data, sector 1, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 1=0A=
mmcblk0: error -84 transferring data, sector 2, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 2=0A=
mmcblk0: error -84 transferring data, sector 3, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3=0A=
mmcblk0: error -84 transferring data, sector 4, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 4=0A=
mmcblk0: error -84 transferring data, sector 5, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 5=0A=
mmcblk0: error -84 transferring data, sector 6, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 6=0A=
mmcblk0: error -84 transferring data, sector 7, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 7=0A=
Buffer I/O error on device mmcblk0, logical block 0=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 0, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 0=0A=
mmcblk0: error -84 transferring data, sector 1, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 1=0A=
mmcblk0: error -84 transferring data, sector 2, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 2=0A=
mmcblk0: error -84 transferring data, sector 3, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3=0A=
mmcblk0: error -84 transferring data, sector 4, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 4=0A=
mmcblk0: error -84 transferring data, sector 5, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 5=0A=
mmcblk0: error -84 transferring data, sector 6, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 6=0A=
mmcblk0: error -84 transferring data, sector 7, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 7=0A=
Buffer I/O error on device mmcblk0, logical block 0=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 0, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 0=0A=
mmcblk0: error -84 transferring data, sector 1, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 1=0A=
mmcblk0: error -84 transferring data, sector 2, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 2=0A=
mmcblk0: error -84 transferring data, sector 3, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3=0A=
mmcblk0: error -84 transferring data, sector 4, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 4=0A=
mmcblk0: error -84 transferring data, sector 5, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 5=0A=
mmcblk0: error -84 transferring data, sector 6, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 6=0A=
mmcblk0: error -84 transferring data, sector 7, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 7=0A=
Buffer I/O error on device mmcblk0, logical block 0=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 0, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 0=0A=
mmcblk0: error -84 transferring data, sector 1, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 1=0A=
mmcblk0: error -84 transferring data, sector 2, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 2=0A=
mmcblk0: error -84 transferring data, sector 3, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3=0A=
mmcblk0: error -84 transferring data, sector 4, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 4=0A=
mmcblk0: error -84 transferring data, sector 5, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 5=0A=
mmcblk0: error -84 transferring data, sector 6, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 6=0A=
mmcblk0: error -84 transferring data, sector 7, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 7=0A=
Buffer I/O error on device mmcblk0, logical block 0=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 16, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 16=0A=
mmcblk0: error -84 transferring data, sector 17, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 17=0A=
mmcblk0: error -84 transferring data, sector 18, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 18=0A=
mmcblk0: error -84 transferring data, sector 19, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 19=0A=
mmcblk0: error -84 transferring data, sector 20, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 20=0A=
mmcblk0: error -84 transferring data, sector 21, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 21=0A=
mmcblk0: error -84 transferring data, sector 22, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 22=0A=
mmcblk0: error -84 transferring data, sector 23, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 23=0A=
Buffer I/O error on device mmcblk0, logical block 2=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 128, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 128=0A=
mmcblk0: error -84 transferring data, sector 129, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 129=0A=
mmcblk0: error -84 transferring data, sector 130, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 130=0A=
mmcblk0: error -84 transferring data, sector 131, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 131=0A=
mmcblk0: error -84 transferring data, sector 132, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 132=0A=
mmcblk0: error -84 transferring data, sector 133, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 133=0A=
mmcblk0: error -84 transferring data, sector 134, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 134=0A=
mmcblk0: error -84 transferring data, sector 135, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 135=0A=
Buffer I/O error on device mmcblk0, logical block 16=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 128, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 128=0A=
mmcblk0: error -84 transferring data, sector 129, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 129=0A=
mmcblk0: error -84 transferring data, sector 130, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 130=0A=
mmcblk0: error -84 transferring data, sector 131, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 131=0A=
mmcblk0: error -84 transferring data, sector 132, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 132=0A=
mmcblk0: error -84 transferring data, sector 133, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 133=0A=
mmcblk0: error -84 transferring data, sector 134, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 134=0A=
mmcblk0: error -84 transferring data, sector 135, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 135=0A=
Buffer I/O error on device mmcblk0, logical block 16=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 128, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 128=0A=
mmcblk0: error -84 transferring data, sector 129, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 129=0A=
mmcblk0: error -84 transferring data, sector 130, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 130=0A=
mmcblk0: error -84 transferring data, sector 131, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 131=0A=
mmcblk0: error -84 transferring data, sector 132, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 132=0A=
mmcblk0: error -84 transferring data, sector 133, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 133=0A=
mmcblk0: error -84 transferring data, sector 134, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 134=0A=
mmcblk0: error -84 transferring data, sector 135, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 135=0A=
Buffer I/O error on device mmcblk0, logical block 16=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 16, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 16=0A=
mmcblk0: error -84 transferring data, sector 17, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 17=0A=
mmcblk0: error -84 transferring data, sector 18, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 18=0A=
mmcblk0: error -84 transferring data, sector 19, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 19=0A=
mmcblk0: error -84 transferring data, sector 20, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 20=0A=
mmcblk0: error -84 transferring data, sector 21, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 21=0A=
mmcblk0: error -84 transferring data, sector 22, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 22=0A=
mmcblk0: error -84 transferring data, sector 23, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 23=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 128, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 128=0A=
mmcblk0: error -84 transferring data, sector 129, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 129=0A=
mmcblk0: error -84 transferring data, sector 130, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 130=0A=
mmcblk0: error -84 transferring data, sector 131, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 131=0A=
mmcblk0: error -84 transferring data, sector 132, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 132=0A=
mmcblk0: error -84 transferring data, sector 133, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 133=0A=
mmcblk0: error -84 transferring data, sector 134, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 134=0A=
mmcblk0: error -84 transferring data, sector 135, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 135=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 64, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 64=0A=
mmcblk0: error -84 transferring data, sector 65, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 65=0A=
mmcblk0: error -84 transferring data, sector 66, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 66=0A=
mmcblk0: error -84 transferring data, sector 67, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 67=0A=
mmcblk0: error -84 transferring data, sector 68, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 68=0A=
mmcblk0: error -84 transferring data, sector 69, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 69=0A=
mmcblk0: error -84 transferring data, sector 70, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 70=0A=
mmcblk0: error -84 transferring data, sector 71, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 71=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 64, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 64=0A=
mmcblk0: error -84 transferring data, sector 65, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 65=0A=
mmcblk0: error -84 transferring data, sector 66, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 66=0A=
mmcblk0: error -84 transferring data, sector 67, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 67=0A=
mmcblk0: error -84 transferring data, sector 68, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 68=0A=
mmcblk0: error -84 transferring data, sector 69, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 69=0A=
mmcblk0: error -84 transferring data, sector 70, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 70=0A=
mmcblk0: error -84 transferring data, sector 71, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 71=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 64, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 64=0A=
mmcblk0: error -84 transferring data, sector 65, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 65=0A=
mmcblk0: error -84 transferring data, sector 66, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 66=0A=
mmcblk0: error -84 transferring data, sector 67, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 67=0A=
mmcblk0: error -84 transferring data, sector 68, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 68=0A=
mmcblk0: error -84 transferring data, sector 69, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 69=0A=
mmcblk0: error -84 transferring data, sector 70, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 70=0A=
mmcblk0: error -84 transferring data, sector 71, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 71=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 64, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 64=0A=
mmcblk0: error -84 transferring data, sector 65, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 65=0A=
mmcblk0: error -84 transferring data, sector 66, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 66=0A=
mmcblk0: error -84 transferring data, sector 67, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 67=0A=
mmcblk0: error -84 transferring data, sector 68, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 68=0A=
mmcblk0: error -84 transferring data, sector 69, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 69=0A=
mmcblk0: error -84 transferring data, sector 70, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 70=0A=
mmcblk0: error -84 transferring data, sector 71, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 71=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 64, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 64=0A=
mmcblk0: error -84 transferring data, sector 65, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 65=0A=
mmcblk0: error -84 transferring data, sector 66, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 66=0A=
mmcblk0: error -84 transferring data, sector 67, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 67=0A=
mmcblk0: error -84 transferring data, sector 68, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 68=0A=
mmcblk0: error -84 transferring data, sector 69, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 69=0A=
mmcblk0: error -84 transferring data, sector 70, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 70=0A=
mmcblk0: error -84 transferring data, sector 71, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 71=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 64, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 64=0A=
mmcblk0: error -84 transferring data, sector 65, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 65=0A=
mmcblk0: error -84 transferring data, sector 66, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 66=0A=
mmcblk0: error -84 transferring data, sector 67, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 67=0A=
mmcblk0: error -84 transferring data, sector 68, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 68=0A=
mmcblk0: error -84 transferring data, sector 69, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 69=0A=
mmcblk0: error -84 transferring data, sector 70, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 70=0A=
mmcblk0: error -84 transferring data, sector 71, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 71=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 64, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 64=0A=
mmcblk0: error -84 transferring data, sector 65, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 65=0A=
mmcblk0: error -84 transferring data, sector 66, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 66=0A=
mmcblk0: error -84 transferring data, sector 67, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 67=0A=
mmcblk0: error -84 transferring data, sector 68, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 68=0A=
mmcblk0: error -84 transferring data, sector 69, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 69=0A=
mmcblk0: error -84 transferring data, sector 70, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 70=0A=
mmcblk0: error -84 transferring data, sector 71, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 71=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 64, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 64=0A=
mmcblk0: error -84 transferring data, sector 65, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 65=0A=
mmcblk0: error -84 transferring data, sector 66, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 66=0A=
mmcblk0: error -84 transferring data, sector 67, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 67=0A=
mmcblk0: error -84 transferring data, sector 68, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 68=0A=
mmcblk0: error -84 transferring data, sector 69, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 69=0A=
mmcblk0: error -84 transferring data, sector 70, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 70=0A=
mmcblk0: error -84 transferring data, sector 71, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 71=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 64, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 64=0A=
mmcblk0: error -84 transferring data, sector 65, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 65=0A=
mmcblk0: error -84 transferring data, sector 66, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 66=0A=
mmcblk0: error -84 transferring data, sector 67, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 67=0A=
mmcblk0: error -84 transferring data, sector 68, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 68=0A=
mmcblk0: error -84 transferring data, sector 69, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 69=0A=
mmcblk0: error -84 transferring data, sector 70, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 70=0A=
mmcblk0: error -84 transferring data, sector 71, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 71=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 64, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 64=0A=
mmcblk0: error -84 transferring data, sector 65, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 65=0A=
mmcblk0: error -84 transferring data, sector 66, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 66=0A=
mmcblk0: error -84 transferring data, sector 67, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 67=0A=
mmcblk0: error -84 transferring data, sector 68, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 68=0A=
mmcblk0: error -84 transferring data, sector 69, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 69=0A=
mmcblk0: error -84 transferring data, sector 70, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 70=0A=
mmcblk0: error -84 transferring data, sector 71, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 71=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 256, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 256=0A=
mmcblk0: error -84 transferring data, sector 257, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 257=0A=
mmcblk0: error -84 transferring data, sector 258, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 258=0A=
mmcblk0: error -84 transferring data, sector 259, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 259=0A=
mmcblk0: error -84 transferring data, sector 260, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 260=0A=
mmcblk0: error -84 transferring data, sector 261, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 261=0A=
mmcblk0: error -84 transferring data, sector 262, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 262=0A=
mmcblk0: error -84 transferring data, sector 263, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 263=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 0, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 0=0A=
mmcblk0: error -84 transferring data, sector 1, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 1=0A=
mmcblk0: error -84 transferring data, sector 2, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 2=0A=
mmcblk0: error -84 transferring data, sector 3, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3=0A=
mmcblk0: error -84 transferring data, sector 4, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 4=0A=
mmcblk0: error -84 transferring data, sector 5, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 5=0A=
mmcblk0: error -84 transferring data, sector 6, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 6=0A=
mmcblk0: error -84 transferring data, sector 7, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 7=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 0, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 0=0A=
mmcblk0: error -84 transferring data, sector 1, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 1=0A=
mmcblk0: error -84 transferring data, sector 2, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 2=0A=
mmcblk0: error -84 transferring data, sector 3, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3=0A=
mmcblk0: error -84 transferring data, sector 4, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 4=0A=
mmcblk0: error -84 transferring data, sector 5, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 5=0A=
mmcblk0: error -84 transferring data, sector 6, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 6=0A=
mmcblk0: error -84 transferring data, sector 7, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 7=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 0, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 0=0A=
mmcblk0: error -84 transferring data, sector 1, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 1=0A=
mmcblk0: error -84 transferring data, sector 2, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 2=0A=
mmcblk0: error -84 transferring data, sector 3, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3=0A=
mmcblk0: error -84 transferring data, sector 4, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 4=0A=
mmcblk0: error -84 transferring data, sector 5, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 5=0A=
mmcblk0: error -84 transferring data, sector 6, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 6=0A=
mmcblk0: error -84 transferring data, sector 7, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 7=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 0, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 0=0A=
mmcblk0: error -84 transferring data, sector 1, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 1=0A=
mmcblk0: error -84 transferring data, sector 2, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 2=0A=
mmcblk0: error -84 transferring data, sector 3, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3=0A=
mmcblk0: error -84 transferring data, sector 4, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 4=0A=
mmcblk0: error -84 transferring data, sector 5, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 5=0A=
mmcblk0: error -84 transferring data, sector 6, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 6=0A=
mmcblk0: error -84 transferring data, sector 7, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 7=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 0, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 0=0A=
mmcblk0: error -84 transferring data, sector 1, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 1=0A=
mmcblk0: error -84 transferring data, sector 2, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 2=0A=
mmcblk0: error -84 transferring data, sector 3, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3=0A=
mmcblk0: error -84 transferring data, sector 4, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 4=0A=
mmcblk0: error -84 transferring data, sector 5, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 5=0A=
mmcblk0: error -84 transferring data, sector 6, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 6=0A=
mmcblk0: error -84 transferring data, sector 7, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 7=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 16, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 16=0A=
mmcblk0: error -84 transferring data, sector 17, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 17=0A=
mmcblk0: error -84 transferring data, sector 18, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 18=0A=
mmcblk0: error -84 transferring data, sector 19, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 19=0A=
mmcblk0: error -84 transferring data, sector 20, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 20=0A=
mmcblk0: error -84 transferring data, sector 21, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 21=0A=
mmcblk0: error -84 transferring data, sector 22, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 22=0A=
mmcblk0: error -84 transferring data, sector 23, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 23=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 0, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 0=0A=
mmcblk0: error -84 transferring data, sector 1, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 1=0A=
mmcblk0: error -84 transferring data, sector 2, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 2=0A=
mmcblk0: error -84 transferring data, sector 3, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3=0A=
mmcblk0: error -84 transferring data, sector 4, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 4=0A=
mmcblk0: error -84 transferring data, sector 5, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 5=0A=
mmcblk0: error -84 transferring data, sector 6, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 6=0A=
mmcblk0: error -84 transferring data, sector 7, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 7=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 0, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 0=0A=
mmcblk0: error -84 transferring data, sector 1, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 1=0A=
mmcblk0: error -84 transferring data, sector 2, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 2=0A=
mmcblk0: error -84 transferring data, sector 3, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3=0A=
mmcblk0: error -84 transferring data, sector 4, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 4=0A=
mmcblk0: error -84 transferring data, sector 5, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 5=0A=
mmcblk0: error -84 transferring data, sector 6, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 6=0A=
mmcblk0: error -84 transferring data, sector 7, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 7=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 0, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 0=0A=
mmcblk0: error -84 transferring data, sector 1, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 1=0A=
mmcblk0: error -84 transferring data, sector 2, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 2=0A=
mmcblk0: error -84 transferring data, sector 3, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3=0A=
mmcblk0: error -84 transferring data, sector 4, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 4=0A=
mmcblk0: error -84 transferring data, sector 5, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 5=0A=
mmcblk0: error -84 transferring data, sector 6, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 6=0A=
mmcblk0: error -84 transferring data, sector 7, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 7=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 0, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 0=0A=
mmcblk0: error -84 transferring data, sector 1, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 1=0A=
mmcblk0: error -84 transferring data, sector 2, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 2=0A=
mmcblk0: error -84 transferring data, sector 3, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3=0A=
mmcblk0: error -84 transferring data, sector 4, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 4=0A=
mmcblk0: error -84 transferring data, sector 5, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 5=0A=
mmcblk0: error -84 transferring data, sector 6, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 6=0A=
mmcblk0: error -84 transferring data, sector 7, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 7=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 0, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 0=0A=
mmcblk0: error -84 transferring data, sector 1, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 1=0A=
mmcblk0: error -84 transferring data, sector 2, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 2=0A=
mmcblk0: error -84 transferring data, sector 3, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3=0A=
mmcblk0: error -84 transferring data, sector 4, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 4=0A=
mmcblk0: error -84 transferring data, sector 5, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 5=0A=
mmcblk0: error -84 transferring data, sector 6, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 6=0A=
mmcblk0: error -84 transferring data, sector 7, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 7=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 0, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 0=0A=
mmcblk0: error -84 transferring data, sector 1, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 1=0A=
mmcblk0: error -84 transferring data, sector 2, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 2=0A=
mmcblk0: error -84 transferring data, sector 3, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3=0A=
mmcblk0: error -84 transferring data, sector 4, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 4=0A=
mmcblk0: error -84 transferring data, sector 5, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 5=0A=
mmcblk0: error -84 transferring data, sector 6, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 6=0A=
mmcblk0: error -84 transferring data, sector 7, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 7=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 0, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 0=0A=
mmcblk0: error -84 transferring data, sector 1, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 1=0A=
mmcblk0: error -84 transferring data, sector 2, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 2=0A=
mmcblk0: error -84 transferring data, sector 3, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3=0A=
mmcblk0: error -84 transferring data, sector 4, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 4=0A=
mmcblk0: error -84 transferring data, sector 5, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 5=0A=
mmcblk0: error -84 transferring data, sector 6, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 6=0A=
mmcblk0: error -84 transferring data, sector 7, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 7=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 0, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 0=0A=
mmcblk0: error -84 transferring data, sector 1, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 1=0A=
mmcblk0: error -84 transferring data, sector 2, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 2=0A=
mmcblk0: error -84 transferring data, sector 3, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3=0A=
mmcblk0: error -84 transferring data, sector 4, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 4=0A=
mmcblk0: error -84 transferring data, sector 5, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 5=0A=
mmcblk0: error -84 transferring data, sector 6, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 6=0A=
mmcblk0: error -84 transferring data, sector 7, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 7=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 0, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 0=0A=
mmcblk0: error -84 transferring data, sector 1, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 1=0A=
mmcblk0: error -84 transferring data, sector 2, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 2=0A=
mmcblk0: error -84 transferring data, sector 3, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3=0A=
mmcblk0: error -84 transferring data, sector 4, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 4=0A=
mmcblk0: error -84 transferring data, sector 5, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 5=0A=
mmcblk0: error -84 transferring data, sector 6, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 6=0A=
mmcblk0: error -84 transferring data, sector 7, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 7=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 0, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 0=0A=
mmcblk0: error -84 transferring data, sector 1, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 1=0A=
mmcblk0: error -84 transferring data, sector 2, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 2=0A=
mmcblk0: error -84 transferring data, sector 3, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3=0A=
mmcblk0: error -84 transferring data, sector 4, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 4=0A=
mmcblk0: error -84 transferring data, sector 5, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 5=0A=
mmcblk0: error -84 transferring data, sector 6, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 6=0A=
mmcblk0: error -84 transferring data, sector 7, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 7=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 0, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 0=0A=
mmcblk0: error -84 transferring data, sector 1, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 1=0A=
mmcblk0: error -84 transferring data, sector 2, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 2=0A=
mmcblk0: error -84 transferring data, sector 3, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3=0A=
mmcblk0: error -84 transferring data, sector 4, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 4=0A=
mmcblk0: error -84 transferring data, sector 5, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 5=0A=
mmcblk0: error -84 transferring data, sector 6, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 6=0A=
mmcblk0: error -84 transferring data, sector 7, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 7=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 0, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 0=0A=
mmcblk0: error -84 transferring data, sector 1, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 1=0A=
mmcblk0: error -84 transferring data, sector 2, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 2=0A=
mmcblk0: error -84 transferring data, sector 3, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3=0A=
mmcblk0: error -84 transferring data, sector 4, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 4=0A=
mmcblk0: error -84 transferring data, sector 5, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 5=0A=
mmcblk0: error -84 transferring data, sector 6, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 6=0A=
mmcblk0: error -84 transferring data, sector 7, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 7=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 128, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 128=0A=
mmcblk0: error -84 transferring data, sector 129, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 129=0A=
mmcblk0: error -84 transferring data, sector 130, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 130=0A=
mmcblk0: error -84 transferring data, sector 131, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 131=0A=
mmcblk0: error -84 transferring data, sector 132, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 132=0A=
mmcblk0: error -84 transferring data, sector 133, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 133=0A=
mmcblk0: error -84 transferring data, sector 134, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 134=0A=
mmcblk0: error -84 transferring data, sector 135, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 135=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 128, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 128=0A=
mmcblk0: error -84 transferring data, sector 129, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 129=0A=
mmcblk0: error -84 transferring data, sector 130, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 130=0A=
mmcblk0: error -84 transferring data, sector 131, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 131=0A=
mmcblk0: error -84 transferring data, sector 132, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 132=0A=
mmcblk0: error -84 transferring data, sector 133, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 133=0A=
mmcblk0: error -84 transferring data, sector 134, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 134=0A=
mmcblk0: error -84 transferring data, sector 135, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 135=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 16, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 16=0A=
mmcblk0: error -84 transferring data, sector 17, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 17=0A=
mmcblk0: error -84 transferring data, sector 18, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 18=0A=
mmcblk0: error -84 transferring data, sector 19, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 19=0A=
mmcblk0: error -84 transferring data, sector 20, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 20=0A=
mmcblk0: error -84 transferring data, sector 21, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 21=0A=
mmcblk0: error -84 transferring data, sector 22, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 22=0A=
mmcblk0: error -84 transferring data, sector 23, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 23=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 0, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 0=0A=
mmcblk0: error -84 transferring data, sector 1, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 1=0A=
mmcblk0: error -84 transferring data, sector 2, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 2=0A=
mmcblk0: error -84 transferring data, sector 3, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3=0A=
mmcblk0: error -84 transferring data, sector 4, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 4=0A=
mmcblk0: error -84 transferring data, sector 5, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 5=0A=
mmcblk0: error -84 transferring data, sector 6, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 6=0A=
mmcblk0: error -84 transferring data, sector 7, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 7=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 0, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 0=0A=
mmcblk0: error -84 transferring data, sector 1, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 1=0A=
mmcblk0: error -84 transferring data, sector 2, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 2=0A=
mmcblk0: error -84 transferring data, sector 3, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3=0A=
mmcblk0: error -84 transferring data, sector 4, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 4=0A=
mmcblk0: error -84 transferring data, sector 5, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 5=0A=
mmcblk0: error -84 transferring data, sector 6, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 6=0A=
mmcblk0: error -84 transferring data, sector 7, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 7=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 8, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 8=0A=
mmcblk0: error -84 transferring data, sector 9, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 9=0A=
mmcblk0: error -84 transferring data, sector 10, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 10=0A=
mmcblk0: error -84 transferring data, sector 11, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 11=0A=
mmcblk0: error -84 transferring data, sector 12, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 12=0A=
mmcblk0: error -84 transferring data, sector 13, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 13=0A=
mmcblk0: error -84 transferring data, sector 14, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 14=0A=
mmcblk0: error -84 transferring data, sector 15, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 15=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 16, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 16=0A=
mmcblk0: error -84 transferring data, sector 17, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 17=0A=
mmcblk0: error -84 transferring data, sector 18, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 18=0A=
mmcblk0: error -84 transferring data, sector 19, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 19=0A=
mmcblk0: error -84 transferring data, sector 20, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 20=0A=
mmcblk0: error -84 transferring data, sector 21, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 21=0A=
mmcblk0: error -84 transferring data, sector 22, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 22=0A=
mmcblk0: error -84 transferring data, sector 23, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 23=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 0, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 0=0A=
mmcblk0: error -84 transferring data, sector 1, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 1=0A=
mmcblk0: error -84 transferring data, sector 2, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 2=0A=
mmcblk0: error -84 transferring data, sector 3, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3=0A=
mmcblk0: error -84 transferring data, sector 4, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 4=0A=
mmcblk0: error -84 transferring data, sector 5, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 5=0A=
mmcblk0: error -84 transferring data, sector 6, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 6=0A=
mmcblk0: error -84 transferring data, sector 7, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 7=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 0, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 0=0A=
mmcblk0: error -84 transferring data, sector 1, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 1=0A=
mmcblk0: error -84 transferring data, sector 2, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 2=0A=
mmcblk0: error -84 transferring data, sector 3, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3=0A=
mmcblk0: error -84 transferring data, sector 4, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 4=0A=
mmcblk0: error -84 transferring data, sector 5, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 5=0A=
mmcblk0: error -84 transferring data, sector 6, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 6=0A=
mmcblk0: error -84 transferring data, sector 7, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 7=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 0, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 0=0A=
mmcblk0: error -84 transferring data, sector 1, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 1=0A=
mmcblk0: error -84 transferring data, sector 2, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 2=0A=
mmcblk0: error -84 transferring data, sector 3, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3=0A=
mmcblk0: error -84 transferring data, sector 4, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 4=0A=
mmcblk0: error -84 transferring data, sector 5, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 5=0A=
mmcblk0: error -84 transferring data, sector 6, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 6=0A=
mmcblk0: error -84 transferring data, sector 7, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 7=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 0, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 0=0A=
mmcblk0: error -84 transferring data, sector 1, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 1=0A=
mmcblk0: error -84 transferring data, sector 2, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 2=0A=
mmcblk0: error -84 transferring data, sector 3, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3=0A=
mmcblk0: error -84 transferring data, sector 4, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 4=0A=
mmcblk0: error -84 transferring data, sector 5, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 5=0A=
mmcblk0: error -84 transferring data, sector 6, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 6=0A=
mmcblk0: error -84 transferring data, sector 7, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 7=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 0, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 0=0A=
mmcblk0: error -84 transferring data, sector 1, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 1=0A=
mmcblk0: error -84 transferring data, sector 2, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 2=0A=
mmcblk0: error -84 transferring data, sector 3, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3=0A=
mmcblk0: error -84 transferring data, sector 4, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 4=0A=
mmcblk0: error -84 transferring data, sector 5, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 5=0A=
mmcblk0: error -84 transferring data, sector 6, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 6=0A=
mmcblk0: error -84 transferring data, sector 7, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 7=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 0, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 0=0A=
mmcblk0: error -84 transferring data, sector 1, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 1=0A=
mmcblk0: error -84 transferring data, sector 2, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 2=0A=
mmcblk0: error -84 transferring data, sector 3, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3=0A=
mmcblk0: error -84 transferring data, sector 4, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 4=0A=
mmcblk0: error -84 transferring data, sector 5, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 5=0A=
mmcblk0: error -84 transferring data, sector 6, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 6=0A=
mmcblk0: error -84 transferring data, sector 7, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 7=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 8, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 8=0A=
mmcblk0: error -84 transferring data, sector 9, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 9=0A=
mmcblk0: error -84 transferring data, sector 10, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 10=0A=
mmcblk0: error -84 transferring data, sector 11, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 11=0A=
mmcblk0: error -84 transferring data, sector 12, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 12=0A=
mmcblk0: error -84 transferring data, sector 13, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 13=0A=
mmcblk0: error -84 transferring data, sector 14, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 14=0A=
mmcblk0: error -84 transferring data, sector 15, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 15=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 128, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 128=0A=
mmcblk0: error -84 transferring data, sector 129, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 129=0A=
mmcblk0: error -84 transferring data, sector 130, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 130=0A=
mmcblk0: error -84 transferring data, sector 131, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 131=0A=
mmcblk0: error -84 transferring data, sector 132, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 132=0A=
mmcblk0: error -84 transferring data, sector 133, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 133=0A=
mmcblk0: error -84 transferring data, sector 134, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 134=0A=
mmcblk0: error -84 transferring data, sector 135, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 135=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 0, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 0=0A=
mmcblk0: error -84 transferring data, sector 1, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 1=0A=
mmcblk0: error -84 transferring data, sector 2, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 2=0A=
mmcblk0: error -84 transferring data, sector 3, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3=0A=
mmcblk0: error -84 transferring data, sector 4, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 4=0A=
mmcblk0: error -84 transferring data, sector 5, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 5=0A=
mmcblk0: error -84 transferring data, sector 6, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 6=0A=
mmcblk0: error -84 transferring data, sector 7, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 7=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 0, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 0=0A=
mmcblk0: error -84 transferring data, sector 1, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 1=0A=
mmcblk0: error -84 transferring data, sector 2, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 2=0A=
mmcblk0: error -84 transferring data, sector 3, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3=0A=
mmcblk0: error -84 transferring data, sector 4, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 4=0A=
mmcblk0: error -84 transferring data, sector 5, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 5=0A=
mmcblk0: error -84 transferring data, sector 6, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 6=0A=
mmcblk0: error -84 transferring data, sector 7, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 7=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 4096, nr 8, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 4096=0A=
mmcblk0: error -84 transferring data, sector 4097, nr 7, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 4097=0A=
mmcblk0: error -84 transferring data, sector 4098, nr 6, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 4098=0A=
mmcblk0: error -84 transferring data, sector 4099, nr 5, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 4099=0A=
mmcblk0: error -84 transferring data, sector 4100, nr 4, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 4100=0A=
mmcblk0: error -84 transferring data, sector 4101, nr 3, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 4101=0A=
mmcblk0: error -84 transferring data, sector 4102, nr 2, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 4102=0A=
mmcblk0: error -84 transferring data, sector 4103, nr 1, card status =
0x900=0A=
end_request: I/O error, dev mmcblk0, sector 4103=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 0, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 0=0A=
mmcblk0: error -84 transferring data, sector 1, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 1=0A=
mmcblk0: error -84 transferring data, sector 2, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 2=0A=
mmcblk0: error -84 transferring data, sector 3, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3=0A=
mmcblk0: error -84 transferring data, sector 4, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 4=0A=
mmcblk0: error -84 transferring data, sector 5, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 5=0A=
mmcblk0: error -84 transferring data, sector 6, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 6=0A=
mmcblk0: error -84 transferring data, sector 7, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 7=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 0, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 0=0A=
mmcblk0: error -84 transferring data, sector 1, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 1=0A=
mmcblk0: error -84 transferring data, sector 2, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 2=0A=
mmcblk0: error -84 transferring data, sector 3, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3=0A=
mmcblk0: error -84 transferring data, sector 4, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 4=0A=
mmcblk0: error -84 transferring data, sector 5, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 5=0A=
mmcblk0: error -84 transferring data, sector 6, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 6=0A=
mmcblk0: error -84 transferring data, sector 7, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 7=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 0, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 0=0A=
mmcblk0: error -84 transferring data, sector 1, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 1=0A=
mmcblk0: error -84 transferring data, sector 2, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 2=0A=
mmcblk0: error -84 transferring data, sector 3, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3=0A=
mmcblk0: error -84 transferring data, sector 4, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 4=0A=
mmcblk0: error -84 transferring data, sector 5, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 5=0A=
mmcblk0: error -84 transferring data, sector 6, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 6=0A=
mmcblk0: error -84 transferring data, sector 7, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 7=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 0, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 0=0A=
mmcblk0: error -84 transferring data, sector 1, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 1=0A=
mmcblk0: error -84 transferring data, sector 2, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 2=0A=
mmcblk0: error -84 transferring data, sector 3, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3=0A=
mmcblk0: error -84 transferring data, sector 4, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 4=0A=
mmcblk0: error -84 transferring data, sector 5, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 5=0A=
mmcblk0: error -84 transferring data, sector 6, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 6=0A=
mmcblk0: error -84 transferring data, sector 7, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 7=0A=
mmcblk0: retrying using single block read=0A=
mmcblk0: error -84 transferring data, sector 0, nr 8, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 0=0A=
mmcblk0: error -84 transferring data, sector 1, nr 7, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 1=0A=
mmcblk0: error -84 transferring data, sector 2, nr 6, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 2=0A=
mmcblk0: error -84 transferring data, sector 3, nr 5, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 3=0A=
mmcblk0: error -84 transferring data, sector 4, nr 4, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 4=0A=
mmcblk0: error -84 transferring data, sector 5, nr 3, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 5=0A=
mmcblk0: error -84 transferring data, sector 6, nr 2, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 6=0A=
mmcblk0: error -84 transferring data, sector 7, nr 1, card status 0x900=0A=
end_request: I/O error, dev mmcblk0, sector 7=0A=

------=_NextPart_000_0053_01CBB7ED.CB488210--

