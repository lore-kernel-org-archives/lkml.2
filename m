Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932219Ab2HFPPX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 11:15:23 -0400
Received: from mailrelay1.diasemi.com ([82.210.246.133]:30605 "EHLO
	mailrelay1.diasemi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932081Ab2HFPPV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 11:15:21 -0400
From: "Opensource [Anthony Olech]" <anthony.olech.opensource@diasemi.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "Opensource [Anthony Olech]" <anthony.olech.opensource@diasemi.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: RE: [NEW DRIVER V1 5/7] DA9058 GPIO driver
Thread-Topic: [NEW DRIVER V1 5/7] DA9058 GPIO driver
Thread-Index: AQHNcIvHmHLW+D1Fqk6Ahcg5llq5SJdGPtkAgAapOBA=
Date: Mon, 6 Aug 2012 15:15:17 +0000
Message-ID: <24DF37198A1E704D9811D8F72B87EB51032C39DE@NB-EX-MBX02.diasemi.com>
References: <201208020849.q728nhU3007824@latitude.olech.com>
 <20120802101952.GG29157@opensource.wolfsonmicro.com>
In-Reply-To: <20120802101952.GG29157@opensource.wolfsonmicro.com>
Accept-Language: en-GB, de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.20.27.23]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Mark for looking at the DA9058 GPIO component driver.

I do realize that REGMAP does locking on individual register accesses,
however, the each GPIO line is controlled by 4-bits in a register, with
the meaning of the most significant bit depending on the GPIO direction,
so it is essential that the register be read first before do an update, thus
two sequential register accesses must be protected by a mutex to
prevent another process changing the register (and hence the meaning
of the most-significant bit) in the middle of the two accesses.

I hope this explains to your satisfaction why a driver mutex is required
in addition to the regmap's register access mutex

Tony Olech

-----Original Message-----
From: Mark Brown [mailto:broonie@opensource.wolfsonmicro.com] 
Sent: 02 August 2012 11:20
To: Opensource [Anthony Olech]
Cc: LKML
Subject: Re: [NEW DRIVER V1 5/7] DA9058 GPIO driver

On Thu, Aug 02, 2012 at 09:48:57AM +0100, Anthony Olech wrote:

> +	mutex_lock(&gpio->lock);
> +	ret = da9058_reg_read(da9058, DA9058_STATUSC_REG, &gpio_level);
> +	mutex_unlock(&gpio->lock);

regmap already does locking for you.

> +	ret = da9058_reg_read(da9058, DA9058_GPIO0001_REG, &gpio_cntrl);
> +	if (ret)
> +		goto exit;
> +
> +	if (offset) {
> +		gpio_cntrl &= ~0xF0;
> +		gpio_cntrl |= 0xF0 & gpio->out_config;
> +
> +		ret = da9058_reg_write(da9058, DA9058_GPIO0001_REG, gpio_cntrl);

Just use regmap_update_bits().
