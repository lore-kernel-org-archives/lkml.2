Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065Ab0EQQfW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 12:35:22 -0400
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:53733 "EHLO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751735Ab0EQQfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 12:35:21 -0400
Subject: Re: [linux-pm] Power Domain Framework
From: Sundar R Iyer <sundar.iyer@stericsson.com>
Reply-To: <sundar.iyer@stericsson.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Deepak Sikri <deepak.sikri79@gmail.com>,
       Viresh KUMAR <viresh.kumar@st.com>,
       Rajeev KUMAR <rajeev-dlh.kumar@st.com>,
       Armando VISCONTI <armando.visconti@st.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Vipin KUMAR <vipin.kumar@st.com>, Shiraz HASHIM <shiraz.hashim@st.com>,
       "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
       Linus WALLEIJ <linus.walleij@stericsson.com>,
       STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>
In-Reply-To: <AANLkTiniwUDg8rQzwgm_X7EbkQJ9tHzBfVtaJRiNE9az@mail.gmail.com>
References: <AANLkTinZU1D1rMOBQDi47tRhXrOXwduQIdni7bCXdce0@mail.gmail.com>
	 <20100510140527.GG5199@sirena.org.uk>
	 <AANLkTikyqnKDNz7FIUvLDAvBReHskHvRCrEz2qBBqseH@mail.gmail.com>
	 <20100517031613.GA3130@opensource.wolfsonmicro.com>
	 <AANLkTimDdBCnRFMDiUkuNKanOzuPNwCpfRv9Gsi03Lsy@mail.gmail.com>
	 <AANLkTinZRhUpFTOOUCdH5dEl3QaXn10USL_hPPQX8cie@mail.gmail.com>
	 <20100517143319.GC5257@opensource.wolfsonmicro.com>
	 <AANLkTiniwUDg8rQzwgm_X7EbkQJ9tHzBfVtaJRiNE9az@mail.gmail.com>
Content-Type: text/plain
Organization: STEricsson
Date: Mon, 17 May 2010 22:05:07 +0530
Message-ID: <1274114107.20589.64.camel@bnru01>
MIME-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-17 at 18:23 +0200, Sundar wrote:
> P.S : Let me post out the patch set following on.

Sorry to change the email-ID; didnt want to would break patch
readability.

The implementation follows:

The regulator framework states that any source which supplies 
power to a peripheral can be modeled as a regulator. However,
in new SoCs where peripherals apart from being powered through
the conventional regulators, peripherals are also powered through
on-chip domains. These on-chip domains control enabling/disabling
and also controlling the output to the peripheral as full mode
or idle mode (retention). These power sources don.t allow control 
of parameters like DRMS, current, voltage etc. 

Also, in such designs, often individual domains are clubbed under
a unified domain. In such a case, smaller domains need to communicate
to the parent domain in case of a constraining request from its peripheral(s).

Domain ABC
	|---Periph Domain A, (100OPP/50OPP),
			to run at 100OPP, parent to run at 100OPP
	|---Periph Domain B, (100OPP),
			to run at 100OPP, parent to run at 100OPP
	|---Periph Domain C, (100OPP/50OPP),
			to run at 100OPP, parent to run at 100OPP

Thus, for ideal power saving modes, the Domain ABC can be turned
to a lower OPP if 
	- Periph B is not running
	- Periph A/C are running at 50OPP only.

This patch set adds a function for controlling the OPPs, 
not touching the existing voltage/mode functions, as they
are needed in their own way for conventional regulators.

Sundar R Iyer (1):
  regulators : Regulator Operating Points

---
 drivers/regulator/core.c           |   79 ++++++++++++++++++++++++++++++++++++
 include/linux/regulator/consumer.h |   27 ++++++++++++
 include/linux/regulator/driver.h   |    5 ++
 include/linux/regulator/machine.h  |    6 +++
 4 files changed, 117 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
old mode 100644
new mode 100755
index 2248087..7c6c5af
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1898,6 +1898,85 @@ out:
 }
 EXPORT_SYMBOL_GPL(regulator_set_optimum_mode);
 
+/* locks held by regulator_set_operating_point() */
+static int _regulator_set_operating_point(struct regulator_dev *rdev,
+		unsigned int opp)
+{
+	int ret, regulator_curr_opp = 0;
+
+	if (!(rdev->constraints->valid_ops_mask & REGULATOR_CHANGE_OPP)) {
+		printk(KERN_ERR "%s: operation not allowed for %s\n",
+				__func__, rdev->desc->name);
+		return -EPERM;
+	}
+
+	/* sanity checks */
+	if (!rdev->desc->ops->set_operating_point) {
+		return -EINVAL;
+	}
+
+	if (rdev->desc->ops->get_operating_point)
+		regulator_curr_opp = rdev->desc->ops->get_operating_point(rdev);
+
+	/* we have no issues with upgrading the opp */
+	if (opp == REGULATOR_OPERATINGPOINT_FULL) {
+		if (rdev->constraints->opp_constraint_count < 1) {
+			if (rdev->supply)
+				ret = _regulator_set_operating_point(rdev->supply, opp);
+			ret = rdev->desc->ops->set_operating_point(rdev, opp);
+		}
+		rdev->constraints->opp_constraint_count++;
+	}
+
+	if (opp == REGULATOR_OPERATINGPOINT_IDLE) {
+		rdev->constraints->opp_constraint_count--;
+		/* if there r no constraints */
+		if (rdev->constraints->opp_constraint_count == 0) {
+			if (rdev->supply)
+				ret = _regulator_set_operating_point(rdev->supply, opp);
+
+			ret = rdev->desc->ops->set_operating_point(rdev, opp);
+		}
+	}
+
+	return ret;
+}
+
+/**
+ * regulator_set_operating_point - set regulator operating point
+ * @regulator: regulator source
+ * @opp: operating point to set
+ *
+ * sets the operating point for a regulator.
+ * this is not to be confused the regulator modes. For smart regulators
+ * that can run at varied operating points, clients can request simply
+ * operating points rather than notional load values.
+ *
+ * For eg, an on-chip regulator source for a peripheral like multimedia can
+ *  - run at a full operating point for a full 1020p,
+ *  - run at half the operating point for something like QVGA.
+ *
+ * All on-chip power domains can be modelled as regulators, and their controls
+ * through this function.
+ *
+ * Returns the new regulator operating point or error.
+ */
+int regulator_set_operating_point(struct regulator *regulator, unsigned int opp)
+{
+	struct regulator_dev *rdev = regulator->rdev;
+	int ret;
+
+	mutex_lock(&rdev->mutex);
+	ret = _regulator_set_operating_point(rdev, opp);
+	mutex_unlock(&rdev->mutex);
+
+	return ret;
+
+}
+EXPORT_SYMBOL_GPL(regulator_set_operating_point);
+
+
+
 /**
  * regulator_register_notifier - register regulator event notifier
  * @regulator: regulator source
diff --git a/include/linux/regulator/consumer.h b/include/linux/regulator/consumer.h
old mode 100644
new mode 100755
index ebd7472..680ec30
--- a/include/linux/regulator/consumer.h
+++ b/include/linux/regulator/consumer.h
@@ -82,6 +82,30 @@
 #define REGULATOR_MODE_STANDBY			0x8
 
 /*
+ * Regulator operating points
+ *
+ * Fast, switchable supplies for peripherals which are controlled
+ * via on-chip power domains are different from normal regulators
+ * which control voltages, current, drms etc. For such power domain
+ * supplies aka regulators, all that can be controlled is the operating
+ * point, OPP. Such regulators can be either on with full voltage, or
+ * partially on at retention/normal voltages (specific to SoC settings)
+ *
+ * these flags can be used to model "power domains" on SoCs in the main
+ * regulator framework
+ *
+ * Also, for such power domains, turning on/off can be handled through
+ * the regulator enable/disable calls
+ *
+ * FULL	Regulator runs at the full output
+ * HALF	Regulator runs at the half output
+ *
+ * these OPPs can be OR'ed together to make a mask of valid regulator OPPs
+ */
+#define REGULATOR_OPERATINGPOINT_FULL		0x1
+#define REGULATOR_OPERATINGPOINT_IDLE		0x2
+
+/*
  * Regulator notifier events.
  *
  * UNDER_VOLTAGE  Regulator output is under voltage.
@@ -160,6 +184,9 @@ int regulator_get_current_limit(struct regulator *regulator);
 
 int regulator_set_mode(struct regulator *regulator, unsigned int mode);
 unsigned int regulator_get_mode(struct regulator *regulator);
+
+int regulator_set_operating_point(struct regulator *regulator, unsigned int opp);
+
 int regulator_set_optimum_mode(struct regulator *regulator, int load_uA);
 
 /* regulator notifier block */
diff --git a/include/linux/regulator/driver.h b/include/linux/regulator/driver.h
old mode 100644
new mode 100755
index 592cd7c..e5be16b
--- a/include/linux/regulator/driver.h
+++ b/include/linux/regulator/driver.h
@@ -122,6 +122,11 @@ struct regulator_ops {
 
 	/* set regulator suspend operating mode (defined in regulator.h) */
 	int (*set_suspend_mode) (struct regulator_dev *, unsigned int mode);
+
+	/* set regulator operating point */
+	int (*set_operating_point) (struct regulator_dev *, int opp);
+	int (*get_operating_point) (struct regulator_dev *);
+
 };
 
 /*
diff --git a/include/linux/regulator/machine.h b/include/linux/regulator/machine.h
old mode 100644
new mode 100755
index e298028..185a5d5
--- a/include/linux/regulator/machine.h
+++ b/include/linux/regulator/machine.h
@@ -39,6 +39,7 @@ struct regulator;
 #define REGULATOR_CHANGE_MODE		0x4
 #define REGULATOR_CHANGE_STATUS		0x8
 #define REGULATOR_CHANGE_DRMS		0x10
+#define REGULATOR_CHANGE_OPP		0x20
 
 /**
  * struct regulator_state - regulator state during low power system states
@@ -109,6 +110,9 @@ struct regulation_constraints {
 	/* valid operations for regulator on this machine */
 	unsigned int valid_ops_mask;
 
+	/* valid operating point ranges for this regulator */
+	unsigned int valid_opp_mask;
+
 	/* regulator input voltage - only if supply is another regulator */
 	int input_uV;
 
@@ -125,6 +129,8 @@ struct regulation_constraints {
 	unsigned always_on:1;	/* regulator never off when system is on */
 	unsigned boot_on:1;	/* bootloader/firmware enabled regulator */
 	unsigned apply_uV:1;	/* apply uV constraint if min == max */
+	unsigned int opp_constraint_count; /* clients enforcing a constraint */
+
 };
 
 /**
-- 
1.7.0



