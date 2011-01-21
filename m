Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753315Ab1AUDGv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 22:06:51 -0500
Received: from mga14.intel.com ([143.182.124.37]:25235 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752333Ab1AUDGu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 22:06:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,355,1291622400"; 
   d="scan'208";a="377740509"
From: "Dong, Chuanxiao" <chuanxiao.dong@intel.com>
To: Chris Ball <cjb@laptop.org>
CC: "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Date: Fri, 21 Jan 2011 11:06:08 +0800
Subject: RE: [PATCH v3 1/1]mmc: implemented eMMC4.4 enhanced area feature
Thread-Topic: [PATCH v3 1/1]mmc: implemented eMMC4.4 enhanced area feature
Thread-Index: Acu4vOZQ5xytTdiSRTu76Dx5mHuefgAVV0gg
Message-ID: <5D8008F58939784290FAB48F5497519835341813A7@shsmsx502.ccr.corp.intel.com>
References: <20110120075556.GA23566@intel.com>
 <20110120161248.GA11774@void.printf.net>
In-Reply-To: <20110120161248.GA11774@void.printf.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p0L3755F008193

Hi Chris,
> > --- /dev/null
> > +++ b/Documentation/ABI/testing/sysfs-devices-mmc
> > @@ -0,0 +1,19 @@
> > +What:
> 	/sys/devices/.../mmc_host/mmcX/mmcX:XXXX/enhanced_area_offset
> > +Date:		January 2011
> > +Contact:	Chuanxiao Dong <chuanxiao.dong@intel.com>
> > +Description:
> > +		Enhanced area is a new feature defined in eMMC4.4 standard.eMMC4.4
> or
> > +		later card can support such feature. This kind of area can help to
> > +		improve the card performance. If the feature is enabled, this attribute
> > +		will indicate the start address of enhanced data area. If not, this
> > +		attribute will be -EINVAL. Unit Byte. Format decimal.
> > +
> > +What:		/sys/devices/.../mmc_host/mmcX/mmcX:XXXX/enhanced_area_size
> > +Date:		January 2011
> > +Contact:	Chuanxiao Dong <chuanxiao.dong@intel.com>
> > +Description:
> > +		Enhanced area is a new feature defined in eMMC4.4 standard. eMMC4.4
> or
> > +		later card can support such feature. This kind of area can help to
> > +		improve the card performance. If the feature is enabled, this attribute
> > +		will indicate the size of enhanced data area. If not, this attribute
> > +		will be -EINVAL. Unit KByte. Format decimal.
> 
> This is still wrapped at > 80 columns.
Sorry for that. I have set the textwidth=80 for vim, not understand why this is still wrapped at >80 columns... I know checkpatch.pl can help us to find the style problem, and is there some other script which can help find the style problem of Document or how can I avoid such errors?
Chris, thank you for your kind patience to help me find these stupid errors again...

> > diff --git a/include/linux/mmc/card.h b/include/linux/mmc/card.h
> > index 8ce0827..736697f 100644
> > --- a/include/linux/mmc/card.h
> > +++ b/include/linux/mmc/card.h
> > @@ -54,6 +54,9 @@ struct mmc_ext_csd {
> >  	unsigned int		sec_trim_mult;	/* Secure trim multiplier  */
> >  	unsigned int		sec_erase_mult;	/* Secure erase multiplier */
> >  	unsigned int		trim_timeout;		/* In milliseconds */
> > +	bool			enhanced_area_en;	/* enhanced area en */
> > +	loff_t		enhanced_area_offset;	/* enhanced area addr */
> > +	size_t		enhanced_area_size;		/* enhanced area size */
> 
> Now enhanced_area_en is aligned correctly, but the other two aren't.
> 
> This adds a warning:
> 
> drivers/mmc/core/mmc.c: In function â€˜mmc_enhanced_area_size_showâ€™:
> drivers/mmc/core/mmc.c:383:261: warning: format â€˜%dâ€™ expects type â€˜intâ€™,
> but argument 3 has type â€˜size_tâ€™
> 
> If you really want size_t, you should use %zu for it -- see
> Documentation/printk-formats.txt.  (Declaring it as unsigned int would
> work fine too.)
> 
> Oh, and let's mention the units of _offset and _size in the comment in
> card.h.
Chris, you mean the type of _offset and _size? I think the 64bits number for _offset is enough, also the 32bits number for _size since the units of _size is Kbytes. Any suggestions on that?

> 
> >  };
> >
> >  struct sd_scr {
> > diff --git a/include/linux/mmc/mmc.h b/include/linux/mmc/mmc.h
> > index 612301f..264ba54 100644
> > --- a/include/linux/mmc/mmc.h
> > +++ b/include/linux/mmc/mmc.h
> > @@ -253,6 +253,8 @@ struct _mmc_csd {
> >   * EXT_CSD fields
> >   */
> >
> > +#define EXT_CSD_PARTITION_ATTRIBUTE	156	/* R/W */
> > +#define EXT_CSD_PARTITION_SUPPORT	160	/* RO */
> >  #define EXT_CSD_ERASE_GROUP_DEF		175	/* R/W */
> >  #define EXT_CSD_ERASED_MEM_CONT		181	/* RO */
> >  #define EXT_CSD_BUS_WIDTH		183	/* R/W */
> > @@ -262,6 +264,7 @@ struct _mmc_csd {
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
> --
> Chris Ball   <cjb@laptop.org>   <http://printf.net/>
> One Laptop Per Child
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
