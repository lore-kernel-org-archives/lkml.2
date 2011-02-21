Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754446Ab1BUOtw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 09:49:52 -0500
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:54846 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751800Ab1BUOtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 09:49:51 -0500
Message-ID: <4D627B7F.7000409@metafoo.de>
Date: Mon, 21 Feb 2011 15:49:35 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101226 Icedove/3.0.11
MIME-Version: 1.0
To: Grazvydas Ignotas <notasas@gmail.com>
CC: Anton Vorontsov <cbouatmailru@gmail.com>,
        Pali Rohar <pali.rohar@gmail.com>,
        Rodolfo Giometti <giometti@linux.it>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/14 v3] bq27x00: Cache battery registers
References: <1297539554-13957-8-git-send-email-lars@metafoo.de>	<1297652493-7207-1-git-send-email-lars@metafoo.de>	<AANLkTimn2JYtUSUrJBQKzXrw+URD5n0Y2h7QMaFzKFdY@mail.gmail.com>	<4D59A93A.7090800@metafoo.de>	<AANLkTi=RJfYEoiCPgesmZUoeOy+MehZQWeWDCWoW7vnh@mail.gmail.com>	<AANLkTik6df6X2Jw8m6SYCFi9aN2LZc=C72WCw=gDevOr@mail.gmail.com>	<4D622243.8030507@metafoo.de> <AANLkTinB8i+UK2gb88Fy0zf8EO0nYksTOmZVfDOWRRro@mail.gmail.com>
In-Reply-To: <AANLkTinB8i+UK2gb88Fy0zf8EO0nYksTOmZVfDOWRRro@mail.gmail.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21/2011 03:00 PM, Grazvydas Ignotas wrote:
>>> However there is bigger problem, compiling as module and doing
>>> insmod/rmmod/insmod causes kernel OOPS:
>>>
>>> [  882.575714] BUG: sleeping function called from invalid context at
>>> arch/arm/mm/fault.c:295
>>> [  882.584350] in_atomic(): 0, irqs_disabled(): 128, pid: 1154, name: insmod
>>> ...
>>> [  882.959930] Unable to handle kernel NULL pointer dereference at
>>> virtual address 00000000
>>> [  882.968444] pgd = c14c8000
>>> [  882.977905] Internal error: Oops: 817 [#1]
>>> ...
>>> [  883.304412] [<c007eed8>] (__queue_work+0x140/0x260) from
>>> [<c007f044>] (queue_work_on+0x2c/0x34)
>>> [  883.313568] [<c007f044>] (queue_work_on+0x2c/0x34) from
>>> [<bf008390>] (bq27x00_update+0x1f8/0x220 [bq27x00_battery])
>>> [  883.324584] [<bf008390>] (bq27x00_update+0x1f8/0x220
>>> [bq27x00_battery]) from [<bf0084c8>] (bq27x00_battery_poll+0x14/0x48
>>> [bq27x00_battery])
>>>
>>> full backtrace attached.
>>
>> I can't reproduce that OOPS. And the backtrace looks a bit strange,
>> queue_work_on is not called from bq27x00_update.
>> Can you send me the disassembly of your bq27x00_update?
> 
> It comes from power_supply_changed, probably omitted because
> queue_work is a tail function of power_supply_changed. It's probably
> something i2c specific, I could try bisecting it for you if you like,
> I know it doesn't happen before this series.

Hi

The following patch should hopefully fix the issue.

- Lars

>From 860fc31cef00bd87085100825ddbff82ad601c33 Mon Sep 17 00:00:00 2001
From: Lars-Peter Clausen <lars@metafoo.de>
Date: Mon, 21 Feb 2011 15:34:19 +0100
Subject: [PATCH] Initialize power_supply changed_work before calling device_add

Calling device_add causes a uevent for that device to be generated.
The power_supply uevent function calls the drivers get_property function,
which might causes the driver to update its state, which again might causes
the driver to call power_supply_changed(). Since the power_supplys
changed_work has not been initialized at this point the behavior is
undefined and might result in a OOPS.

This patch fixes the issue by initializing the power_supplys changed_work
prior to adding the power_supplys device to the device tree.

Reported-by: Grazvydas Ignotas <notasas@gmail.com>
Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/power/power_supply_core.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/power/power_supply_core.c b/drivers/power/power_supply_core.c
index 970f733..329b46b 100644
--- a/drivers/power/power_supply_core.c
+++ b/drivers/power/power_supply_core.c
@@ -171,6 +171,8 @@ int power_supply_register(struct device *parent, struct
power_supply *psy)
 	dev_set_drvdata(dev, psy);
 	psy->dev = dev;

+	INIT_WORK(&psy->changed_work, power_supply_changed_work);
+
 	rc = kobject_set_name(&dev->kobj, "%s", psy->name);
 	if (rc)
 		goto kobject_set_name_failed;
@@ -179,8 +181,6 @@ int power_supply_register(struct device *parent, struct
power_supply *psy)
 	if (rc)
 		goto device_add_failed;

-	INIT_WORK(&psy->changed_work, power_supply_changed_work);
-
 	rc = power_supply_create_triggers(psy);
 	if (rc)
 		goto create_triggers_failed;
-- 
1.7.2.3

