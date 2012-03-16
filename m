Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761739Ab2CPN47 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 09:56:59 -0400
Received: from smtp-out-236.synserver.de ([212.40.185.236]:1159 "EHLO
	smtp-out-227.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1761162Ab2CPN45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 09:56:57 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 3703
Message-ID: <4F63472C.5050102@metafoo.de>
Date: Fri, 16 Mar 2012 14:59:08 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111114 Iceowl/1.0b2 Icedove/3.1.16
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: linux-kernel@vger.kernel.org, Balaji Rao <balajirrao@openmoko.org>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH RFT 1/2] regulator: pcf50633: Don't write to reserved
 bits of AUTO output voltage select register
References: <1331904943.2891.1.camel@phoenix>
In-Reply-To: <1331904943.2891.1.camel@phoenix>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/16/2012 02:35 PM, Axel Lin wrote:
> The datasheet says 00000000 to 00101110 are reserved, and the min value of the
> voltage setting is 1.8 V.
> Thus don't write 0 to AUTO output voltage select register (address 1Ah).
> 
> Table 50. AUTOOUT - AUTO output voltage select register (address 1Ah) bit description[1]
> Bit Symbol Access Description
> 7:0 auto_out R/W VO(prog) = 0.625 + auto_out × 0.025 V
> eg. 00000000 to 00101110: reserved
> 00101111: 1.8 V (min)
> 01010011: 2.7 V
> 01101010: 3.275 V
> 01101011: 3.300 V
> 01101100: 3.325 V
> 01111111 : 3.800 V (max)
> ..... .....
> 11111110 : 3.800 V
> 11111111 : 3.800 V
> 
> This patch also fixes a bug in pcf50633_regulator_list_voltage.
> It is wrong to do "index += 0x2f" for PCF50633_REGULATOR_AUTO in
> pcf50633_regulator_list_voltage. The purpose of adding 0x2f to index is because
> current code return 0 in auto_voltage_bits when millivolts < 1800.
> For millivolts > 1800, adding 0x2f to index is wrong.
> 
> We should handle this by
> return -EINVAL if the selector is in the reserved range of AUTOOUT.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/regulator/pcf50633-regulator.c |   23 +++++------------------
>  1 files changed, 5 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/regulator/pcf50633-regulator.c b/drivers/regulator/pcf50633-regulator.c
> index 6db46c6..3cefc63 100644
> --- a/drivers/regulator/pcf50633-regulator.c
> +++ b/drivers/regulator/pcf50633-regulator.c
> @@ -52,7 +52,7 @@ static const u8 pcf50633_regulator_registers[PCF50633_NUM_REGULATORS] = {
>[...]
>  
> @@ -161,6 +158,9 @@ static int pcf50633_regulator_voltage_value(enum pcf50633_regulator_id id,
>  
>  	switch (id) {
>  	case PCF50633_REGULATOR_AUTO:
> +		/* AUTOOUT: 00000000 to 00101110 are reserved */
> +		if (bits < 0x2f)
> +			return -EINVAL;
>  		millivolts = auto_voltage_value(bits);
>  		break;
>  	case PCF50633_REGULATOR_DOWN1:
> @@ -208,20 +208,7 @@ static int pcf50633_regulator_get_voltage(struct regulator_dev *rdev)
>  static int pcf50633_regulator_list_voltage(struct regulator_dev *rdev,
>  						unsigned int index)
>  {
> -	struct pcf50633 *pcf;
> -	int regulator_id;
> -
> -	pcf = rdev_get_drvdata(rdev);
> -
> -	regulator_id = rdev_get_id(rdev);
> -
> -	switch (regulator_id) {
> -	case PCF50633_REGULATOR_AUTO:
> -		index += 0x2f;
> -		break;
> -	default:
> -		break;
> -	}

Does this make sense? Now we return -EINVAL if index is less than 0x2f


