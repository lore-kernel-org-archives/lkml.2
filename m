Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933219Ab0KLXtK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 18:49:10 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49066 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932073Ab0KLXtH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 18:49:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=wYmXO0Oj/zbjeXfYMLdwyoVzMVLd+GwocPca8y3AyfDgNJAXxt8zWUojSqfhVutO3V
         y//urN+DJLBSz5BYW1dwCgItAgnJgkIpGXietoncV10p0Gr2xch0qcDRRNru2Cg4tka/
         +17yaKsgncdnT+VA0Nbch4IriiZxl/E9cLICU=
MIME-Version: 1.0
In-Reply-To: <1289605221.3292.53.camel@localhost.localdomain>
References: <80b5a10ac1a6ef51afca3c113b624bf1b5049452.1289427381.git.luto@mit.edu>
 <AANLkTi=s+0i36qd-bd3=MdeiJS-TThos9RmeUCsfHyy=@mail.gmail.com>
 <AANLkTimAfULHTkyLVpGv5r3DcSfVXzsgGiHgTdamNpt2@mail.gmail.com> <1289605221.3292.53.camel@localhost.localdomain>
From: Andrew Lutomirski <luto@mit.edu>
Date: Fri, 12 Nov 2010 18:48:44 -0500
X-Google-Sender-Auth: Va2n4xj0Tf_5k69PjW_DPtVEYhw
Message-ID: <AANLkTi=iso2+R6-5+2ipe39JLHw9o0TgMGCRSTqd5qQz@mail.gmail.com>
Subject: Re: [PATCH] Improve clocksource unstable warning
To: john stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        pc@us.ibm.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 12, 2010 at 6:40 PM, john stultz <johnstul@us.ibm.com> wrote:
> On Fri, 2010-11-12 at 16:52 -0500, Andrew Lutomirski wrote:
>> On Fri, Nov 12, 2010 at 4:31 PM, john stultz <johnstul@us.ibm.com> wrote:
>> > Ideas:
>> > 1) Maybe should we check that we get two sequential failures where the
>> > cpu seems fast before we throw out the TSC? This will still fall over
>> > in some stall cases (ie: a poor rt task hogging the cpu  for 10
>> > minutes, pausing for a 10th of a second and then continuing to hog the
>> > cpu).
>> >
>> > 2) We could look at the TSC delta, and if it appears outside the order
>> > of 2-10x faster (i don't think any cpus scale up even close to 10x in
>> > freq, but please correct me if so), then assume we just have been
>> > blocked from running and don't throw out the TSC.
>> >
>> > 3) Similar to #2 we could look at the max interval that the watchdog
>> > clocksource provides, and if the TSC delta is greater then that, avoid
>> > throwing things out. This combined with #2 might narrow out the false
>> > positives fairly well.
>> >
>> > Any additional thoughts here?
>>
>> Yes.  As far as I know, the watchdog doesn't give arbitrary values
>> when it wraps; it just wraps.  Here's a possible heuristic, in
>> pseudocode:
>>
>> wd_now_1 = (read watchdog)
>> cs_now = (read clocksource)
>>
>> cs_elapsed = cs_now - cs_last;
>> wd_elapsed = wd_now_1 - wd_last;
>>
>> if ( abs(wd_elapsed - cs_elapsed) < MAX_DELTA)
>>   return;  // We're OK.
>>
>> wd_now_2 = (read watchdog again)
>> if (abs(wd_now_1 - wd_now_2) > MAX_DELTA / 2)
>>   bail;  // The clocksource might be unstable, but we either just
>> lagged or the watchdog is unstable, and in either case we don't gain
>> anything by marking the clocksource unstable.
>
> This is more easily done by just bounding the clocksource read:
> wd_now_1 = watchdog->read()
> cs_now = clocksource->read()
> wd_now_2 = watchdog->read()
>
> if (((wd_now_2 - wd_now_1)&watchdog->mask) > SOMETHING_SMALL)
>        bail; // hit an SMI or some sort of long preemption
>
>> if ( wd_elapsed < cs_elapsed and ( (cs_elapsed - wd_elapsed) %
>> wd_wrapping_time ) < (something fairly small) )
>>   bail;  // The watchdog most likely wrapped.
>
> Huh. The modulo bit may need tweaking as its not immediately clear its
> right. Maybe the following is clearer?:
>
> if ((cs_elapsed > wd_wrapping_time)
>        && (abs((cs_elapsed % wd_wrapping_time)-wd_elapsed) < MAX_DELTA)
>        // should be ok.

I think this is wrong if wd_elapsed is large (which could happen if
the real wd time is something like (2 * wd_wrapping_time -
MAX_DELTA/4)).

--Andy
