Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751646Ab1AOI3Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jan 2011 03:29:16 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:64332 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188Ab1AOI3P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jan 2011 03:29:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vGIgPf8sj8PkHe6N+QGDYUKkG260cL6iVaDUV1FkWbK1RszfEaKTaVGyh4MXF9NWBj
         6z+pAqZkPAwMKCb/O6DOUzKdimxTH/OcwLgm+6bCLvC6t9cPDfXkhBE3R5CKglZ96WGP
         cR2zbu9DIV1XbM7zac39PVh2a/M4k/4ywa7Cc=
MIME-Version: 1.0
In-Reply-To: <20110105145128.3b635ae7.akpm@linux-foundation.org>
References: <1294198711-15492-1-git-send-email-dzickus@redhat.com>
	<1294198711-15492-2-git-send-email-dzickus@redhat.com>
	<20110105145128.3b635ae7.akpm@linux-foundation.org>
Date: Sat, 15 Jan 2011 16:29:13 +0800
Message-ID: <AANLkTinWqVHN=1hMmz-wqz2ot=MP8SCQmgjtPMFLmDG3@mail.gmail.com>
Subject: Re: [PATCH 1/2] panic: ratelimit panic messages
From: Dave Young <hidave.darkstar@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Don Zickus <dzickus@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        fweisbec@gmail.com, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 6, 2011 at 6:51 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Tue,  4 Jan 2011 22:38:30 -0500
> Don Zickus <dzickus@redhat.com> wrote:
>
>> Sometimes when things go bad, so much spew is coming on the console it is hard
>> to figure out what happened.  This patch allows you to ratelimit the panic
>> messages with the intent that the first panic message will provide the info
>> we need to figure out what happened.
>>
>> Adds new kernel param 'panic_ratelimit=on/<integer in seconds>'
>>
>
> Terminological whinge: panic() is a specific kernel API which ends up
> doing a sort-of-oops thing.  So the graph is
>
>        panic           -> oops
>        other-things    -> oops
>
> Your patch doesn't affect only panics - it also affects oops, BUG(),
> etc.  So I'd suggest that this patch should do s/panic/oops/g.
>
>> ---
>>  Documentation/kernel-parameters.txt |    6 ++++++
>>  kernel/panic.c                      |   30 ++++++++++++++++++++++++++++++
>>  2 files changed, 36 insertions(+), 0 deletions(-)
>>
>> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
>> index 316c723..1416964 100644
>> --- a/Documentation/kernel-parameters.txt
>> +++ b/Documentation/kernel-parameters.txt
>> @@ -1807,6 +1807,12 @@ and is between 256 and 4096 characters. It is defined in the file
>>       panic=          [KNL] Kernel behaviour on panic
>>                       Format: <timeout>
>>
>> +     panic_ratelimit=        [KNL] ratelimit the panic messages
>> +                     Useful for slowing down multiple panics to capture
>> +                     the first one before it scrolls off the screen
>> +                     Format: "on" or some integer in seconds
>> +                     "on" defaults to 10 minutes
>> +
>
> We keep on hacking away at this and things never seem to get much
> better.  It's still the case that a large number of our oops reports
> are damaged because the important parts of the oops trace scrolled off
> the screen.
>
> I therefore propose
>
>        oops_lines_delay=N,M
>
> which will cause the kernel to pause for M milliseconds after emitting
> N lines of oops output.  Bonus marks for handling linewrap!

I ever try to do similar things to printk_delay, something like
printk_lines_delay,
or give printk_delay one more parameter of lines.

What do you think about this approach?

>
> Start the line counter at oops_begin() or thereabouts and then do the
> delay after N lines have been emitted.  I guess that counter should
> _not_ be invalidated in oops_end(): if the oops generates 12 lines and
> then another 100 lines of random printk crap are printed, we still want
> to put a pause after the 13th line of that random crap, so we can view
> the oops.
>
> The oops_lines_delay implemetnation should count lines from all CPUs
> and should block all CPUs during the delay.
>
> I think this would solve the problem which you're seeing, as well as
> the much larger my-oops-scrolled-off problem?
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Regards
dave
