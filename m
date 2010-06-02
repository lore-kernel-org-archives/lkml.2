Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757025Ab0FBJS1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 05:18:27 -0400
Received: from eu1sys200aog114.obsmtp.com ([207.126.144.137]:47177 "EHLO
	eu1sys200aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752819Ab0FBJSZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 05:18:25 -0400
From: Linus WALLEIJ <linus.walleij@stericsson.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Bengt JONSSON <bengt.g.jonsson@stericsson.com>,
       Sundar R IYER <sundar.iyer@stericsson.com>
Date: Wed, 2 Jun 2010 11:18:00 +0200
Subject: RFC: Regulator Framework Voltage Setting
Thread-Topic: Regulator Framework Voltage Setting
Thread-Index: AcsBp8S1KNjr9l3yTQ2pBMAX/YBYfAAjG1sg
Message-ID: <CEE6BB42CAD6E947908279175AF8470A025A8A54F4@EXDCVYMBSTM006.EQ1STM.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-cr-hashedpuzzle: CNG0 FSD4 FktS HArp HGH4 JH83 KGIQ La7q LbAg MsOr OkHQ
 PXF+ SYLX TZEd UVe8
 VUH/;2;YgByAG8AbwBuAGkAZQBAAG8AcABlAG4AcwBvAHUAcgBjAGUALgB3AG8AbABmAHMAbwBuAG0AaQBjAHIAbwAuAGMAbwBtADsAbABpAG4AdQB4AC0AawBlAHIAbgBlAGwAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA=;Sosha1_v1;7;{0DB23768-D772-422A-94BF-4D5DCDB29EA1};bABpAG4AdQBzAC4AdwBhAGwAbABlAGkAagBAAHMAdABlAHIAaQBjAHMAcwBvAG4ALgBjAG8AbQA=;Wed,
 02 Jun 2010 09:18:00
 GMT;UgBGAEMAOgAgAFIAZQBnAHUAbABhAHQAbwByACAARgByAGEAbQBlAHcAbwByAGsAIABWAG8AbAB0AGEAZwBlACAAUwBlAHQAdABpAG4AZwA=
x-cr-puzzleid: {0DB23768-D772-422A-94BF-4D5DCDB29EA1}
acceptlanguage: en-US
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

we have a question regarding the regulator_set_voltage function in the 
regulator framework (drivers/regulator/core.c). The current 
implementation checks the input min and max arguments against the 
constraints and then calls the driver set_voltage operation directly 
without checking the other consumer requests.

In our view it should respect all consumer voltage settings. Then, the 
implementation would (roughly) be to iterate through all consumers and 
make sure all of their latest requests are satisfied.

Our questions:
- Is this the correct interpretation of the current functionality?
- Is the proposed behaviour what you would expect?
- Any other problems to consider?

Below we have given an example to clarify.

Best regards,

Bengt JONSSON
Sundar R IYER
Linus WALLEIJ



Here is an example with three users (consumers) connected to the same 
regulator_dev:

rdev ------ xreg (User X)
        |--- yreg (User Y)
        |--- zreg (User Z)

The users call the regulator framework like this:

1. User X calls regulator_set_voltage(xreg, 2000000, 3000000)
2. User Y calls regulator_set_voltage(yreg, 2100000, 3100000)
3. User Z calls regulator_set_voltage(zreg, 1900000, 2900000)
4. User Y calls regulator_set_voltage(yreg, 1900000, 3100000)
5. User Z calls regulator_set_voltage(zreg, 1900000, 3100000)
6. User X calls regulator_set_voltage(xreg, 4000000, 5000000). Here the 
call should fail.

Assuming there are no constraints, with current implementation, the 
requests would be sent unchanged to the driver. What we would expect 
from the regulator framework is this:

1. The framework calls rdev->desc->ops->set_voltage(rdev, 2000000, 3000000)
2. The framework calls rdev->desc->ops->set_voltage(rdev, 2100000, 3000000)
3. The framework calls rdev->desc->ops->set_voltage(rdev, 2100000, 2900000)
4. The framework calls rdev->desc->ops->set_voltage(rdev, 2000000, 2900000)
5. The framework calls rdev->desc->ops->set_voltage(rdev, 2000000, 3000000)
6. Failed because the ranges do not overlap.


