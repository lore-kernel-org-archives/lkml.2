Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229Ab1LTEWv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 23:22:51 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:36000 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258Ab1LTEWs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 23:22:48 -0500
MIME-Version: 1.0
In-Reply-To: <4EEE5B08.8010703@gmail.com>
References: <1324209529-15892-1-git-send-email-ozaki.ryota@gmail.com> <4EEE5B08.8010703@gmail.com>
From: Ryota Ozaki <ozaki.ryota@gmail.com>
Date: Tue, 20 Dec 2011 13:22:27 +0900
Message-ID: <CAKrYomjxhXwXdDJUP3ny3oa-wo81LJmsQmG8Emj986BHp+LbNQ@mail.gmail.com>
Subject: Re: [PATCH][RESEND] mm: Fix off-by-one bug in print_nodes_state
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-mm@kvack.org, stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kosaki-san,

I'm sorry for my late reply.
2011/12/19 KOSAKI Motohiro <kosaki.motohiro@gmail.com>:
> (12/18/11 6:58 AM), Ryota Ozaki wrote:
>> /sys/devices/system/node/{online,possible} involve a garbage byte
>> because print_nodes_state returns content size + 1. To fix the bug,
>> the patch changes the use of cpuset_sprintf_cpulist to follow the
>> use at other places, which is clearer and safer.
>>
>> This bug was introduced since v2.6.24.
>>
>> Signed-off-by: Ryota Ozaki<ozaki.ryota@gmail.com>
>> ---
>>   drivers/base/node.c |    8 +++-----
>>   1 files changed, 3 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/base/node.c b/drivers/base/node.c
>> index 5693ece..ef7c1f9 100644
>> --- a/drivers/base/node.c
>> +++ b/drivers/base/node.c
>> @@ -587,11 +587,9 @@ static ssize_t print_nodes_state(enum node_states state, char *buf)
>>   {
>>       int n;
>>
>> -     n = nodelist_scnprintf(buf, PAGE_SIZE, node_states[state]);
>> -     if (n>  0&&  PAGE_SIZE>  n + 1) {
>> -             *(buf + n++) = '\n';
>> -             *(buf + n++) = '\0';
>> -     }
>> +     n = nodelist_scnprintf(buf, PAGE_SIZE-2, node_states[state]);
>
> PAGE_SIZE-1. This seems another off by one. buf[n++] = '¥n' mean
> override old trailing '¥0' and buf[n] = '¥0' mean to append one byte.
> Then totally, we append one byte.

Thanks for pointing this out, you're right. (nodelist_)scnprintf returns
size-1 at most, thus we need to remain just one byte. I'll fix it in
the next patch.

Actually I bring the code from another and such the flaw can be found in other
functions. So I'll them as well.

  ozaki-r

>
>> +     buf[n++] = '\n';
>> +     buf[n] = '\0';
>>       return n;
>>   }
>>
>
