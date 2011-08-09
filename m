Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751950Ab1HIIqL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 04:46:11 -0400
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:22644
	"EHLO AM1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750981Ab1HIIqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 04:46:09 -0400
X-SpamScore: -19
X-BigFish: VPS-19(zz9371K1102K542M1432N98dKzz1202hzz8275dhz32i2a8h668h839h93fh61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:59.163.77.45;KIP:(null);UIP:(null);IPVD:NLI;H:KCHJEXHC01.kpit.com;RD:59.163.77.45.static.vsnl.net.in;EFVD:NLI
From: Ashish Jangam <Ashish.Jangam@kpitcummins.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "sameo@openedhand.com" <sameo@openedhand.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dajun <dajun.chen@diasemi.com>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>
Subject: RE: [PATCH v3 01/11] MFD: DA9052 MFD core module
Thread-Topic: [PATCH v3 01/11] MFD: DA9052 MFD core module
Thread-Index: AQHMVD4qIG1g25gGR0aI27Urs+BS/ZUUE8yg
Date: Tue, 9 Aug 2011 08:45:47 +0000
Message-ID: <C3AE124F08223B42BC95AEB82F0F6CEDC805@KCHJEXMB02.kpit.com>
References: <1312552424.5572.145.camel@L-0532.kpit.com>
 <20110806133829.GA28267@opensource.wolfsonmicro.com>
In-Reply-To: <20110806133829.GA28267@opensource.wolfsonmicro.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.10.38.22]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p798kNhf029380


> -----Original Message-----
> From: Mark Brown [mailto:broonie@opensource.wolfsonmicro.com]
> Sent: Saturday, August 06, 2011 7:09 PM
> To: Ashish Jangam
> Cc: sameo@openedhand.com; linux-kernel@vger.kernel.org; Dajun; linaro-
> dev@lists.linaro.org
> Subject: Re: [PATCH v3 01/11] MFD: DA9052 MFD core module
> 
> On Fri, Aug 05, 2011 at 07:23:44PM +0530, ashishj3 wrote:
> 
> > +choice
> > +	prompt "Chip Type"
> > +	depends on MFD_DA9053_SPI || MFD_DA9053_I2C
> > +config PMIC_DA9053AA
> > +	bool "Support Dialog Semiconductor DA9053 AA PMIC"
> > +	help
> > +	  Support for Dialog semiconductor DA9053 AA PMIC.
> > +	  This driver provides common support for accessing  the device,
> > +	  additional drivers must be enabled in order to use the
> > +	  functionality of the device.
> > +config PMIC_DA9053Bx
> 
> Could do with blank lines between blocks.  Though looking at the code
> here I don't understand why these are compile options at all, or if they
> need to be compile options for some reason why they're not independantly
> selectable?
DA9052 PMIC chip id may get OTP therefore chip id cannot be used as 
a distinguishing factor. Hence these compile time options were introduced.
DA9053 is a higher version of DA9052 therefore not independently selectable.
This means that there can be either DA9052 or DA9053 on system. I need to correct
this Kconfig to take care of this. 
> 
> > +int da9052_reg_read(struct da9052 *da9052, unsigned char reg)
> > +{
> > +	int val, ret;
> > +
> > +	if (reg > DA9052_MAX_REG_CNT) {
> > +		dev_err(da9052->dev, "invalid reg %x\n", reg);
> > +		return -EINVAL;
> > +	}
> > +
> > +	#ifdef CONFIG_MFD_DA9052_SPI
> > +		reg = (reg << 1) | 1;
> > +	#endif
> 
> There's several problems here:
> 
> - You shouldn't be indenting preprocessor directives.
> - You shouldn't be adding extra indentation before.
> - This will break I2C devices if SPI support is built into the driver.
> 
> Please, when writing code try to understand the abstractions you're
> using.  For example here think about the purpose of being able to build
> I2C and SPI separately and simultaneously and the goal of the regmap
> API.
> 
> Looks like we need to add per device mangling for the SPI register
> read/write flag.
For now we will handle this as below:-
During SPI and I2C registration we will add bus type(SPI/I2C) info in the
struct da9052. And before initiating any device I/O this struct member will
be read and reg address will be manipulated if needed.
> 
> > +	da9052_group_write(da9052, DA9052_EVENT_A_REG, 4, v);
> > +
> > +	#ifndef CONFIG_PMIC_DA9053Bx
> > +	DA9052_FIXME();
> > +	#endif
> 
> This should be runtime detected based on the device name, either from
> the device registration or by reading back chip identification.
As said above getting chip info will not work in DA9053/53 case. Also DA9052 code 
works for DA9053 except for few minor changes in MFD and regulator module.
In this case registering different device will also require a preprocessor directive
Or separate DA9053 file therefore this option was not opt. 
>



ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
