Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756339Ab0DANrB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 09:47:01 -0400
Received: from ppsw-1.csi.cam.ac.uk ([131.111.8.131]:41539 "EHLO
	ppsw-1.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755815Ab0DANqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 09:46:54 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4BB4A465.3050305@cam.ac.uk>
Date: Thu, 01 Apr 2010 14:49:25 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20100109 Thunderbird/3.0
MIME-Version: 1.0
To: Jerome Oufella <jerome.oufella@savoirfairelinux.com>
CC: Jean Delvare <khali@linux-fr.org>, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org
Subject: Re: [lm-sensors] [PATCH] hwmon: sht15: Fix sht15_calc_temp  interpolation
 function
References: <1732720040.861270126460533.JavaMail.root@mail.savoirfairelinux.com>
In-Reply-To: <1732720040.861270126460533.JavaMail.root@mail.savoirfairelinux.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/10 13:54, Jerome Oufella wrote:
> ----- "Jean Delvare" <khali@linux-fr.org> wrote :
>> May I suggest the more simple fix below?
>>
>> ---
>>  drivers/hwmon/sht15.c |    4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> --- linux-2.6.34-rc3.orig/drivers/hwmon/sht15.c	2010-04-01
>> 13:41:15.000000000 +0200
>> +++ linux-2.6.34-rc3/drivers/hwmon/sht15.c	2010-04-01
>> 13:41:55.000000000 +0200
>> @@ -305,10 +305,10 @@ static inline int sht15_calc_temp(struct
>>  	int d1 = 0;
>>  	int i;
>>  
>> -	for (i = 1; i < ARRAY_SIZE(temppoints); i++)
>> +	for (i = ARRAY_SIZE(temppoints) - 1; i > 0 ;i--)
>>  		/* Find pointer to interpolate */
>>  		if (data->supply_uV > temppoints[i - 1].vdd) {
>> -			d1 = (data->supply_uV/1000 - temppoints[i - 1].vdd)
>> +			d1 = (data->supply_uV - temppoints[i - 1].vdd)
>>  				* (temppoints[i].d1 - temppoints[i - 1].d1)
>>  				/ (temppoints[i].vdd - temppoints[i - 1].vdd)
>>  				+ temppoints[i - 1].d1;
>>
>> It leads to the same numbers as with Jerome's patch, with the
>> advantages that 1* it is a much smaller change, more suitable for
>> applying to stable kernels and 2* it avoids the magic constant number
>> 10000.
>>
>> The "/1000" seems to be a relict of former times when
>> temppoints[*].vdd
>> was probably expressed in millivolt instead of microvolt. And the
>> inverted loop iteration is obviously a bug.
>>
>> Note that in both cases, something should be done about values which
>> are outside of the temppoints array. I don't know how likely these
>> are,
>> but they are seriously mishandled. For supply_uV values below
>> temppoints[0].vdd, d1 defaults to 0, so no adjustment is done at all.
>> temppoints[0].d1 would seem to be a much better default, if we don't
>> want to do any interpolation in that case. For supply_uV values above
>> temppoints[4].vdd, we do interpolate, which seems reasonable.
>>
>> Opinions?
>>
>> -- 
>> Jean Delvare
> 
> That's fine, it does a good job for me, in the expected voltage range.

Seems sensible.  I'm not quite sure but I think the code in question predates
my involvement with the driver, so I'm guessing I never actually looked
closely enough at it.

Jonathan
