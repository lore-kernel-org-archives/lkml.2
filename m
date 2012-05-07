Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757657Ab2EGXpr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 19:45:47 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:48508 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755225Ab2EGXpq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 19:45:46 -0400
MIME-Version: 1.0
In-Reply-To: <1336401445.8274.319.camel@deadeye>
References: <20120504204230.094388730@linuxfoundation.org>
	<1336401445.8274.319.camel@deadeye>
Date: Mon, 7 May 2012 16:45:44 -0700
Message-ID: <CA++WF2OhfV4Fv8Jo+o_VMyZ9mdQLMs3iOtiP0_jskUR_8gc9jg@mail.gmail.com>
Subject: Re: [ 67/75] ipw2200: Fix race condition in the command completion acknowledge
From: Stanislav Yakovlev <stas.yakovlev@gmail.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: "John W. Linville" <linville@tuxdriver.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Greg KH <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7 May 2012 07:37, Ben Hutchings <ben@decadent.org.uk> wrote:
> On Fri, 2012-05-04 at 13:43 -0700, Greg KH wrote:
>> 3.3-stable review patch.  If anyone has any objections, please let me know.
>>
>> ------------------
>>
>> From: Stanislav Yakovlev <stas.yakovlev@gmail.com>
>>
>> commit dd447319895d0c0af423e483d9b63f84f3f8869a upstream.
>>
>> Driver incorrectly validates command completion: instead of waiting
>> for a command to be acknowledged it continues execution.  Most of the
>> time driver gets acknowledge of the command completion in a tasklet
>> before it executes the next one. But sometimes it sends the next
>> command before it gets acknowledge for the previous one. In such a
>> case one of the following error messages appear in the log:
> [...]
>> +     now = jiffies;
>> +     end = now + HOST_COMPLETE_TIMEOUT;
>> +again:
>>       rc = wait_event_interruptible_timeout(priv->wait_command_queue,
>>                                             !(priv->
>>                                               status & STATUS_HCMD_ACTIVE),
>> -                                           HOST_COMPLETE_TIMEOUT);
>> +                                           end - now);
>> +     if (rc < 0) {
>> +             now = jiffies;
>> +             if (time_before(now, end))
>> +                     goto again;
>> +             rc = 0;
>> +     }
> [...]
>
> If you don't want the wait to be interrupted, use wait_event_timeout()
> instead of this ridiculous loop!

Usually "modprobe ipw2200" takes less than a second, and after
switching to wait_event_timeout it will take more than 10 seconds. We
can not decrease the waiting timeout because we want to keep it big
enough for the worst case(when the firmware did not reply).

There is a relevant discussion on lklm:
https://lkml.org/lkml/2008/9/25/2
https://lkml.org/lkml/2008/9/26/194

Stanislav.

> Ben.
>
> --
> Ben Hutchings
> Hoare's Law of Large Problems:
>        Inside every large problem is a small problem struggling to get out.
