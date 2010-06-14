Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756656Ab0FNV3E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 17:29:04 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:62412 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754856Ab0FNV3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 17:29:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=AvBEDp9GlMIxLO+dB+BIxkOUL/4NAk/AHjQrstJiNZwy/WcoEMOvsFIWxS10nQqs3c
         k2cHP1B94Ft67H3VBFgDAmfNZmHq7kKIOcpe7ckyxahtsJaxsbzrJ/t4ycPpBqMAexdM
         HU8pI66uOrgF9S4GwIhdWgP66iaGdeI0ysO90=
Message-ID: <4C169F19.1040608@gmail.com>
Date: Mon, 14 Jun 2010 14:28:57 -0700
From: David Daney <david.s.daney@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: "Justin P. Mattock" <justinmattock@gmail.com>,
       linux-kernel@vger.kernel.org, reiserfs-devel@vger.kernel.org,
       linux-bluetooth@vger.kernel.org, clemens@ladisch.de,
       debora@linux.vnet.ibm.com, dri-devel@lists.freedesktop.org,
       linux-i2c@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
       linux-media@vger.kernel.org
Subject: Re: [PATCH 6/8]i2c:i2c_core Fix warning: variable 'dummy' set but
 not used
References: <1276547208-26569-1-git-send-email-justinmattock@gmail.com>	<1276547208-26569-7-git-send-email-justinmattock@gmail.com> <20100614225315.2bae9e37@hyperion.delvare>
In-Reply-To: <20100614225315.2bae9e37@hyperion.delvare>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2010 01:53 PM, Jean Delvare wrote:
> Hi Justin,
>
> On Mon, 14 Jun 2010 13:26:46 -0700, Justin P. Mattock wrote:
>> could be a right solution, could be wrong
>> here is the warning:
>>    CC      drivers/i2c/i2c-core.o
>> drivers/i2c/i2c-core.c: In function 'i2c_register_adapter':
>> drivers/i2c/i2c-core.c:757:15: warning: variable 'dummy' set but not used
>>
>>   Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
>>
>> ---
>>   drivers/i2c/i2c-core.c |    2 ++
>>   1 files changed, 2 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
>> index 1cca263..79c6c26 100644
>> --- a/drivers/i2c/i2c-core.c
>> +++ b/drivers/i2c/i2c-core.c
>> @@ -794,6 +794,8 @@ static int i2c_register_adapter(struct i2c_adapter *adap)
>>   	mutex_lock(&core_lock);
>>   	dummy = bus_for_each_drv(&i2c_bus_type, NULL, adap,
>>   				 __process_new_adapter);
>> +	if(!dummy)
>> +		dummy = 0;
>
> One word: scripts/checkpatch.pl
>
> In other news, the above is just plain wrong. First we force people to
> read the result of bus_for_each_drv() and then when they do and don't
> need the value, gcc complains, so we add one more layer of useless
> code, which developers and possibly tools will later wonder and
> complain about? I can easily imagine that a static code analyzer would
> spot the above code as being a potential bug.
>
> Let's stop this madness now please.
>
> Either __must_check goes away from bus_for_each_drv() and from every
> other function which raises this problem, or we must disable that new
> type of warning gcc 4.6.0 generates. Depends which warnings we value
> more, as we can't sanely have both.
>

That is the crux of the whole thing.  Putting in crap to get rid of the 
__must_check warning someone obviously wanted to provoke is just plain 
wrong.

I don't know what the answer is, but in addition to your suggestion of 
removing the __must_check, you might try:

BUG_ON(dummy != WHAT_IT_SHOULD_BE);

or

if (dummy != WHAT_IT_SHOULD_BE)
	panic("nice message here);


or

static inline void i_really_know_what_i_am_doing(int arg)
{
	/*
	 * Trick the compiler because we don't want to
	 * handle error conditions.
	 */
	return;
}

.
.
.

	i_really_know_what_i_am_doing(dummy);



David Daney

