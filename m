Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751410Ab0CQC7V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 22:59:21 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:43823 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762Ab0CQC7A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 22:59:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=uteTedyANKk/xlQuHSSJFlqblg1XnoczUYWRAN9WnAcF6nwjYzR/T6SeE2r4t3N3Tj
         COBPvcb6ZUQxpAliLY1JIsiMirezpwCpASQ8DRZTHPNJ2GizsdLF3UvjUtkaeJ1S8N7n
         +vSXA9FZStJT+B24dSy+dBJO0fyv26HfmU2Vo=
MIME-Version: 1.0
In-Reply-To: <1268763512.1676.7.camel@work-vm>
References: <1268735629.5075.8.camel@eight.analog.com>
	 <1268763512.1676.7.camel@work-vm>
Date: Wed, 17 Mar 2010 10:58:59 +0800
Message-ID: <4e5ebad51003161958n6db293f0y6da99483bf96ada0@mail.gmail.com>
Subject: Re: [PATCH] Timekeeping: Fix dead lock in update_wall_time by correct 
	shift convertion.
From: Sonic Zhang <sonic.adi@gmail.com>
To: john stultz <johnstul@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 17, 2010 at 2:18 AM, john stultz <johnstul@us.ibm.com> wrote:
> On Tue, 2010-03-16 at 18:33 +0800, sonic zhang wrote:
>> update_wall_time() runs into dead lock after kernel traps into kgdb and exits
>> per user's request some seconds layer. This is root caused to be wrong
>> calculation of maxshift in update_wall_time().
>>
>> The shift in update_wall_time() and logarithmic_accumulation() is
>> clock shift. In order to generate ntp_error and maxshift correctly,
>> shift convertion between clock and ntp should be done properly.
>
> Hmmm. I don't believe this patch is correct, as it redefines the units
> that ntp_error accumulates (which will cause problems in ntp correction)
>

What units does the ntp_error accumulates? NTP tick or clock source
tick? shift varable here is clock source shift.


> Could you provide some more details on how you triggered the issue (what
> hardware, and what clocksource was being used at the time), as well as
> the analysis you did that suggested this solution?
>
If you enabled KGDB over ethernet debugging in kernel hacking, you
will see the dead lock after you connect your gdb to kernel and set a
breakpoint, wait for 30 seconds and continue kernel. The direct cause
is the clock shift calculated after kernel resumes is bigger than the
maxshift calculated based on NTP tick_length. So, the loop "while
(offset >= timekeeper.cycle_interval)" never exists, because offset is
too big to be reduced properly before shift(limited to maxshift)
becomes negative value. The offset value in my test is 1553274374.

The hardware is blackfin and any hardware clock source, gptimer or core counter.

> It may be that we are hitting an overflow in the ntp_error value, which
> could possibly cause some strange clock steering. Not sure about a
> deadlock though.
>
> Can you trigger this issue when you replace:
>
>        offset = logarithmic_accumulation(offset, shift);
> with
>        offset = logarithmic_accumulation(offset, 0);
>
> ?

Yes, this workaround never dead loop because the shift is never
decreased to negative value and need about 3883 loops to finish when
offset is 1553274374.

>
> thanks
> -john
>
>
