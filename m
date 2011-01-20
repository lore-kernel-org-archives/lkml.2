Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283Ab1ATGJz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 01:09:55 -0500
Received: from mga02.intel.com ([134.134.136.20]:5524 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752239Ab1ATGJx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 01:09:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,348,1291622400"; 
   d="scan'208";a="594714449"
From: "Dong, Chuanxiao" <chuanxiao.dong@intel.com>
To: Chris Ball <cjb@laptop.org>
CC: "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Date: Thu, 20 Jan 2011 14:08:04 +0800
Subject: RE: [PATCH v2 1/1]mmc: implemented eMMC4.4 enhanced area feature
Thread-Topic: [PATCH v2 1/1]mmc: implemented eMMC4.4 enhanced area feature
Thread-Index: Acu4UbBD5xeY7LufSICdNEVOdCoRjQAEwNdg
Message-ID: <5D8008F58939784290FAB48F54975198352A15BFC0@shsmsx502.ccr.corp.intel.com>
References: <20110113125727.GA20452@intel.com>
 <20110120032519.GA4827@void.printf.net>
In-Reply-To: <20110120032519.GA4827@void.printf.net>
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
Thanks for comments. I will fix the typo and line warp errors in the next submissions. :)

> >  MMC_DEV_ATTR(name, "%s\n", card->cid.prod_name);
> >  MMC_DEV_ATTR(oemid, "0x%04x\n", card->cid.oemid);
> >  MMC_DEV_ATTR(serial, "0x%08x\n", card->cid.serial);
> > +MMC_DEV_ATTR(enhanced_area_offset, "0x%llxB\n",
> > +		card->ext_csd.enhanced_area_offset);
> > +MMC_DEV_ATTR(enhanced_area_size, "0x%xKB\n",
> card->ext_csd.enhanced_area_size);
> 
> I think these should probably be printed in decimal instead of hex.
> 
> Hm, this way the sysfs files will show up regardless of whether we have
> an eMMC device or an SD card, which is very confusing.  Can you not check
> whether enhanced_area_en == 1 before create these files?
> 
SD card will not use this code when initializing. So I think these files only are created for eMMC card. If the eMMC card doesn't support enhanced area, can we use the same way like below scenario, exporting some value like -EINVAL to user? What do you think?

> >
> >  static struct attribute *mmc_std_attrs[] = {
> >  	&dev_attr_cid.attr,
> > @@ -349,6 +387,8 @@ static struct attribute *mmc_std_attrs[] = {
> >  	&dev_attr_name.attr,
> >  	&dev_attr_oemid.attr,
> >  	&dev_attr_serial.attr,
> > +	&dev_attr_enhanced_area_offset.attr,
> > +	&dev_attr_enhanced_area_size.attr,
> >  	NULL,
> >  };
> >
> > @@ -484,6 +524,39 @@ static int mmc_init_card(struct mmc_host *host, u32
> ocr,
> >  	}
> >
> >  	/*
> > +	 * If enhanced_area_en is TRUE, host need to enable
> > +	 * ERASE_GRP_DEF bit.
> > +	 * ERASE_GRP_DEF bit will be lost everytime
> > +	 * after a reset or power off.
> > +	 */
> > +	if (card->ext_csd.enhanced_area_en) {
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
> > +			card->ext_csd.enhanced_area_offset = 0;
> > +			card->ext_csd.enhanced_area_size = 0;
> 
> It makes more sense to me to return -EINVAL instead of 0 if we know
> nothing about the enhanced_area.  What do you think?
Agree. This can let user know the enhanced area offset and size are invalid argument.

Thanks
Chuanxiao
