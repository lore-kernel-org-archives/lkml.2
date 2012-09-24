Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575Ab2IXLqF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 07:46:05 -0400
Received: from science.horizon.com ([71.41.210.146]:58904 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754187Ab2IXLqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 07:46:03 -0400
Date: 24 Sep 2012 07:46:02 -0400
Message-ID: <20120924114602.501.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux@horizon.com, mpn@google.com, vda.linux@googlemail.com
Subject: Re: [PATCH 3/4] lib: vsprintf: Optimize put_dec_trunc8
Cc: hughd@google.com, linux-kernel@vger.kernel.org
In-Reply-To: <xa1ttxuo61md.fsf@mina86.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>  lib/vsprintf.c |   20 ++++++--------------
>>  1 file changed, 6 insertions(+), 14 deletions(-)
>>
>> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
>> index a8e7392..3ca77b8 100644
>> --- a/lib/vsprintf.c
>> +++ b/lib/vsprintf.c
>> @@ -174,20 +174,12 @@ char *put_dec_trunc8(char *buf, unsigned r)
>>  	unsigned q;
>>=20=20
>>  	/* Copy of previous function's body with added early returns */
>> -	q      = (r * (uint64_t)0x1999999a) >> 32;
>> -	*buf++ = (r - 10 * q) + '0'; /* 2 */
>> -	if (q == 0)
>> -		return buf;
>> -	r      = (q * (uint64_t)0x1999999a) >> 32;
>> -	*buf++ = (q - 10 * r) + '0'; /* 3 */
>> -	if (r == 0)
>> -		return buf;
>> -	q      = (r * (uint64_t)0x1999999a) >> 32;
>> -	*buf++ = (r - 10 * q) + '0'; /* 4 */
>> -	if (q == 0)
>> -		return buf;
>> -	r      = (q * (uint64_t)0x1999999a) >> 32;
>> -	*buf++ = (q - 10 * r) + '0'; /* 5 */
>> +	while (r >= 10000) {
>> +		q = r + '0';
>> +		r  = (r * (uint64_t)0x1999999a) >> 32;
>> +		*buf++ = q - 10*r;
>> +	}

> This loop looks nothing like the original code.  Why are you adding '0'
> at the beginning?

Because I was trying to avoid useless bare "move" instructions
when converting to a non-swapping loop, and putting it up
there made clear that the copy could be combined with a
useful add on a 3-operand machine.  (Or even a 2-operand with
lea.)

Compilers are probably smart enough to figure that out by themselves,
but it mirrors my thinking as I was writing the code.

While it is a bit subtle, it's only three lines of code, and
I figured the equivalence to
"q = r; r = <math>; +buf++ = q - 10*r + '0';"
was pretty easy to see.


> Also, the original code switches the role of q and r,
> the loop does not.

Well, obviously; I had to do that to make it possible to put
into a loop.

Truthfully, it would have made *more* sense to swap q and r globally,
so the loop had a more sensible q=quotient/r=remainder assignment,
but I wanted to show that the unmodified tail was in fact unmodified.

The big saving from using a loop is that it avoids unnecessary
32x32->64-bit multiplies, falling through to the 16x16->32-bit
code as early as possible.  Given that most numbers are small,
this seemed like a significant win.

(As long as it doesn't add additional unpredictable conditional
branches, which are also expensive.)
