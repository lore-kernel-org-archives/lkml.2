Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756645Ab2IRISY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 04:18:24 -0400
Received: from smtp-out-031.synserver.de ([212.40.185.31]:1126 "EHLO
	smtp-out-031.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753662Ab2IRISW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 04:18:22 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 32107
Message-ID: <50582E77.3070808@metafoo.de>
Date: Tue, 18 Sep 2012 10:19:03 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.6esrpre) Gecko/20120817 Icedove/10.0.6
MIME-Version: 1.0
To: "Kim, Milo" <Milo.Kim@ti.com>
CC: Jonathan Cameron <jic23@kernel.org>, Jonathan Cameron <jic23@cam.ac.uk>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6] iio: adc: add new lp8788 adc driver
References: <A874F61F95741C4A9BA573A70FE3998F41EF510C@DQHE02.ent.ti.com>
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F41EF510C@DQHE02.ent.ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17/2012 11:35 AM, Kim, Milo wrote:
>  TI LP8788 PMU provides regulators, battery charger, ADC,
>  RTC, backlight driver and current sinks.
> 
>  This patch enables the LP8788 ADC functions.
> 
>  The LP8788 ADC has several ADC input selection and supports 12bit resolution.
>  Internal operation of getting ADC is access to registers of LP8788.
>  The LP8788 ADC uses exported functions for accessing these registers.
>  (exported by LP8788 MFD device driver)
> 
>  This driver supports IIO_CHAN_INFO_RAW and SCALE.
>  So the IIO consumer can calculate the value with raw and scale.
>  The unit of scale is micro.
> 
>  (ADC Input Selection)
> 
>  Voltage: battery voltage (MAX 5.0, 5.5 and 6.0V)
>           charger input voltage
>           four general ADC inputs
>           coin cell voltage
>  Current: battery charging current
>  Temperature: IC temperature
> 
>  (The IIO map for the IIO consumer)
> 
>  The ADC input is configurable in the platform side.
>  Even though this platform data is not defined,
>  the default IIO map is created for supporting the power supply driver.
>  The battery voltage and temperature are used inside this driver.
> 
>  (History)
> 
>  Patch v6.
>  (a) Fix scale value for each ADC input selection
>  Voltage and current type are mili unit and temperature is degree.
>  To calculate the IC temperature,
>  temp = raw * scaleint + (raw * scalepart)/ 1000000, scaleint is always 0.
>       = raw * 0.061050, raw: 0 ~ 4095
>  Then range of IC temperature(ADC result) is 0 ~ 250'C
> 
>  (b) Reorganization of the IIO channel Spec
>  Remove address, scan_type and scan_index and rollback the datasheet name.
>  The reason why 'address' field is unnecessary is no relation with each channel.
>  Moreover, to get the raw ADC value, the address info is not only one register
>  but also several registers.
>  Therefore specific function(lp8788_get_adc_result) is called rather than
>  using one 'address' field.
> 
>  (c) Fix coding style
>  Remove duplicated checking routine while unregistering the IIO map.
>  Fix code for space and parenthesis.
> 
>  Patch v5.
>  Fix default consumer name as 'lp8788-charger'.
>  Add mutex for ADC read operation.
>  Reorganization on lp8788_adc_read_raw().
> 
>  Patch v4.
>  Fix adc_raw function: support RAW and SCALE channel info.
>  Change LP8788 ADC platform data - iio map.
>  Enables the default IIO map.
> 
>  Patch v3.
>  Fix wrong size of allocating iio private data.
>  Fix coding styles.
> 
>  Patch v2.
>  Support RAW and SCALE interface for IIO consumer.
>  Clean up the iio channel spec macro.
> 
> Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>

Looks good to me,

Reviewed-by: Lars-Peter Clausen <lars@metafoo.de>

One comment though, not sure if it is critical or not.

> +static int lp8788_get_adc_result(struct lp8788_adc *adc, enum lp8788_adc_id id,
> +				int *val)
> +{
> +	unsigned int msb;
> +	unsigned int lsb;
> +	unsigned int result;
> +	u8 data;
> +	u8 rawdata[2];
> +	int size = ARRAY_SIZE(rawdata);
> +	int retry = 5;
> +	int ret;
> +
> +	data = (id << 1) | ADC_CONV_START;
> +	ret = lp8788_write_byte(adc->lp, LP8788_ADC_CONF, data);
> +	if (ret)
> +		goto err_io;
> +
> +	/* retry until adc conversion is done */
> +	data = 0;
> +	while (retry--) {
> +		usleep_range(100, 200);
> +
> +		ret = lp8788_read_byte(adc->lp, LP8788_ADC_DONE, &data);
> +		if (ret)
> +			goto err_io;
> +
> +		/* conversion done */
> +		if (data)
> +			break;

Could as well go into the while header like this:
    while (!data && retry--)

> +	}
> +

You still sample the data, even if there was a timeout and ADC_DONE is not set.

> +	ret = lp8788_read_multi_bytes(adc->lp, LP8788_ADC_RAW, rawdata, size);
> +	if (ret)
> +		goto err_io;
> +
> +	msb = (rawdata[0] << 4) & 0x00000ff0;
> +	lsb = (rawdata[1] >> 4) & 0x0000000f;
> +	result = msb | lsb;
> +	*val = result;
> +
> +	return 0;
> +
> +err_io:
> +	return ret;
> +}
