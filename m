Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122Ab1BUQfB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 11:35:01 -0500
Received: from mail-bw0-f42.google.com ([209.85.214.42]:60131 "EHLO
	mail-bw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224Ab1BUQex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 11:34:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=rmrhO5MAk880NnGCQhxls3MhqBFqQWK4h/axv5dnOZm+22q0aRZVjVNivDx0mJwO/e
         NDF19wcBq4ADKC38/4WbUJ1AEZFfFJhefztiL5NXAvWvITFuHx+fFkpm41M+3wlBugbD
         JvgQWG9i2sH0GOoeiOcXJD23YSPr++NnkCkoc=
Message-ID: <4D629427.8020500@gmail.com>
Date: Mon, 21 Feb 2011 17:34:47 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, stefanb@linux.vnet.ibm.com,
        linux-pm <linux-pm@lists.linux-foundation.org>, stable@kernel.org,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        debora@linux.vnet.ibm.com,
        Linus Torvalds <torvalds@linux-foundation.org>, preining@logic.at
Subject: Re: 2.6.37.1 s2disk regression (TPM)
References: <4D60E93D.1050205@gmail.com> <4D60F108.9000106@gmail.com> <201102201151.11635.rjw@sisk.pl> <201102201248.10779.rjw@sisk.pl> <4D628521.8000205@linux.vnet.ibm.com>
In-Reply-To: <4D628521.8000205@linux.vnet.ibm.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please stop garbling my name. I'm not Sladby (2nd time you
committed that) and not even Juri.

On 02/21/2011 04:30 PM, Rajiv Andrade wrote:
> On 02/20/2011 08:48 AM, Rafael J. Wysocki wrote:
> 
>> On Sunday, February 20, 2011, Rafael J. Wysocki wrote:
>>> No, and the author and maintainer have not been responding.  If that
>>> contiunes,I'll simply ask Linus to revert it.
> Sorry, but you sent the email this Friday, I didn't catch it in time and
> I wasn't working during the weekend.
> 
>> BTW, the first hunk from that commit in drivers/char/tpm/tpm.c seems
>> to be
>> completely broken:
>> @@ -577,9 +577,11 @@ duration:
>>          if (rc)
>>                  return;
>>
>> -       if (be32_to_cpu(tpm_cmd.header.out.return_code)
>> -           != 3 * sizeof(u32))
>> +       if (be32_to_cpu(tpm_cmd.header.out.return_code) != 0 ||
>> +           be32_to_cpu(tpm_cmd.header.out.length)
>> +           != sizeof(tpm_cmd.header.out) + sizeof(u32) + 3 *
>> sizeof(u32))
>>                  return;
>> +
>>          duration_cap =&tpm_cmd.params.getcap_out.cap.duration;
>>          chip->vendor.duration[TPM_SHORT] =
>>              usecs_to_jiffies(be32_to_cpu(duration_cap->tpm_short));
>>
>> Namely, either the old code always returned as a result of the
>> conditional
>> being removed, or the new code will always return as a result of
>> the (... != 0) check.  I wonder if there's supposed to be (... == 0)
>> instead?
> The previous code was checking the wrong field of the TPM returned
> buffer, probably
> due an old commit that incorporated the tpm_cmd strucuture, it should
> check if the return code
> is != 0, which if true, means that the command didn't succeed. The
> output length check should be
> just a sanity check, so indeed the logical operator should be&& 
> instead.

No it should not. You want 'if (wrong_retcode OR wrong_len) die;'. IOW I
don't see what exactly is wrong on the 'if'. I think it's correct.
(Given the old test was incorrect.)

There has to be another problem which caused my regression. And since it
reports "Operation Timed out", the former default timeout values worked
for me, the ones read from TPM do not.

I'm not at that machine now, what are the usual timeouts in usecs? The
use of conversed jiffies seem bogus. If the usecs are so low (or HZ so
high on some configs) that the conversion returns 1 jiffie,
wait_event_interruptible_timeout in wait_for_stat will return 0 when:
* 1 jiffie passes without change in status (proper timeout)
* status changed, but also the timer ticked once meanwhile, i.e. we
scheduled a moment before timer tick

But this is only a theory so far. What about this (wrapped, just dropped
by mouse), I may try it when I'm back to the machine?
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -201,7 +201,7 @@ static int wait_for_stat(struct tpm_chip *chip, u8
mask, unsigned long timeout,
                                                      ((tpm_tis_status
                                                        (chip) & mask) ==
                                                       mask), timeout);
-               if (rc > 0)
+               if (rc > 0 || (tpm_tis_status(chip) & mask) == mask)
                        return 0;
        } else {
                stop = jiffies + timeout;

regards,
-- 
js
