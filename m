Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757394Ab0KLVcA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 16:32:00 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:39150 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757228Ab0KLVb4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 16:31:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=IrCmS/hb1Mbw1AQ6S7TapQVuONw1GABH4Hlbnykf2VXGQ/y4hO8kNxUctjL+fdWilT
         APJZfk1HFro86VtUVK38eKjWV+1Q25BotokEPF2pVeEl2mYOOs7b14aThUv1ZU4AUhSp
         DnHMHhLwqdFKZqMW+veyOZlxEDjjuf4lcclOk=
MIME-Version: 1.0
In-Reply-To: <80b5a10ac1a6ef51afca3c113b624bf1b5049452.1289427381.git.luto@mit.edu>
References: <80b5a10ac1a6ef51afca3c113b624bf1b5049452.1289427381.git.luto@mit.edu>
Date: Fri, 12 Nov 2010 13:31:55 -0800
X-Google-Sender-Auth: 046tKH8O48T7xENPMQW3akeDzw4
Message-ID: <AANLkTi=s+0i36qd-bd3=MdeiJS-TThos9RmeUCsfHyy=@mail.gmail.com>
Subject: Re: [PATCH] Improve clocksource unstable warning
From: john stultz <johnstul@us.ibm.com>
To: Andy Lutomirski <luto@mit.edu>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        pc@us.ibm.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 2:16 PM, Andy Lutomirski <luto@mit.edu> wrote:
> When the system goes out to lunch for a long time, the clocksource
> watchdog might get false positives.  Clarify the warning so that
> people stop blaming their system freezes on the timing code.

So this issue has also crept up at times in the -rt kernel, where some
high priority rt tasks hogs the cpu long enough for the watchdog
clocksource to wrap, and then the TSC seems to have sped up relative
to the watchdog when the system returns to a normal state and causes a
false positive, so the TSC gets kicked out.

So the watchdog heuristic is rough, since it depends on three things:
1) The watchdog clocksource is actually trustworthy
2) The watchdog actually runs near to when it expects to run.
3) When reading the different clocksources, any interruptions when the
watchdog runs are small enough to to be handled by the allowed margin
of error.

And in these cases we're breaking #2

So I had a few  ideas  to improve the huristic somewhat (and huristic
refinement is always ugly). So first of all,  the whole reason for the
watchdog code is the TSC. Other platforms may want to make use of it,
but none do at this moment.

The majority of TSC issues are caused when the TSC halts in idle
(probably most common these days) or slows down due to cpufreq
scaling.

When we get these false positives, its because the watchdog check
interval is too long and the watchdog hardware has wrapped. This makes
it appear that the TSC is running too *fast*.  So we could try to be
more skeptical of watchdog failures where the TSC appears to have sped
up, rather then the more common real issue of it slowing down.

Now the actual positive where this could occur is if you were on an
old APM based laptop, and booted on battery power and the cpus started
at their slow freq. Then you plugged in the AC and the cpus jumped to
the faster rate. So while I suspect this is a rare case these days (on
ACPI based hardware the kernel has more say in cpufreq transitions, so
I believe we are unlikely to calculate tsc_khz while the cpus are in
low power mode), we still need to address this.

Ideas:
1) Maybe should we check that we get two sequential failures where the
cpu seems fast before we throw out the TSC? This will still fall over
in some stall cases (ie: a poor rt task hogging the cpu  for 10
minutes, pausing for a 10th of a second and then continuing to hog the
cpu).

2) We could look at the TSC delta, and if it appears outside the order
of 2-10x faster (i don't think any cpus scale up even close to 10x in
freq, but please correct me if so), then assume we just have been
blocked from running and don't throw out the TSC.

3) Similar to #2 we could look at the max interval that the watchdog
clocksource provides, and if the TSC delta is greater then that, avoid
throwing things out. This combined with #2 might narrow out the false
positives fairly well.

Any additional thoughts here?

thanks
-john
