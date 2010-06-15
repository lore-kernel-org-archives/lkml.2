Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756793Ab0FOQUm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 12:20:42 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:3095 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753079Ab0FOQUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 12:20:40 -0400
Message-ID: <4C17A857.8030306@caviumnetworks.com>
Date: Tue, 15 Jun 2010 09:20:39 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: David Daney <david.s.daney@gmail.com>,
       "Justin P. Mattock" <justinmattock@gmail.com>,
       linux-kernel@vger.kernel.org, reiserfs-devel@vger.kernel.org,
       linux-bluetooth@vger.kernel.org, clemens@ladisch.de,
       debora@linux.vnet.ibm.com, dri-devel@lists.freedesktop.org,
       linux-i2c@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
       linux-media@vger.kernel.org
Subject: Re: [PATCH 6/8]i2c:i2c_core Fix warning: variable 'dummy' set but
  not used
References: <1276547208-26569-1-git-send-email-justinmattock@gmail.com>	<1276547208-26569-7-git-send-email-justinmattock@gmail.com>	<20100614225315.2bae9e37@hyperion.delvare>	<4C169F19.1040608@gmail.com> <20100615134039.6ccfc17a@hyperion.delvare>
In-Reply-To: <20100615134039.6ccfc17a@hyperion.delvare>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Jun 2010 16:20:39.0833 (UTC) FILETIME=[B1DCC090:01CB0CA6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/15/2010 04:40 AM, Jean Delvare wrote:
> Hi David,
>
> On Mon, 14 Jun 2010 14:28:57 -0700, David Daney wrote:
>> On 06/14/2010 01:53 PM, Jean Delvare wrote:
>>> Hi Justin,
>>>
>>> On Mon, 14 Jun 2010 13:26:46 -0700, Justin P. Mattock wrote:
>>>> could be a right solution, could be wrong
>>>> here is the warning:
>>>>     CC      drivers/i2c/i2c-core.o
>>>> drivers/i2c/i2c-core.c: In function 'i2c_register_adapter':
>>>> drivers/i2c/i2c-core.c:757:15: warning: variable 'dummy' set but not used
>>>>
>>>>    Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
>>>>
>>>> ---
>>>>    drivers/i2c/i2c-core.c |    2 ++
>>>>    1 files changed, 2 insertions(+), 0 deletions(-)
>>>>
>>>> diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
>>>> index 1cca263..79c6c26 100644
>>>> --- a/drivers/i2c/i2c-core.c
>>>> +++ b/drivers/i2c/i2c-core.c
>>>> @@ -794,6 +794,8 @@ static int i2c_register_adapter(struct i2c_adapter *adap)
>>>>    	mutex_lock(&core_lock);
>>>>    	dummy = bus_for_each_drv(&i2c_bus_type, NULL, adap,
>>>>    				 __process_new_adapter);
>>>> +	if(!dummy)
>>>> +		dummy = 0;
>>>
>>> One word: scripts/checkpatch.pl
>>>
>>> In other news, the above is just plain wrong. First we force people to
>>> read the result of bus_for_each_drv() and then when they do and don't
>>> need the value, gcc complains, so we add one more layer of useless
>>> code, which developers and possibly tools will later wonder and
>>> complain about? I can easily imagine that a static code analyzer would
>>> spot the above code as being a potential bug.
>>>
>>> Let's stop this madness now please.
>>>
>>> Either __must_check goes away from bus_for_each_drv() and from every
>>> other function which raises this problem, or we must disable that new
>>> type of warning gcc 4.6.0 generates. Depends which warnings we value
>>> more, as we can't sanely have both.
>>>
>>
>> That is the crux of the whole thing.  Putting in crap to get rid of the
>> __must_check warning someone obviously wanted to provoke is just plain
>> wrong.
>
> __process_new_adapter() calls i2c_do_add_adapter() which always returns
> 0. Why should I check the return value of bus_for_each_drv() when I
> know it will always be 0 by construction?
>
> Also note that the same function is also called through
> bus_for_each_dev() somewhere else in i2c-core, and there is no warning
> there because bus_for_each_dev() is not marked __must_check. How
> consistent is this? If bus_for_each_dev() is OK without __must_check,
> then I can't see why bus_for_each_drv() wouldn't be.
>

Well, I would advocate removing the __must_check then.


David Daney
