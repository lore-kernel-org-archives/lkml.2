Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598Ab0DCPhy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Apr 2010 11:37:54 -0400
Received: from bamako.nerim.net ([62.4.17.28]:57463 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752355Ab0DCPht (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Apr 2010 11:37:49 -0400
Date: Sat, 3 Apr 2010 17:37:45 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Jerome Oufella <jerome.oufella@savoirfairelinux.com>,
       lm-sensors <lm-sensors@lm-sensors.org>, linux-kernel@vger.kernel.org,
       Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [lm-sensors] regulator: regulator_get behaviour without 
 CONFIG_REGULATOR set
Message-ID: <20100403173745.2bf17ee6@hyperion.delvare>
In-Reply-To: <20100402204503.GA15237@opensource.wolfsonmicro.com>
References: <2122967437.461270223106350.JavaMail.root@mail.savoirfairelinux.com>
	<1779783481.621270223270264.JavaMail.root@mail.savoirfairelinux.com>
	<20100402160058.GE27613@sirena.org.uk>
	<20100402184403.2ea1263e@hyperion.delvare>
	<20100402185138.GA12817@opensource.wolfsonmicro.com>
	<20100402213010.4a64e50f@hyperion.delvare>
	<20100402204503.GA15237@opensource.wolfsonmicro.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Fri, 2 Apr 2010 21:45:03 +0100, Mark Brown wrote:
> On Fri, Apr 02, 2010 at 09:30:10PM +0200, Jean Delvare wrote:
> > looks much better than
> >
> > /* If a regulator is available, query what the supply voltage actually is!*/
> > 	data->reg = regulator_get(data->dev, "vcc");
> > 	if (!IS_ERR(data->reg)) {
> > 		int voltage = regulator_get_voltage(data->reg);
> > 		if (voltage) {
> > 			data->supply_uV = voltage;
> > 			regulator_enable(data->reg);
> > 			/* setup a notifier block to update this if
> > 			 *  another device causes the voltage to change */
> > 			data->nb.notifier_call = &sht15_invalidate_voltage;
> > 			ret = regulator_register_notifier(data->reg, &data->nb);
> > 		}
> > 	}
> 
> In this case you don't need the if (voltage) check - the code that uses
> supply_uV is going to have to cope with it being set to 0 if the driver
> doesn't just give up, and the enable wants to happen anyway (perhaps
> we've got a switchable supply we can't read the voltage of).  It should
> never make any odds if the notifier never gets called since the supply
> could be invariant.

We still need to check if (voltage) to not overwrite the previous value
of data->supply_uV with 0. We will probably do that as an immediate fix
to the sht15 driver. But yes, the rest doesn't need a condition.

Still, I'd prefer if drivers were just able to check for data->reg ==
NULL and skip the whole thing. Would you apply the following patch?

* * * * *

From: Jean Delvare <khali@linux-fr.org>
Subject: regulator: Let drivers know when they use the stub API

Have the stub variant of regulator_get() return NULL, so that drivers
can (but still don't have to) handle this case specifically.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Jerome Oufella <jerome.oufella@savoirfairelinux.com>
---
 include/linux/regulator/consumer.h |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- linux-2.6.34-rc3.orig/include/linux/regulator/consumer.h	2010-03-09 08:25:30.000000000 +0100
+++ linux-2.6.34-rc3/include/linux/regulator/consumer.h	2010-04-03 17:21:08.000000000 +0200
@@ -183,9 +183,13 @@ static inline struct regulator *__must_c
 {
 	/* Nothing except the stubbed out regulator API should be
 	 * looking at the value except to check if it is an error
-	 * value so the actual return value doesn't matter.
+	 * value. Drivers are free to handle NULL specifically by
+	 * skipping all regulator API calls, but they don't have to.
+	 * Drivers which don't, should make sure they properly handle
+	 * corner cases of the API, such as regulator_get_voltage()
+	 * returning 0.
 	 */
-	return (struct regulator *)id;
+	return NULL;
 }
 static inline void regulator_put(struct regulator *regulator)
 {


Thanks,
-- 
Jean Delvare
