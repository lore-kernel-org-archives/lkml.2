Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580Ab2CRLF6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2012 07:05:58 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:45976 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752674Ab2CRLF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2012 07:05:57 -0400
Message-ID: <4F65C1AA.40102@metafoo.de>
Date: Sun, 18 Mar 2012 12:06:18 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120207 Icedove/3.0.11
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH v2 1/2] regulator: pcf50633: Don't write to reserved bits
 of AUTO output voltage select register
References: <1331942824.6622.1.camel@phoenix>
In-Reply-To: <1331942824.6622.1.camel@phoenix>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/17/2012 01:07 AM, Axel Lin wrote:
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

I think you misunderstood what the current code does. The first usable voltage
is 1.8V which is equal to a index of of 0x2f. So the driver adds 0x2f to the
index so that there is not a headroom of 0x2f unusable voltages. So a selector
of 0 translates to 1.8V, a selector of 1 translates to 1.825V and so on.

I can see why you'd want to change it to simplify the code, but you also have
to change the number of voltages for the AUTO regulator to 128.
