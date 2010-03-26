Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718Ab0CZJfF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 05:35:05 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:42159 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754Ab0CZJfC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 05:35:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=tRzyzZeMUKIP6MvXEUlLSxLnIH/NRrrV26QQfKdwD4LWESY2rMXgADz55L+EYkdS8a
         qcBWwyqcwbRFc86hAeicL897jNH30WDA+vhHaaLWmTYL/19Rod/q7NUprvwkHrPnFOYD
         H/eRg/y9ePIXf1L1BbWMmti+aYTMelnI6TJC8=
Message-ID: <4BAC7FC3.50405@gmail.com>
Date: Fri, 26 Mar 2010 10:34:59 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.2pre) Gecko/20100308 SUSE/3.1b1-6.1 Thunderbird/3.1b1
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Pavel Machek <pavel@ucw.cz>, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org,
       Nigel Cunningham <ncunningham@crca.org.au>
Subject: Re: [RFC 09/15] PM / Hibernate: user, implement user_ops writer
References: <1269361063-3341-1-git-send-email-jslaby@suse.cz> <20100324204259.GA6423@elf.ucw.cz> <4BAA86E8.5090108@gmail.com> <201003252314.33256.rjw@sisk.pl>
In-Reply-To: <201003252314.33256.rjw@sisk.pl>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/25/2010 11:14 PM, Rafael J. Wysocki wrote:
> On Wednesday 24 March 2010, Jiri Slaby wrote:
>> On 03/24/2010 09:42 PM, Pavel Machek wrote:
>>>> +	if (test_bit(TODO_CLOSED, to_do_flags))
>>>> +		return -EIO;
>>>> +
>>>> +	to_do_buf = buf;
>>>> +	wmb();
>>>> +	set_bit(TODO_WORK, to_do_flags);
>>>> +	wake_up_interruptible(&to_do_wait);
>>>
>>> Uhuh, open-coded barriers... these need to be commented, and I guess
>>> you just should not play this kind of trickery.
>>
>> It's just to ensure the to_do_buf store is not reordered with the
>> set_bit. I wanted to avoid locks as too heavy tools here.
> 
> No, please use them, at least in a prototype version.
> 
> We can always optimize things out later, but doing optimizations upfront
> doesn't really work well from my experience.
> 
> So, if you'd use a lock somewhere, please use it, or maybe use a completion if
> that fits the design better.

That's it, I don't think a lock is appropriate here (I didn't even think
of that) -- I don't know what to lock (OK, I see it, but it's not that
clear). There is no potential for race per se, I only need to disable
reordering (which locks do as a side-effect). I need the steps to be
done in the A-B order where there is a barrier appropriate. Here, A is
store to to_do_buf, B is set_bit. It's I set to_do_buf, flag that it may
be used, the consumer will see the flag and use to_do_buf, in this order.

Above that if I introduce locks the wait_event on the other side will
grow into an unreadable mess. I would need to hold a lock when checking
the condition and hold it until I reach to_do_buf use, but also unlock
it on all paths that do not reach that point. Yeah, it's indeed doable,
but I don't think, it will improve things.

I also don't think completion is appropriate here, as I have a condition
to check for and it differs over wake_up sites.

thanks,
-- 
js
