Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486Ab0KEIfj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 04:35:39 -0400
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:35089 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752109Ab0KEIfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 04:35:37 -0400
Message-ID: <4CD3C1A8.5050305@euromail.se>
Date: Fri, 05 Nov 2010 09:34:48 +0100
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Guenter Roeck <guenter.roeck@ericsson.com>
CC: Jean Delvare <khali@linux-fr.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
Subject: Re: [lm-sensors] [PATCH 4/8] hwmon: applesmc: Handle new temperature
 format
References: <1288511434-5662-1-git-send-email-rydberg@euromail.se> <1288511434-5662-5-git-send-email-rydberg@euromail.se> <20101105023525.GC28308@ericsson.com>
In-Reply-To: <20101105023525.GC28308@ericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1PEHla-0003kw-Ah.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1PEHla-0003kw-Ah 7e04fb9566e6e02620977cbd6ea18144
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>

>> diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
>> index 0207618..ec92aff 100644
>> --- a/drivers/hwmon/applesmc.c
>> +++ b/drivers/hwmon/applesmc.c
>> @@ -733,13 +733,19 @@ static ssize_t applesmc_show_temperature(struct device *dev,
>>  	ret = applesmc_get_entry_by_index(index, &entry);
>>  	if (ret)
>>  		return ret;
>> +	if (entry.len > 2)
>> +		return -EINVAL;
>>  
>> -	ret = applesmc_read_entry(&entry, buffer, 2);
>> +	ret = applesmc_read_entry(&entry, buffer, entry.len);
>>  	if (ret)
>>  		return ret;
>>  
>> -	temp = buffer[0]*1000;
>> -	temp += (buffer[1] >> 6) * 250;
>> +	if (entry.len == 2) {
>> +		temp = buffer[0]*1000;
>> +		temp += (buffer[1] >> 6) * 250;
>> +	} else {
>> +		temp = buffer[0] * 4000;
>> +	}
> 
> Another comment - in the next patch, you check for entry.len == 0.
> If that can happen, you would need to check it here as well.


It cannot happen after a succesful return from get_entry(), but I will check it
again. Earlier versions used entry.len rather than entry.valid, which can still
be seen in a few places.

Thanks,
Henrik
