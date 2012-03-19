Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964960Ab2CSJG2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 05:06:28 -0400
Received: from smtp-out-236.synserver.de ([212.40.185.236]:1093 "EHLO
	smtp-out-236.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754326Ab2CSJG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 05:06:27 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 31113
Message-ID: <4F66F79C.3070501@metafoo.de>
Date: Mon, 19 Mar 2012 10:08:44 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111114 Iceowl/1.0b2 Icedove/3.1.16
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH v3 1/2] regulator: pcf50633: Don't write to reserved bits
 of AUTO output voltage select register
References: <1332125724.17246.1.camel@phoenix>
In-Reply-To: <1332125724.17246.1.camel@phoenix>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2012 03:55 AM, Axel Lin wrote:
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
> This patch also fixes a bug in pcf50633_regulator_list_voltage:
> In regulator core _regulator_do_set_voltage function:
> 
>         if (rdev->desc->ops->set_voltage) {
>                 ret = rdev->desc->ops->set_voltage(rdev, min_uV, max_uV,
>                                                    &selector);
> 
>                 if (rdev->desc->ops->list_voltage)
>                         selector = rdev->desc->ops->list_voltage(rdev,
>                                                                  selector);
>                 else
>                         selector = -1;
> 
> The list_voltage call here takes the selector got from set_voltage callback.
> Thus adding 0x2f to the index in pcf50633_regulator_list_voltage looks wrong to me.
> 
> e.g.
> If min_uV < 1.8V, pcf50633_regulator_set_voltage sets 0 to selector.
> For this case, adding 0x2f to the index in pcf50633_regulator_list_voltage is correct.
> However, if min_uV == 1.8V, pcf50633_regulator_set_voltage sets 0x2f to selector.
> Adding 0x2f to the index in pcf50633_regulator_list_voltage in this case is wrong.
> 
> What this patch does is:
> The minimal voltage setting for AUTOOUT is 0x2f.
> Thus for the case min_uV < 1.8, set the voltage setting to 1.8V by writting
> 0x2f to AUTOOUT register and set selector = 0x2f.
> So we don't write the rserved range to AUTOOUT register.
> Which means the possible range of AUTOOUT register value is 0x2f ~ 0xff.
> 
> We have no problem in regulator_get_voltage.
> Since we won't write 0~0x2e to AUTOOUT register, we have no problem converting
> the bits we read to voltage. The equation in auto_voltage_value works fine.
> 
> For list_voltage, we need to take into account the case selector is 0 ~ 0x2e
> because the regulator core assumes the selector is starting from 0.
> This patch returns 0 for the cases selector is 0 ~ 0x2e, which means
> "this selector code can't be used on this system".
> 
> The regulator core iterates from 0 to n_voltages to find the small voltage
> in the specific range. The n_voltages settings for AUTOOUT should be 128 now,
> including the reserved range of AUTOOUT.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Lars-Peter Clausen <lars@metafoo.de>
