Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933414Ab2GCGst (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 02:48:49 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:41191 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933111Ab2GCGss convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 02:48:48 -0400
From: "AnilKumar, Chimata" <anilkumar@ti.com>
To: Axel Lin <axel.lin@gmail.com>
CC: "Girdwood, Liam" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: RE: [PATCH 2/2] regulator: tps65217: Fix voltage boundary checking
 in tps65217_pmic_map_voltage
Thread-Topic: [PATCH 2/2] regulator: tps65217: Fix voltage boundary checking
 in tps65217_pmic_map_voltage
Thread-Index: AQHNWNxZmY5gFg9gAUCbVVRddR0fhJcXCrbQ
Date: Tue, 3 Jul 2012 06:48:23 +0000
Message-ID: <331ABD5ECB02734CA317220B2BBEABC13E9E8DAD@DBDE01.ent.ti.com>
References: <1341284473.18757.2.camel@phoenix>
	 <1341284755.18757.5.camel@phoenix>
	 <331ABD5ECB02734CA317220B2BBEABC13E9E8CAB@DBDE01.ent.ti.com>
 <1341293168.3241.7.camel@phoenix>
In-Reply-To: <1341293168.3241.7.camel@phoenix>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.133.24]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 03, 2012 at 10:56:08, Axel Lin wrote:
> 
> > Case 1:-
> > ------
> > 
> > tps->info[rid]->min_uV = 600000;
> > tps->info[rid]->max_uV = 1100000;
> > 
> > If we do regulator_set_voltage(reg, 550000, 1100000);
> > 
> > This results into error condition and how can we handle with this?
> 
> In original code, it returns error. ( I think which is wrong.)
> 
> What we want is to set the smallest voltage within the specified voltage
> range.
> With this patch, calling regulator_set_voltage(reg, 550000, 1100000);
> is the same as calling regulator_set_voltage(reg, 600000, 1100000);
> It will set the voltage to 600000 uV.

Suppose
rdev->constraints->min_uV = 600000; /* wrong data entered by user as DT/plat
						data */
rdev->constraints->max_uV = 1500000;

And tps limits (little modification from my previous mail "actual values")

tps->info[rid]->min_uV = 900000;
tps->info[rid]->max_uV = 1800000;

regulator_set_voltage(reg, 850000, 1100000);

In side tps65217_pmic_map_voltage() we have

tps->info[rid]->uv_to_vsel(850000, &sel) nothing but
tps65217_uv_to_vsel1(850000, &sel);

sel = (((850000 - 900000) + (25000) - 1) / (25000));
sel = ((-25001)/(25000));
sel = -1; /* Which is not expected */

Ideally this would be the change

	if (min_uV < tps->info[rid]->min_uV)
		min_uV = tps->info[rid]->min_uV;

	if (max_uV > tps->info[rid]->max_uV)
		max_uV = tps->info[rid]->max_uV;

	if (max_uV < tps->info[rid]->min_uV ||
			min_uV > tps->info[rid]->max_uV)
		return -EINVAL;

If this is not the case then I am completely in a wrong direction.

> 
> > 
> > Case 2:-
> > ------
> > 
> > I think the current code handles this case as well.
> > 
> > There might be a case where board/DT data is false like
> > 
> > tps->info[rid]->min_uV = 1100000;
> > tps->info[rid]->max_uV = 600000;
> > 
> I don't get it.
> You mean the case min_uV is greater than max_uV?
> 
> My understanding of current implementation is that the
> tps->info[rid]->min_uV and tps->info[rid]->max_uV are not controlled by
> board/DT data. They are defined in tps65217_pmic_regs[].

My point here is rdev->constraints->min_uV and rdev->constraints->max_uV
values set from DT/board file. Sorry about the confusion.
This case is taken care by regulator core.

Regards
AnilKumar