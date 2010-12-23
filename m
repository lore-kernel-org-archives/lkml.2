Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752442Ab0LWCKo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 21:10:44 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52385 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139Ab0LWCKn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 21:10:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=ZWEq9uHHVgFcBN6bdPXSMF9aVVb6bDerRTGEOKy5E+lAWgrpRDRny4/eljk+P5o4XY
         5W9sl/MA2QxOI0OsB1y4yyduoNyS7QReOkTD+MxxFuy9Wcms4LVsDfyWLD9fiz6Lqzp7
         KzKJa+zmVRWZuhRya1IiFM0M9jcN3esee3Tcc=
MIME-Version: 1.0
In-Reply-To: <20101222133359.GF26306@opensource.wolfsonmicro.com>
References: <20101221155004.GA21871@opensource.wolfsonmicro.com>
	<1292998991-26968-6-git-send-email-myungjoo.ham@samsung.com>
	<20101222133359.GF26306@opensource.wolfsonmicro.com>
Date: Thu, 23 Dec 2010 11:10:41 +0900
X-Google-Sender-Auth: Jrh0Y8JVh4K-HEpYxO5RV2aL8MI
Message-ID: <AANLkTimhfUTD0ze8VaBz9BtkuEMx9sutc-1VvsXfH-ot@mail.gmail.com>
Subject: Re: [PATCH v2 5/6] MFD MAX8998/LP3974: Charger Support
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 22, 2010 at 10:33 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Wed, Dec 22, 2010 at 03:23:10PM +0900, MyungJoo Ham wrote:
>> With the new regulator, "CHARGER", users can control charging
>> current and turn on and off the charger. Note that the charger
>> specification of LP3974 is different from that of MAX8998.
>>
>> "CHARGER_ONLINE" monitors the charger status, which can be
>> different from the status "CHARGER"; e.g., users allowed the charger
>> to charge, but the MAX8998 chip decided not to do so.
>>
>> "BATTERY_ONLINE" monitors the battery status (the existence of the
>> battery).
>
> Normally I'd expect a battery charger to be exposed via the power supply
> API - I'd at least expect to see a consumer in the power supply API
> which manages the charger and given the amount of automation you usually
> see in chargers integrated into PMICs (things like automatically
> starting and stopping themselves) it's not entirely clear that they map
> on that well to the regulator API.
>

The "CHARGER" regulator is to give the charger control to the user,
which consists of switching (turn on/off) and current limit, which is
what a current regulator does. On the contrary, when the charger
control is implemented by power supply API, we do not have explicit
control over such features (current limit and turn on/off).

Yes, PMICs including MAX8998/LP3974 can turn the charger on/off
automatically; however, users (or board designers) still want explicit
control over charger.

For example, there could be a thermistor attached on a board (out of
PMIC) reading battery temperature, which is used to cut the charger
off if it's too hot or cold; then, we cannot rely on PMIC's automatic
control unless we put thermistor drivers into PMIC driver.
MAX8998/LP3974 has a thermistor in it; however, it measures the chip
core temperature, not the ambient temperature.

Furthermore, a board may need to support multiple types of
charger(USB, ACDC-5V-2A, ACDC-5V-1A, ...), which have various current
limits. Thus, we need to adjust charger current limit out of PMIC
driver unless the PMIC can detect every type of supported chargers,
which MAX8998/LP3974 cannot.

That's why I have implemented charger in regulator framework. In the
environment described above, the power supply consumer is going to be
implemented over PMIC driver, USB/TA select driver (e.g., FSA9480),
and Thermistor driver (e.g., NTC Thermistor). It appears that such a
consumer driver is going to be a board or policy specification; (or
full or callbacks that is going to be filled by a mach/board file)



Thanks.

- MyungJoo

-- 
MyungJoo Ham (함명주), Ph.D.
Mobile Software Platform Lab,
Digital Media and Communications (DMC) Business
Samsung Electronics
cell: 82-10-6714-2858
