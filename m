Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543Ab1BURMs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 12:12:48 -0500
Received: from e24smtp01.br.ibm.com ([32.104.18.85]:34153 "EHLO
	e24smtp01.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273Ab1BURMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 12:12:46 -0500
Message-ID: <4D629D03.90801@linux.vnet.ibm.com>
Date: Mon, 21 Feb 2011 14:12:35 -0300
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, stefanb@linux.vnet.ibm.com,
        linux-pm <linux-pm@lists.linux-foundation.org>, stable@kernel.org,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        debora@linux.vnet.ibm.com,
        Linus Torvalds <torvalds@linux-foundation.org>, preining@logic.at
Subject: Re: 2.6.37.1 s2disk regression (TPM)
References: <4D60E93D.1050205@gmail.com> <4D60F108.9000106@gmail.com> <201102201151.11635.rjw@sisk.pl> <201102201248.10779.rjw@sisk.pl> <4D628521.8000205@linux.vnet.ibm.com> <4D629427.8020500@gmail.com>
In-Reply-To: <4D629427.8020500@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 11022117-6842-0000-0000-000000624A51
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21/2011 01:34 PM, Jiri Slaby wrote:

>>> BTW, the first hunk from that commit in drivers/char/tpm/tpm.c seems
>>> to be
>>> completely broken:
>>> @@ -577,9 +577,11 @@ duration:
>>>           if (rc)
>>>                   return;
>>>
>>> -       if (be32_to_cpu(tpm_cmd.header.out.return_code)
>>> -           != 3 * sizeof(u32))
>>> +       if (be32_to_cpu(tpm_cmd.header.out.return_code) != 0 ||
>>> +           be32_to_cpu(tpm_cmd.header.out.length)
>>> +           != sizeof(tpm_cmd.header.out) + sizeof(u32) + 3 *
>>> sizeof(u32))
>>>                   return;
>>> +
>>>           duration_cap =&tpm_cmd.params.getcap_out.cap.duration;
>>>           chip->vendor.duration[TPM_SHORT] =
>>>               usecs_to_jiffies(be32_to_cpu(duration_cap->tpm_short));
>>>
>>> Namely, either the old code always returned as a result of the
>>> conditional
>>> being removed, or the new code will always return as a result of
>>> the (... != 0) check.  I wonder if there's supposed to be (... == 0)
>>> instead?
>> The previous code was checking the wrong field of the TPM returned
>> buffer, probably
>> due an old commit that incorporated the tpm_cmd strucuture, it should
>> check if the return code
>> is != 0, which if true, means that the command didn't succeed. The
>> output length check should be
>> just a sanity check, so indeed the logical operator should be&&
>> instead.
> No it should not. You want 'if (wrong_retcode OR wrong_len) die;'. IOW I
> don't see what exactly is wrong on the 'if'. I think it's correct.
> (Given the old test was incorrect.)
Exactly, I read it too fast and inverted the logic while writing the response, missing De Morgan's.

> There has to be another problem which caused my regression. And since it
> reports "Operation Timed out", the former default timeout values worked
> for me, the ones read from TPM do not.
Yes, it's highly due inconsistent timeout values reported by the TPM as I mentioned, my working timeouts are:
3020000 4510000 181000000

> I'm not at that machine now, what are the usual timeouts in usecs? The
> use of conversed jiffies seem bogus. If the usecs are so low (or HZ so
> high on some configs) that the conversion returns 1 jiffie,
> wait_event_interruptible_timeout in wait_for_stat will return 0 when:
> * 1 jiffie passes without change in status (proper timeout)
> * status changed, but also the timer ticked once meanwhile, i.e. we
> scheduled a moment before timer tick
>
> But this is only a theory so far. What about this (wrapped, just dropped
> by mouse), I may try it when I'm back to the machine?
> --- a/drivers/char/tpm/tpm_tis.c
> +++ b/drivers/char/tpm/tpm_tis.c
> @@ -201,7 +201,7 @@ static int wait_for_stat(struct tpm_chip *chip, u8
> mask, unsigned long timeout,
>                                                        ((tpm_tis_status
>                                                          (chip)&  mask) ==
>                                                         mask), timeout);
> -               if (rc>  0)
> +               if (rc>  0 || (tpm_tis_status(chip)&  mask) == mask)
>                          return 0;
>          } else {
>                  stop = jiffies + timeout;
>
This will work for small timeout values discrepancies, but not if, for example,
the TPM is returning the values in msecs instead of usecs, which should affect the
result when issuing commands that last longer. That's why I'd like to see
the failing timeout values first.

Rajiv

