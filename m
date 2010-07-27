Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753077Ab0G0VEj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 17:04:39 -0400
Received: from mail.bluewatersys.com ([202.124.120.130]:6350 "EHLO
	hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750996Ab0G0VEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 17:04:38 -0400
Message-ID: <4C4F4A0C.7010807@bluewatersys.com>
Date: Wed, 28 Jul 2010 09:05:16 +1200
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Anton Vorontsov <cbouatmailru@gmail.com>
CC: Geert Uytterhoeven <geert@linux-m68k.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
        Yulia Vilensky <vilensky@compulab.co.il>
Subject: [PATCH] Fix ds2782 battery driver units (was Re: [GIT PULL] battery-2.6.35.git)
References: <20100727135115.GA31789@oksana.dev.rtsoft.ru> <AANLkTim77oCDk9L8oYE5DCEKqZL_L_dm=mm-46=MZwX7@mail.gmail.com> <20100727141331.GA5394@oksana.dev.rtsoft.ru>
In-Reply-To: <20100727141331.GA5394@oksana.dev.rtsoft.ru>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/28/2010 02:13 AM, Anton Vorontsov wrote:
> On Tue, Jul 27, 2010 at 04:03:14PM +0200, Geert Uytterhoeven wrote:
>   
>> On Tue, Jul 27, 2010 at 15:51, Anton Vorontsov <cbouatmailru@gmail.com> wrote:
>>     
>>> diff --git a/drivers/power/ds2782_battery.c b/drivers/power/ds2782_battery.c
>>> index d762a0c..9b3b4b7 100644
>>> --- a/drivers/power/ds2782_battery.c
>>> +++ b/drivers/power/ds2782_battery.c
>>> @@ -43,10 +43,9 @@
>>>  struct ds278x_info;
>>>
>>>  struct ds278x_battery_ops {
>>> -       int     (*get_current)(struct ds278x_info *info, int *current_uA);
>>> -       int     (*get_voltage)(struct ds278x_info *info, int *voltage_uA);
>>> -       int     (*get_capacity)(struct ds278x_info *info, int *capacity_uA);
>>> -
>>> +       int (*get_battery_current)(struct ds278x_info *info, int *current_uA);
>>> +       int (*get_battery_voltage)(struct ds278x_info *info, int *voltage_uA);
>>> +       int (*get_battery_capacity)(struct ds278x_info *info, int *capacity_uA);
>>>       
>> What's the meaning of these `uA' namings? At first I thought `micro Ampère', but
>> that can't be correct for voltage (`uV'?) and capacity (`uAh'?).
>>     
> Yeah, the names aren't quite right. But they were wrong before
> that patch too, so a patch on top to fix these issues will work.
>
> Cc'ing driver authors.
>
> Thanks Geert!
>   

Thanks for pointing this out. The following untested patch fixes the
units in the variable names.

~Ryan

---
Correct the unit names in the ds2782 battery driver. Changes voltage_uA
to voltage_uV and capacity_uA to capacity.

Signed-off-by: Ryan Mallon <ryan@bluewatersys.com>
---

diff --git a/drivers/power/ds2782_battery.c b/drivers/power/ds2782_battery.c
index 9b3b4b7..d9a3b59 100644
--- a/drivers/power/ds2782_battery.c
+++ b/drivers/power/ds2782_battery.c
@@ -44,8 +44,8 @@ struct ds278x_info;
 
 struct ds278x_battery_ops {
 	int (*get_battery_current)(struct ds278x_info *info, int *current_uA);
-	int (*get_battery_voltage)(struct ds278x_info *info, int *voltage_uA);
-	int (*get_battery_capacity)(struct ds278x_info *info, int *capacity_uA);
+	int (*get_battery_voltage)(struct ds278x_info *info, int *voltage_uV);
+	int (*get_battery_capacity)(struct ds278x_info *info, int *capacity);
 };
 
 #define to_ds278x_info(x) container_of(x, struct ds278x_info, battery)
@@ -137,7 +137,7 @@ static int ds2782_get_current(struct ds278x_info *info, int *current_uA)
 	return 0;
 }
 
-static int ds2782_get_voltage(struct ds278x_info *info, int *voltage_uA)
+static int ds2782_get_voltage(struct ds278x_info *info, int *voltage_uV)
 {
 	s16 raw;
 	int err;
@@ -149,7 +149,7 @@ static int ds2782_get_voltage(struct ds278x_info *info, int *voltage_uA)
 	err = ds278x_read_reg16(info, DS278x_REG_VOLT_MSB, &raw);
 	if (err)
 		return err;
-	*voltage_uA = (raw / 32) * 4800;
+	*voltage_uV = (raw / 32) * 4800;
 	return 0;
 }
 
@@ -177,7 +177,7 @@ static int ds2786_get_current(struct ds278x_info *info, int *current_uA)
 	return 0;
 }
 
-static int ds2786_get_voltage(struct ds278x_info *info, int *voltage_uA)
+static int ds2786_get_voltage(struct ds278x_info *info, int *voltage_uV)
 {
 	s16 raw;
 	int err;
@@ -189,7 +189,7 @@ static int ds2786_get_voltage(struct ds278x_info *info, int *voltage_uA)
 	err = ds278x_read_reg16(info, DS278x_REG_VOLT_MSB, &raw);
 	if (err)
 		return err;
-	*voltage_uA = (raw / 8) * 1220;
+	*voltage_uV = (raw / 8) * 1220;
 	return 0;
 }
 

