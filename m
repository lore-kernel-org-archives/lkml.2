Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758478Ab2DMKhv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 06:37:51 -0400
Received: from www.linutronix.de ([62.245.132.108]:41063 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870Ab2DMKht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 06:37:49 -0400
Date: Fri, 13 Apr 2012 12:37:40 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
cc: x86@kernel.org, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        lm-sensors@lm-sensors.org, Guenter Roeck <guenter.roeck@ericsson.com>,
        Jean Delvare <khali@linux-fr.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: Re: [PATCH v6 2/3] x86/platform: TS-5500 basic platform support
In-Reply-To: <1334276935-11258-3-git-send-email-vivien.didelot@savoirfairelinux.com>
Message-ID: <alpine.LFD.2.02.1204131155580.2542@ionos>
References: <1334276935-11258-1-git-send-email-vivien.didelot@savoirfairelinux.com> <1334276935-11258-3-git-send-email-vivien.didelot@savoirfairelinux.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Apr 2012, Vivien Didelot wrote:
> +/**
> + * struct ts5500_sbc - TS-5500 SBC main structure
> + * @lock:		Read/Write mutex.

What's the point of this mutex ?

AFAICT, it's only ever used in the init path which is serialized by
itself.

> + * @board_id:		Board name.

  name in an integer ?

> + * @sram:		Check SRAM option.
> + * @rs485:		Check RS-485 option.
> + * @adc:		Check Analog/Digital converter option.
> + * @ereset:		Check External Reset option.
> + * @itr:		Check Industrial Temperature Range option.
> + * @jumpers:		States of jumpers 1-7.
> + */
> +struct ts5500_sbc {
> +	struct mutex	lock;
> +	int		board_id;
> +	bool		sram;
> +	bool		rs485;
> +	bool		adc;
> +	bool		ereset;
> +	bool		itr;
> +	u8		jumpers;
> +};


> +/**
> + * ts5500_bios_signature() - find board signature in BIOS shadow RAM.
> + */
> +static int __init ts5500_bios_signature(void)
> +{
> +	void __iomem *bios = ioremap(0xF0000, 0x10000);
> +	int i, ret = 0;

ioremaps can fail. 

> +	for (i = 0; i < ARRAY_SIZE(signatures); i++)
> +		if (check_signature(bios + signatures[i].offset,
+				    signatures[i].string,
> +				    strlen(signatures[i].string)))
> +			goto found;
> +		else
> +			pr_notice("Technologic Systems BIOS signature "
> +				  "'%s' not found at offset %zd\n",
> +				  signatures[i].string, signatures[i].offset);
> +	ret = -ENODEV;
> +found:
> +	iounmap(bios);

Uurg, this is convoluted. What's wrong with doing:

  int ret = -ENODEV;

  for (....) {
      if (check_signature()) {
      	 ret = 0;
	 break;
      }
  }

That way the code becomes readable and we really do not need a
printout when the kernel is configured for multiple platforms and
runs on a !TS board. Also you would print out that nonsense if your
signature array has more than one entry for each non matching
one. Pretty pointless.

> +	tmp = inb(TS5500_PRODUCT_CODE_ADDR);
> +	if (tmp != TS5500_PRODUCT_CODE) {
> +		pr_err("This platform is not a TS-5500 (found ID 0x%x)\n", tmp);
> +		ret = -ENODEV;
> +		goto cleanup;
> +	}
> +	sbc->board_id = tmp;

So we store a constant value in a data structure and the sole purpose
is to display that constant value in sysfs file. Interesting feature.

> +static struct attribute *ts5500_attributes[] = {
> +	&dev_attr_id.attr,
> +	&dev_attr_sram.attr,
> +	&dev_attr_rs485.attr,
> +	&dev_attr_adc.attr,
> +	&dev_attr_ereset.attr,
> +	&dev_attr_itr.attr,
> +	&dev_attr_jp1.attr,
> +	&dev_attr_jp2.attr,
> +	&dev_attr_jp3.attr,
> +	&dev_attr_jp4.attr,
> +	&dev_attr_jp5.attr,
> +	&dev_attr_jp6.attr,

So you create 12 sysfs entries to export boolean features and a
constant value. I don't care much, but this looks like massive
overkill.

> +/* A/D Converter platform device */
> +
> +static int ts5500_adc_convert(u8 ctrl, u16 *raw)
> +{
> +	u8 lsb, msb;
> +
> +	/* Start convertion (ensure the 3 MSB are set to 0) */
> +	outb(ctrl & 0x1F, TS5500_ADC_CONV_INIT_LSB_ADDR);
> +
> +	udelay(TS5500_ADC_CONV_DELAY);
> +	if (inb(TS5500_ADC_CONV_BUSY_ADDR) & TS5500_ADC_CONV_BUSY)
> +		return -EBUSY;

Shouldn't you check the busy bit _BEFORE_ writing into the converter?

Also initiating the conversion and then bailing out if it did not
complete in some micro seconds is kinda strange. What's wrong with
that hardware? And how does it ever recover?

> +static void ts5500_adc_release(struct device *dev)
> +{
> +	/* noop */

  Very helpful comment.

> +}
> +
> +static struct platform_device ts5500_adc_pdev = {
> +	.name = "max197",
> +	.id = -1,
> +	.dev = {
> +		.platform_data = &ts5500_adc_pdata,
> +		.release = ts5500_adc_release,

What's the point of this empty release function ? The device is never
released.

Thanks,

	tglx
