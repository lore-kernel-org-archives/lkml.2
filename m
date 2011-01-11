Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752336Ab1AKFxA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 00:53:00 -0500
Received: from mga02.intel.com ([134.134.136.20]:21662 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751327Ab1AKFw4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 00:52:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,305,1291622400"; 
   d="scan'208";a="591741024"
From: "Dong, Chuanxiao" <chuanxiao.dong@intel.com>
To: Chris Ball <cjb@laptop.org>
CC: "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Mai, Leonard" <leonard.mai@intel.com>
Date: Tue, 11 Jan 2011 13:52:18 +0800
Subject: RE: [PATCH v2 1/1]mmc: export enhanced area info to user
Thread-Topic: [PATCH v2 1/1]mmc: export enhanced area info to user
Thread-Index: AcuwWdMY+4n0HAfOR8enUardyBkyCAA+HuXg
Message-ID: <5D8008F58939784290FAB48F549751983519F4944C@shsmsx502.ccr.corp.intel.com>
References: <20101208112101.GA14565@intel.com>
 <20110110000241.GA26898@void.printf.net>
In-Reply-To: <20110110000241.GA26898@void.printf.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris,
Thanks for your comments. It is really helpful!

> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org
> [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Chris Ball
> Sent: Monday, January 10, 2011 8:03 AM
> To: Dong, Chuanxiao
> Cc: linux-mmc@vger.kernel.org; linux-kernel@vger.kernel.org; Mai, Leonard
> Subject: Re: [PATCH v2 1/1]mmc: export enhanced area info to user
> 
> Hi Chuanxiao, sorry for the late review.
> 
> On Wed, Dec 08, 2010 at 07:21:01PM +0800, Chuanxiao Dong wrote:
> > enhanced area is a new feature of eMMC4.41 card. Since the offsize and size
> > of enhaneced area is one time programmable register, driver will not set
> > them and just read these values out.
> >
> > So this patch just let host driver read out the enhanced area offsize and
> > size if the eMMC card is enabled this feature. And expose these values to
> > user space through sys fs for use. The feature enabling should be done in
> > manufactory.
> >
> > Before read out these values, host driver also need set the ERASE_GROUP_DEF
> > byte. If this setting this byte failed, driver will set the offsize and size
> > to be 0. But not sure whether need to do this.
> >
> > Signed-off-by: Chuanxiao Dong <chuanxiao.dong@intel.com>
> 
> Which userspace applications do you imagine will use this feature?
> If we're talking about a published interface, we should document this
> in Documentation/ABI.  If this is just a tool to aid in debugging
> pre-production hardware or host controller drivers, it should live
> in debugfs instead.
What we considered is that, if our eMMC card have some area been set to be an enhanced area, MMC driver can export the size and address of this area to user space so that user can use such area for a SWAP partition. Enhanced area has a good performance than the normal area.
Chris, I will document this in Documentation/ABI, thanks a lot for making me clear.

> 
> > ---
> >  drivers/mmc/core/mmc.c   |   92
> ++++++++++++++++++++++++++++++++++++++++++++++
> >  include/linux/mmc/card.h |    3 +
> >  include/linux/mmc/mmc.h  |    3 +
> >  3 files changed, 98 insertions(+), 0 deletions(-)
> >
> > diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
> > index 77f93c3..1f49778 100644
> > --- a/drivers/mmc/core/mmc.c
> > +++ b/drivers/mmc/core/mmc.c
> > @@ -302,6 +302,64 @@ static int mmc_read_ext_csd(struct mmc_card *card)
> >  	}
> >
> >  	if (card->ext_csd.rev >= 4) {
> > +		/*
> > +		 * Enhanced area feature support
> > +		 * check whether eMMC card is enabled enhanced area,
> > +		 * if so, export enhanced area offset and size to
> > +		 * user by adding sysfs interface
> > +		 */
> > +		if ((ext_csd[EXT_CSD_PARTITION_SUPPORT] & 0x2) &&
> > +				(ext_csd[EXT_CSD_PARTITION_ATTRIBUTE] & 0x1)) {
> > +			u8 hc_erase_grp_sz =
> > +				ext_csd[EXT_CSD_HC_ERASE_GRP_SIZE];
> > +			u8 hc_wp_grp_sz =
> > +				ext_csd[EXT_CSD_HC_WP_GRP_SIZE];
> > +			 /*
> > +			  * FIXME
> > +			  * Not sure whether need to enable the
> > +			  * ERASE_GROUP_DEF bit
> > +			  */
> > +			err = mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
> > +					EXT_CSD_ERASE_GROUP_DEF, 1);
> > +
> > +			if (err && err != -EBADMSG)
> > +				goto out;
> > +
> > +			if (err) {
> > +				/*
> > +				 * ignore this err, just disable enhanced area
> > +				 */
> > +				err = 0;
> > +				goto next;
> > +			}
> > +			/* update ext_csd ERASE_GRP_DEF bit */
> > +			ext_csd[EXT_CSD_ERASE_GROUP_DEF] = 1;
> > +			card->ext_csd.erase_group_def =
> > +				ext_csd[EXT_CSD_ERASE_GROUP_DEF];
> > +			/*
> > +			 * set a flag to identify whether the enhanced
> > +			 * user data are enabled
> > +			 */
> > +			card->ext_csd.enh_data_area_en = 1;
> > +			/*
> > +			 * caculate the enhanced data area offset, unit B
> > +			 */
> > +			card->ext_csd.enh_data_area_off =
> > +				(ext_csd[139] << 24) + (ext_csd[138] << 16) +
> > +				(ext_csd[137] << 8) + ext_csd[136];
> > +			if (mmc_card_blockaddr(card))
> > +				card->ext_csd.enh_data_area_off <<= 9;
> > +			/*
> > +			 * caculate the enhanced data area size, unit KB
> > +			 */
> > +			card->ext_csd.enh_data_area_sz =
> > +				(ext_csd[142] << 16) + (ext_csd[141] << 8) +
> > +				ext_csd[140];
> > +			card->ext_csd.enh_data_area_sz *=
> > +				(size_t)(hc_erase_grp_sz * hc_wp_grp_sz);
> > +			card->ext_csd.enh_data_area_sz <<= 9;
> > +		}
> > +next:
> >  		card->ext_csd.sec_trim_mult =
> >  			ext_csd[EXT_CSD_SEC_TRIM_MULT];
> >  		card->ext_csd.sec_erase_mult =
> > @@ -336,6 +394,9 @@ MMC_DEV_ATTR(manfid, "0x%06x\n",
> card->cid.manfid);
> >  MMC_DEV_ATTR(name, "%s\n", card->cid.prod_name);
> >  MMC_DEV_ATTR(oemid, "0x%04x\n", card->cid.oemid);
> >  MMC_DEV_ATTR(serial, "0x%08x\n", card->cid.serial);
> > +MMC_DEV_ATTR(enhen, "%d\n", card->ext_csd.enh_data_area_en);
> > +MMC_DEV_ATTR(enhoff, "0x%llxB\n", card->ext_csd.enh_data_area_off);
> > +MMC_DEV_ATTR(enhsz, "0x%xKB\n", card->ext_csd.enh_data_area_sz);
> 
> If enhen == 0 and the user cats enhoff/enhsz, I think you should return
> something like -EINVAL instead of 0.  (You could also instead consider
> making the appearance of enhoff and enhsz conditional on enhen == 1,
> and then just not export enhen to userspace at all?)
I will use the second way which makes user much more clearly. :)

> 
> Regardless of where the files live, we should have much better names
> for them.  It should be possible to work out what each file is for
> without already knowing!  Perhaps enhanced_area_{enable,offset,size},
> if that's not too long.
Sure, I will give a better name to them in the next submission.

> 
> >
> >  static struct attribute *mmc_std_attrs[] = {
> >  	&dev_attr_cid.attr,
> > @@ -349,6 +410,9 @@ static struct attribute *mmc_std_attrs[] = {
> >  	&dev_attr_name.attr,
> >  	&dev_attr_oemid.attr,
> >  	&dev_attr_serial.attr,
> > +	&dev_attr_enhen.attr,
> > +	&dev_attr_enhoff.attr,
> > +	&dev_attr_enhsz.attr,
> >  	NULL,
> >  };
> >
> > @@ -472,6 +536,34 @@ static int mmc_init_card(struct mmc_host *host, u32
> ocr,
> >  			goto free_card;
> >  	}
> >
> > +	/*
> > +	 * If enh_data_are_en is TRUE, means this init card
> > +	 * operation is used to reinit card after a reset
> > +	 * ERASE_GRP_DEF register value will be lost everytime
> > +	 * after a reset or power off.
> > +	 *
> > +	 * FIXME
> > +	 * Not sure whether need to enable ERASE_GRP_DEF bit.
> > +	 */
> 
> Can we find out somehow?
Yes. ERASE_GRP_DEF bit needs to be set. Confirmed with our eMMC device vender.

> 
> > +	if (card->ext_csd.enh_data_area_en) {
> > +		err = mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
> > +				EXT_CSD_ERASE_GROUP_DEF, 1);
> > +
> > +		if (err && err != -EBADMSG)
> > +			goto free_card;
> > +
> > +		if (err) {
> > +			err = 0;
> > +			/*
> > +			 * Just disable enhanced area off & sz
> > +			 * will try to enable ERASE_GROUP_DEF
> > +			 * during next time reinit
> > +			 */
> > +			card->ext_csd.enh_data_area_off = 0;
> > +			card->ext_csd.enh_data_area_sz = 0;
> > +		}
> > +	}
> > +
> >  	if (!oldcard) {
> >  		/*
> >  		 * Fetch and process extended CSD.
> > diff --git a/include/linux/mmc/card.h b/include/linux/mmc/card.h
> > index 8ce0827..e850a39 100644
> > --- a/include/linux/mmc/card.h
> > +++ b/include/linux/mmc/card.h
> > @@ -54,6 +54,9 @@ struct mmc_ext_csd {
> >  	unsigned int		sec_trim_mult;	/* Secure trim multiplier  */
> >  	unsigned int		sec_erase_mult;	/* Secure erase multiplier */
> >  	unsigned int		trim_timeout;		/* In milliseconds */
> > +	unsigned int		enh_data_area_en; /* enh area enable bit */
> > +	loff_t				enh_data_area_off; /* enh area offset */
> > +	size_t				enh_data_area_sz; /* enh area size */
> >  };
> >
> >  struct sd_scr {
> > diff --git a/include/linux/mmc/mmc.h b/include/linux/mmc/mmc.h
> > index 956fbd8..97ca016 100644
> > --- a/include/linux/mmc/mmc.h
> > +++ b/include/linux/mmc/mmc.h
> > @@ -251,6 +251,8 @@ struct _mmc_csd {
> >   * EXT_CSD fields
> >   */
> >
> > +#define EXT_CSD_PARTITION_ATTRIBUTE 156	/* R/W */
> > +#define EXT_CSD_PARTITION_SUPPORT	160	/* RO */
> >  #define EXT_CSD_ERASE_GROUP_DEF		175	/* R/W */
> >  #define EXT_CSD_ERASED_MEM_CONT		181	/* RO */
> >  #define EXT_CSD_BUS_WIDTH		183	/* R/W */
> > @@ -260,6 +262,7 @@ struct _mmc_csd {
> >  #define EXT_CSD_CARD_TYPE		196	/* RO */
> >  #define EXT_CSD_SEC_CNT			212	/* RO, 4 bytes */
> >  #define EXT_CSD_S_A_TIMEOUT		217	/* RO */
> > +#define EXT_CSD_HC_WP_GRP_SIZE		221	/* RO */
> >  #define EXT_CSD_ERASE_TIMEOUT_MULT	223	/* RO */
> >  #define EXT_CSD_HC_ERASE_GRP_SIZE	224	/* RO */
> >  #define EXT_CSD_SEC_TRIM_MULT		229	/* RO */
> 
> Thanks,
> 
> - Chris.
> --
> Chris Ball   <cjb@laptop.org>   <http://printf.net/>
> One Laptop Per Child
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
