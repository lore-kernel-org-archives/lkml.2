Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759479Ab1FBHwM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 03:52:12 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:60698 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752882Ab1FBHwK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 03:52:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=E4qMLNs5jWEBfWgEAGtGoOrQoqYJaxrzD8AsHIXWkUe8UpX+5aNRy02DOz/xgasenq
         dqDRhOGWcSPCLzPsIJrKfHIRCpT71PaR4uH+cR4q+bslCrl6Yj5pXw9DuaXQ/OX5M0q4
         +XJ9t7GbmaknLOjnG9iFDPJ+N5yDR7416SmZg=
MIME-Version: 1.0
In-Reply-To: <20110601155017.GD24028@aftab>
References: <1306835745.2353.3.camel@twins>
	<tip-f01114cb59d670e9b4f2c335930dd57db96e9360@git.kernel.org>
	<20110531125621.GA24439@gere.osrc.amd.com>
	<1306847516.2353.80.camel@twins>
	<20110601070547.GB3368@liondog.tnic>
	<1306924612.2353.176.camel@twins>
	<20110601155017.GD24028@aftab>
Date: Thu, 2 Jun 2011 15:52:09 +0800
Message-ID: <BANLkTikT6OT-HDi-DR+_ZWEhfp_CYWJ3Hg@mail.gmail.com>
Subject: Re: [tip:sched/urgent] sched: Fix cross-cpu clock sync on remote wakeups
From: Yong Zhang <yong.zhang0@gmail.com>
To: Borislav Petkov <bp@amd64.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Borislav Petkov <bp@alien8.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "markus@trippelsdorf.de" <markus@trippelsdorf.de>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 1, 2011 at 11:50 PM, Borislav Petkov <bp@amd64.org> wrote:
> On Wed, Jun 01, 2011 at 06:36:52AM -0400, Peter Zijlstra wrote:
>> trace_printk() can go pretty much anywhere, you want to start with
>> something like the below and go from there, either up into
>> arch/x86/kernel/tsc.c:native_sched_clock() or down into the scheduler
>> and instrument rq->clock (although you most likely already get most of
>> that through the sched_clock_cpu() trace_printk).
>
> See for a trace excerpt below.
>
>> Also, it might be good to check on the sched_clock_stable logic in
>> general and on your platform in particular, if that's set we forgo all
>> the fancy bits and return sched_clock() directly.
>
> Nah, we don't set sched_clock_stable on AMD.
>
> --
>          <idle>-0     [023]   511.343360: sched_clock_cpu: clock: 511500051225
>          <idle>-0     [023]   511.343365: sched_clock_tick: gtod: 511500058415, now: 511343364325
>          <idle>-0     [023]   511.343367: sched_clock_local: now: 511343365506, gtod: 511500058415, delta: 1181, old_clock: 511500051225, clock: 511500059596
>          <idle>-0     [023]   511.343369: sched_clock_local: now: 511343367760, gtod: 511500058415, delta: 3435, old_clock: 511500059596, clock: 511500061850
>          <idle>-0     [023]   511.343370: sched_clock_cpu: clock: 511500061850
>          <idle>-0     [023]   511.343380: sched_clock_local: now: 511343378644, gtod: 511500058415, delta: 14319, old_clock: 511500061850, clock: 511500072734
>          <idle>-0     [023]   511.343381: sched_clock_cpu: clock: 511500072734
>          <idle>-0     [000]   511.343519: sched_clock_tick: gtod: 511500210072, now: 511343515910
>          <idle>-0     [000]   511.343523: sched_clock_local: now: 511343521252, gtod: 511500210072, delta: 5342, old_clock: 511484088885, clock: 511500215414
>           <...>-102   [023]   511.343527: sched_clock_local: now: 511343524554, gtod: 511500058415, delta: 160229, old_clock: 511500072734, clock: 511500218644

In sched_clock_local(), clock is calculated around ->tick_gtod even if
that ->tick_gtod
is stale for long time because we stays in idle state. You know ->tick_gtod
is only updated in sched_clock_tick();

IOW, when a cpu goes out of idle, sched_clock_tick() is called from
tick_nohz_stop_idle() which is later than interrupt.

So if we have any site which call sched_clock() in interrupt on an
idle cpu, it could
get incorrect clock.

I'm not sure how to teach sched_clock() about this special case, Peter?

Thanks,
Yong

>
> let's take this one for example
>
> now: 511343524554       is the TSC on core 23
> gtod: 511500058415      tick_gtod we just updated with the delta of now and scd->tick_raw. Btw, delta is > 0 so we're incrementing fine.
> old_clock: 511500072734 what we returned on the previous sched_clock_cpu() above at tstamp 511.343381
> clock: 511500218644     is what we actually return
>
>
>           <...>-102   [023]   511.343528: sched_clock_cpu: clock: 511500218644
>          <idle>-0     [000]   511.343542: sched_clock_local: now: 511343540484, gtod: 511500210072, delta: 24574, old_clock: 511500215414, clock: 511500234646
>
>
> now, on cpu0 we've advanced in the meantime with now=511343540484 (btw,
> the now TSC values are almost the same as the ftrace timestamps, the
> last being taken only a couple of 盜 later) and so on ...
>
> So, I don't see anything unusual but I could very well be missing
> something. Btw, this trace is without your change to ttwu_queue().
>
> I'll do the same exercise on another F10h system once I get it free to
> see whether we see the same monotonicity there too.
>
> Let me know if you want something else traced or the trace tweaked.
>
>
>          <idle>-0     [000]   511.343543: sched_clock_cpu: clock: 511500234646
>           <...>-1549  [023]   511.343548: sched_clock_local: now: 511343546428, gtod: 511500058415, delta: 182103, old_clock: 511500218644, clock: 511500240518
>           <...>-1549  [023]   511.343549: sched_clock_cpu: clock: 511500240518
>          <idle>-0     [023]   511.343560: sched_clock_local: now: 511343558648, gtod: 511500058415, delta: 194323, old_clock: 511500240518, clock: 511500252738
>          <idle>-0     [023]   511.343561: sched_clock_cpu: clock: 511500252738
>          <idle>-0     [023]   511.347381: sched_clock_tick: gtod: 511504076961, now: 511347377038
>          <idle>-0     [000]   511.347386: sched_clock_tick: gtod: 511504078048, now: 511347378123
>          <idle>-0     [023]   511.347389: sched_clock_local: now: 511347383317, gtod: 511504076961, delta: 6279, old_clock: 511500252738, clock: 511504083240
>          <idle>-0     [000]   511.347392: sched_clock_local: now: 511347387920, gtod: 511504078048, delta: 9797, old_clock: 511500234646, clock: 511504087845
>          <idle>-0     [023]   511.347397: sched_clock_local: now: 511347395232, gtod: 511504076961, delta: 18194, old_clock: 511504083240, clock: 511504095155
>          <idle>-0     [000]   511.347399: sched_clock_local: now: 511347396131, gtod: 511504078048, delta: 18008, old_clock: 511504087845, clock: 511504096056
>          <idle>-0     [023]   511.347401: sched_clock_cpu: clock: 511504095155
>          <idle>-0     [000]   511.347402: sched_clock_cpu: clock: 511504096056
>          <idle>-0     [000]   511.473120: sched_clock_tick: gtod: 511630004325, now: 511473117198
>          <idle>-0     [000]   511.473124: sched_clock_local: now: 511473122126, gtod: 511630004325, delta: 4928, old_clock: 511504096056, clock: 511630009253
>          <idle>-0     [000]   511.473156: sched_clock_local: now: 511473154566, gtod: 511630004325, delta: 37368, old_clock: 511630009253, clock: 511630041693
>          <idle>-0     [000]   511.473157: sched_clock_cpu: clock: 511630041693
>           <...>-3889  [000]   511.473232: sched_clock_local: now: 511473229761, gtod: 511630004325, delta: 112563, old_clock: 511630041693, clock: 511630116888
>           <...>-3889  [000]   511.473233: sched_clock_cpu: clock: 511630116888
>           <...>-1226  [000]   511.473251: sched_clock_local: now: 511473249602, gtod: 511630004325, delta: 132404, old_clock: 511630116888, clock: 511630136729
>           <...>-1226  [000]   511.473252: sched_clock_cpu: clock: 511630136729
>          <idle>-0     [012]   511.473260: sched_clock_local: now: 511473255980, gtod: 511448077716, delta: 181793791, old_clock: 511448095543, clock: 511452077966
>          <idle>-0     [012]   511.473263: sched_clock_cpu: clock: 511452077966
>           <...>-3889  [000]   511.473266: sched_clock_local: now: 511473263744, gtod: 511630004325, delta: 146546, old_clock: 511630136729, clock: 511630150871
>           <...>-3889  [000]   511.473267: sched_clock_cpu: clock: 511630150871
>          <idle>-0     [012]   511.473271: sched_clock_tick: gtod: 511630157193, now: 511473269741
>          <idle>-0     [012]   511.473273: sched_clock_local: now: 511473271181, gtod: 511630157193, delta: 1440, old_clock: 511452077966, clock: 511630158633
>          <idle>-0     [000]   511.473280: sched_clock_local: now: 511473277552, gtod: 511630004325, delta: 160354, old_clock: 511630150871, clock: 511630164679
>          <idle>-0     [000]   511.473282: sched_clock_cpu: clock: 511630164679
>           <...>-3891  [012]   511.473355: sched_clock_local: now: 511473352521, gtod: 511630157193, delta: 82780, old_clock: 511630158633, clock: 511630239973
>           <...>-3891  [012]   511.473356: sched_clock_cpu: clock: 511630239973
>           <...>-1201  [012]   511.473375: sched_clock_local: now: 511473373553, gtod: 511630157193, delta: 103812, old_clock: 511630239973, clock: 511630261005
>           <...>-1201  [012]   511.473376: sched_clock_cpu: clock: 511630261005
>          <idle>-0     [000]   511.473380: sched_clock_local: now: 511473375569, gtod: 511630004325, delta: 258371, old_clock: 511630164679, clock: 511630262696
>          <idle>-0     [000]   511.473383: sched_clock_cpu: clock: 511630262696
>           <...>-3891  [012]   511.473387: sched_clock_local: now: 511473384172, gtod: 511630157193, delta: 114431, old_clock: 511630261005, clock: 511630271624
>           <...>-3891  [012]   511.473388: sched_clock_cpu: clock: 511630271624
>
>
> --
> Regards/Gruss,
> Boris.
>
> Advanced Micro Devices GmbH
> Einsteinring 24, 85609 Dornach
> General Managers: Alberto Bozzo, Andrew Bowd
> Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
> Registergericht Muenchen, HRB Nr. 43632
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Only stand for myself
