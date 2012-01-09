Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754266Ab2AIHEh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 02:04:37 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:6187 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753339Ab2AIHEf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 02:04:35 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Sun, 08 Jan 2012 23:04:35 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Laxman Dewangan <ldewangan.com@nvidia.com>,
        "lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Date: Mon, 9 Jan 2012 12:34:25 +0530
Subject: RE: [PATCH V1] TPS62360: Add tps62360 regulator driver
Thread-Topic: [PATCH V1] TPS62360: Add tps62360 regulator driver
Thread-Index: AczOJsiUwgliCH99Sc6NcEADKEshQwAdAiiw
Message-ID: <96C9D994977DD0439FB6D3FE3B13DD907DBDABA9A3@BGMAIL01.nvidia.com>
References: <1325668818-1096-1-git-send-email-ldewangan@nvidia.com>
 <20120105062919.GI11867@opensource.wolfsonmicro.com>
 <96C9D994977DD0439FB6D3FE3B13DD907DBD3A9E9B@BGMAIL01.nvidia.com>
 <20120106185755.GC2893@opensource.wolfsonmicro.com>
 <96C9D994977DD0439FB6D3FE3B13DD907DBD3AA0DE@BGMAIL01.nvidia.com>
 <20120107191047.GA3590@opensource.wolfsonmicro.com>
 <96C9D994977DD0439FB6D3FE3B13DD907DBD3AA0E4@BGMAIL01.nvidia.com>
 <20120108165819.GB29065@opensource.wolfsonmicro.com>
In-Reply-To: <20120108165819.GB29065@opensource.wolfsonmicro.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sunday, January 08, 2012 10:28 PM, Mark Brown wrote:
> > In range form, the disadvantages is that, most of time, the voltage
> > requirement is surrounding operating voltage and so it will use only
> > one combination of VSEL in most of time and will not get the benefit.
> > The discrete form have long list of voltage and filling table is pain.
> > Also need to maintain the big list of lookuptable to select voltage
> > configuration register.
> 
> You only have four possible VSELs so I don't see a concern there.

In my design, the voltage vary from 900mV to the 1300mV in increment of
50mV. In this case, the voltage change request is 900, 950, 1000, 1050,
1100, 1150, 1200, 1250, 1300.
I would like to have entry like
900-950->vsel0
950-1000>vsel1,
1000-1050->vsel2
1050-1100->vsel3
1100-1150->vsel0
1150-1200->vsel1
1200-1250->vsel2
1250->1300->vsel3
Based on voltage increment requirements for a given application, this
table can be tune more. Now if client request for voltage setting for
range of 1000-1050, I will select the VSET1 for configuration, similarly
for 1100-1150, VSET0 will be the configuration register.

I will have structure like:
/*
 * struct tps62360_voltage_sel_table - tps62360 voltage selection table
 *            for seleting the input VSEL for desired output.
 * @min_uV: Minimum microvolts in the range. The voltage is included.
 * @max_uV: Maximum microvolts in the range. The voltage is excluded.
 * @vsel_in: Input vsel for the range (min_uV <= uV < max_uV) of voltage.
 */
struct tps62360_voltage_sel_table {
        int min_uV;
        int max_uV;
        int vsel_in;
}

/*
 * struct tps62360_regulator_platform_data - tps62360 regulator platform data.
 *::::::::::::::;
* @vsel_table: the lookup table for different voltages and correspondinf input
 *              voltage selection.
 * @vsel_table_size: Number of entry in vsel_table.
 */

struct tps62360_regulator_platform_data {
        struct regulator_init_data *reg_init_data;
        :::::::::::::
        struct tps62360_voltage_sel_table *vsel_table;
        int vsel_table_size;
};


Is it inline with your suggestion?
