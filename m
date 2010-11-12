Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757538Ab0KLVwq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 16:52:46 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48425 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755400Ab0KLVwp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 16:52:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=d2EUavP8AXRO6a4tsxKHi86kQNVcwD10BNytv7uoA2rXpT2hWu1yQWLPARQuFOpyZV
         3TrIuKgMSYlSOHh6vyLYzp3UWcqKrimWcmAGU3RZX0/qJwUql46SrC8XjVZy1ZIR8JqB
         h64ry50gMd6FfmKpDHu1DN1rMSMGQuBB92B28=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=s+0i36qd-bd3=MdeiJS-TThos9RmeUCsfHyy=@mail.gmail.com>
References: <80b5a10ac1a6ef51afca3c113b624bf1b5049452.1289427381.git.luto@mit.edu>
 <AANLkTi=s+0i36qd-bd3=MdeiJS-TThos9RmeUCsfHyy=@mail.gmail.com>
From: Andrew Lutomirski <luto@mit.edu>
Date: Fri, 12 Nov 2010 16:52:22 -0500
X-Google-Sender-Auth: kq9GcYqITxanK6uOR0rpUl2SWE4
Message-ID: <AANLkTimAfULHTkyLVpGv5r3DcSfVXzsgGiHgTdamNpt2@mail.gmail.com>
Subject: Re: [PATCH] Improve clocksource unstable warning
To: john stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        pc@us.ibm.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 12, 2010 at 4:31 PM, john stultz <johnstul@us.ibm.com> wrote:
> On Wed, Nov 10, 2010 at 2:16 PM, Andy Lutomirski <luto@mit.edu> wrote:
>> When the system goes out to lunch for a long time, the clocksource
>> watchdog might get false positives.  Clarify the warning so that
>> people stop blaming their system freezes on the timing code.
>
> So this issue has also crept up at times in the -rt kernel, where some
> high priority rt tasks hogs the cpu long enough for the watchdog
> clocksource to wrap, and then the TSC seems to have sped up relative
> to the watchdog when the system returns to a normal state and causes a
> false positive, so the TSC gets kicked out.
>
> So the watchdog heuristic is rough, since it depends on three things:
> 1) The watchdog clocksource is actually trustworthy
> 2) The watchdog actually runs near to when it expects to run.
> 3) When reading the different clocksources, any interruptions when the
> watchdog runs are small enough to to be handled by the allowed margin
> of error.
>
> And in these cases we're breaking #2
>
> So I had a few  ideas  to improve the huristic somewhat (and huristic
> refinement is always ugly). So first of all,  the whole reason for the
> watchdog code is the TSC. Other platforms may want to make use of it,
> but none do at this moment.
>
> The majority of TSC issues are caused when the TSC halts in idle
> (probably most common these days) or slows down due to cpufreq
> scaling.
>
> When we get these false positives, its because the watchdog check
> interval is too long and the watchdog hardware has wrapped. This makes
> it appear that the TSC is running too *fast*.  So we could try to be
> more skeptical of watchdog failures where the TSC appears to have sped
> up, rather then the more common real issue of it slowing down.
>
> Now the actual positive where this could occur is if you were on an
> old APM based laptop, and booted on battery power and the cpus started
> at their slow freq. Then you plugged in the AC and the cpus jumped to
> the faster rate. So while I suspect this is a rare case these days (on
> ACPI based hardware the kernel has more say in cpufreq transitions, so
> I believe we are unlikely to calculate tsc_khz while the cpus are in
> low power mode), we still need to address this.
>
> Ideas:
> 1) Maybe should we check that we get two sequential failures where the
> cpu seems fast before we throw out the TSC? This will still fall over
> in some stall cases (ie: a poor rt task hogging the cpu  for 10
> minutes, pausing for a 10th of a second and then continuing to hog the
> cpu).
>
> 2) We could look at the TSC delta, and if it appears outside the order
> of 2-10x faster (i don't think any cpus scale up even close to 10x in
> freq, but please correct me if so), then assume we just have been
> blocked from running and don't throw out the TSC.
>
> 3) Similar to #2 we could look at the max interval that the watchdog
> clocksource provides, and if the TSC delta is greater then that, avoid
> throwing things out. This combined with #2 might narrow out the false
> positives fairly well.
>
> Any additional thoughts here?

Yes.  As far as I know, the watchdog doesn't give arbitrary values
when it wraps; it just wraps.  Here's a possible heuristic, in
pseudocode:

wd_now_1 = (read watchdog)
cs_now = (read clocksource)

cs_elapsed = cs_now - cs_last;
wd_elapsed = wd_now_1 - wd_last;

if ( abs(wd_elapsed - cs_elapsed) < MAX_DELTA)
  return;  // We're OK.

wd_now_2 = (read watchdog again)
if (abs(wd_now_1 - wd_now_2) > MAX_DELTA / 2)
  bail;  // The clocksource might be unstable, but we either just
lagged or the watchdog is unstable, and in either case we don't gain
anything by marking the clocksource unstable.

if ( wd_elapsed < cs_elapsed and ( (cs_elapsed - wd_elapsed) %
wd_wrapping_time ) < (something fairly small) )
  bail;  // The watchdog most likely wrapped.

mark_unstable;


The idea is that there are three obvious causes for false positives.

1. Something caused the watchdog itself to lag.  In this case, the
second watchdog read will differ from the first one by a lot and we'll
bail.

2. The TSC wrapped in the time between two watchdog checks.  I don't
think that this is very likely on x86 CPUs.  (Tsn't the TSC always 64
bits?  By the time that a 20GHz CPU wraps a 64-bit TSC, you're
probably already replaced the computer.)

3. The watchdog wrapped in the time between two watchdog checks.  In
this case, unless something else went wrong simultaneously, we'll
detect it.

On the other hand, the chance that the TSC was unstable by almost
exactly a multiple of the watchdog wrapping time is pretty unlikely.


If we're using a non-TSC clocksource, then you could get false
positives if that clocksource wraps, but maybe the watchdog is
unnecessary in that case.

--Andy
