Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752551Ab2IXFqg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 01:46:36 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:45282 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751141Ab2IXFqf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 01:46:35 -0400
From: "AnilKumar, Chimata" <anilkumar@ti.com>
To: =?iso-8859-1?Q?=C9ric_Piel?= <eric.piel@tremplin-utc.net>
CC: "arnd@arndb.de" <arnd@arndb.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jic23@cam.ac.uk" <jic23@cam.ac.uk>, "greg@kroah.com" <greg@kroah.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2] lis3lv02d: Add STMicroelectronics lis331dlh digital
 accelerometer
Thread-Topic: [PATCH v2] lis3lv02d: Add STMicroelectronics lis331dlh digital
 accelerometer
Thread-Index: AQHNgC+0NDpTyonaHU+HVTncuJ8wyZeYSuuAgADgI5A=
Date: Mon, 24 Sep 2012 05:46:10 +0000
Message-ID: <331ABD5ECB02734CA317220B2BBEABC13EA3A4A4@DBDE01.ent.ti.com>
References: <1345617039-27469-1-git-send-email-anilkumar@ti.com>
 <505F814B.4040709@tremplin-utc.net>
In-Reply-To: <505F814B.4040709@tremplin-utc.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

Thanks for the comments,

On Mon, Sep 24, 2012 at 03:08:19, Éric Piel wrote:
> On 22-08-12 08:30, AnilKumar Ch wrote:
> > This patch adds support for lis331dlh digital accelerometer to the
> > lis3lv02d driver family. Adds ID field for detecting the lis331dlh
> > module, based on this ID field lis3lv02d driver will export the
> > lis331dlh module functionality.
> 
> Hello AnilKumar,
> 
> Sorry for taking so long to review your patch. Overall, it looks great :-)
> 
> There are just a few points that almost code-style/comment that needs to 
> be fixed. See below. Could you fix these small issues, and submit a new 
> patch for Andrew to pick it in his queue?

As I can see this patch is already in linux-next, I will submit
a new patch by addressing all your comments.

> 
> Here is my:
> Reviewed-by: Éric Piel <eric.piel@tremplin-utc.net>
> 
> 
> >
> > Signed-off-by: AnilKumar Ch <anilkumar@ti.com>
> > ---
> > Changes from v1:
> > 	- Removed G range sysfs entry from v1
> > 	- Modified documentation to specify lis331dlh is supported
> >
> >   Documentation/misc-devices/lis3lv02d   |    3 ++-
> >   drivers/misc/lis3lv02d/lis3lv02d.c     |   42 +++++++++++++++++++++++++++++-
> >   drivers/misc/lis3lv02d/lis3lv02d.h     |   44 +++++++++++++++++++++++++++-----
> >   drivers/misc/lis3lv02d/lis3lv02d_i2c.c |    7 ++++-
> >   4 files changed, 87 insertions(+), 9 deletions(-)
> >
> > diff --git a/Documentation/misc-devices/lis3lv02d b/Documentation/misc-devices/lis3lv02d
> > index f1a4ec8..af815b9 100644
> > --- a/Documentation/misc-devices/lis3lv02d
> > +++ b/Documentation/misc-devices/lis3lv02d
> > @@ -4,7 +4,8 @@ Kernel driver lis3lv02d
> >   Supported chips:
> >
> >     * STMicroelectronics LIS3LV02DL, LIS3LV02DQ (12 bits precision)
> > -  * STMicroelectronics LIS302DL, LIS3L02DQ, LIS331DL (8 bits)
> > +  * STMicroelectronics LIS302DL, LIS3L02DQ, LIS331DL (8 bits) and
> > +    LIS331DLH (16 bits)
> >
> >   Authors:
> >           Yan Burman <burman.yan@gmail.com>
> > diff --git a/drivers/misc/lis3lv02d/lis3lv02d.c b/drivers/misc/lis3lv02d/lis3lv02d.c
> > index 29d12a7..c0a9199 100644
> > --- a/drivers/misc/lis3lv02d/lis3lv02d.c
> > +++ b/drivers/misc/lis3lv02d/lis3lv02d.c
> > @@ -80,6 +80,14 @@
> >   #define LIS3_SENSITIVITY_12B		((LIS3_ACCURACY * 1000) / 1024)
> >   #define LIS3_SENSITIVITY_8B		(18 * LIS3_ACCURACY)
> >
> > +/*
> > + * LIS3331DLH spec says 1LSBs corresponds 4G/1024 -> 1LSB is 1000/1024 mG.
> > + * Sensitivity values for +/-2G, outdata in 12 bits for +/-2G scale. so 4
> > + * bits adjustment is required
> > + */
> > +#define LIS3DLH_SENSITIVITY_2G		((LIS3_ACCURACY * 1000) / 1024)
> > +#define SHIFT_ADJ_2G			4
> > +
> You said later:
> >
> > Typo mistake this should be 4G/4096
> Could you fix the comment. Even better, change LIS3331DLH to LIS331DLH
> 
> Also, if I understand correctly, there is currently no support for 
> changing the sensitivity. It stays at 2G all the time, right? In such 
> case, please add a sentence in this comment that the driver does only 
> support the 2G sensitivity for now.

I will do this

> 
> 
> >   #define LIS3_DEFAULT_FUZZ_12B		3
> >   #define LIS3_DEFAULT_FLAT_12B		3
> >   #define LIS3_DEFAULT_FUZZ_8B		1
> > @@ -133,6 +141,19 @@ static s16 lis3lv02d_read_12(struct lis3lv02d *lis3, int reg)
> >   	return (s16)((hi << 8) | lo);
> >   }
> >
> > +/* 12bits for 2G range, 13 bits for 4G range and 14 bits for 8G range */
> > +static s16 lis3lv02d_read_16(struct lis3lv02d *lis3, int reg)
> > +{
> > +	u8 lo, hi;
> > +	int v;
> > +
> > +	lis3->read(lis3, reg - 1, &lo);
> > +	lis3->read(lis3, reg, &hi);
> > +	v = (int) ((hi << 8) | lo);
> > +
> > +	return (s16) v >> lis3->shift_adj;
> > +}
> As the method reads 12, 13, or 14 bits, it's a bit tricky to call it 
> "*_read_16". I'd suggest maybe "lis3lv02d_read_12_14", 
> "lis3lv02d_read_adj_16", or even "lis331dlh_read_data". Pick the one you 
> prefer :-)

Comment is available to convey the number of bits so I am changing it to
"lis331dlh_read_data".

> 
> 
> >   /**
> >    * lis3lv02d_get_axis - For the given axis, give the value converted
> >    * @axis:      1,2,3 - can also be negative
> > @@ -193,6 +214,7 @@ static void lis3lv02d_get_xyz(struct lis3lv02d *lis3, int *x, int *y, int *z)
> >   static int lis3_12_rates[4] = {40, 160, 640, 2560};
> >   static int lis3_8_rates[2] = {100, 400};
> >   static int lis3_3dc_rates[16] = {0, 1, 10, 25, 50, 100, 200, 400, 1600, 5000};
> > +static int lis3_3dlh_rates[4] = {50, 100, 400, 1000};
> >
> >   /* ODR is Output Data Rate */
> >   static int lis3lv02d_get_odr(struct lis3lv02d *lis3)
> > @@ -265,7 +287,7 @@ static int lis3lv02d_selftest(struct lis3lv02d *lis3, s16 results[3])
> >   				(LIS3_IRQ1_DATA_READY | LIS3_IRQ2_DATA_READY));
> >   	}
> >
> > -	if (lis3->whoami == WAI_3DC) {
> > +	if ((lis3->whoami == WAI_3DC) || (lis3->whoami == WAI_3DLH)) {
> >   		ctlreg = CTRL_REG4;
> >   		selftest = CTRL4_ST0;
> >   	} else {
> > @@ -396,9 +418,17 @@ int lis3lv02d_poweron(struct lis3lv02d *lis3)
> >   		lis3->read(lis3, CTRL_REG2, &reg);
> >   		if (lis3->whoami ==  WAI_12B)
> >   			reg |= CTRL2_BDU | CTRL2_BOOT;
> > +		else if (lis3->whoami ==  WAI_3DLH)
> > +			reg |= CTRL2_BOOT_3DLH;
> >   		else
> >   			reg |= CTRL2_BOOT_8B;
> >   		lis3->write(lis3, CTRL_REG2, reg);
> > +
> > +		if (lis3->whoami ==  WAI_3DLH) {
> > +			lis3->read(lis3, CTRL_REG4, &reg);
> > +			reg |= CTRL4_BDU;
> > +			lis3->write(lis3, CTRL_REG4, reg);
> > +		}
> >   	}
> >
> >   	err = lis3lv02d_get_pwron_wait(lis3);
> > @@ -954,6 +984,16 @@ int lis3lv02d_init_device(struct lis3lv02d *lis3)
> >   		lis3->odr_mask = CTRL1_ODR0|CTRL1_ODR1|CTRL1_ODR2|CTRL1_ODR3;
> >   		lis3->scale = LIS3_SENSITIVITY_8B;
> >   		break;
> > +	case WAI_3DLH:
> > +		pr_info("16 bits 3DLH sensor found\n");

I am planning to change this print message to
"LIS331DLH sensor found"

> > +		lis3->read_data = lis3lv02d_read_16;
> > +		lis3->mdps_max_val = 2048; /* 12 bits for 2G */
> > +		lis3->shift_adj = SHIFT_ADJ_2G;
> > +		lis3->pwron_delay = LIS3_PWRON_DELAY_WAI_8B;
> > +		lis3->odrs = lis3_3dlh_rates;
> > +		lis3->odr_mask = CTRL1_DR0 | CTRL1_DR1;
> > +		lis3->scale = LIS3DLH_SENSITIVITY_2G;
> > +		break;
> >   	default:
> >   		pr_err("unknown sensor type 0x%X\n", lis3->whoami);
> >   		return -EINVAL;
> > diff --git a/drivers/misc/lis3lv02d/lis3lv02d.h b/drivers/misc/lis3lv02d/lis3lv02d.h
> > index 2b1482a..c1a545e 100644
> > --- a/drivers/misc/lis3lv02d/lis3lv02d.h
> > +++ b/drivers/misc/lis3lv02d/lis3lv02d.h
> > @@ -26,12 +26,12 @@
> >   /*
> >    * This driver tries to support the "digital" accelerometer chips from
> >    * STMicroelectronics such as LIS3LV02DL, LIS302DL, LIS3L02DQ, LIS331DL,
> > - * LIS35DE, or LIS202DL. They are very similar in terms of programming, with
> > - * almost the same registers. In addition to differing on physical properties,
> > - * they differ on the number of axes (2/3), precision (8/12 bits), and special
> > - * features (freefall detection, click...). Unfortunately, not all the
> > - * differences can be probed via a register.
> > - * They can be connected either via I²C or SPI.
> > + * LIS331DLH, LIS35DE, or LIS202DL. They are very similar in terms of
> > + * programming, with almost the same registers. In addition to differing
> > + * on physical properties, they differ on the number of axes (2/3),
> > + * precision (8/12 bits), and special features (freefall detection,
> > + * click...). Unfortunately, not all the differences can be probed via
> > + * a register. They can be connected either via I²C or SPI.
> >    */
> >
> >   #include <linux/lis3lv02d.h>
> > @@ -96,12 +96,22 @@ enum lis3lv02d_reg {
> >   };
> >
> >   enum lis3_who_am_i {
> > +	WAI_3DLH	= 0x32,	/* 16 bits: LIS331DLH */
> >   	WAI_3DC		= 0x33,	/* 8 bits: LIS3DC, HP3DC */
> >   	WAI_12B		= 0x3A, /* 12 bits: LIS3LV02D[LQ]... */
> >   	WAI_8B		= 0x3B, /* 8 bits: LIS[23]02D[LQ]... */
> >   	WAI_6B		= 0x52, /* 6 bits: LIS331DLF - not supported */
> >   };
> >
> > +enum lis3_type {
> > +	LIS3DC,
> > +	HP3DC,
> > +	LIS3LV02D,
> > +	LIS2302D,
> > +	LIS331DLF,
> > +	LIS331DLH,
> > +};
> > +
> >   enum lis3lv02d_ctrl1_12b {
> >   	CTRL1_Xen	= 0x01,
> >   	CTRL1_Yen	= 0x02,
> > @@ -129,6 +139,27 @@ enum lis3lv02d_ctrl1_3dc {
> >   	CTRL1_ODR3	= 0x80,
> >   };
> >
> > +enum lis331dlh_ctrl1 {
> > +	CTRL1_DR0	= 0x08,
> > +	CTRL1_DR1	= 0x10,
> > +	CTRL1_PM0	= 0x20,
> > +	CTRL1_PM1	= 0x40,
> > +	CTRL1_PM2	= 0x80,
> > +};
> > +
> > +enum lis331dlh_ctrl2 {
> > +	CTRL2_HPEN1	= 0x04,
> > +	CTRL2_HPEN2	= 0x08,
> > +	CTRL2_FDS_3DLH	= 0x10,
> > +	CTRL2_BOOT_3DLH	= 0x80,
> > +};
> > +
> > +enum lis331dlh_ctrl4 {
> > +	CTRL4_STSIGN	= 0x08,
> > +	CTRL4_BLE	= 0x40,
> > +	CTRL4_BDU	= 0x80,
> > +};
> > +
> >   enum lis3lv02d_ctrl2 {
> >   	CTRL2_DAS	= 0x01,
> >   	CTRL2_SIM	= 0x02,
> > @@ -279,6 +310,7 @@ struct lis3lv02d {
> >   	int                     data_ready_count[2];
> >   	atomic_t		wake_thread;
> >   	unsigned char           irq_cfg;
> > +	unsigned int		shift_adj;
> >
> >   	struct lis3lv02d_platform_data *pdata;	/* for passing board config */
> >   	struct mutex		mutex;     /* Serialize poll and selftest */
> > diff --git a/drivers/misc/lis3lv02d/lis3lv02d_i2c.c b/drivers/misc/lis3lv02d/lis3lv02d_i2c.c
> > index c02fea0..98cf9ba 100644
> > --- a/drivers/misc/lis3lv02d/lis3lv02d_i2c.c
> > +++ b/drivers/misc/lis3lv02d/lis3lv02d_i2c.c
> > @@ -90,7 +90,11 @@ static int lis3_i2c_init(struct lis3lv02d *lis3)
> >   	if (ret < 0)
> >   		return ret;
> >
> > -	reg |= CTRL1_PD0 | CTRL1_Xen | CTRL1_Yen | CTRL1_Zen;
> > +	if (lis3->whoami == WAI_3DLH)
> > +		reg |= CTRL1_PM0 | CTRL1_Xen | CTRL1_Yen | CTRL1_Zen;
> > +	else
> > +		reg |= CTRL1_PD0 | CTRL1_Xen | CTRL1_Yen | CTRL1_Zen;
> > +
> >   	return lis3->write(lis3, CTRL_REG1, reg);
> >   }
> >
> > @@ -232,6 +236,7 @@ static int lis3_i2c_runtime_resume(struct device *dev)
> >
> >   static const struct i2c_device_id lis3lv02d_id[] = {
> >   	{"lis3lv02d", 0 },
> > +	{"lis331dlh", LIS331DLH},
> I'm not fully grasping the meaning of this table. But as there seems to
> be no user of the second value, I imagine this value just has to be 
> different for each entry? If so, I'd recommend to change the 0 to 
> LIS3LV02D, to make it clear that LIS331DLH != 0. Or is this value 
> meaningful for the user, in which case we cannot change it anymore?
> 

I will change this and update the enum lis3_type accordingly, which
has these macros

Thanks
AnilKumar

