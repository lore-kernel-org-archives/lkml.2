Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755228Ab0KJT4l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 14:56:41 -0500
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:37416 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752734Ab0KJT4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 14:56:40 -0500
Message-ID: <4CDAF8E4.7030609@euromail.se>
Date: Wed, 10 Nov 2010 20:56:20 +0100
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Guenter Roeck <guenter.roeck@ericsson.com>
CC: Jean Delvare <khali@linux-fr.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] hwmon: (applesmc) Fix checkpatch errors
References: <1289415200-4928-1-git-send-email-guenter.roeck@ericsson.com> <4CDAE9D7.3060007@euromail.se> <20101110193930.GA31650@ericsson.com>
In-Reply-To: <20101110193930.GA31650@ericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1PGGmN-0002dM-5z.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1PGGmN-0002dM-5z 56d311bfa35cd3196ee3d46d51517093
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> @@ -977,7 +975,11 @@ static ssize_t applesmc_key_at_index_show

>>>  static ssize_t applesmc_key_at_index_store(struct device *dev,
>>>  	struct device_attribute *attr, const char *sysfsbuf, size_t count)
>>>  {
>>> -	key_at_index = simple_strtoul(sysfsbuf, NULL, 10);
>>> +	unsigned long newkey;
>>> +
>>> +	if (strict_strtoul(sysfsbuf, 10, &newkey) < 0)
>>> +		return -EINVAL;
>>> +	key_at_index = newkey;
>>
>>
>> Crash alert - key_at_index is not range checked, and the remake uses this value
>> as an array index...
>>
> Good that I made this change ;). I'll add the check and re-send.


Indeed! The downside of remakes... sorry about that. :-)

I guess the change should go into patch 4 already? There is also the option to
put the bounds check in applesmc_get_entry_by_index, but I like the simplicity
of "|| newkey >= smcreg.key_count".

> This points to another problem, though. You allocate key_count entries,
> ie cache[0]..cache[key_count-1]. Yet, the key searches are from 0..key_count,
> ie span key_count+1 entries. Is that another problem ?

>

> Seems to me you would either have to allocate key_count+1 entries, or terminate
> the search at key_count - 1. Not sure which one would be correct. Let me know,
> and I'll update the affected patch(es).


If you are referring to the lower and upper bound functions, those use the
one-past-the-last-element convention, so it is actually still 0..key_count - 1.
I stayed very close to the stl reference implementation, which relies on the
fact that when begin != end, (begin + (end - begin) / 2) < end.

Cheers,
Henrik
