Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758516Ab2EIIJh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 04:09:37 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:9413 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757918Ab2EIIJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 04:09:32 -0400
X-AuditID: cbfee60d-b7b94ae000004ede-c7-4faa263a638f
Date: Wed, 09 May 2012 08:09:30 +0000 (GMT)
From: =?euc-kr?B?x9S47cHW?= <myungjoo.ham@samsung.com>
Subject: Re: RE: [PATCH v2] charger_manager: update charge profile upon
 temperature zone change
To: "Pallala, Ramakrishna" <ramakrishna.pallala@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        =?euc-kr?Q?=C3=D6=C2=F9=BF=EC?= <cw00.choi@samsung.com>,
        jenny.tc@intel.com
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20120509080844297@myungjoo.ham
Msgkey: 20120509080844297@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20120509080844297@myungjoo.ham
X-ParentMTR: 
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <19644772.137541336550969403.JavaMail.weblogic@epml16>
X-Brightmail-Tracker: AAAAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q4989pGV001132

> > > This patch allows the Charger-Manager to adjust the charging
> > > parameters upon events like VBUS rise or drop and allows batteries to
> > > have multiple charge profiles for different temperature zones.
> > >
> > > Signed-off-by: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
> > 
> > I don't see how the parameters are changed when update_charger is true.
> My initial thought was to keep these details hide from CM.

We are integrating charger max current configuration with charger status:
e.g., whether "TA" is connected, "USB" is connected, or "Solar" is connected
should determine the current configuration. In our testbed system, if "TA" is
connected, it becomes (regulator_set_current_limit) < 1A and it becomes 500mA
if "USB 2.0" is connected.

Such information is given to the charger manager instance via charger_desc along
with current limit. We will release the patchset after applying and testing in
our testbed.

Thus, the details may/should be in CM; we will be controlling them in CM anyway.

The data structure will look like this (this is an abstract and psuedo):
struct charger_cable {
	const char *extcon_dev_name;
	const char *extcon_cable_name;
	unsigned long current_uA;
};
struct charger {
	const char *regulator_name;
	ARRAY of struct charger_cable;
};
struct charger_desc {
	...
	ARRAY of struct charger;
};

I'm not sure whether the final value will be max(enabled_cable_uA) or
sum(enabled_cable_uA). And we might need another "current_limit_uA"
in struct charger.

> 
> > Are you intending to do it at userspace after getting uevent_notify()? (I don't think
> > it's good)
> No, we will do it from driver only.

Fine.

> 
> > If the intension is to update some of the charger-manager internal parameters (struct
> > charger_manager's struct charger_desc) according to the temperature, we'd need a more
> > general method that can also update values in the charger-manager context.
> > 
> > For example, instead of simply putting a callback to determine whether an update is
> > required or not, a table of (including hysterisis) temperatures and values to be updated
> > (or callbacks to update charger_desc based on the temperature) might be a starting
> > point. You may also need to consider using notifier chain w/ temperatures.
> > 
> Yes I agree, I will submit another patch with these changes.
> 
> As part of charge enablement we generally program charge current, charge voltage
> into the charger chip.
> 
> We can pass the charging parameters CC and CV in two ways.
> 1. Add these params in charger_desc struct and the  charger regulator can get these
> params using container_of() call? but becomes complex.
> 
> 2. use regulator_set_voltage()/regulator_set_current_limit() functions to set the CV and CC params.
> but not suitable as is, we have add support in regulator framework
> 
> 3. use regulator_get_drvdata()/regulator_set_drvdata() to set CC & CV params. These functions
> allow us to add more params in future if required.
> 
> I am thinking of using option 3.
> 
> Let me know your feedback.

I'd suggest you to do option 2 with the following interface.

Anyway, (reading another mails from this thread) it appears that it may look
like this, assuming that the charger_current control regarding the charger-type
based on Extcon cannot be applied to this:

struct charger_temp_notify {
	bool high; /* true: notifies if it goes higher from lower */
	int notify_mC;
	int recovery_mC;
	struct notifier_block nb;
	struct charger_desc *desc; /* CM will automatically set this */
};
struct charger_desc {
	...
	ARRAY of struct charger_temp_notify;
};

If you want to alarm at 80C and turn it off at 75C;
	{ high = true, notify_mC = 80000, recovery_mc = 75000, ... };

Then you can handle temperature-based events at your own charger device driver.


Cheers!
MyungJoo.

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
